From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [PATCH] scsi: Check if the device support WRITE_SAME_10
Date: Wed, 05 Jun 2013 22:09:22 +0200
Message-ID: <51AF9AF2.5000907@itwm.fraunhofer.de>
References: <51AC1440.7020505@zytor.com> <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com> <51AC3283.4000403@zytor.com> <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com> <51ACBAA0.40604@zytor.com> <CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com> <51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net> <51AD2485.9000601@zytor.com> <alpine.DEB.2.02.1306041132260.19072@jlaw-desktop.mno.stratus.com> <51AF0CCF.8000909@itwm.fraunhofer.de> <51AF232C.8060209@itwm.fraunhofer.de> <51AF34E0.3030609@itwm.fraunhofer.de> <yq1r4ggpdy7.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1r4ggpdy7.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, "H. Peter Anvin" <hpa@zytor.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 06/05/2013 09:14 PM, Martin K. Petersen wrote:>>>>>> "Bernd" == Bernd Schubert <bernd.schubert@itwm.fraunhofer.de> writes:
> 
> Bernd> The md layer currently cannot handle failed WRITE_SAME commands
> Bernd> and the initial easiest fix is to check if the device supports
> Bernd> WRITE_SAME at all. It already tested for WRITE_SAME_16 and this
> Bernd> commit adds a test for WRITE_SAME_10.
> 
> No go. That'll disable WRITE SAME for drives which don't support
> RSOC. Which means almost all of them.

Ah, sorry, I didn't check the specs.

> 
> I propose the following...
> 

> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -442,8 +442,15 @@ sd_store_write_same_blocks(struct device *dev, struct device_attribute *attr,
>  
>  	if (max == 0)
>  		sdp->no_write_same = 1;
> -	else if (max <= SD_MAX_WS16_BLOCKS)
> -		sdkp->max_ws_blocks = max;
> +	else
> +		sdp->no_write_same = 0;
> +
> +	if (sdkp->ws16)
> +		sdkp->max_ws_blocks =
> +			max_t(unsigned long, max, SD_MAX_WS16_BLOCKS);
> +	else
> +		sdkp->max_ws_blocks =
> +			max_t(unsigned long, max, SD_MAX_WS10_BLOCKS);
>  
>  	sd_config_write_same(sdkp);

Max? Not min_t()?


> @@ -762,16 +769,16 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
>  	 * blocks per I/O unless the device explicitly advertises a
>  	 * bigger limit.
>  	 */
> -	if (sdkp->max_ws_blocks == 0)
> -		sdkp->max_ws_blocks = SD_MAX_WS10_BLOCKS;
> -
> -	if (sdkp->ws16 || sdkp->max_ws_blocks > SD_MAX_WS10_BLOCKS)
> +	if (sdkp->max_ws_blocks > SD_MAX_WS10_BLOCKS)
>  		blocks = min_not_zero(sdkp->max_ws_blocks,
>  				      (u32)SD_MAX_WS16_BLOCKS);
>  	else
>  		blocks = min_not_zero(sdkp->max_ws_blocks,
>  				      (u32)SD_MAX_WS10_BLOCKS);
>  
> +	if (sdkp->ws16 || sdkp->ws10 || sdkp->device->no_report_opcodes)
> +		sdkp->max_ws_blocks = blocks;
> +
>  out:
>  	blk_queue_max_write_same_sectors(q, blocks * (logical_block_size >> 9));
>  }

blk_queue_max_write_same_sectors(q, sdkp->max_ws_blocks * (logical_block_size >> 9)) ?
Otherwise sdkp->max_ws_blocks and the queue might have different values, wouldn't they?


I cant't provide a comment about scsi_get_vpd_page, I simply don't know. You certainly
know the scsi specs ways better than I do!


Thanks,
Bernd



