From: scameron@beardog.cce.hp.com
Subject: Re: Is this a known problem with the SCSI mid layer?
Date: Thu, 14 Jan 2010 13:00:46 -0600
Message-ID: <20100114190046.GA13413@beardog.cce.hp.com>
References: <20100114165602.GY13413@beardog.cce.hp.com> <4B4F617B.5050609@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:23004 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab0ANS6V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 13:58:21 -0500
Content-Disposition: inline
In-Reply-To: <4B4F617B.5050609@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, mikem@beardog.cce.hp.com, dab@hp.com, hch@infradead.com, axboe@kernel.dk, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thu, Jan 14, 2010 at 01:24:59PM -0500, Douglas Gilbert wrote:
> scameron@beardog.cce.hp.com wrote:
> >I'm seeing a problem which I think is a problem in the SCSI mid layer.
> >
> >Check this out:
> >
> >I can rmmod and insmod hpsa (a modified version from 
> >what's currently in the mainline tree, but I don't think
> >that matters.)
> >
> >I have one logical drive present
> >
> >[root@slicer ~]# rmmod hpsa
> >[root@slicer ~]# insmod /usr/src/linux-2.6.27.42/drivers/scsi/hpsa.ko
> >[root@slicer ~]# cat /proc/scsi/scsi
> >Attached devices:
> >Host: scsi1 Channel: 00 Id: 00 Lun: 00
> >  Vendor: HP       Model: 1210m            Rev: 0150
> >  Type:   RAID                             ANSI  SCSI revision: 05
> >Host: scsi1 Channel: 00 Id: 00 Lun: 01
> >  Vendor: HP       Model: 1210m VOLUME     Rev: 0150
> >  Type:   Direct-Access                    ANSI  SCSI revision: 05
> >[root@slicer ~]# rmmod hpsa
> >[root@slicer ~]# insmod /usr/src/linux-2.6.27.42/drivers/scsi/hpsa.ko
> >[root@slicer ~]# cat /proc/scsi/scsi
> >Attached devices:
> >Host: scsi2 Channel: 00 Id: 00 Lun: 00
> >  Vendor: HP       Model: 1210m            Rev: 0150
> >  Type:   RAID                             ANSI  SCSI revision: 05
> >Host: scsi2 Channel: 00 Id: 00 Lun: 01
> >  Vendor: HP       Model: 1210m VOLUME     Rev: 0150
> >  Type:   Direct-Access                    ANSI  SCSI revision: 05
> >[root@slicer ~]# lsscsi -g
> >[2:0:0:0]    storage HP       1210m            0150  -         /dev/sg0
> >[2:0:0:1]    disk    HP       1210m VOLUME     0150  /dev/sda  /dev/sg1
> >
> >So far, so good.
> >
> >Now, watch this.  Remove the device while something has it open:
> >
> >[root@slicer ~]# sleep 10 < /dev/sg1 & ( sleep 1 && echo scsi 
> >remove-single-device 2 0 0 1 > /proc/scsi/scsi )
> >[1] 6077
> >[root@slicer ~]# 
> >[1]+  Done                    sleep 10 < /dev/sg1
> >[root@slicer ~]# lsof /dev/sg1
> >lsof: status error on /dev/sg1: No such file or directory
> >lsof 4.78
> > latest revision: ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/
> > latest FAQ: ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/FAQ
> > latest man page: ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_man
> > usage: [-?abhlnNoOPRstUvVX] [+|-c c] [+|-d s] [+D D] [+|-f]
> > [-F [f]] [-g [s]] [-i [i]] [+|-L [l]] [+m [m]] [+|-M] [-o [o]]
> > [-p s] [+|-r [t]] [-S [t]] [-T [t]] [-u s] [+|-w] [-x [fl]] [-Z [Z]] [--] 
> > [names]
> >Use the ``-h'' option to get more help information.
> >[root@slicer ~]# rmmod hpsa
> >ERROR: Module hpsa is in use
> >[root@slicer ~]#
> >
> >Hmm, that's not cool.
> 
> Steve,
> That 'sleep 10 < /dev/sg1' worries me. The purpose of a
> read() on a sg device is to fetch the response of a SCSI
> command sent by a preceding write(). So with nothing to
> read and a blocking sg device file descriptor the read()
> probably hangs. IMO the valid use of the sg driver should
> not have a read() hanging for a SCSI command that was
> never sent. While that is happening you remove the
> device.

I don't think the sleep does a read from stdin.  As far
as I can tell, There is no read, just an open(), by the shell,
to connect to sleep's stdin, but sleep never reads from stdin.
It does some reads for locale stuff, but not from stdin.
According to strace, all reads by sleep are from file descriptor
3, which is opened to various things, locale, random, library
stuff, but no reads from stdin.  Just an open() by the shell.

> 
> That may be a valid torture test for the sg driver but
> isn't something that should be encouraged from the
> user space.

