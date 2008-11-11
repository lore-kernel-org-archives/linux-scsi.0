From: "Kit Gerrits" <kitgerrits@gmail.com>
Subject: RE: Question about spun-down USB disk
Date: Tue, 11 Nov 2008 01:11:27 +0100
Message-ID: <4918cdb1.2208420a.0cdf.5972@mx.google.com>
References: <491868E8.2040108@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:12544 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbYKKALc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2008 19:11:32 -0500
Received: by ug-out-1314.google.com with SMTP id 39so578509ugf.37
        for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2008 16:11:30 -0800 (PST)
In-Reply-To: <491868E8.2040108@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Stefan Richter' <stefanr@s5r6.in-berlin.de>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org


The disk spins up automatically, but the O/S threw an error because the disk
did not reply in time.
When I access the disks through SMB or NFS, everything is fime.
If, for some reason, a program wants to write to a file on there without
spinning the drive up in advance, 
  the error pops up.
Mind you, I haven't had the error in days now.

All I'm looking for is a way to increase the time the O/S waits for the disk
to spin up.


Regards,

Kit 

-----Original Message-----
From: Stefan Richter [mailto:stefanr@s5r6.in-berlin.de] 
Sent: maandag 10 november 2008 18:01
To: Kit Gerrits
Cc: dgilbert@interlog.com; linux-scsi@vger.kernel.org
Subject: Re: Question about spun-down USB disk

Kit Gerrits wrote:
> How do you expect them to know -in advance- that their disk will spin 
> down, possibly killing their filesystem?

(Well, this has of course nothing to do with the sg_start utility.)

> People are alresdy reporting these problems:
> http://www.nslu2-linux.org/wiki/FAQ/DealWithAutoSpinDownOnSeagateFreeA
> gent 
> http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg5
> 2952.html

The second report (about Seagate Freeagent USB, FireWire, eSATA with Linux
2.6.21-rc7) doesn't have enough detail.  The former report (about Seagate
Freeagent USB?) suggests a seemingly successful workaround for Seagate
Freeagent disks:  Switch on the allow_restart flag via sysfs.
In Linux 2.6.24 and later, this flag is already enabled by default for all
USB HDDs, i.e. the user doesn't have to do anything anymore to activate this
fix.

I guess the problem with /your/ disk could be that the kernel cannot easily
tell from the type of error status which it gets from the firmware of the
disk (of its USB chip, to be precise) that it should issue the START STOP
UNIT command to get the disk going again.

> I can understand Linux' UN*X roots imply big servers with SCSI disks 
> that need to be highly available.
> It would, however, be nice if the O/S could optionally manage disks 
> the way 'a certain other O/S' does.
> 
> If everyone could save those 10 watts per disk with their little 
> server at home, they might even save a few pennies.

About auto-spin-down:  Auto-spin-down (and thus auto-spin-up) managed by the
kernel for SCSI disks (as opt-in feature; and thus for USB disks
too) has been in the works, but I don't know what the status of this work
is.

About auto-spin-up:  Note that many firmwares of cheap devices don't care a
damn about standards; they just barely work with some luck with some
versions of Windows if the Windows user doesn't do anything extraordinary
with them.  From what I understand, proper sense data from the disk would be
enough for the kernel to send a START STOP UNIT to switch the motor on and
to retry the last request.  Somebody correct me if I'm wrong.

BTW, if you stopped the disk with sg_start --stop, can you always
successfully start it again with sg_start --start (if you run it before any
other accesses to this disk)?
--
Stefan Richter
-=====-==--- =-== -=-=-
http://arcgraph.de/sr/

