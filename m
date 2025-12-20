Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com [209.85.216.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19554199FAB
	for <linux-scsi@vger.kernel.org>; Sat, 20 Dec 2025 05:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766207783; cv=none; b=Y/KMXz+o9A/xCjvNyGUbHGjIgpRjL6oseiPEurhjo+qXRXkbNy7R9+UQ7O8YWub7hrAbB+AF7ozIl3D0i/IhFIOzmJOBa7jTwe///XFD5jVrV/yYGFlc5ACDvFdYzEZ26FFjUjeMa8O3Y4oyobeQ/Wcw7+jR0reARl21sGTbV4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766207783; c=relaxed/simple;
	bh=1xKvni1bzY6OwMh4a/ilB37kH5ndTGYakU3+gOSFhZg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tnROT61EgtNru/eiveSWVlvKZSKOksIcPttFq0eqpwHwGa1+0sL1EdFP+qgTxKQ1wPOiOdFfNbpS6W6KjKKaGvAZdi3t1Tr/rIbo5yMLKkz3eBNMIUdl96ApFJqWoKZEYycN0B5e3qDhtjdZ1hYwLt23hykSwgOX5CC28NzfukM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M/XVb6X/; arc=none smtp.client-ip=209.85.216.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M/XVb6X/"
Received: by mail-pj1-f67.google.com with SMTP id 98e67ed59e1d1-34c84dc332cso2071616a91.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 21:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766207777; x=1766812577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ckgeJ+CqhB0/hVPpNo4ZlPmbJh6YPSeUc7ThpFnRd+Y=;
        b=M/XVb6X/T+VG6LsdM7LjyLhuZaTPr/aukcr5+46Vuf4NodcpNEiNKPyId0/UDRFI93
         Xrd1Q8KxWT16H/Dkuyc3KroUUoe7QQA7FPvhP9VWU2YeJxFmY2XAjo9AzqoRua7qe2dM
         KPdaRHPlXRCAgzM4OIDiWi5dWBehsAZJbQs33Hv/XiectuifYkW2OxCJz5wSG9sohlQM
         i2rCjPUM0YDd02w5Q7n7JTq0Q3aI3imWt1BCygtFPmbqbgUzZIc/JNihW7bLIzofLxyF
         94wnpJj3CZfFVcMkz0PZqFevefjELccs1fHCTQSYSTzcOre2AwDzgn5SUPGMDCFZQf2b
         zQLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766207777; x=1766812577;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ckgeJ+CqhB0/hVPpNo4ZlPmbJh6YPSeUc7ThpFnRd+Y=;
        b=ogLMcv7oC35j9JZHqH1uig2gPB5Y6LsBo+YNhRAnFJc+dDwHAdEDm7IlljnsiS7JWY
         1YvsWFD54wt6YmcO+2B3qZ+2KP7VNBbFEHKn7itJwgM7gqSkb0vvjVGUzhOdncPtFLZE
         3LElDksT4dVjTrMH8DM8+vie3AX6YZMW5WqPqWo6bt3c8325kTRCmPxRN990t49+tUky
         fayLSLHFLNrdVZMVtmydh30zLMdZLg840awvGL5jcpOcbaooQ3rn0dQ4xiGEc3gTXDkx
         4LdQ0p/qLFKAmVUAxU55EoqsTjvsCHD90EbjQx7Di8ekOIe/saPraUZ//7c4+xh3HYjm
         wcXQ==
X-Gm-Message-State: AOJu0YwvcG8zdNfnfBk207yWl2mrM0vfjC//mvc1Zr2yYn6rOY7jTxKH
	XKTTwaz0QGafEdH3wQdZzb6IePbs429qVUI0DRhthBQJ37bWsScZkMOw3rIFjZC7WYk=
X-Gm-Gg: AY/fxX5NWTONIaQlV3o9GtSvM31DbjhPaycv0ONxGfUZEEshVtL6n+DCV9n1NXW41oO
	kWncTB3CVFNMNi0DDjnbTIld/QOsZ/n29kKWe/DF3ck8LbAvz/tKtrfUNEuRX/59PaIWnR5ESAv
	4y0s6vOgxodcdTnCq+ldszvYeT0xYsO9m/fgPCQES1xH+j+bdQMfscVI7gklkMk0Cd9OGhULGW6
	4wJe1DLpdYU0wtl99XDfJKFQiJcrfXhmFRJdjLVpHQPgZAhsL6L+5/oOt7zIEBko2YhfpVOwU0v
	JhGeku4b29e1/+OGdAQusBqPjir34CUe5XeV1xK66Lf68heSxHn1u4f+tM1h4R8Pr73JrCzFPeQ
	DbiaJ6xgo8WOfc7C903FdbJl5FErOZMTS+cz1CUa8pHZx4TvpMSyDbkXNR1wqOhzJGJu/g9PMIi
	5fGSC98FMYGV91iLTQ3ak4kF0YETyCSj59cx9D53v9/FRPCIqk0yXV9VAWkUlOO4li9z9urbATO
	sOIZrDBIkhOmRNXQEs5ElR7oQR9RVsY4EUe2qcbMfgdgfWDVDQt9VXJWrXUYD0MPbgkEai6BPhC
	L0Va
X-Google-Smtp-Source: AGHT+IFFAB4CELMJFFAxuxM+spFJsnN5utxUChYFmGmVIGjCzEbVaAO6gQBLILdTHVAn9B4B46fL0Q==
X-Received: by 2002:a05:7022:220b:b0:11a:61ef:7949 with SMTP id a92af1059eb24-121722ac425mr6050111c88.9.1766207777062;
        Fri, 19 Dec 2025 21:16:17 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724dd7f5sm16482269c88.5.2025.12.19.21.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 21:16:16 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: [PATCH 1/5] scsi: ips: remove function tracing macros
Date: Fri, 19 Dec 2025 21:15:58 -0800
Message-ID: <20251220051602.28029-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These function tracing macros clutter the code and provide
no value over ftrace. Remove them.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/scsi/ips.c | 172 ---------------------------------------------
 1 file changed, 172 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 3393a288fd23..8a1ad327923a 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -216,11 +216,9 @@ module_param(ips, charp, 0);
                          scb->scsi_cmd->sc_data_direction)
 
 #ifdef IPS_DEBUG
