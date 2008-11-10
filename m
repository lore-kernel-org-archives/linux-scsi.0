From: "Kit Gerrits" <kitgerrits@gmail.com>
Subject: RE: Question about spun-down USB disk
Date: Mon, 10 Nov 2008 03:17:57 +0100
Message-ID: <491799d8.2435440a.1153.3886@mx.google.com>
References: <491765D3.4080001@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:30126 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbYKJCSD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2008 21:18:03 -0500
Received: by nf-out-0910.google.com with SMTP id d3so990863nfc.21
        for <linux-scsi@vger.kernel.org>; Sun, 09 Nov 2008 18:18:01 -0800 (PST)
In-Reply-To: <491765D3.4080001@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org


You provide a valid point.
However, from an energy/environmental standpoint, I fail to see the problem.
Don't harddisks in laptops generally spin down after there's been no
activity for a while?
How does the O/S handle those?

These aren't server disks I'm talking about, but disks in a system designed
to conserve power.
Why should the disk in my home server be powered up when no-one is using the
server?


Western Digital MyBooks and Seagate FreeAgent disks power themselves down
automatically (firmware setting).
Does that mean you want people that have these disks to lose their data?
How do you expect them to know -in advance- that their disk will spin down,
possibly killing their filesystem?

People are alresdy reporting these problems:
http://www.nslu2-linux.org/wiki/FAQ/DealWithAutoSpinDownOnSeagateFreeAgent
http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg52952.h
tml



I can understand Linux' UN*X roots imply big servers with SCSI disks that
need to be highly available.
It would, however, be nice if the O/S could optionally manage disks the way
'a certain other O/S' does.

If everyone could save those 10 watts per disk with their little server at
home, they might even save a few pennies.


- disclaimer-
For safety, I keeep my data on two separate disks and rsync these daily, 
  so I'm not particularly afraid of a filesystem or O/S crash.
9 times out of 10, I only read from the disk as all media mounts are 
  readonly and the disk is mounted with 'noatime'.
I would like to unmount the disks before spinning them down, 
  but I don't think NFS and SMB can auto-mount the disk.
  Providing the disk in question is automatically spun up...


Regards,

Kit Gerrits
 

-----Original Message-----
From: Douglas Gilbert [mailto:dgilbert@interlog.com] 
Sent: zondag 9 november 2008 23:36
To: Kit Gerrits
Cc: linux-scsi@vger.kernel.org
Subject: Re: Question about spun-down USB disk

Kit Gerrits wrote:
> Hello all!
> 
> I am using an Asus EEE Box with Fedora 9 as a NAS.
> I have found a way to spin-down my USB harddisks with the sg3 utils,  
> but the system occasionally times out on write actions to the disk.
> I usually access the disk through SMB of NFS, which forces the disk to 
> spin up first.
> Sometimes the system opens the disk by itself, throwing an error.
>  lost page write due to I/O error on sdf1
> 
> Is there any way to increase the system timeout when 
> accessing/writing-to the drive?
> Or should I go ask the ext3 people?
> Or does sg_start not notify the kernel the device has been stopped?

In response to the sg_start question, it does not notify the kernel that the
device has been stopped. IMO stopping a disk containing a mounted file
system is asking for trouble, however I don't think that it the role of such
low level utilities to detect and prevent such things.
As for informing the kernel, if I discovered a way to do that, then I would
need to investigate how that might be done on other OSes that sg3_utils is
ported to (e.g. Windows). So I would prefer not to go down that path.

Doug Gilbert

> When the system fails, I get the following error:
> Nov  4 23:50:42 EEE-Box kernel: sd 6:0:0:0: [sdf] Result: 
> hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK Nov  4 23:50:42 
> EEE-Box kernel: end_request: I/O error, dev sdf, sector
> 976767873
--snip--

