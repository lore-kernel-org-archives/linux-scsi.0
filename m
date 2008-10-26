From: Tejun Heo <tj@kernel.org>
Subject: Timeout regression introduced by 242f9dcb8ba6f68fcd217a119a7648a4f69290e9
Date: Sun, 26 Oct 2008 18:46:36 +0900
Message-ID: <49043C7C.8050207@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050509070309050203010408"
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050509070309050203010408
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello, Jens.

Commit 242f9dcb8ba6f68fcd217a119a7648a4f69290e9 introduces a strange
regression for libata.  The second timeout gives puts different
pointer from the issued command onto eh_cmd_q breaking libata EH
command matching which triggers WARN_ON() in ata_eh_finish() and hangs
command processing or causes oops later depending on circumstances.

Here are logs with induced timeouts (patch attached).  In commit
242f9dcb8, the XXX messages for the second timeout shows different
scsi_cmd pointers for eh_cmd_q and qc->scmd which is initialized by
ata_scsi_qc_new() during command translation.

COMMIT 608aeef17a91747d6303de4df5e2c2e6899a95e8

[   60.878067] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   60.892956] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   60.906557] scsi0 : ata_piix
[   60.920296] scsi1 : ata_piix
[   60.935038] ata1: SATA max UDMA/133 cmd 0xa000 ctl 0x9c00 bmdma 0x9480 irq 19
[   60.949498] ata2: SATA max UDMA/133 cmd 0x9880 ctl 0x9800 bmdma 0x9488 irq 19
[   60.963803] ata1: XXX eh_cmd_q:
[   60.967773] ata1: XXX qc0: cmd=0 flags=00000000 scmd=0000000000000000
[   61.314020] ata1: SATA link down (SStatus 0 SControl 300)
[   61.326661] ata2: XXX eh_cmd_q:
[   61.330362] ata2: XXX qc0: cmd=0 flags=00000000 scmd=0000000000000000
[   61.835369] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   61.860329] ata2.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, max UDMA/133
[   61.874173] ata2.00: 293046768 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   61.904307] ata2.00: configured for UDMA/133
[   61.931835] scsi 1:0:0:0: Direct-Access     ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5
[   61.954781] sd 1:0:0:0: [sda] 293046768 512-byte hardware sectors (150040 MB)
[   61.974311] sd 1:0:0:0: [sda] Write Protect is off
[   61.986953] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   62.004210] sd 1:0:0:0: [sda] 293046768 512-byte hardware sectors (150040 MB)
[   62.018928] sd 1:0:0:0: [sda] Write Protect is off
[   62.031649] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   62.048168]  sda: unknown partition table
[   62.067140] sd 1:0:0:0: [sda] Attached SCSI disk
[   62.084652] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   69.731222] ata2.00: XXX skipping completion
[  129.726468] ata2: XXX eh_cmd_q: ffff88003df1a450
[  129.730425] ata2: XXX qc0: cmd=ca flags=0000000b scmd=ffff88003df1a450
[  129.752854] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  129.767447] ata2.00: cmd ca/00:20:00:00:00/00:00:00:00:00/e0 tag 0 dma 16384 out
[  129.767448]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  129.797623] ata2.00: status: { DRDY }
[  129.797634] ata2: hard resetting link
[  130.286510] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  130.331427] ata2.00: configured for UDMA/133
[  130.343836] ata2: EH complete
[  130.354794] ata2.00: XXX skipping completion
[  190.361697] ata2: XXX eh_cmd_q: ffff88003df1a450
[  190.365662] ata2: XXX qc0: cmd=ca flags=0000000b scmd=ffff88003df1a450
[  190.389080] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  190.404280] ata2.00: cmd ca/00:20:00:00:00/00:00:00:00:00/e0 tag 0 dma 16384 out
[  190.404281]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  190.435828] ata2.00: status: { DRDY }
[  190.447786] ata2: hard resetting link
[  190.933748] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  190.978649] ata2.00: configured for UDMA/133
[  190.991373] ata2: EH complete
[  191.002663] ata2.00: XXX skipping completion

COMMIT 242f9dcb8ba6f68fcd217a119a7648a4f69290e9

