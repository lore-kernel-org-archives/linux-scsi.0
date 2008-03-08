From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: make use of the residue value
Date: Fri, 07 Mar 2008 18:17:55 -0600
Message-ID: <1204935475.2889.28.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0802261113260.4447-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33977 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786AbYCHAR7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2008 19:17:59 -0500
In-Reply-To: <Pine.LNX.4.44L0.0802261113260.4447-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2008-02-27 at 15:25 -0500, Alan Stern wrote:
> On 20 Feb 2008, Alan Stern wrote:
> 
> > This patch (as1036) causes the SCSI midlayer to take into account the
> > residue value provided by some low-level drivers.  There's at least
> > one situation (USB mass storage with the Bulk-only transport) where
> > the specification states that it is permissible for a device to
> > indicate some of the data was not transferred correctly merely by
> > setting the residue value, without issuing a Check Condition.
> 
> After a week, there hasn't been any feedback on this patch.  Has it
> been accepted?  Is there anything wrong with it?  Is it still on a
> "to-look-at" queue?

OK, I ran it through its paces, but it fails in testing.  A very fun
failure, actually, some disks fail to appear with udev.

The reason is they return a residue from the VPD inquiry.  What your
patch actually causes is the block layer to resubmit the command with
the residue and triggers an overrun error (because the length in the
command is now much longer than the data buffer).

The bottom line is that this patch won't work with variable length
commands like inquiry that always return a residue.

James




