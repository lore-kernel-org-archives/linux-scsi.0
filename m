From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 7/12] scsi: megaraid_sas - allocate the application cmds to
 sas2 controller
Date: Sun, 20 Sep 2009 20:42:30 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C35C512403@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C51199A@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:37458 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754174AbZIUCmj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Sep 2009 22:42:39 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C51199A@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

MegaRAID SAS2 controller ioctl can't use 32 cmd for applications.  Driver need to divide different number of cmds to IO and application.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   24 +++++++++++++++++++++---
 drivers/scsi/megaraid/megaraid_sas.h |    1 +
 2 files changed, 22 insertions(+), 3 deletions(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-09-14 05:59:48.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-09-14 06:07:09.000000000 -0400
@@ -1239,7 +1239,14 @@ static void megasas_complete_cmd_dpc(uns

                spin_lock_irqsave(instance->host->host_lock, flags);
                instance->flag &= ~MEGASAS_FW_BUSY;
-               instance->host->can_queue =
+               if ((instance->pdev->device ==
+                       PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+                       (instance->pdev->device ==
+                       PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+                       instance->host->can_queue =
+                               instance->max_fw_cmds - MEGASAS_SKINNY_INT_CMDS;
+               } else
+                       instance->host->can_queue =
                                instance->max_fw_cmds - MEGASAS_INT_CMDS;

                spin_unlock_irqrestore(instance->host->host_lock, flags);
@@ -2774,7 +2781,13 @@ static int megasas_io_attach(struct mega
         */
        host->irq = instance->pdev->irq;
        host->unique_id = instance->unique_id;
-       host->can_queue = instance->max_fw_cmds - MEGASAS_INT_CMDS;
+       if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+               (instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+               host->can_queue =
+                       instance->max_fw_cmds - MEGASAS_SKINNY_INT_CMDS;
+       } else
+               host->can_queue =
+                       instance->max_fw_cmds - MEGASAS_INT_CMDS;
        host->this_id = instance->init_id;
        host->sg_tablesize = instance->max_num_sge;
        host->max_sectors = instance->max_sectors_per_req;
@@ -2909,7 +2922,6 @@ megasas_probe_one(struct pci_dev *pdev,
        spin_lock_init(&poll_aen_lock);

        mutex_init(&instance->aen_mutex);
-       sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);

        /*
         * Initialize PCI related and misc parameters
@@ -2919,6 +2931,12 @@ megasas_probe_one(struct pci_dev *pdev,
        instance->unique_id = pdev->bus->number << 8 | pdev->devfn;
        instance->init_id = MEGASAS_DEFAULT_INIT_ID;

+       if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+               (instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+               sema_init(&instance->ioctl_sem, MEGASAS_SKINNY_INT_CMDS);
+       } else
+               sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
+
        megasas_dbg_lvl = 0;
        instance->flag = 0;
        instance->unload = 0;
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2009-09-14 05:59:48.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2009-09-14 06:09:56.000000000 -0400
@@ -655,6 +655,7 @@ struct megasas_ctrl_info {
  * is shown below
  */
 #define MEGASAS_INT_CMDS                       32
+#define MEGASAS_SKINNY_INT_CMDS                        5

 /*
  * FW can accept both 32 and 64 bit SGLs. We want to allocate 32/64 bit
