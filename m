From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 04/10] hpsa: factor out driver name
Date: Thu, 19 Jan 2012 14:00:59 -0600
Message-ID: <20120119200059.17835.90819.stgit@beardog.cce.hp.com>
References: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, scott.teel@hp.com, akpm@linux-foundation.org, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Sometimes, for testing purposes (e.g. testing rmmod on a system
that normally boots using hpsa) it's nice to rename the driver
and split it into two drivers and restrict it to certain
controllers.  This makes that easier.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   27 ++++++++++++++-------------
 drivers/scsi/hpsa.h |    2 +-
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d191e3f..129655a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -56,6 +56,7 @@
 /* HPSA_DRIVER_VERSION must be 3 byte values (0-255) separated by '.' */
 #define HPSA_DRIVER_VERSION "2.0.2-1"
 #define DRIVER_NAME "HP HPSA Driver (v " HPSA_DRIVER_VERSION ")"
+#define HPSA "hpsa"
 
 /* How long to wait (in milliseconds) for board to go into simple mode */
 #define MAX_CONFIG_WAIT 30000
@@ -202,30 +203,30 @@ static int check_for_unit_attention(struct ctlr_info *h,
 
 	switch (c->err_info->SenseInfo[12]) {
 	case STATE_CHANGED:
-		dev_warn(&h->pdev->dev, "hpsa%d: a state change "
+		dev_warn(&h->pdev->dev, HPSA "%d: a state change "
 			"detected, command retried\n", h->ctlr);
 		break;
 	case LUN_FAILED:
-		dev_warn(&h->pdev->dev, "hpsa%d: LUN failure "
+		dev_warn(&h->pdev->dev, HPSA "%d: LUN failure "
 			"detected, action required\n", h->ctlr);
 		break;
 	case REPORT_LUNS_CHANGED:
-		dev_warn(&h->pdev->dev, "hpsa%d: report LUN data "
+		dev_warn(&h->pdev->dev, HPSA "%d: report LUN data "
 			"changed, action required\n", h->ctlr);
 	/*
 	 * Note: this REPORT_LUNS_CHANGED condition only occurs on the MSA2012.
 	 */
 		break;
 	case POWER_OR_RESET:
-		dev_warn(&h->pdev->dev, "hpsa%d: a power on "
+		dev_warn(&h->pdev->dev, HPSA "%d: a power on "
 			"or device reset detected\n", h->ctlr);
 		break;
 	case UNIT_ATTENTION_CLEARED:
-		dev_warn(&h->pdev->dev, "hpsa%d: unit attention "
+		dev_warn(&h->pdev->dev, HPSA "%d: unit attention "
 		    "cleared by another initiator\n", h->ctlr);
 		break;
 	default:
-		dev_warn(&h->pdev->dev, "hpsa%d: unknown "
+		dev_warn(&h->pdev->dev, HPSA "%d: unknown "
 			"unit attention detected\n", h->ctlr);
 		break;
 	}
@@ -473,8 +474,8 @@ static struct device_attribute *hpsa_shost_attrs[] = {
 
 static struct scsi_host_template hpsa_driver_template = {
 	.module			= THIS_MODULE,
-	.name			= "hpsa",
-	.proc_name		= "hpsa",
+	.name			= HPSA,
+	.proc_name		= HPSA,
 	.queuecommand		= hpsa_scsi_queue_command,
 	.scan_start		= hpsa_scan_start,
 	.scan_finished		= hpsa_scan_finished,
@@ -3341,7 +3342,7 @@ static int hpsa_controller_hard_reset(struct pci_dev *pdev,
 static __devinit void init_driver_version(char *driver_version, int len)
 {
 	memset(driver_version, 0, len);
-	strncpy(driver_version, "hpsa " HPSA_DRIVER_VERSION, len - 1);
+	strncpy(driver_version, HPSA " " HPSA_DRIVER_VERSION, len - 1);
 }
 
 static __devinit int write_driver_ver_to_cfgtable(
@@ -3922,7 +3923,7 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 		return err;
 	}
 
-	err = pci_request_regions(h->pdev, "hpsa");
+	err = pci_request_regions(h->pdev, HPSA);
 	if (err) {
 		dev_err(&h->pdev->dev,
 			"cannot obtain PCI resources, aborting\n");
@@ -4240,7 +4241,7 @@ static void start_controller_lockup_detector(struct ctlr_info *h)
 		spin_lock_init(&lockup_detector_lock);
 		hpsa_lockup_detector =
 			kthread_run(detect_controller_lockup_thread,
-						NULL, "hpsa");
+						NULL, HPSA);
 	}
 	if (!hpsa_lockup_detector) {
 		dev_warn(&h->pdev->dev,
@@ -4312,7 +4313,7 @@ reinit_after_soft_reset:
 	if (rc != 0)
 		goto clean1;
 
-	sprintf(h->devname, "hpsa%d", number_of_controllers);
+	sprintf(h->devname, HPSA "%d", number_of_controllers);
 	h->ctlr = number_of_controllers;
 	number_of_controllers++;
 
@@ -4526,7 +4527,7 @@ static int hpsa_resume(__attribute__((unused)) struct pci_dev *pdev)
 }
 
 static struct pci_driver hpsa_pci_driver = {
-	.name = "hpsa",
+	.name = HPSA,
 	.probe = hpsa_init_one,
 	.remove = __devexit_p(hpsa_remove_one),
 	.id_table = hpsa_pci_device_id,	/* id_table */
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index b4b97eb..7b28d54 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -316,7 +316,7 @@ static unsigned long SA5_completed(struct ctlr_info *h)
 		dev_dbg(&h->pdev->dev, "Read %lx back from board\n",
 			register_value);
 	else
-		dev_dbg(&h->pdev->dev, "hpsa: FIFO Empty read\n");
+		dev_dbg(&h->pdev->dev, "FIFO Empty read\n");
 #endif
 
 	return register_value;
