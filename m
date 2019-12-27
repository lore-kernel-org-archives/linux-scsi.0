Return-Path: <SRS0=4AUr=2R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DA8C2D0CE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Dec 2019 22:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E099222C4
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Dec 2019 22:57:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ccim0X8M";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ADWlHYhP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfL0W5K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Dec 2019 17:57:10 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36010 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbfL0W5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Dec 2019 17:57:10 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 38B718EE10C;
        Fri, 27 Dec 2019 14:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1577487430;
        bh=K+tf+8cWkcZ4RMhGp2HRRSr87o8eRXh1u1OgW1IKsdM=;
        h=Subject:From:To:Cc:Date:From;
        b=ccim0X8MD/TuGqEwu5dhTt2HJ8RKOLNBI766A6L+eSa/aRxY3MV4ltdzzlfMl9lZA
         K0aYPp7F1i+grf6gu7eHzpl2TjnPrEwpvEj3P3CbsGCgSNc+IBoymCHZFHEjnKkkEL
         AUZcTXMCZo9Dzj0HNut34IJ2eexOF14AVQII4294=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 49W62Kp4joOS; Fri, 27 Dec 2019 14:57:10 -0800 (PST)
Received: from jarvis.lan (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id B31A58EE0E9;
        Fri, 27 Dec 2019 14:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1577487429;
        bh=K+tf+8cWkcZ4RMhGp2HRRSr87o8eRXh1u1OgW1IKsdM=;
        h=Subject:From:To:Cc:Date:From;
        b=ADWlHYhPbI2UtW58EuEceEALpxnFX2bzDH6jYLZm2Xtgyymv4vRuFETfdiLAxb10O
         Mla/Aa/AJlWyEMWnW2HwbXjvljzL+7NSJVMvIBrGbma/p3iA4dki/fu7QxFOcmQbgx
         MyeQ5hpfCSXCBgNNflWRn1ykzJ8vdRLuqvDwigkg=
Message-ID: <1577487428.3225.6.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.5-rc3
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 27 Dec 2019 14:57:08 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Four fixes and one spelling update, all in drivers: 2 in lpfc and the
rest in mp3sas, cxgbi and target.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arnd Bergmann (1):
      scsi: lpfc: fix build failure with DEBUGFS disabled

Colin Ian King (1):
      scsi: lpfc: fix spelling mistakes of asynchronous

Dan Carpenter (1):
      scsi: mpt3sas: Fix double free in attach error handling

Israel Rukshin (1):
      scsi: target/iblock: Fix protection error with blocks greater than 512B

Varun Prakash (1):
      scsi: libcxgbi: fix NULL pointer dereference in cxgbi_device_destroy()

And the diffstat:

 drivers/scsi/cxgbi/libcxgbi.c       |  3 ++-
 drivers/scsi/lpfc/lpfc_debugfs.c    |  3 +--
 drivers/scsi/lpfc/lpfc_init.c       |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c        | 10 +++++-----
 drivers/scsi/mpt3sas/mpt3sas_base.c |  1 -
 drivers/target/target_core_iblock.c |  4 +++-
 6 files changed, 12 insertions(+), 11 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 0d044c165960..dc9320f37ebf 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -121,7 +121,8 @@ static inline void cxgbi_device_destroy(struct cxgbi_device *cdev)
 		"cdev 0x%p, p# %u.\n", cdev, cdev->nports);
 	cxgbi_hbas_remove(cdev);
 	cxgbi_device_portmap_cleanup(cdev);
-	cxgbi_ppm_release(cdev->cdev2ppm(cdev));
+	if (cdev->cdev2ppm)
+		cxgbi_ppm_release(cdev->cdev2ppm(cdev));
 	if (cdev->pmap.max_connect)
 		cxgbi_free_big_mem(cdev->pmap.port_csk);
 	kfree(cdev);
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 2e6a68d9ea4f..a5ecbce4eda2 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -5385,7 +5385,6 @@ static const struct file_operations lpfc_debugfs_ras_log = {
 	.read =         lpfc_debugfs_read,
 	.release =      lpfc_debugfs_ras_log_release,
 };
