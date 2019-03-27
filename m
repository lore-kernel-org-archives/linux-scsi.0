From: Mukesh Ojha <mojha@codeaurora.org>
Subject: Re: [PATCH] scsi: sun_esp: : Fix object reference leaks in
 esp_sbus_probe
Date: Wed, 27 Mar 2019 18:17:34 +0530
Message-ID: <8560b226-1f0b-e9c6-6a18-800e10111f65@codeaurora.org>
References: <1553644557-35817-1-git-send-email-huang.zijiang@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553644557-35817-1-git-send-email-huang.zijiang@zte.com.cn>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Huang Zijiang <huang.zijiang@zte.com.cn>, jejb@linux.ibm.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, wang.yi59@zte.com.cn
List-Id: linux-scsi@vger.kernel.org


Sorry for the spam whosoever has got the last mail, as the last did not 
get to
the mailing list, and it bounced, so sending it again.

On 3/27/2019 5:25 AM, Huang Zijiang wrote:
> The of_find_device_by_node() takes a reference to the underlying device
> structure, we should release that reference whatever of_find_device_by_node
> reutrns.
s/reutrns/returns
>
> Signed-off-by: Huang Zijiang <huang.zijiang@zte.com.cn>



Take mine review tag once you make above change.

Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

-Mukesh



> ---
>   drivers/scsi/sun_esp.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
> index a11efbc..a74605a 100644
> --- a/drivers/scsi/sun_esp.c
> +++ b/drivers/scsi/sun_esp.c
> @@ -543,9 +543,8 @@ static int esp_sbus_probe(struct platform_device *op)
>   		return -ENODEV;
>   
>   	ret = esp_sbus_probe_one(op, dma_of, hme);
> -	if (ret)
> -		put_device(&dma_of->dev);
>   
> +	put_device(&dma_of->dev);
>   	return ret;
>   }
>   
