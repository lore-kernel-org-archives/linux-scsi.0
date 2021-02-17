Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD7CC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 09:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11BC164E3E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 09:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhBQJRC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 04:17:02 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:54361 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbhBQJQb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 04:16:31 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210217091528epoutp039dbb1254e8504a19e6dfb3be5b646df2~kfjQpK_3X1016410164epoutp03U
        for <linux-scsi@vger.kernel.org>; Wed, 17 Feb 2021 09:15:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210217091528epoutp039dbb1254e8504a19e6dfb3be5b646df2~kfjQpK_3X1016410164epoutp03U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1613553329;
        bh=rP4xw17YxOKl7mDL1soKfZ+FVUk/CGUKjOGNi1zuUCk=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=FTDAL5/EtCPAWN0gxWxVLQjBR/7BCL9HQQzTtpd1V8yb+G0wot6m87RuopX+Vbgyq
         EDv8fXrF7dT2ESC/sHi41n57xPKisWQs+gp8MvJ1ViQzAIOMKXaHC3gYH80w8/U9jW
         YZzb/TKyNgkVNuSIqdU0BlP6Tb46UX6hc5pJ967w=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210217091521epcas2p3ced511cb0cd2bd1c94ccc6a38c1b8352~kfjJgFGK00463404634epcas2p36;
        Wed, 17 Feb 2021 09:15:21 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.187]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DgXHW16vTz4x9Px; Wed, 17 Feb
        2021 09:15:19 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-e5-602cdea6580b
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        4E.DC.05262.6AEDC206; Wed, 17 Feb 2021 18:15:18 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v20 4/4] scsi: ufs: Add HPB 2.0 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210217090853epcms2p17db2903a3a0c1a13e4ee071b9a39dbc8@epcms2p1>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210217091517epcms2p1a5ff04e9c1fff2641e7914032c5fa5e7@epcms2p1>
Date:   Wed, 17 Feb 2021 18:15:17 +0900
X-CMS-MailID: 20210217091517epcms2p1a5ff04e9c1fff2641e7914032c5fa5e7
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsWy7bCmme7yezoJBvf0LB7M28ZmsbftBLvF
        y59X2SwO337HbjHtw09mi0/rl7FavDykabHqQbhF8+L1bBZzzjYwWfT2b2WzeHznM7vFohvb
        mCz6/7WzWFzeNYfNovv6DjaL5cf/MVnc3sJlsXTrTUaLzulrWCwWLdzN4iDqcfmKt8flvl4m
        j52z7rJ7TFh0gNFj/9w17B4tJ/ezeHx8eovFo2/LKkaPz5vkPNoPdDMFcEXl2GSkJqakFimk
        5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAPaikUJaYUwoUCkgsLlbS
        t7Mpyi8tSVXIyC8usVVKLUjJKTA0LNArTswtLs1L10vOz7UyNDAwMgWqTMjJuDr/CEvBlBeM
        FTOW/mZuYFy8l7GLkYNDQsBEYutsuS5GTg4hgR2MEi2vVUDCvAKCEn93CIOEhQXMJb6evcsO
        UaIksf7iLHaIuJ7ErYdrGEFsNgEdiekn7gPFuThEBDaxSNxb0MEK4jAL/GKSOPH4A1iVhACv
        xIz2pywQtrTE9uVbweKcAn4SH7f9hKrRkPixrJcZwhaVuLn6LTuM/f7YfKgaEYnWe2ehagQl
        HvzcDRWXlDi2+wMThF0vsfXOL0aQIyQEehglDu+8xQqR0Je41rER7AheAV+JPc+OsIHYLAKq
        Eh+vHIA6zkXi3qLHYAuYBeQltr+dwwwKFWYBTYn1u/Qh4aYsceQWC8xbDRt/s6OzmQX4JDoO
        /4WL75j3BOo0NYl1P9czTWBUnoUI6llIds1C2LWAkXkVo1hqQXFuemqxUYExcuxuYgSndi33
        HYwz3n7QO8TIxMF4iFGCg1lJhJf9s1aCEG9KYmVValF+fFFpTmrxIUZToC8nMkuJJucDs0te
        SbyhqZGZmYGlqYWpmZGFkjhvscGDeCGB9MSS1OzU1ILUIpg+Jg5OqQamtsVThCu2LF8nn8p7
        SF7x0ETlZ8vr9af/Ufj5UE5+rzrv/EVPGzIn5lwwzjX4/Uuq/t9VuYLoiju1KpdTo0Venduh
        lLz7bs2GfSkXTp2ew3PFJs/2xUa1PgfRXva9B6oenIlZ82v/TtF4Gd3q+4IRa7Y7hVxwVvqt
        IpsvxHa/fPdUj698BznllnAUrvpVvkm/cnXdqg1rOpdOqtbhku2xvCh9XPq48tlJexI87vmK
        +9/dEeyVZnnt/5l9HUlfEz8a2GjpP1TNOvNZZlZMn5lR85z37hMYjl3P2yGxcdPunV+3Xr7K
        eaSiMH0xq4exEIt91PYI/eI1tZquG2bGc7rfXvM9wOka66e4xQotn1imKLEUZyQaajEXFScC
        AN4B7Kp2BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210217090853epcms2p17db2903a3a0c1a13e4ee071b9a39dbc8
