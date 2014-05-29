From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 05/24] hpsa: change doorbell reset delay to ten seconds
Date: Thu, 29 May 2014 10:52:47 -0500
Message-ID: <20140529155246.8180.70657.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:19822 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763AbaE2Pyi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:54:38 -0400
Received: from g2t2354.austin.hp.com (g2t2354.austin.hp.com [15.217.128.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id AF0F5DD3
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 15:35:21 +0000 (UTC)
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Justin Lindley <justin.lindley@hp.com>

After 3.22 firmware, PMC firmware guys tell us the
previous 5 second delay after a reset now needs to
be 10 secs to avoid a PCIe error due to the driver
looking at the controller too soon after the reset.

Signed-off-by: Justin Lindley <justin.lindley@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1df9a8a..2220b32 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5831,12 +5831,12 @@ static int hpsa_controller_hard_reset(struct pci_dev *pdev,
 		dev_info(&pdev->dev, "using doorbell to reset controller\n");
 		writel(use_doorbell, vaddr + SA5_DOORBELL);
 
-		/* PMC hardware guys tell us we need a 5 second delay after
+		/* PMC hardware guys tell us we need a 10 second delay after
 		 * doorbell reset and before any attempt to talk to the board
 		 * at all to ensure that this actually works and doesn't fall
 		 * over in some weird corner cases.
 		 */
-		msleep(5000);
+		msleep(10000);
 	} else { /* Try to do it the PCI power state way */
 
 		/* Quoting from the Open CISS Specification: "The Power

