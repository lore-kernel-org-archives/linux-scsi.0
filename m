From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v11 6/9] Make scsi_remove_host() wait until error handling
 finished
Date: Tue, 25 Jun 2013 19:47:04 +0200
Message-ID: <51C9D798.6000206@acm.org>
References: <51B86E26.6030108@acm.org> <51B86FC1.6000103@acm.org>    <1372101557.2013.76.camel@dabdike.int.hansenpartnership.com>    <51C8A668.3060700@cs.wisc.edu>   <1372112866.2013.104.camel@dabdike.int.hansenpartnership.com>   <51C95C79.2080804@acm.org> <1372167923.2806.13.camel@dabdike>  <51C9B7D1.9040702@acm.org>  <FBC61EDC-F703-4E3F-9980-70D41EE9484F@cs.wisc.edu> <1372182057.2806.43.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:39265 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3FYRrH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jun 2013 13:47:07 -0400
In-Reply-To: <1372182057.2806.43.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>

On 06/25/13 19:40, James Bottomley wrote:
> If I look at what we actually do: all the HBAs treat scsi_remove_host as
> a waited for transition.  The reason this works is the loop over
> __scsi_remove_device() in scsi_forget_host().  By the time that loop
> returns, every scsi_device is gone (and so is every target).  Because
> blk_cleanup_queue() induces a synchronous wait for the queue to die in
> __scsi_remove_device(), there can be no outstanding I/O and no eh
> activity for the device when it returns (and no possibility of starting
> any).  Thus at the end of scsi_forget_host, we have no devices to start
> I/O and no eh activity, so the final put will be the last.

With the patch at the start of this thread everything works like you 
described above. However, without that patch EH activity can continue 
after scsi_remove_device() has returned. I have seen that occurring 
several times while testing SCSI LLD patches.

Bart.

