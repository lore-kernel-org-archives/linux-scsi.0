From: David Miller <davem@davemloft.net>
Subject: Bootup regression from srp_transport queuecommand() change...
Date: Wed, 28 Dec 2016 15:27:00 -0500 (EST)
Message-ID: <20161228.152700.56383949697289644.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: bart.vanassche@sandisk.com
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org


Commit 669f044170d8933c3d66d231b69ea97cb8447338 ("scsi: srp_transport:
Move queuecommand() wait code to SCSI core") causes my sparc64 T4-2
machine to stop booting properly.

It gets past mounting root but then the disk seems to wedge and scsi
command resets don't seem to improve the situation.

The controller on this machine is an mpt2sas:

[  988.085192] mpt3sas version 14.101.00.00 loaded
[  988.094440] mpt2sas_cm0: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (265775888 kB)
[  988.165492] mpt2sas_cm0: MSI-X vectors supported: 1, no of cores: 128, max_msix_vectors: -1
[  988.182124] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 166
[  988.192152] mpt2sas_cm0: iomem(0x0000084001200000), mapped(0x0000084001200000), size(16384)
[  988.208816] mpt2sas_cm0: ioport(0x0000085100002000), size(256)
[  988.305669] mpt2sas_cm0: Allocated physical memory: size(2324 kB)
[  988.317563] mpt2sas_cm0: Current Controller Queue Depth(1529),Max Controller Queue Depth(1600)
[  988.334753] mpt2sas_cm0: Scatter Gather Elements per IO(128)
[  988.396240] mpt2sas_cm0: LSISAS2008: FWVersion(09.00.00.00), ChipRevision(0x03), BiosVersion(00.00.00.00)
[  988.415087] mpt2sas_cm0: Protocol=(
[  988.415089] Initiator
[  988.422032] ,Target
[  988.426532] ), 
[  988.430707] Capabilities=(
[  988.434167] Raid
[  988.439558] ,TLR
[  988.443212] ,EEDP
[  988.446853] ,Snapshot Buffer
[  988.450676] ,Diag Trace Buffer
[  988.456409] ,Task Set Full
[  988.462487] ,NCQ
[  988.467874] )
[  988.474803] scsi host0: Fusion MPT SAS Host
[  988.484310] mpt2sas_cm0: sending port enable !!
[  990.014651] mpt2sas_cm0: host_add: handle(0x0001), sas_addr(0x5080020000f7b908), phys(8)
[  996.139132] mpt2sas_cm0: port enable: SUCCESS
[  996.170653] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSC2CW48 400i PQ: 0 ANSI: 5
[  996.186607] scsi 0:0:0:0: SATA: handle(0x0009), sas_addr(0x4433221100000000), phy(0), device_name(0x517b5001f9f6b27f)
[  996.207728] scsi 0:0:0:0: SATA: enclosure_logical_id(0x5080020000f7b908), slot(0)
[  996.222818] scsi 0:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[  996.344371] scsi 0:0:1:0: CD-ROM            TEAC     DV-W28SS-R       1.0C PQ: 0 ANSI: 0
[  996.360272] scsi 0:0:1:0: SATA: handle(0x000a), sas_addr(0x4433221107000000), phy(7), device_name(0x0000000000000000)
[  996.381442] scsi 0:0:1:0: SATA: enclosure_logical_id(0x5080020000f7b908), slot(7)

It was not easy to track this down.

Initial bisect hit the scsi-misc merge itself, bisecting within the
merge doesn't find the commit mentioned above.

So I went throught the commits in the scsi-misc merge one by one,
adding them on top of vanilla v4.9 until I hit the problem.

This means the above commit doesn't introduce the regression in the
context in which it was made.

The commit message mentions blockability.  So I tried to look at
mpt3sas driver changes that happened in mainline meanwhile.  And
I came upon commit 18f6084a989ba1b38702f9af37a2e4049a924be6
("scsi: mpt3sas: Fix secure erase premature termination")

And this, indeed, adds a new call to scsi_internal_device_block()
inside of the queuecommand() method of the mpt3sas driver.

This seems to invalidate the analysis done in the commit message of
669f044170d8933c3d66d231b69ea97cb8447338 ("scsi: srp_transport: Move
queuecommand() wait code to SCSI core").

I guess some userland information gathering tool, udev, or similar is
doing the passthru ATA command to the devices behind my mpt2sas host,
triggering the logic there to call scsi_internal_device_block().

I'm happy to test any changes, and would really like to see this bug
fixed.

Thanks!
