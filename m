From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: Mon, 11 Oct 2004 16:13:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041011231317.GA11365@us.ibm.com>
References: <Pine.LNX.4.44L0.0410111558460.21084-100000@netrider.rowland.org> <1097525576.2031.173.camel@mulgrave> <20041011204050.GD8296@us.ibm.com> <1097529322.2031.199.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:8373 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S269341AbUJKXNX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 19:13:23 -0400
Content-Disposition: inline
In-Reply-To: <1097529322.2031.199.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> On Mon, 2004-10-11 at 15:40, Mike Anderson wrote:
> > > This is the remove implies cancel issue that was discussed earlier.  I
> > > thought the proposal was to have a remove that wouldn't automatically
> > > cancel all the commands? ... although I don't think I've seen any code
> > > for that case yet.
> > > 
> > 
> > Clarification. James, are you indicating that there needs to be a new
> > scsi mid api that performs similar function to scsi_remove_host expect
> > does not cancel commands?
> 
> Sorry, by "a remove that .." I was meaning "another remove method that
> ..."
> 

Well based on Mike C's mail it looks like when I moved scsi_forget_host
up in scsi_remove_host that I broke scsi_host_cancel as it stands now
scsi_remove_host is not really doing any cancels.

http://marc.theaimsgroup.com/?l=linux-scsi&m=109743460011434&w=2

> > If is unclear to me if a LLDD provides a slave_destroy which is called
> > from scsi_remove_device during the scsi_forget_host function that we
> > would hit a case where the LLDD has good IO to complete still
> > outstanding when we complete scsi_forget_host and call scsi_host_cancel.
> 
> That depends what the LLD does with the slave destroy really.  The API
> doesn't say the LLD has to chase all I/Os down when slave destroy is
> called, so we can't assume it has.
> 

ok.

-andmike
--
Michael Anderson
andmike@us.ibm.com

