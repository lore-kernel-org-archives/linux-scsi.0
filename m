From: Christian Roessner <info@roessner-net.com>
Subject: tmscsim broken on amd64 with 2.6.5?
Date: Sat, 10 Apr 2004 15:58:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404101558.40004.info@roessner-net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p15112047.pureserver.info ([217.160.169.118]:28869 "EHLO
	mail.wim-media.de") by vger.kernel.org with ESMTP id S262022AbUDJN6g
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2004 09:58:36 -0400
Received: from mail.wim-media.de (localhost.localdomain [127.0.0.1])
	by wim-media.de (Postfix) with ESMTP id C15D7398002
	for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2004 15:59:02 +0200 (CEST)
Received: from [192.168.1.3] (pD9E2A553.dip.t-dialin.net [217.226.165.83])
	by mail.wim-media.de (Postfix) with ESMTP id 58B79398001
	for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2004 15:59:02 +0200 (CEST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I noticed that the tmscsim module seems to have problems with my DawiControl 
(2974??) and the TEAC CD writer. I told some people at 
linux-kernel@vger.kernel.org that the AM53C974 was the only driver that ever 
worked for me (2.4.x kernels). They said it was discussed here if to keep the 
driver in 2.6.x or not. They said the tmscsim would be preffered, so I send 
you some output with the hope you are able to fix it. A friend gave me an 
Adaptec 2940/UW, so I normally would not need to have this fixed, but I will 
wait and help you finding the error if you want to (Replacing the adapter 
later).


cat /proc/scsi/scsi:

Host: scsi1 Channel: 00 Id: 04 Lun: 00
  Vendor:          Model:   }     @ C      Rev:
  Type:   Direct-Access                    ANSI SCSI revision: ffffffff


cat /proc/scsi/tmscsim/1

Tekram DC390/AM53C974 PCI SCSI Host Adapter, Driver Version 2.0f 2000-12-20
SCSI Host Nr 1, AM53C974 Adapter Nr 0
IOPortBase 0x9400, IRQ 11
MaxID 7, MaxLUN 1, AdapterID 7, SelTimeout 250 ms, DelayReset 1 s
TagMaxNum 16, Status 0x00, ACBFlag 0x00, GlitchEater 24 ns
Statistics: Cmnds 15, Cmnds not sent directly 2, Out of SRB conds 0
            Lost arbitrations 0, Sel. connected 0, Connected: No
Nr of attached devices: 1, Nr of DCBs: 1
Map of attached LUNs: 00 00 00 00 01 00 00 00
Idx ID LUN Prty Sync DsCn SndS TagQ NegoPeriod SyncSpeed SyncOffs MaxCmd
00  04  00  Yes  No   Yes  Yes  No   (124 ns)                       01
Commands in Queues: Query: 0:


My system:

lspci:
0000:00:00.0 Host bridge: nVidia Corporation nForce3 Host Bridge (rev a4)
0000:00:01.0 ISA bridge: nVidia Corporation nForce3 LPC Bridge (rev a6)
0000:00:01.1 SMBus: nVidia Corporation nForce3 SMBus (rev a4)
0000:00:02.0 USB Controller: nVidia Corporation nForce3 USB 1.1 (rev a5)
0000:00:02.1 USB Controller: nVidia Corporation nForce3 USB 1.1 (rev a5)
0000:00:02.2 USB Controller: nVidia Corporation nForce3 USB 2.0 (rev a2)
0000:00:06.0 Multimedia audio controller: nVidia Corporation nForce3 Audio 
(rev a2)
0000:00:08.0 IDE interface: nVidia Corporation nForce3 IDE (rev a5)
0000:00:0a.0 PCI bridge: nVidia Corporation nForce3 PCI Bridge (rev a2)
0000:00:0b.0 PCI bridge: nVidia Corporation nForce3 AGP Bridge (rev a4)
0000:00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
0000:00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
0000:00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
0000:00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
0000:01:06.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
0000:01:07.0 SCSI storage controller: Advanced Micro Devices [AMD] 53c974 
[PCscsi] (rev 10)
0000:01:09.0 Multimedia video controller: Brooktree Corporation Bt848 Video 
Capture (rev 12)
0000:01:0a.0 Network controller: AVM Audiovisuelles MKTG & Computer System 
GmbH B1 ISDN
0000:01:0b.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 
(rev 10)
0000:01:0c.0 RAID bus controller: Integrated Technology Express, Inc.: Unknown 
device 8212 (rev 11)
0000:01:0d.0 RAID bus controller: CMD Technology Inc: Unknown device 3512 (rev 
01)
0000:01:0e.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 
Controller (PHY/Link)
0000:02:00.0 VGA compatible controller: nVidia Corporation NV18 [GeForce4 MX 
440 AGP 8x] (rev a2)


uname -a:

Linux amd64 2.6.5-gentoo #2 Fri Apr 9 01:34:26 CEST 2004 x86_64 4  GNU/Linux


gcc:

gcc (GCC) 3.3.3 20040217 (Gentoo Linux 3.3.3, propolice-3.3-7)


glibc:

2.3.3_pre20040207


Thanks in advance

Christian
