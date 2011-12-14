From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: Make UAS work on HS for devices with and without command tagging
 support
Date: Wed, 14 Dec 2011 14:53:31 -0800
Message-ID: <20111214225331.GA5508@xanatos>
References: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9345 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758321Ab1LNWxc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2011 17:53:32 -0500
Content-Disposition: inline
In-Reply-To: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>

On Wed, Dec 14, 2011 at 07:47:50PM +0100, Sebastian Andrzej Siewior wrote:
> Hi Sarah and Matthew,
> 
> the two patches were required to get my new fancy uasp gadget work on HS
> with dummy_hcd. It is processing only one command at a time however it
> caught a few bugs already :)

Thanks for testing!  Are these patches on top of the patches I sent out
a week ago?  Or just on top of Greg's tree?

> To deal with canceled commands (where we may have to kill some status urbs)
> I've been thinking about a list within uas_dev_info which keeps track of
> all status urbs and counts all commands which are queued.  Once we start
> removing commands which timed out we should make sure that the number of
> commands which remain is the same as the number of status urbs which we
> have. If we have more status urbs than commands then we kill some status
> urbs. If it is the other way around then someone was too trigger happy.

That might work, but we'd have to synchronize the list manipulations
across status completions.  That would get complex in the USB 3.0 case,
where we could (potentially, if the xHCI driver had multiple event ring
support and the host had MSI-X support) have two status completion
handlers running on different CPUs.  One of the completion handlers
would have to spin, waiting on the other.  So if we can avoid a list of
outstanding URBs, that would be better.

Matthew was just mentioning to me that it might be good to just have one
status URB per USB 2.0 UAS device, and just keep re-submitting it.  USB
2.0 devices don't have streams, so there can't be multiple status URBs
being processed at the same time, so I think it would work.  The only
difficulty I see is syncing the status completion with an abort of the
same command, but I think that could be done with an RCU reader lock in
the status completion.  There shouldn't be any performance difference
between re-using one status URB or using a dedicated one in the
cmnd_info structure.  Plus, we wouldn't have to allocate status URBs in
completion handlers if we just used one dedicated status URB.

For USB 3.0 UAS, I think the status URB should stay in the cmnd_info
structure, since we know that when a status URB completes for a
particular stream ID, it is directly associated with that command, and
not a different command.  So I'd like to address the sense URB failure
issue you tried to fix in the second patch, but I think we should go
about it in a different way.

Sarah Sharp