References: <20210217090853epcms2p17db2903a3a0c1a13e4ee071b9a39dbc8@epcms2p1>
        <CGME20210217090853epcms2p17db2903a3a0c1a13e4ee071b9a39dbc8@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch supports the HPB 2.0.

The HPB 2.0 supports read of varying sizes from 4KB to 512KB.
In the case of Read (<= 32KB) is supported as single HPB read.
In the case of Read (36KB ~ 512KB) is supported by as a combination of
write buffer command and HPB read command to deliver more PPN.
The write buffer commands may not be issued immediately due to busy tags.
To use HPB read more aggressively, the driver can requeue the write buffer
command. The requeue threshold is implemented as timeout and can be
modified with requeue_timeout_ms entry in sysfs.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  19 +-
 drivers/scsi/ufs/ufshcd.c                  |   8 +-
 drivers/scsi/ufs/ufshpb.c                  | 499 +++++++++++++++++++--
 drivers/scsi/ufs/ufshpb.h                  |  61 ++-
 4 files changed, 534 insertions(+), 53 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index bf5cb8846de1..239fe741a7f6 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1253,14 +1253,14 @@ Description:	This entry shows the number of HPB pinned regions assigned to
 
 		The file is read only.
 
-What:		/sys/class/scsi_device/*/device/hpb_sysfs/hit_cnt
+What:		/sys/class/scsi_device/*/device/hpb_stat_sysfs/hit_cnt
 Date:		February 2021
 Contact:	Daejun Park <daejun7.park@samsung.com>
 Description:	This entry shows the number of reads that changed to HPB read.
 
 		The file is read only.
 
-What:		/sys/class/scsi_device/*/device/hpb_sysfs/miss_cnt
+What:		/sys/class/scsi_device/*/device/hpb_stat_sysfs/miss_cnt
 Date:		February 2021
 Contact:	Daejun Park <daejun7.park@samsung.com>
 Description:	This entry shows the number of reads that cannot be changed to
@@ -1268,7 +1268,7 @@ Description:	This entry shows the number of reads that cannot be changed to
 
 		The file is read only.
 
-What:		/sys/class/scsi_device/*/device/hpb_sysfs/rb_noti_cnt
+What:		/sys/class/scsi_device/*/device/hpb_stat_sysfs/rb_noti_cnt
 Date:		February 2021
 Contact:	Daejun Park <daejun7.park@samsung.com>
 Description:	This entry shows the number of response UPIUs that has
@@ -1276,7 +1276,7 @@ Description:	This entry shows the number of response UPIUs that has
 
 		The file is read only.
 
-What:		/sys/class/scsi_device/*/device/hpb_sysfs/rb_active_cnt
+What:		/sys/class/scsi_device/*/device/hpb_stat_sysfs/rb_active_cnt
 Date:		February 2021
 Contact:	Daejun Park <daejun7.park@samsung.com>
 Description:	This entry shows the number of active sub-regions recommended by
@@ -1284,7 +1284,7 @@ Description:	This entry shows the number of active sub-regions recommended by
 
 		The file is read only.
 
-What:		/sys/class/scsi_device/*/device/hpb_sysfs/rb_inactive_cnt
+What:		/sys/class/scsi_device/*/device/hpb_stat_sysfs/rb_inactive_cnt
 Date:		February 2021
 Contact:	Daejun Park <daejun7.park@samsung.com>
 Description:	This entry shows the number of inactive regions recommended by
@@ -1292,10 +1292,17 @@ Description:	This entry shows the number of inactive regions recommended by
 
 		The file is read only.
 
-What:		/sys/class/scsi_device/*/device/hpb_sysfs/map_req_cnt
+What:		/sys/class/scsi_device/*/device/hpb_stat_sysfs/map_req_cnt
 Date:		February 2021
 Contact:	Daejun Park <daejun7.park@samsung.com>
 Description:	This entry shows the number of read buffer commands for
 		activating sub-regions recommended by response UPIUs.
 
 		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/requeue_timeout_ms
+Date:		February 2021
+Contact:	Daejun Park <daejun7.park@samsung.com>
+Description:	This entry shows the requeue timeout threshold for write buffer
+		command in ms. This value can be changed by writing proper integer to
+		this entry.
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 851c01a26207..9881267eebc1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2656,7 +2656,12 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	lrbp->req_abort_skip = false;
 
-	ufshpb_prep(hba, lrbp);
+	err = ufshpb_prep(hba, lrbp);
+	if (err == -EAGAIN) {
+		lrbp->cmd = NULL;
+		ufshcd_release(hba);
+		goto out;
+	}
 
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
@@ -8019,6 +8024,7 @@ static const struct attribute_group *ufshcd_driver_groups[] = {
 	&ufs_sysfs_lun_attributes_group,
 #ifdef CONFIG_SCSI_UFS_HPB
 	&ufs_sysfs_hpb_stat_group,
+	&ufs_sysfs_hpb_param_group,
 #endif
 	NULL,
 };
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 937327180dda..312b5aede0c7 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -54,13 +54,22 @@ static bool ufshpb_is_support_chunk(int transfer_len)
 	return transfer_len <= HPB_MULTI_CHUNK_HIGH;
 }
 
