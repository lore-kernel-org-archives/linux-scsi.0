From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] isci: reformulate for_each_isci_host macro to fix an oops
Date: Thu, 16 Jan 2014 14:16:24 +0100
Message-ID: <20140116131624.24112.8745.stgit@gklab-154-244.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com
Cc: pawel.baldysiak@intel.com, dave.jiang@intel.com, maciej.patelczyk@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The loop 'for' in macro 'for_each_isci_host' (drivers/scsi/isci/init.c:717)
is executed more times than it can be. Regardless the condition:
   'id < ARRAY_SIZE(to_pci_info(pdev)->hosts)' (drivers/scsi/isci/host.h:315)
it is executed when id equals ARRAY_SIZE(to_pci_info(pdev)->hosts) too.
(Remark: ARRAY_SIZE(to_pci_info(pdev)->hosts) always equals SCI_MAX_CONTROLLERS = 2)

It sounds crazy, but it is truth. I have checked it in the following way:
I have added the line:

   printk(KERN_ERR ">>> (%d < %d) == %d \n", \
          i, SCI_MAX_CONTROLLERS, (i < SCI_MAX_CONTROLLERS));

after the 'for_each_isci_host' macro in drivers/scsi/isci/init.c:701
and received the following output:

   >>> (0 < 2) == 1
   >>> (1 < 2) == 1
   >>> (2 < 2) == 1

after issuing 'modprobe isci' command on platform with two SCU controllers
(Patsburg D or T chipset required).
The kernel was compiled using gcc version 4.8.2.

This patch does not introduce any functional changes. It only reformulates
the 'for_each_isci_host' macro and the relevant code in the drivers/scsi/isci/init.c file
and fixes the following oops after 'rmmod isci':

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff8131360b>] __list_add+0x1b/0xc0
Oops: 0000 [#1] SMP
RIP: 0010:[<ffffffff8131360b>]  [<ffffffff8131360b>] __list_add+0x1b/0xc0
Call Trace:
  [<ffffffff81661b84>] __mutex_lock_slowpath+0x114/0x1b0
  [<ffffffff81661c3f>] mutex_lock+0x1f/0x30
  [<ffffffffa03e97cb>] sas_disable_events+0x1b/0x50 [libsas]
  [<ffffffffa03e9818>] sas_unregister_ha+0x18/0x60 [libsas]
  [<ffffffffa040316e>] isci_unregister+0x1e/0x40 [isci]
  [<ffffffffa0403efd>] isci_pci_remove+0x5d/0x100 [isci]
  [<ffffffff813391cb>] pci_device_remove+0x3b/0xb0
  [<ffffffff813fbf7f>] __device_release_driver+0x7f/0xf0
  [<ffffffff813fc8f8>] driver_detach+0xa8/0xb0
  [<ffffffff813fbb8b>] bus_remove_driver+0x9b/0x120
  [<ffffffff813fcf2c>] driver_unregister+0x2c/0x50
  [<ffffffff813381f3>] pci_unregister_driver+0x23/0x80
  [<ffffffffa04152f8>] isci_exit+0x10/0x1e [isci]
  [<ffffffff810d199b>] SyS_delete_module+0x16b/0x2d0
  [<ffffffff81012a21>] ? do_notify_resume+0x61/0xa0
  [<ffffffff8166ce29>] system_call_fastpath+0x16/0x1b

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
Tested-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/isci/host.h |    8 ++++----
 drivers/scsi/isci/init.c |   20 ++++++++++++++------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 4911310..2002fdf 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -310,10 +310,10 @@ static inline struct Scsi_Host *to_shost(struct isci_host *ihost)
 	return ihost->sas_ha.core.shost;
 }
 
-#define for_each_isci_host(id, ihost, pdev) \
-	for (id = 0, ihost = to_pci_info(pdev)->hosts[id]; \
-	     id < ARRAY_SIZE(to_pci_info(pdev)->hosts) && ihost; \
-	     ihost = to_pci_info(pdev)->hosts[++id])
+#define for_each_isci_host(id, ihost, hosts) \
+	for (id = 0, ihost = hosts[0]; \
+	     (id < SCI_MAX_CONTROLLERS) && ihost; \
+	     ihost = hosts[++id])
 
 static inline void wait_for_start(struct isci_host *ihost)
 {
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index d25d0d8..5a07b7b 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -346,6 +346,7 @@ static int isci_setup_interrupts(struct pci_dev *pdev)
 	int err, i, num_msix;
 	struct isci_host *ihost;
 	struct isci_pci_info *pci_info = to_pci_info(pdev);
+	struct isci_host **hosts;
 
 	/*
 	 *  Determine the number of vectors associated with this
@@ -390,7 +391,8 @@ static int isci_setup_interrupts(struct pci_dev *pdev)
 	return 0;
 
  intx:
-	for_each_isci_host(i, ihost, pdev) {
+	hosts = pci_info->hosts;
+	for_each_isci_host(i, ihost, hosts) {
 		err = devm_request_irq(&pdev->dev, pdev->irq, isci_intx_isr,
 				       IRQF_SHARED, DRV_NAME"-intx", ihost);
 		if (err)
@@ -621,6 +623,7 @@ static int isci_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct isci_pci_info *pci_info;
 	int err, i;
 	struct isci_host *isci_host;
+	struct isci_host **hosts;
 	const struct firmware *fw = NULL;
 	struct isci_orom *orom = NULL;
 	char *source = "(platform)";
@@ -698,13 +701,15 @@ static int isci_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_host_alloc;
 
-	for_each_isci_host(i, isci_host, pdev)
+	hosts = pci_info->hosts;
+	for_each_isci_host(i, isci_host, hosts)
 		scsi_scan_host(to_shost(isci_host));
 
 	return 0;
 
  err_host_alloc:
-	for_each_isci_host(i, isci_host, pdev)
+	hosts = pci_info->hosts;
+	for_each_isci_host(i, isci_host, hosts)
 		isci_unregister(isci_host);
 	return err;
 }
@@ -712,9 +717,10 @@ static int isci_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 static void isci_pci_remove(struct pci_dev *pdev)
 {
 	struct isci_host *ihost;
+	struct isci_host **hosts = to_pci_info(pdev)->hosts;
 	int i;
 
-	for_each_isci_host(i, ihost, pdev) {
+	for_each_isci_host(i, ihost, hosts) {
 		wait_for_start(ihost);
 		isci_unregister(ihost);
 		isci_host_deinit(ihost);
@@ -726,9 +732,10 @@ static int isci_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct isci_host *ihost;
+	struct isci_host **hosts = to_pci_info(pdev)->hosts;
 	int i;
 
-	for_each_isci_host(i, ihost, pdev) {
+	for_each_isci_host(i, ihost, hosts) {
 		sas_suspend_ha(&ihost->sas_ha);
 		isci_host_deinit(ihost);
 	}
@@ -744,6 +751,7 @@ static int isci_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct isci_host *ihost;
+	struct isci_host **hosts = to_pci_info(pdev)->hosts;
 	int rc, i;
 
 	pci_set_power_state(pdev, PCI_D0);
@@ -758,7 +766,7 @@ static int isci_resume(struct device *dev)
 
 	pci_set_master(pdev);
 
-	for_each_isci_host(i, ihost, pdev) {
+	for_each_isci_host(i, ihost, hosts) {
 		sas_prep_resume_ha(&ihost->sas_ha);
 
 		isci_host_init(ihost);
