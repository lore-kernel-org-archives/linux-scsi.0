From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 14/30] scsi: aacraid semaphore cleanup
Date: Tue, 07 Sep 2010 14:32:47 -0000
Message-ID: <20100907125056.040881100@linutronix.de>
References: <20100907124636.880953480@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:43756 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113Ab0IGOdL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2010 10:33:11 -0400
Content-Disposition: inline; filename=drivers-scsi-sema.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/aacraid/commctrl.c |    2 +-
 drivers/scsi/aacraid/commsup.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/scsi/aacraid/commctrl.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aacraid/commctrl.c
+++ linux-2.6/drivers/scsi/aacraid/commctrl.c
@@ -190,7 +190,7 @@ static int open_getadapter_fib(struct aa
 		/*
 		 *	Initialize the mutex used to wait for the next AIF.
 		 */
-		init_MUTEX_LOCKED(&fibctx->wait_sem);
+		sema_init(&fibctx->wait_sem, 0);
 		fibctx->wait = 0;
 		/*
 		 *	Initialize the fibs and set the count of fibs on
Index: linux-2.6/drivers/scsi/aacraid/commsup.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aacraid/commsup.c
+++ linux-2.6/drivers/scsi/aacraid/commsup.c
@@ -124,7 +124,7 @@ int aac_fib_setup(struct aac_dev * dev)
 		fibptr->hw_fib_va = hw_fib;
 		fibptr->data = (void *) fibptr->hw_fib_va->data;
 		fibptr->next = fibptr+1;	/* Forward chain the fibs */
-		init_MUTEX_LOCKED(&fibptr->event_wait);
+		sema_init(&fibptr->event_wait, 0);
 		spin_lock_init(&fibptr->event_lock);
 		hw_fib->header.XferState = cpu_to_le32(0xffffffff);
 		hw_fib->header.SenderSize = cpu_to_le16(dev->max_fib_size);


