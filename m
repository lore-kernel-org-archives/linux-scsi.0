From: Yanggun <yang.geum.seok@gmail.com>
Subject: Re: [PATCH 0/2] some block and scsi layer additions for ULD scatterlist code
Date: Wed, 7 Dec 2005 10:17:39 +0900
Message-ID: <ee0ae26a0512061717q49dcb6c3h@mail.gmail.com>
References: <1133771825.23619.16.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.207]:63442 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932675AbVLGBRk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Dec 2005 20:17:40 -0500
Received: by zproxy.gmail.com with SMTP id 12so222861nzp
        for <linux-scsi@vger.kernel.org>; Tue, 06 Dec 2005 17:17:40 -0800 (PST)
In-Reply-To: <1133771825.23619.16.camel@max>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: axboe@suse.de, Linux SCSI list <linux-scsi@vger.kernel.org>

Hi,

i am currently using linux kernel version 2.6.15-rc5 on x86 with Promise
SATAII150 TX2Plus(250G SATA HDD Disk x 2).

But, SATA HDD disk does not become. program execute result of "fdisk
/dev/sda" is  "Unable to read /dev/sda".

Work well in linux kernel version 2.6.13.2.

Do not act below since change as result that do debugging.
      "[SCSI] use scatter lists for all block pc requests and
simplify hw handlers"
      -  http://kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=392160335c798bbe94ab3aae6ea0c85d32b81bbc


Test and tried your bug patch,  but, result is same.

By result that I do debugging, if queuecommand () of LLD layer returns
result properly, but execute scsi_probe_lun () -> scsi_execute_req ()
-> blk_execute_rq ()  by thing which is not realized to proc/scsi/scsi
come out . after execute blk_execute_rq(), then cmd->buffer,
cmd->request_buffer is NULL. so, "Model:"  in scsi_add_lun() ->
print_inquiry() comes out NULL.

I what whether must do debugging inform can?

what should I do?

Test Enviroment
--------------
Kernel version: 2.6.15-rc5
SATA Controller: Promise SATAII150 TX2Plus
SATA HDD: Western Digital 250G x 2
SATA Driver: http://www.promise.com/support/download/download2_eng.asp?productID=126&category=all&os=100#

Log
----------------
Nov 24 18:08:27 kernel: ulsata2:[info] Drive 1/0: WDC
WD2500JS-22MHB0    488397167s 250059MB  UDMA6
Nov 24 18:08:27 kernel: ulsata2:[info] Drive 3/0: WDC
WD2500JS-22MHB0    488397167s 250059MB  UDMA6
Nov 24 18:08:27 kernel: scsi0 : ulsata2
Nov 24 18:08:27 kernel:   Vendor:           Model:
      Rev:
Nov 24 18:08:27 kernel:   Type:   Direct-Access
      ANSI SCSI revision: 00
Nov 24 18:08:27 kernel: sda : sector size 0 reported, assuming 512.
Nov 24 18:08:27 kernel: SCSI device sda: 1 512-byte hdwr sectors (0 MB)
Nov 24 18:08:27 kernel: sda: asking for cache data failed
Nov 24 18:08:27 kernel: sda: assuming drive cache: write through
Nov 24 18:08:27 kernel: sda : sector size 0 reported, assuming 512.
Nov 24 18:08:27 kernel: SCSI device sda: 1 512-byte hdwr sectors (0 MB)
Nov 24 18:08:27 kernel: sda: asking for cache data failed
Nov 24 18:08:27 kernel: sda: assuming drive cache: write through
Nov 24 18:08:27 kernel:  sda: sda1
Nov 24 18:08:27 kernel: sd 0:0:0:0: Attached scsi disk sda
Nov 24 18:08:27 kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Nov 24 18:08:27 kernel:   Vendor:           Model:
      Rev:
Nov 24 18:08:27 kernel:   Type:   Direct-Access
      ANSI SCSI revision: 00
Nov 24 18:08:27 kernel: sdb : sector size 0 reported, assuming 512.
Nov 24 18:08:27 kernel: SCSI device sdb: 1 512-byte hdwr sectors (0 MB)
Nov 24 18:08:27 kernel: sdb: asking for cache data failed
Nov 24 18:08:27 kernel: sdb: assuming drive cache: write through
Nov 24 18:08:27 kernel: sdb : sector size 0 reported, assuming 512.
Nov 24 18:08:27 kernel: SCSI device sdb: 1 512-byte hdwr sectors (0 MB)
Nov 24 18:08:27 kernel: sdb: asking for cache data failed
Nov 24 18:08:27 kernel: sdb: assuming drive cache: write through
Nov 24 18:08:27 kernel:  sdb: sdb1
Nov 24 18:08:27 kernel: sd 0:0:2:0: Attached scsi disk sdb
Nov 24 18:08:27 kernel: sd 0:0:2:0: Attached scsi generic sg1 type 0


