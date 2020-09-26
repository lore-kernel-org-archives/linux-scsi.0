Return-Path: <SRS0=SrIF=DD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EDA0C4727E
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 16:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30FE32076D
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 16:20:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Ubq4BTgv";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="HMrGtvRs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbgIZQUx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Sep 2020 12:20:53 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60366 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725208AbgIZQUw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 26 Sep 2020 12:20:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 7F6978EEC00;
        Sat, 26 Sep 2020 09:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1601137251;
        bh=np14n02UPx7+mTcJvXlH10yq9AZTAssWo+9lzdCQ3Nc=;
        h=Subject:From:To:Cc:Date:From;
        b=Ubq4BTgvcqGikKftV0puSYI+YNllTEZUMWetb3fPPoahzAAUokZmi6LF6569k2xVs
         xMRI/EsO/8G0AvfiQywxfJfdTomEKt3TNSwMqLjoo+3qLASIW+W+EZw7+PYQxu0T2D
         zlrGUUQXV88LQTzWUv3hmqjNV3fWT35UQp8jGIbY=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id n_lvf0wezFSO; Sat, 26 Sep 2020 09:20:35 -0700 (PDT)
Received: from jarvis (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id D2E018EEBCA;
        Sat, 26 Sep 2020 09:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1601136300;
        bh=np14n02UPx7+mTcJvXlH10yq9AZTAssWo+9lzdCQ3Nc=;
        h=Subject:From:To:Cc:Date:From;
        b=HMrGtvRssUxA7kS3jiUBYI2rj6RX7JDcUZwO5//sAE6jkaUUo/QyAtJi20b5BNUyM
         TjgITjrhbvLjfxpfzc71A0ue5z3WvOkiShoX6zU7EoJBoIJmDiL0xJA5kj3kNJWS3E
         zvgaug767S0BwYpJ+qKcTATVWpe2+mnKRzOXv2rM=
Message-ID: <534da60ce3bf4c6e30071b721e9c08466e574f08.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.9-rc6
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 26 Sep 2020 09:04:58 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Three fixes: one in drivers (lpfc) and two for zoned block devices. 
The latter also impinges on the block layer but only to introduce a new
block API for setting the zone model rather than fiddling with the
queue directly in the zoned block driver.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Damien Le Moal (2):
      scsi: sd: sd_zbc: Fix ZBC disk initialization
      scsi: sd: sd_zbc: Fix handling of host-aware ZBC disks

James Smart (1):
      scsi: lpfc: Fix initial FLOGI failure due to BBSCN not supported

And the diffstat:

 block/blk-settings.c             | 46 ++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_hbadisc.c | 76 +++++++++++++++++++++++++++-------------
 drivers/scsi/sd.c                | 34 +++++++++---------
 drivers/scsi/sd.h                |  8 +----
 drivers/scsi/sd_zbc.c            | 66 ++++++++++++++++++++--------------
 include/linux/blkdev.h           |  2 ++
 6 files changed, 159 insertions(+), 73 deletions(-)

With full diff below.

James

---

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 76a7e03bcd6c..34b721a2743a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -801,6 +801,52 @@ bool blk_queue_can_use_dma_map_merging(struct request_queue *q,
 }
 EXPORT_SYMBOL_GPL(blk_queue_can_use_dma_map_merging);
 
+/**
+ * blk_queue_set_zoned - configure a disk queue zoned model.
+ * @disk:	the gendisk of the queue to configure
+ * @model:	the zoned model to set
+ *
+ * Set the zoned model of the request queue of @disk according to @model.
+ * When @model is BLK_ZONED_HM (host managed), this should be called only
+ * if zoned block device support is enabled (CONFIG_BLK_DEV_ZONED option).
+ * If @model specifies BLK_ZONED_HA (host aware), the effective model used
+ * depends on CONFIG_BLK_DEV_ZONED settings and on the existence of partitions
+ * on the disk.
+ */
+void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
+{
+	switch (model) {
+	case BLK_ZONED_HM:
+		/*
+		 * Host managed devices are supported only if
+		 * CONFIG_BLK_DEV_ZONED is enabled.
+		 */
+		WARN_ON_ONCE(!IS_ENABLED(CONFIG_BLK_DEV_ZONED));
+		break;
+	case BLK_ZONED_HA:
+		/*
+		 * Host aware devices can be treated either as regular block
+		 * devices (similar to drive managed devices) or as zoned block
+		 * devices to take advantage of the zone command set, similarly
+		 * to host managed devices. We try the latter if there are no
+		 * partitions and zoned block device support is enabled, else
+		 * we do nothing special as far as the block layer is concerned.
+		 */
+		if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) ||
+		    disk_has_partitions(disk))
+			model = BLK_ZONED_NONE;
+		break;
+	case BLK_ZONED_NONE:
+	default:
+		if (WARN_ON_ONCE(model != BLK_ZONED_NONE))
+			model = BLK_ZONED_NONE;
+		break;
+	}
+
+	disk->queue->limits.zoned = model;
+}
+EXPORT_SYMBOL_GPL(blk_queue_set_zoned);
+
 static int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 142a02114479..bf06d8549bd3 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -71,6 +71,7 @@ static void lpfc_disc_timeout_handler(struct lpfc_vport *);
 static void lpfc_disc_flush_list(struct lpfc_vport *vport);
 static void lpfc_unregister_fcfi_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 static int lpfc_fcf_inuse(struct lpfc_hba *);
