From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: 11 Oct 2004 16:15:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097529322.2031.199.camel@mulgrave>
References: <Pine.LNX.4.44L0.0410111558460.21084-100000@netrider.rowland.org>
	<1097525576.2031.173.camel@mulgrave>  <20041011204050.GD8296@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:5866 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269250AbUJKVP0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 17:15:26 -0400
In-Reply-To: <20041011204050.GD8296@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2004-10-11 at 15:40, Mike Anderson wrote:
> > This is the remove implies cancel issue that was discussed earlier.  I
> > thought the proposal was to have a remove that wouldn't automatically
> > cancel all the commands? ... although I don't think I've seen any code
> > for that case yet.
> > 
> 
> Clarification. James, are you indicating that there needs to be a new
> scsi mid api that performs similar function to scsi_remove_host expect
> does not cancel commands?

Sorry, by "a remove that .." I was meaning "another remove method that
..."

> If is unclear to me if a LLDD provides a slave_destroy which is called
> from scsi_remove_device during the scsi_forget_host function that we
> would hit a case where the LLDD has good IO to complete still
> outstanding when we complete scsi_forget_host and call scsi_host_cancel.

That depends what the LLD does with the slave destroy really.  The API
doesn't say the LLD has to chase all I/Os down when slave destroy is
called, so we can't assume it has.

> Is there some locking / synchronization issue with our state changes and
> the scsi_prep_fn / scsi_request_fn / scsi_dispatch_cmd sequence?

In the device, no ... I still need to check the host.

James


