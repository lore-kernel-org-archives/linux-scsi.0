From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: No I/O errors reported after SATA link hard reset
Date: Thu, 17 Aug 2017 11:24:22 +0200
Message-ID: <13561110-4e59-303a-8e3d-dd60c1bafba8@fastmail.fm>
References: <fe5cc200a4cba71cb9e5e6a980699805@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <fe5cc200a4cba71cb9e5e6a980699805@assyoma.it>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
Cc: Gionatan Danti <g.danti@assyoma.it>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[This seems to be libata error handling and not scsi, so I added more CCs]

On 08/17/2017 12:27 AM, Gionatan Danti wrote:
> Hi list,
> some time ago, I had a filesystem corruption on a simple, two disks
> RAID1 MD array. On the affected machine, /var/log/messages shown some
> "failed command: WRITE FPDMA QUEUED" entries, but *no* action (ie: kick
> off disk) was taken by MDRAID. I tracked down the problem to an instable
> power supply (switching power rail/connector solved the problem).
> 
> In the latest day I had some spare time and I am now able to regularly
> replicate the problem. Basically, when a short powerloss happens, the
> scsi midlayer logs some failed operations, but does *not* pass these
> errors to higher layer. In other words, no I/O error is returned to the
> calling application. This is the reason why MDRAID did not kick off the
> instable disk on the machine with corrupted filesystem.
> 
> To replicated the problem, I wrote a large random file on a small MD
> RAID1 array, pulling off the power of one disk from about 2 seconds. The
> file write operation stopped for some seconds, than recovered. Running
> an array check resulted in a high number of mismatch_cnt sectors. Dmesg
> logged the following lines:
> 
> Aug 16 16:04:02 blackhole kernel: ata6.00: exception Emask 0x50 SAct
> 0x7fffffff SErr 0x90a00 action 0xe frozen
> Aug 16 16:04:02 blackhole kernel: ata6.00: irq_stat 0x00400000, PHY RDY
> changed
> Aug 16 16:04:02 blackhole kernel: ata6: SError: { Persist HostInt
> PHYRdyChg 10B8B }
> Aug 16 16:04:02 blackhole kernel: ata6.00: failed command: WRITE FPDMA
> QUEUED
> Aug 16 16:04:02 blackhole kernel: ata6.00: cmd
> 61/00:00:10:82:09/04:00:00:00:00/40 tag 0 ncq 524288 out#012         res
> 40/00:d8:10:72:09/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
> Aug 16 16:04:02 blackhole kernel: ata6.00: status: { DRDY }
> ...
> Aug 16 16:04:02 blackhole kernel: ata6.00: failed command: WRITE FPDMA
> QUEUED
> Aug 16 16:04:02 blackhole kernel: ata6.00: cmd
> 61/00:f0:10:7e:09/04:00:00:00:00/40 tag 30 ncq 524288 out#012        
> res 40/00:d8:10:72:09/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
> Aug 16 16:04:02 blackhole kernel: ata6.00: status: { DRDY }
> Aug 16 16:04:02 blackhole kernel: ata6: hard resetting link
> Aug 16 16:04:03 blackhole kernel: ata6: SATA link down (SStatus 0
> SControl 310)
> Aug 16 16:04:04 blackhole kernel: ata6: hard resetting link
> Aug 16 16:04:14 blackhole kernel: ata6: softreset failed (device not ready)
> Aug 16 16:04:14 blackhole kernel: ata6: hard resetting link
> Aug 16 16:04:24 blackhole kernel: ata6: softreset failed (device not ready)
> Aug 16 16:04:24 blackhole kernel: ata6: hard resetting link
> Aug 16 16:04:35 blackhole kernel: ata6: link is slow to respond, please
> be patient (ready=0)
> Aug 16 16:04:42 blackhole kernel: ata6: SATA link down (SStatus 0
> SControl 310)
> Aug 16 16:04:46 blackhole kernel: ata6: hard resetting link
> Aug 16 16:04:46 blackhole kernel: ata3: exception Emask 0x10 SAct 0x0
> SErr 0x40d0202 action 0xe frozen
> Aug 16 16:04:46 blackhole kernel: ata3: irq_stat 0x00400000, PHY RDY
> changed
> Aug 16 16:04:46 blackhole kernel: ata3: SError: { RecovComm Persist
> PHYRdyChg CommWake 10B8B DevExch }
> Aug 16 16:04:46 blackhole kernel: ata3: hard resetting link
> Aug 16 16:04:51 blackhole kernel: ata3: softreset failed (device not ready)
> Aug 16 16:04:51 blackhole kernel: ata3: applying PMP SRST workaround and
> retrying
> Aug 16 16:04:51 blackhole kernel: ata3: SATA link up 3.0 Gbps (SStatus
> 123 SControl 300)
> Aug 16 16:04:51 blackhole kernel: ata3.00: configured for UDMA/133
> Aug 16 16:04:51 blackhole kernel: ata3: EH complete
> Aug 16 16:04:52 blackhole kernel: ata6: softreset failed (device not ready)
> Aug 16 16:04:52 blackhole kernel: ata6: applying PMP SRST workaround and
> retrying
> Aug 16 16:04:52 blackhole kernel: ata6: SATA link up 1.5 Gbps (SStatus
> 113 SControl 310)
> Aug 16 16:04:52 blackhole kernel: ata6.00: configured for UDMA/133
> Aug 16 16:04:52 blackhole kernel: ata6: EH complete
> 
> As you can see, while failed SATA operation were logged in dmesg (and
> /var/log/messages), no I/O errors where returned to the upper layer
> (MDRAID) or the calling application. I had to say that I *fully expect*
> some inconsistencies: after all, removing the power wipes the volatile
> disk's DRAM cache, which means data loss. However, I really expected
> some I/O errors to be thrown to the higher layers, causing visible
> reactions (ie: a disks pushed out the array). With no I/O errors
> returned, the higher layer application are effectively blind.
> 
> More concerning is the fact that these undetected errors can make their
> way even when the higher application consistently calls sync() and/or
> fsync. In other words, it seems than even acknowledged writes can fail
> in this manner (and this is consistent with the first machine corrupting
> its filesystem due to journal trashing - XFS journal surely uses sync()
> where appropriate). The mechanism seems the following:
> 
> - an higher layer application issue sync();
> - a write barrier is generated;
> - a first FLUSH CACHE command is sent to the disk;
> - data are written to the disk's DRAM cache;
> - power is lost! The volatile cache lose its content;
> - power is re-established and the disk become responsive again;
> - a second FLUSH CACHE command is sent to the disk;
> - the disk acks each SATA command, but real data are lost.
> 
> As a side note, when the power loss or SATA cable disconnection is
> relatively long (over 10 seconds, as by eh timeout), the SATA disks
> become disconnected (and the MD layer acts accordlying):
> 
> Aug 16 16:12:20 blackhole kernel: ata6.00: exception Emask 0x50 SAct
> 0x7fffffff SErr 0x490a00 action 0xe frozen
> Aug 16 16:12:20 blackhole kernel: ata6.00: irq_stat 0x08000000,
> interface fatal error
> Aug 16 16:12:20 blackhole kernel: ata6: SError: { Persist HostInt
> PHYRdyChg 10B8B Handshk }
> Aug 16 16:12:20 blackhole kernel: ata6.00: failed command: WRITE FPDMA
> QUEUED
> Aug 16 16:12:20 blackhole kernel: ata6.00: cmd
> 61/00:00:38:88:09/04:00:00:00:00/40 tag 0 ncq 524288 out#012         res
> 40/00:d8:38:f4:09/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
> Aug 16 16:12:20 blackhole kernel: ata6.00: status: { DRDY }
> ...
> Aug 16 16:12:32 blackhole kernel: sd 5:0:0:0: [sdf] FAILED Result:
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Aug 16 16:12:32 blackhole kernel: sd 5:0:0:0: [sdf] Sense Key : Illegal
> Request [current] [descriptor]
> Aug 16 16:12:32 blackhole kernel: sd 5:0:0:0: [sdf] Add. Sense:
> Unaligned write command
> Aug 16 16:12:32 blackhole kernel: sd 5:0:0:0: [sdf] CDB: Write(10) 2a 00
> 00 09 88 38 00 04 00 00
> Aug 16 16:12:32 blackhole kernel: blk_update_request: 23 callbacks
> suppressed
> Aug 16 16:12:32 blackhole kernel: blk_update_request: I/O error, dev
> sdf, sector 624696
> 
> Now, I have few questions:
> - is the above explanation plausible, or I am (horribly) missing something?
> - why the scsi midlevel does not respond to a power loss event by
> immediately offlining the disks?
> - is the scsi midlevel behavior configurable (I know I can lower eh
> timeout, but is this the right solution)?
> - how to deal with this problem (other than being 100% sure power is
> never lost by any disks)?


I added the ata mailing list and Tejun.
I already wanted to report the same issue, as a flaky cable caused
libata error handling on one of my systems at home. ATA EH succeeded for
several weeks until several file systems on that system reported
corruption (btrfs and ext4). Failed commands I can see from syslog are
"READ FPDMA QUEUED" and "FLUSH CACHE EXT", but I'm not sure if it is
complete, as the log file is on btrfs and it reports checksum mismatch
for that file. Kernel version is 4.4.0-81-ubuntu, I have not checked yet
if they applied any libata patches.


Thanks,
Bernd

