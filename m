From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] SCSI: add check_capacity flag and sd_read_last_sector()
Date: Wed, 22 Apr 2009 08:57:37 -0700
Message-ID: <20090422155737.GA18880@kroah.com>
References: <Pine.LNX.4.44L0.0904221034340.3405-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:48508 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753340AbZDVQBb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Apr 2009 12:01:31 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904221034340.3405-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Wed, Apr 22, 2009 at 10:42:36AM -0400, Alan Stern wrote:
> This patch (as1196) adds a new scsi_device flag to tell sd.c that it
> should verify the results of READ CAPACITY by trying the read the last
> sector.  This is necessary because a large percentage of USB
> mass-storage devices -- too many for a blacklist -- have a bug whereby
> they return the total number of sectors rather than the index of the
> last sector.
> 
> The new sd_read_last_sector() routine carries out the test, using a
> very short timeout and a small number of retries.  Any working device
> for which the check_capacity flag is set should be able to pass the
> test easily.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> James & Greg:
> 
> Although part of this patch touches usb-storage, the majority of 
> it affects SCSI files.  Is it okay if the whole thing goes in via 
> James's tree?

No objection from me at all.  Feel free to add a:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to the patch and push it through James.

thanks,

greg k-h
