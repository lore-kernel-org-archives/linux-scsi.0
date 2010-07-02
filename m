From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC 1/2] block: implement an unprep function corresponding directly to prep
Date: Fri, 2 Jul 2010 13:03:44 +0200
Message-ID: <20100702110343.GA27159@lst.de>
References: <1277917264.2839.153.camel@mulgrave.site> <20100701104653O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:33171 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab0GBLED (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jul 2010 07:04:03 -0400
Content-Disposition: inline
In-Reply-To: <20100701104653O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, snitzer@redhat.com, hch@lst.de, axboe@kernel.dk, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Thu, Jul 01, 2010 at 10:47:12AM +0900, FUJITA Tomonori wrote:
> I think so. If I can figure out why qemu scsi driver is broken, the
> job is done.

Well, I still have problems even with libata + a trim capable SSD.
Dmesg from the last attept with your patch to use FS requests all the
way:

[   27.669404] ata2.00: exception Emask 0x10 SAct 0x1 SErr 0x400100 action 0x6 frozen
[   27.669533] ata2.00: irq_stat 0x08000000, interface fatal error
[   27.669627] ata2: SError: { UnrecovData Handshk }
[   27.669720] ata2.00: failed command: WRITE FPDMA QUEUED
[   27.669819] ata2.00: cmd 61/ff:00:00:00:00/ff:00:00:00:00/40 tag 0 ncq 33553920 out
[   27.669821]          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
[   27.670096] ata2.00: status: { DRDY }
[   27.670196] ata2: hard resetting link
[   27.975118] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   27.978618] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   27.978628] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   27.978756] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   27.984299] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   27.984309] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   27.984437] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   27.984814] ata2.00: configured for UDMA/133
[   27.987548] ata2.00: configured for UDMA/133
[   27.987645] ata2: EH complete
[   27.987784] ata2.00: exception Emask 0x10 SAct 0x1 SErr 0x400100 action 0x6 frozen
[   27.987915] ata2.00: irq_stat 0x08000000, interface fatal error
[   27.988026] ata2: SError: { UnrecovData Handshk }
[   27.988128] ata2.00: failed command: WRITE FPDMA QUEUED
[   27.988234] ata2.00: cmd 61/ff:00:00:00:00/ff:00:00:00:00/40 tag 0 ncq 33553920 out
[   27.988236]          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
[   27.988499] ata2.00: status: { DRDY }
[   27.988591] ata2: hard resetting link
[   28.293109] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   28.297509] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   28.297518] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   28.297648] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   28.301854] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   28.301863] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   28.301991] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   28.302378] ata2.00: configured for UDMA/133
[   28.305024] ata2.00: configured for UDMA/133
[   28.305123] ata2: EH complete
[   28.305292] ata2.00: exception Emask 0x10 SAct 0x1 SErr 0x400100 action 0x6 frozen
[   28.305421] ata2.00: irq_stat 0x08000000, interface fatal error
[   28.305513] ata2: SError: { UnrecovData Handshk }
[   28.305605] ata2.00: failed command: WRITE FPDMA QUEUED
[   28.305703] ata2.00: cmd 61/ff:00:00:00:00/ff:00:00:00:00/40 tag 0 ncq 33553920 out
[   28.305705]          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
[   28.305948] ata2.00: status: { DRDY }
[   28.306066] ata2: hard resetting link
[   28.611111] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   28.613232] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   28.613241] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   28.613378] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   28.619103] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   28.619112] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   28.619240] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   28.619616] ata2.00: configured for UDMA/133
[   28.623193] ata2.00: configured for UDMA/133
[   28.623289] ata2: EH complete
[   28.623427] ata2: limiting SATA link speed to 1.5 Gbps
[   28.623528] ata2.00: exception Emask 0x10 SAct 0x1 SErr 0x400100 action 0x6 frozen
[   28.623651] ata2.00: irq_stat 0x08000000, interface fatal error
[   28.623745] ata2: SError: { UnrecovData Handshk }
[   28.623836] ata2.00: failed command: WRITE FPDMA QUEUED
[   28.623934] ata2.00: cmd 61/ff:00:00:00:00/ff:00:00:00:00/40 tag 0 ncq 33553920 out
[   28.623937]          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
[   28.624202] ata2.00: status: { DRDY }
[   28.624303] ata2: hard resetting link
[   28.929103] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   28.932449] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   28.932458] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   28.932587] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   28.939190] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   28.939200] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   28.939328] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   28.939763] ata2.00: configured for UDMA/133
[   28.941154] ata2.00: configured for UDMA/133
[   28.941250] ata2: EH complete
[   28.941414] ata2.00: exception Emask 0x10 SAct 0x1 SErr 0x400100 action 0x6 frozen
[   28.941538] ata2.00: irq_stat 0x08000000, interface fatal error
[   28.941631] ata2: SError: { UnrecovData Handshk }
[   28.941722] ata2.00: failed command: WRITE FPDMA QUEUED
[   28.941821] ata2.00: cmd 61/ff:00:00:00:00/ff:00:00:00:00/40 tag 0 ncq 33553920 out
[   28.941823]          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
[   28.942091] ata2.00: status: { DRDY }
[   28.942187] ata2: hard resetting link
[   29.247116] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   29.250536] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   29.250545] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   29.250673] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   29.256129] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   29.256138] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   29.256266] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   29.256651] ata2.00: configured for UDMA/133
[   29.259263] ata2.00: configured for UDMA/133
[   29.259359] ata2: EH complete
[   29.259533] ata2.00: exception Emask 0x10 SAct 0x1 SErr 0x400100 action 0x6 frozen
[   29.259659] ata2.00: irq_stat 0x08000000, interface fatal error
[   29.259752] ata2: SError: { UnrecovData Handshk }
[   29.259843] ata2.00: failed command: WRITE FPDMA QUEUED
[   29.259942] ata2.00: cmd 61/ff:00:00:00:00/ff:00:00:00:00/40 tag 0 ncq 33553920 out
[   29.259945]          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
[   29.260218] ata2.00: status: { DRDY }
[   29.260319] ata2: hard resetting link
[   29.565102] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   29.569593] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   29.569603] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   29.569731] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   29.573969] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   29.573978] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   29.574127] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   29.574543] ata2.00: configured for UDMA/133
[   29.577217] ata2.00: configured for UDMA/133
[   29.577313] sd 1:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[   29.577460] sd 1:0:0:0: [sdb] Sense Key : Aborted Command [current] [descriptor]
[   29.577786] Descriptor sense data with sense descriptors (in hex):
[   29.577928]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[   29.578923]         00 00 00 00
[   29.579301] sd 1:0:0:0: [sdb] Add. Sense: No additional sense information
[   29.579496] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 00 00 00 00 ff ff 00
[   29.580281] end_request: I/O error, dev sdb, sector 0
[   29.580395] ata2: EH complete

