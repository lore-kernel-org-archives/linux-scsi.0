From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptspi : min_period, max_offset,max_width,incorrectlyset, resulting domain validation failing
Date: Wed, 20 Sep 2006 09:24:52 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7032CEFC@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:50412 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751621AbWITPZC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Sep 2006 11:25:02 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Tuesday, September 19, 2006 7:17 PM, James Bottomley wrote: 

> Well, by standard, I'm supposed to start out negotiation with the
> fastest I can possibly do and the drive modifies this in its 
> reply.  The
> heuristics over DT vs non-DT in the transport class are to cope with
> arguably buggy drives in the field.  I've never come across a 
> DT capable
> drive on an LVD bus that showed a problem in this regard ... have you
> found one?
> 

Yes I have a U160 drive that does that.  Meaning sending a ppr
with factor=0x8, the device returns factor=0xA.  Instead
if you send a factor=0x9, the device returns factor=0x9.  In 
other words, spi transport is short changing nego on U160 devices.
See my proof at the end of this email.

My suggestion is:
the spi transport layer should only negotiate at factor=0x8
when both QAS and IUS are enabled in byte 56 of the inquiry 
data.  When you see both these bits zero, you should start 
your max speed inquiry test at factor=0x9 instead of factor=0x8. 
Yeah, I know that this came out in SPI-3, but there really
are no U160 devices out there that can actually do QAS. 

Also, another problem is you should only enable QAS when all 
the devices on a single bus are U320(excluding safte proc).  
Meaning, if you have mixed mode case, such as U160 mixed with 
U320, you should disable QAS for all the U320 devices.
The problem you will face is the U320 devices with QAS enabled
are going to starve the bus, and the other devices never win 
arbitration.  I've seen in my test bed using current
spi transport.  In my environment, I have two U160 devices,
and one U320 device. Spi transport will enable
QAS for the U320 device.

-----------------------------------------------------------------

Here is my proof.  Here are two scsi bus traces.  

(1) The first trace shows that sending ppr with 
factor=0x8 nego, the device returns with factor=0xA.   
(2) The second trace shows that sending ppr with 
factor=0x9 nego, the device returns with factor=0x9.


Fist Trace:

  129          2_414  Arb
  130          1_316  Arbwin 7
  131          0_788 +Select 7,0
  132         11_878 +Sel/Resel End
  133        178_276 +MsgOut C0 Identify
                             20 Simple Queue
                             01 Tag
                             01 06 04 08 00 7F 01 D3
                       Parallel Protocol Pw:6.25ns,off:127,Width:16
bits,
                       IU=1 DT=1 QAS=0
  134         44_228  MsgIn  01 06 04 0A 00 3F 01 00
                       Parallel Protocol Pw:25ns,off:63,Width:16 bits,
                       IU=0 DT=0 QAS=0
  135        197_962  CMD - Inquiry     
                       12 00 00 00 60 00
  136          1_174  DataIn (W)
                   0h: 00 00 03 02 5B 00 00 3E ....[..>
                   8h: 51 55 41 4E 54 55 4D 20 QUANTUM 
                  10h: 41 54 4C 41 53 20 56 20 ATLAS V 
                  18h: 33 36 20 57 4C 53 20 20 36 WLS  
                  20h: 30 41 30 36 31 34 33 39 0A061439
                  28h: 39 31 31 32 32 30 32 38 91122028
                  30h: 20 20 39 39 31 30 30 37   991007
                  38h: 0C 30 30 30 30 30 30 30 .0000000
                  40h: 30 30 30 30 30 30 30 30 00000000
                  48h: 30 30 30 30 30 30 30 30 00000000
                  50h: 30 30 30 30 30 30 30 30 00000000
                  58h: 30 30 30 30 30 30 30 30 00000000
                      (96 Bytes)
  137         46_262  DEnd  96 Bytes
  138          0_938  Status 00 Good
  139          1_224  MsgIn  00 Cmd Complete
  140         59_330 Bus Free 


Second Trace:

  128        730_298 Bus Free
  129          2_412  Arb
  130          1_314  Arbwin 7
  131          0_790 +Select 7,0
  132         12_830 +Sel/Resel End
  133        161_576 +MsgOut C0 Identify
                             20 Simple Queue
                             01 Tag
                             01 06 04 09 00 7F 01 02
                       Parallel Protocol Pw:12.5ns,off:127,Width:16
bits,
                       IU=0 DT=1 QAS=0
  134         45_576  MsgIn  01 06 04 09 00 3F 01 02
                       Parallel Protocol Pw:12.5ns,off:63,Width:16 bits,
                       IU=0 DT=1 QAS=0
  135        201_852  CMD - Inquiry     
                       12 00 00 00 60 00
  136          0_644  DataIn (DT)
                   0h: 00 00 03 02 5B 00 00 3E ....[..>
                   8h: 51 55 41 4E 54 55 4D 20 QUANTUM 
                  10h: 41 54 4C 41 53 20 56 20 ATLAS V 
                  18h: 33 36 20 57 4C 53 20 20 36 WLS  
                  20h: 30 41 30 36 31 34 33 39 0A061439
                  28h: 39 31 31 32 32 30 32 38 91122028
                  30h: 20 20 39 39 31 30 30 37   991007
                  38h: 0C 30 30 30 30 30 30 30 .0000000
                  40h: 30 30 30 30 30 30 30 30 00000000
                  48h: 30 30 30 30 30 30 30 30 00000000
                  50h: 30 30 30 30 30 30 30 30 00000000
                  58h: 30 30 30 30 30 30 30 30 00000000
                      (96 Bytes)
  137         30_054  DEnd  96 Bytes
  138          0_938  Status 00 Good
  139          1_204  MsgIn  00 Cmd Complete
  140         88_910 Bus Free