+/*
+ * WRITE_BUFFER CMD support 36K (len=9) ~ 512K (len=128) default.
+ * it is possible to change range of transfer_len through sysfs.
+ */
+static inline bool ufshpb_is_required_wb(struct ufshpb_lu *hpb, int len)
+{
+	return (len >= hpb->pre_req_min_tr_len &&
+		len <= hpb->pre_req_max_tr_len);
+}
+
 static bool ufshpb_is_general_lun(int lun)
 {
 	return lun < UFS_UPIU_MAX_UNIT_NUM_ID;
 }
 
-static bool
-ufshpb_is_pinned_region(struct ufshpb_lu *hpb, int rgn_idx)
+static bool ufshpb_is_pinned_region(struct ufshpb_lu *hpb, int rgn_idx)
 {
 	if (hpb->lu_pinned_end != PINNED_NOT_SET &&
 	    rgn_idx >= hpb->lu_pinned_start &&
@@ -213,6 +222,35 @@ static bool ufshpb_test_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
 	return false;
 }
 
+static int ufshpb_fill_ppn_from_page(struct ufshpb_lu *hpb,
+			  struct ufshpb_map_ctx *mctx, int pos, int len,
+			  u64 *ppn_buf)
+{
+	struct page *page;
+	int index, offset;
+	int copied;
+
+	index = pos / (PAGE_SIZE / HPB_ENTRY_SIZE);
+	offset = pos % (PAGE_SIZE / HPB_ENTRY_SIZE);
+
+	if ((offset + len) <= (PAGE_SIZE / HPB_ENTRY_SIZE))
+		copied = len;
+	else
+		copied = (PAGE_SIZE / HPB_ENTRY_SIZE) - offset;
+
+	page = mctx->m_page[index];
+	if (unlikely(!page)) {
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+			"error. cannot find page in mctx\n");
+		return -ENOMEM;
+	}
+
+	memcpy(ppn_buf, page_address(page) + (offset * HPB_ENTRY_SIZE),
+	       copied * HPB_ENTRY_SIZE);
+
+	return copied;
+}
+
 static u64 ufshpb_get_ppn(struct ufshpb_lu *hpb,
 			  struct ufshpb_map_ctx *mctx, int pos, int *error)
 {
@@ -256,7 +294,8 @@ ufshpb_get_pos_from_lpn(struct ufshpb_lu *hpb, unsigned long lpn, int *rgn_idx,
 
 static void
 ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb *lrbp,
-				  u32 lpn, u64 ppn,  unsigned int transfer_len)
+			    u32 lpn, u64 ppn,  unsigned int transfer_len,
+			    int read_id)
 {
 	unsigned char *cdb = lrbp->cmd->cmnd;
 
@@ -265,15 +304,269 @@ ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb *lrbp,
 	/* ppn value is stored as big-endian in the host memory */
 	put_unaligned(ppn, (u64 *)&cdb[6]);
 	cdb[14] = transfer_len;
+	cdb[15] = read_id;
 
 	lrbp->cmd->cmd_len = UFS_CDB_SIZE;
 }
 
