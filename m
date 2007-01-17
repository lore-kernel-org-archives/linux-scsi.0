From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: no utility / method to show association between HBA &	non-sg
	BLOCK (scsi) devices - register_blkdev()
Date: Wed, 17 Jan 2007 15:06:12 -0700
Message-ID: <1169071572.7419.2.camel@bluto.andrew>
References: <8260533.post@talk.nabble.com> <45A53290.1060400@torque.net>
	 <45A62C32.8E7F.00B8.0@novell.com> <45A69AD6.60207@torque.net>
	 <45AE22E0.DB3A.00B8.0@novell.com>  <45AE8F64.9080504@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel6.hp.com ([156.153.255.205]:51422 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbXAQWSG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jan 2007 17:18:06 -0500
In-Reply-To: <45AE8F64.9080504@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Thayne Harmon <tharmon@novell.com>, linux-scsi@vger.kernel.org

On Wed, 2007-01-17 at 16:04 -0500, Douglas Gilbert wrote:
> Thayne Harmon wrote:
> >>>> On Thu, Jan 11, 2007 at  1:15 PM, in message <45A69AD6.60207@torque.net>,
> > Douglas Gilbert <dougg@torque.net> wrote: 
> >> Thayne Harmon wrote:
> >>> Gentlemen,
> >>>
> >>> hwinfo, lshal, sysfs do not show the relationship for non- sg BLOCK devices 
> >> with there 
> >>> associated Host Bus Adapter.
> >> All devices (i.e. logical units) have a 4 element tuple
> >> associated with them and the first element is the host
> >> number. A HBA contains one or more hosts. Then you can
> >> datamine in /sys/class/scsi_host/host<n> for whatever
> >> information you want.
> >>
> >>> Do you know of a utility or method that can show this?
> >> May I suggest lsscsi. That won't help you in the lk 2.4
> >> series and earlier though There are other methods by
> >> which the sg device corresponding to a "non- sg" block
> >> device (e.g. /dev/sdc) can be found.
> > 
> > [context - Linux testserver 2.6.16.21-0.8-smp i586]
> > 
> > There is no corresponding sg device. The device file is
> > /dev/cciss/c0d1.
> 
> Ok, I'm not familiar with the cciss driver. It looks like
> it lives outside the linux scsi subsystem but according
> to Documentation/cciss.txt it can subsequently "engage"
> the scsi subsystem??
> 
> If it is outside the scsi subsystem then it doesn't
> get corresponding sg devices. However as part of the
> block subsystem it might accept the SG_IO ioctl (if
> it accepts SCSI commands and it is implemented).
> 

Cciss is a block driver mostly outside of SCSI. It does interface into
the SCSI system for tape drives.

> > I tried lsscsi, however it would not print out the non-sg block devices.
> > 
> > I have attached the output of tree /sys and the output of lsscsi and uname.
> > One can search for cciss to find the devices and the driver.
> > I still cannot see a relationship.
> 
> <snip sysfs dump>
> 
> > [0:0:0:0]    storage COMPAQ   MSA1000          4.32  -       
> > [0:0:0:3]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sda
> > [0:0:0:4]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sdb
> > [0:0:0:5]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sdc
> > [0:0:0:6]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sdd
> > [0:0:0:7]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sde
> > [1:0:0:0]    storage COMPAQ   MSA1000          4.32  -       
> > [1:0:0:3]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sdf
> > [1:0:0:4]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sdg
> > [1:0:0:5]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sdh
> > [1:0:0:6]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sdi
> > [1:0:0:7]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sdj
> 
> Well this looks like output from lsscsi. And those devices look
> like they could be associated with cciss, especially the
> compaq "storage" devices. These devices should have corresponding
> sg device nodes. Try "lsscsi -g".

These are Fibre-Channel Storage arrays, probably going through a QLogic
HBA.

> 
> Still a bit unclear as hosts 0 and 1 are Fibre Channel
> judging from the sysfs output for them.
> 
> Doug Gilbert
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Andrew Patterson
Hewlett-Packard Company