[root@test root]# lsmod
Module                  Size  Used by
snd_pcm_oss            48288  0
snd_pcm                80520  1 snd_pcm_oss
snd_timer              21508  1 snd_pcm
snd_page_alloc          8456  1 snd_pcm
snd_mixer_oss          17024  1 snd_pcm_oss
lp                      9412  0
parport                31816  1 lp
snd                    47076  4 snd_pcm_oss,snd_pcm,snd_timer,snd_mixer_oss
soundcore               7776  1 snd
sr_mod                 15268  0
sg                     34208  0
i810                   20480  0
i830                   24832  0
odcap                  21488  2
button                  5008  0
sbp2                   21252  0
ohci1394               31540  0
ieee1394               87224  2 sbp2,ohci1394
pl2303                 18948  0
usbserial              27368  1 pl2303
usb_storage            53696  0
uhci_hcd               30096  0
ide_scsi               14468  0
raid1                  17920  0
md_mod                 59088  1 raid1
ehci_hcd               29960  0
usbcore               106880  6 pl2303,usbserial,usb_storage,uhci_hcd,ehci_hcd
e1000                  99892  0
sd_mod                 15888  0
ulsata2               132060  0
scsi_mod              122984  7
sr_mod,sg,sbp2,usb_storage,ide_scsi,sd_mod,ulsata2



[root@sentry24 root]# sfdisk -l

Disk /dev/hda: 1007 cylinders, 16 heads, 63 sectors/track
Units = cylinders of 516096 bytes, blocks of 1024 bytes, counting from 0

  Device Boot Start     End   #cyls    #blocks   Id  System
/dev/hda1   *      0+   1006    1007-    507496+  83  Linux
/dev/hda2          0       -       0          0    0  Empty
/dev/hda3          0       -       0          0    0  Empty
/dev/hda4          0       -       0          0    0  Empty

Disk /dev/sda: 0 cylinders, 64 heads, 32 sectors/track
Warning: The partition table looks like it was made
 for C/H/S=*/255/63 (instead of 0/64/32).
For this listing I'll assume that geometry.
Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0

  Device Boot Start     End   #cyls    #blocks   Id  System
/dev/sda1          0+  30400   30401- 244196001   83  Linux
/dev/sda2          0       -       0          0    0  Empty
/dev/sda3          0       -       0          0    0  Empty
/dev/sda4          0       -       0          0    0  Empty

Disk /dev/sdb: 0 cylinders, 64 heads, 32 sectors/track
Warning: The partition table looks like it was made
 for C/H/S=*/255/63 (instead of 0/64/32).
For this listing I'll assume that geometry.
Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0

  Device Boot Start     End   #cyls    #blocks   Id  System
/dev/sdb1          0+  30400   30401- 244196001   83  Linux
/dev/sdb2          0       -       0          0    0  Empty
/dev/sdb3          0       -       0          0    0  Empty
/dev/sdb4          0       -       0          0    0  Empty
[root@sentry24 root]#



[root@sentry24 root]# sg_map -i -x
/dev/sg0  0 0 0 0  0  /dev/sda    WDC WD2500JS-00M
/dev/sg1  0 0 2 0  0  /dev/sdb    WDC WD2500JS-00M
[root@sentry24 root]#



[root@sentry24 root]# fdisk -l /dev/sda
[root@sentry24 root]# fdisk /dev/sda

Unable to read /dev/sda
[root@sentry24 root]#

[root@sentry24 root]# !parted
parted --script /dev/sda mklabel msdos
Error: Can't have a partition outside the disk!
Error: Operation not permitted during read on /dev/sda
Error: Operation not permitted during write on /dev/sda

2005/12/5, Mike Christie <michaelc@cs.wisc.edu>:
> These two patches are some of the core or bugfix code for the SCSI ULD
> scatterlist code. The first patch exports the block layer functions
> needed to be able to do async REQ_BLOCK_PC commands and hook into the
> request end_io callout and it adds the max_hw_sectors code. And the
> second patch fixes a bug in st where it allows SCSI-ml to retry commands
> and reverts SCSI-ml back to its previous behavior where it does not
> allow scsi_io_completion to retry REQ_BLOCK_PC (previously special
> requests) commands.
>
> These patches were made against linux-2.6-block, but apply with some
> offset to scsi-misc.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
