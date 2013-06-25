From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v11 6/9] Make scsi_remove_host() wait until error handling
 finished
Date: Tue, 25 Jun 2013 13:13:08 +0200
Message-ID: <51C97B44.7050101@acm.org>
References: <51B86E26.6030108@acm.org> <51B86FC1.6000103@acm.org>  <1372101557.2013.76.camel@dabdike.int.hansenpartnership.com>  <51C8A668.3060700@cs.wisc.edu> <1372112866.2013.104.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:41100 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab3FYLNM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jun 2013 07:13:12 -0400
In-Reply-To: <1372112866.2013.104.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>

On 06/25/13 00:27, James Bottomley wrote:
> For a variety of reasons this patch set is incredibly hard to review:
> Almost every patch touches pieces in the mid layer where you have to be
> sure in minute detail you know what's going on (and what should be going
> on), so usually it's a couple of hours with the source code just making
> sure you do know this.  Plus it's code where the underlying usage model
> has evolved over the years meaning the original guarantees might have
> been violated silently somewhere and the ramifications spread out like
> tentacles everywhere.  Finally, it's not clear from the change logs why
> the changes are actually being made: for instance sentence one of this
> change log says "A SCSI LLD may start cleaning up host resources as soon
> as scsi_remove_host() returns." which causes my sanity checker to go off
> immediately because in a refcounted model, like we use for dev, target
> and host, nothing essential is supposed to be freed until the last put
> which may or may not happen in the remove function.

If the invocations of the eh_* callback functions would be visible to 
the block layer then blk_cleanup_queue() would wait until any such eh_* 
invocations have finished. Such an approach could simplify device 
removal in the SCSI mid-layer significantly. It also would avoid that an 
eh_* callback can be invoked via an ioctl after scsi_remove_device() has 
finished.

Bart.

