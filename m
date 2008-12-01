From: akpm@linux-foundation.org
Subject: [patch for 2.6.28? 1/1] aacraid: disable Dell Percraid quirk on Adaptec 2200S and 2120S
Date: Mon, 01 Dec 2008 14:04:12 -0800
Message-ID: <200812012204.mB1M4C4l003416@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133AbYLAWFX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2008 17:05:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, thenzl@redhat.com, Achim_Leubner@adaptec.com, aacraid@adaptec.com, dermoth@aei.ca, gernot.hillier@siemens.com, stable@kernel.org

From: Tomas Henzl <thenzl@redhat.com>

A lot of 64bit machines with Adaptec 2200S and 2120S controllers don't
recognize SCSI disks any more with the patch "fix driver failure with Dell
PowerEdge Expandable RAID Controller 3/Di", but fail with tons of "aac_srb:
aac_fib_send failed with status: 8195" instead. This patch disables the
quirk introduced in the change cited above for those two controllers again.

Signed-off-by: Gernot Hillier <gernot.hillier@siemens.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Cc: <aacraid@adaptec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Tested-by: Thomas Guyot-Sionnest <dermoth@aei.ca>
Cc: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Cc: <stable@kernel.org>		[2.6.27.x, 2.6.26.x, 2.6.25.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/linit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/aacraid/linit.c~aacraid-disable-dell-percraid-quirk-on-adaptec-2200s-and-2120s drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c~aacraid-disable-dell-percraid-quirk-on-adaptec-2200s-and-2120s
+++ a/drivers/scsi/aacraid/linit.c
@@ -175,8 +175,8 @@ static struct aac_driver_ident aac_drive
 	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* PERC 3/Di (Boxster/PERC3DiB) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* catapult */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* tomcat */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2120S (Crusader) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2200S (Vulcan) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG },		      /* Adaptec 2120S (Crusader) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG },		      /* Adaptec 2200S (Vulcan) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2200S (Vulcan-2m) */
 	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend S220 (Legend Crusader) */
 	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend S230 (Legend Vulcan) */
_
