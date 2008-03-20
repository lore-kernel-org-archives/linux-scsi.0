From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] a100u2w: fix bitmap lookup routine
Date: Thu, 20 Mar 2008 18:34:49 +0900
Message-ID: <20080320093448.GA30888@APFDCB5C>
References: <20080317123200.GA17756@APFDCB5C> <1205765204.6767.129.camel@localhost.localdomain> <20080319142419.GA27779@devserv.devel.redhat.com> <20080320135518W.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:52043 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbYCTJnA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Mar 2008 05:43:00 -0400
Received: by wf-out-1314.google.com with SMTP id 28so888231wff.4
        for <linux-scsi@vger.kernel.org>; Thu, 20 Mar 2008 02:43:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20080320135518W.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: alan@redhat.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hch@lst.de, dledford@redhat.com, fujita.tomonori@lab.ntt.co.jp

On Thu, Mar 20, 2008 at 01:56:28PM +0900, FUJITA Tomonori wrote:

> @@ -715,14 +709,9 @@ static struct orc_scb *orc_alloc_scb(struct orc_host * host)
>  static void orc_release_scb(struct orc_host *host, struct orc_scb *scb)
>  {
>  	unsigned long flags;
> -	u8 index, i, channel;
>  
>  	spin_lock_irqsave(&(host->allocation_lock), flags);
> -	channel = host->index;	/* Channel */
> -	index = scb->scbidx;
> -	i = index / 32;
> -	index %= 32;
> -	host->allocation_map[channel][i] |= (1 << index);
> +	set_bit(scb->scbidx, host->allocation_map[host->index]);
>  	spin_unlock_irqrestore(&(host->allocation_lock), flags);
>  }
>  

set_bit() and clear_bit() take unsigned long pointer as a bitmap in
the second argument on some architectures. I'd rather change the type of
allocation_map than proliferating the casts.

This is incremental patch to the original bugfix patch.

Subject: [patch 2/2] a100u2w: convert to use bitmap library for allocation_map

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/scsi/a100u2w.c |   38 ++++++++++++++------------------------
 drivers/scsi/a100u2w.h |    3 ++-
 2 files changed, 16 insertions(+), 25 deletions(-)

Index: 2.6-rc/drivers/scsi/a100u2w.c
===================================================================
--- 2.6-rc.orig/drivers/scsi/a100u2w.c
+++ 2.6-rc/drivers/scsi/a100u2w.c
@@ -71,6 +71,7 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
+#include <linux/bitmap.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -478,13 +479,10 @@ static void setup_SCBs(struct orc_host *
 
 static void init_alloc_map(struct orc_host * host)
 {
-	u8 i, j;
+	int i;
 
-	for (i = 0; i < MAX_CHANNELS; i++) {
-		for (j = 0; j < 8; j++) {
-			host->allocation_map[i][j] = 0xffffffff;
-		}
-	}
+	for (i = 0; i < MAX_CHANNELS; i++)
+		bitmap_fill(host->allocation_map[i], 256);
 }
 
 /**
@@ -666,21 +664,16 @@ static struct orc_scb *__orc_alloc_scb(s
 {
 	u8 channel;
 	unsigned long idx;
-	u8 index;
-	u8 i;
 
 	channel = host->index;
-	for (i = 0; i < 8; i++) {
-		for (index = 0; index < 32; index++) {
-			if ((host->allocation_map[channel][i] >> index) & 0x01) {
-				host->allocation_map[channel][i] &= ~(1 << index);
-				idx = index + 32 * i;
-				/*
-				 * Translate the index to a structure instance
-				 */
-				return host->scb_virt + idx;
-			}
-		}
+
+	idx = find_first_bit(host->allocation_map[channel], 256);
+	if (idx < 256) {
+		clear_bit(idx, host->allocation_map[channel]);
+		/*
+		 * Translate the index to a structure instance
+		 */
+		return host->scb_virt + idx;
 	}
 	return NULL;
 }
@@ -716,14 +709,11 @@ static struct orc_scb *orc_alloc_scb(str
 static void orc_release_scb(struct orc_host *host, struct orc_scb *scb)
 {
 	unsigned long flags;
-	u8 index, i, channel;
+	u8 channel;
 
 	spin_lock_irqsave(&(host->allocation_lock), flags);
 	channel = host->index;	/* Channel */
-	index = scb->scbidx;
-	i = index / 32;
-	index %= 32;
-	host->allocation_map[channel][i] |= (1 << index);
+	set_bit(scb->scbidx, host->allocation_map[channel]);
 	spin_unlock_irqrestore(&(host->allocation_lock), flags);
 }
 
Index: 2.6-rc/drivers/scsi/a100u2w.h
===================================================================
--- 2.6-rc.orig/drivers/scsi/a100u2w.h
+++ 2.6-rc/drivers/scsi/a100u2w.h
@@ -239,7 +239,8 @@ struct orc_host {
 	dma_addr_t escb_phys;	/* scatter list Physical address */
 	u8 target_flag[16];	/* target configuration, TCF_EN_TAG */
 	u8 max_tags[16];	/* ORC_MAX_SCBS */
-	u32 allocation_map[MAX_CHANNELS][8];	/* Max STB is 256, So 256/32 */
+	/* Max STB is 256 */
+	unsigned long allocation_map[MAX_CHANNELS][BITS_TO_LONGS(256)];
 	spinlock_t allocation_lock;
 	struct pci_dev *pdev;
 };
