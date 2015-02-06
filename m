From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 17/36] aha1542: split out code from aha1542_hw_init
Date: Fri,  6 Feb 2015 23:11:38 +0100
Message-ID: <1423260717-15944-18-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56974 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756709AbbBFWQQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:16:16 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8F-0006fF-R5
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:11 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Split out bus times related block of aha1542_hw_init into separate function
aha1542_set_bus_times.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   65 ++++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 4bfba45..b8e4952 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -867,6 +867,40 @@ static int __init do_setup(char *str)
 __setup("aha1542=",do_setup);
 #endif
 
+/* Set the Bus on/off-times as not to ruin floppy performance */
+static void aha1542_set_bus_times(int indx)
+{
+	unsigned int base_io = bases[indx];
+	u8 oncmd[] = {CMD_BUSON_TIME, 7};
+	u8 offcmd[] = {CMD_BUSOFF_TIME, 5};
+
+	if (setup_called[indx]) {
+		oncmd[1] = setup_buson[indx];
+		offcmd[1] = setup_busoff[indx];
+	}
+	aha1542_intr_reset(base_io);
+	aha1542_out(base_io, oncmd, 2);
+	if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
+		goto fail;
+	aha1542_intr_reset(base_io);
+	aha1542_out(base_io, offcmd, 2);
+	if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
+		goto fail;
+	if (setup_dmaspeed[indx] >= 0) {
+		u8 dmacmd[] = {CMD_DMASPEED, 0};
+		dmacmd[1] = setup_dmaspeed[indx];
+		aha1542_intr_reset(base_io);
+		aha1542_out(base_io, dmacmd, 2);
+		if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
+			goto fail;
+	}
+	aha1542_intr_reset(base_io);
+	return;
+fail:
+	printk(KERN_ERR "setting bus on/off-time failed\n");
+	aha1542_intr_reset(base_io);
+}
+
 /* return non-zero on detection */
 static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct device *pdev, int indx)
 {
@@ -897,37 +931,8 @@ static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct
 
 			base_io = bases[indx];
 
-			/* Set the Bus on/off-times as not to ruin floppy performance */
-			{
-				u8 oncmd[] = {CMD_BUSON_TIME, 7};
-				u8 offcmd[] = {CMD_BUSOFF_TIME, 5};
+			aha1542_set_bus_times(indx);
 
-				if (setup_called[indx]) {
-					oncmd[1] = setup_buson[indx];
-					offcmd[1] = setup_busoff[indx];
-				}
-				aha1542_intr_reset(base_io);
-				aha1542_out(base_io, oncmd, 2);
-				if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
-					goto fail;
-				aha1542_intr_reset(base_io);
-				aha1542_out(base_io, offcmd, 2);
-				if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
-					goto fail;
-				if (setup_dmaspeed[indx] >= 0) {
-					u8 dmacmd[] = {CMD_DMASPEED, 0};
-					dmacmd[1] = setup_dmaspeed[indx];
-					aha1542_intr_reset(base_io);
-					aha1542_out(base_io, dmacmd, 2);
-					if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
-						goto fail;
-				}
-				while (0) {
-fail:
-					printk(KERN_ERR "aha1542_detect: setting bus on/off-time failed\n");
-				}
-				aha1542_intr_reset(base_io);
-			}
 			if (aha1542_query(base_io, &trans))
 				goto unregister;
 
-- 
Ondrej Zary

