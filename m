From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG in SCSI async scanning
Date: Tue, 7 Aug 2007 14:32:41 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0708071425170.2799-100000@iolanthe.rowland.org>
References: <1186505933.3414.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57904 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751908AbXHGScm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 14:32:42 -0400
In-Reply-To: <1186505933.3414.53.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 7 Aug 2007, James Bottomley wrote:

> On Tue, 2007-08-07 at 12:54 -0400, Alan Stern wrote:
> > Can somebody explain the reason for calling a separate 
> > scsi_sysfs_add_devices() routine in the async scanning code instead of 
> > just calling scsi_sysfs_add_sdev() normally from within scsi_add_lun()?
> 
> Matthew's away at the moment, so I'll speak for him.
> 
> The reason is so that the order of device enumeration remains
> approximately constant.   We didn't necessarily want completely random
> and timing related enumerations with the async scanning patch.

If you say so.  But aren't synchronous enumerations just about as 
random and timing-related?  I guess you're concerned about cases where 
multiple SCSI buses are scanned in parallel.

> > This peculiar delayed approach has introduced a bug.  It evades the
> > protection provided by shost->scan_mutex and as a result, if a host is
> > hot-unplugged in the middle of an async scan, the SCSI core will
> > attempt to unregister the host's devices before they have been
> > registered!  Obviously this is not good.
> 
> Does this patch fix it:
> 
> http://marc.info/?l=linux-scsi&m=118289275414202
> 
> ? it's one of a number designed to address the problems.

Yes it does, thank you very much.  I urge you to send the patch 
upstream in time for 2.6.23 and also to submit it for the 2.6.22-stable 
branch (if you haven't done so already).

Alan Stern

