From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Subject: [PATCH] mptsas: add mptsas_shutdown to call pci_disable_msi
Date: Tue, 22 Apr 2008 19:47:33 -0700
Message-ID: <200804221947.33524.yhlu.kernel@gmail.com>
Reply-To: yhlu.kernel@gmail.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:12317 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416AbYDWCrw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Apr 2008 22:47:52 -0400
Received: by py-out-1112.google.com with SMTP id u52so3888930pyb.10
        for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2008 19:47:51 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Prakash, Sathya" <sathya.prakash@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "Eric W. Biederman" <ebiederm@xmission.com>


this change

| commit 23a274c8a5adafc74a66f16988776fc7dd6f6e51
| Author: Prakash, Sathya <sathya.prakash@lsi.com>
| Date:   Fri Mar 7 15:53:21 2008 +0530
|
|     [SCSI] mpt fusion: Enable MSI by default for SAS controllers
|
|     This patch modifies the driver to enable MSI by default for all SAS chips.
|
cause kexec RHEL 5.1 kernel fail.

root casue: the rhel 5.1 kernel still use INTx emulation.
and mptscsih_shutdown doesn't call pci_disable_msi to reenable INTx on kexec path

so try to call mptsas_remove in mptsas_shutdown.
then pci_disable_msi will be called via mptsas_remove==>mptscih_remove==>
mpt_detach.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Prakash, Sathya <sathya.prakash@lsi.com>
CC: "Moore, Eric" <Eric.Moore@lsi.com>

Index: linux-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptsas.c
+++ linux-2.6/drivers/message/fusion/mptsas.c
@@ -3327,6 +3327,11 @@ static void __devexit mptsas_remove(stru
 	mptscsih_remove(pdev);
 }
 
+static void mptsas_shutdown(struct pci_dev *pdev)
+{
+	mptsas_remove(pdev);
+}
+
 static struct pci_device_id mptsas_pci_table[] = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1064,
 		PCI_ANY_ID, PCI_ANY_ID },
@@ -3348,7 +3353,7 @@ static struct pci_driver mptsas_driver =
 	.id_table	= mptsas_pci_table,
 	.probe		= mptsas_probe,
 	.remove		= __devexit_p(mptsas_remove),
-	.shutdown	= mptscsih_shutdown,
+	.shutdown	= mptsas_shutdown,
 #ifdef CONFIG_PM
 	.suspend	= mptscsih_suspend,
 	.resume		= mptscsih_resume,
