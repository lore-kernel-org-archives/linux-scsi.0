From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Thu, 16 Jun 2005 08:57:40 -0500
Message-ID: <1118930260.4998.6.camel@mulgrave>
References: <1118876632.5045.90.camel@mulgrave>
	 <Pine.LNX.4.44L0.0506152205000.5061-100000@netrider.rowland.org>
	 <20050616073127.GA20051@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:16056 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261554AbVFPN5p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2005 09:57:45 -0400
In-Reply-To: <20050616073127.GA20051@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2005-06-16 at 00:31 -0700, Mike Anderson wrote:

> I have something similar that I was testing since you mentioned the
> problem the other day. Our build machine went down so I will need to wait
> until tomorrow to get access to my patches for a post, if you have already
> rolled a patch we can compare notes when I post.
> 
> What I did in the patch sequence was:
> 	1.) Recode the scsi_host state model to align with the device
> 	state model (i.e. added scsi_host_set_state function and
> 	associated changes).
> 	2.) Made shost cancel matched the scsi device state model and set
> 	this at the top of scsi_remove_host. Previous cancel code was not
> 	doing anything as the list was normally empty do to
> 	scsi_forget_host being called first. Also there where possible
> 	race conditions that you previously mentioned about canceling
> 	commands in this method.
> 	3.) Added choke point checks under the scan_mutex to determine if
> 	scanning is allowed (scsi_host_scan_allowed).
> 	4.) Added a target state model to match the scsi device state
> 	model.
> 	5.) I use the STGT_CANCEL and STGT_DEL states in scsi_forget_host
> 	to skip over entries in the list as I am no longer using the
> 	_safe version.
> This looks like a good starting point with limited testing. I also need to
> more states to the target state model as I only added a few that I needed
> for the delete code.

That sounds something like what I was thinking.

There is some subtlety to this: the call to forget host with existing
targets must:

a) put the host into a state where it won't accept any additions or
removal.
b) loop over targets and devices removing them from visibility and doing
final puts for them
c) finally remove the host from visibility, set the deleted state and do
the final put (which may not remove the actual structure until the last
referrer relinquishes its reference).

Also, since the target is a pure container, I don't think it needs to be
a party to the state model.

Anyway, post the code and we can refine it.

James


