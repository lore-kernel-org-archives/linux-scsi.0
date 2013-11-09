From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 2/5] scsi: improved eh timeout handler
Date: Sat, 9 Nov 2013 08:35:32 +0000
Message-ID: <1383986131.18681.15.camel@dabdike>
References: <1383635145-112651-1-git-send-email-hare@suse.de>
	 <1383635145-112651-3-git-send-email-hare@suse.de>
	 <527944BF.9000507@cs.wisc.edu> <5279E64E.8040005@suse.de>
	 <527A7AF7.10809@cs.wisc.edu> <527B3707.9060202@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:36740 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3KIIgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Nov 2013 03:36:24 -0500
In-Reply-To: <527B3707.9060202@suse.de>
Content-Language: en-US
Content-ID: <3ACFA1E727182944B40B66D48EB7E116@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

On Thu, 2013-11-07 at 07:45 +0100, Hannes Reinecke wrote:
> On 11/06/2013 06:23 PM, Mike Christie wrote:
> > On 11/05/2013 10:48 PM, Hannes Reinecke wrote:
> >> On 11/05/2013 08:19 PM, Mike Christie wrote:
> >>> On 11/04/2013 11:05 PM, Hannes Reinecke wrote:
> >>>> +
> >>>> +	scmd->eh_eflags |= SCSI_EH_ABORT_SCHEDULED;
> >>>> +	SCSI_LOG_ERROR_RECOVERY(3,
> >>>> +		scmd_printk(KERN_INFO, scmd,
> >>>> +			    "scmd %p abort scheduled\n", scmd));
> >>>> +	schedule_delayed_work(&scmd->abort_work, HZ / 100);
> >>>> +	return SUCCESS;
> >>>> +}
> >>>
> >>> Do we want to use our own workqueue_struct with WQ_MEM_RECLAIM set?
> >>>
> >> Errm. Yes, why?
> >>
> >> I must admit I'm not _that_ familiar with workqueues ...
> >> Care to explain?
> >>
> > 
> > We all share the above workqueue_structs pool of threads, so if we get
> > stuck behind code doing GFP_KERNEL allocs that end up needing to write
> > data to the disk we are now trying to aborts on, then we could get
> > stuck. With WQ_MEM_RECLAIM, we have our own backup thread that gets
> > created at workqueue_struct create time which can get used in cases like
> > that so we can always make forward progress.
> > 
> Ah. Right. Yes, that makes sense.
> 
> I guess I'll have to redo the patches _yet again_.

So when were you going to send the redo?  The merge window is now open
and Linus was shirty with me about a late merge last time ...

James

