From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass
	larger receive buffer
Date: 17 Nov 2003 16:36:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069112216.5270.54.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
	 <1068766632.2851.142.camel@patrh9>
	 <20031113162401.A29775@beaverton.ibm.com>
	 <1069105104.2324.331.camel@patrh9>
	 <20031117140032.A21143@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:19909 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261831AbTKQXh5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2003 18:37:57 -0500
In-Reply-To: <20031117140032.A21143@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: linux-scsi@vger.kernel.org

> If you want to test with your read only media, just use the dev flags:
> 
> 	echo "vendor:model:0x4000" > /proc/scsi/device_info 
> 
> Then add your device, see if it comes back as writable, and try to mount
> or write it, and compare without the above (you can't remove device_info
> entry without rebooting or rmmod-ing scsi).

Success!

Yes I see, same for sd as for sr/ide-cd, we can defeat write-protect in
2.6.0-test9 by root privilege so that then we can fail to write thru dd
or thru mount without bothering to notify the user loudly.

To prepare I remember I tried:

1) Make device writable.
2) mkfs
3) sync
4) Unplug.
5) Make device read-only.
6) Plug back in.

Thereafter I saw such tty logs as:

$ sudo sg_scan -i
/dev/sg0: scsi0 channel=0 id=0 lun=0 [em]  type=0
    LEXAR     DIGITAL FILM      /W1. [wide=0 sync=0 cmdq=0 sftre=0 pq=0x0]
$
$ v="LEXAR   "; m="DIGITAL FILM    "; echo "$v:$m:0x4000" | sudo dd of=/proc/scsi/device_info
0+1 records in
0+1 records out
$
$ sudo dd of=/dev/sda1 if=/dev/zero bs=512 count=1
dd: opening `/dev/sda1': Read-only file system
$
$ sudo modprobe -r usb-storage
$ sudo modprobe usb-storage
$
$ sudo dd of=/dev/sda1 if=/dev/zero bs=512 count=1
1+0 records in
1+0 records out
$
$ dmesg | tail
usb-storage:  -y "00 00 00 00 00 00"
usb-storage:  -i 0x1000 -y "28 00 00 00 00 20 00 00 08 00"
usb-storage:  -o 0x1000 -y "2A 00 00 00 00 20 00 00 08 00"
SCSI error : <4 0 0 0> return code = 0x8000002
Info fld=0x0, Current sda: sense = f0  7
ASC=27 ASCQ= 0
Raw sense data:0xf0 0x00 0x07 0x00 0x00 0x00 0x00 0x0b 0x00 0x00 0x00 0x00 0x27 0x00 0x00 0x00 0x00 0x00 0x00
end_request: I/O error, dev sda, sector 32
Buffer I/O error on device sda1, logical block 0
lost page write due to I/O error on sda1
$
$ sudo mount /dev/sda1 /mnt/sda1
$ ls /mnt/sda1
lost+found
$ sudo umount /mnt/sda1
$ dmesg | tail
 [<c010b509>] sysenter_past_esp+0x52/0x71
 
usb-storage:  -o 0x400 -y "2A 00 00 00 00 22 00 00 02 00"
SCSI error : <4 0 0 0> return code = 0x8000002
Info fld=0x0, Current sda: sense = f0  7
ASC=27 ASCQ= 0
Raw sense data:0xf0 0x00 0x07 0x00 0x00 0x00 0x00 0x0b 0x00 0x00 0x00 0x00 0x27 0x00 0x00 0x00 0x00 0x00 0x00
end_request: I/O error, dev sda, sector 34
Buffer I/O error on device sda1, logical block 1
lost page write due to I/O error on sda1
$

> [Trimmed the cc line]

Ack.

I concluded by trying:

$ egrep 'CONFIG_SCSI.*m' .config
CONFIG_SCSI=m
CONFIG_SCSI_DEBUG=m
$

Also I was helped by the dmesg:

scsi_strcpy_devinfo: vendor string 'LEXAR     ' is too long
scsi_strcpy_devinfo: model string 'DIGITAL FILM      ' is too long

And I failed to immediately grok `logger`.  Instead I correlated my
shell commands with my dmesg by patching usb-storage to trace cdb's. 

Pat LaVarre


