From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Tue, 28 Oct 2003 17:51:57 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031028175157.A14803@beaverton.ibm.com>
References: <1067376788.1056.5.camel@ronald.kuetemeier.com> <Pine.LNX.4.44L0.0310281737350.6912-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:65265 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S261861AbTJ2Bwp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 20:52:45 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0310281737350.6912-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Tue, Oct 28, 2003 at 05:49:48PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ronald Kuetemeier <ronald@kuetemeier.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Tue, Oct 28, 2003 at 05:49:48PM -0500, Alan Stern wrote:

> All right.  The logs make it clear.

Not quite clear for me yet :-/

> Your device doesn't like the MODE-SENSE(10) for page 3F.  But instead of 
> reporting a normal error code, it tries to send an overlong packet (i.e., 
> longer than the host asked for).  Of course this is an error, and the SCSI 
> code retries several times, eventually giving up.  Oddly enough, the 
> device then returns an Invalid Command status for the _next_ command, 
> which is an innocuous TEST-UNIT-READY.  I don't understand that.

> Anyway, the SCSI layer recognizes that something is wrong.  But for some
> unknown reason it goes right back to the beginning of the probe sequence,
> starting with another TEST-UNIT-READY, READ-CAPACITY, and moving on.  
> Naturally enough, when it reaches the MODE-SENSE(10) again the same
> problem reoccurs.  Patrick, do you know why the sd initialization code is
> doing this?

It does not go back to the probe (scsi scan or sd_probe code), sd_open for
removable media can call sd_revalidate_disk. sd_revalidate_disk is also
called via sd_probe.

The partition check code in register_disk opens the block device once (can
anyone verify that?) calling sd_open. But it almost looks like we have
multiple sd_open calls - given the multiple TEST UNIT READY's READ
CAPACITY, and MODE SENSE calls.

I think the sdev->changed is getting set, causing the read command
(sd_init_command fails) to fail.

I'll look more tomorrow. If anyone figures out or knows the sdev->changed
code please post.

> Even the successful logfile had an odd feature.  The sd driver knew enough
> to skip both the page 3F and the page 8 MODE-SENSE(10) calls.  But then it
> went ahead and issued MODE-SENSE(6) for page 8!  Fortunately this worked
> (or rather, failed cleanly enough) for things to progress okay.  Patrick,
> can you explain that too?

The scsi_dev_flags overrides the host adapter setting, and we did not tell
it to skip page 8. Since it worked it does not matter, but we could have
used (given BLIST_MS_SKIP_PAGE_08 is 0x2000 and BLIST_MS_SKIP_PAGE_3F is
0x4000):
	
	echo "model:vendor:0x6000" > /proc/scsi/device_info

-- Patrick Mansfield