+static inline void ufshpb_set_write_buf_cmd(unsigned char *cdb,
+					    unsigned long lpn, unsigned int len,
+					    int read_id)
+{
+	cdb[0] = UFSHPB_WRITE_BUFFER;
+	cdb[1] = UFSHPB_WRITE_BUFFER_PREFETCH_ID;
+
+	put_unaligned_be32(lpn, &cdb[2]);
+	cdb[6] = read_id;
+	put_unaligned_be16(len * HPB_ENTRY_SIZE, &cdb[7]);
+
+	cdb[9] = 0x00;	/* Control = 0x00 */
+}
+
+static struct ufshpb_req *ufshpb_get_pre_req(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_req *pre_req;
+
+	if (hpb->num_inflight_pre_req >= hpb->throttle_pre_req) {
+		dev_info(&hpb->sdev_ufs_lu->sdev_dev,
+			 "pre_req throttle. inflight %d throttle %d",
+			 hpb->num_inflight_pre_req, hpb->throttle_pre_req);
+		return NULL;
+	}
+
+	pre_req = list_first_entry_or_null(&hpb->lh_pre_req_free,
+					   struct ufshpb_req, list_req);
+	if (!pre_req) {
+		dev_info(&hpb->sdev_ufs_lu->sdev_dev, "There is no pre_req");
+		return NULL;
+	}
+
+	list_del_init(&pre_req->list_req);
+	hpb->num_inflight_pre_req++;
+
+	return pre_req;
+}
+
+static inline void ufshpb_put_pre_req(struct ufshpb_lu *hpb,
+				      struct ufshpb_req *pre_req)
+{
+	pre_req->req = NULL;
+	pre_req->bio = NULL;
+	list_add_tail(&pre_req->list_req, &hpb->lh_pre_req_free);
+	hpb->num_inflight_pre_req--;
+}
+
+static void ufshpb_pre_req_compl_fn(struct request *req, blk_status_t error)
+{
+	struct ufshpb_req *pre_req = (struct ufshpb_req *)req->end_io_data;
+	struct ufshpb_lu *hpb = pre_req->hpb;
+	unsigned long flags;
+	struct scsi_sense_hdr sshdr;
+
+	if (error) {
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev, "block status %d", error);
+		scsi_normalize_sense(pre_req->sense, SCSI_SENSE_BUFFERSIZE,
+				     &sshdr);
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+			"code %x sense_key %x asc %x ascq %x",
+			sshdr.response_code,
+			sshdr.sense_key, sshdr.asc, sshdr.ascq);
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+			"byte4 %x byte5 %x byte6 %x additional_len %x",
+			sshdr.byte4, sshdr.byte5,
+			sshdr.byte6, sshdr.additional_length);
+	}
+
+	bio_put(pre_req->bio);
+	blk_mq_free_request(req);
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+	ufshpb_put_pre_req(pre_req->hpb, pre_req);
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+}
+
+static int ufshpb_prep_entry(struct ufshpb_req *pre_req, struct page *page)
+{
+	struct ufshpb_lu *hpb = pre_req->hpb;
+	struct ufshpb_region *rgn;
+	struct ufshpb_subregion *srgn;
+	u64 *addr;
+	int offset = 0;
+	int copied;
+	unsigned long lpn = pre_req->wb.lpn;
+	int rgn_idx, srgn_idx, srgn_offset;
+	unsigned long flags;
+
+	addr = page_address(page);
+	ufshpb_get_pos_from_lpn(hpb, lpn, &rgn_idx, &srgn_idx, &srgn_offset);
+
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+
+next_offset:
+	rgn = hpb->rgn_tbl + rgn_idx;
+	srgn = rgn->srgn_tbl + srgn_idx;
+
+	if (!ufshpb_is_valid_srgn(rgn, srgn))
+		goto mctx_error;
+
+	if (!srgn->mctx)
+		goto mctx_error;
+
+	copied = ufshpb_fill_ppn_from_page(hpb, srgn->mctx, srgn_offset,
+					   pre_req->wb.len - offset,
+					   &addr[offset]);
+
+	if (copied < 0)
+		goto mctx_error;
+
+	offset += copied;
+	srgn_offset += offset;
+
+	if (srgn_offset == hpb->entries_per_srgn) {
+		srgn_offset = 0;
+
+		if (++srgn_idx == hpb->srgns_per_rgn) {
+			srgn_idx = 0;
+			rgn_idx++;
+		}
+	}
+
+	if (offset < pre_req->wb.len)
+		goto next_offset;
+
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+	return 0;
+mctx_error:
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+	return -ENOMEM;
+}
+
+static int ufshpb_pre_req_add_bio_page(struct ufshpb_lu *hpb,
+				       struct request_queue *q,
+				       struct ufshpb_req *pre_req)
+{
+	struct page *page = pre_req->wb.m_page;
+	struct bio *bio = pre_req->bio;
+	int entries_bytes, ret;
+
+	if (!page)
+		return -ENOMEM;
+
+	if (ufshpb_prep_entry(pre_req, page))
+		return -ENOMEM;
+
+	entries_bytes = pre_req->wb.len * sizeof(u64);
+
+	ret = bio_add_pc_page(q, bio, page, entries_bytes, 0);
+	if (ret != entries_bytes) {
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+			"bio_add_pc_page fail: %d", ret);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static inline int ufshpb_get_read_id(struct ufshpb_lu *hpb)
+{
+	if (++hpb->cur_read_id >= MAX_HPB_READ_ID)
+		hpb->cur_read_id = 0;
+	return hpb->cur_read_id;
+}
+
+static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
+				  struct ufshpb_req *pre_req, int read_id)
+{
+	struct scsi_device *sdev = cmd->device;
+	struct request_queue *q = sdev->request_queue;
+	struct request *req;
+	struct scsi_request *rq;
+	struct bio *bio = pre_req->bio;
+
+	pre_req->hpb = hpb;
+	pre_req->wb.lpn = sectors_to_logical(cmd->device,
+					     blk_rq_pos(cmd->request));
+	pre_req->wb.len = sectors_to_logical(cmd->device,
+					     blk_rq_sectors(cmd->request));
+	if (ufshpb_pre_req_add_bio_page(hpb, q, pre_req))
+		return -ENOMEM;
+
+	req = pre_req->req;
+
+	/* 1. request setup */
+	blk_rq_append_bio(req, &bio);
+	req->rq_disk = NULL;
+	req->end_io_data = (void *)pre_req;
+	req->end_io = ufshpb_pre_req_compl_fn;
+
+	/* 2. scsi_request setup */
+	rq = scsi_req(req);
+	rq->retries = 1;
+
+	ufshpb_set_write_buf_cmd(rq->cmd, pre_req->wb.lpn, pre_req->wb.len,
+				 read_id);
+	rq->cmd_len = scsi_command_size(rq->cmd);
+
+	if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
+		return -EAGAIN;
+
+	hpb->stats.pre_req_cnt++;
+
+	return 0;
+}
+
+static int ufshpb_issue_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
+				int *read_id)
+{
+	struct ufshpb_req *pre_req;
+	struct request *req = NULL;
+	struct bio *bio = NULL;
+	unsigned long flags;
+	int _read_id;
+	int ret = 0;
+
+	req = blk_get_request(cmd->device->request_queue,
+			      REQ_OP_SCSI_OUT | REQ_SYNC, BLK_MQ_REQ_NOWAIT);
+	if (IS_ERR(req))
+		return -EAGAIN;
+
+	bio = bio_alloc(GFP_ATOMIC, 1);
+	if (!bio) {
+		blk_put_request(req);
+		return -EAGAIN;
+	}
+
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+	pre_req = ufshpb_get_pre_req(hpb);
+	if (!pre_req) {
+		ret = -EAGAIN;
+		goto unlock_out;
+	}
+	_read_id = ufshpb_get_read_id(hpb);
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+
+	pre_req->req = req;
+	pre_req->bio = bio;
+
+	ret = ufshpb_execute_pre_req(hpb, cmd, pre_req, _read_id);
+	if (ret)
+		goto free_pre_req;
+
+	*read_id = _read_id;
+
+	return ret;
+free_pre_req:
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+	ufshpb_put_pre_req(hpb, pre_req);
+unlock_out:
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+	bio_put(bio);
+	blk_put_request(req);
+	return ret;
+}
+
 /*
  * This function will set up HPB read command using host-side L2P map data.
- * In HPB v1.0, maximum size of HPB read command is 4KB.
  */
