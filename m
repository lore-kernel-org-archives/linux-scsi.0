From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Tue, 05 Dec 2006 15:50:32 -0600
Message-ID: <1165355432.2785.20.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56716 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758976AbWLEVum (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2006 16:50:42 -0500
In-Reply-To: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Joerg Schilling <schilling@fokus.fraunhofer.de>, Doug Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2006-12-05 at 15:52 -0500, Alan Stern wrote:
> I decided to do this by email instead of bugzilla so that it would be 
> visible to everyone on the linux-scsi mailing list.
> 
> Re: http://bugzilla.kernel.org/show_bug.cgi?id=7026
> 
> To recap: Joerg Schilling needs to be able to retrieve the max_sectors 
> value for a SCSI device's request queue.  Doing it via sysfs is rather 
> clumsy, especially when only a file descriptor is available and not the 
> device name.  He has asked for an ioctl interface to provide the 
> information.

But how did he get the file descriptor?  He opened a device name, which
could have been used to get the sysfs file.

> Is the patch below acceptable?

Really, no.  The parameter you're fishing for is a block parameter, not
a SCSI parameter ... it should really be a block ioctl if we have to
have an ioctl at all.

James


