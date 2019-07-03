From: Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [RESEND PATCH] scsi: target/iblock: Fix overrun in WRITE SAME
 emulation
Date: Wed, 3 Jul 2019 16:24:36 +0300
Message-ID: <20190703132436.22k53mprnrn5fxcj@SPB-NB-133.local>
References: <20190702191636.26481-1-r.bolshakov@yadro.com>
 <a1c14025-cb00-7f64-a633-82019a3b6813@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a1c14025-cb00-7f64-a633-82019a3b6813@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Michael Christie <mchristi@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 03, 2019 at 12:40:29PM +0900, Michael Christie wrote:
> On 07/03/2019 04:16 AM, Roman Bolshakov wrote:
> > WRITE SAME corrupts data on the block device behind iblock if the
> > command is emulated. The emulation code issues (M - 1) * N times more
> > bios than requested, where M is the number of 512 blocks per real block
> > size and N is the NUMBER OF LOGICAL BLOCKS specified in WRITE SAME
> > command. So, for a device with 4k blocks, 7 * N more LBAs gets written
> > after the requested range.
> > 
> > The issue happens because the number of 512 byte sectors to be written
> > is decreased one by one while the real bios are typically from 1 to 8
> > 512 byte sectors per bio.
> > 
> Roman,
> 
> The patch looks ok to me. Just one question. How did you hit this?
> 

Hi Michael,

The initiator was CentOS 7.x with distro kernel (3.10.0-x). There were
two cases:
 * Initiatalization [1] and online resize of ext4 filesystem [2]
   use WRITE SAME [3] for zeroing. TCM doesn't support RSOC, so
   the initiator defaults to using WRITE SAME (10). The filesystem
   showed errors after online resize;
 * a WRITE SAME command for the last LBA was stuck in multipath. TCM
   always returned LOGICAL UNIT NOT SUPPORTED for the command. The
   resason of the response is because some bios were sent beyond the
   sector limit. WRITE SAME with NUMBER OF LOGICAL BLOCKS == 1 was
   failing for the last 7 LBAs.

> Did you by any chance export this disk to a ESX initiator and was it
> doing WRITE SAME to zero out data. But, did the device being used by
> iblock not support the zero out command (was
> /sys/block/XYZ/queue/write_zeroes_max_bytes == 0)?
> 

It did not support zero out and write same, both
write_zeroes_max_bytes/write_same_max_bytes == 0

> Or, did you just send a WRITE SAME command manually using some tools
> like sg utils and it had a non zero'd buffer to write out?
> 

Yes, I triaged the issues above with sg_write_same/sg_dd and non-zero
buffer.

1. https://patchwork.ozlabs.org/patch/66590/
2. https://lists.openwall.net/linux-ext4/2012/01/04/14
3. https://www.spinics.net/lists/linux-scsi/msg57783.html

Best regards,
Roman
