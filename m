From: Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
Date: Wed, 25 Mar 2009 02:06:59 -0400
Message-ID: <49C9CA03.7040603@garzik.org>
References: <cjlqb-7sp-1@gated-at.bofh.it> <cjq6y-6sq-11@gated-at.bofh.it> <49C9BEC8.9020403@devnull.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49C9BEC8.9020403@devnull.org>
Sender: linux-ide-owner@vger.kernel.org
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: "linux.kernel" <linux-kernel@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>, Arjan van de Ven <arjan@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Niel Lambrechts wrote:
> On 03/25/2009 03:30 AM, Theodore Tso wrote:
>> On Tue, Mar 24, 2009 at 10:25:57PM +0200, Niel Lambrechts wrote:
>>> Hi,
>>>
>>> After upgrading to 2.6.29 I get the below errors after resuming from
>>> hibernating with s2disk. I ran fsck and tried doing the same thing again
>>> in 2.6.28.9-pae, but do not get any errors there.
>> The ext4 errors are interleaved with hardware errors, and the ext4
>> errors are about I/O errors.
>>
>> EXT4-fs error (device sda6): __ext4_get_inode_loc: unable to read inode block - inode=2346519
>> EXT4-fs error (device sda6) in ext4_reserve_inode_write: IO failure
>>
>> This looks more like a hibernation problem than an ext4 problem.
>> Looks like the hard drive is being left in some inconsistent state
>> after resuming from hibernation.
>>
>>      	   	       		   	   - Ted
> 
> Thanks for the info Theodore, this is definitely looks like some type of
> regression in 2.6.29, as the problem is not evident when I s2disk using
> 2.6.28.9, even after multiple suspend/resume cycles.
> 
> I found some 'ATA bus errors' and 'SError' messages in
> /var/log/messages, so I've attached the messages from both 2.6.29 and
> 2.6.28 for comparison.

Well, here is the interpretation of messages:

> ata1.00: irq_stat 0x00400008, PHY RDY changed
> ata1: SError: { PHYRdyChg CommWake }

Your SATA hardware flags a connect-or-disconnect event ("PHY RDY"), 
which requires us to abort a bunch of queued commands:

> ata1.00: cmd 60/18:00:77:88:6f/00:00:0e:00:00/40 tag 0 ncq 12288 in
>          res 50/00:30:07:b3:10/00:00:0c:00:00/40 Emask 0x10 (ATA bus error)
[...]
> ata1.00: cmd 60/30:68:07:b3:10/00:00:0c:00:00/40 tag 13 ncq 24576 in
>          res 50/00:30:07:b3:10/00:00:0c:00:00/40 Emask 0x10 (ATA bus error)

  ...through the 14th command (tag 13).

> Mar 24 21:29:14 linux-7vph kernel: ata1: hard resetting link
> Mar 24 21:29:14 linux-7vph kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> Mar 24 21:29:14 linux-7vph kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
> Mar 24 21:29:14 linux-7vph kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
> Mar 24 21:29:14 linux-7vph kernel: ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
> Mar 24 21:29:14 linux-7vph kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
> Mar 24 21:29:14 linux-7vph kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
> Mar 24 21:29:14 linux-7vph kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
> Mar 24 21:29:14 linux-7vph kernel: ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
> Mar 24 21:29:14 linux-7vph kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
> Mar 24 21:29:14 linux-7vph kernel: ata1.00: configured for UDMA/133
> Mar 24 21:29:14 linux-7vph kernel: ata1.00: configured for UDMA/133


SATA link is reset, and ACPI is re-run.

> Mar 24 21:29:14 linux-7vph kernel: sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> Mar 24 21:29:14 linux-7vph kernel: sd 0:0:0:0: [sda] Sense Key : Aborted Command [current] [descriptor]
> Mar 24 21:29:14 linux-7vph kernel: Descriptor sense data with sense descriptors (in hex):
> Mar 24 21:29:14 linux-7vph kernel:         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
> Mar 24 21:29:14 linux-7vph kernel:         0c 10 b3 07 
> Mar 24 21:29:14 linux-7vph kernel: sd 0:0:0:0: [sda] Add. Sense: No additional sense information
> Mar 24 21:29:14 linux-7vph kernel: end_request: I/O error, dev sda, sector 242190455

The SCSI subsystem aborts each of the queued commands.

> Mar 24 21:29:14 linux-7vph kernel: ata1: EH complete

SATA error handling completes

> Mar 24 21:29:14 linux-7vph kernel: EXT4-fs error (device sda6): __ext4_get_inode_loc: unable to read inode block - inode=2330178, block=9338883

ext4 pukes, because of SATA/SCSI errors

> Mar 24 21:29:14 linux-7vph kernel: sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors: (200 GB/186 GiB)
> Mar 24 21:29:14 linux-7vph kernel: sd 0:0:0:0: [sda] Write Protect is off
> Mar 24 21:29:14 linux-7vph kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> Mar 24 21:29:14 linux-7vph kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Mar 24 21:29:14 linux-7vph kernel: sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors: (200 GB/186 GiB)
> Mar 24 21:29:14 linux-7vph kernel: sd 0:0:0:0: [sda] Write Protect is off
> Mar 24 21:29:14 linux-7vph kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> Mar 24 21:29:14 linux-7vph kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

SCSI finished re-initialization.

So from this, a few observations and open questions:

Why didn't these SCSI commands get retried?

Were they left over from prior to resume?

Did SCSI error out the commands too soon?  The probing is not complete 
until AFTER the sector errors, I note.

Did the system resume before ACPI resume and SCSI resume completed?  It 
sure looks that way, from the log.

Does the asynchronous probing play a role here?

	Jeff



