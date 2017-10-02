From: Hannes Reinecke <hare@suse.de>
Subject: Re: mptsas driver cannot detect hotplugging disk with the LSI SCSI
 SAS1068 controller in Ubuntu guest on VMware
Date: Mon, 2 Oct 2017 16:32:47 +0200
Message-ID: <1ad520f6-a1d8-5ce7-ee74-83edfdbfd39b@suse.de>
References: <CA+eFSM1aJRYs__pwtz+8E0TFOeKuKpHoiOkX6Wmm_2HMT1ut5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+eFSM1aJRYs__pwtz+8E0TFOeKuKpHoiOkX6Wmm_2HMT1ut5A@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Gavin Guo <gavin.guo@canonical.com>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/27/2017 09:33 AM, Gavin Guo wrote:
> There is a problem in the latest upstream kernel with the device:
> 
> $ grep -i lsi lspci
> 03:00.0 Serial Attached SCSI controller [0107]: LSI Logic / Symbios
> Logic SAS1068 PCI-X Fusion-MPT SAS [1000:0054] (rev 01)
> 
> The device is simulated by the VMware ESXi 5.5
> 
> When hotplugging a new disk to the Guest Ubuntu OS, the latest kernel
> cannot automatically probe the disk. However, on the v3.19.0-80.88
> kernel, the disk can be dynamically probed and show the following
> info message:
> 
> mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 1, phy 1,
> sas_addr 0x5000c29a6bdae0f5
> scsi 2:0:1:0: Direct-Access     VMware   Virtual disk     1.0  PQ: 0
> ANSI: 2
> sd 2:0:1:0: Attached scsi generic sg2 type 0
> sd 2:0:1:0: [sdb] 2097152 512-byte logical blocks: (1.07 GB/1.00 GiB)
> sd 2:0:1:0: [sdb] Write Protect is off
> sd 2:0:1:0: [sdb] Mode Sense: 61 00 00 00
> sd 2:0:1:0: [sdb] Cache data unavailable
> sd 2:0:1:0: [sdb] Assuming drive cache: write through
>  sdb: unknown partition table
> sd 2:0:1:0: [sdb] Attached SCSI disk
> 
> After looking up the message:
> mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 1, phy 1,
> sas_addr 0x5000c29a6bdae0f5
> 
> I found it comes from the path:
> mptsas_firmware_event_work -> mptsas_send_sas_event ->
> mptsas_hotplug_work -> mptsas_add_end_device
> 
> I'll appreciate if anyone can give the idea: If it's possible that the
> irq from the simulated LSI SAS controller didn't come in to trigger
> the event? However, it can work on the v3.19 kernel so if there is
> any driver implementation issue in the latest kernel.
> 
This is an issue with the mptsas driver, who originally assumed that no
system will have direct-attached SAS devices.
VMWare chose to implement exactly that, so the hotplug detection logic
is flawed here.
I'll be sending a patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
