From: Meelis Roos <mroos@linux.ee>
Subject: Re: [PATCH] hpsa: disable volume status check for older controller
Date: Fri, 4 Aug 2017 19:26:57 +0300 (EEST)
Message-ID: <alpine.LRH.2.20.1708041923430.29380@math.ut.ee>
References: <1501686356-56888-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:58102 "EHLO smtp2.it.da.ut.ee"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752350AbdHDQ1B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Aug 2017 12:27:01 -0400
In-Reply-To: <1501686356-56888-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

> Older Controller might not support volume status, so disable
> it if 'hpsa_allow_any' is present.

It makes my DL380G4 boot with hpsa.hpsa_allow_any=1 and it seems to 
work. Howevere, there are multiole verbose dmesg entries about failing 
things:

    0.267224] HP HPSA Driver (v 3.4.18-0)
[    0.267351] hpsa 0000:04:03.0: unsupported board ID: 0x40910e11
[    0.267494] hpsa 0000:04:03.0: unsupported board ID: 0x40910e11
[    0.267695] hpsa 0000:04:03.0: PCI IRQ 51 -> rerouted to legacy IRQ 19
[    0.267889] hpsa 0000:04:03.0: Physical aborts not supported
[    0.268036] hpsa 0000:04:03.0: Logical aborts not supported
[    0.268163] hpsa 0000:04:03.0: HP SSD Smart Path aborts not supported
[    0.448240] scsi host0: hpsa
[    0.452228] hpsa 0000:04:03.0: report luns requested format 2, got 0
[    0.453950] hpsa 0000:04:03.0: hpsa0: hpsa_update_device_info: can't get device id for host 0:C0:T0:L0       Direct-Access           MAN3735MC       
[    0.454312] hpsa 0000:04:03.0: SCSI status: LUN:0000000000000000 CDB:26000000000015000801000000000000
[    0.454525] hpsa 0000:04:03.0: SCSI Status = 02, Sense key = 0x05, ASC = 0x3a, ASCQ = 0x00
[    0.458100] hpsa 0000:04:03.0: hpsa0: hpsa_update_device_info: can't get device id for host 0:C0:T-1:L-1     Direct-Access           MAP3735NC       
[    0.458453] hpsa 0000:04:03.0: SCSI status: LUN:0000000000000000 CDB:26000100000015000801000000000000
[    0.458668] hpsa 0000:04:03.0: SCSI Status = 02, Sense key = 0x05, ASC = 0x3a, ASCQ = 0x00
[    0.485980] hpsa 0000:04:03.0: C0:T-1:L-1 Volume status not available, assuming online.
[    0.486807] hpsa 0000:04:03.0: scsi 0:0:0:0: masked Direct-Access     FUJITSU  MAN3735MC        PHYS DRV SSDSmartPathCap- En- Exp=0
[    0.487020] hpsa 0000:04:03.0: scsi 0:0:1:0: masked Direct-Access     FUJITSU  MAP3735NC        PHYS DRV SSDSmartPathCap- En- Exp=0
[    0.487229] hpsa 0000:04:03.0: scsi 0:1:0:0: added Direct-Access     HP       LOGICAL VOLUME   RAID-1(+0) SSDSmartPathCap- En- Exp=1
[    0.487440] hpsa 0000:04:03.0: scsi 0:3:0:0: added RAID              HP       SA6i             controller SSDSmartPathCap- En- Exp=1
[    0.487997] scsi 0:1:0:0: Direct-Access     HP       LOGICAL VOLUME   2.84 PQ: 0 ANSI: 4
[    0.488989] scsi 0:3:0:0: RAID              HP       SA6i             2.84 PQ: 0 ANSI: 0
[    0.489390] hpsa 0000:0b:04.0: unsupported board ID: 0x409c0e11
[    0.489532] hpsa 0000:0b:04.0: unsupported board ID: 0x409c0e11
[    0.489870] hpsa 0000:0b:04.0: Physical aborts not supported
[    0.489995] hpsa 0000:0b:04.0: Logical aborts not supported
[    0.490118] hpsa 0000:0b:04.0: HP SSD Smart Path aborts not supported
[    0.628221] scsi host1: hpsa
[    0.632143] hpsa 0000:0b:04.0: report luns requested format 2, got 0
[    0.633498] hpsa 0000:0b:04.0: scsi 1:3:0:0: added RAID              HP       SA6400           controller SSDSmartPathCap- En- Exp=1
[    0.634246] scsi 1:0:0:0: RAID              HP       SA6400           2.84 PQ: 0 ANSI: 0
[    0.634882] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    0.635581] sd 0:1:0:0: [sda] 430622325 512-byte logical blocks: (220 GB/205 GiB)
[    0.635974] sd 0:1:0:0: [sda] Write Protect is off
[    0.636118] sd 0:1:0:0: [sda] Mode Sense: 5b 00 00 08
[    0.636337] sd 0:1:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA

Among these, the following show up red in dmesg:

report luns requested format 2, got 0
hpsa0: hpsa_update_device_info: can't get device id for host 0:C0:T0:L0       Direct-Access           MAN3735MC
hpsa0: hpsa_update_device_info: can't get device id for host 0:C0:T-1:L-1     Direct-Access           MAP3735NC
report luns requested format 2, got 0

-- 
Meelis Roos (mroos@linux.ee)
