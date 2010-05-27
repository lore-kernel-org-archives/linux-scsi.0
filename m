From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 15/24] hpsa: clean up debug ifdefs
Date: Thu, 27 May 2010 15:13:58 -0500
Message-ID: <20100527201358.3116.20503.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:46800 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab0E0UJT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:09:19 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: clean up debug ifdefsS

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 61fd71e..b34ee41 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3143,9 +3143,9 @@ static __devinit int hpsa_hard_reset_controller(struct pci_dev *pdev)
  *   the io functions.
  *   This is for debug only.
  */
-#ifdef HPSA_DEBUG
 static void print_cfg_table(struct device *dev, struct CfgTable *tb)
 {
+#ifdef HPSA_DEBUG
 	int i;
 	char temp_name[17];
 
@@ -3175,8 +3175,8 @@ static void print_cfg_table(struct device *dev, struct CfgTable *tb)
 	dev_info(dev, "   Server Name = %s\n", temp_name);
 	dev_info(dev, "   Heartbeat Counter = 0x%x\n\n\n",
 		readl(&(tb->HeartBeat)));
-}
 #endif				/* HPSA_DEBUG */
+}
 
 static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
 {
@@ -3442,11 +3442,7 @@ static int __devinit hpsa_enter_simple_mode(struct ctlr_info *h)
 		/* delay and try again */
 		msleep(10);
 	}
-
-#ifdef HPSA_DEBUG
 	print_cfg_table(&h->pdev->dev, h->cfgtable);
-#endif				/* HPSA_DEBUG */
-
 	if (!(readl(&(h->cfgtable->TransportActive)) & CFGTBL_Trans_Simple)) {
 		dev_warn(&h->pdev->dev,
 			"unable to get board into simple mode\n");

