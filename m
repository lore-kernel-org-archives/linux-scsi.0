From: Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH] libsrp: free kfifo struct in srp_iu_pool_free
Date: Mon, 30 Mar 2009 18:49:01 +0000
Message-ID: <20090330184901.GC11116@hera.kernel.org>
References: <200903291119.42080.jdelvare@suse.de> <20090330184458.GB11116@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:38628 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599AbZC3S6O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Mar 2009 14:58:14 -0400
Content-Disposition: inline
In-Reply-To: <20090330184458.GB11116@hera.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Wright <chrisw@sous-sol.org>
Cc: Jean Delvare <jdelvare@suse.de>, stable@kernel.org, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Appears to be a small leak here when freeing pool, the kfifo gets left
behind.  Did I miss a caller that frees kfifo?

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 15e2d13..3a305f8 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -81,6 +81,7 @@ static void srp_iu_pool_free(struct srp_queue *q)
 {
 	kfree(q->items);
 	kfree(q->pool);
+	kfree(q->queue);
 }
 
 static struct srp_buf **srp_ring_alloc(struct device *dev,
