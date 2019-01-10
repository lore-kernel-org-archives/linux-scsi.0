From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvscsi: use GFP_ATOMIC with dma_alloc_coherent in
 map_sg_data
Date: Thu, 10 Jan 2019 08:56:45 -0600
Message-ID: <e508178b-4dab-802b-2e36-5a7ebfa226ef@linux.vnet.ibm.com>
References: <1547089136-20264-1-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1547089136-20264-1-git-send-email-tyreld@linux.vnet.ibm.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/09/2019 08:58 PM, Tyrel Datwyler wrote:
> While mapping DMA for scatter list when a scsi command is queued the
> existing call to dma_alloc_coherent() in our map_sg_data() function
> passes zero for the gfp_flags parameter. We are most definitly in atomic
> context at this point as queue_command() is called in softirq context
> and further we have a spinlock holding the scsi host lock.
> 
> Fix this by passing GFP_ATOMIC to dma_alloc_coherent() to prevent any
> sort of sleeping in atomic context deadlock.
> 
> Fixes: 4dddbc26c389 ("[SCSI] ibmvscsi: handle large scatter/gather lists")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 1135e74..cb8535e 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -731,7 +731,7 @@ static int map_sg_data(struct scsi_cmnd *cmd,
>  		evt_struct->ext_list = (struct srp_direct_buf *)
>  			dma_alloc_coherent(dev,
>  					   SG_ALL * sizeof(struct srp_direct_buf),
> -					   &evt_struct->ext_list_token, 0);
> +					   &evt_struct->ext_list_token, GFP_ATOMIC);
>  		if (!evt_struct->ext_list) {
>  			if (!firmware_has_feature(FW_FEATURE_CMO))
>  				sdev_printk(KERN_ERR, cmd->device,
> 

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
