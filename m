From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix sd open/remove race
Date: 09 Apr 2004 09:28:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081520891.2202.44.camel@mulgrave>
References: <Pine.LNX.4.44L0.0404091005520.1000-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:27546 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261358AbUDIO3H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2004 10:29:07 -0400
In-Reply-To: <Pine.LNX.4.44L0.0404091005520.1000-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2004-04-09 at 09:11, Alan Stern wrote:
> The patch is almost but not quite correct.  It acquires the new semaphore 
> unnecessarily during scsi_disk_put, it fails to acquire it when erasing 
> the gendisk private_data, and it needs to erase the private_data during 
> sd_remove (not scsi_disk_release).  It also contains a syntax error.

Heh, the additional semicolon I'll remove.

However, the rest of your patch is wrong.

The reason is that what you're trying to synchronise is the naming
lookup (the gendisk open).  You have to allow currently open devices to
continue to operate.  NULL'ing out the disk->private_data before
del_gendisk would mean it was null for sd_release, so every attempt to
close the device after removal would oops.  That's why the NULL must be
done in the reference release routine, not in the disconnection
indication routine.  The race you're trying to prevent is the 0->1
reference after disconnection.

The original patch, By the way, did hold the sd_ref_sem around the NULL
of disk->private_data because the scsi_disk_release is triggered from
kobject_put on last put (and thus is under the semaphore).

James


