From: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] [PATCH] [SCSI] libiscsi: fix iscsi pool error path
Date: Mon, 30 Mar 2009 18:44:58 +0000
Message-ID: <20090330184458.GB11116@hera.kernel.org>
References: <200903291119.42080.jdelvare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:50749 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461AbZC3SyY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Mar 2009 14:54:24 -0400
Content-Disposition: inline
In-Reply-To: <200903291119.42080.jdelvare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jean Delvare <jdelvare@suse.de>
Cc: stable@kernel.org, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

* Jean Delvare (jdelvare@suse.de) wrote:
> --- linux-2.6.29-rc5.orig/drivers/scsi/libiscsi.c	2009-01-29 08:27:19.000000000 +0100
> +++ linux-2.6.29-rc5/drivers/scsi/libiscsi.c	2009-02-16 21:19:14.000000000 +0100
> @@ -1944,7 +1944,7 @@ iscsi_pool_init(struct iscsi_pool *q, in
>  		num_arrays++;
>  	q->pool = kzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL);
>  	if (q->pool == NULL)
> -		goto enomem;
> +		return -ENOMEM;
>  
>  	q->queue = kfifo_init((void*)q->pool, max * sizeof(void*),
>  			      GFP_KERNEL, NULL);
> @@ -1979,8 +1979,7 @@ void iscsi_pool_free(struct iscsi_pool *
>  
>  	for (i = 0; i < q->max; i++)
>  		kfree(q->pool[i]);
> -	if (q->pool)
> -		kfree(q->pool);
> +	kfree(q->pool);
>  	kfree(q->queue);

AFAICT, This is still broken.

thanks,
-chris
--

Subject: [PATCH] libiscsi: fix error path on iscsi_pool_init

From: Chris Wright <chrisw@sous-sol.org>

I'm not all that keen on kfifo_init returning ERR_PTR, but...
q->queue could be ERR_PTR(-ENOMEM) which will break unwinding
on error.  Make iscsi_pool_free more defensive.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index dfaa8ad..2f4df53 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1995,7 +1995,7 @@ iscsi_pool_init(struct iscsi_pool *q, int max, void ***items, int item_size)
 		num_arrays++;
 	q->pool = kzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL);
 	if (q->pool == NULL)
-		return -ENOMEM;
+		goto enomem;
 
 	q->queue = kfifo_init((void*)q->pool, max * sizeof(void*),
 			      GFP_KERNEL, NULL);
@@ -2028,10 +2028,13 @@ void iscsi_pool_free(struct iscsi_pool *q)
 {
 	int i;
 
-	for (i = 0; i < q->max; i++)
-		kfree(q->pool[i]);
-	kfree(q->pool);
-	kfree(q->queue);
+	if (q->pool) {
+		for (i = 0; i < q->max; i++)
+			kfree(q->pool[i]);
+		kfree(q->pool);
+		if (!IS_ERR(q->queue))
+			kfree(q->queue);
+	}
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
 
