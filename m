Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA4EC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 17:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83E4A206D7
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 17:35:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="np7mfgjw";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="np7mfgjw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgF0Rf0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 13:35:26 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58380 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725932AbgF0Rf0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 27 Jun 2020 13:35:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id C991C8EE13D;
        Sat, 27 Jun 2020 10:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1593279325;
        bh=CAqv7UAzSIvMRORrnIhtD30lRQySqjn7wSDPDhEoRfk=;
        h=Subject:From:To:Cc:Date:From;
        b=np7mfgjwctXCdyc0Rff44c2rrlR5GRlfD/GEnpV/JxyYS9Ki9iyeQwavXUJ8CsLZ0
         fsHrTeLxHdx+YjbZ6FPWvvflejqPoidoZhgWFUH54RvC0IkG5/b43ng+eMM7kjsuhu
         XA/e36H/yNacJtuC+5UgOOZa/Xz2EmgMDUIJorNg=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZekNd-Fia26I; Sat, 27 Jun 2020 10:35:25 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 1C99F8EE07B;
        Sat, 27 Jun 2020 10:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1593279325;
        bh=CAqv7UAzSIvMRORrnIhtD30lRQySqjn7wSDPDhEoRfk=;
        h=Subject:From:To:Cc:Date:From;
        b=np7mfgjwctXCdyc0Rff44c2rrlR5GRlfD/GEnpV/JxyYS9Ki9iyeQwavXUJ8CsLZ0
         fsHrTeLxHdx+YjbZ6FPWvvflejqPoidoZhgWFUH54RvC0IkG5/b43ng+eMM7kjsuhu
         XA/e36H/yNacJtuC+5UgOOZa/Xz2EmgMDUIJorNg=
Message-ID: <1593279324.11424.5.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.8-rc2
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 27 Jun 2020 10:35:24 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Six small fixes, five in drivers and one to correct another minor
regression from cc97923a5bcc ("block: move dma drain handling to scsi")
where we still need the drain stub to be built in to the kernel for the
modular libata, non-modular SAS driver case.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Christoph Hellwig (1):
      scsi: libata: Fix the ata_scsi_dma_need_drain stub

Daniel Wagner (1):
      scsi: qla2xxx: Set NVMe status code for failed NVMe FCP request

Roman Bolshakov (1):
      scsi: qla2xxx: Keep initiator ports after RSCN

SeongJae Park (1):
      scsi: lpfc: Avoid another null dereference in lpfc_sli4_hba_unset()

Steffen Maier (1):
      scsi: zfcp: Fix panic on ERP timeout for previously dismissed ERP action

Tomas Henzl (1):
      scsi: mptscsih: Fix read sense data size

And the diffstat:

 drivers/message/fusion/mptscsih.c |  4 +---
 drivers/s390/scsi/zfcp_erp.c      | 13 +++++++++++--
 drivers/scsi/lpfc/lpfc_init.c     |  3 ++-
 drivers/scsi/qla2xxx/qla_gs.c     |  4 +++-
 drivers/scsi/qla2xxx/qla_nvme.c   |  3 ++-
 include/linux/libata.h            |  2 +-
 6 files changed, 20 insertions(+), 9 deletions(-)

With full diff below.

James

---

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index f0737c57ed5f..1491561d2e5c 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -118,8 +118,6 @@ int 		mptscsih_suspend(struct pci_dev *pdev, pm_message_t state);
 int 		mptscsih_resume(struct pci_dev *pdev);
 #endif
 
-#define SNS_LEN(scp)	SCSI_SENSE_BUFFERSIZE
-
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
@@ -2422,7 +2420,7 @@ mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR
 		/* Copy the sense received into the scsi command block. */
 		req_index = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
 		sense_data = ((u8 *)ioc->sense_buf_pool + (req_index * MPT_SENSE_BUFFER_ALLOC));
