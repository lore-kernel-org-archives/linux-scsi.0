From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] a100u2w: fix bitmap lookup routine
Date: Thu, 20 Mar 2008 13:56:28 +0900
Message-ID: <20080320135518W.tomof@acm.org>
References: <20080317123200.GA17756@APFDCB5C>
	<1205765204.6767.129.camel@localhost.localdomain>
	<20080319142419.GA27779@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:40368 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbYCTE5P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 00:57:15 -0400
In-Reply-To: <20080319142419.GA27779@devserv.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: alan@redhat.com
Cc: James.Bottomley@HansenPartnership.com, akinobu.mita@gmail.com, linux-scsi@vger.kernel.org, hch@lst.de, dledford@redhat.com, fujita.tomonori@lab.ntt.co.jp

On Wed, 19 Mar 2008 10:24:19 -0400
Alan Cox <alan@redhat.com> wrote:

> On Mon, Mar 17, 2008 at 09:46:44AM -0500, James Bottomley wrote:
> > On Mon, 2008-03-17 at 21:32 +0900, Akinobu Mita wrote:
> > > This patch is only compile tested.
> > 
> > It looks fine to me ... I don't suppose we can find someone with an
> > actual card to test it out, could we?
> > 
> > Another observation is that this code is really trying to reinvent
> > bitmaps, so if someone with a card cares they could convert it over to
> > the linux bitmap infrastructure.
> 
> If you want it tested then send me the patch.

Can you try this?

Thanks,

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index f608d4a..a183dab 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -664,22 +664,16 @@ static int orc_device_reset(struct orc_host * host, struct scsi_cmnd *cmd, unsig
 
 static struct orc_scb *__orc_alloc_scb(struct orc_host * host)
 {
-	u8 channel;
-	unsigned long idx;
-	u8 index;
-	u8 i;
+	long idx;
+	unsigned size = sizeof(host->allocation_map[host->index]) * 8;
+	unsigned long *map = (unsigned long *)host->allocation_map[host->index];
 
-	channel = host->index;
-	for (i = 0; i < 8; i++) {
-		for (index = 0; index < 32; index++) {
-			if ((host->allocation_map[channel][i] >> index) & 0x01) {
-				host->allocation_map[channel][i] &= ~(1 << index);
-				break;
-			}
-		}
-		idx = index + 32 * i;
+	idx = find_first_bit(map, size);
+	if (idx < size) {
+		clear_bit(idx, map);
 		/* Translate the index to a structure instance */
-		return (struct orc_scb *) ((unsigned long) host->scb_virt + (idx * sizeof(struct orc_scb)));
+		return (struct orc_scb *)((unsigned long) host->scb_virt
+					  + (idx * sizeof(struct orc_scb)));
 	}
 	return NULL;
 }
@@ -715,14 +709,9 @@ static struct orc_scb *orc_alloc_scb(struct orc_host * host)
 static void orc_release_scb(struct orc_host *host, struct orc_scb *scb)
 {
 	unsigned long flags;
-	u8 index, i, channel;
 
 	spin_lock_irqsave(&(host->allocation_lock), flags);
-	channel = host->index;	/* Channel */
-	index = scb->scbidx;
-	i = index / 32;
-	index %= 32;
-	host->allocation_map[channel][i] |= (1 << index);
+	set_bit(scb->scbidx, host->allocation_map[host->index]);
 	spin_unlock_irqrestore(&(host->allocation_lock), flags);
 }
 
