From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Qemu-devel] megasas: Unexpected response from lun 1 while
 scanning, scan aborted
Date: Thu, 28 Mar 2019 15:24:44 +0100
Message-ID: <78e04dbb-de4f-3d1b-973d-6cb906a13e42@suse.de>
References: <9c3849cf-86c6-4568-bff5-1050b445322d@default>
 <c3a8f877-82bc-44ab-72e8-51f62c0a65ed@suse.de>
 <442316ee-8800-275c-85e9-a5d054a28e63@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <442316ee-8800-275c-85e9-a5d054a28e63@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-block@nongnu.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
List-Id: linux-scsi@vger.kernel.org

On 3/28/19 1:47 AM, Dongli Zhang wrote:
> 
> 
> On 3/27/19 7:31 PM, Hannes Reinecke wrote:
>> On 3/26/19 5:47 PM, Dongli Zhang wrote:
>>> I am reporting an error that the scsi lun cannot initialize successfully when I
>>> am emulating megasas scsi controller with qemu.
>>>
>>> I am not sure if this is issue in qemu or linux kernel.
>>>
>>> When 'lun=1' is specified, there is "Unexpected response from lun 1 while
>>> scanning, scan aborted".
>>>
>>> Everything works well if 'lun=0' is specified.
>>>
>>>
>>> Below is the qemu cmdline involved:
>>>
>>> -device megasas,id=scsi0 \
>>> -device scsi-hd,drive=drive0,bus=scsi0.0,lun=1 \
>>> -drive file=/home/zhang/img/test.img,if=none,id=drive0,format=raw
>>>
>>>
>>> Below is the syslog related to 'scsi|SCSI'
>>>
>>> # dmesg | grep SCSI
>>> [    0.392494] SCSI subsystem initialized
>>> [    0.460666] Block layer SCSI generic (bsg) driver version 0.4 loaded (major
>>> 251)
>>> [    0.706788] sd 1:0:0:0: [sda] Attached SCSI disk
>>> # dmesg | grep scsi
>>> [    0.511643] scsi host0: Avago SAS based MegaRAID driver
>>> [    0.523302] scsi 0:2:0:0: Unexpected response from lun 1 while scanning,
>>> scan aborted
>>> [    0.540364] scsi host1: ata_piix
>>> [    0.540780] scsi host2: ata_piix
>>> [    0.702396] scsi 1:0:0:0: Direct-Access     ATA      QEMU HARDDISK    2.5+
>>> PQ: 0 ANSI: 5
>>>
>>> When 'lun=1' is changed to 'lun=0', there is no issue.
>>>
>>> Thank you very much!
>>>
>> That's an artifact from the megasas emulation in quemu.
>> Megasas (internally) can't handle LUN numbers (the RAID part only knows about
>> 'disks'), so I took the decision to not expose devices with LUN != 0.
>> Please use a different SCSI target number, not a non-zero LUN number.
> 
> The guest kernel is able to detect the disk if lun is always 0, while target
> number is changed:
> 
> -device scsi-hd,drive=drive0,bus=scsi0.0,channel=0,scsi-id=0,lun=0
> -device scsi-hd,drive=drive1,bus=scsi0.0,channel=0,scsi-id=1,lun=0
> 
> # dmesg | grep scsi
> [    0.935999] scsi host0: ata_piix
> [    0.936401] scsi host1: ata_piix
> [    1.100945] scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    2.5+
> PQ: 0 ANSI: 5
> [    1.102409] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    1.672952] scsi host2: Avago SAS based MegaRAID driver
> [    1.683886] scsi 2:2:0:0: Direct-Access     QEMU     QEMU HARDDISK    2.5+
> PQ: 0 ANSI: 5
> [    1.684915] scsi 2:2:1:0: Direct-Access     QEMU     QEMU HARDDISK    2.5+
> PQ: 0 ANSI: 5
> [    1.701529] sd 2:2:0:0: Attached scsi generic sg1 type 0
> [    1.704795] sd 2:2:1:0: Attached scsi generic sg2 type 0
> # dmesg | grep SCSI
> [    0.111015] SCSI subsystem initialized
> [    0.904712] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 246)
> [    1.121174] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.703739] sd 2:2:0:0: [sdb] Attached SCSI disk
> [    1.706964] sd 2:2:1:0: [sdc] Attached SCSI disk
> 
> 
> 
> If device with LUN != 0 will not be exposed, why not set max_lun = 0 as what
> qemu lsi is doing?
> 
> diff --git a/hw/scsi/megasas.c b/hw/scsi/megasas.c
> index a56317e..c966ee0 100644
> --- a/hw/scsi/megasas.c
> +++ b/hw/scsi/megasas.c
> @@ -2298,7 +2298,7 @@ static void megasas_scsi_uninit(PCIDevice *d)
>   static const struct SCSIBusInfo megasas_scsi_info = {
>       .tcq = true,
>       .max_target = MFI_MAX_LD,
> -    .max_lun = 255,
> +    .max_lun = 0,
> 
>       .transfer_data = megasas_xfer_complete,
>       .get_sg_list = megasas_get_sg_list,
> 
Hmm. Good point.

In _theory_ one could just jbod mode, in which case _all_ LUNs are 
exposed. But then we could probably adjust it, based on which mode is 
selected.
I'll check.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
