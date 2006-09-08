From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Device not ready problem
Date: Fri, 08 Sep 2006 11:18:44 +0200
Message-ID: <45013574.5030606@s5r6.in-berlin.de>
References: <45012A84.5050109@dataforce.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:14763 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S1750716AbWIHJW6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Sep 2006 05:22:58 -0400
In-Reply-To: <45012A84.5050109@dataforce.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kelvin Wood <kelvin@dataforce.com.au>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

Kelvin Wood wrote to linux1394-user:
> Hi everyone,
> 
> We recently purchased a Maxtor 300GB drive, and we've been trying to 
> mount the drive on a server running RedHat Enterprise 3. So far, we've 
> got the server to detect the drive and map it to /dev/sda device, but it 
> seems to have the following errors out while trying to read the disk:
> 
> Sep  8 18:02:35 server kernel: blk: queue c8897a18, I/O limit 4095Mb (mask 0xffffffff)
> Sep  8 18:02:35 server kernel:   Vendor: Maxtor    Model: OneTouch III      Rev: 0338
> Sep  8 18:02:35 server kernel:   Type:   Direct-Access                      ANSI SCSI revision: 06
> Sep  8 18:02:35 server kernel: blk: queue c8897018, I/O limit 4095Mb (mask 0xffffffff)
> Sep  8 18:02:35 server kernel: Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
> Sep  8 18:02:35 server kernel: SCSI device sda: 586114704 512-byte hdwr sectors (300091 MB)
> Sep  8 18:02:35 server kernel:  sda:<6>Device 08:00 not ready.
> Sep  8 18:02:35 server kernel:  I/O error: dev 08:00, sector 0
> Sep  8 18:02:35 server kernel: Device 08:00 not ready.
> Sep  8 18:02:35 server kernel:  I/O error: dev 08:00, sector 0
> Sep  8 18:02:35 server kernel:  unable to read partition table

Was the disk already spinning before sbp2 logged in?

If it was _not_ spinning, then it was fixed in Linux 2.6.18-rc4,
2.6.17.2, and 2.6.16.28 by
http://kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e31f59ce593b073ee14241781edfb0637697eeb6
See also https://bugzilla.novell.com/show_bug.cgi?id=183011 and try the
sg_start command, as suggested in comment #2 at this bug. (After that,
you'd need to somehow force Linux to re-read the partition table.)

If the disk was already spinning, it is hard to say whether this patch
would be the fix. Additional SCSI debug logging or the sg_start trick
would tell us. Alas...

> Other bits of miscellaneous information that may help:
> 
> Kernel: kernel-smp-2.4.21-40.EL
> Libraw: libraw1394-0.9.0-10.RHEL3

...I don't know if the SCSI core's code which above 2.6 patch relies on
is also available in Linux 2.4 or as a patch for Linux 2.4. The guys at
linux-scsi know more about it, therefore I crossposted.

> [root@server root]# cat /proc/scsi/sbp2_0/1
> Host scsi1             : SBP-2 IEEE-1394 (ohci1394)
> Driver version         : $Rev: 906 $ James Goodwin <jamesg@filanet.com>
> 
> Module options         :
>   max_speed            : S800
>   max_sectors          : 255
>   serialize_io         : no
>   exclusive_login      : yes
> 
> Attached devices       :
>   [Channel: 00, Id: 00, Lun: 00]  Direct-Access     Maxtor   OneTouch III
> 
> [root@server root]# lspci
> 00:00.0 Host bridge: Broadcom CNB20HE Host Bridge (rev 23)
> 00:00.1 Host bridge: Broadcom CNB20HE Host Bridge (rev 01)
> 00:00.2 Host bridge: Broadcom CNB20HE Host Bridge (rev 01)
> 00:00.3 Host bridge: Broadcom CNB20HE Host Bridge (rev 01)
> 00:01.0 RAID bus controller: Compaq Computer Corporation Smart Array 5i/532 (rev 01)
> 00:02.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 08)
> 00:04.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 08)
> 00:05.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
> 00:06.0 System peripheral: Compaq Computer Corporation Advanced System Management Controller
> 00:0f.0 ISA bridge: Broadcom OSB4 South Bridge (rev 51)
> 00:0f.1 IDE interface: Broadcom OSB4 IDE Controller
> 00:0f.2 USB Controller: Broadcom OSB4/CSB5 OHCI USB Controller (rev 04)
> 01:03.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 61)
> 01:03.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 61)
> 01:03.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 63)
> 01:03.3 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller (rev 46)
> 07:03.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
> 07:07.0 PCI Hot-plug controller: Compaq Computer Corporation PCI Hotplug Controller (rev 12)
> 
> [root@server root]# cat /proc/scsi/scsi
> Attached devices:
> Host: scsi0 Channel: 00 Id: 06 Lun: 00
>   Vendor: HP       Model: Ultrium 2-SCSI   Rev: S24D
>   Type:   Sequential-Access                ANSI SCSI revision: 03
> Host: scsi1 Channel: 00 Id: 00 Lun: 00
>   Vendor: Maxtor   Model: OneTouch III     Rev: 0338
>   Type:   Direct-Access                    ANSI SCSI revision: 06
> 
> Have we got a dud disk on our hands, or is this a problem with the driver?
> 
> Thanks,
> 
> Kelvin

Do you have a Windows box with FireWire or a Mac to test the disk?
-- 
Stefan Richter
-=====-=-==- =--= -=---
http://arcgraph.de/sr/