-#define METHOD_TRACE(s, i)    if (ips_debug >= (i+10)) printk(KERN_NOTICE s "\n");
 #define DEBUG(i, s)           if (ips_debug >= i) printk(KERN_NOTICE s "\n");
 #define DEBUG_VAR(i, s, v...) if (ips_debug >= i) printk(KERN_NOTICE s "\n", v);
 #else
-#define METHOD_TRACE(s, i)
 #define DEBUG(i, s)
 #define DEBUG_VAR(i, s, v...)
 #endif
@@ -558,8 +556,6 @@ ips_detect(struct scsi_host_template * SHT)
 {
 	int i;
 
-	METHOD_TRACE("ips_detect", 1);
-
 #ifdef MODULE
 	if (ips)
 		ips_setup(ips);
@@ -648,8 +644,6 @@ static void ips_release(struct Scsi_Host *sh)
 	ips_ha_t *ha;
 	int i;
 
-	METHOD_TRACE("ips_release", 1);
-
 	scsi_remove_host(sh);
 
 	for (i = 0; i < IPS_MAX_ADAPTERS && ips_sh[i] != sh; i++) ;
@@ -779,8 +773,6 @@ int ips_eh_abort(struct scsi_cmnd *SC)
 	int ret;
 	struct Scsi_Host *host;
 
-	METHOD_TRACE("ips_eh_abort", 1);
-
 	if (!SC)
 		return (FAILED);
 
@@ -836,8 +828,6 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 	ips_ha_t *ha;
 	ips_scb_t *scb;
 
-	METHOD_TRACE("ips_eh_reset", 1);
-
 #ifdef NO_IPS_RESET
 	return (FAILED);
 #else
@@ -1023,8 +1013,6 @@ static int ips_queue_lck(struct scsi_cmnd *SC)
 	ips_ha_t *ha;
 	ips_passthru_t *pt;
 
-	METHOD_TRACE("ips_queue", 1);
-
 	ha = (ips_ha_t *) SC->device->host->hostdata;
 
 	if (!ha)
@@ -1131,8 +1119,6 @@ static int ips_biosparam(struct scsi_device *sdev, struct gendisk *unused,
 	int sectors;
 	int cylinders;
 
-	METHOD_TRACE("ips_biosparam", 1);
-
 	if (!ha)
 		/* ?!?! host adater info invalid */
 		return (0);
@@ -1208,8 +1194,6 @@ do_ipsintr(int irq, void *dev_id)
 	struct Scsi_Host *host;
 	int irqstatus;
 
-	METHOD_TRACE("do_ipsintr", 2);
-
 	ha = (ips_ha_t *) dev_id;
 	if (!ha)
 		return IRQ_NONE;
@@ -1255,8 +1239,6 @@ ips_intr_copperhead(ips_ha_t * ha)
 	IPS_STATUS cstatus;
 	int intrstatus;
 
-	METHOD_TRACE("ips_intr", 2);
-
 	if (!ha)
 		return 0;
 
@@ -1319,8 +1301,6 @@ ips_intr_morpheus(ips_ha_t * ha)
 	IPS_STATUS cstatus;
 	int intrstatus;
 
-	METHOD_TRACE("ips_intr_morpheus", 2);
-
 	if (!ha)
 		return 0;
 
@@ -1386,8 +1366,6 @@ ips_info(struct Scsi_Host *SH)
 	char *bp;
 	ips_ha_t *ha;
 
-	METHOD_TRACE("ips_info", 1);
-
 	ha = IPS_HA(SH);
 
 	if (!ha)
@@ -1469,8 +1447,6 @@ static int ips_is_passthru(struct scsi_cmnd *SC)
 {
 	unsigned long flags;
 
-	METHOD_TRACE("ips_is_passthru", 1);
-
 	if (!SC)
 		return (0);
 
@@ -1546,8 +1522,6 @@ ips_make_passthru(ips_ha_t *ha, struct scsi_cmnd *SC, ips_scb_t *scb, int intr)
 	int i, ret;
         struct scatterlist *sg = scsi_sglist(SC);
 
-	METHOD_TRACE("ips_make_passthru", 1);
-
         scsi_for_each_sg(SC, sg, scsi_sg_count(SC), i)
 		length += sg->length;
 
@@ -1884,8 +1858,6 @@ ips_usrcmd(ips_ha_t * ha, ips_passthru_t * pt, ips_scb_t * scb)
 	IPS_SG_LIST sg_list;
 	uint32_t cmd_busaddr;
 
-	METHOD_TRACE("ips_usrcmd", 1);
-
 	if ((!scb) || (!pt) || (!ha))
 		return (0);
 
@@ -1971,8 +1943,6 @@ ips_cleanup_passthru(ips_ha_t * ha, ips_scb_t * scb)
 {
 	ips_passthru_t *pt;
 
-	METHOD_TRACE("ips_cleanup_passthru", 1);
-
 	if ((!scb) || (!scb->scsi_cmd) || (!scsi_sglist(scb->scsi_cmd))) {
 		DEBUG_VAR(1, "(%s%d) couldn't cleanup after passthru",
 			  ips_name, ha->host_num);
@@ -2009,8 +1979,6 @@ ips_cleanup_passthru(ips_ha_t * ha, ips_scb_t * scb)
 static int
 ips_host_info(ips_ha_t *ha, struct seq_file *m)
 {
-	METHOD_TRACE("ips_host_info", 1);
-
 	seq_puts(m, "\nIBM ServeRAID General Information:\n\n");
 
 	if ((le32_to_cpu(ha->nvram->signature) == IPS_NVRAM_P5_SIG) &&
@@ -2127,8 +2095,6 @@ ips_host_info(ips_ha_t *ha, struct seq_file *m)
 static void
 ips_identify_controller(ips_ha_t * ha)
 {
-	METHOD_TRACE("ips_identify_controller", 1);
-
 	switch (ha->pcidev->device) {
 	case IPS_DEVICEID_COPPERHEAD:
 		if (ha->pcidev->revision <= IPS_REVID_SERVERAID) {
@@ -2219,8 +2185,6 @@ ips_get_bios_version(ips_ha_t * ha, int intr)
 	uint8_t subminor;
 	uint8_t *buffer;
 
-	METHOD_TRACE("ips_get_bios_version", 1);
-
 	major = 0;
 	minor = 0;
 
@@ -2374,8 +2338,6 @@ ips_hainit(ips_ha_t * ha)
 {
 	int i;
 
-	METHOD_TRACE("ips_hainit", 1);
-
 	if (!ha)
 		return (0);
 
@@ -2513,7 +2475,6 @@ ips_next(ips_ha_t * ha, int intr)
 	ips_copp_wait_item_t *item;
 	int ret;
 	struct Scsi_Host *host;
-	METHOD_TRACE("ips_next", 1);
 
 	if (!ha)
 		return;
@@ -2737,8 +2698,6 @@ ips_next(ips_ha_t * ha, int intr)
 static void
 ips_putq_scb_head(ips_scb_queue_t * queue, ips_scb_t * item)
 {
-	METHOD_TRACE("ips_putq_scb_head", 1);
-
 	if (!item)
 		return;
 
@@ -2767,8 +2726,6 @@ ips_removeq_scb_head(ips_scb_queue_t * queue)
 {
 	ips_scb_t *item;
 
-	METHOD_TRACE("ips_removeq_scb_head", 1);
-
 	item = queue->head;
 
 	if (!item) {
@@ -2802,8 +2759,6 @@ ips_removeq_scb(ips_scb_queue_t * queue, ips_scb_t * item)
 {
 	ips_scb_t *p;
 
-	METHOD_TRACE("ips_removeq_scb", 1);
-
 	if (!item)
 		return (NULL);
 
@@ -2845,8 +2800,6 @@ ips_removeq_scb(ips_scb_queue_t * queue, ips_scb_t * item)
 /****************************************************************************/
 static void ips_putq_wait_tail(ips_wait_queue_entry_t *queue, struct scsi_cmnd *item)
 {
-	METHOD_TRACE("ips_putq_wait_tail", 1);
-
 	if (!item)
 		return;
 
@@ -2878,8 +2831,6 @@ static struct scsi_cmnd *ips_removeq_wait_head(ips_wait_queue_entry_t *queue)
 {
 	struct scsi_cmnd *item;
 
-	METHOD_TRACE("ips_removeq_wait_head", 1);
-
 	item = queue->head;
 
 	if (!item) {
@@ -2913,8 +2864,6 @@ static struct scsi_cmnd *ips_removeq_wait(ips_wait_queue_entry_t *queue,
 {
 	struct scsi_cmnd *p;
 
-	METHOD_TRACE("ips_removeq_wait", 1);
-
 	if (!item)
 		return (NULL);
 
@@ -2957,8 +2906,6 @@ static struct scsi_cmnd *ips_removeq_wait(ips_wait_queue_entry_t *queue,
 static void
 ips_putq_copp_tail(ips_copp_queue_t * queue, ips_copp_wait_item_t * item)
 {
-	METHOD_TRACE("ips_putq_copp_tail", 1);
-
 	if (!item)
 		return;
 
@@ -2991,8 +2938,6 @@ ips_removeq_copp_head(ips_copp_queue_t * queue)
 {
 	ips_copp_wait_item_t *item;
 
-	METHOD_TRACE("ips_removeq_copp_head", 1);
-
 	item = queue->head;
 
 	if (!item) {
@@ -3026,8 +2971,6 @@ ips_removeq_copp(ips_copp_queue_t * queue, ips_copp_wait_item_t * item)
 {
 	ips_copp_wait_item_t *p;
 
-	METHOD_TRACE("ips_removeq_copp", 1);
-
 	if (!item)
 		return (NULL);
 
@@ -3068,8 +3011,6 @@ ips_removeq_copp(ips_copp_queue_t * queue, ips_copp_wait_item_t * item)
 static void
 ipsintr_blocking(ips_ha_t * ha, ips_scb_t * scb)
 {
-	METHOD_TRACE("ipsintr_blocking", 2);
-
 	ips_freescb(ha, scb);
 	if (ha->waitflag && ha->cmd_in_progress == scb->cdb[0]) {
 		ha->waitflag = false;
@@ -3090,8 +3031,6 @@ ipsintr_blocking(ips_ha_t * ha, ips_scb_t * scb)
 static void
 ipsintr_done(ips_ha_t * ha, ips_scb_t * scb)
 {
-	METHOD_TRACE("ipsintr_done", 2);
-
 	if (!scb) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "Spurious interrupt; scb NULL.\n");
@@ -3124,8 +3063,6 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 {
 	int ret;
 
-	METHOD_TRACE("ips_done", 1);
-
 	if (!scb)
 		return;
 
@@ -3234,8 +3171,6 @@ ips_map_status(ips_ha_t * ha, ips_scb_t * scb, ips_stat_t * sp)
 	IPS_DCDB_TABLE_TAPE *tapeDCDB;
 	IPS_SCSI_INQ_DATA inquiryData;
 
-	METHOD_TRACE("ips_map_status", 1);
-
 	if (scb->bus) {
 		DEBUG_VAR(2,
 			  "(%s%d) Physical device error (%d %d %d): %x %x, Sense Key: %x, ASC: %x, ASCQ: %x",
@@ -3369,8 +3304,6 @@ ips_send_wait(ips_ha_t * ha, ips_scb_t * scb, int timeout, int intr)
 {
 	int ret;
 
-	METHOD_TRACE("ips_send_wait", 1);
-
 	if (intr != IPS_FFDC) {	/* Won't be Waiting if this is a Time Stamp */
 		ha->waitflag = true;
 		ha->cmd_in_progress = scb->cdb[0];
@@ -3439,8 +3372,6 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 	IPS_DCDB_TABLE_TAPE *tapeDCDB;
 	int TimeOut;
 
-	METHOD_TRACE("ips_send_cmd", 1);
-
 	ret = IPS_SUCCESS;
 
 	if (!scb->scsi_cmd) {
@@ -3821,8 +3752,6 @@ ips_chkstatus(ips_ha_t * ha, IPS_STATUS * pstatus)
 	int errcode;
 	IPS_SCSI_INQ_DATA inquiryData;
 
-	METHOD_TRACE("ips_chkstatus", 1);
-
 	scb = &ha->scbs[pstatus->fields.command_id];
 	scb->basic_status = basic_status =
 	    pstatus->fields.basic_status & IPS_BASIC_STATUS_MASK;
@@ -3972,8 +3901,6 @@ ips_chkstatus(ips_ha_t * ha, IPS_STATUS * pstatus)
 static int
 ips_online(ips_ha_t * ha, ips_scb_t * scb)
 {
-	METHOD_TRACE("ips_online", 1);
-
 	if (scb->target_id >= IPS_MAX_LD)
 		return (0);
 
@@ -4009,8 +3936,6 @@ ips_inquiry(ips_ha_t * ha, ips_scb_t * scb)
 {
 	IPS_SCSI_INQ_DATA inquiry;
 
-	METHOD_TRACE("ips_inquiry", 1);
-
 	memset(&inquiry, 0, sizeof (IPS_SCSI_INQ_DATA));
 
 	inquiry.DeviceType = IPS_SCSI_INQ_TYPE_DASD;
@@ -4044,8 +3969,6 @@ ips_rdcap(ips_ha_t * ha, ips_scb_t * scb)
 {
 	IPS_SCSI_CAPACITY cap;
 
-	METHOD_TRACE("ips_rdcap", 1);
-
 	if (scsi_bufflen(scb->scsi_cmd) < 8)
 		return (0);
 
@@ -4077,8 +4000,6 @@ ips_msense(ips_ha_t * ha, ips_scb_t * scb)
 	uint32_t cylinders;
 	IPS_SCSI_MODE_PAGE_DATA mdata;
 
-	METHOD_TRACE("ips_msense", 1);
-
 	if (le32_to_cpu(ha->enq->ulDriveSize[scb->target_id]) > 0x400000 &&
 	    (ha->enq->ucMiscFlag & 0x8) == 0) {
 		heads = IPS_NORM_HEADS;
@@ -4165,8 +4086,6 @@ ips_reqsen(ips_ha_t * ha, ips_scb_t * scb)
 {
 	IPS_SCSI_REQSEN reqsen;
 
-	METHOD_TRACE("ips_reqsen", 1);
-
 	memset(&reqsen, 0, sizeof (IPS_SCSI_REQSEN));
 
 	reqsen.ResponseCode =
@@ -4193,8 +4112,6 @@ static void
 ips_free(ips_ha_t * ha)
 {
 
-	METHOD_TRACE("ips_free", 1);
-
 	if (ha) {
 		if (ha->enq) {
 			dma_free_coherent(&ha->pcidev->dev, sizeof(IPS_ENQ),
@@ -4289,8 +4206,6 @@ ips_allocatescbs(ips_ha_t * ha)
 	int i;
 	dma_addr_t command_dma, sg_dma;
 
-	METHOD_TRACE("ips_allocatescbs", 1);
-
 	/* Allocate memory for the SCBs */
 	ha->scbs = dma_alloc_coherent(&ha->pcidev->dev,
 			ha->max_cmds * sizeof (ips_scb_t),
@@ -4350,7 +4265,6 @@ ips_init_scb(ips_ha_t * ha, ips_scb_t * scb)
 {
 	IPS_SG_LIST sg_list;
 	uint32_t cmd_busaddr, sg_busaddr;
-	METHOD_TRACE("ips_init_scb", 1);
 
 	if (scb == NULL)
 		return;
@@ -4395,8 +4309,6 @@ ips_getscb(ips_ha_t * ha)
 {
 	ips_scb_t *scb;
 
-	METHOD_TRACE("ips_getscb", 1);
-
 	if ((scb = ha->scb_freelist) == NULL) {
 
 		return (NULL);
@@ -4426,7 +4338,6 @@ static void
 ips_freescb(ips_ha_t * ha, ips_scb_t * scb)
 {
 
-	METHOD_TRACE("ips_freescb", 1);
 	if (scb->flags & IPS_SCB_MAP_SG)
                 scsi_dma_unmap(scb->scsi_cmd);
 	else if (scb->flags & IPS_SCB_MAP_SINGLE)
@@ -4455,8 +4366,6 @@ ips_isinit_copperhead(ips_ha_t * ha)
 	uint8_t scpr;
 	uint8_t isr;
 
-	METHOD_TRACE("ips_isinit_copperhead", 1);
-
 	isr = inb(ha->io_addr + IPS_REG_HISR);
 	scpr = inb(ha->io_addr + IPS_REG_SCPR);
 
@@ -4481,8 +4390,6 @@ ips_isinit_copperhead_memio(ips_ha_t * ha)
 	uint8_t isr = 0;
 	uint8_t scpr;
 
-	METHOD_TRACE("ips_is_init_copperhead_memio", 1);
-
 	isr = readb(ha->mem_ptr + IPS_REG_HISR);
 	scpr = readb(ha->mem_ptr + IPS_REG_SCPR);
 
@@ -4507,8 +4414,6 @@ ips_isinit_morpheus(ips_ha_t * ha)
 	uint32_t post;
 	uint32_t bits;
 
-	METHOD_TRACE("ips_is_init_morpheus", 1);
-
 	if (ips_isintr_morpheus(ha))
 	    ips_flush_and_reset(ha);
 
@@ -4623,8 +4528,6 @@ ips_poll_for_flush_complete(ips_ha_t * ha)
 static void
 ips_enable_int_copperhead(ips_ha_t * ha)
 {
-	METHOD_TRACE("ips_enable_int_copperhead", 1);
-
 	outb(ha->io_addr + IPS_REG_HISR, IPS_BIT_EI);
 	inb(ha->io_addr + IPS_REG_HISR);	/*Ensure PCI Posting Completes*/
 }
@@ -4640,8 +4543,6 @@ ips_enable_int_copperhead(ips_ha_t * ha)
 static void
 ips_enable_int_copperhead_memio(ips_ha_t * ha)
 {
-	METHOD_TRACE("ips_enable_int_copperhead_memio", 1);
-
 	writeb(IPS_BIT_EI, ha->mem_ptr + IPS_REG_HISR);
 	readb(ha->mem_ptr + IPS_REG_HISR);	/*Ensure PCI Posting Completes*/
 }
@@ -4659,8 +4560,6 @@ ips_enable_int_morpheus(ips_ha_t * ha)
 {
 	uint32_t Oimr;
 
-	METHOD_TRACE("ips_enable_int_morpheus", 1);
-
 	Oimr = readl(ha->mem_ptr + IPS_REG_I960_OIMR);
 	Oimr &= ~0x08;
 	writel(Oimr, ha->mem_ptr + IPS_REG_I960_OIMR);
@@ -4684,8 +4583,6 @@ ips_init_copperhead(ips_ha_t * ha)
 	uint8_t PostByte[IPS_MAX_POST_BYTES];
 	int i, j;
 
-	METHOD_TRACE("ips_init_copperhead", 1);
-
 	for (i = 0; i < IPS_MAX_POST_BYTES; i++) {
 		for (j = 0; j < 45; j++) {
 			Isr = inb(ha->io_addr + IPS_REG_HISR);
@@ -4777,8 +4674,6 @@ ips_init_copperhead_memio(ips_ha_t * ha)
 	uint8_t PostByte[IPS_MAX_POST_BYTES];
 	int i, j;
 
-	METHOD_TRACE("ips_init_copperhead_memio", 1);
-
 	for (i = 0; i < IPS_MAX_POST_BYTES; i++) {
 		for (j = 0; j < 45; j++) {
 			Isr = readb(ha->mem_ptr + IPS_REG_HISR);
@@ -4872,8 +4767,6 @@ ips_init_morpheus(ips_ha_t * ha)
 	uint32_t Oimr;
 	int i;
 
-	METHOD_TRACE("ips_init_morpheus", 1);
-
 	/* Wait up to 45 secs for Post */
 	for (i = 0; i < 45; i++) {
 		Isr = readl(ha->mem_ptr + IPS_REG_I2O_HIR);
@@ -4985,8 +4878,6 @@ ips_reset_copperhead(ips_ha_t * ha)
 {
 	int reset_counter;
 
-	METHOD_TRACE("ips_reset_copperhead", 1);
-
 	DEBUG_VAR(1, "(%s%d) ips_reset_copperhead: io addr: %x, irq: %d",
 		  ips_name, ha->host_num, ha->io_addr, ha->pcidev->irq);
 
@@ -5030,8 +4921,6 @@ ips_reset_copperhead_memio(ips_ha_t * ha)
 {
 	int reset_counter;
 
-	METHOD_TRACE("ips_reset_copperhead_memio", 1);
-
 	DEBUG_VAR(1, "(%s%d) ips_reset_copperhead_memio: mem addr: %x, irq: %d",
 		  ips_name, ha->host_num, ha->mem_addr, ha->pcidev->irq);
 
@@ -5076,8 +4965,6 @@ ips_reset_morpheus(ips_ha_t * ha)
 	int reset_counter;
 	uint8_t junk;
 
-	METHOD_TRACE("ips_reset_morpheus", 1);
-
 	DEBUG_VAR(1, "(%s%d) ips_reset_morpheus: mem addr: %x, irq: %d",
 		  ips_name, ha->host_num, ha->mem_addr, ha->pcidev->irq);
 
@@ -5119,8 +5006,6 @@ ips_statinit(ips_ha_t * ha)
 {
 	uint32_t phys_status_start;
 
-	METHOD_TRACE("ips_statinit", 1);
-
 	ha->adapt->p_status_start = ha->adapt->status;
 	ha->adapt->p_status_end = ha->adapt->status + IPS_MAX_CMDS;
 	ha->adapt->p_status_tail = ha->adapt->status;
@@ -5150,8 +5035,6 @@ ips_statinit_memio(ips_ha_t * ha)
 {
 	uint32_t phys_status_start;
 
-	METHOD_TRACE("ips_statinit_memio", 1);
-
 	ha->adapt->p_status_start = ha->adapt->status;
 	ha->adapt->p_status_end = ha->adapt->status + IPS_MAX_CMDS;
 	ha->adapt->p_status_tail = ha->adapt->status;
@@ -5178,8 +5061,6 @@ ips_statinit_memio(ips_ha_t * ha)
 static uint32_t
 ips_statupd_copperhead(ips_ha_t * ha)
 {
-	METHOD_TRACE("ips_statupd_copperhead", 1);
-
 	if (ha->adapt->p_status_tail != ha->adapt->p_status_end) {
 		ha->adapt->p_status_tail++;
 		ha->adapt->hw_status_tail += sizeof (IPS_STATUS);
@@ -5206,8 +5087,6 @@ ips_statupd_copperhead(ips_ha_t * ha)
 static uint32_t
 ips_statupd_copperhead_memio(ips_ha_t * ha)
 {
-	METHOD_TRACE("ips_statupd_copperhead_memio", 1);
-
 	if (ha->adapt->p_status_tail != ha->adapt->p_status_end) {
 		ha->adapt->p_status_tail++;
 		ha->adapt->hw_status_tail += sizeof (IPS_STATUS);
@@ -5235,8 +5114,6 @@ ips_statupd_morpheus(ips_ha_t * ha)
 {
 	uint32_t val;
 
-	METHOD_TRACE("ips_statupd_morpheus", 1);
-
 	val = readl(ha->mem_ptr + IPS_REG_I2O_OUTMSGQ);
 
 	return (val);
@@ -5257,8 +5134,6 @@ ips_issue_copperhead(ips_ha_t * ha, ips_scb_t * scb)
 	uint32_t TimeOut;
 	uint32_t val;
 
-	METHOD_TRACE("ips_issue_copperhead", 1);
-
 	if (scb->scsi_cmd) {
 		DEBUG_VAR(2, "(%s%d) ips_issue: cmd 0x%X id %d (%d %d %d)",
 			  ips_name,
@@ -5311,8 +5186,6 @@ ips_issue_copperhead_memio(ips_ha_t * ha, ips_scb_t * scb)
 	uint32_t TimeOut;
 	uint32_t val;
 
-	METHOD_TRACE("ips_issue_copperhead_memio", 1);
-
 	if (scb->scsi_cmd) {
 		DEBUG_VAR(2, "(%s%d) ips_issue: cmd 0x%X id %d (%d %d %d)",
 			  ips_name,
@@ -5362,8 +5235,6 @@ static int
 ips_issue_i2o(ips_ha_t * ha, ips_scb_t * scb)
 {
 
-	METHOD_TRACE("ips_issue_i2o", 1);
-
 	if (scb->scsi_cmd) {
 		DEBUG_VAR(2, "(%s%d) ips_issue: cmd 0x%X id %d (%d %d %d)",
 			  ips_name,
@@ -5394,8 +5265,6 @@ static int
 ips_issue_i2o_memio(ips_ha_t * ha, ips_scb_t * scb)
 {
 
-	METHOD_TRACE("ips_issue_i2o_memio", 1);
-
 	if (scb->scsi_cmd) {
 		DEBUG_VAR(2, "(%s%d) ips_issue: cmd 0x%X id %d (%d %d %d)",
 			  ips_name,
@@ -5427,8 +5296,6 @@ ips_isintr_copperhead(ips_ha_t * ha)
 {
 	uint8_t Isr;
 
-	METHOD_TRACE("ips_isintr_copperhead", 2);
-
 	Isr = inb(ha->io_addr + IPS_REG_HISR);
 
 	if (Isr == 0xFF)
@@ -5460,8 +5327,6 @@ ips_isintr_copperhead_memio(ips_ha_t * ha)
 {
 	uint8_t Isr;
 
-	METHOD_TRACE("ips_isintr_memio", 2);
-
 	Isr = readb(ha->mem_ptr + IPS_REG_HISR);
 
 	if (Isr == 0xFF)
@@ -5493,8 +5358,6 @@ ips_isintr_morpheus(ips_ha_t * ha)
 {
 	uint32_t Isr;
 
-	METHOD_TRACE("ips_isintr_morpheus", 2);
-
 	Isr = readl(ha->mem_ptr + IPS_REG_I2O_HIR);
 
 	if (Isr & IPS_BIT_I2O_OPQI)
@@ -5518,8 +5381,6 @@ ips_wait(ips_ha_t * ha, int time, int intr)
 	int ret;
 	int done;
 
-	METHOD_TRACE("ips_wait", 1);
-
 	ret = IPS_FAILURE;
 	done = false;
 
@@ -5573,8 +5434,6 @@ ips_wait(ips_ha_t * ha, int time, int intr)
 static int
 ips_write_driver_status(ips_ha_t * ha, int intr)
 {
-	METHOD_TRACE("ips_write_driver_status", 1);
-
 	if (!ips_readwrite_page5(ha, false, intr)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "unable to read NVRAM page 5.\n");
@@ -5641,8 +5500,6 @@ ips_read_adapter_status(ips_ha_t * ha, int intr)
 	ips_scb_t *scb;
 	int ret;
 
-	METHOD_TRACE("ips_read_adapter_status", 1);
-
 	scb = &ha->scbs[ha->max_cmds - 1];
 
 	ips_init_scb(ha, scb);
@@ -5684,8 +5541,6 @@ ips_read_subsystem_parameters(ips_ha_t * ha, int intr)
 	ips_scb_t *scb;
 	int ret;
 
-	METHOD_TRACE("ips_read_subsystem_parameters", 1);
-
 	scb = &ha->scbs[ha->max_cmds - 1];
 
 	ips_init_scb(ha, scb);
@@ -5729,8 +5584,6 @@ ips_read_config(ips_ha_t * ha, int intr)
 	int i;
 	int ret;
 
-	METHOD_TRACE("ips_read_config", 1);
-
 	/* set defaults for initiator IDs */
 	for (i = 0; i < 4; i++)
 		ha->conf->init_id[i] = 7;
@@ -5786,8 +5639,6 @@ ips_readwrite_page5(ips_ha_t * ha, int write, int intr)
 	ips_scb_t *scb;
 	int ret;
 
-	METHOD_TRACE("ips_readwrite_page5", 1);
-
 	scb = &ha->scbs[ha->max_cmds - 1];
 
 	ips_init_scb(ha, scb);
@@ -5836,8 +5687,6 @@ ips_clear_adapter(ips_ha_t * ha, int intr)
 	ips_scb_t *scb;
 	int ret;
 
-	METHOD_TRACE("ips_clear_adapter", 1);
-
 	scb = &ha->scbs[ha->max_cmds - 1];
 
 	ips_init_scb(ha, scb);
@@ -5898,8 +5747,6 @@ ips_ffdc_reset(ips_ha_t * ha, int intr)
 {
 	ips_scb_t *scb;
 
-	METHOD_TRACE("ips_ffdc_reset", 1);
-
 	scb = &ha->scbs[ha->max_cmds - 1];
 
 	ips_init_scb(ha, scb);
@@ -5932,8 +5779,6 @@ ips_ffdc_time(ips_ha_t * ha)
 {
 	ips_scb_t *scb;
 
-	METHOD_TRACE("ips_ffdc_time", 1);
-
 	DEBUG_VAR(1, "(%s%d) Sending time update.", ips_name, ha->host_num);
 
 	scb = &ha->scbs[ha->max_cmds - 1];
@@ -5967,8 +5812,6 @@ ips_fix_ffdc_time(ips_ha_t * ha, ips_scb_t * scb, time64_t current_time)
 {
 	struct tm tm;
 
-	METHOD_TRACE("ips_fix_ffdc_time", 1);
-
 	time64_to_tm(current_time, 0, &tm);
 
 	scb->cmd.ffdc.hour   = tm.tm_hour;
@@ -5998,8 +5841,6 @@ ips_erase_bios(ips_ha_t * ha)
 	int timeout;
 	uint8_t status = 0;
 
-	METHOD_TRACE("ips_erase_bios", 1);
-
 	status = 0;
 
 	/* Clear the status register */
@@ -6110,8 +5951,6 @@ ips_erase_bios_memio(ips_ha_t * ha)
 	int timeout;
 	uint8_t status;
 
-	METHOD_TRACE("ips_erase_bios_memio", 1);
-
 	status = 0;
 
 	/* Clear the status register */
@@ -6224,8 +6063,6 @@ ips_program_bios(ips_ha_t * ha, char *buffer, uint32_t buffersize,
 	int timeout;
 	uint8_t status = 0;
 
-	METHOD_TRACE("ips_program_bios", 1);
-
 	status = 0;
 
 	for (i = 0; i < buffersize; i++) {
@@ -6315,8 +6152,6 @@ ips_program_bios_memio(ips_ha_t * ha, char *buffer, uint32_t buffersize,
 	int timeout;
 	uint8_t status = 0;
 
-	METHOD_TRACE("ips_program_bios_memio", 1);
-
 	status = 0;
 
 	for (i = 0; i < buffersize; i++) {
@@ -6405,8 +6240,6 @@ ips_verify_bios(ips_ha_t * ha, char *buffer, uint32_t buffersize,
 	uint8_t checksum;
 	int i;
 
-	METHOD_TRACE("ips_verify_bios", 1);
-
 	/* test 1st byte */
 	outl(0, ha->io_addr + IPS_REG_FLAP);
 	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
@@ -6454,8 +6287,6 @@ ips_verify_bios_memio(ips_ha_t * ha, char *buffer, uint32_t buffersize,
 	uint8_t checksum;
 	int i;
 
-	METHOD_TRACE("ips_verify_bios_memio", 1);
-
 	/* test 1st byte */
 	writel(0, ha->mem_ptr + IPS_REG_FLAP);
 	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
@@ -6762,7 +6593,6 @@ ips_insert_device(struct pci_dev *pci_dev, const struct pci_device_id *ent)
 	int index = -1;
 	int rc;
 
-	METHOD_TRACE("ips_insert_device", 1);
 	rc = pci_enable_device(pci_dev);
 	if (rc)
 		return rc;
@@ -6825,7 +6655,6 @@ ips_init_phase1(struct pci_dev *pci_dev, int *indexPtr)
 	char __iomem *mem_ptr;
 	uint32_t IsDead;
 
-	METHOD_TRACE("ips_init_phase1", 1);
 	index = IPS_MAX_ADAPTERS;
 	for (j = 0; j < IPS_MAX_ADAPTERS; j++) {
 		if (ips_ha[j] == NULL) {
@@ -7032,7 +6861,6 @@ ips_init_phase2(int index)
 
 	ha = ips_ha[index];
 
-	METHOD_TRACE("ips_init_phase2", 1);
 	if (!ha->active) {
 		ips_ha[index] = NULL;
 		return -1;
-- 
2.43.0

