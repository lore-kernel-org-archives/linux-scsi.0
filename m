From: Benjamin Rood <benjaminjrood@gmail.com>
Subject: [PATCH 7/8] pm80xx: wait a minimum of 500ms before issuing commands to SPCv
Date: Fri, 30 Oct 2015 10:53:30 -0400
Message-ID: <1446216811-2248-8-git-send-email-brood@attotech.com>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:33524 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbbJ3Oxo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 10:53:44 -0400
Received: by qgeo38 with SMTP id o38so63665702qge.0
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 07:53:44 -0700 (PDT)
In-Reply-To: <1446216811-2248-1-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com
Cc: Benjamin Rood <brood@attotech.com>

The documentation for the 8070 and 8072 SPCv chip explicitly states that
a minimum of 500ms must elapse before issuing commands, otherwise the
SPCv may not process them and the firmware may get into an unrecoverable
state requiring a reboot.  While the Linux guys will probably think this
is 'racy', it is called out in the chip documentation and inserting this
delay makes power management function properly.

Signed-off-by: Benjamin Rood <brood@attotech.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index a0e55d4..ab99984 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1190,6 +1190,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	int rc;
 	u8 i = 0, j;
 	u32 device_state;
+	u32 wait_count;
 	DECLARE_COMPLETION_ONSTACK(completion);
 	pm8001_ha = sha->lldd_ha;
 	device_state = pdev->current_state;
@@ -1243,6 +1244,17 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 		for (i = 1; i < pm8001_ha->number_of_intr; i++)
 			PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, i);
 	}
+
+	if (pm8001_ha->chip_id == chip_8070 ||
+		pm8001_ha->chip_id == chip_8072) {
+		wait_count = 500;
+		do {
+			mdelay(1);
+		} while (--wait_count);
+	}
+
+	/* Spin up the PHYs */
+
 	pm8001_ha->flags = PM8001F_RUN_TIME;
 	for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
 		pm8001_ha->phy[i].enable_completion = &completion;
-- 
2.4.3