-void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
 	struct ufshpb_lu *hpb;
 	struct ufshpb_region *rgn;
@@ -283,25 +576,27 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	u64 ppn;
 	unsigned long flags;
 	int transfer_len, rgn_idx, srgn_idx, srgn_offset;
+	int read_id = MAX_HPB_READ_ID;
 	int err = 0;
 
 	hpb = ufshpb_get_hpb_data(cmd->device);
 	if (!hpb)
-		return;
+		return -ENODEV;
 
 	if (ufshpb_get_state(hpb) != HPB_PRESENT) {
 		dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
 			   "%s: ufshpb state is not PRESENT", __func__);
-		return;
+		return -ENODEV;
 	}
 
 	if (!ufshpb_is_write_or_discard_cmd(cmd) &&
 	    !ufshpb_is_read_cmd(cmd))
-		return;
+		return 0;
 
-	transfer_len = sectors_to_logical(cmd->device, blk_rq_sectors(cmd->request));
+	transfer_len = sectors_to_logical(cmd->device,
+					  blk_rq_sectors(cmd->request));
 	if (unlikely(!transfer_len))
-		return;
+		return 0;
 
 	lpn = sectors_to_logical(cmd->device, blk_rq_pos(cmd->request));
 	ufshpb_get_pos_from_lpn(hpb, lpn, &rgn_idx, &srgn_idx, &srgn_offset);
@@ -314,18 +609,18 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
 				 transfer_len);
 		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
-		return;
+		return 0;
 	}
 
 	if (!ufshpb_is_support_chunk(transfer_len))
-		return;
+		return 0;
 
 	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
 	if (ufshpb_test_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
 				   transfer_len)) {
 		hpb->stats.miss_cnt++;
 		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
-		return;
+		return 0;
 	}
 
 	ppn = ufshpb_get_ppn(hpb, srgn->mctx, srgn_offset, &err);
@@ -339,12 +634,29 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		 */
 		WARN_ON(true);
 		dev_err(hba->dev, "ufshpb_get_ppn failed. err %d\n", err);
-		return;
+		return err;
+	}
+
+	if (ufshpb_is_required_wb(hpb, transfer_len)) {
+		err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
+		if (err) {
+			unsigned long timeout;
+
+			timeout = cmd->jiffies_at_alloc + msecs_to_jiffies(
+				  hpb->params.requeue_timeout_ms);
+
+			if (time_before(jiffies, timeout))
+				return -EAGAIN;
+
+			hpb->stats.miss_cnt++;
+			return 0;
+		}
 	}
 
-	ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len);
+	ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len, read_id);
 
 	hpb->stats.hit_cnt++;
+	return 0;
 }
 
 static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
@@ -381,9 +693,9 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 	map_req->req = req;
 	map_req->bio = bio;
 
-	map_req->rgn_idx = srgn->rgn_idx;
-	map_req->srgn_idx = srgn->srgn_idx;
-	map_req->mctx = srgn->mctx;
+	map_req->rb.rgn_idx = srgn->rgn_idx;
+	map_req->rb.srgn_idx = srgn->srgn_idx;
+	map_req->rb.mctx = srgn->mctx;
 
 	return map_req;
 
@@ -476,8 +788,8 @@ static void ufshpb_map_req_compl_fn(struct request *req, blk_status_t error)
 	struct ufshpb_subregion *srgn;
 	unsigned long flags;
 
