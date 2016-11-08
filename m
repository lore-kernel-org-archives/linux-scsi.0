From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Ordering problems with 3ware controller
Date: Tue, 8 Nov 2016 11:07:37 +0100
Message-ID: <a41b4bab-edb7-34ab-eb76-7ff4d6e3f677@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.molgen.mpg.de ([141.14.17.9]:51289 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932477AbcKHKPc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 05:15:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adam Radford <linuxraid@lsi.com>

Dear Linux SCSI folks,


Updating from Linux 4.4.X to Linux 4.8.4, we noticed that the 3ware 
devices under `/dev` – `/dev/twa0`, `/dev/twa1`, … – map to the 
controllers differently.

This unfortunately breaks quite a lot of our scripts, as we depend on 
the fact that the first controller is also in the front.

> $ dmesg | grep 3ware
> [   14.509238] 3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
> [   14.824274] scsi host8: 3ware 9000 Storage Controller
> [   14.824537] 3w-9xxx: scsi8: Found a 3ware 9000 Storage Controller at 0xd0200000, IRQ: 17.
> [   15.508310] scsi host9: 3ware 9000 Storage Controller
> [   15.508569] 3w-9xxx: scsi9: Found a 3ware 9000 Storage Controller at 0xda100000, IRQ: 17.

Tracing `twi_cli` it looks like the ordering of the devices in 
`/sys/class/scsi_host` might have changed, as `getdents64` seems to be 
used for the ordering of creating `/dev/twaX`.

> $ find /sys/class/scsi_host/ -ls
>      6033      0 drwxr-xr-x   2  root     system          0 Nov  8 10:58 /sys/class/scsi_host/
>     23125      0 lrwxrwxrwx   1  root     system          0 Oct 27 17:41 /sys/class/scsi_host/host0 -> ../../devices/pci0000:00/0000:00:07.0/ata1/host0/scsi_host/host0
>     29893      0 lrwxrwxrwx   1  root     system          0 Oct 27 18:03 /sys/class/scsi_host/host9 -> ../../devices/pci0000:80/0000:80:0e.0/0000:90:00.0/host9/scsi_host/host9
>     23878      0 lrwxrwxrwx   1  root     system          0 Oct 27 17:41 /sys/class/scsi_host/host7 -> ../../devices/pci0000:80/0000:80:08.0/ata8/host7/scsi_host/host7
>     23640      0 lrwxrwxrwx   1  root     system          0 Oct 27 17:41 /sys/class/scsi_host/host5 -> ../../devices/pci0000:80/0000:80:07.0/ata6/host5/scsi_host/host5
>     23402      0 lrwxrwxrwx   1  root     system          0 Oct 27 17:41 /sys/class/scsi_host/host3 -> ../../devices/pci0000:00/0000:00:08.0/ata4/host3/scsi_host/host3
>     23164      0 lrwxrwxrwx   1  root     system          0 Oct 27 17:41 /sys/class/scsi_host/host1 -> ../../devices/pci0000:00/0000:00:07.0/ata2/host1/scsi_host/host1
>     29851      0 lrwxrwxrwx   1  root     system          0 Oct 27 18:03 /sys/class/scsi_host/host8 -> ../../devices/pci0000:00/0000:00:0e.0/0000:05:00.0/host8/scsi_host/host8
>     23839      0 lrwxrwxrwx   1  root     system          0 Oct 27 17:41 /sys/class/scsi_host/host6 -> ../../devices/pci0000:80/0000:80:08.0/ata7/host6/scsi_host/host6
>     23601      0 lrwxrwxrwx   1  root     system          0 Oct 27 17:41 /sys/class/scsi_host/host4 -> ../../devices/pci0000:80/0000:80:07.0/ata5/host4/scsi_host/host4
>     23363      0 lrwxrwxrwx   1  root     system          0 Oct 27 17:41 /sys/class/scsi_host/host2 -> ../../devices/pci0000:00/0000:00:08.0/ata3/host2/scsi_host/host2
> $ sudo -i tw_cli show
>
> Ctl   Model        (V)Ports  Drives   Units   NotOpt  RRate   VRate  BBU
> ------------------------------------------------------------------------
> c8    9650SE-8LPML 8         8        1       0       5       1      OK
> c9    9690SA-8E    0         0        0       0       5       1      OK
>
> Enclosure     Slots  Drives  Fans  TSUnits  PSUnits  Alarms
> --------------------------------------------------------------
> /c9/e0        16     0       3     1        2        1

So in this case `c8` is mapped to `/dev/twa1`, and `c9` to `/dev/twa0`.

As we do not know of a way, to use `tw_cli` to find the correct mapping, 
or another place, we rely on the implicit ordering, which – according to 
my colleagues – has worked for over 15 years [1].

Do you know of a way, to either get the mapping “over an API” so we 
don’t have to rely on the implicit ordering?

Otherwise, do you know, why the ordering has changed, and can this be 
reverted?


Kind regards,

Paul Menzel


[1] 
https://www.thomas-krenn.com/de/wiki/Smartmontools_mit_3ware_RAID_Controller
     (German)