-		memcpy(sc->sense_buffer, sense_data, SNS_LEN(sc));
+		memcpy(sc->sense_buffer, sense_data, MPT_SENSE_BUFFER_ALLOC);
 
 		/* Log SMART data (asc = 0x5D, non-IM case only) if required.
 		 */
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index db320dab1fee..79f6e8fb03ca 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -577,7 +577,10 @@ static void zfcp_erp_strategy_check_fsfreq(struct zfcp_erp_action *act)
 				   ZFCP_STATUS_ERP_TIMEDOUT)) {
 			req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
 			zfcp_dbf_rec_run("erscf_1", act);
-			req->erp_action = NULL;
+			/* lock-free concurrent access with
+			 * zfcp_erp_timeout_handler()
+			 */
+			WRITE_ONCE(req->erp_action, NULL);
 		}
 		if (act->status & ZFCP_STATUS_ERP_TIMEDOUT)
 			zfcp_dbf_rec_run("erscf_2", act);
@@ -613,8 +616,14 @@ void zfcp_erp_notify(struct zfcp_erp_action *erp_action, unsigned long set_mask)
 void zfcp_erp_timeout_handler(struct timer_list *t)
 {
 	struct zfcp_fsf_req *fsf_req = from_timer(fsf_req, t, timer);
-	struct zfcp_erp_action *act = fsf_req->erp_action;
+	struct zfcp_erp_action *act;
 
+	if (fsf_req->status & ZFCP_STATUS_FSFREQ_DISMISSED)
+		return;
+	/* lock-free concurrent access with zfcp_erp_strategy_check_fsfreq() */
+	act = READ_ONCE(fsf_req->erp_action);
+	if (!act)
+		return;
 	zfcp_erp_notify(act, ZFCP_STATUS_ERP_TIMEDOUT);
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 69a5249e007a..6637f84a3d1b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11878,7 +11878,8 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 	lpfc_sli4_xri_exchange_busy_wait(phba);
 
 	/* per-phba callback de-registration for hotplug event */
-	lpfc_cpuhp_remove(phba);
+	if (phba->pport)
+		lpfc_cpuhp_remove(phba);
 
 	/* Disable PCI subsystem interrupt */
 	lpfc_sli4_disable_intr(phba);
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 42c3ad27f1cb..df670fba2ab8 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3496,7 +3496,9 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 				qla2x00_clear_loop_id(fcport);
 				fcport->flags |= FCF_FABRIC_DEVICE;
 			} else if (fcport->d_id.b24 != rp->id.b24 ||
-				fcport->scan_needed) {
+				   (fcport->scan_needed &&
+				    fcport->port_type != FCT_INITIATOR &&
+				    fcport->port_type != FCT_NVME_INITIATOR)) {
 				qlt_schedule_sess_for_deletion(fcport);
 			}
 			fcport->d_id.b24 = rp->id.b24;
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index d66d47a0f958..fa695a4007f8 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -139,11 +139,12 @@ static void qla_nvme_release_fcp_cmd_kref(struct kref *kref)
 	sp->priv = NULL;
 	if (priv->comp_status == QLA_SUCCESS) {
 		fd->rcv_rsplen = le16_to_cpu(nvme->u.nvme.rsp_pyld_len);
+		fd->status = NVME_SC_SUCCESS;
 	} else {
 		fd->rcv_rsplen = 0;
 		fd->transferred_length = 0;
+		fd->status = NVME_SC_INTERNAL;
 	}
-	fd->status = 0;
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
 	fd->done(fd);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 042e584daca7..c57bf6749681 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1092,7 +1092,7 @@ extern int ata_scsi_ioctl(struct scsi_device *dev, unsigned int cmd,
 #define ATA_SCSI_COMPAT_IOCTL /* empty */
 #endif
 extern int ata_scsi_queuecmd(struct Scsi_Host *h, struct scsi_cmnd *cmd);
-#if IS_ENABLED(CONFIG_ATA)
+#if IS_REACHABLE(CONFIG_ATA)
 bool ata_scsi_dma_need_drain(struct request *rq);
 #else
 #define ata_scsi_dma_need_drain NULL
