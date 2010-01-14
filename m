From: scameron@beardog.cce.hp.com
Subject: Is this a known problem with the SCSI mid layer?
Date: Thu, 14 Jan 2010 10:56:02 -0600
Message-ID: <20100114165602.GY13413@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:13767 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab0ANQxh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 11:53:37 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, mikem@beardog.cce.hp.com, dab@hp.com, hch@infradead.com, axboe@kernel.dk


I'm seeing a problem which I think is a problem in the SCSI mid layer.

Check this out:

I can rmmod and insmod hpsa (a modified version from 
what's currently in the mainline tree, but I don't think
that matters.)

I have one logical drive present

[root@slicer ~]# rmmod hpsa
[root@slicer ~]# insmod /usr/src/linux-2.6.27.42/drivers/scsi/hpsa.ko
[root@slicer ~]# cat /proc/scsi/scsi
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: HP       Model: 1210m            Rev: 0150
  Type:   RAID                             ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 01
  Vendor: HP       Model: 1210m VOLUME     Rev: 0150
  Type:   Direct-Access                    ANSI  SCSI revision: 05
[root@slicer ~]# rmmod hpsa
[root@slicer ~]# insmod /usr/src/linux-2.6.27.42/drivers/scsi/hpsa.ko
[root@slicer ~]# cat /proc/scsi/scsi
Attached devices:
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: HP       Model: 1210m            Rev: 0150
  Type:   RAID                             ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 01
  Vendor: HP       Model: 1210m VOLUME     Rev: 0150
  Type:   Direct-Access                    ANSI  SCSI revision: 05
[root@slicer ~]# lsscsi -g
[2:0:0:0]    storage HP       1210m            0150  -         /dev/sg0
[2:0:0:1]    disk    HP       1210m VOLUME     0150  /dev/sda  /dev/sg1

So far, so good.

Now, watch this.  Remove the device while something has it open:

[root@slicer ~]# sleep 10 < /dev/sg1 & ( sleep 1 && echo scsi remove-single-device 2 0 0 1 > /proc/scsi/scsi )
[1] 6077
[root@slicer ~]# 
[1]+  Done                    sleep 10 < /dev/sg1
[root@slicer ~]# lsof /dev/sg1
lsof: status error on /dev/sg1: No such file or directory
lsof 4.78
 latest revision: ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/
 latest FAQ: ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/FAQ
 latest man page: ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_man
 usage: [-?abhlnNoOPRstUvVX] [+|-c c] [+|-d s] [+D D] [+|-f]
 [-F [f]] [-g [s]] [-i [i]] [+|-L [l]] [+m [m]] [+|-M] [-o [o]]
 [-p s] [+|-r [t]] [-S [t]] [-T [t]] [-u s] [+|-w] [-x [fl]] [-Z [Z]] [--] [names]
Use the ``-h'' option to get more help information.
[root@slicer ~]# rmmod hpsa
ERROR: Module hpsa is in use
[root@slicer ~]#

Hmm, that's not cool.

Maybe it's my driver.  Let me try with USB.

[root@slicer ~]# cat /proc/scsi/scsi
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: USB      Model: DISK 2.0         Rev: 0403
  Type:   Direct-Access                    ANSI  SCSI revision: 00
[root@slicer ~]# lsmod | grep sd
sd_mod                 59592  0 
scsi_mod              189304  9 usb_storage,ib_iser,iscsi_tcp,libiscsi,scsi_transport_iscsi,scsi_dh,sg,cciss,sd_mod
[root@slicer ~]# rmmod usb_storage
[root@slicer ~]# cat /proc/scsi/scsi
Attached devices:
[root@slicer ~]# modprobe usb_storage
[root@slicer ~]# cat /proc/scsi/scsi
Attached devices:
[root@slicer ~]# echo scsi add-single-device 1 0 0 0 > /proc/scsi/scsi
-bash: echo: write error: No such device or address

Oh yeah, the host number increments, forgot about that...

[root@slicer ~]# echo scsi add-single-device 2 0 0 0 > /proc/scsi/scsi
[root@slicer ~]# cat /proc/scsi/scsi
Attached devices:
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: USB      Model: DISK 2.0         Rev: 0403
  Type:   Direct-Access                    ANSI  SCSI revision: 00
[root@slicer ~]# lsscsi -g
[2:0:0:0]    disk    USB      DISK 2.0         0403  /dev/sda  /dev/sg0
[root@slicer ~]# sleep 10 < /dev/sg0 & ( sleep 1 && echo scsi remove-single-device 2 0 0 0 > /proc/scsi/scsi )
[1] 6073
[root@slicer ~]# 
[root@slicer ~]# 
[1]+  Done                    sleep 10 < /dev/sg0
[root@slicer ~]# rmmod usb_storage
ERROR: Module usb_storage is in use
[root@slicer ~]#

Hmm, same thing.

Any thoughts?  (other than "don't do that."  Our array configuration
utility for smart arrays is causing similar trouble, as it rapidly creates
and deletes logical drives, etc. so it would be nice if this didn't happen.)

-- steve

