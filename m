From: Michael Christie <mchristi@redhat.com>
Subject: Re: [RESEND PATCH] scsi: target/iblock: Fix overrun in WRITE SAME
 emulation
Date: Wed, 3 Jul 2019 12:40:29 +0900
Message-ID: <a1c14025-cb00-7f64-a633-82019a3b6813@redhat.com>
References: <20190702191636.26481-1-r.bolshakov@yadro.com>
Reply-To: mchristi@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190702191636.26481-1-r.bolshakov@yadro.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Roman Bolshakov <r.bolshakov@yadro.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

On 07/03/2019 04:16 AM, Roman Bolshakov wrote:
> WRITE SAME corrupts data on the block device behind iblock if the
> command is emulated. The emulation code issues (M - 1) * N times more
> bios than requested, where M is the number of 512 blocks per real block
> size and N is the NUMBER OF LOGICAL BLOCKS specified in WRITE SAME
> command. So, for a device with 4k blocks, 7 * N more LBAs gets written
> after the requested range.
> 
> The issue happens because the number of 512 byte sectors to be written
> is decreased one by one while the real bios are typically from 1 to 8
> 512 byte sectors per bio.
> 
> Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/target/target_core_iblock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index f4a075303e9a..6949ea8bc387 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -502,7 +502,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
>  
>  		/* Always in 512 byte units for Linux/Block */
>  		block_lba += sg->length >> SECTOR_SHIFT;
> -		sectors -= 1;
> +		sectors -= sg->length >> SECTOR_SHIFT;
>  	}
>  
>  	iblock_submit_bios(&list);
> 

Roman,

The patch looks ok to me. Just one question. How did you hit this?

Did you by any chance export this disk to a ESX initiator and was it
doing WRITE SAME to zero out data. But, did the device being used by
iblock not support the zero out command (was
/sys/block/XYZ/queue/write_zeroes_max_bytes == 0)?

Or, did you just send a WRITE SAME command manually using some tools
like sg utils and it had a non zero'd buffer to write out?

Or, was it some other use case?
