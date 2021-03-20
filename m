Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C549EC433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 16:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F59261940
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 16:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhCTQtN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Mar 2021 12:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhCTQst (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Mar 2021 12:48:49 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5010AC061574;
        Sat, 20 Mar 2021 09:48:49 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id AE4981280171;
        Sat, 20 Mar 2021 09:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1616258927;
        bh=y0SveulOEXg3XU4Yclm6Cxt1Lxe73GjXPskpZ2GuMPk=;
        h=Message-ID:Subject:From:To:Date:From;
        b=rKFvS+S993Ikkc+A3d/BsYrniFGvr+oShy6ZwLXFCVveIAWmO7TFWpMs32hYlp9pc
         n5prk/KUd5a3QKMC0Az34Lo7xm7o7mIa6mqAJYlC83xFa4SMwhyZepMRG4JEGBf6NQ
         KzDRmoRgrrnmHklVcST9UGlb3Ppd8eQsq7o08kY4=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AJLuaNpWtNHU; Sat, 20 Mar 2021 09:48:47 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 473A21280168;
        Sat, 20 Mar 2021 09:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1616258927;
        bh=y0SveulOEXg3XU4Yclm6Cxt1Lxe73GjXPskpZ2GuMPk=;
        h=Message-ID:Subject:From:To:Date:From;
        b=rKFvS+S993Ikkc+A3d/BsYrniFGvr+oShy6ZwLXFCVveIAWmO7TFWpMs32hYlp9pc
         n5prk/KUd5a3QKMC0Az34Lo7xm7o7mIa6mqAJYlC83xFa4SMwhyZepMRG4JEGBf6NQ
         KzDRmoRgrrnmHklVcST9UGlb3Ppd8eQsq7o08kY4=
Message-ID: <04bf2656fe347fa20b3d6599c18322426720b084.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.12-rc3
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 20 Mar 2021 09:48:46 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Eight fixes, all in drivers, all fairly minor either being fixes in
error legs, memory leaks on teardown, context errors or semantic
problems.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Alexey Dobriyan (1):
      scsi: qla2xxx: Fix broken #endif placement

Christophe JAILLET (1):
      scsi: mpt3sas: Do not use GFP_KERNEL in atomic context

Dan Carpenter (1):
      scsi: lpfc: Fix some error codes in debugfs

Johannes Thumshirn (1):
      scsi: sd_zbc: Update write pointer offset cache

Lv Yunlong (2):
      scsi: st: Fix a use after free in st_open()
      scsi: myrs: Fix a double free in myrs_cleanup()

Tyrel Datwyler (1):
      scsi: ibmvfc: Free channel_setup_buf during device tear down

dongjian (1):
      scsi: ufs: ufs-mediatek: Correct operator & -> &&

And the diffstat:

 drivers/scsi/ibmvscsi/ibmvfc.c       |  2 ++
 drivers/scsi/lpfc/lpfc_debugfs.c     |  4 ++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  2 +-
 drivers/scsi/myrs.c                  |  2 +-
 drivers/scsi/qla2xxx/qla_target.h    |  2 +-
 drivers/scsi/sd_zbc.c                | 19 +++++++++++--------
 drivers/scsi/st.c                    |  2 +-
 drivers/scsi/ufs/ufs-mediatek.c      |  2 +-
 8 files changed, 20 insertions(+), 15 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 338e29d3e025..6a92891ac488 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -5784,6 +5784,8 @@ static void ibmvfc_free_mem(struct ibmvfc_host *vhost)
 			  vhost->disc_buf_dma);
 	dma_free_coherent(vhost->dev, sizeof(*vhost->login_buf),
 			  vhost->login_buf, vhost->login_buf_dma);
