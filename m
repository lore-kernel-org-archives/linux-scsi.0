From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v12 2/6] Avoid calling __scsi_remove_device() twice
Date: Mon, 1 Jul 2013 14:38:45 +0000
Message-ID: <1372689525.2385.16.camel@dabdike>
References: <51CC5176.90609@acm.org> <51CC51FC.5050901@acm.org>
	 <1372662351.2360.24.camel@dabdike> <51D12C5E.30801@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:35998 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3GAOi5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jul 2013 10:38:57 -0400
In-Reply-To: <51D12C5E.30801@acm.org>
Content-Language: en-US
Content-ID: <A9C8741082C9F44B87D46A5291F926CE@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Tejun Heo <tj@kernel.org>

On Mon, 2013-07-01 at 09:14 +0200, Bart Van Assche wrote:
> On 07/01/13 09:05, James Bottomley wrote:
> >
> > On Thu, 2013-06-27 at 16:53 +0200, Bart Van Assche wrote:
> >> If something goes wrong during LUN scanning, e.g. a transport layer
> >> failure occurs, then __scsi_remove_device() can get invoked by the
> >> LUN scanning code for a SCSI device in state SDEV_CREATED_BLOCK. If
> >> this happens then the SCSI device has not yet been added to sysfs
> >> (is_visible == 0).  Make sure that in that case the transition into
> >> state SDEV_DEL occurs. This avoids that __scsi_remove_device() gets
> >> invoked a second time by scsi_forget_host().
> >
> > The patch summary of this one isn't true.  How about "enable destruction
> > of blocked devices which fail LUN scanning"
> 
> Hello James,
> 
> Do you want me to repost the patch series or is this something you can 
> fix up ?

I can fix it up, but if you repost, please change it.

Thanks,

James