+static void lpfc_mbx_cmpl_read_sparam(struct lpfc_hba *, LPFC_MBOXQ_t *);
 
 void
 lpfc_terminate_rport_io(struct fc_rport *rport)
@@ -1138,11 +1139,13 @@ lpfc_mbx_cmpl_clear_la(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	return;
 }
 
-
 void
 lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport *vport = pmb->vport;
+	LPFC_MBOXQ_t *sparam_mb;
+	struct lpfc_dmabuf *sparam_mp;
+	int rc;
 
 	if (pmb->u.mb.mbxStatus)
 		goto out;
@@ -1167,12 +1170,42 @@ lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	}
 
 	/* Start discovery by sending a FLOGI. port_state is identically
-	 * LPFC_FLOGI while waiting for FLOGI cmpl. Check if sending
-	 * the FLOGI is being deferred till after MBX_READ_SPARAM completes.
+	 * LPFC_FLOGI while waiting for FLOGI cmpl.
 	 */
 	if (vport->port_state != LPFC_FLOGI) {
-		if (!(phba->hba_flag & HBA_DEFER_FLOGI))
+		/* Issue MBX_READ_SPARAM to update CSPs before FLOGI if
+		 * bb-credit recovery is in place.
+		 */
+		if (phba->bbcredit_support && phba->cfg_enable_bbcr &&
+		    !(phba->link_flag & LS_LOOPBACK_MODE)) {
+			sparam_mb = mempool_alloc(phba->mbox_mem_pool,
+						  GFP_KERNEL);
+			if (!sparam_mb)
+				goto sparam_out;
+
+			rc = lpfc_read_sparam(phba, sparam_mb, 0);
+			if (rc) {
+				mempool_free(sparam_mb, phba->mbox_mem_pool);
+				goto sparam_out;
+			}
+			sparam_mb->vport = vport;
+			sparam_mb->mbox_cmpl = lpfc_mbx_cmpl_read_sparam;
+			rc = lpfc_sli_issue_mbox(phba, sparam_mb, MBX_NOWAIT);
+			if (rc == MBX_NOT_FINISHED) {
+				sparam_mp = (struct lpfc_dmabuf *)
+						sparam_mb->ctx_buf;
+				lpfc_mbuf_free(phba, sparam_mp->virt,
+					       sparam_mp->phys);
+				kfree(sparam_mp);
+				sparam_mb->ctx_buf = NULL;
+				mempool_free(sparam_mb, phba->mbox_mem_pool);
+				goto sparam_out;
+			}
+
+			phba->hba_flag |= HBA_DEFER_FLOGI;
+		}  else {
 			lpfc_initial_flogi(vport);
+		}
 	} else {
 		if (vport->fc_flag & FC_PT2PT)
 			lpfc_disc_start(vport);
@@ -1184,6 +1217,7 @@ lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			 "0306 CONFIG_LINK mbxStatus error x%x "
 			 "HBA state x%x\n",
 			 pmb->u.mb.mbxStatus, vport->port_state);
+sparam_out:
 	mempool_free(pmb, phba->mbox_mem_pool);
 
 	lpfc_linkdown(phba);
@@ -3239,21 +3273,6 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 	lpfc_linkup(phba);
 	sparam_mbox = NULL;
 
