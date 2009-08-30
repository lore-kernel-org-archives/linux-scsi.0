From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: [PATCH 2.6.30] libsrp: fix memory leak in srp_ring_free()
Date: Sun, 30 Aug 2009 12:36:48 +0200
Message-ID: <e2e108260908300336p777654bbw2f0b1eef9b6858c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:47764 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbZH3Kgr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2009 06:36:47 -0400
Received: by ewy2 with SMTP id 2so3260053ewy.17
        for <linux-scsi@vger.kernel.org>; Sun, 30 Aug 2009 03:36:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>

This patch fixes a memory leak in the libsrp function srp_ring_free().
It is not documented whether or not this function should free the ring
pointer itself. But the source code of the callers of this function
(srp_target_alloc() and srp_target_free()) makes it clear that
srp_ring_free() should deallocate the ring pointer itself. Furthermore,
the patch below makes srp_ring_free() deallocate all memory allocated by
srp_ring_alloc().

This patch affects the ibmvstgt driver, which is the only in-tree driver
that calls the srp_ring_free() function (indirectly).

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: FUJITA Tomonori <tomof@acm.org>

diff -uprN orig/linux-2.6.30/drivers/scsi/libsrp.c
linux-2.6.30/drivers/scsi/libsrp.c
--- orig/linux-2.6.30/drivers/scsi/libsrp.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30/drivers/scsi/libsrp.c	2009-08-30 11:53:26.000000000 +0200
@@ -124,6 +124,7 @@ static void srp_ring_free(struct device
 		dma_free_coherent(dev, size, ring[i]->buf, ring[i]->dma);
 		kfree(ring[i]);
 	}
+	kfree(ring);
 }

 int srp_target_alloc(struct srp_target *target, struct device *dev,
