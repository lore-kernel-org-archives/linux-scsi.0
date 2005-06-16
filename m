From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Thu, 16 Jun 2005 00:31:27 -0700
Message-ID: <20050616073127.GA20051@us.ibm.com>
References: <1118876632.5045.90.camel@mulgrave> <Pine.LNX.4.44L0.0506152205000.5061-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:4048 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261152AbVFPHa5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2005 03:30:57 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5G7UuiD001685
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 03:30:56 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j5G7UuwU211658
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 03:30:56 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5G7UuSj024133
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 03:30:56 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0506152205000.5061-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> On Wed, 15 Jun 2005, James Bottomley wrote:
> 
> > On Wed, 2005-06-15 at 17:11 -0400, Alan Stern wrote:
> > > This means that scsi_target_reap can be called and the __targets list 
> > > changed essentially at any time (subject only to the host_lock).  Hence it 
> > > is impossible for scsi_forget_host to iterate through the list of targets 
> > > belonging to the host: While it is working to remove one target, the next 
> > > target on the list (stored in the tmp variable) might be removed by 
> > > another thread.
> > 
> > It's no better nor worse than we already have.  As has been said many
> > times before, we need a proper host state model.
> > 
> > > In fact there doesn't seem to be any safe way to remove all the targets
> > > from a host.  And what's to prevent scsi_target_reap being called twice
> > > for the same target?
> > 
> > The usage, if you look at the code ... it's alloc/reap or inc
> > reap_ref/reap
> 
> Okay, I understand a little better now.
> 
> Would it hurt anything to change scsi_remove_host so that SHOST_DEL gets
> set at the start, before scsi_forget_host is called?  If that were done,
> then we could make every pathway that adds a device acquire the scan_mutex
> and fail if SHOST_DEL is already set.  Thus no devices would ever be added
> after forget_host had removed the existing ones, which can happen as
> things stand.
> 
> Furthermore, forget_host could be changed to loop over the __devices list
> instead of the __targets list.  The net effect would be the same: All the
> devices on the host would be removed and the targets would automatically
> get reaped by scsi_device_dev_release.  There wouldn't be any need to
> iterate over the targets at all.
> 
> As a final change, the new loop-over-devices in forget_host and the one in
> __scsi_remove_target should be made to skip over devices with SDEV_DEL
> already set, and each time they call scsi_remove_device the loops should
> restart from the beginning.  This will eliminate the problem of the tmp
> pointer being pulled out from under the code (even though it has 
> quadratic behavior).
> 
> Do these changes sound okay?
> 

I have something similar that I was testing since you mentioned the
problem the other day. Our build machine went down so I will need to wait
until tomorrow to get access to my patches for a post, if you have already
rolled a patch we can compare notes when I post.

What I did in the patch sequence was:
	1.) Recode the scsi_host state model to align with the device
	state model (i.e. added scsi_host_set_state function and
	associated changes).
	2.) Made shost cancel matched the scsi device state model and set
	this at the top of scsi_remove_host. Previous cancel code was not
	doing anything as the list was normally empty do to
	scsi_forget_host being called first. Also there where possible
	race conditions that you previously mentioned about canceling
	commands in this method.
	3.) Added choke point checks under the scan_mutex to determine if
	scanning is allowed (scsi_host_scan_allowed).
	4.) Added a target state model to match the scsi device state
	model.
	5.) I use the STGT_CANCEL and STGT_DEL states in scsi_forget_host
	to skip over entries in the list as I am no longer using the
	_safe version.
This looks like a good starting point with limited testing. I also need to
more states to the target state model as I only added a few that I needed
for the delete code.

Anyway sorry about the delay.

-andmike
--
Michael Anderson
andmike@us.ibm.com

