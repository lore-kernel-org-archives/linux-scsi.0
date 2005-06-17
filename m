From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Thu, 16 Jun 2005 22:01:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506162149370.31849-100000@netrider.rowland.org>
References: <1118930260.4998.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.247.233.35] ([140.247.233.35]:26868 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S261897AbVFQCBj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2005 22:01:39 -0400
In-Reply-To: <1118930260.4998.6.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 16 Jun 2005, James Bottomley wrote:

> On Thu, 2005-06-16 at 00:31 -0700, Mike Anderson wrote:
> 
> > I have something similar that I was testing since you mentioned the
> > problem the other day. Our build machine went down so I will need to wait
> > until tomorrow to get access to my patches for a post, if you have already
> > rolled a patch we can compare notes when I post.
> > 
> > What I did in the patch sequence was:
> > 	1.) Recode the scsi_host state model to align with the device
> > 	state model (i.e. added scsi_host_set_state function and
> > 	associated changes).
> > 	2.) Made shost cancel matched the scsi device state model and set
> > 	this at the top of scsi_remove_host. Previous cancel code was not
> > 	doing anything as the list was normally empty do to
> > 	scsi_forget_host being called first. Also there where possible
> > 	race conditions that you previously mentioned about canceling
> > 	commands in this method.
> > 	3.) Added choke point checks under the scan_mutex to determine if
> > 	scanning is allowed (scsi_host_scan_allowed).
> > 	4.) Added a target state model to match the scsi device state
> > 	model.
> > 	5.) I use the STGT_CANCEL and STGT_DEL states in scsi_forget_host
> > 	to skip over entries in the list as I am no longer using the
> > 	_safe version.
> > This looks like a good starting point with limited testing. I also need to
> > more states to the target state model as I only added a few that I needed
> > for the delete code.

That's more ambitious than what I was planning, although it seems to cover
much the same ground.  At the moment my patchwork is only partly finished.

> That sounds something like what I was thinking.
> 
> There is some subtlety to this: the call to forget host with existing
> targets must:
> 
> a) put the host into a state where it won't accept any additions or
> removal.

I don't see anything wrong with allowing removals, but certainly it 
shouldn't accept any additions.  Would it be best to add a new 
SHOST_REMOVED state bit and test for it every time the scan_mutex is 
acquired?

> b) loop over targets and devices removing them from visibility and doing
> final puts for them

There's no point in looping over targets.  As the devices get released
they will automatically take the targets along with them.  Visibility of 
targets won't matter because no new devices can be created.

> c) finally remove the host from visibility, set the deleted state and do
> the final put (which may not remove the actual structure until the last
> referrer relinquishes its reference).

Aside from the visibility part, this is already done by scsi_remove_host 
and the LLDs, right?

> Also, since the target is a pure container, I don't think it needs to be
> a party to the state model.

Agreed.

Alan Stern

