Return-Path: <SRS0=+pcl=63=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF25C2D0F6
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 01:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3DA9206B7
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 01:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgEMBj4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 21:39:56 -0400
Received: from smtp.infotech.no ([82.134.31.41]:36284 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728228AbgEMBj4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 21:39:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id E598C204197;
        Wed, 13 May 2020 03:39:53 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MaYMqjpoDXlD; Wed, 13 May 2020 03:39:46 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 935D320417A;
        Wed, 13 May 2020 03:39:45 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     damien.lemoal@wdc.com, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] scsi_debug: parser tables and code interaction
Date:   Tue, 12 May 2020 21:39:43 -0400
Message-Id: <20200513013943.25285-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is in response to a static analyser report from Dan Carpenter
titled: "[bug report] scsi: scsi_debug: Add per_host_store option".
This code may not clear the static analyzer reports, but may shed light
on why they occur. Amongst other things this driver has a table driven
SCSI command parser which also involves some C code. There are some
invariants between the table entries and the corresponding C code (i.e.
the resp_*() functions) that, if broken, may lead to a NULL dereference.
And the report is valid, at least in the case of the PRE-FETCH command.
Alas, that is not one of the cases that the static analyzer reported.

In this particular corner case: when the fake_rw flag is set and the
table entry for a "store"-accessing command does not have the required
F_FAKE_RW flag set, do the following. Call BUG_ON() in the devip2sip()
very close to a comment block explaining why it was called and how to
fix it.  checkpatch.pl complains about the BUG_ON() but there is no
reasonable remedial action that can be taken at run time.

This change allows the code reported by the static analyzer to be
simplified. Comments were also added to the table flags (e.g.
F_FAKE_RW) so developers who add commands might be more inclined to
use them (properly).

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 115 +++++++++++++++++++++-----------------
 1 file changed, 64 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 60e84a1cdfac..66f00346dbd2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -61,7 +61,7 @@
 
 /* make sure inq_product_rev string corresponds to this version */
 #define SDEBUG_VERSION "0189"	/* format to fit INQUIRY revision field */
-static const char *sdebug_version_date = "20200507";
+static const char *sdebug_version_date = "20200512";
 
 #define MY_NAME "scsi_debug"
 
@@ -236,21 +236,23 @@ static const char *sdebug_version_date = "20200507";
 #define SDEBUG_CANQUEUE  (SDEBUG_CANQUEUE_WORDS * BITS_PER_LONG)
 #define DEF_CMD_PER_LUN  255
 
-#define F_D_IN			1
-#define F_D_OUT			2
+/* UA - Unit Attention; SA - Service Action; SSU - Start Stop Unit */
+#define F_D_IN			1	/* Data-in command (e.g. READ) */
+#define F_D_OUT			2	/* Data-out command (e.g. WRITE) */
 #define F_D_OUT_MAYBE		4	/* WRITE SAME, NDOB bit */
 #define F_D_UNKN		8
-#define F_RL_WLUN_OK		0x10
-#define F_SKIP_UA		0x20
-#define F_DELAY_OVERR		0x40
-#define F_SA_LOW		0x80	/* cdb byte 1, bits 4 to 0 */
-#define F_SA_HIGH		0x100	/* as used by variable length cdbs */
-#define F_INV_OP		0x200
-#define F_FAKE_RW		0x400
-#define F_M_ACCESS		0x800	/* media access */
-#define F_SSU_DELAY		0x1000
-#define F_SYNC_DELAY		0x2000
-
+#define F_RL_WLUN_OK		0x10	/* allowed with REPORT LUNS W-LUN */
+#define F_SKIP_UA		0x20	/* bypass UAs (e.g. INQUIRY command) */
+#define F_DELAY_OVERR		0x40	/* for commands like INQUIRY */
+#define F_SA_LOW		0x80	/* SA is in cdb byte 1, bits 4 to 0 */
+#define F_SA_HIGH		0x100	/* SA is in cdb bytes 8 and 9 */
+#define F_INV_OP		0x200	/* invalid opcode (not supported) */
+#define F_FAKE_RW		0x400	/* bypass resp_*() when fake_rw set */
+#define F_M_ACCESS		0x800	/* media access, reacts to SSU state */
+#define F_SSU_DELAY		0x1000	/* SSU command delay (long-ish) */
+#define F_SYNC_DELAY		0x2000	/* SYNCHRONIZE CACHE delay */
+
+/* Useful combinations of the above flags */
 #define FF_RESPOND (F_RL_WLUN_OK | F_SKIP_UA | F_DELAY_OVERR)
 #define FF_MEDIA_IO (F_M_ACCESS | F_FAKE_RW)
 #define FF_SA (F_SA_HIGH | F_SA_LOW)
