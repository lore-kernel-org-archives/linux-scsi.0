From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Sat, 10 Apr 2004 18:42:16 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0404101744350.1502-100000@poirot.grange>
References: <200404101558.40004.info@roessner-net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:21982 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262060AbUDJQrz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2004 12:47:55 -0400
In-Reply-To: <200404101558.40004.info@roessner-net.com>
List-Id: linux-scsi@vger.kernel.org
To: Christian Roessner <info@roessner-net.com>
Cc: linux-scsi@vger.kernel.org

Hi

On Sat, 10 Apr 2004, Christian Roessner wrote:

> I noticed that the tmscsim module seems to have problems with my DawiControl
> (2974??) and the TEAC CD writer. I told some people at
> linux-kernel@vger.kernel.org that the AM53C974 was the only driver that ever
> worked for me (2.4.x kernels). They said it was discussed here if to keep the

Ok, to try to fix the problem we'll have to enable very verbose debugging
in scsi. The good thing about your problem is that you don't boot from
tmscsim. So, you can compile it as a module, load it, unload, etc.

Are you getting any errors in /var/log/messages? First, please, enable
scsi-logging in your kernel configuration. Are you regularly using scsi
for anything else (other scsi controllers, usb storage, ieee1394)? Can you
refrain from using them, while testing with tmscsim? If so, set the
scsi-logging level to 0x1ff. If you have scsi compiled in kernel, specify
scsi_logging=0x1ff as a boot-parameter, if as a module, load it with
modprobe scsi_mod scsi_logging_level=0x1ff
Then uncomment defines for DC390_DEBUG0, DC390_DEBUG1, DC390_DCBDEBUG in
drivers/scsi/tmscsim.c. Configure tmscsim as a module, recompile it and
load it. Then please, send an extract from your /var/log/messages
corresponding to the driver-initialisation, device detection. If it is too
big, you can send just the principle information here, and just a link to
the location of the log, or, if the former is impossible, just send the
complete log to me offlist, then I would upload it somewhere. Of course,
it would be best if everybody had access to the log.

> cat /proc/scsi/scsi:
>
> Host: scsi1 Channel: 00 Id: 04 Lun: 00
>   Vendor:          Model:   }     @ C      Rev:
>   Type:   Direct-Access                    ANSI SCSI revision: ffffffff

Ok, that doesn't look right:-)

> cat /proc/scsi/tmscsim/1
>
> Tekram DC390/AM53C974 PCI SCSI Host Adapter, Driver Version 2.0f 2000-12-20
> SCSI Host Nr 1, AM53C974 Adapter Nr 0
> IOPortBase 0x9400, IRQ 11
> MaxID 7, MaxLUN 1, AdapterID 7, SelTimeout 250 ms, DelayReset 1 s
> TagMaxNum 16, Status 0x00, ACBFlag 0x00, GlitchEater 24 ns
> Statistics: Cmnds 15, Cmnds not sent directly 2, Out of SRB conds 0
>             Lost arbitrations 0, Sel. connected 0, Connected: No
> Nr of attached devices: 1, Nr of DCBs: 1
> Map of attached LUNs: 00 00 00 00 01 00 00 00
> Idx ID LUN Prty Sync DsCn SndS TagQ NegoPeriod SyncSpeed SyncOffs MaxCmd
> 00  04  00  Yes  No   Yes  Yes  No   (124 ns)                       01
> Commands in Queues: Query: 0:
>
>
> My system:
>
> lspci:
> 0000:00:00.0 Host bridge: nVidia Corporation nForce3 Host Bridge (rev a4)
...
> 0000:00:08.0 IDE interface: nVidia Corporation nForce3 IDE (rev a5)
> 0000:00:0a.0 PCI bridge: nVidia Corporation nForce3 PCI Bridge (rev a2)
> 0000:00:0b.0 PCI bridge: nVidia Corporation nForce3 AGP Bridge (rev a4)
> 0000:00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
> 0000:00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
> 0000:00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
> 0000:00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
...
> 0000:01:07.0 SCSI storage controller: Advanced Micro Devices [AMD] 53c974
> [PCscsi] (rev 10)
...
> 0000:01:0c.0 RAID bus controller: Integrated Technology Express, Inc.: Unknown
> device 8212 (rev 11)
> 0000:01:0d.0 RAID bus controller: CMD Technology Inc: Unknown device 3512 (rev
> 01)
> 0000:01:0e.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000
> Controller (PHY/Link)
...

> uname -a:
>
> Linux amd64 2.6.5-gentoo #2 Fri Apr 9 01:34:26 CEST 2004 x86_64 4  GNU/Linux


Ooh... 64bit... Ok, all the more interesting:-) I can forsee a lot of
fun:-)

Thanks
Guennadi
---
Guennadi Liakhovetski





