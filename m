From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH v3 3/3] usb: storage: update usb devices for write cache
 quirk in quirk list.
Date: Sat, 09 Jun 2012 22:44:40 +0400
Message-ID: <4FD39998.4020903@mvista.com>
References: <1339263678-4075-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39639 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755386Ab2FISqA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jun 2012 14:46:00 -0400
Received: by lahd3 with SMTP id d3so1968406lah.19
        for <linux-scsi@vger.kernel.org>; Sat, 09 Jun 2012 11:45:58 -0700 (PDT)
In-Reply-To: <1339263678-4075-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu, bvanassche@acm.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Pankaj Kumar <pankaj.km@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>

Hello.

On 06/09/2012 09:41 PM, Namjae Jeon wrote:

> Update information of Seagate Portable HDD and WD My Passport HDD in
> quirk list.

> Signed-off-by: Namjae Jeon<namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar<pankaj.km@samsung.com>
> Signed-off-by: Amit Sahrawat<a.sahrawat@samsung.com>
> ---
>   drivers/usb/storage/unusual_devs.h |   24 ++++++++++++++++++++++++
>   1 file changed, 24 insertions(+)

> diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
> index 1719886..64f0369 100644
> --- a/drivers/usb/storage/unusual_devs.h
> +++ b/drivers/usb/storage/unusual_devs.h
> @@ -1267,6 +1267,18 @@ UNUSUAL_DEV( 0x0af0, 0xd357, 0x0000, 0x0000,
>   		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>   		0 ),
>
> +/* Reported by Namjae Jeon<namjae.jeon@samsung.com>
> + * Even though write cache is enabled by default,
> + * SCSI driver assume that cache is not enabled
> + * which in turn might lead loss of data
                               ^ to the

> + * since data still will be in cache.
> + * So this entry is needed for assuming that cache is enabled.
> + */
> +UNUSUAL_DEV(0x0bc2, 0x2300, 0x0000, 0x9999,
> +		"Seagate",
> +		"Portable HDD",
> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),
> +
>   /* Reported by Ben Efros<ben@pc-doctor.com>  */
>   UNUSUAL_DEV( 0x0bc2, 0x3010, 0x0000, 0x0000,
>   		"Seagate",
> @@ -1468,6 +1480,18 @@ UNUSUAL_DEV(  0x1058, 0x0704, 0x0000, 0x9999,
>   		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>   		US_FL_SANE_SENSE),
>
> +/* Reported by Namjae Jeon<namjae.jeon@samsung.com>
> + * Even though write cache is enabled by default,
> + * SCSI driver assume that cache is not enabled
> + * which in turn might lead loss of data
                               ^ to the

WBR, Sergei
