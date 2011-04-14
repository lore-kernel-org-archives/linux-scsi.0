From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH] bfa: Move debugfs initialization before bfa init.
Date: Thu, 14 Apr 2011 16:50:35 -0700
Message-ID: <1302825035-353-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:45043 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752674Ab1DOASq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2011 20:18:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Move the initialization of debugfs before bfa init, to enable
	  us to collect driver/firmware traces if init fails.
	- Add a printk to display message on bfa_init failure.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfad.c         |   22 ++++++++++++++--------
 drivers/scsi/bfa/bfad_debugfs.c |   33 +++++++++++++--------------------
 2 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index d9360bf..59b5e9b 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -232,6 +232,9 @@ bfad_sm_created(struct bfad_s *bfad, enum bfad_sm_event event)
 		if ((bfad->bfad_flags & BFAD_HAL_INIT_DONE)) {
 			bfa_sm_send_event(bfad, BFAD_E_INIT_SUCCESS);
 		} else {
+			printk(KERN_WARNING
+				"bfa %s: bfa init failed\n",
+				bfad->pci_name);
 			bfad->bfad_flags |= BFAD_HAL_INIT_FAIL;
 			bfa_sm_send_event(bfad, BFAD_E_INIT_FAILED);
 		}
@@ -1001,10 +1004,6 @@ bfad_cfg_pport(struct bfad_s *bfad, enum bfa_lport_role role)
 		bfad->pport.roles |= BFA_LPORT_ROLE_FCP_IM;
 	}
 
-	/* Setup the debugfs node for this scsi_host */
-	if (bfa_debugfs_enable)
-		bfad_debugfs_init(&bfad->pport);
-
 	bfad->bfad_flags |= BFAD_CFG_PPORT_DONE;
 
 out:
@@ -1014,10 +1013,6 @@ out:
 void
 bfad_uncfg_pport(struct bfad_s *bfad)
 {
-	/* Remove the debugfs node for this scsi_host */
-	kfree(bfad->regdata);
-	bfad_debugfs_exit(&bfad->pport);
-
 	if ((supported_fc4s & BFA_LPORT_ROLE_FCP_IM) &&
 	    (bfad->pport.roles & BFA_LPORT_ROLE_FCP_IM)) {
 		bfad_im_scsi_host_free(bfad, bfad->pport.im_port);
@@ -1399,6 +1394,10 @@ bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid)
 	bfad->pport.bfad = bfad;
 	INIT_LIST_HEAD(&bfad->pbc_vport_list);
 
+	/* Setup the debugfs node for this bfad */
+	if (bfa_debugfs_enable)
+		bfad_debugfs_init(&bfad->pport);
+
 	retval = bfad_drv_init(bfad);
 	if (retval != BFA_STATUS_OK)
 		goto out_drv_init_failure;
@@ -1414,6 +1413,9 @@ out_bfad_sm_failure:
 	bfa_detach(&bfad->bfa);
 	bfad_hal_mem_release(bfad);
 out_drv_init_failure:
+	/* Remove the debugfs node for this bfad */
+	kfree(bfad->regdata);
+	bfad_debugfs_exit(&bfad->pport);
 	mutex_lock(&bfad_mutex);
 	bfad_inst--;
 	list_del(&bfad->list_entry);
@@ -1455,6 +1457,10 @@ bfad_pci_remove(struct pci_dev *pdev)
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 	bfad_hal_mem_release(bfad);
 
+	/* Remove the debugfs node for this bfad */
+	kfree(bfad->regdata);
+	bfad_debugfs_exit(&bfad->pport);
+
 	/* Cleaning the BFAD instance */
 	mutex_lock(&bfad_mutex);
 	bfad_inst--;
diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index c66e32e..48be0c5 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -28,10 +28,10 @@
  * mount -t debugfs none /sys/kernel/debug
  *
  * BFA Hierarchy:
- *	- bfa/host#
- * where the host number corresponds to the one under /sys/class/scsi_host/host#
+ *	- bfa/pci_dev:<pci_name>
+ * where the pci_name corresponds to the one under /sys/bus/pci/drivers/bfa
  *
- * Debugging service available per host:
+ * Debugging service available per pci_dev:
  * fwtrc:  To collect current firmware trace.
  * drvtrc: To collect current driver trace
  * fwsave: To collect last saved fw trace as a result of firmware crash.
@@ -489,11 +489,9 @@ static atomic_t bfa_debugfs_port_count;
 inline void
 bfad_debugfs_init(struct bfad_port_s *port)
 {
-	struct bfad_im_port_s *im_port = port->im_port;
-	struct bfad_s *bfad = im_port->bfad;
-	struct Scsi_Host *shost = im_port->shost;
+	struct bfad_s *bfad = port->bfad;
 	const struct bfad_debugfs_entry *file;
-	char name[16];
+	char name[64];
 	int i;
 
 	if (!bfa_debugfs_enable)
@@ -510,17 +508,15 @@ bfad_debugfs_init(struct bfad_port_s *port)
 		}
 	}
 
-	/*
-	 * Setup the host# directory for the port,
-	 * corresponds to the scsi_host num of this port.
-	 */
-	snprintf(name, sizeof(name), "host%d", shost->host_no);
+	/* Setup the pci_dev debugfs directory for the port */
+	snprintf(name, sizeof(name), "pci_dev:%s", bfad->pci_name);
 	if (!port->port_debugfs_root) {
 		port->port_debugfs_root =
 			debugfs_create_dir(name, bfa_debugfs_root);
 		if (!port->port_debugfs_root) {
 			printk(KERN_WARNING
-				"BFA host root dir creation failed\n");
+				"bfa %s: debugfs root creation failed\n",
+				bfad->pci_name);
 			goto err;
 		}
 
@@ -536,8 +532,8 @@ bfad_debugfs_init(struct bfad_port_s *port)
 							file->fops);
 			if (!bfad->bfad_dentry_files[i]) {
 				printk(KERN_WARNING
-					"BFA host%d: create %s entry failed\n",
-					shost->host_no, file->name);
+					"bfa %s: debugfs %s creation failed\n",
+					bfad->pci_name, file->name);
 				goto err;
 			}
 		}
@@ -550,8 +546,7 @@ err:
 inline void
 bfad_debugfs_exit(struct bfad_port_s *port)
 {
-	struct bfad_im_port_s *im_port = port->im_port;
-	struct bfad_s *bfad = im_port->bfad;
+	struct bfad_s *bfad = port->bfad;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(bfad_debugfs_files); i++) {
@@ -562,9 +557,7 @@ bfad_debugfs_exit(struct bfad_port_s *port)
 	}
 
 	/*
-	 * Remove the host# directory for the port,
-	 * corresponds to the scsi_host num of this port.
-	*/
+	 * Remove the pci_dev debugfs directory for the port */
 	if (port->port_debugfs_root) {
 		debugfs_remove(port->port_debugfs_root);
 		port->port_debugfs_root = NULL;
-- 
1.7.3.rc1