-	srgn = hpb->rgn_tbl[map_req->rgn_idx].srgn_tbl +
-		map_req->srgn_idx;
+	srgn = hpb->rgn_tbl[map_req->rb.rgn_idx].srgn_tbl +
+		map_req->rb.srgn_idx;
 
 	ufshpb_clear_dirty_bitmap(hpb, srgn);
 	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
@@ -512,12 +824,12 @@ static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
 
 	q = hpb->sdev_ufs_lu->request_queue;
 	for (i = 0; i < hpb->pages_per_srgn; i++) {
-		ret = bio_add_pc_page(q, map_req->bio, map_req->mctx->m_page[i],
+		ret = bio_add_pc_page(q, map_req->bio, map_req->rb.mctx->m_page[i],
 				      PAGE_SIZE, 0);
 		if (ret != PAGE_SIZE) {
 			dev_err(&hpb->sdev_ufs_lu->sdev_dev,
 				   "bio_add_pc_page fail %d - %d\n",
-				   map_req->rgn_idx, map_req->srgn_idx);
+				   map_req->rb.rgn_idx, map_req->rb.srgn_idx);
 			return ret;
 		}
 	}
@@ -533,8 +845,8 @@ static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
 	if (unlikely(last))
 		mem_size = hpb->last_srgn_entries * HPB_ENTRY_SIZE;
 
-	ufshpb_set_read_buf_cmd(rq->cmd, map_req->rgn_idx,
-				map_req->srgn_idx, mem_size);
+	ufshpb_set_read_buf_cmd(rq->cmd, map_req->rb.rgn_idx,
+				map_req->rb.srgn_idx, hpb->srgn_mem_size);
 	rq->cmd_len = HPB_READ_BUFFER_CMD_LENGTH;
 
 	blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_map_req_compl_fn);
@@ -1165,6 +1477,11 @@ static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
 	u32 entries_per_rgn;
 	u64 rgn_mem_size, tmp;
 
+	/* for pre_req */
+	hpb->pre_req_min_tr_len = HPB_MULTI_CHUNK_LOW;
+	hpb->pre_req_max_tr_len = HPB_MULTI_CHUNK_HIGH;
+	hpb->cur_read_id = 0;
+
 	hpb->lu_pinned_start = hpb_lu_info->pinned_start;
 	hpb->lu_pinned_end = hpb_lu_info->num_pinned ?
 		(hpb_lu_info->pinned_start + hpb_lu_info->num_pinned - 1)
@@ -1312,7 +1629,7 @@ ufshpb_sysfs_attr_show_func(rb_active_cnt);
 ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
 ufshpb_sysfs_attr_show_func(map_req_cnt);
 
-static struct attribute *hpb_dev_attrs[] = {
+static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_hit_cnt.attr,
 	&dev_attr_miss_cnt.attr,
 	&dev_attr_rb_noti_cnt.attr,
@@ -1323,10 +1640,108 @@ static struct attribute *hpb_dev_attrs[] = {
 };
 
 struct attribute_group ufs_sysfs_hpb_stat_group = {
-	.name = "hpb_sysfs",
-	.attrs = hpb_dev_attrs,
+	.name = "hpb_stat_sysfs",
+	.attrs = hpb_dev_stat_attrs,
+};
+
+/* SYSFS functions */
+#define ufshpb_sysfs_param_show_func(__name)				\
+static ssize_t __name##_show(struct device *dev,			\
+	struct device_attribute *attr, char *buf)			\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);		\
+	if (!hpb)							\
+		return -ENODEV;						\
+									\
+	return sysfs_emit(buf, "%d\n", hpb->params.__name);		\
+}
+
+ufshpb_sysfs_param_show_func(requeue_timeout_ms);
+static ssize_t
+requeue_timeout_ms_store(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);
+	int val;
+
+	if (!hpb)
+		return -ENODEV;
+
+	if (kstrtouint(buf, 0, &val))
+		return -EINVAL;
+
+	if (val <= 0)
+		return -EINVAL;
+
+	hpb->params.requeue_timeout_ms = val;
+
+	return count;
+}
+static DEVICE_ATTR_RW(requeue_timeout_ms);
+
+static struct attribute *hpb_dev_param_attrs[] = {
+	&dev_attr_requeue_timeout_ms.attr,
 };
 
