From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] hpsa: add support for legacy boards
Date: Wed, 2 Aug 2017 17:05:49 +0200
Message-ID: <fa9c1dac-98a7-e6ca-65a6-38df6d77c769@suse.de>
References: <1499755744-79217-1-git-send-email-hare@suse.de>
 <alpine.LRH.2.20.1707111547060.31569@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42370 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752473AbdHBPFw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Aug 2017 11:05:52 -0400
In-Reply-To: <alpine.LRH.2.20.1707111547060.31569@math.ut.ee>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 07/11/2017 04:25 PM, Meelis Roos wrote:
>> Add support for legacy boards, ensuring to enable the driver for
>> those boards only when 'hpsa_allow_any' is set.
> 
> Applied this patch, made sure I had compiled in hpsa and not cciss to 
> avoid any variables from initramfs, and still I get this:
> 
> [    4.015080] hpsa 0000:00:04.0: unrecognized board ID: 0x40800e11, ignoring.
> [    4.098473] hpsa 0000:00:04.0: Board ID not found
> 
> Boot command line was "root=/dev/sda1 console=ttyS0,9600 ro hpsa_allow_any=1" - 
> seems correct.
> 
> By looking at the code, I should see "unsupported board ID:" and it 
> should work, but I see "unrecognized board ID:" and it does not work.
> 
> Hmm, trying hpsa.hpsa_allow_any=1. Much better:
> 
> [    3.891531] hpsa 0000:00:04.0: unsupported board ID: 0x40800e11
> [    3.962367] hpsa 0000:00:04.0: unsupported board ID: 0x40800e11
> [    4.033493] hpsa 0000:00:04.0: Controller reports max supported commands of 0 Using 16 instead. Ensure that firmware is up to date.
> [    4.175134] hpsa 0000:00:04.0: Physical aborts not supported
> [    4.242931] hpsa 0000:00:04.0: Logical aborts not supported
> [    4.309594] hpsa 0000:00:04.0: HP SSD Smart Path aborts not supported
> [    4.460889] hpsa 0000:00:04.0: Controller reports max supported commands of 0 Using 16 instead. Ensure that firmware is up to date.
> [    4.584679] scsi host0: hpsa
> [    4.587842] hpsa 0000:00:04.0: report luns requested format 2, got 0
> [    4.613215] hpsa 0000:00:04.0: scsi 0:0:0:0: masked Direct-Access     COMPAQ   BD03685A24       PHYS DRV SSDSmartPathCap- En- Exp=0
> [    4.613219] hpsa 0000:00:04.0: C0:B1:T0:L0 Volume status is not available through vital product data pages.
> [    4.613224] hpsa 0000:00:04.0: scsi 0:1:0:0: offline Direct-Access     COMPAQ   LOGICAL VOLUME   RAID-1(+0) SSDSmartPathCap- En- Exp=1
> [    4.613229] hpsa 0000:00:04.0: scsi 0:3:0:0: added RAID              COMPAQ   Smart Array 5i   controller SSDSmartPathCap- En- Exp=1
> [    6.187725] scsi 0:3:0:0: RAID              COMPAQ   Smart Array 5i   2.62 PQ: 0 ANSI: 0
> [...]
> [    6.726872] VFS: Cannot open root device "sda1" or unknown-block(0,0): error -6
> [    6.814364] Please append a correct "root=" boot option; here are the available partitions:
> [    6.914403] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
> 
> Controller is detected, there is something behind it but no sda is 
> detected and no bootup.
> 
> What next?
> 
As Don indicated, older controller probably don't support volume state
information. But that shouldn't distract us. Will be sending a patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