-	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
-		cfglink_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-		if (!cfglink_mbox)
-			goto out;
-		vport->port_state = LPFC_LOCAL_CFG_LINK;
-		lpfc_config_link(phba, cfglink_mbox);
-		cfglink_mbox->vport = vport;
-		cfglink_mbox->mbox_cmpl = lpfc_mbx_cmpl_local_config_link;
-		rc = lpfc_sli_issue_mbox(phba, cfglink_mbox, MBX_NOWAIT);
-		if (rc == MBX_NOT_FINISHED) {
-			mempool_free(cfglink_mbox, phba->mbox_mem_pool);
-			goto out;
-		}
-	}
-
 	sparam_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!sparam_mbox)
 		goto out;
@@ -3274,7 +3293,20 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 		goto out;
 	}
 
-	if (phba->hba_flag & HBA_FCOE_MODE) {
+	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
+		cfglink_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+		if (!cfglink_mbox)
+			goto out;
+		vport->port_state = LPFC_LOCAL_CFG_LINK;
+		lpfc_config_link(phba, cfglink_mbox);
+		cfglink_mbox->vport = vport;
+		cfglink_mbox->mbox_cmpl = lpfc_mbx_cmpl_local_config_link;
+		rc = lpfc_sli_issue_mbox(phba, cfglink_mbox, MBX_NOWAIT);
+		if (rc == MBX_NOT_FINISHED) {
+			mempool_free(cfglink_mbox, phba->mbox_mem_pool);
+			goto out;
+		}
+	} else {
 		vport->port_state = LPFC_VPORT_UNKNOWN;
 		/*
 		 * Add the driver's default FCF record at FCF index 0 now. This
@@ -3331,10 +3363,6 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 		}
 		/* Reset FCF roundrobin bmask for new discovery */
 		lpfc_sli4_clear_fcf_rr_bmask(phba);
-	} else {
-		if (phba->bbcredit_support && phba->cfg_enable_bbcr &&
-		    !(phba->link_flag & LS_LOOPBACK_MODE))
-			phba->hba_flag |= HBA_DEFER_FLOGI;
 	}
 
 	/* Prepare for LINK up registrations */
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 95018e650f2d..16503e22691e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2964,26 +2964,32 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 
 	if (sdkp->device->type == TYPE_ZBC) {
 		/* Host-managed */
-		q->limits.zoned = BLK_ZONED_HM;
+		blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HM);
 	} else {
 		sdkp->zoned = (buffer[8] >> 4) & 3;
-		if (sdkp->zoned == 1 && !disk_has_partitions(sdkp->disk)) {
+		if (sdkp->zoned == 1) {
 			/* Host-aware */
-			q->limits.zoned = BLK_ZONED_HA;
+			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HA);
 		} else {
-			/*
-			 * Treat drive-managed devices and host-aware devices
-			 * with partitions as regular block devices.
-			 */
-			q->limits.zoned = BLK_ZONED_NONE;
-			if (sdkp->zoned == 2 && sdkp->first_scan)
-				sd_printk(KERN_NOTICE, sdkp,
-					  "Drive-managed SMR disk\n");
+			/* Regular disk or drive managed disk */
+			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_NONE);
 		}
 	}
-	if (blk_queue_is_zoned(q) && sdkp->first_scan)
+
+	if (!sdkp->first_scan)
+		goto out;
+
+	if (blk_queue_is_zoned(q)) {
 		sd_printk(KERN_NOTICE, sdkp, "Host-%s zoned block device\n",
 		      q->limits.zoned == BLK_ZONED_HM ? "managed" : "aware");
+	} else {
+		if (sdkp->zoned == 1)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Host-aware SMR disk used as regular disk\n");
+		else if (sdkp->zoned == 2)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Drive-managed SMR disk\n");
+	}
 
  out:
 	kfree(buffer);
@@ -3404,10 +3410,6 @@ static int sd_probe(struct device *dev)
 	sdkp->first_scan = 1;
 	sdkp->max_medium_access_timeouts = SD_MAX_MEDIUM_TIMEOUTS;
 
-	error = sd_zbc_init_disk(sdkp);
-	if (error)
-		goto out_free_index;
-
 	sd_revalidate_disk(gd);
 
 	gd->flags = GENHD_FL_EXT_DEVT;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 4933e7daf17d..a3aad608bc38 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -215,7 +215,6 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
 
 #ifdef CONFIG_BLK_DEV_ZONED
 
