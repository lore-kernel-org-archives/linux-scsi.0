From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 23/28] be2iscsi: Fail the sessions immediately after TPE
Date: Thu, 21 Jul 2016 14:38:00 +0530
Message-ID: <1469092085-14311-24-git-send-email-jitendra.bhivare@broadcom.com>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36594 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbcGUJJi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2016 05:09:38 -0400
Received: by mail-wm0-f54.google.com with SMTP id q128so14832747wma.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 02:09:37 -0700 (PDT)
In-Reply-To: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Sessions are no longer valid, so schedule sess_work to fail the sessions
immediately when error is detected. This is done to avoid iSCSI transport
layer to keep sending NOP-Out which driver any ways fail.

Schedule sess_work immediately in case of HBA error. Old sessions are gone
for good and need to be re-established.

iscsi_session_failure needs process context hence this work.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 24 +++++++++++++++++++++---
 drivers/scsi/be2iscsi/be_main.h |  1 +
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index a930358..29d5291 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5407,7 +5407,10 @@ static void beiscsi_hw_health_check(unsigned long ptr)
 	if (beiscsi_detect_ue(phba)) {
 		__beiscsi_log(phba, KERN_ERR,
 			      "BM_%d : port in error: %lx\n", phba->state);
-		/* detect TPE if UER supported */
+		/* sessions are no longer valid, so first fail the sessions */
+		queue_work(phba->wq, &phba->sess_work);
+
+		/* detect UER supported */
 		if (!test_bit(BEISCSI_HBA_UER_SUPP, &phba->state))
 			return;
 		/* modify this timer to check TPE */
@@ -5571,12 +5574,24 @@ static void beiscsi_disable_port(struct beiscsi_hba *phba, int unload)
 	hwi_cleanup_port(phba);
 }
 
+static void beiscsi_sess_work(struct work_struct *work)
+{
+	struct beiscsi_hba *phba;
+
+	phba = container_of(work, struct beiscsi_hba, sess_work);
+	/*
+	 * This work gets scheduled only in case of HBA error.
+	 * Old sessions are gone so need to be re-established.
+	 * iscsi_session_failure needs process context hence this work.
+	 */
+	iscsi_host_for_each_session(phba->shost, beiscsi_session_fail);
+}
+
 static void beiscsi_recover_port(struct work_struct *work)
 {
 	struct beiscsi_hba *phba;
 
 	phba = container_of(work, struct beiscsi_hba, recover_port.work);
-	iscsi_host_for_each_session(phba->shost, beiscsi_session_fail);
 	beiscsi_disable_port(phba, 0);
 	beiscsi_enable_port(phba);
 }
@@ -5596,6 +5611,8 @@ static pci_ers_result_t beiscsi_eeh_err_detected(struct pci_dev *pdev,
 	del_timer_sync(&phba->hw_check);
 	cancel_delayed_work_sync(&phba->recover_port);
 
+	/* sessions are no longer valid, so first fail the sessions */
+	iscsi_host_for_each_session(phba->shost, beiscsi_session_fail);
 	beiscsi_disable_port(phba, 0);
 
 	if (state == pci_channel_io_perm_failure) {
@@ -5841,6 +5858,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	schedule_delayed_work(&phba->eqd_update,
 			      msecs_to_jiffies(BEISCSI_EQD_UPDATE_INTERVAL));
 
+	INIT_WORK(&phba->sess_work, beiscsi_sess_work);
 	INIT_DELAYED_WORK(&phba->recover_port, beiscsi_recover_port);
 	/**
 	 * Start UE detection here. UE before this will cause stall in probe
@@ -5851,7 +5869,6 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	phba->hw_check.data = (unsigned long)phba;
 	mod_timer(&phba->hw_check,
 		  jiffies + msecs_to_jiffies(BEISCSI_UE_DETECT_INTERVAL));
-
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
 		    "\n\n\n BM_%d : SUCCESS - DRIVER LOADED\n\n\n");
 	return 0;
@@ -5897,6 +5914,7 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 	/* first stop UE detection before unloading */
 	del_timer_sync(&phba->hw_check);
 	cancel_delayed_work_sync(&phba->recover_port);
+	cancel_work_sync(&phba->sess_work);
 
 	beiscsi_iface_destroy_default(phba);
 	iscsi_host_remove(phba->shost);
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 1fd6c18..953d94a 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -418,6 +418,7 @@ struct beiscsi_hba {
 #define BEISCSI_UE_DETECT_INTERVAL	1000
 	u32 ue2rp;
 	struct delayed_work recover_port;
+	struct work_struct sess_work;
 
 	bool mac_addr_set;
 	u8 mac_address[ETH_ALEN];
-- 
1.9.1

