From: Benjamin Rood <benjaminjrood@gmail.com>
Subject: [PATCH v2 7/9] pm80xx: wait a minimum of 500ms before issuing commands to SPCv
Date: Mon,  2 Nov 2015 15:42:29 -0500
Message-ID: <1446496949-1980-1-git-send-email-brood@attotech.com>
References: <CAD+HZHU-2V0R1uRAqauxFWuSsC0qGLsGCoVrBgmbhp2LADbfdg@mail.gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:35234 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbbKBUmd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 15:42:33 -0500
Received: by qkct129 with SMTP id t129so3645816qkc.2
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2015 12:42:33 -0800 (PST)
In-Reply-To: <CAD+HZHU-2V0R1uRAqauxFWuSsC0qGLsGCoVrBgmbhp2LADbfdg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com, hare@suse.de
Cc: Benjamin Rood <brood@attotech.com>

The documentation for the 8070 and 8072 SPCv chip explicitly states that
a minimum of 500ms must elapse before issuing commands, otherwise the
SPCv may not process them and the firmware may get into an unrecoverable
state requiring a reboot.  While the Linux guys will probably think this
is 'racy', it is called out in the chip documentation and inserting this
delay makes power management function properly.

Signed-off-by: Benjamin Rood <brood@attotech.com>
---
Changes from v1 -> v2:
	-Used mdelay(500) instead of a loop to facilitate required delay
	-Added comment as to why this behavior exists

 drivers/scsi/pm8001/pm8001_init.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 7ce7ea3..d147c41 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1243,6 +1243,19 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 		for (i = 1; i < pm8001_ha->number_of_intr; i++)
 			PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, i);
 	}
+
+	/* Chip documentation for the 8070 and 8072 SPCv    */
+	/* states that a 500ms minimum delay is required    */
+	/* before issuing commands.  Otherwise, the firmare */
+	/* will enter an unrecoverable state.               */
+
+	if (pm8001_ha->chip_id == chip_8070 ||
+		pm8001_ha->chip_id == chip_8072) {
+		mdelay(500);
+	}
+
+	/* Spin up the PHYs */
+
 	pm8001_ha->flags = PM8001F_RUN_TIME;
 	for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
 		pm8001_ha->phy[i].enable_completion = &completion;
-- 
2.4.3

