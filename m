From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Thu, 13 Nov 2003 16:24:01 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031113162401.A29775@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org> <1068766632.2851.142.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:25232 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S264470AbTKNAY7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 19:24:59 -0500
Content-Disposition: inline
In-Reply-To: <1068766632.2851.142.camel@patrh9>; from p.lavarre@ieee.org on Thu, Nov 13, 2003 at 04:37:12PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: stern@rowland.harvard.edu, mdharm-scsi@one-eyed-alien.net, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

On Thu, Nov 13, 2003 at 04:37:12PM -0700, Pat LaVarre wrote:

> Maybe here I mean to ask: can we easily nutshell for me how well
> write-protect works now in sd?  I understand that we find mode sense of
> header alone and mode sense of xFF troublesome.
> 
> I'm not clear how often we try those techniques.  Do we try only soon
> after plug in or also soon after each disc insertion?

For removable media, we try once when found (sd_probe calls
sd_revalidate_disk), and generally on each open of the device as follows:

sd_open calls check_disk_change, calls sd_media_changed. sd_media_changed
returns 1 if media changed and if so check_disk_change calls
sd_revalidate_disk to figure out if the media is writable and whether to
set write_prot.

On open if write_prot is set and we try to open for writing the open fails
with EROFS.

write_prot can only be set for removable media.

AFAICT, the sd write_prot setting is never passed on up to the block layer.


(Verified with with an ide cd) if the mount syscall returns EROFS, the
mount command tries again with a read-only mount.

If we check after the open for a write failure to read only media, we
cannot keep the same open semantics (return EROFS on open). Is this
important? I don't know.

For file systems, the write out of page cache would get an error, but
AFAIUI those errors can't be passed back to the application since the
application thinks the write has already completed once it goes into the
page cache (I think this was a bug in 2.4, maybe just readahead, where we
did not report such write failures).

I don't have any sd removable read only media.

If you want to test with your read only media, just use the dev flags:

	echo "vendor:model:0x4000" > /proc/scsi/device_info 

Then add your device, see if it comes back as writable, and try to mount
or write it, and compare without the above (you can't remove device_info
entry without rebooting or rmmod-ing scsi).

-- Patrick Mansfield
