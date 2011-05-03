From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 02/16] hpsa: add readl after writel in interrupt mask setting
	code
Date: Tue, 03 May 2011 14:58:55 -0500
Message-ID: <20110503195854.5478.57327.stgit@beardog.cce.hp.com>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This is to ensure the board interrupts are really off when
these functions return.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 98c97ca..7eec397 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -228,10 +228,12 @@ static void SA5_intr_mask(struct ctlr_info *h, unsigned long val)
 	if (val) { /* Turn interrupts on */
 		h->interrupts_enabled = 1;
 		writel(0, h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+		(void) readl(h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
 	} else { /* Turn them off */
 		h->interrupts_enabled = 0;
 		writel(SA5_INTR_OFF,
 			h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+		(void) readl(h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
 	}
 }
 
@@ -240,10 +242,12 @@ static void SA5_performant_intr_mask(struct ctlr_info *h, unsigned long val)
 	if (val) { /* turn on interrupts */
 		h->interrupts_enabled = 1;
 		writel(0, h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+		(void) readl(h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
 	} else {
 		h->interrupts_enabled = 0;
 		writel(SA5_PERF_INTR_OFF,
 			h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+		(void) readl(h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
 	}
 }
 
