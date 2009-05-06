From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 7/10] scsi: megaraid_sas - Re-assign the Cmds to Application
 for the iMR controller
Date: Tue, 5 May 2009 19:43:07 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C354F61C60@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C354F61C5D@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og104.obsmtp.com ([64.18.2.161]:32781 "EHLO
	exprod7og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZEFBnw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2009 21:43:52 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C354F61C5D@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>

For the new SAS 2(0x73) controller, Driver needs to Re-allocate the cmds packets to Application

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   24 +++++++++++++++++++++---
 drivers/scsi/megaraid/megaraid_sas.h |    1 +
 2 files changed, 22 insertions(+), 3 deletions(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-05-04 20:32:42.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-05-04 20:37:32.000000000 -0400
@@ -1207,7 +1207,14 @@ static void megasas_complete_cmd_dpc(uns

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
@@ -2736,7 +2743,13 @@ static int megasas_io_attach(struct mega
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
@@ -2871,7 +2884,6 @@ megasas_probe_one(struct pci_dev *pdev,
        spin_lock_init(&instance->completion_lock);

        mutex_init(&instance->aen_mutex);
-       sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);

        /*
         * Initialize PCI related and misc parameters
@@ -2881,6 +2893,12 @@ megasas_probe_one(struct pci_dev *pdev,
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
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2009-05-04 20:32:42.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2009-05-04 20:00:31.000000000 -0400
@@ -665,6 +665,7 @@ struct megasas_ctrl_info {
  * is shown below
  */
 #define MEGASAS_INT_CMDS                       32
+#define MEGASAS_SKINNY_INT_CMDS                        5

 /*
  * FW can accept both 32 and 64 bit SGLs. We want to allocate 32/64 bit
