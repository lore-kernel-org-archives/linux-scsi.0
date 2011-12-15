From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: Make UAS work on HS for devices with and without command tagging
 support
Date: Thu, 15 Dec 2011 09:44:37 +0100
Message-ID: <4EE9B375.4020606@linutronix.de>
References: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de> <20111214225331.GA5508@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:35950 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758343Ab1LOIom (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2011 03:44:42 -0500
In-Reply-To: <20111214225331.GA5508@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>

On 12/14/2011 11:53 PM, Sarah Sharp wrote:
> Thanks for testing!  Are these patches on top of the patches I sent out
> a week ago?  Or just on top of Greg's tree?

They are ontop of Greg's tree. I know that you sent a patch to fix the
same issue I did on my #1 patch. I remember that something did not work
out. It might be the thing for which I need #2. So if you want me to
rebase those two or redo something please let me know.

>> To deal with canceled commands (where we may have to kill some status urbs)
>> I've been thinking about a list within uas_dev_info which keeps track of
>> all status urbs and counts all commands which are queued.  Once we start
>> removing commands which timed out we should make sure that the number of
>> commands which remain is the same as the number of status urbs which we
>> have. If we have more status urbs than commands then we kill some status
>> urbs. If it is the other way around then someone was too trigger happy.
>
> That might work, but we'd have to synchronize the list manipulations
> across status completions.  That would get complex in the USB 3.0 case,
> where we could (potentially, if the xHCI driver had multiple event ring
> support and the host had MSI-X support) have two status completion
> handlers running on different CPUs.  One of the completion handlers
> would have to spin, waiting on the other.  So if we can avoid a list of
> outstanding URBs, that would be better.

USB3.0. I see. On 3.0 we would have one status urb for each command so
it might end up in the command struct.

> Matthew was just mentioning to me that it might be good to just have one
> status URB per USB 2.0 UAS device, and just keep re-submitting it.  USB
> 2.0 devices don't have streams, so there can't be multiple status URBs
> being processed at the same time, so I think it would work.  The only
Oh. That sounds great. I've been thinking how to avoid multiple
allocation/allocation of them.

> difficulty I see is syncing the status completion with an abort of the
> same command, but I think that could be done with an RCU reader lock in
> the status completion.  There shouldn't be any performance difference
> between re-using one status URB or using a dedicated one in the
> cmnd_info structure.  Plus, we wouldn't have to allocate status URBs in
> completion handlers if we just used one dedicated status URB.

yep. Sounds like a plan.

> For USB 3.0 UAS, I think the status URB should stay in the cmnd_info
> structure, since we know that when a status URB completes for a
> particular stream ID, it is directly associated with that command, and
> not a different command.  So I'd like to address the sense URB failure
> issue you tried to fix in the second patch, but I think we should go
> about it in a different way.

Fine by me. You want me to redo #2 with one status urb/uas device or do
you do it yourself?

> Sarah Sharp

Sebastian
