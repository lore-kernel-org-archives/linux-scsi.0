From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/2] gdth: fix Error: Driver 'gdth' is already registered,
	aborting...
Date: Sun, 04 May 2008 22:35:58 -0500
Message-ID: <1209958558.16283.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51565 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563AbYEEDgF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 23:36:05 -0400
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id BE3B4842B
	for <linux-scsi@vger.kernel.org>; Sun,  4 May 2008 22:36:03 -0500 (CDT)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id soRg5IY8+kCl for <linux-scsi@vger.kernel.org>;
	Sun,  4 May 2008 22:36:00 -0500 (CDT)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id CC4F9A252
	for <linux-scsi@vger.kernel.org>; Sun,  4 May 2008 22:35:59 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This message appears on modprobe/rmmod/modprobe of the driver.  It's
caused because if the driver has no instances, it returns an error
from gdth_init, which causes the module to fail to load.
Unfortunately, the module's pci driver is still registered at this
point.

Fix this by making gdth behave like a modern driver and insert even if
it doesn't find any instances (in case of hot plug or software driven
binding).

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/gdth.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 16785a2..46771d4 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -550,7 +550,6 @@ static int __init gdth_search_isa(ulong32 bios_adr)
 #endif /* CONFIG_ISA */
 
 #ifdef CONFIG_PCI
-static bool gdth_pci_registered;
 
 static bool gdth_search_vortex(ushort device)
 {
@@ -5157,8 +5156,13 @@ static int __init gdth_init(void)
 
 #ifdef CONFIG_PCI
 	/* scanning for PCI controllers */
-	if (pci_register_driver(&gdth_pci_driver) == 0)
-		gdth_pci_registered = true;
+	if (pci_register_driver(&gdth_pci_driver)) {
+		gdth_ha_str *ha;
+
+		list_for_each_entry(ha, &gdth_instances, list)
+			gdth_remove_one(ha);
+		return -ENODEV;
+	}
 #endif /* CONFIG_PCI */
 
 	TRACE2(("gdth_detect() %d controller detected\n", gdth_ctr_count));
@@ -5181,8 +5185,7 @@ static void __exit gdth_exit(void)
 #endif
 
 #ifdef CONFIG_PCI
-	if (gdth_pci_registered)
-		pci_unregister_driver(&gdth_pci_driver);
+	pci_unregister_driver(&gdth_pci_driver);
 #endif
 
 	list_for_each_entry(ha, &gdth_instances, list)
-- 
1.5.4.4



