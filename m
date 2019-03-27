From: Hannes Reinecke <hare@suse.de>
Subject: Re: megasas: Unexpected response from lun 1 while scanning, scan
 aborted
Date: Wed, 27 Mar 2019 12:31:37 +0100
Message-ID: <c3a8f877-82bc-44ab-72e8-51f62c0a65ed@suse.de>
References: <9c3849cf-86c6-4568-bff5-1050b445322d@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9c3849cf-86c6-4568-bff5-1050b445322d@default>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-block@nongnu.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com
Cc: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
List-Id: linux-scsi@vger.kernel.org

On 3/26/19 5:47 PM, Dongli Zhang wrote:
> I am reporting an error that the scsi lun cannot initialize successfully when I
> am emulating megasas scsi controller with qemu.
> 
> I am not sure if this is issue in qemu or linux kernel.
> 
> When 'lun=1' is specified, there is "Unexpected response from lun 1 while
> scanning, scan aborted".
> 
> Everything works well if 'lun=0' is specified.
> 
> 
> Below is the qemu cmdline involved:
> 
> -device megasas,id=scsi0 \
> -device scsi-hd,drive=drive0,bus=scsi0.0,lun=1 \
> -drive file=/home/zhang/img/test.img,if=none,id=drive0,format=raw
> 
> 
> Below is the syslog related to 'scsi|SCSI'
> 
> # dmesg | grep SCSI
> [    0.392494] SCSI subsystem initialized
> [    0.460666] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    0.706788] sd 1:0:0:0: [sda] Attached SCSI disk
> # dmesg | grep scsi
> [    0.511643] scsi host0: Avago SAS based MegaRAID driver
> [    0.523302] scsi 0:2:0:0: Unexpected response from lun 1 while scanning, scan aborted
> [    0.540364] scsi host1: ata_piix
> [    0.540780] scsi host2: ata_piix
> [    0.702396] scsi 1:0:0:0: Direct-Access     ATA      QEMU HARDDISK    2.5+ PQ: 0 ANSI: 5
> 
> When 'lun=1' is changed to 'lun=0', there is no issue.
> 
> Thank you very much!
> 
That's an artifact from the megasas emulation in quemu.
Megasas (internally) can't handle LUN numbers (the RAID part only knows 
about 'disks'), so I took the decision to not expose devices with LUN != 0.
Please use a different SCSI target number, not a non-zero LUN number.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
