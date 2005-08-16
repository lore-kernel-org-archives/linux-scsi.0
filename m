From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [PATCH 2.4.12.5 1/2] lib: allow idr to be used in irq context
Date: Tue, 16 Aug 2005 17:55:50 -0400
Message-ID: <430260E6.4090108@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:13245 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750980AbVHPV4D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Aug 2005 17:56:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Dave Jones <davej@redhat.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: Jim Houston <jim.houston@ccur.com>

Hi,

This patch allows idr to be used in irq context.

idr_pre_get() is necessary to be called before
idr_get_new() is called.  No locking is necessary when
calling idr_pre_get().

But idr_get_new(), idr_find() and idr_remove()
must be serialized with respect to each other.

All of the aforementioned, may end up in alloc_layer()
or free_layer() which grabs the idp lock using spin_lock.

If idr_get_new() or idr_remove() is used in IRQ context,
then we may get a lockup when idr_pre_get was called
in process context and an IRQ interrupted while it held
the idp lock.

This patch changes the spin_lock to spin_lock_irqsave,
and spin_unlock to spin_unlock_irqrestore, to allow
idr_get_new(), idr_find() and idr_remove() to be
called from IRQ context, while idr_pre_get() to be
called in process context.

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

--- linux-2.6.12.5/lib/idr.c.old	2005-08-16 17:20:08.000000000 -0400
+++ linux-2.6.12.5/lib/idr.c	2005-08-16 17:22:16.000000000 -0400
@@ -37,27 +37,29 @@
 static struct idr_layer *alloc_layer(struct idr *idp)
 {
 	struct idr_layer *p;
+	unsigned long flags;
 
-	spin_lock(&idp->lock);
+	spin_lock_irqsave(&idp->lock, flags);
 	if ((p = idp->id_free)) {
 		idp->id_free = p->ary[0];
 		idp->id_free_cnt--;
 		p->ary[0] = NULL;
 	}
-	spin_unlock(&idp->lock);
+	spin_unlock_irqrestore(&idp->lock, flags);
 	return(p);
 }
 
 static void free_layer(struct idr *idp, struct idr_layer *p)
 {
+	unsigned long flags;
 	/*
 	 * Depends on the return element being zeroed.
 	 */
-	spin_lock(&idp->lock);
+	spin_lock_irqsave(&idp->lock, flags);
 	p->ary[0] = idp->id_free;
 	idp->id_free = p;
 	idp->id_free_cnt++;
-	spin_unlock(&idp->lock);
+	spin_unlock_irqrestore(&idp->lock, flags);
 }
 
 /**
