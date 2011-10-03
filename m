From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/1] cciss: resubmit add delay to PCI PM reset code
Date: Mon, 3 Oct 2011 13:50:15 -0500
Message-ID: <20111003185015.GC6898@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:44042 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1JCSuU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2011 14:50:20 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

PATCH 1 of 1

From: Mike Miller <mike.miller@hp.com>

cciss: add delay back to PCI Power Management reset

When we change states from D0 to D3Hot and back to D0 we need a small delay.
Otherwise we may think the board has failed to reset and we bail. This
change affects the Smart Array P600.

Please ignore the previous patch that did this. I made it against the wrong
code base resulting in an offset. My apologies.

Signed-off-by: Mike Miller <mike.miller@hp.com>
---
 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8f4ef65..a70c6dd 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4526,13 +4526,13 @@ static int cciss_controller_hard_reset(struct pci_dev *pdev,
 		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
 		pmcsr |= PCI_D3hot;
 		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
-
 		msleep(500);
 
 		/* enter the D0 power management state */
 		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
 		pmcsr |= PCI_D0;
 		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
+		msleep(500);
 	}
 	return 0;
 }