Yeah, of course this test isn't exactly a sane thing to do,
but, if someone happens to "echo scsi remove-single-device ... "
while some process has the corresponding /dev/sg node merely opened, 
wedging things seems, well, kinda bad.  And it was something
we ran into testing other software, I just isolated it down to this
test case. 

This, however, appears to work:

[root@slicer ~]# cat /proc/scsi/scsi
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: USB      Model: DISK 2.0         Rev: 0403
  Type:   Direct-Access                    ANSI  SCSI revision: 00
[root@slicer ~]# lsscsi
[1:0:0:0]    disk    USB      DISK 2.0         0403  /dev/sdb
[root@slicer ~]# sleep 10 < /dev/sdb & ( sleep 1 && echo scsi remove-single-device 1 0 0 0 > /proc/scsi/scsi )
[1] 5942
[root@slicer ~]# 
[1]+  Done                    sleep 10 < /dev/sdb
[root@slicer ~]# rmmod usb_storage

and this works too:

[root@slicer ~]# insmod /usr/src/linux-2.6.27.42/drivers/scsi/hpsa.ko
[root@slicer ~]# cat /proc/scsi/scsi
Attached devices:
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: HP       Model: 1210m            Rev: 0150
  Type:   RAID                             ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 01
  Vendor: HP       Model: 1210m VOLUME     Rev: 0150
  Type:   Direct-Access                    ANSI  SCSI revision: 05
[root@slicer ~]# lsscsi
[2:0:0:0]    storage HP       1210m            0150  -       
[2:0:0:1]    disk    HP       1210m VOLUME     0150  /dev/sda
[root@slicer ~]# sleep 10 < /dev/sda & ( sleep 1 && echo scsi remove-single-device 2 0 0 1 > /proc/scsi/scsi )
[1] 6087
[root@slicer ~]# 
[1]+  Done                    sleep 10 < /dev/sda
[root@slicer ~]# rmmod hpsa
[root@slicer ~]#



> 
> On a Ubuntu kernel 2.6.31-17-generic using a virtual
> device owned by the scsi_debug driver and the same
> torture test, I don't have a problem with 'rmmod scsi_debug'
> 
> IMO the usb-storage driver is not a good yardstick.
> 

Yeah, wasn't my first choice for a guinea pig, as I know it
does some strange things compared to other scsi drivers, but
it was what I had handy, hardware-wise.

I'll try to scrounge up some different hardware, and see if they
behave the same.

> Doug Gilbert
> 
> 
> >Maybe it's my driver.  Let me try with USB.
> >
> >[root@slicer ~]# cat /proc/scsi/scsi
> >Attached devices:
> >Host: scsi1 Channel: 00 Id: 00 Lun: 00
> >  Vendor: USB      Model: DISK 2.0         Rev: 0403
> >  Type:   Direct-Access                    ANSI  SCSI revision: 00
> >[root@slicer ~]# lsmod | grep sd
> >sd_mod                 59592  0 
> >scsi_mod              189304  9 
> >usb_storage,ib_iser,iscsi_tcp,libiscsi,scsi_transport_iscsi,scsi_dh,sg,cciss,sd_mod
> >[root@slicer ~]# rmmod usb_storage
> >[root@slicer ~]# cat /proc/scsi/scsi
> >Attached devices:
> >[root@slicer ~]# modprobe usb_storage
> >[root@slicer ~]# cat /proc/scsi/scsi
> >Attached devices:
> >[root@slicer ~]# echo scsi add-single-device 1 0 0 0 > /proc/scsi/scsi
> >-bash: echo: write error: No such device or address
> >
> >Oh yeah, the host number increments, forgot about that...
> >
> >[root@slicer ~]# echo scsi add-single-device 2 0 0 0 > /proc/scsi/scsi
> >[root@slicer ~]# cat /proc/scsi/scsi
> >Attached devices:
> >Host: scsi2 Channel: 00 Id: 00 Lun: 00
> >  Vendor: USB      Model: DISK 2.0         Rev: 0403
> >  Type:   Direct-Access                    ANSI  SCSI revision: 00
> >[root@slicer ~]# lsscsi -g
> >[2:0:0:0]    disk    USB      DISK 2.0         0403  /dev/sda  /dev/sg0
> >[root@slicer ~]# sleep 10 < /dev/sg0 & ( sleep 1 && echo scsi 
> >remove-single-device 2 0 0 0 > /proc/scsi/scsi )
> >[1] 6073
> >[root@slicer ~]# 
> >[root@slicer ~]# 
> >[1]+  Done                    sleep 10 < /dev/sg0
> >[root@slicer ~]# rmmod usb_storage
> >ERROR: Module usb_storage is in use
> >[root@slicer ~]#
> >
> >Hmm, same thing.
> >
> >Any thoughts?  (other than "don't do that."  Our array configuration
> >utility for smart arrays is causing similar trouble, as it rapidly creates
> >and deletes logical drives, etc. so it would be nice if this didn't 
> >happen.)
