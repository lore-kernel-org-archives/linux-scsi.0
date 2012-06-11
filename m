From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v4 3/3] usb: storage: update usb devices for write cache
 quirk in quirk list.
Date: Mon, 11 Jun 2012 10:19:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1206111018040.1607-100000@iolanthe.rowland.org>
References: <1339421351-2971-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339421351-2971-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net, sshtylyov@mvista.com, bvanassche@acm.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Pankaj Kumar <pankaj.km@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 11 Jun 2012, Namjae Jeon wrote:

> Update information of Seagate Portable HDD and WD My Passport HDD in
> quirk list.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  drivers/usb/storage/unusual_devs.h |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
> index 1719886..64f0369 100644
> --- a/drivers/usb/storage/unusual_devs.h
> +++ b/drivers/usb/storage/unusual_devs.h
> @@ -1267,6 +1267,18 @@ UNUSUAL_DEV( 0x0af0, 0xd357, 0x0000, 0x0000,
>  		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>  		0 ),
>  
> +/* Reported by Namjae Jeon <namjae.jeon@samsung.com>
> + * Even though write cache is enabled by default,
> + * SCSI driver assume that cache is not enabled
> + * which in turn might lead to the loss of data
> + * since data still will be in cache.
> + * So this entry is needed for assuming that cache is enabled.
> + */

Please remove everything except the "Reported by" line.  The rest is 
obvious when we see the US_FL_WRITE_CACHE flag.

> +UNUSUAL_DEV(0x0bc2, 0x2300, 0x0000, 0x9999,
> +		"Seagate",
> +		"Portable HDD",
> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),
> +
>  /* Reported by Ben Efros <ben@pc-doctor.com> */
>  UNUSUAL_DEV( 0x0bc2, 0x3010, 0x0000, 0x0000,
>  		"Seagate",
> @@ -1468,6 +1480,18 @@ UNUSUAL_DEV(  0x1058, 0x0704, 0x0000, 0x9999,
>  		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>  		US_FL_SANE_SENSE),
>  
> +/* Reported by Namjae Jeon <namjae.jeon@samsung.com>
> + * Even though write cache is enabled by default,
> + * SCSI driver assume that cache is not enabled
> + * which in turn might lead to the loss of data
> + * since data still will be in cache.
> + * So this entry is needed for assuming that cache is enabled.
> + */

Same here.

> +UNUSUAL_DEV(0x1058, 0x070a, 0x0000, 0x9999,
> +		"Western Digital",
> +		"My Passport HDD",
> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),

Alan Stern
