From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi:NCR5380: remove same check condition in
 NCR5380_select
Date: Fri, 3 Aug 2018 12:24:07 +1000 (AEST)
Message-ID: <alpine.LNX.2.21.1808031156350.16@nippy.intranet>
References: <1533179408-20631-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533179408-20631-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>
Cc: schmitzmic@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, andy.shevchenko@gmail.com, john.garry@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2 Aug 2018, zhong jiang wrote:

> The same check condition is redundant, so remove one of them.
> 

If you are trying to find redundant code, your coccinelle script is 
dangerously flawed.

You need to realize that NCR5380_read(CURRENT_SCSI_DATA_REG) is not simply 
a value in a CPU register or a device register, but it is the actual state 
of the scsi bus data lines, which are subject to change any time, at the 
whim of the firmwares in all of the SCSI bus devices participating in 
arbitration at the time, or of a user who might kick a plug etc.

>From the datasheet:

    The SCSI data lines are not actually registered, but gated directly 
    onto the CPU bus whenever Address 000 is read by the CPU...

Hence, NAK.

-- 

> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/scsi/NCR5380.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 90ea0f5..2ecaf3f 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -999,8 +999,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
>  
>  	/* Check for lost arbitration */
>  	if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
> -	    (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) ||
> -	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
> +	    (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask)) {
>  		NCR5380_write(MODE_REG, MR_BASE);
>  		dsprintk(NDEBUG_ARBITRATION, instance, "lost arbitration, deasserting MR_ARBITRATE\n");
>  		spin_lock_irq(&hostdata->lock);
> 
