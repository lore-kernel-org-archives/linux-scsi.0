From: bernd@rhm.de
Subject: Re: hot-swap problems with Adaptec AIC-7902 (aic79xx)
Date: Wed, 24 Aug 2005 16:42:29 +0200 (MESZ)
Message-ID: <200508241442.QAA27491@node130.rhm.de>
References: <1124882984.13829.33.camel@cronos.criticalpath.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.Space.Net ([195.30.0.8]:8208 "HELO mail.space.net")
	by vger.kernel.org with SMTP id S1751040AbVHXOmd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 10:42:33 -0400
Received: (from bernd@localhost)
	by node130.rhm.de (8.9.3 (PHNE_28760)/8.8.6) id QAA27491
	for linux-scsi@vger.kernel.org; Wed, 24 Aug 2005 16:42:29 +0200 (MESZ)
In-Reply-To: <1124882984.13829.33.camel@cronos.criticalpath.it> from Andrea Carpani at "Aug 24, 5 01:29:44 pm"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>Hi everybody,
>here are some issues I'm having with my system dealing with
>hot-swapping.
>
>The box is a Tyan GX28 (B2881) B2881G28U4H with 4 Hot-swap U320 SCSI
>bays. SCSI controller is Adaptec AIC-7902 dual channel Ultra320 SCSI.
>
># cat /proc/scsi/scsi
>Attached devices:
>Host: scsi0 Channel: 00 Id: 00 Lun: 00
>  Vendor: FUJITSU  Model: MAP3735NC        Rev: 0108
>  Type:   Direct-Access                    ANSI SCSI revision: 03
>Host: scsi0 Channel: 00 Id: 01 Lun: 00
>  Vendor: FUJITSU  Model: MAP3735NC        Rev: 0108
>  Type:   Direct-Access                    ANSI SCSI revision: 03
>
>Linux kernel 2.6.12.3 (no patches).
>
>I have 2 drives single partition set up as a single md0 software
>mirrored raid device (xfs filesystem). I set /dev/sdb1 as faulty and
>remove it from the array.
>
>I then want to hot-swap the drive with another one.
>
>echo "scsi remove-single-device 0 0 1 0" > /proc/scsi/scsi
>
>removes it and 
>
>cat /proc/scsi/scsi
>
>shows this. If I physically swap the drive (with a different Maxtor one)
>and issue
>
>echo "scsi add-single-device 0 0 1 0" > /proc/scsi/scsi
>
>nothing happens (syslog: 
>Aug 24 12:53:48 localhost kernel: scsi0: ILLEGAL_PHASE 0x80
>Aug 24 12:53:48 localhost kernel: (scsi0:A:1:0): Abort Message Sent)
>and the new drive appears in /proc/scsi/scsi only after a second "echo"
>command (I assume this is a power-up delay).
>
>At this point I'm not yet adding the drive to the mirror. The problem is
>that if I repeat the last steps more than once (remove-single-device,
>swap the drives again, add-single-device) I get the following error on
>the console and everything freezes
>
>I/O error in filesystem ("md0") meta-data dev md0 block 0x44308c4
>("xlog_iodone") error 5 buf count 1024
>Filesystem "md0": Log I/O error detected.
>Shutting down filesystem: md0
>Please umount the filesystem and rectify the problem(s).
>
>Which is quite strange as I'm only scsi-dealing with the sdb device and
>the filesystem at this point should only be on sda.
>
>Here are some questions:
>Is it possible that the scsi level operations disturb the other drive?
>Which is the correct way to hot-swap scsi disks? Am I doing something
>wrong?
>More often than not (but not as easily reproducible) the removal and
>detection of a new drive fails and the box hangs (no console messages):
>could it be a driver/board problem?
>Are there well tested scsi adapters/drivers that I should use?
>Which scsi debug info should I turn on to help understad the problem?
>
>
>Thanks,
>Andrea.
>
>-- 
>Andrea Carpani <andrea.carpani@criticalpath.net>

-------------------------------------------------------------------------

Hi Andrea,

we have the same problem with AIC7902 and we posted this some month ago
to the scsi and the raid groups but without reply. We have RAID1 arrays.
with 10 drives on two controllers so 5 drives are an the one half of the 
RAID1 arrays and 5 on the other. When we hotreplace a drive _all_ arrays
go into degrated mode because _all_ drives on the controller where
the disk is repaced are declared to be not ready during the spinup of
the replaced drive. Strange! This means we don't have the possibilty to
hotreplace a drive on Linux which we had since 20 years on HPUX. 

As we detected in many, many tries we made the problem seem to come up
with kernel 2.6.x. In re not sure. With 2.4 there was never reported a
problem with hotswap by any customer. We use Suse 9.2 / 9.3 and SLES 9.0.

Sorry for this reply not giving you a solution but we wish to have
one, too.

Greetings Bernd Rieke
