From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass
	larger receive buffer
Date: 13 Nov 2003 18:54:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068774856.2851.259.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
	 <1068766632.2851.142.camel@patrh9>
	 <20031113162401.A29775@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:7584 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264485AbTKNByt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 20:54:49 -0500
In-Reply-To: <20031113162401.A29775@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: stern@rowland.harvard.edu, mdharm-scsi@one-eyed-alien.net, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

> > From: Patrick Mansfield ...
> > For removable media, we try once when found
> > (sd_probe calls sd_revalidate_disk), and
> > generally on each open of the device as follows:

Prompt & incisive, thank you.

> From: Matthew Dharm ...
> ... I think we're basically at a point where
> the only problematic command is MODE_SENSE and
> MODE_SENSE_10, so I say blacklisting them from
> USB devices should be fine.

Lost me sorry help?

If we eat those commands, how then can write-protect work in Linux for
that rare case of an actually compliant device with a write-protectab;e
disk (like the device firmware I remember shipping myself 1994..2003)?

> > If we check after the open for a write failure
> > to read only media, we cannot keep the same
> > open semantics (return EROFS on open).

Without mode sense, we will see the open for write pass thru, and we
will have to teach the fs (ext3, fat, fat32, udf, ...) to recover
gracefully from a late write error, yes?

> > From: Patrick Mansfield ...
> > I don't have any sd removable read only
> > media.

Want an Iomega Zip drive and disk shipped to you?

(I can't arrange that easily, but if I try it might happen someday,
especially if you're precisely the next person who asks me and not the
person after that.)

(You have no Iomega Zip disk already, yes?  I ask just because you can't
see the write-protect tab on a Zip disk unless you disassemble the disk
and use an electron microscope, so you might not know how to flip it.)

> > If you want to test with your read only
> > media, just use the dev flags:
> > echo "vendor:model:0x4000" > /proc/scsi/device_info 
> > Then add your device, see if it comes back
> > as writable, and try to mount or write it,
> > and compare without the above (you can't
> > remove device_info entry without rebooting
> > or rmmod-ing scsi).

Will do, again I thank you for explaining.

My first guess is that in bash syntax for me we mean to take $vendor and
$model from op x12 Inquiry data, vendor = bytes[x8:F], model =
bytes[x10:1F], so for me:

vendor = "IOMEGA   "
model = "ZIP 250          "
echo "$vendor:$model:0x4000" > /proc/scsi/device_info 

Results you describe for allowing open to write of unwritable disk sound
to me like results I've seen in cdrom/ sr/ ide-cd land.  I will try sd
and report back.

Pat LaVarre