-int sd_zbc_init_disk(struct scsi_disk *sdkp);
 void sd_zbc_release_disk(struct scsi_disk *sdkp);
 int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
 int sd_zbc_revalidate_zones(struct scsi_disk *sdkp);
@@ -231,11 +230,6 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 
 #else /* CONFIG_BLK_DEV_ZONED */
 
-static inline int sd_zbc_init_disk(struct scsi_disk *sdkp)
-{
-	return 0;
-}
-
 static inline void sd_zbc_release_disk(struct scsi_disk *sdkp) {}
 
 static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
@@ -259,7 +253,7 @@ static inline blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
 static inline unsigned int sd_zbc_complete(struct scsi_cmnd *cmd,
 			unsigned int good_bytes, struct scsi_sense_hdr *sshdr)
 {
-	return 0;
+	return good_bytes;
 }
 
 static inline blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd,
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 0e94ff056bff..cf07b7f93579 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -651,6 +651,28 @@ static void sd_zbc_print_zones(struct scsi_disk *sdkp)
 			  sdkp->zone_blocks);
 }
 
+static int sd_zbc_init_disk(struct scsi_disk *sdkp)
+{
+	sdkp->zones_wp_offset = NULL;
+	spin_lock_init(&sdkp->zones_wp_offset_lock);
+	sdkp->rev_wp_offset = NULL;
+	mutex_init(&sdkp->rev_mutex);
+	INIT_WORK(&sdkp->zone_wp_offset_work, sd_zbc_update_wp_offset_workfn);
+	sdkp->zone_wp_update_buf = kzalloc(SD_BUF_SIZE, GFP_KERNEL);
+	if (!sdkp->zone_wp_update_buf)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void sd_zbc_release_disk(struct scsi_disk *sdkp)
+{
+	kvfree(sdkp->zones_wp_offset);
+	sdkp->zones_wp_offset = NULL;
+	kfree(sdkp->zone_wp_update_buf);
+	sdkp->zone_wp_update_buf = NULL;
+}
+
 static void sd_zbc_revalidate_zones_cb(struct gendisk *disk)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
@@ -667,7 +689,24 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	u32 max_append;
 	int ret = 0;
 
-	if (!sd_is_zoned(sdkp))
+	/*
+	 * For all zoned disks, initialize zone append emulation data if not
+	 * already done. This is necessary also for host-aware disks used as
+	 * regular disks due to the presence of partitions as these partitions
+	 * may be deleted and the disk zoned model changed back from
+	 * BLK_ZONED_NONE to BLK_ZONED_HA.
+	 */
+	if (sd_is_zoned(sdkp) && !sdkp->zone_wp_update_buf) {
+		ret = sd_zbc_init_disk(sdkp);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * There is nothing to do for regular disks, including host-aware disks
+	 * that have partitions.
+	 */
+	if (!blk_queue_is_zoned(q))
 		return 0;
 
 	/*
@@ -764,28 +803,3 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 
 	return ret;
 }
-
-int sd_zbc_init_disk(struct scsi_disk *sdkp)
-{
-	if (!sd_is_zoned(sdkp))
-		return 0;
-
-	sdkp->zones_wp_offset = NULL;
-	spin_lock_init(&sdkp->zones_wp_offset_lock);
-	sdkp->rev_wp_offset = NULL;
-	mutex_init(&sdkp->rev_mutex);
-	INIT_WORK(&sdkp->zone_wp_offset_work, sd_zbc_update_wp_offset_workfn);
-	sdkp->zone_wp_update_buf = kzalloc(SD_BUF_SIZE, GFP_KERNEL);
-	if (!sdkp->zone_wp_update_buf)
-		return -ENOMEM;
-
-	return 0;
-}
-
-void sd_zbc_release_disk(struct scsi_disk *sdkp)
-{
-	kvfree(sdkp->zones_wp_offset);
-	sdkp->zones_wp_offset = NULL;
-	kfree(sdkp->zone_wp_update_buf);
-	sdkp->zone_wp_update_buf = NULL;
-}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bb5636cc17b9..868e11face00 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -352,6 +352,8 @@ struct queue_limits {
 typedef int (*report_zones_cb)(struct blk_zone *zone, unsigned int idx,
 			       void *data);
 
+void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model);
+
 #ifdef CONFIG_BLK_DEV_ZONED
 
 #define BLK_ALL_ZONES  ((unsigned int)-1)