@@ -607,25 +609,25 @@ static const struct opcode_info_t sync_cache_iarr[] = {
 };
 
 static const struct opcode_info_t pre_fetch_iarr[] = {
-	{0, 0x90, 0, F_SYNC_DELAY | F_M_ACCESS, resp_pre_fetch, NULL,
+	{0, 0x90, 0, F_SYNC_DELAY | FF_MEDIA_IO, resp_pre_fetch, NULL,
 	    {16,  0x2, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	     0xff, 0xff, 0xff, 0xff, 0x3f, 0xc7} },	/* PRE-FETCH (16) */
 };
 
 static const struct opcode_info_t zone_out_iarr[] = {	/* ZONE OUT(16) */
-	{0, 0x94, 0x1, F_SA_LOW, resp_close_zone, NULL,
+	{0, 0x94, 0x1, F_SA_LOW | F_M_ACCESS, resp_close_zone, NULL,
 	    {16, 0x1, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	     0xff, 0, 0, 0xff, 0xff, 0x1, 0xc7} },	/* CLOSE ZONE */
-	{0, 0x94, 0x2, F_SA_LOW, resp_finish_zone, NULL,
+	{0, 0x94, 0x2, F_SA_LOW | F_M_ACCESS, resp_finish_zone, NULL,
 	    {16, 0x2, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	     0xff, 0, 0, 0xff, 0xff, 0x1, 0xc7} },	/* FINISH ZONE */
-	{0, 0x94, 0x4, F_SA_LOW, resp_rwp_zone, NULL,
+	{0, 0x94, 0x4, F_SA_LOW | F_M_ACCESS, resp_rwp_zone, NULL,
 	    {16, 0x4, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	     0xff, 0, 0, 0xff, 0xff, 0x1, 0xc7} },  /* RESET WRITE POINTER */
 };
 
 static const struct opcode_info_t zone_in_iarr[] = {	/* ZONE IN(16) */
-	{0, 0x95, 0x6, F_SA_LOW | F_D_IN, NULL, NULL,
+	{0, 0x95, 0x6, F_SA_LOW | F_D_IN | F_M_ACCESS, NULL, NULL,
 	    {16, 0x6, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	     0xff, 0xff, 0xff, 0xff, 0x3f, 0xc7} }, /* REPORT ZONES */
 };
@@ -726,17 +728,17 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 	{0, 0x89, 0, F_D_OUT | FF_MEDIA_IO, resp_comp_write, NULL,
 	    {16,  0xf8, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0, 0,
 	     0, 0xff, 0x3f, 0xc7} },		/* COMPARE AND WRITE */
-	{ARRAY_SIZE(pre_fetch_iarr), 0x34, 0, F_SYNC_DELAY | F_M_ACCESS,
+	{ARRAY_SIZE(pre_fetch_iarr), 0x34, 0, F_SYNC_DELAY | FF_MEDIA_IO,
 	    resp_pre_fetch, pre_fetch_iarr,
 	    {10,  0x2, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
 	     0, 0, 0, 0} },			/* PRE-FETCH (10) */
 
 /* 30 */
-	{ARRAY_SIZE(zone_out_iarr), 0x94, 0x3, F_SA_LOW,
+	{ARRAY_SIZE(zone_out_iarr), 0x94, 0x3, F_SA_LOW | F_M_ACCESS,
 	    resp_open_zone, zone_out_iarr, /* ZONE_OUT(16), OPEN ZONE) */
 		{16,  0x3 /* SA */, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 		 0xff, 0xff, 0x0, 0x0, 0xff, 0xff, 0x1, 0xc7} },
-	{ARRAY_SIZE(zone_in_iarr), 0x95, 0x0, F_SA_LOW | F_D_IN,
+	{ARRAY_SIZE(zone_in_iarr), 0x95, 0x0, F_SA_LOW | F_M_ACCESS,
 	    resp_report_zones, zone_in_iarr, /* ZONE_IN(16), REPORT ZONES) */
 		{16,  0x0 /* SA */, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 		 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xbf, 0xc7} },
@@ -2873,10 +2875,20 @@ static inline int check_device_access_params
 	return 0;
 }
 
-static inline struct sdeb_store_info *devip2sip(struct sdebug_dev_info *devip)
+/*
+ * Note: if BUG_ON() fires it usually indicates a problem with the parser
+ * tables. Perhaps a missing F_FAKE_RW or FF_MEDIA_IO flag. Response functions
+ * that access any of the "stores" in struct sdeb_store_info should call this
+ * function with bug_if_fake_rw set to true.
+ */
+static inline struct sdeb_store_info *devip2sip(struct sdebug_dev_info *devip,
+						bool bug_if_fake_rw)
 {
-	return sdebug_fake_rw ?
-			NULL : xa_load(per_store_ap, devip->sdbg_host->si_idx);
+	if (sdebug_fake_rw) {
+		BUG_ON(bug_if_fake_rw);	/* See note above */
+		return NULL;
+	}
+	return xa_load(per_store_ap, devip->sdbg_host->si_idx);
 }
 
 /* Returns number of bytes copied or -1 if error. */
@@ -3013,7 +3025,7 @@ static void dif_copy_prot(struct scsi_cmnd *scp, sector_t sector,
 	size_t resid;
 	void *paddr;
 	struct sdeb_store_info *sip = devip2sip((struct sdebug_dev_info *)
-						scp->device->hostdata);
+						scp->device->hostdata, true);
 	struct t10_pi_tuple *dif_storep = sip->dif_storep;
 	const void *dif_store_end = dif_storep + sdebug_store_sectors;
 	struct sg_mapping_iter miter;
@@ -3059,7 +3071,7 @@ static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
 	unsigned int i;
 	sector_t sector;
 	struct sdeb_store_info *sip = devip2sip((struct sdebug_dev_info *)
-						scp->device->hostdata);
+						scp->device->hostdata, true);
 	struct t10_pi_tuple *sdt;
 
 	for (i = 0; i < sectors; i++, ei_lba++) {
@@ -3092,7 +3104,7 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u32 ei_lba;
 	int ret;
 	u64 lba;
-	struct sdeb_store_info *sip = devip2sip(devip);
+	struct sdeb_store_info *sip = devip2sip(devip, true);
 	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 	u8 *cmd = scp->cmnd;
 	struct sdebug_queued_cmd *sqcp;
@@ -3401,8 +3413,8 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u32 ei_lba;
 	int ret;
 	u64 lba;
-	struct sdeb_store_info *sip = devip2sip(devip);
-	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
+	struct sdeb_store_info *sip = devip2sip(devip, true);
+	rwlock_t *macc_lckp = &sip->macc_lck;
 	u8 *cmd = scp->cmnd;
 
 	switch (cmd[0]) {
@@ -3552,8 +3564,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	u8 *lrdp = NULL;
 	u8 *up;
-	struct sdeb_store_info *sip = devip2sip(devip);
-	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
+	struct sdeb_store_info *sip = devip2sip(devip, true);
+	rwlock_t *macc_lckp = &sip->macc_lck;
 	u8 wrprotect;
 	u16 lbdof, num_lrd, k;
 	u32 num, num_by, bt_len, lbdof_blen, sg_off, cum_lb;
@@ -3728,8 +3740,8 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	u32 lb_size = sdebug_sector_size;
 	int ret;
 	struct sdeb_store_info *sip = devip2sip((struct sdebug_dev_info *)
-						scp->device->hostdata);
-	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
+						scp->device->hostdata, true);
+	rwlock_t *macc_lckp = &sip->macc_lck;
 	u8 *fs1p;
 	u8 *fsp;
 
@@ -3902,8 +3914,8 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 {
 	u8 *cmd = scp->cmnd;
 	u8 *arr;
-	struct sdeb_store_info *sip = devip2sip(devip);
-	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
+	struct sdeb_store_info *sip = devip2sip(devip, true);
+	rwlock_t *macc_lckp = &sip->macc_lck;
 	u64 lba;
 	u32 dnum;
 	u32 lb_size = sdebug_sector_size;
@@ -3973,8 +3985,8 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	unsigned char *buf;
 	struct unmap_block_desc *desc;
-	struct sdeb_store_info *sip = devip2sip(devip);
-	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
+	struct sdeb_store_info *sip = devip2sip(devip, true);
+	rwlock_t *macc_lckp = &sip->macc_lck;
 	unsigned int i, payload_len, descriptors;
 	int ret;
 
@@ -4041,7 +4053,6 @@ static int resp_get_lba_status(struct scsi_cmnd *scp,
 			       struct sdebug_dev_info *devip)
 {
 	u8 *cmd = scp->cmnd;
-	struct sdeb_store_info *sip = devip2sip(devip);
 	u64 lba;
 	u32 alloc_len, mapped, num;
 	int ret;
@@ -4057,9 +4068,11 @@ static int resp_get_lba_status(struct scsi_cmnd *scp,
 	if (ret)
 		return ret;
 
-	if (scsi_debug_lbp())
+	if (scsi_debug_lbp()) {
+		struct sdeb_store_info *sip = devip2sip(devip, true);
+
 		mapped = map_state(sip, lba, &num);
-	else {
+	} else {
 		mapped = 1;
 		/* following just in case virtual_gb changed */
 		sdebug_capacity = get_sdebug_capacity();
@@ -4119,9 +4132,9 @@ static int resp_pre_fetch(struct scsi_cmnd *scp,
 	u64 block, rest = 0;
 	u32 nblks;
 	u8 *cmd = scp->cmnd;
-	struct sdeb_store_info *sip = devip2sip(devip);
-	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
-	u8 *fsp = sip ? sip->storep : NULL;
+	struct sdeb_store_info *sip = devip2sip(devip, true);
+	rwlock_t *macc_lckp = &sip->macc_lck;
+	u8 *fsp = sip->storep;
 
 	if (cmd[0] == PRE_FETCH) {	/* 10 byte cdb */
 		lba = get_unaligned_be32(cmd + 2);
@@ -4265,8 +4278,8 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u64 lba;
 	u8 *arr;
 	u8 *cmd = scp->cmnd;
-	struct sdeb_store_info *sip = devip2sip(devip);
-	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
+	struct sdeb_store_info *sip = devip2sip(devip, true);
+	rwlock_t *macc_lckp = &sip->macc_lck;
 
 	bytchk = (cmd[1] >> 1) & 0x3;
 	if (bytchk == 0) {
@@ -4344,7 +4357,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	u8 *arr = NULL, *desc;
 	u8 *cmd = scp->cmnd;
 	struct sdeb_zone_state *zsp;
-	struct sdeb_store_info *sip = devip2sip(devip);
+	struct sdeb_store_info *sip = devip2sip(devip, false);
 	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 
 	if (!sdebug_dev_is_zoned(devip)) {
@@ -4484,7 +4497,7 @@ static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u8 *cmd = scp->cmnd;
 	struct sdeb_zone_state *zsp;
 	bool all = cmd[14] & 0x01;
-	struct sdeb_store_info *sip = devip2sip(devip);
+	struct sdeb_store_info *sip = devip2sip(devip, false);
 	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 
 	if (!sdebug_dev_is_zoned(devip)) {
@@ -4563,7 +4576,7 @@ static int resp_close_zone(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	struct sdeb_zone_state *zsp;
 	bool all = cmd[14] & 0x01;
-	struct sdeb_store_info *sip = devip2sip(devip);
+	struct sdeb_store_info *sip = devip2sip(devip, false);
 	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 
 	if (!sdebug_dev_is_zoned(devip)) {
@@ -4636,7 +4649,7 @@ static int resp_finish_zone(struct scsi_cmnd *scp,
 	u64 z_id;
 	u8 *cmd = scp->cmnd;
 	bool all = cmd[14] & 0x01;
-	struct sdeb_store_info *sip = devip2sip(devip);
+	struct sdeb_store_info *sip = devip2sip(devip, false);
 	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 
 	if (!sdebug_dev_is_zoned(devip)) {
@@ -4712,7 +4725,7 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u64 z_id;
 	u8 *cmd = scp->cmnd;
 	bool all = cmd[14] & 0x01;
-	struct sdeb_store_info *sip = devip2sip(devip);
+	struct sdeb_store_info *sip = devip2sip(devip, false);
 	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 
 	if (!sdebug_dev_is_zoned(devip)) {
-- 
2.25.1

