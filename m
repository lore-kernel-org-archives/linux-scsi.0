From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Question about spun-down USB disk
Date: Mon, 10 Nov 2008 18:01:28 +0100
Message-ID: <491868E8.2040108@s5r6.in-berlin.de>
References: <491799d8.2435440a.1153.3886@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:34700 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbYKJRDE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2008 12:03:04 -0500
In-Reply-To: <491799d8.2435440a.1153.3886@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kit Gerrits <kitgerrits@gmail.com>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org

Kit Gerrits wrote:
> How do you expect them to know -in advance- that their disk will spin down,
> possibly killing their filesystem?

(Well, this has of course nothing to do with the sg_start utility.)

> People are alresdy reporting these problems:
> http://www.nslu2-linux.org/wiki/FAQ/DealWithAutoSpinDownOnSeagateFreeAgent
> http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg52952.html

The second report (about Seagate Freeagent USB, FireWire, eSATA with
Linux 2.6.21-rc7) doesn't have enough detail.  The former report (about
Seagate Freeagent USB?) suggests a seemingly successful workaround for
Seagate Freeagent disks:  Switch on the allow_restart flag via sysfs.
In Linux 2.6.24 and later, this flag is already enabled by default for
all USB HDDs, i.e. the user doesn't have to do anything anymore to
activate this fix.

I guess the problem with /your/ disk could be that the kernel cannot
easily tell from the type of error status which it gets from the
firmware of the disk (of its USB chip, to be precise) that it should
issue the START STOP UNIT command to get the disk going again.

> I can understand Linux' UN*X roots imply big servers with SCSI disks that
> need to be highly available.
> It would, however, be nice if the O/S could optionally manage disks the way
> 'a certain other O/S' does.
> 
> If everyone could save those 10 watts per disk with their little server at
> home, they might even save a few pennies.

About auto-spin-down:  Auto-spin-down (and thus auto-spin-up) managed by
the kernel for SCSI disks (as opt-in feature; and thus for USB disks
too) has been in the works, but I don't know what the status of this
work is.

About auto-spin-up:  Note that many firmwares of cheap devices don't
care a damn about standards; they just barely work with some luck with
some versions of Windows if the Windows user doesn't do anything
extraordinary with them.  From what I understand, proper sense data from
the disk would be enough for the kernel to send a START STOP UNIT to
switch the motor on and to retry the last request.  Somebody correct me
if I'm wrong.

BTW, if you stopped the disk with sg_start --stop, can you always
successfully start it again with sg_start --start (if you run it before
any other accesses to this disk)?
-- 
Stefan Richter
-=====-==--- =-== -=-=-
http://arcgraph.de/sr/
