From: Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] Revert "scsi: mpt3sas: Fix secure erase premature
 termination"
Date: Sun, 15 Jan 2017 10:19:25 +0100
Message-ID: <20170115091925.GA26656@gmail.com>
References: <1484319727.2527.8.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484319727.2527.8.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org


So there's a new mpt3sas SCSI driver boot regression, introduced in this merge 
window, which made one of my servers unbootable.

The kernel, starting at upstream commit a829a8445f09, would hang thusly:

[    6.230363] Linux agpgart interface v0.103
[    6.245029] brd: module loaded
[    6.253233] loop: module loaded
[    6.256695] mpt3sas version 14.101.00.00 loaded
[    6.261890] mpt2sas_cm0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (65950628 kB)
[    6.326222] mpt2sas_cm0: MSI-X vectors supported: 1, no of cores: 32, max_msix_vectors: -1
[    6.334953] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 24
[    6.340237] mpt2sas_cm0: iomem(0x00000000dff3c000), mapped(0xffffc90007414000), size(16384)
[    6.349002] mpt2sas_cm0: ioport(0x000000000000e000), size(256)
[    6.410830] mpt2sas_cm0: sending message unit reset !!
[    6.417739] mpt2sas_cm0: message unit reset: SUCCESS
[    6.463486] mpt2sas_cm0: Allocated physical memory: size(8199 kB)
[    6.469820] mpt2sas_cm0: Current Controller Queue Depth(3640),Max Controller Queue Depth(3712)
[    6.478840] mpt2sas_cm0: Scatter Gather Elements per IO(128)
[    6.530653] mpt2sas_cm0: LSISAS2008: FWVersion(12.00.00.00), ChipRevision(0x03), BiosVersion(07.23.01.00)
[    6.540621] mpt2sas_cm0: Protocol=(
[    6.540622] Initiator
[    6.544346] ,Target
[    6.546844] ), 
[    6.549168] Capabilities=(
[    6.551165] TLR
[    6.554098] ,EEDP
[    6.556095] ,Snapshot Buffer
[    6.558249] ,Diag Trace Buffer
[    6.561359] ,Task Set Full
[    6.564666] ,NCQ
[    6.567594] )
[    6.571517] scsi host0: Fusion MPT SAS Host
[    6.576539] mpt2sas_cm0: sending port enable !!
[    6.576699] ahci 0000:00:11.0: version 3.0
[    6.577285] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    6.577290] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    6.579218] scsi host1: ahci
[    6.579685] scsi host2: ahci
[    6.5800[   39.972084] sd 0:0:0:0: attempting task abort! scmd(ffff881014cb9500)
[   39.978809] sd 0:0:0:0: [sda] tag#0 CDB: ATA command pass through(12)/Blank a1 08 2e 00 01 00 00 00 00 ec 00 00
[   39.989346] scsi target0:0:0: handle(0x0009), sas_address(0x4433221100000000), phy(0)
[   39.997584] scsi target0:0:0: enclosure_logical_id(0x5003048003e10c00), slot(31)
[   40.005425] sd 0:0:0:0: task abort: SUCCESS scmd(ffff881014cb9500)
udevd[472]: timeout 'ata_id --export /dev/sda'
udevd[472]: timeout: killing 'ata_id --export /dev/sda' [503]
udevd[472]: timeout: killing 'ata_id --export /dev/sda' [503]
udevd[472]: timeout: killing 'ata_id --export /dev/sda' [503]
udevd[472]: timeout: killing 'ata_id --export /dev/sda' [503]
udevd[472]: timeout: killing 'ata_id --export /dev/sda' [503]
udevd[472]: timeout: killing 'ata_id --export /dev/sda' [503]
udevd[472]: timeout: killing 'ata_id --export /dev/sda' [503]
udevd[472]: timeout: killing 'ata_id --export /dev/sda' [503]

[ this would continue ad infinitum. ]

The correct bootup sequence would be:

[    6.252918] loop: module loaded
[    6.256390] mpt3sas version 14.101.00.00 loaded
[    6.261554] mpt2sas_cm0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (65950628 kB)
[    6.325894] mpt2sas_cm0: MSI-X vectors supported: 1, no of cores: 32, max_msix_vectors: -1
[    6.334640] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 24
[    6.339925] mpt2sas_cm0: iomem(0x00000000dff3c000), mapped(0xffffc900073f4000), size(16384)
[    6.348672] mpt2sas_cm0: ioport(0x000000000000e000), size(256)
[    6.410508] mpt2sas_cm0: sending message unit reset !!
[    6.417437] mpt2sas_cm0: message unit reset: SUCCESS
[    6.463275] mpt2sas_cm0: Allocated physical memory: size(8199 kB)
[    6.469627] mpt2sas_cm0: Current Controller Queue Depth(3640),Max Controller Queue Depth(3712)
[    6.478635] mpt2sas_cm0: Scatter Gather Elements per IO(128)
[    6.530433] mpt2sas_cm0: LSISAS2008: FWVersion(12.00.00.00), ChipRevision(0x03), BiosVersion(07.23.01.00)
[    6.540424] mpt2sas_cm0: Protocol=(
[    6.540425] Initiator
[    6.544150] ,Target
[    6.546644] ), 
[    6.548968] Capabilities=(
[    6.550943] TLR
[    6.553901] ,EEDP
[    6.555898] ,Snapshot Buffer
[    6.558050] ,Diag Trace Buffer
[    6.561159] ,Task Set Full
[    6.564462] ,NCQ
[    6.567395] )
[    6.571316] scsi host0: Fusion MPT SAS Host
[    6.576344] mpt2sas_cm0: sending port enable !!
[    6.576495] ahci 0000:00:11.0: version 3.0
[    6.577100] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    6.577105] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    6.579016] scsi host1: ahci
[    6.579387] scsi host2: ahci
[    6.[
[32m  OK  
[0m] Started Journal Service.
...

(BTW., note the various broken printk lines - which is an unrelated bug.)

I bisected the regression back to this upstream merge commit done by Linus:

  commit a829a8445f09036404060f4d6489cb13433f4304
  Merge: 84b607913442 f5b893c94715
  Author: Linus Torvalds <torvalds@linux-foundation.org>
  Date:   Wed Dec 14 10:49:33 2016 -0800

    Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi

... which is a head-scratcher, so I double checked the key bisection points, but 
the bisection result is robust. I also re-created Linus's merge and double checked 
the conflict resolution - which looks fine as well.

After (much) more testing it turns out that the bug is some sort of combination 
bug, in that scsi-next didn't have all the SCSI fixes that upstream already had, 
in particular it didn't have these commits:

  7ff723ad0f87 scsi: mpt3sas: Unblock device after controller reset
  18f6084a989b scsi: mpt3sas: Fix secure erase premature termination
  6d3a56ed0985 scsi: mpt3sas: Fix for block device of raid exists even after deleting raid disk

When Linus pulled in scsi-next-minus-fixes these two sets of commits combined and 
produced the regression - and made the bisection lead to the merge commit.

So I manually rebased those 3 fixes on top of the scsi-next tree (f5b893c94715) 
and indeed one of them broke my box:

  18f6084a989b scsi: mpt3sas: Fix secure erase premature termination

I reverted it from latest upstream (with a minor conflict resolution), and that 
makes my box boot fine again. I have no idea which scsi-next commit this change 
interacted with, and it's not easy to find out so I'm not volunteering! It must be 
one of these 256 commits:

   e3a00f68e426..f5b893c94715

Note that reverting the first commit alone does not help:

  7ff723ad0f87 scsi: mpt3sas: Unblock device after controller reset

So it's reverting 18f6084a989b (while keeping ata_12_16_cmd() around to enable the 
7ff723ad0f87 fix) that does the trick.

Thanks,

	Ingo

====================>
>From 0734e6d2a7f757172d6b7750d8fcf602909300e6 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@kernel.org>
Date: Sun, 15 Jan 2017 09:59:39 +0100
Subject: [PATCH] Revert "scsi: mpt3sas: Fix secure erase premature termination"

This reverts commit 18f6084a989ba1b38702f9af37a2e4049a924be6.

 Conflicts:
	drivers/scsi/mpt3sas/mpt3sas_scsih.c

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b5c966e319d3..3573daa2cce8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4063,13 +4063,6 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	if (ioc->logging_level & MPT_DEBUG_SCSI)
 		scsi_print_command(scmd);
 
-	/*
-	 * Lock the device for any subsequent command until command is
-	 * done.
-	 */
-	if (ata_12_16_cmd(scmd))
-		scsi_internal_device_block(scmd->device);
-
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
@@ -4650,9 +4643,6 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	if (scmd == NULL)
 		return 1;
 
-	if (ata_12_16_cmd(scmd))
-		scsi_internal_device_unblock(scmd->device, SDEV_RUNNING);
-
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 
 	if (mpi_reply == NULL) {
