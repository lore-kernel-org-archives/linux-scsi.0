From: mroos@linux.ee
Subject: Re: [PATCH 1/4] async: introduce 'async_domain' type
Date: Fri, 25 May 2012 16:40:42 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1205251636080.27303@math.ut.ee>
References: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com>  <20120525075027.21933.75815.stgit@dwillia2-linux.jf.intel.com> <1337932267.2932.7.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337932267.2932.7.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Mark Brown <broonie@opensource.wolfsonmicro.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Liam Girdwood <lrg@ti.com>
List-Id: linux-scsi@vger.kernel.org

I applied these 4 patches on top of todays git (one trivial conflict 
with include removal) and it does not work - hangs here:

[   65.322282] PCI: Enabling device: (0000:00:0d.0), cmd 5
[   65.394252] scsi0 : pata_ali
[   65.432976] scsi1 : pata_ali
[   65.471610] ata1: PATA max UDMA/66 cmd 0x1fe02010200 ctl 0x1fe02010218 bmdma 0x1fe02010220 irq 12
[   65.588340] ata2: PATA max UDMA/66 cmd 0x1fe02010210 ctl 0x1fe02010208 bmdma 0x1fe02010228 irq 12
[   65.705941] Linux Tulip driver version 1.1.15-NAPI (Feb 27, 2007)
[   65.788850] tulip0: Old style EEPROM with no media selection information
[   65.877209] tulip0:  MII transceiver #1 config 1000 status 782d advertising 01e1
[   65.978529] net eth0: Davicom DM9102/DM9102A rev 49 at MMIO 0x1ff00000000, EEPROM not present, 00:03:ba:0c:06:cd, IRQ 9
[   66.123140] tulip1: Old style EEPROM with no media selection information
[   66.211483] tulip1:  MII transceiver #1 config 1000 status 7809 advertising 01e1
[   66.312539] net eth1: Davicom DM9102/DM9102A rev 49 at MMIO 0x1ff00002000, EEPROM not present, 00:03:ba:0c:06:ce, IRQ 10
[   66.456108] ata1.00: ATA-7: SAMSUNG SP1213N, TL100-30, max UDMA/100
[   66.538542] ata1.00: 234493056 sectors, multi 16: LBA48
[   66.608850] mousedev: PS/2 mouse device common for all mice
[   66.683438] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[   66.766961] rtc0: no alarms, 114 bytes nvram
[   66.823471] ata1.00: configured for UDMA/66
[   66.879054] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SP1213N  TL10 PQ: 0 ANSI: 5
[   66.988422] TCP: cubic registered
[   67.032002] NET: Registered protocol family 17
[   67.090463] Key type dns_resolver registered
[   67.146589] initlevel:7=late, 15 registered initcalls
[   67.214787] sd 0:0:0:0: [sda] 234493056 512-byte logical blocks: (120 GB/111 GiB)
[   67.314623] sd 0:0:0:0: [sda] Write Protect is off
[   67.377601] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   67.444782] registered taskstats version 1
[   67.510339] console [netcon0] enabled
[   67.558375] netconsole: network logging started
[   67.617966] rtc_cmos rtc_cmos: setting system clock to 2012-05-25 13:11:47 UTC (1337951507)
[   89.787327] BUG: soft lockup - CPU#0 stuck for 23s! [swapper:1]
[   89.865086] Modules linked in:
[   89.905086] TSTATE: 0000004480001600 TPC: 0000000000471f10 TNPC: 0000000000471f14 Y: 00000000    Not tainted
[   90.034288] TPC: <async_synchronize_cookie_domain+0x170/0x240>
[   90.110926] g0: fffff8006e341001 g1: 0000000000000000 g2: 0000000000000000 g3: 0000000000000000
[   90.225242] g4: fffff8006e054000 g5: 0000000000000000 g6: fffff8006e058000 g7: 0000000000846da0
[   90.339642] o0: 0000000000000001 o1: fffff8006e058400 o2: 0000000000471ff0 o3: 0000000000000000
[   90.454045] o4: 0000000000000000 o5: 000000000085b800 sp: fffff8006e05b371 ret_pc: 00000000004209d4
[   90.573025] RPC: <tl0_irq14+0x14/0x20>
[   90.622249] l0: 0000000000001000 l1: 0000000080001607 l2: 0000000000471fec l3: 0000000000000400
[   90.736565] l4: 0000000000000000 l5: 0000000000000000 l6: 0000000000000000 l7: 0000000000000008
[   90.850969] i0: 0000000000000004 i1: 0000000000846d70 i2: 0000000000846d80 i3: 00000000004d3a4c
[   90.965369] i4: 00000000000005c3 i5: 000000000089a000 i6: fffff8006e05b451 i7: 0000000000472014
[   91.079775] I7: <async_synchronize_full+0x14/0x40>
[   91.142711] Call Trace:
[   91.174721]  [0000000000472014] async_synchronize_full+0x14/0x40
[   91.253593]  [0000000000601134] wait_for_device_probe+0x74/0xa0
[   91.331420]  [0000000000876e30] prepare_namespace+0x44/0x198
[   91.405812]  [00000000008769a0] kernel_init+0x100/0x114
[   91.474394]  [000000000042b0d0] kernel_thread+0x30/0x60
[   91.543074]  [00000000006f71c8] rest_init+0x10/0x68

-- 
Meelis Roos (mroos@linux.ee)
