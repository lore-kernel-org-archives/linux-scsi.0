From: Catalin Muresan <catalin.muresan@astral.ro>
Subject: Re: Apple Xserve RAID and qlogic ISP2312 (qla2300)
Date: Thu, 28 Oct 2004 18:35:22 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041028153522.GC1915@astral.ro>
References: <20041027233321.GA842@astral.ro> <20041028143734.GA16358@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dummy.cluj.astral.ro ([193.230.240.25]:1668 "EHLO cnn.astral.ro")
	by vger.kernel.org with ESMTP id S261732AbUJ1PlY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2004 11:41:24 -0400
Content-Disposition: inline
In-Reply-To: <20041028143734.GA16358@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, bogdan.luca@astral.ro


	Hi,

On Thu, Oct 28, 2004 at 07:37:34AM -0700, Patrick Mansfield wrote:
 > On Thu, Oct 28, 2004 at 02:33:21AM +0300, Catalin Muresan wrote:
 > > 
 > > 	Hi,
 > > 
 > > 	I have the hardware from the subject, the problem i have is that the
 > > scsi layer doesn't see any luns i made on the raid except LUN 0. here is an
 > > example:
 > 
 > LUN 0 didn't show up according to your log output and comments below.

	the storage performs LUN masking so there's only LUN 5 available on
ID 0.

 > > [root@zerg-b root]# cd /proc/scsi/qla2xxx/  
 > > [root@zerg-b qla2xxx]# cat 0
 > > QLogic PCI to Fibre Channel Host Adapter for IBM HS20:
 > >         Firmware version 3.02.30 IPX, Driver version 8.00.00b15-k
 > 
 > > SCSI Device Information:
 > > scsi-qla0-adapter-node=2000000d60d367e0;
 > > scsi-qla0-adapter-port=2100000d60d367e0;
 > > scsi-qla0-target-0=60003930000026b4;
 > > 
 > > SCSI LUN Information:
 > > (Id:Lun)  * - indicates lun is not registered with the OS.
 > > ( 0: 5): Total reqs 0, Pending reqs 0, flags 0x0*, 0:0:83 00
 > 
 > The adapter seems to think there is a target and lun 0.

	the adapter sees id 0 lun 5 ( 0: 5) because it blindly scans every lun

 > Did anything show up on host 1?

	host 1 is not connected to the FC fabric because i have only 1 FC
switch module installed, that's why i didn't include that info - short no.

 > > 	you can see that the driver has found the 5th LUN but scsi_scan
 > > doesn't se it when scanning, scsi_probe_and_add_lun for LUN 0 returns
 > > SCSI_SCAN_NO_RESPONSE instead of SCSI_SCAN_TARGET_PRESENT. I have added
 > > {"APPLE", "Xserve RAID", NULL, BLIST_SPARSELUN}, in scsi_devinfo.c so
 > > scsi_scan will try and perform a sparse scan on the LUNs but that doesn't
 > > help because scanning LUN 0 fails.
 > 
 > Yep.
 > 
 > > Oct 28 01:59:37 zerg-b kernel: scsi_scan_host_selected: <0:4294967295:4294967295:4294967295>
 > > Oct 28 01:59:37 zerg-b kernel: scsi scan: INQUIRY to host 0 channel 0 id 0 lun 0
 > > Oct 28 01:59:37 zerg-b kernel: scsi scan: 1st INQUIRY failed with code 0x10000
 > 
 > The 0x10000 is a DID_NO_CONNECT, generally the adapter can't talk to
 > the target at all.

	I don't know what the SCSI spec has to say about this, but by
looking at the code it should respond with SCSI_SCAN_TARGET_PRESENT.

 > It seem like the storage was seen, then went away and then came back.

	no, it's just that the storage or the controller don't report
anything for masked luns. It looks more and more a storage problem, I'm
gonna try and bug Apple about this. What does the SCSI spec says about this?

 > Do you always get the same behaviour?

	yes.

 > Are there other messages in your log? Just post the entire log without
 > the scsi logging on, from adapter load time to scan completion.

	ok but is like there's no devices attached (it's an older log