[  107.180869] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  107.195909] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[  107.209595] scsi0 : ata_piix
[  107.220667] scsi1 : ata_piix
[  107.237009] ata1: SATA max UDMA/133 cmd 0xa000 ctl 0x9c00 bmdma 0x9480 irq 19
[  107.251375] ata2: SATA max UDMA/133 cmd 0x9880 ctl 0x9800 bmdma 0x9488 irq 19
[  107.265641] ata1: XXX eh_cmd_q:
[  107.269613] ata1: XXX qc0: cmd=0 flags=00000000 scmd=0000000000000000
[  107.617455] ata1: SATA link down (SStatus 0 SControl 300)
[  107.630171] ata2: XXX eh_cmd_q:
[  107.634166] ata2: XXX qc0: cmd=0 flags=00000000 scmd=0000000000000000
[  108.126787] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  108.147729] ata2.00: ATA-7: WDC WD1500ADFD-00NLR1, 20.07P20, max UDMA/133
[  108.161843] ata2.00: 293046768 sectors, multi 16: LBA48 NCQ (depth 0/32)
[  108.191731] ata2.00: configured for UDMA/133
[  108.219236] scsi 1:0:0:0: Direct-Access     ATA      WDC WD1500ADFD-0 20.0 PQ: 0 ANSI: 5
[  108.237140] sd 1:0:0:0: [sda] 293046768 512-byte hardware sectors (150040 MB)
[  108.253474] sd 1:0:0:0: [sda] Write Protect is off
[  108.267280] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  108.284851] sd 1:0:0:0: [sda] 293046768 512-byte hardware sectors (150040 MB)
[  108.299687] sd 1:0:0:0: [sda] Write Protect is off
[  108.312502] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  108.329320]  sda: unknown partition table
[  108.348303] sd 1:0:0:0: [sda] Attached SCSI disk
[  108.361898] sd 1:0:0:0: Attached scsi generic sg0 type 0
[  116.468909] ata2.00: XXX skipping completion
[  176.589876] ata2: XXX eh_cmd_q: ffff88003bd67cb8
[  176.593827] ata2: XXX qc0: cmd=ca flags=0000000b scmd=ffff88003bd67cb8
[  176.616842] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  176.631953] ata2.00: cmd ca/00:20:00:00:00/00:00:00:00:00/e0 tag 0 dma 16384 out
[  176.631954]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  176.662845] ata2.00: status: { DRDY }
[  176.674218] ata2: hard resetting link
[  177.157912] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  177.194824] ata2.00: configured for UDMA/133
[  177.206926] ata2: EH complete
[  177.218269] ata2.00: XXX skipping completion
[  207.637488] ata2: XXX eh_cmd_q: ffff88003bd679b8
[  207.641444] ata2: XXX qc0: cmd=ca flags=0000000b scmd=ffff88003bd67cb8
[  207.664891] ------------[ cut here ]------------
[  207.677609] WARNING: at drivers/ata/libata-eh.c:2944 ata_eh_finish+0xd2/0xe0 [libata]()
[  207.694344] Modules linked in: ata_piix libata
[  207.694350] Pid: 3974, comm: scsi_eh_1 Not tainted 2.6.27-rc9-work #562
[  207.694352] 
[  207.694352] Call Trace:
[  207.694360]  [<ffffffff802388bf>] warn_on_slowpath+0x5f/0x90
[  207.694374]  [<ffffffffa00142a0>] ? ata_sff_softreset+0x0/0x170 [libata]
[  207.694382]  [<ffffffffa000e5e8>] ? ata_eh_link_autopsy+0x118/0x870 [libata]
[  207.694391]  [<ffffffffa0002d90>] ? sata_std_hardreset+0x0/0x40 [libata]
[  207.694398]  [<ffffffffa000f15d>] ? ata_eh_recover+0x21d/0xcd0 [libata]
[  207.694406]  [<ffffffffa00120f0>] ? ata_sff_postreset+0x0/0x80 [libata]
[  207.694414]  [<ffffffffa0002d90>] ? sata_std_hardreset+0x0/0x40 [libata]
[  207.694421]  [<ffffffffa00142a0>] ? ata_sff_softreset+0x0/0x170 [libata]
[  207.694429]  [<ffffffffa0014410>] ? ata_sff_prereset+0x0/0xc0 [libata]
[  207.694437]  [<ffffffffa000fdc2>] ata_eh_finish+0xd2/0xe0 [libata]
[  207.694444]  [<ffffffffa0002d90>] ? sata_std_hardreset+0x0/0x40 [libata]
[  207.694451]  [<ffffffffa0002d90>] ? sata_std_hardreset+0x0/0x40 [libata]
[  207.694459]  [<ffffffffa00142a0>] ? ata_sff_softreset+0x0/0x170 [libata]
[  207.694467]  [<ffffffffa000fe7d>] ata_do_eh+0xad/0xc0 [libata]
[  207.694474]  [<ffffffffa0002d90>] ? sata_std_hardreset+0x0/0x40 [libata]
[  207.694481]  [<ffffffffa00142a0>] ? ata_sff_softreset+0x0/0x170 [libata]
[  207.694489]  [<ffffffffa0011fba>] ata_sff_error_handler+0xea/0x220 [libata]
[  207.694497]  [<ffffffffa0010873>] ata_scsi_error+0x2b3/0x870 [libata]
[  207.694501]  [<ffffffff8052d89f>] scsi_error_handler+0x12f/0x5d0
[  207.694505]  [<ffffffff80724cf2>] ? _spin_unlock_irqrestore+0x42/0x80
[  207.694507]  [<ffffffff8052d770>] ? scsi_error_handler+0x0/0x5d0
[  207.694510]  [<ffffffff802504a9>] kthread+0x49/0x90
[  207.694513]  [<ffffffff8020d529>] child_rip+0xa/0x11
[  207.694515]  [<ffffffff8020cb33>] ? restore_args+0x0/0x30
[  207.694517]  [<ffffffff80250460>] ? kthread+0x0/0x90
[  207.694519]  [<ffffffff8020d51f>] ? child_rip+0x0/0x11
[  207.694520] 
[  207.694522] ---[ end trace 27f6013c0d17023b ]---
[  207.694596] sd 1:0:0:0: [sda] 293046768 512-byte hardware sectors (150040 MB)
[  207.694621] sd 1:0:0:0: [sda] Write Protect is off
[  207.694663] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

