From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND PATCH] scsi: target/iblock: Fix overrun in WRITE SAME emulation
Date: Tue, 02 Jul 2019 16:37:16 -0400
Message-ID: <yq1pnmsfa0z.fsf@oracle.com>
References: <20190702191636.26481-1-r.bolshakov@yadro.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190702191636.26481-1-r.bolshakov@yadro.com> (Roman Bolshakov's
        message of "Tue, 2 Jul 2019 22:16:38 +0300")
Sender: stable-owner@vger.kernel.org
To: Roman Bolshakov <r.bolshakov@yadro.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org


Roman,

> WRITE SAME corrupts data on the block device behind iblock if the
> command is emulated. The emulation code issues (M - 1) * N times more
> bios than requested, where M is the number of 512 blocks per real
> block size and N is the NUMBER OF LOGICAL BLOCKS specified in WRITE
> SAME command. So, for a device with 4k blocks, 7 * N more LBAs gets
> written after the requested range.
>
> The issue happens because the number of 512 byte sectors to be written
> is decreased one by one while the real bios are typically from 1 to 8
> 512 byte sectors per bio.

Applied to 5.2/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
