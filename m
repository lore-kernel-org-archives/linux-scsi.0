From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Recover SCSI disks
Date: Fri, 21 Oct 2005 11:11:39 +1000
Message-ID: <4358404B.9080006@torque.net>
References: <dj8a8v$ta0$1@sea.gmane.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:10981 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S964820AbVJUBKh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 21:10:37 -0400
In-Reply-To: <dj8a8v$ta0$1@sea.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: linux-scsi@vger.kernel.org

Robin Bowes wrote:
> Hi,
> 
> I've got a Compaq U2 storage array connected to a Compaw Smart 2/p
> controller with an assortment of 4.3GB and 9.1GB disks that I use for
> testing purposes.
> 
> Some of the drives have "died" on me, i.e. I get yellow lights when they
> are plugged into the arrays.
> 
> Is it possible to do anything low-level to ressurect these drives? e.g.
> take them out of their caddies, connected them directly to a SCSI
> controller and low-level format them or something?
> 
> (There's no data on them - I just want them to work again!)
> 
> Any suggestions appreciated.

Robin,
You may like to fetch sg3_utils and try sg_format thus:
   sg_format /dev/sda
assuming a disk you have fetched from the array is placed
at /dev/sda .

If that fails, the disk is probably dead. Otherwise it
should tell you several things (and doesn't change
anything). Often drives in RAIDs are formatted
to a sector size slightly greater than 512 bytes. To
re-use the disk (freestanding) in linux you will need to
format it back 512 bytes thus:
   sg_format --format --size=512 /dev/sda

A format may not be needed. In any case, the next step
would usually be to partition the disk (e.g. with fdisk)
then make a file system on one or more of its partitions
(e.g. with mkfs.ext3 ). The disk (or at least its partition)
should then be ready to mount and use.

Doug Gilbert


