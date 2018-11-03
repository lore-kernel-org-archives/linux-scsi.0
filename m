From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: myrs: avoid stack overflow warning
Date: Sat, 3 Nov 2018 09:47:34 +0100
Message-ID: <c4e5b45e-85a5-d279-0265-a4974f41fa85@suse.de>
References: <20181102154426.1951776-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181102154426.1951776-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/2/18 4:44 PM, Arnd Bergmann wrote:
> Putting a 1024 byte data structure on the stack is generally a bad idea.
> On 32-bit systems, it also triggers a compile-time warning when building
> with -Og:
> 
> drivers/scsi/myrs.c: In function 'myrs_get_ctlr_info':
> drivers/scsi/myrs.c:212:1: error: the frame size of 1028 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> 
> We only really need three members of the structure, so just read them
> manually here instead of copying the entire structure.
> 
> Fixes: 77266186397c ("scsi: myrs: Add Mylex RAID controller (SCSI interface)")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/scsi/myrs.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
> index 0264a2e2bc19..b8d54ef8cf6d 100644
> --- a/drivers/scsi/myrs.c
> +++ b/drivers/scsi/myrs.c
> @@ -163,9 +163,12 @@ static unsigned char myrs_get_ctlr_info(struct myrs_hba *cs)
>   	dma_addr_t ctlr_info_addr;
>   	union myrs_sgl *sgl;
>   	unsigned char status;
> -	struct myrs_ctlr_info old;
> +	unsigned short ldev_present, ldev_critical, ldev_offline;
> +
> +	ldev_present = cs->ctlr_info->ldev_present;
> +	ldev_critical = cs->ctlr_info->ldev_critical;
> +	ldev_offline = cs->ctlr_info->ldev_offline;
>   
> -	memcpy(&old, cs->ctlr_info, sizeof(struct myrs_ctlr_info));
>   	ctlr_info_addr = dma_map_single(&cs->pdev->dev, cs->ctlr_info,
>   					sizeof(struct myrs_ctlr_info),
>   					DMA_FROM_DEVICE);
> @@ -198,9 +201,9 @@ static unsigned char myrs_get_ctlr_info(struct myrs_hba *cs)
>   		    cs->ctlr_info->rbld_active +
>   		    cs->ctlr_info->exp_active != 0)
>   			cs->needs_update = true;
> -		if (cs->ctlr_info->ldev_present != old.ldev_present ||
> -		    cs->ctlr_info->ldev_critical != old.ldev_critical ||
> -		    cs->ctlr_info->ldev_offline != old.ldev_offline)
> +		if (cs->ctlr_info->ldev_present != ldev_present ||
> +		    cs->ctlr_info->ldev_critical != ldev_critical ||
> +		    cs->ctlr_info->ldev_offline != ldev_offline)
>   			shost_printk(KERN_INFO, cs->host,
>   				     "Logical drive count changes (%d/%d/%d)\n",
>   				     cs->ctlr_info->ldev_critical,
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
