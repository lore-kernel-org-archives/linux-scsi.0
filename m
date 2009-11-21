From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Thin provisioning fixes
Date: Fri, 20 Nov 2009 22:56:50 -0600
Message-ID: <4B077312.3050501@redhat.com>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, hch@infradead.org, willy@wil.cx, jgarzik@pobox.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> A few updates to the thin provisioning bits aimed at 2.6.33:
> 
>  - Block layer support for reporting whether reading previously
>    discarded blocks returns zeroes or not.  Jens, this applies on
>    top of the patch that you have already queued.
> 
>  - Updated SCSI disk thin provisioning support:
> 
>    - Reports TPRZ via the new block layer flag
> 
>    - Moved some of the discard detection to read_capacity_16 to
>      accommodate TP devices that don't support Unmap and the
>      block limits VPD
> 
>    James, this replaces my existing post-merge sd patch.
> 
>  - libata:
> 
>    - Translate DRAT and ZRAT to TPRZ (zeroed blocks after trim)
> 
>    - Report the maximum discard sectors in the block limits VPD
> 
>    - Fix a couple of problems in ata_set_lba_range_entries() that
>      caused us to issue garbled trims
> 
> 
> Interested parties can grab the tp branch from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux-2.6-mkp.git

I pulled that tonight ...

Doing a test on an OCZ ssd, by patterning 16GB and then discarding
it via a single ioctl call, ends in an unhappy drive:

ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata3.00: cmd 06/01:00:00:00:00/00:02:00:00:00/a0 tag 0 dma 4294966784 out
         res 40/00:18:18:00:00/00:00:00:00:00/40 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: hard resetting link
ata3: SATA link down (SStatus 0 SControl 300)
ata3: hard resetting link
ata3: SATA link down (SStatus 0 SControl 300)
ata3: limiting SATA link speed to 1.5 Gbps
ata3: hard resetting link
ata3: SATA link down (SStatus 0 SControl 310)
ata3.00: disabled
ata3: EH complete
ata3.00: detaching (SCSI 2:0:0:0)
sd 2:0:0:0: [sdb] Stopping disk
sd 2:0:0:0: [sdb] START_STOP FAILED
sd 2:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK

... and then it goes away ...

-Eric