-#endif
 
 #undef lpfc_debugfs_op_dumpHBASlim
 static const struct file_operations lpfc_debugfs_op_dumpHBASlim = {
@@ -5557,7 +5556,7 @@ static const struct file_operations lpfc_idiag_op_extAcc = {
 	.write =        lpfc_idiag_extacc_write,
 	.release =      lpfc_idiag_cmd_release,
 };
-
+#endif
 
 /* lpfc_idiag_mbxacc_dump_bsg_mbox - idiag debugfs dump bsg mailbox command
  * @phba: Pointer to HBA context object.
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6298b1729098..6a04fdb3fbf2 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5883,7 +5883,7 @@ void lpfc_sli4_async_event_proc(struct lpfc_hba *phba)
 			break;
 		default:
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-					"1804 Invalid asynchrous event code: "
+					"1804 Invalid asynchronous event code: "
 					"x%x\n", bf_get(lpfc_trailer_code,
 					&cq_event->cqe.mcqe_cmpl));
 			break;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c82b5792da98..625c046ac4ef 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8555,7 +8555,7 @@ lpfc_sli4_async_mbox_unblock(struct lpfc_hba *phba)
 	psli->sli_flag &= ~LPFC_SLI_ASYNC_MBX_BLK;
 	spin_unlock_irq(&phba->hbalock);
 
-	/* wake up worker thread to post asynchronlous mailbox command */
+	/* wake up worker thread to post asynchronous mailbox command */
 	lpfc_worker_wake_up(phba);
 }
 
@@ -8823,7 +8823,7 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 		return rc;
 	}
 
-	/* Now, interrupt mode asynchrous mailbox command */
+	/* Now, interrupt mode asynchronous mailbox command */
 	rc = lpfc_mbox_cmd_check(phba, mboxq);
 	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
@@ -13112,11 +13112,11 @@ lpfc_cq_event_setup(struct lpfc_hba *phba, void *entry, int size)
 }
 
 /**
- * lpfc_sli4_sp_handle_async_event - Handle an asynchroous event
+ * lpfc_sli4_sp_handle_async_event - Handle an asynchronous event
  * @phba: Pointer to HBA context object.
  * @cqe: Pointer to mailbox completion queue entry.
  *
- * This routine process a mailbox completion queue entry with asynchrous
+ * This routine process a mailbox completion queue entry with asynchronous
  * event.
  *
  * Return: true if work posted to worker thread, otherwise false.
@@ -13270,7 +13270,7 @@ lpfc_sli4_sp_handle_mbox_event(struct lpfc_hba *phba, struct lpfc_mcqe *mcqe)
  * @cqe: Pointer to mailbox completion queue entry.
  *
  * This routine process a mailbox completion queue entry, it invokes the
- * proper mailbox complete handling or asynchrous event handling routine
+ * proper mailbox complete handling or asynchronous event handling routine
  * according to the MCQE's async bit.
  *
  * Return: true if work posted to worker thread, otherwise false.
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 848fbec7bda6..45fd8dfb7c40 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5248,7 +5248,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 					&ct->chain_buffer_dma);
 			if (!ct->chain_buffer) {
 				ioc_err(ioc, "chain_lookup: pci_pool_alloc failed\n");
-				_base_release_memory_pools(ioc);
 				goto out;
 			}
 		}
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 6949ea8bc387..51ffd5c002de 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -646,7 +646,9 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
 	}
 
 	bip->bip_iter.bi_size = bio_integrity_bytes(bi, bio_sectors(bio));
-	bip_set_seed(bip, bio->bi_iter.bi_sector);
+	/* virtual start sector must be in integrity interval units */
+	bip_set_seed(bip, bio->bi_iter.bi_sector >>
+				  (bi->interval_exp - SECTOR_SHIFT));
 
 	pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_size,
 		 (unsigned long long)bip->bip_iter.bi_sector);
