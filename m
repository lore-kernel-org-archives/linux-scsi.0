From: Chris Webb <chris@arachsys.com>
Subject: Re: MD/RAID time out writing superblock
Date: Thu, 17 Sep 2009 00:19:21 +0100
Message-ID: <20090916231921.GL1924@arachsys.com>
References: <4A9BBC4A.6070708@redhat.com>
 <4A9BC023.10903@kernel.org>
 <20090907114442.GG18831@arachsys.com>
 <20090907115927.GU8710@arachsys.com>
 <20090909120218.GB21829@arachsys.com>
 <4AADF3C4.5060004@kernel.org>
 <4AADF471.2020801@suse.de>
 <4AAE3B9A.2060306@rtr.ca>
 <4AAE3F86.8090804@suse.de>
 <4AAE524C.2030401@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AAE524C.2030401@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <teheo@suse.de>, linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Mark Lord <liml@rtr.ca> writes:

> I suspect we're missing some info from this specific failure.
> Looking back at Chris's earlier posting, the whole thing started
> with a FLUSH_CACHE_EXT failure.  Once that happens, all bets are
> off on anything that follows.
> 
> >Everything will be running fine when suddenly:
> >
> >  ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> >  ata1.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> >          res 40/00:00:80:17:91/00:00:37:00:00/40 Emask 0x4 (timeout)
> >  ata1.00: status: { DRDY }
> >  ata1: hard resetting link
> >  ata1: softreset failed (device not ready)
> >  ata1: hard resetting link
> >  ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> >  ata1.00: configured for UDMA/133
> >  ata1: EH complete
> >  end_request: I/O error, dev sda, sector 1465147272
> >  md: super_written gets error=-5, uptodate=0
> >  raid10: Disk failure on sda3, disabling device.
> >  raid10: Operation continuing on 5 devices.

Hi Mark. Yes, when the first timeout after a clean boot happens, it's with
an 0xea flush command every time:

  [...]
  ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
  ata5.00: ATA-8: ST3750523AS, CC34, max UDMA/133
  ata5.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
  ata5.00: configured for UDMA/133
  scsi 4:0:0:0: Direct-Access     ATA      ST3750523AS      CC34 PQ: 0 ANSI: 5
  sd 4:0:0:0: [sde] 1465149168 512-byte hardware sectors: (750 GB/698 GiB)
  sd 4:0:0:0: [sde] Write Protect is off
  sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
  sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  sd 4:0:0:0: [sde] 1465149168 512-byte hardware sectors: (750 GB/698 GiB)
  sd 4:0:0:0: [sde] Write Protect is off
  sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
  sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
   sde: sde1 sde2 sde3
  sd 4:0:0:0: [sde] Attached SCSI disk
  sd 4:0:0:0: Attached scsi generic sg4 type 0

  [later]
  ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
  ata5.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
           res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)
  ata5.00: status: { DRDY }
  ata5: hard resetting link
  ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
  ata5.00: configured for UDMA/133
  ata5: EH complete
  sd 4:0:0:0: [sde] 1465149168 512-byte hardware sectors: (750 GB/698 GiB)
  sd 4:0:0:0: [sde] Write Protect is off
  sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
  sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  end_request: I/O error, dev sde, sector 1465147264
  md: super_written gets error=-5, uptodate=0
  raid10: Disk failure on sde3, disabling device.
  raid10: Operation continuing on 4 devices.

Best wishes,

Chris.
