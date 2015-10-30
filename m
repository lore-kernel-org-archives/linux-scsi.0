From: Benjamin Rood <benjaminjrood@gmail.com>
Subject: [PATCH] pm80xx: remove the SCSI host before detaching from SAS transport
Date: Fri, 30 Oct 2015 16:01:37 -0400
Message-ID: <1446235297-4572-1-git-send-email-brood@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:36611 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030592AbbJ3UBm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 16:01:42 -0400
Received: by qgad10 with SMTP id d10so70771641qga.3
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 13:01:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com
Cc: Benjamin Rood <brood@attotech.com>

Previously, when this module was unloaded via 'rmmod' with at least one
drive attached, the SCSI error handler thread would become stuck in an
infinite recovery loop and lockup the system, necessitating a reboot.

Once the SAS layer is detached, the driver will fail any subsequent
commands since the target devices are removed.  However, removing the
SCSI host generates a SYNCHRONIZE CACHE (10) command, which was failed
and left the error handler no method of recovery.

This patch simply removes the SCSI host first so that no more commands
can come down, prior to cleaning up the SAS layer.  Note that the stack
is built up with the SCSI host first, and then the SAS layer.  Perhaps
it should be reversed for symmetry, so that commands cannot be sent to
the pm80xx driver prior to attaching the SAS layer?

What was really strange about this bug was that it was introduced at
commit cff549e4860f ("[SCSI]: proper state checking and module refcount
handling in scsi_device_get").  This commit appears to tinker with how
the reference counting is performed for SCSI device objects.  My theory
is that prior to this commit, the refcount for a device object was
blindly incremented at some point during the teardown process which
coincidentially made the device stick around during the procedure, which
also coincidentially made any commands sent to the driver not fail
(since the device was technically still "there").  After this commit was
applied, my theory is the refcount for the device object is not being
incremented at a specific point anymore, which makes the device go away,
and thus made the pm80xx driver fail any subsequent commands.

You may also want to see the following for more details:

[1] http://www.spinics.net/lists/linux-scsi/msg37208.html
[2] http://marc.info/?l=linux-scsi&m=144416476406993&w=2

Signed-off-by: Benjamin Rood <brood@attotech.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index bdc624f..b1b2dd7 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1096,10 +1096,10 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 	struct pm8001_hba_info *pm8001_ha;
 	int i, j;
 	pm8001_ha = sha->lldd_ha;
+	scsi_remove_host(pm8001_ha->shost);
 	sas_unregister_ha(sha);
 	sas_remove_host(pm8001_ha->shost);
 	list_del(&pm8001_ha->list);
-	scsi_remove_host(pm8001_ha->shost);
 	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
 
-- 
2.4.3

