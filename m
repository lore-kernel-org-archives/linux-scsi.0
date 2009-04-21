From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 5/10] mpt2sas : driver name needs to be in the MPT2IOCINFO ioctl
Date: Tue, 21 Apr 2009 15:40:01 -0600
Message-ID: <20090421213959.GF18563@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og63.obsmtp.com ([64.18.14.203]:55968 "EHLO
	chip3og63.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbZDUVi2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 17:38:28 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

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
