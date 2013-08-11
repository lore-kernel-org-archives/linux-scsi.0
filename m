From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.11-rc4
Date: Sun, 11 Aug 2013 14:13:11 -0700
Message-ID: <1376255591.17400.37.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50872 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754843Ab3HKVNN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Aug 2013 17:13:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is three bug fixes: An fnic warning caused by sleeping under a
lock, a major regression with our updated WRITE SAME/UNMAP logic which
caused tons of USB devices (and one RAID card) to cease to function and
a megaraid_sas firmware initialisation problem which causes kdump
failures.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Chris Leech (1):
      fnic: BUG: sleeping function called from invalid context during probe

Martin K. Petersen (1):
      Don't attempt to send extended INQUIRY command if skip_vpd_pages is set

Sumit.Saxena@lsi.com (1):
      megaraid_sas: megaraid_sas driver init fails in kdump kernel

The diffstat is:

 drivers/scsi/fnic/fnic.h                  |  2 +-
 drivers/scsi/fnic/fnic_main.c             | 22 +++++++++-------------
 drivers/scsi/megaraid/megaraid_sas_base.c | 20 +++++++++++++++-----
 drivers/scsi/scsi.c                       |  3 +++
 4 files changed, 28 insertions(+), 19 deletions(-)

And the full diff is attached below.

James

---

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index b6d1f92..c18c681 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -38,7 +38,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.5.0.22"
+#define DRV_VERSION		"1.5.0.23"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 5f09d18..42e15ee 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -642,19 +642,6 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		INIT_WORK(&fnic->fip_frame_work, fnic_handle_fip_frame);
 		INIT_WORK(&fnic->event_work, fnic_handle_event);
 		skb_queue_head_init(&fnic->fip_frame_queue);
-		spin_lock_irqsave(&fnic_list_lock, flags);
-		if (!fnic_fip_queue) {
-			fnic_fip_queue =
-				create_singlethread_workqueue("fnic_fip_q");
-			if (!fnic_fip_queue) {
-				spin_unlock_irqrestore(&fnic_list_lock, flags);
-				printk(KERN_ERR PFX "fnic FIP work queue "
-						 "create failed\n");
-				err = -ENOMEM;
-				goto err_out_free_max_pool;
-			}
-		}
-		spin_unlock_irqrestore(&fnic_list_lock, flags);
 		INIT_LIST_HEAD(&fnic->evlist);
 		INIT_LIST_HEAD(&fnic->vlans);
 	} else {
@@ -960,6 +947,13 @@ static int __init fnic_init_module(void)
 	spin_lock_init(&fnic_list_lock);
 	INIT_LIST_HEAD(&fnic_list);
 
+	fnic_fip_queue = create_singlethread_workqueue("fnic_fip_q");
+	if (!fnic_fip_queue) {
+		printk(KERN_ERR PFX "fnic FIP work queue create failed\n");
+		err = -ENOMEM;
+		goto err_create_fip_workq;
+	}
+
 	fnic_fc_transport = fc_attach_transport(&fnic_fc_functions);
 	if (!fnic_fc_transport) {
 		printk(KERN_ERR PFX "fc_attach_transport error\n");
@@ -978,6 +972,8 @@ static int __init fnic_init_module(void)
 err_pci_register:
 	fc_release_transport(fnic_fc_transport);
 err_fc_transport:
+	destroy_workqueue(fnic_fip_queue);
+err_create_fip_workq:
 	destroy_workqueue(fnic_event_queue);
 err_create_fnic_workq:
 	kmem_cache_destroy(fnic_io_req_cache);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 0177295..1f0ca68 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3547,11 +3547,21 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		break;
 	}
 
-	/*
-	 * We expect the FW state to be READY
-	 */
-	if (megasas_transition_to_ready(instance, 0))
-		goto fail_ready_state;
+	if (megasas_transition_to_ready(instance, 0)) {
+		atomic_set(&instance->fw_reset_no_pci_access, 1);
+		instance->instancet->adp_reset
+			(instance, instance->reg_set);
+		atomic_set(&instance->fw_reset_no_pci_access, 0);
+		dev_info(&instance->pdev->dev,
+			"megasas: FW restarted successfully from %s!\n",
+			__func__);
+
+		/*waitting for about 30 second before retry*/
+		ssleep(30);
+
+		if (megasas_transition_to_ready(instance, 0))
+			goto fail_ready_state;
+	}
 
 	/*
 	 * MSI-X host index 0 is common for all adapter.
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3b1ea34..eaa808e 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1031,6 +1031,9 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 {
 	int i, result;
 
+	if (sdev->skip_vpd_pages)
+		goto fail;
+
 	/* Ask for all the pages supported by this device */
 	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
 	if (result)


