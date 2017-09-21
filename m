From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH 1/1] scsi: bnx: use setup_timer
Date: Thu, 21 Sep 2017 16:02:53 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1709211601330.2123@flash12.qlogic.org>
References: <1505994464-11465-1-git-send-email-allen.lkml@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505994464-11465-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Allen Pais <allen.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Thu, 21 Sep 2017, 7:47am, Allen Pais wrote:

>     Use setup_timer function instead of initializing timer with the
>     function and data fields.
> 
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index 6844ba3..a056211 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -1946,11 +1946,10 @@ static void bnx2fc_fw_destroy(struct bnx2fc_hba *hba)
>  {
>  	if (test_and_clear_bit(BNX2FC_FLAG_FW_INIT_DONE, &hba->flags)) {
>  		if (bnx2fc_send_fw_fcoe_destroy_msg(hba) == 0) {
> -			init_timer(&hba->destroy_timer);
> +			setup_timer(&hba->destroy_timer, bnx2fc_destroy_timer,
> +				    (unsigned long)hba);
>  			hba->destroy_timer.expires = BNX2FC_FW_TIMEOUT +
>  								jiffies;
> -			hba->destroy_timer.function = bnx2fc_destroy_timer;
> -			hba->destroy_timer.data = (unsigned long)hba;
>  			add_timer(&hba->destroy_timer);
>  			wait_event_interruptible(hba->destroy_wait,
>  					test_bit(BNX2FC_FLAG_DESTROY_CMPL,
> 

The title of the patch should be fixed up since the driver is 'bnx2fc'.  
But besides that nit the patch looks good.

Acked-by: Chad Dupuis <chad.dupuis@cavium.com>
