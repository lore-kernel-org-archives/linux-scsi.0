From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 5/13] mpt2sas: driver name needs to be in the MPT2IOCINFO ioctl
Date: Mon, 13 Apr 2009 22:31:05 -0600
Message-ID: <20090414043101.GF20124@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og61.obsmtp.com ([64.18.14.187]:54679 "EHLO
	chip3og61.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbZDNSFP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2009 14:05:15 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id n3EI5Bd2004605
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 11:05:12 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id n3EI5FeC017062
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 11:05:15 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The driver name needs to be at the beginining of the driver_version string in
MPT2IOCINFO ioctl.  This is the same behaviour is there already in the mptsas
driver.

Signed-off-by: Eric Moore <eric.moore@lsi.com>


diff -uaprN a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
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