+struct attribute_group ufs_sysfs_hpb_param_group = {
+	.name = "hpb_param_sysfs",
+	.attrs = hpb_dev_param_attrs,
+};
+
+static int ufshpb_pre_req_mempool_init(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_req *pre_req = NULL;
+	int qd = hpb->sdev_ufs_lu->queue_depth;
+	int i, j;
+
+	INIT_LIST_HEAD(&hpb->lh_pre_req_free);
+
+	hpb->pre_req = kcalloc(qd, sizeof(struct ufshpb_req), GFP_KERNEL);
+	hpb->throttle_pre_req = qd;
+	hpb->num_inflight_pre_req = 0;
+
+	if (!hpb->pre_req)
+		goto release_mem;
+
+	for (i = 0; i < qd; i++) {
+		pre_req = hpb->pre_req + i;
+		INIT_LIST_HEAD(&pre_req->list_req);
+		pre_req->req = NULL;
+		pre_req->bio = NULL;
+
+		pre_req->wb.m_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!pre_req->wb.m_page) {
+			for (j = 0; j < i; j++)
+				__free_page(hpb->pre_req[j].wb.m_page);
+
+			goto release_mem;
+		}
+		list_add_tail(&pre_req->list_req, &hpb->lh_pre_req_free);
+	}
+
+	return 0;
+release_mem:
+	kfree(hpb->pre_req);
+	return -ENOMEM;
+}
+
+static void ufshpb_pre_req_mempool_destroy(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_req *pre_req = NULL;
+	int i;
+
+	for (i = 0; i < hpb->throttle_pre_req; i++) {
+		pre_req = hpb->pre_req + i;
+		if (!pre_req->wb.m_page)
+			__free_page(hpb->pre_req[i].wb.m_page);
+		list_del_init(&pre_req->list_req);
+	}
+
+	kfree(hpb->pre_req);
+}
+
 static void ufshpb_stat_init(struct ufshpb_lu *hpb)
 {
 	hpb->stats.hit_cnt = 0;
@@ -1337,6 +1752,11 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
 	hpb->stats.map_req_cnt = 0;
 }
 
+static void ufshpb_param_init(struct ufshpb_lu *hpb)
+{
+	hpb->params.requeue_timeout_ms = HPB_REQUEUE_TIME_MS;
+}
+
 static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 {
 	int ret;
@@ -1369,14 +1789,24 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		goto release_req_cache;
 	}
 
+	ret = ufshpb_pre_req_mempool_init(hpb);
+	if (ret) {
+		dev_err(hba->dev, "ufshpb(%d) pre_req_mempool init fail",
+			hpb->lun);
+		goto release_m_page_cache;
+	}
+
 	ret = ufshpb_alloc_region_tbl(hba, hpb);
 	if (ret)
-		goto release_m_page_cache;
+		goto release_pre_req_mempool;
 
 	ufshpb_stat_init(hpb);
+	ufshpb_param_init(hpb);
 
 	return 0;
 
+release_pre_req_mempool:
+	ufshpb_pre_req_mempool_destroy(hpb);
 release_m_page_cache:
 	kmem_cache_destroy(hpb->m_page_cache);
 release_req_cache:
@@ -1384,7 +1814,8 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	return ret;
 }
 
