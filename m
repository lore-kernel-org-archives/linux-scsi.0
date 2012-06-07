From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH 1/3] scsi: set to WCE if usb cache quirk is present.
Date: Thu, 07 Jun 2012 16:16:18 +0400
Message-ID: <4FD09B92.1020600@mvista.com>
References: <1338985224-9684-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1338985224-9684-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Pankaj Kumar <pankaj.km@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

Hello.

On 06-06-2012 16:20, Namjae Jeon wrote:

> Make use of USB quirk method to identify such HDD while reading the cache status in sd_probe(). If cache quirk is present for the HDD, lets assume that cache is enabled and make WCE bit equal to 1.

> Signed-off-by: Namjae Jeon<namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar<pankaj.km@samsung.com>
> Signed-off-by: Amit Sahrawat<a.sahrawat@samsung.com>
> ---
>   drivers/scsi/sd.c          |    9 +++++++--
>   include/scsi/scsi_device.h |    1 +
>   2 files changed, 8 insertions(+), 2 deletions(-)

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 6f0a4c6..33faf6d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2259,8 +2259,13 @@ bad_sense:
>   		sd_printk(KERN_ERR, sdkp, "Asking for cache data failed\n");
>
>   defaults:
> -	sd_printk(KERN_ERR, sdkp, "Assuming drive cache: write through\n");
> -	sdkp->WCE = 0;
> +	if (sdp->wce_quirk) {
> +		sdkp->WCE = 1;
> +		sd_printk(KERN_NOTICE, sdkp, "Assuming drive cache write back\n");

    You forgot colon after "cache".

> +	} else {
> +		sd_printk(KERN_ERR, sdkp, "Assuming drive cache: write through\n");
> +		sdkp->WCE = 0;

    It makes sense to do assignments and printk() in the same order in both 
branches.

> +	}
>   	sdkp->RCD = 0;
>   	sdkp->DPOFUA = 0;
>   }

WBR, Sergei