+	dma_free_coherent(vhost->dev, sizeof(*vhost->channel_setup_buf),
+			  vhost->channel_setup_buf, vhost->channel_setup_dma);
 	dma_pool_destroy(vhost->sg_pool);
 	ibmvfc_free_queue(vhost, async_q);
 	LEAVE;
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index bc79a017e1a2..46a8f2d1d2b8 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2421,7 +2421,7 @@ lpfc_debugfs_dif_err_write(struct file *file, const char __user *buf,
 	memset(dstbuf, 0, 33);
 	size = (nbytes < 32) ? nbytes : 32;
 	if (copy_from_user(dstbuf, buf, size))
-		return 0;
+		return -EFAULT;
 
 	if (dent == phba->debug_InjErrLBA) {
 		if ((dstbuf[0] == 'o') && (dstbuf[1] == 'f') &&
@@ -2430,7 +2430,7 @@ lpfc_debugfs_dif_err_write(struct file *file, const char __user *buf,
 	}
 
 	if ((tmp == 0) && (kstrtoull(dstbuf, 0, &tmp)))
-		return 0;
+		return -EINVAL;
 
 	if (dent == phba->debug_writeGuard)
 		phba->lpfc_injerr_wgrd_cnt = (uint32_t)tmp;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index ffca03064797..6aa6de729187 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -413,7 +413,7 @@ mpt3sas_get_port_by_id(struct MPT3SAS_ADAPTER *ioc,
 	 * And add this object to port_table_list.
 	 */
 	if (!ioc->multipath_on_hba) {
-		port = kzalloc(sizeof(struct hba_port), GFP_KERNEL);
+		port = kzalloc(sizeof(struct hba_port), GFP_ATOMIC);
 		if (!port)
 			return NULL;
 
diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 4adf9ded296a..329fd025c718 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -2273,12 +2273,12 @@ static void myrs_cleanup(struct myrs_hba *cs)
 	if (cs->mmio_base) {
 		cs->disable_intr(cs);
 		iounmap(cs->mmio_base);
+		cs->mmio_base = NULL;
 	}
 	if (cs->irq)
 		free_irq(cs->irq, cs);
 	if (cs->io_addr)
 		release_region(cs->io_addr, 0x80);
-	iounmap(cs->mmio_base);
 	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 	scsi_host_put(cs->host);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 10e5e6c8087d..01620f3eab39 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -116,7 +116,6 @@
 	(min(1270, ((ql) > 0) ? (QLA_TGT_DATASEGS_PER_CMD_24XX + \
 		QLA_TGT_DATASEGS_PER_CONT_24XX*((ql) - 1)) : 0))
 #endif
-#endif
 
 #define GET_TARGET_ID(ha, iocb) ((HAS_EXTENDED_IDS(ha))			\
 			 ? le16_to_cpu((iocb)->u.isp2x.target.extended)	\
@@ -244,6 +243,7 @@ struct ctio_to_2xxx {
 #ifndef CTIO_RET_TYPE
 #define CTIO_RET_TYPE	0x17		/* CTIO return entry */
 #define ATIO_TYPE7 0x06 /* Accept target I/O entry for 24xx */
+#endif
 
 struct fcp_hdr {
 	uint8_t  r_ctl;
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index ee558675eab4..994f1b8e3504 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -280,27 +280,28 @@ static int sd_zbc_update_wp_offset_cb(struct blk_zone *zone, unsigned int idx,
 static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)
 {
 	struct scsi_disk *sdkp;
+	unsigned long flags;
 	unsigned int zno;
 	int ret;
 
 	sdkp = container_of(work, struct scsi_disk, zone_wp_offset_work);
 
-	spin_lock_bh(&sdkp->zones_wp_offset_lock);
+	spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
 	for (zno = 0; zno < sdkp->nr_zones; zno++) {
 		if (sdkp->zones_wp_offset[zno] != SD_ZBC_UPDATING_WP_OFST)
 			continue;
 
-		spin_unlock_bh(&sdkp->zones_wp_offset_lock);
+		spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
 		ret = sd_zbc_do_report_zones(sdkp, sdkp->zone_wp_update_buf,
 					     SD_BUF_SIZE,
 					     zno * sdkp->zone_blocks, true);
-		spin_lock_bh(&sdkp->zones_wp_offset_lock);
+		spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
 		if (!ret)
 			sd_zbc_parse_report(sdkp, sdkp->zone_wp_update_buf + 64,
 					    zno, sd_zbc_update_wp_offset_cb,
 					    sdkp);
 	}
-	spin_unlock_bh(&sdkp->zones_wp_offset_lock);
+	spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
 
 	scsi_device_put(sdkp->device);
 }
@@ -324,6 +325,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 	struct request *rq = cmd->request;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	unsigned int wp_offset, zno = blk_rq_zone_no(rq);
+	unsigned long flags;
 	blk_status_t ret;
 
 	ret = sd_zbc_cmnd_checks(cmd);
@@ -337,7 +339,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 	if (!blk_req_zone_write_trylock(rq))
 		return BLK_STS_ZONE_RESOURCE;
 
-	spin_lock_bh(&sdkp->zones_wp_offset_lock);
+	spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
 	wp_offset = sdkp->zones_wp_offset[zno];
 	switch (wp_offset) {
 	case SD_ZBC_INVALID_WP_OFST:
@@ -366,7 +368,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 
 		*lba += wp_offset;
 	}
-	spin_unlock_bh(&sdkp->zones_wp_offset_lock);
+	spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
 	if (ret)
 		blk_req_zone_write_unlock(rq);
 	return ret;
@@ -445,6 +447,7 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	unsigned int zno = blk_rq_zone_no(rq);
 	enum req_opf op = req_op(rq);
+	unsigned long flags;
 
 	/*
 	 * If we got an error for a command that needs updating the write
@@ -452,7 +455,7 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 	 * invalid to force an update from disk the next time a zone append
 	 * command is issued.
 	 */
-	spin_lock_bh(&sdkp->zones_wp_offset_lock);
+	spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
 
 	if (result && op != REQ_OP_ZONE_RESET_ALL) {
 		if (op == REQ_OP_ZONE_APPEND) {
@@ -496,7 +499,7 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 	}
 
 unlock_wp_offset:
-	spin_unlock_bh(&sdkp->zones_wp_offset_lock);
+	spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
 
 	return good_bytes;
 }
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 841ad2fc369a..9ca536aae784 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1269,8 +1269,8 @@ static int st_open(struct inode *inode, struct file *filp)
 	spin_lock(&st_use_lock);
 	if (STp->in_use) {
 		spin_unlock(&st_use_lock);
-		scsi_tape_put(STp);
 		DEBC_printk(STp, "Device already in use.\n");
+		scsi_tape_put(STp);
 		return (-EBUSY);
 	}
 
diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index c55202b92a43..a981f261b304 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -911,7 +911,7 @@ static void ufs_mtk_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
 	if (!hba->vreg_info.vccq2 || !hba->vreg_info.vcc)
 		return;
 
-	if (lpm & !hba->vreg_info.vcc->enabled)
+	if (lpm && !hba->vreg_info.vcc->enabled)
 		regulator_set_mode(hba->vreg_info.vccq2->reg,
 				   REGULATOR_MODE_IDLE);
 	else if (!lpm)