-static struct ufshpb_lu *ufshpb_alloc_hpb_lu(struct ufs_hba *hba, int lun,
+static struct ufshpb_lu *ufshpb_alloc_hpb_lu(struct ufs_hba *hba,
+				     struct scsi_device *sdev,
 				     struct ufshpb_dev_info *hpb_dev_info,
 				     struct ufshpb_lu_info *hpb_lu_info)
 {
@@ -1395,7 +1826,8 @@ static struct ufshpb_lu *ufshpb_alloc_hpb_lu(struct ufs_hba *hba, int lun,
 	if (!hpb)
 		return NULL;
 
-	hpb->lun = lun;
+	hpb->lun = sdev->lun;
+	hpb->sdev_ufs_lu = sdev;
 
 	ufshpb_lu_parameter_init(hba, hpb, hpb_dev_info, hpb_lu_info);
 
@@ -1405,6 +1837,7 @@ static struct ufshpb_lu *ufshpb_alloc_hpb_lu(struct ufs_hba *hba, int lun,
 		goto release_hpb;
 	}
 
+	sdev->hostdata = hpb;
 	return hpb;
 
 release_hpb:
@@ -1607,6 +2040,7 @@ void ufshpb_destroy_lu(struct ufs_hba *hba, struct scsi_device *sdev)
 
 	ufshpb_cancel_jobs(hpb);
 
+	ufshpb_pre_req_mempool_destroy(hpb);
 	ufshpb_destroy_region_tbl(hpb);
 
 	kmem_cache_destroy(hpb->map_req_cache);
@@ -1670,7 +2104,7 @@ void ufshpb_init_hpb_lu(struct ufs_hba *hba, struct scsi_device *sdev)
 	if (ret)
 		goto out;
 
-	hpb = ufshpb_alloc_hpb_lu(hba, lun, &hba->ufshpb_dev,
+	hpb = ufshpb_alloc_hpb_lu(hba, sdev, &hba->ufshpb_dev,
 				  &hpb_lu_info);
 	if (!hpb)
 		goto out;
@@ -1678,9 +2112,6 @@ void ufshpb_init_hpb_lu(struct ufs_hba *hba, struct scsi_device *sdev)
 	tot_active_srgn_pages += hpb_lu_info.max_active_rgns *
 			hpb->srgns_per_rgn * hpb->pages_per_srgn;
 
-	hpb->sdev_ufs_lu = sdev;
-	sdev->hostdata = hpb;
-
 out:
 	/* All LUs are initialized */
 	if (atomic_dec_and_test(&hba->ufshpb_dev.slave_conf_cnt))
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index c70e73546e35..eb8366d47d8a 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -30,19 +30,24 @@
 #define PINNED_NOT_SET				U32_MAX
 
 /* hpb support chunk size */
-#define HPB_MULTI_CHUNK_HIGH			1
+#define HPB_MULTI_CHUNK_LOW			9
+#define HPB_MULTI_CHUNK_HIGH			128
 
 /* hpb vender defined opcode */
 #define UFSHPB_READ				0xF8
 #define UFSHPB_READ_BUFFER			0xF9
 #define UFSHPB_READ_BUFFER_ID			0x01
+#define UFSHPB_WRITE_BUFFER			0xFA
+#define UFSHPB_WRITE_BUFFER_PREFETCH_ID		0x02
+#define MAX_HPB_READ_ID				0x7F
 #define HPB_READ_BUFFER_CMD_LENGTH		10
 #define LU_ENABLED_HPB_FUNC			0x02
 
 #define HPB_RESET_REQ_RETRIES			10
 #define HPB_MAP_REQ_RETRIES			5
+#define HPB_REQUEUE_TIME_MS			3
 
-#define HPB_SUPPORT_VERSION			0x100
+#define HPB_SUPPORT_VERSION			0x200
 
 enum UFSHPB_MODE {
 	HPB_HOST_CONTROL,
@@ -118,23 +123,39 @@ struct ufshpb_region {
 	     (i)++)
 
 /**
- * struct ufshpb_req - UFSHPB READ BUFFER (for caching map) request structure
- * @req: block layer request for READ BUFFER
- * @bio: bio for holding map page
- * @hpb: ufshpb_lu structure that related to the L2P map
+ * struct ufshpb_req - HPB related request structure (write/read buffer)
+ * @req: block layer request structure
+ * @bio: bio for this request
+ * @hpb: ufshpb_lu structure that related to
+ * @list_req: ufshpb_req mempool list
+ * @sense: store its sense data
  * @mctx: L2P map information
  * @rgn_idx: target region index
  * @srgn_idx: target sub-region index
  * @lun: target logical unit number
+ * @m_page: L2P map information data for pre-request
+ * @len: length of host-side cached L2P map in m_page
+ * @lpn: start LPN of L2P map in m_page
  */
 struct ufshpb_req {
 	struct request *req;
 	struct bio *bio;
 	struct ufshpb_lu *hpb;
-	struct ufshpb_map_ctx *mctx;
-
-	unsigned int rgn_idx;
-	unsigned int srgn_idx;
+	struct list_head list_req;
+	char sense[SCSI_SENSE_BUFFERSIZE];
+	union {
+		struct {
+			struct ufshpb_map_ctx *mctx;
+			unsigned int rgn_idx;
+			unsigned int srgn_idx;
+			unsigned int lun;
+		} rb;
+		struct {
+			struct page *m_page;
+			unsigned int len;
+			unsigned long lpn;
+		} wb;
+	};
 };
 
 struct victim_select_info {
@@ -143,6 +164,10 @@ struct victim_select_info {
 	atomic_t active_cnt;
 };
 
+struct ufshpb_params {
+	unsigned int requeue_timeout_ms;
+};
+
 struct ufshpb_stats {
 	u64 hit_cnt;
 	u64 miss_cnt;
@@ -150,6 +175,7 @@ struct ufshpb_stats {
 	u64 rb_active_cnt;
 	u64 rb_inactive_cnt;
 	u64 map_req_cnt;
+	u64 pre_req_cnt;
 };
 
 struct ufshpb_lu {
@@ -165,6 +191,15 @@ struct ufshpb_lu {
 	struct list_head lh_act_srgn; /* hold rsp_list_lock */
 	struct list_head lh_inact_rgn; /* hold rsp_list_lock */
 
+	/* pre request information */
+	struct ufshpb_req *pre_req;
+	int num_inflight_pre_req;
+	int throttle_pre_req;
+	struct list_head lh_pre_req_free;
+	int cur_read_id;
+	int pre_req_min_tr_len;
+	int pre_req_max_tr_len;
+
 	/* cached L2P map management worker */
 	struct work_struct map_work;
 
@@ -189,6 +224,7 @@ struct ufshpb_lu {
 	u32 pages_per_srgn;
 
 	struct ufshpb_stats stats;
+	struct ufshpb_params params;
 
 	struct kmem_cache *map_req_cache;
 	struct kmem_cache *m_page_cache;
@@ -200,7 +236,7 @@ struct ufs_hba;
 struct ufshcd_lrb;
 
 #ifndef CONFIG_SCSI_UFS_HPB
-static void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
+static int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) { return 0; }
 static void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
 static void ufshpb_resume(struct ufs_hba *hba) {}
 static void ufshpb_suspend(struct ufs_hba *hba) {}
@@ -214,7 +250,7 @@ static bool ufshpb_is_allowed(struct ufs_hba *hba) { return false; }
 static void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf) {}
 static void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf) {}
 #else
-void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
+int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
 void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
 void ufshpb_resume(struct ufs_hba *hba);
 void ufshpb_suspend(struct ufs_hba *hba);
@@ -228,6 +264,7 @@ bool ufshpb_is_allowed(struct ufs_hba *hba);
 void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf);
 void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf);
 extern struct attribute_group ufs_sysfs_hpb_stat_group;
+extern struct attribute_group ufs_sysfs_hpb_param_group;
 #endif
 
 #endif /* End of Header */
-- 
2.25.1

