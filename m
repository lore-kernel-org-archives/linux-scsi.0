From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: Mon, 11 Oct 2004 13:40:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041011204050.GD8296@us.ibm.com>
References: <Pine.LNX.4.44L0.0410111558460.21084-100000@netrider.rowland.org> <1097525576.2031.173.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:26069 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S269239AbUJKUkz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 16:40:55 -0400
Content-Disposition: inline
In-Reply-To: <1097525576.2031.173.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> On Mon, 2004-10-11 at 15:03, Alan Stern wrote:
> > The problem arises when a command completes.  In the notified ejection 
> > case, if the LLD tries to call the scsi_done routine for a completed 
> > command which was submitted before scsi_remove_host and which the SCSI 
> > core has already cleaned up, it will cause an oops.  Since the LLD has no 
> > way to tell whether the core has cleaned up a command or not, its only 
> > choice is to fail _every_ command starting shortly before it calls 
> > scsi_remove_host.
> 
> This is the remove implies cancel issue that was discussed earlier.  I
> thought the proposal was to have a remove that wouldn't automatically
> cancel all the commands? ... although I don't think I've seen any code
> for that case yet.
> 

Clarification. James, are you indicating that there needs to be a new
scsi mid api that performs similar function to scsi_remove_host expect
does not cancel commands?

If is unclear to me if a LLDD provides a slave_destroy which is called
from scsi_remove_device during the scsi_forget_host function that we
would hit a case where the LLDD has good IO to complete still
outstanding when we complete scsi_forget_host and call scsi_host_cancel.

Is there some locking / synchronization issue with our state changes and
the scsi_prep_fn / scsi_request_fn / scsi_dispatch_cmd sequence?

-andmike
--
Michael Anderson
andmike@us.ibm.com

