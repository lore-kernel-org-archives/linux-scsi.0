From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Fix SCSI regression in 2.6.27 [was [Bugme-new] [Bug
	12099] New: Nokia 5310 storage-mode]
Date: Tue, 25 Nov 2008 23:07:47 -0600
Message-ID: <1227676067.3415.63.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0811251026500.2457-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47966 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750760AbYKZFHv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2008 00:07:51 -0500
In-Reply-To: <Pine.LNX.4.44L0.0811251026500.2457-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, stable@kernel.org

On Tue, 2008-11-25 at 10:34 -0500, Alan Stern wrote:
> This patch is intended for 2.6.27.stable and 2.6.28.  It's a temporary 
> fix for a problem affecting a number of USB mass-storage devices 
> (including many Nokia phones): When trying to access a nonexistent 
> "last" sector, the SCSI midlayer gets caught in an endless retry loop.

Can't we just invoke the last sector handling flag for all Nokia
devices?

> See for example Bugzilla #11843 and #12099.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> On Tue, 25 Nov 2008, Andrew Morton wrote:
> 
> > On Tue, 25 Nov 2008 01:07:43 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:
> > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=12099
> > > 
> > >            Summary: Nokia 5310 storage-mode
> > >            Product: Drivers
> > >            Version: 2.5
> > >      KernelVersion: 2.6.27
> > >           Platform: All
> > >         OS/Version: Linux
> > >               Tree: Mainline
> > >             Status: NEW
> > >           Severity: normal
> > >           Priority: P1
> > >          Component: USB
> > >         AssignedTo: greg@kroah.com
> > >         ReportedBy: robsonpeixoto@gmail.com
> > > 
> > > 
> > > Latest working kernel version: 2.6.26
> > > Earliest failing kernel version: 2.6.27
> > 
> > A regression.
> > 
> > > Distribution: ArchLinux
> > > Hardware Environment: USB(ohci,ehci)
> > > Software Environment: gcc 4.3.2, glibc 2.8
> > > Problem Description: 
> > > 
> > > When I plug in my Nokia 5310 show a msg in cel "Transferring data" and in
> > > computer nothing happend.
> 
> Unless we want to keep on receiving regression reports like this one,
> this patch or something like it needs to be applied.  We can hope
> 2.6.29 will work better...  But unhappily, to date James has not
> responded to any of my patch submissions in this area.
> 
> Alan Stern
> 
> 
> 
> Index: 2.6.27.4/drivers/scsi/scsi_lib.c
> ===================================================================
> --- 2.6.27.4.orig/drivers/scsi/scsi_lib.c
> +++ 2.6.27.4/drivers/scsi/scsi_lib.c
> @@ -611,6 +611,11 @@ static void scsi_requeue_command(struct 
>  	struct request *req = cmd->request;
>  	unsigned long flags;
>  
> +	if (--req->retries < 0) {
> +		blk_end_request(req, -EIO, blk_rq_bytes(req));
> +		scsi_next_command(cmd);
> +		return;
> +	}

This would cause tape errors on unit attention (fairly common
condition).  It can be argued that we get more users of USB mobile
phones than tapes, but I'd rather keep both communities happy

By and large, the reason we backport from head if at all possible is so
we can avoid bugs like this creeping into stable.  (And backporting from
head is far easier if the bug fixes are small and don't contain
miscellaneous code clean ups, control flow changes and comment fixes)

> Unless we want to keep on receiving regression reports like this one,
> this patch or something like it needs to be applied.  We can hope
> 2.6.29 will work better...  But unhappily, to date James has not
> responded to any of my patch submissions in this area.

I tried to untangle it on the 'plane yesterday.  I've just got a bit
more testing to do then I'll post the patch to your patch.

James


