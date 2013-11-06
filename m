From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/5] scsi: improved eh timeout handler
Date: Wed, 06 Nov 2013 09:23:03 -0800
Message-ID: <527A7AF7.10809@cs.wisc.edu>
References: <1383635145-112651-1-git-send-email-hare@suse.de> <1383635145-112651-3-git-send-email-hare@suse.de> <527944BF.9000507@cs.wisc.edu> <5279E64E.8040005@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58633 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab3KFRZD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Nov 2013 12:25:03 -0500
In-Reply-To: <5279E64E.8040005@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

On 11/05/2013 10:48 PM, Hannes Reinecke wrote:
> On 11/05/2013 08:19 PM, Mike Christie wrote:
>> On 11/04/2013 11:05 PM, Hannes Reinecke wrote:
>>> +
>>> +	scmd->eh_eflags |= SCSI_EH_ABORT_SCHEDULED;
>>> +	SCSI_LOG_ERROR_RECOVERY(3,
>>> +		scmd_printk(KERN_INFO, scmd,
>>> +			    "scmd %p abort scheduled\n", scmd));
>>> +	schedule_delayed_work(&scmd->abort_work, HZ / 100);
>>> +	return SUCCESS;
>>> +}
>>
>> Do we want to use our own workqueue_struct with WQ_MEM_RECLAIM set?
>>
> Errm. Yes, why?
> 
> I must admit I'm not _that_ familiar with workqueues ...
> Care to explain?
> 

We all share the above workqueue_structs pool of threads, so if we get
stuck behind code doing GFP_KERNEL allocs that end up needing to write
data to the disk we are now trying to aborts on, then we could get
stuck. With WQ_MEM_RECLAIM, we have our own backup thread that gets
created at workqueue_struct create time which can get used in cases like
that so we can always make forward progress.