because i've rebooted with another kernel that scans every lun on every
target, thus finding the storage)

Oct 27 22:23:22 zerg-b kernel: QLogic Fibre Channel HBA Driver (c02ad498)
Oct 27 22:23:22 zerg-b kernel: ACPI: PCI interrupt 0000:02:02.0[A] -> GSI 18 (level, low) -> IRQ 177
Oct 27 22:23:22 zerg-b kernel: qla2300 0000:02:02.0: Found an ISP2312, irq 177, iobase 0xf8802000
Oct 27 22:23:22 zerg-b kernel: qla2300 0000:02:02.0: Configuring PCI space...
Oct 27 22:23:22 zerg-b kernel: qla2300 0000:02:02.0: Configure NVRAM parameters...
Oct 27 22:23:22 zerg-b kernel: qla2300 0000:02:02.0: Verifying loaded RISC code...
Oct 27 22:23:22 zerg-b kernel: qla2300 0000:02:02.0: Waiting for LIP to complete...
Oct 27 22:23:22 zerg-b kernel: qla2300 0000:02:02.0: LOOP UP detected (2 Gbps).
Oct 27 22:23:22 zerg-b kernel: qla2300 0000:02:02.0: Topology - (F_Port), Host Loop address 0xffff
Oct 27 22:23:22 zerg-b kernel: scsi0 : qla2xxx
Oct 27 22:23:22 zerg-b kernel: qla2300 0000:02:02.0: 
Oct 27 22:23:22 zerg-b kernel:  QLogic Fibre Channel HBA Driver: 8.00.00b15-k
Oct 27 22:23:22 zerg-b kernel:   QLogic IBM HS20 - 
Oct 27 22:23:22 zerg-b kernel:   ISP2312: PCI-X (133 MHz) @ 0000:02:02.0 hdma-, host#=0, fw=3.02.30 IPX
Oct 27 22:23:22 zerg-b kernel: ACPI: PCI interrupt 0000:02:02.1[B] -> GSI 19 (level, low) -> IRQ 185
Oct 27 22:23:22 zerg-b kernel: qla2300 0000:02:02.1: Found an ISP2312, irq 185, iobase 0xf8808000
Oct 27 22:23:22 zerg-b kernel: qla2300 0000:02:02.1: Configuring PCI space...
Oct 27 22:23:22 zerg-b kernel: qla2300 0000:02:02.1: Configure NVRAM parameters...
Oct 27 22:23:22 zerg-b kernel: qla2300 0000:02:02.1: Verifying loaded RISC code...
Oct 27 22:23:22 zerg-b kernel: qla2300 0000:02:02.1: Waiting for LIP to complete...
Oct 27 22:23:22 zerg-b kernel: qla2300 0000:02:02.1: Cable is unplugged...
Oct 27 22:23:22 zerg-b kernel: scsi1 : qla2xxx
Oct 27 22:23:22 zerg-b kernel: qla2300 0000:02:02.1: 
Oct 27 22:23:22 zerg-b kernel:  QLogic Fibre Channel HBA Driver: 8.00.00b15-k
Oct 27 22:23:22 zerg-b kernel:   QLogic IBM HS20 - 
Oct 27 22:23:22 zerg-b kernel:   ISP2312: PCI-X (133 MHz) @ 0000:02:02.1 hdma-, host#=1, fw=3.02.30 IPX
Oct 27 22:23:22 zerg-b kernel: ACPI: PCI interrupt 0000:00:0f.2[A] -> GSI 7 (level, low) -> IRQ 7

 > > 	storage is APPLE Xserve RAID, latest firmware with lun masking activated, for this node
 > > the 5th LUN is allowed. using add-single-device does the trick but i need a
 > > kernel to boot from FC. here is the output after 
 > 
 > > # echo "scsi add-single-device 0 0 0 5" > /proc/scsi/scsi
 > 
 > You can also use:
 > 
 > 	echo "- - -" > /sys/class/scsi_host/host0/scan

	my goal is to have a kernel with which I can boot from FC, but i see
that can be done only with an ugly patch(for now) or with tricks from
initrd.

 > -- Patrick Mansfield

-- 
Kat
