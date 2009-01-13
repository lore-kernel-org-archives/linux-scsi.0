From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Open/iSCSI] Memory leak in repetitive --login/--logout with
 v2.0-870.1
Date: Mon, 12 Jan 2009 20:41:13 -0600
Message-ID: <496BFF49.5030204@cs.wisc.edu>
References: <1231539756.4560.1028.camel@haakon2.linux-iscsi.org>	 <496AA4D1.9060701@cs.wisc.edu> <1231806432.1274.6.camel@haakon2.linux-iscsi.org> <496BED4A.7030006@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050906010300060306030404"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59343 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbZAMClX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2009 21:41:23 -0500
In-Reply-To: <496BED4A.7030006@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

This is a multi-part message in MIME format.
--------------050906010300060306030404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mike Christie wrote:
> Nicholas A. Bellinger wrote:
> 
>> Ok, I still have my hands full with LIO v3.0 code atm, so I am not sure
>> how soon I could get to this..
>>
> 
> Don't worry about it. I can replicate it here.
> 

Crazy, I guess it is a leak we always had (at least back to 2.6.22 (did 
not look firther)), and no one noticed. Here is a patch. I will send it 
to James with some other patches I had.

Thanks for the report.

--------------050906010300060306030404
Content-Type: text/plain;
 name="libiscsi-fix-pool-queue-leak.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libiscsi-fix-pool-queue-leak.patch"

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7225b6e..257c241 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1981,6 +1981,7 @@ void iscsi_pool_free(struct iscsi_pool *q)
 		kfree(q->pool[i]);
 	if (q->pool)
 		kfree(q->pool);
+	kfree(q->queue);
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
 

--------------050906010300060306030404--
