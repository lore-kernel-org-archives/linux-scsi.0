From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 7/7] libiscsi: fix iscsi pool error path
Date: Thu, 02 Apr 2009 11:05:16 -0500
Message-ID: <49D4E23C.2010201@cs.wisc.edu>
References: <1238609489948-git-send-email-michaelc@cs.wisc.edu> <12386094922477-git-send-email-michaelc@cs.wisc.edu> <12386094933319-git-send-email-michaelc@cs.wisc.edu> <200904021602.55587.jdelvare@suse.de> <49D4D68A.8080606@cs.wisc.edu> <20090402152715.GF18394@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050804010509010901010504"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43225 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbZDBQGS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Apr 2009 12:06:18 -0400
In-Reply-To: <20090402152715.GF18394@sequoia.sous-sol.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Wright <chrisw@sous-sol.org>
Cc: Jean Delvare <jdelvare@suse.de>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>

This is a multi-part message in MIME format.
--------------050804010509010901010504
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Chris Wright wrote:
> * Mike Christie (michaelc@cs.wisc.edu) wrote:
>>>> -	if (q->queue == ERR_PTR(-ENOMEM))
>>>> +	if (IS_ERR(q->queue)) {
>>> This indeed solves the problem I had underlined before, but
>>> introduces a new one. Right now the only error returned by kfifo_init
>>> is -ENOMEM. This may however change in the future, and then the
>>> above code would silently convert the other error code to -ENOMEM.
>>> This might make it difficult to trace errors.
>> What do you mean by converting other errors codes to -ENOMEM?
> 
> Jean means the goto label...it will jump to essentially return -ENOMEM.
> 

Ah, ok, I can agree with passing up errors in general. I did the 
attached patch to propogate the error code upwards. It does not really 
make much difference now. The iscsi pool init caller just checks for 
error or no error and does not even print out the error. It will not 
make tracing errors easier or more difficult. To be useful, we would 
have to propgate the error higher to userspace so the user can see it. I 
do not think I have time to get that in the current feature window, so 
that would have to wait unless you have patches I can test now.

--------------050804010509010901010504
Content-Type: text/plain;
 name="libiscsi-propogate-pool-error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libiscsi-propogate-pool-error.patch"

libiscsi: propogate errors from kfifo_init to iscsi_pool_init callers

Don't convert kfifo_init's error code to -ENOMEM when passing the
error to the iscsi_pool_init caller.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 6896283..cf86d59 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1984,6 +1984,7 @@ int
 iscsi_pool_init(struct iscsi_pool *q, int max, void ***items, int item_size)
 {
 	int i, num_arrays = 1;
+	int rc = -ENOMEM;
 
 	memset(q, 0, sizeof(*q));
 
@@ -1995,20 +1996,21 @@ iscsi_pool_init(struct iscsi_pool *q, int max, void ***items, int item_size)
 		num_arrays++;
 	q->pool = kzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL);
 	if (q->pool == NULL)
-		return -ENOMEM;
+		return rc;
 
 	q->queue = kfifo_init((void*)q->pool, max * sizeof(void*),
 			      GFP_KERNEL, NULL);
 	if (IS_ERR(q->queue)) {
 		q->queue = NULL;
-		goto enomem;
+		rc = PTR_ERR(q->queue);		
+		goto fail;
 	}
 
 	for (i = 0; i < max; i++) {
 		q->pool[i] = kzalloc(item_size, GFP_KERNEL);
 		if (q->pool[i] == NULL) {
 			q->max = i;
-			goto enomem;
+			goto fail;
 		}
 		__kfifo_put(q->queue, (void*)&q->pool[i], sizeof(void*));
 	}
@@ -2020,9 +2022,9 @@ iscsi_pool_init(struct iscsi_pool *q, int max, void ***items, int item_size)
 
 	return 0;
 
-enomem:
+fail:
 	iscsi_pool_free(q);
-	return -ENOMEM;
+	return rc;
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_init);
 

--------------050804010509010901010504--
