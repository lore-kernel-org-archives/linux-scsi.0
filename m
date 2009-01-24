From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: race condition between scsi device add/remove code paths in
	2.6.28
Date: Fri, 23 Jan 2009 23:06:35 -0600
Message-ID: <1232773596.10682.1.camel@localhost.localdomain>
References: <8b62ef2d0901231608y8df423ema178ae8700173ea1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47017 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbZAXFGe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Jan 2009 00:06:34 -0500
In-Reply-To: <8b62ef2d0901231608y8df423ema178ae8700173ea1@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sudhakar <ssudhakarp@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Sat, 2009-01-24 at 05:38 +0530, Sudhakar wrote:
> Hi,
> 
> In our labs, we encountered a kernel crash, while stressing scsi
> device add/remove code path of 2.6.28 kernel. lsscsi output on my
> machine looks like this:
> 
> *******Start******
> 
> [root@IMIT2S005 ~]# lsscsi
> [0:0:0:0]    disk    ATA      ST3250620NS      3BKS  -
> [0:0:1:0]    disk    ATA      ST3250620NS      3BKS  -
> [0:0:2:0]    disk    ATA      ST3250620NS      3BKS  -
> [0:0:3:0]    disk    ATA      ST3250620NS      3BKS  -
> [0:1:0:0]    disk    Dell     VIRTUAL DISK     1028  /dev/sda
> [1:0:0:0]    cd/dvd  Optiarc  DVD RW AD-7190S  1.00  /dev/scd0
> [5:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sdb
> 
> *******End*********
> 
> I have written script which would recursively add/remove the lone lun
> of scsi_debug device. My script looks like this:
> 
> ********Start******
> 
> [root@IMIT2S005 temp]# cat s.sh
> while [ true ]
> do
>         echo "scsi remove-single-device 5 0 0 0" > /proc/scsi/scsi
>         echo "scsi add-single-device 5 0 0 0" > /proc/scsi/scsi
> done
> [root@IMIT2S005 temp]#
> 
> ********End********
> 
> When the above script is run for approximately 10 seconds, we started
> to see the following messages and finally NULL pointer dereference.
> 
> ********Start*******
> 
> Jan 24 00:13:12 IMIT2S005 kernel: ------------[ cut here ]------------
> Jan 24 00:13:12 IMIT2S005 kernel: WARNING: at fs/sysfs/dir.c:462
> sysfs_add_one+0x33/0x39()
> Jan 24 00:13:12 IMIT2S005 kernel: sysfs: duplicate filename '5:0:0:0'
> can not be created

This is thought to be fixed by 

commit 32aeef605aa01e1fee45e052eceffb00e72ba2b0
Author: Hannes Reinecke <hare@suse.de>
Date:   Tue Jan 13 16:50:37 2009 +0100

    [SCSI] Skip deleted devices in __scsi_device_lookup_by_target()
 
Which is now upstream.

James