-- 
tejun

--------------050509070309050203010408
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYXRhL2xpYmF0YS1jb3JlLmMgYi9kcml2ZXJzL2F0YS9s
aWJhdGEtY29yZS5jCmluZGV4IDc5ZTNhOGUuLjI0MTc5YjggMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvYXRhL2xpYmF0YS1jb3JlLmMKKysrIGIvZHJpdmVycy9hdGEvbGliYXRhLWNvcmUuYwpA
QCAtNDY0Miw2ICs0NjQyLDEzIEBAIHZvaWQgYXRhX3FjX2NvbXBsZXRlKHN0cnVjdCBhdGFf
cXVldWVkX2NtZCAqcWMpCiB7CiAJc3RydWN0IGF0YV9wb3J0ICphcCA9IHFjLT5hcDsKIAor
CWlmIChxYy0+dGYuY29tbWFuZCA9PSBBVEFfQ01EX0ZQRE1BX1dSSVRFIHx8CisJICAgIHFj
LT50Zi5jb21tYW5kID09IEFUQV9DTURfV1JJVEUgfHwKKwkgICAgcWMtPnRmLmNvbW1hbmQg
PT0gQVRBX0NNRF9XUklURV9FWFQpIHsKKwkJYXRhX2Rldl9wcmludGsocWMtPmRldiwgS0VS
Tl9JTkZPLCAiWFhYIHNraXBwaW5nIGNvbXBsZXRpb25cbiIpOworCQlyZXR1cm47CisJfQor
CiAJLyogWFhYOiBOZXcgRUggYW5kIG9sZCBFSCB1c2UgZGlmZmVyZW50IG1lY2hhbmlzbXMg
dG8KIAkgKiBzeW5jaHJvbml6ZSBFSCB3aXRoIHJlZ3VsYXIgZXhlY3V0aW9uIHBhdGguCiAJ
ICoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvYXRhL2xpYmF0YS1laC5jIGIvZHJpdmVycy9hdGEv
bGliYXRhLWVoLmMKaW5kZXggYzFkYjJmMi4uNjE3YzE4OCAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9hdGEvbGliYXRhLWVoLmMKKysrIGIvZHJpdmVycy9hdGEvbGliYXRhLWVoLmMKQEAgLTUz
MSw2ICs1MzEsMTkgQEAgdm9pZCBhdGFfc2NzaV9lcnJvcihzdHJ1Y3QgU2NzaV9Ib3N0ICpo
b3N0KQogCiAJCXNwaW5fbG9ja19pcnFzYXZlKGFwLT5sb2NrLCBmbGFncyk7CiAKKwkJewor
CQkJc3RydWN0IGF0YV9xdWV1ZWRfY21kICpxYzsKKworCQkJYXRhX3BvcnRfcHJpbnRrKGFw
LCBLRVJOX0lORk8sICJYWFggZWhfY21kX3E6Iik7CisJCQlsaXN0X2Zvcl9lYWNoX2VudHJ5
KHNjbWQsICZob3N0LT5laF9jbWRfcSwgZWhfZW50cnkpCisJCQkJcHJpbnRrKCIgJXAiLCBz
Y21kKTsKKwkJCXByaW50aygiXG4iKTsKKworCQkJcWMgPSBfX2F0YV9xY19mcm9tX3RhZyhh
cCwgMCk7CisJCQlhdGFfcG9ydF9wcmludGsoYXAsIEtFUk5fSU5GTywgIlhYWCBxYyVkOiBj
bWQ9JXggZmxhZ3M9JTA4bHggc2NtZD0lcFxuIiwKKwkJCQkJcWMtPnRhZywgcWMtPnRmLmNv
bW1hbmQsIHFjLT5mbGFncywgcWMtPnNjc2ljbWQpOworCQl9CisKIAkJbGlzdF9mb3JfZWFj
aF9lbnRyeV9zYWZlKHNjbWQsIHRtcCwgJmhvc3QtPmVoX2NtZF9xLCBlaF9lbnRyeSkgewog
CQkJc3RydWN0IGF0YV9xdWV1ZWRfY21kICpxYzsKIAo=
--------------050509070309050203010408--
