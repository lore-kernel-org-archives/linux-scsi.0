From: Nathan Shearer <mail@nathanshearer.ca>
Subject: Hot Swap Problems with LSI HBA and LSI Backplane -- reproducable
 and very frustrating
Date: Wed, 18 Sep 2013 16:06:11 -0600
Message-ID: <523A23D3.6030608@nathanshearer.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from whm02.asteroidpc.com ([207.228.103.87]:48214 "EHLO
	nathanshearer.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751670Ab3IRXH4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Sep 2013 19:07:56 -0400
Received: from home.nathanshearer.ca ([207.228.103.143]:47664 helo=[10.64.0.10])
	by whm02.asteroidpc.com with esmtpsa (TLSv1:DHE-RSA-CAMELLIA256-SHA:256)
	(Exim 4.80.1)
	(envelope-from <mail@nathanshearer.ca>)
	id 1VMPt0-0004Mg-EO
	for linux-scsi@vger.kernel.org; Wed, 18 Sep 2013 16:06:14 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

I'm having problems with two systems where hot-swapping sata drives 
results in their bay being permanently disabled until I cold boot the 
system. My hardware configuration is fairly straight forward:

Host Bus Adapter: LSI SAS9207-8i  (contains the LSISAS2308)
Case: Supermicro SuperChassis 826E2-R800LPB (contains the BPN-SAS-826EL2 
backplane)
Backplane: Supermicro BPN-SAS-826EL2 (contains two LSISASx28 SAS Expanders)
Hard Drives: Western Digital WD3000BLFS-01YBU4, Western Digital 
WD20EARS, Seagate ST3000DM001, Seagate ST4000DM000 (I have many other 
types and sizes to test with)

Some links to technical information that might be relevant:
LSI SAS9207-8i Host Bus 
Adapterhttp://www.lsi.com/products/storagecomponents/Pages/LSISAS9207-8i.aspx#two
LSISAS2308 
http://www.lsi.com/products/storagecomponents/Pages/LSISAS2308.aspx
Supermicro SuperChassis 826E2-R800LPB 
http://www.supermicro.com/products/chassis/2u/826/sc826e2-r800lp.cfm
LSISASx28 SAS Expander 
http://www.lsi.com/products/storagecomponents/Pages/LSISASx28.aspx

Problem in detail
Ultimately I will be booting from a software RAID1 from the 12 drives in 
this system. During my testing I discovered this problem and I have been 
booting from a Gentoo USB drive so I can test all 12 SAS bays (labeled 
SAS0 through SAS11 on the backplane). If I boot the system from the USB 
drive, then insert a Western Digital WD3000BLFS-01YBU4 into SAS0, the 
drive spins up and is detected. Everything works as expected. I can pull 
the drive, mpt2sas removes the handle and I can repeate the process with 
the other SAS1 through SAS11 bays. Repeating the process with a Western 
Digital WD20EARS has the same results. All 12 bays work. Repeating with 
a Seagate ST4000DM000 and I find that some bays do not spin up the 
drive. When this happens that bay is dead and I can even use the 
previously working Western Digital WD3000BLFS-01YBU4 in it. The only 
thing that gets the bays working again is a cold boot after powering off 
the system and actually unplugging it for an extended period (>5 minutes).

While doing this testing I did see some strange errors in the kernel 
logs, but only after switching my HBA out for a Supermicro AOC-USAS2-L8i 
(which contains the LSISAS2008 and uses the same mpt2sas driver):
Testing SAS8 with ST4000DM000 worked (but there were strange kernel errors):
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.322489] scsi 
6:0:35:0: Direct-Access     ATA      ST4000DM000-1F21 CC51 PQ: 0 ANSI: 5
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.322499] scsi 
6:0:35:0: SATA: handle(0x000b), sas_addr(0x500304800105a94c), phy(12), 
device_name(0xc500500017534f84)
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.322503] scsi 
6:0:35:0: SATA: enclosure_logical_id(0x50030442523a2033), slot(8)
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.322572] scsi 
6:0:35:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.322575] scsi 
6:0:35:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), 
cmd_que(1)
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.322762] sd 6:0:35:0: 
Attached scsi generic sg2 type 0
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.323340] sd 6:0:35:0: 
[sdb] physical block alignment offset: 4096
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.323345] sd 6:0:35:0: 
[sdb] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.323347] sd 6:0:35:0: 
[sdb] 4096-byte physical blocks
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.400933] sd 6:0:35:0: 
[sdb] Write Protect is off
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.400938] sd 6:0:35:0: 
[sdb] Mode Sense: 73 00 00 08
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.401764] sd 6:0:35:0: 
[sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.524835]  sdb: sdb1 
sdb2 sdb3
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.527592] AMD-Vi: 
Event logged [IO_PAGE_FAULT device=41:00.0 domain=0x0014 
address=0x0000000010000000 flags=0x0020]
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.527598] AMD-Vi: 
Event logged [IO_PAGE_FAULT device=41:00.0 domain=0x0014 
address=0x0000000010000040 flags=0x0020]
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.527601] AMD-Vi: 
Event logged [IO_PAGE_FAULT device=41:00.0 domain=0x0014 
address=0x0000000010000010 flags=0x0020]
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.527609] AMD-Vi: 
Event logged [IO_PAGE_FAULT device=41:00.0 domain=0x0014 
address=0x0000000010000020 flags=0x0020]
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.613861] sd 6:0:35:0: 
[sdb] Attached SCSI disk
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.739109] md: bind<sdb2>
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.742970] md: bind<sdb3>
     Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.746619] md: bind<sdb1>
Removed ST4000DM000 from SAS8 and inserted it into SAS6:
     Sep 17 22:23:49 gentoo-live-usb kernel: [ 1563.287575] mpt2sas0: 
removing handle(0x000b), sas_addr(0x500304800105a94c)
     Sep 17 22:24:16 gentoo-live-usb kernel: [ 1590.287517] mpt2sas0: 
device is not present handle(0x000b), no sas_device!!!
     Sep 17 22:24:26 gentoo-live-usb kernel: [ 1601.035876] mpt2sas0: 
removing handle(0x000a), sas_addr(0x500304800105a97d)
     Sep 17 22:24:26 gentoo-live-usb kernel: [ 1601.037113] mpt2sas0: 
expander_remove: handle(0x0009), sas_addr(0x500304800105a97f
Removed ST4000DM000 from SAS6 and inserted into SAS8 failed. No activity 
in /var/log/messages. Drive does not spin up.
Removed ST4000DM000 from SAS8 and inserted into SAS6 failed. No activity 
in /var/log/messages. Drive does not spin up.

The "device is not present" "no sas_device!!!" is interesting. What does 
it mean because there certainly is a drive in that SAS bay. I googled 
AMD-Vi and it seems related to IOMMU so i disabled that in the BIOS. I'm 
not doing PCI passthrough on this system but I did plan to use it as a 
Xen/KVM host later on. Disabling the IOMMU feature in the BIOS did 
suppress the AMD-Vi page fault, but I wonder if things are still broken 
somewhere and that is triggering other problems alter on which causes my 
SAS bays to get disabled untill I drain the power from the system.

Any help would be greatly appreciated.
