From: Douglas Gilbert <dougg@torque.net>
Subject: Re: aic7xxx support for >2TB volumes?
Date: Fri, 18 Nov 2005 18:59:21 +1000
Message-ID: <437D97E9.8020709@torque.net>
References: <200511161208.02374.kilian.cavalotti@lip6.fr>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:41617 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S932621AbVKRI6u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 03:58:50 -0500
Received: from borg.st.net.au (postfix@zorg.st.net.au [203.16.233.9])
	by zeus1.kernel.org (8.13.1/8.13.1) with ESMTP id jAI8wcB4011194
	for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2005 00:58:41 -0800
In-Reply-To: <200511161208.02374.kilian.cavalotti@lip6.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>
Cc: linux-scsi@vger.kernel.org

Kilian CAVALOTTI wrote:
> Hi all, 
> 
> After some searching through newgroups and mailing lists, I haven't really 
> found an answer to the question: is the aic7xxx driver capable of supporting 
> larger than 2 terabytes volumes? I have read some success reports, but some 
> failed attempts too...
> 
> I actually have an external RAID array, hosting a 6TB virtual disk, plugged on 
> an Adaptec 39160 SCSI card. I'm using a 2.6.14 kernel, with  CONFIG_LBD=y, 
> and thus, the aic7xxx (ver 7.0) module.
> 
> My dmesg show the following:
> 
> scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
>         <Adaptec 3960D Ultra160 SCSI adapter>
>         aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
>   Vendor: transtec  Model: T6100S16R1-D      Rev: 342J
>   Type:   Direct-Access                      ANSI SCSI revision: 05
> scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
>  target1:0:0: Beginning Domain Validation
>  target1:0:0: wide asynchronous.
>  target1:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
>  target1:0:0: Ending Domain Validation
> sdb : very big device. try to use READ CAPACITY(16).
> sdb : READ CAPACITY(16) failed.
> sdb : status=0, message=00, host=5, driver=00
> sdb : use 0xffffffff as device size
> SCSI device sdb: 4294967296 512-byte hdwr sectors (2199023 MB)
> SCSI device sdb: drive cache: write back
> sdb : very big device. try to use READ CAPACITY(16).
> sdb : READ CAPACITY(16) failed.
> sdb : status=0, message=00, host=5, driver=00
> sdb : use 0xffffffff as device size
> SCSI device sdb: 4294967296 512-byte hdwr sectors (2199023 MB)
> SCSI device sdb: drive cache: write back
>  sdb: unknown partition table
> Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
> Attached scsi generic sg2 at scsi1, channel 0, id 0, lun 0,  type 0
> 
> Whatever the real size of the volume, it always give a "4294967296 512-byte 
> hdwr sectors (2199023 MB)" device...
> 
> Is there a way to support a >2TB volume on this SCSI controler? I know I could 
> split my volume in smaller ones and use LVM to reassemble them, but I'd like 
> to avoid adding overhead to the storage stack, and keep it the simplest.

>From the above, it seems the problem is within the
"sdb" device. If it responds to a READ CAPACITY (10)
with a last lba of 0xffffffff (i.e. (2**32 - 1)) then
according to SBC-2 and SBC-3 that is flagging the
application client (i.e. the sd driver) to try a
READ CAPACITY (16) command. The larger READ CAPACITY (16)
has an eight byte (64 bit) last lba field.

>From the log output above, /dev/sdb seems to reject
the READ CAPACITY (16) command. I think that it is
unlikely that the aic7xxx driver is filtering out that
particular command (why should it?) and a simple grep
in that driver for READ_CAP finds no matches.

As an extra check of the linux sd driver you could fetch
sg3_utils, build it and try:
  sg_readcap -16 /dev/sdb

If that fails than I think you need to speak to the vendor
of /dev/sdb . Perhaps there is newer firmware.


Doug Gilbert
