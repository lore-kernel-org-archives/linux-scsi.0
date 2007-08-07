From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG in SCSI async scanning
Date: Tue, 07 Aug 2007 11:58:53 -0500
Message-ID: <1186505933.3414.53.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0708071242140.2834-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:51342 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758128AbXHGQ6y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 12:58:54 -0400
In-Reply-To: <Pine.LNX.4.44L0.0708071242140.2834-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Wilcox <matthew@wil.cx>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2007-08-07 at 12:54 -0400, Alan Stern wrote:
> Can somebody explain the reason for calling a separate 
> scsi_sysfs_add_devices() routine in the async scanning code instead of 
> just calling scsi_sysfs_add_sdev() normally from within scsi_add_lun()?

Matthew's away at the moment, so I'll speak for him.

The reason is so that the order of device enumeration remains
approximately constant.   We didn't necessarily want completely random
and timing related enumerations with the async scanning patch.

> This peculiar delayed approach has introduced a bug.  It evades the
> protection provided by shost->scan_mutex and as a result, if a host is
> hot-unplugged in the middle of an async scan, the SCSI core will
> attempt to unregister the host's devices before they have been
> registered!  Obviously this is not good.

Does this patch fix it:

http://marc.info/?l=linux-scsi&m=118289275414202

? it's one of a number designed to address the problems.

James


> There are at least two reports filed in the kernel.org bugilla showing 
> this bug: #8840 and #8846.
> 
> Alan Stern

