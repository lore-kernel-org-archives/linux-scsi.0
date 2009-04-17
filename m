From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 5/14 - 2nd post] mpt2sas: driver name needs to be in the MPT2IOCINFO ioctl
Date: Fri, 17 Apr 2009 10:27:44 -0600
Message-ID: <20090417162742.GF7009@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3mo2-old.postini.com ([64.18.14.205]:49456 "EHLO
	chip3mo2-old.postini.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbZDQQ0x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 12:26:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

The driver name needs to be at the beginining of the driver_version string in
MPT2IOCINFO ioctl.  This is the same behaviour is there already in the mptsas
driver.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uarpN a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c	2009-04-09 16:44:05.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c	2009-04-13 15:28:16.000000000 -0600
@@ -917,9 +917,9 @@ _ctl_getiocinfo(void __user *arg)
 	karg.pci_information.u.bits.function = PCI_FUNC(ioc->pdev->devfn);
 	karg.pci_information.segment_id = pci_domain_nr(ioc->pdev->bus);
 	karg.firmware_version = ioc->facts.FWVersion.Word;
-	strncpy(karg.driver_version, MPT2SAS_DRIVER_VERSION,
-	    MPT2_IOCTL_VERSION_LENGTH);
-	karg.driver_version[MPT2_IOCTL_VERSION_LENGTH - 1] = '\0';
+	strcpy(karg.driver_version, MPT2SAS_DRIVER_NAME);
+	strcat(karg.driver_version, "-");
+	strcat(karg.driver_version, MPT2SAS_DRIVER_VERSION);
 	karg.bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
 
 	if (copy_to_user(arg, &karg, sizeof(karg))) {
