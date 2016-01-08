From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH] megaraid:Fix possible NULL pointer deference in mraid_mm_ioctl
Date: Fri, 8 Jan 2016 16:35:33 +0530
Message-ID: <a15502eb3124eb63ab54a50031e587d8@mail.gmail.com>
References: <1452022374-20206-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:32832 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbcAHLFg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2016 06:05:36 -0500
Received: by mail-lf0-f41.google.com with SMTP id m198so25540329lfm.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Jan 2016 03:05:35 -0800 (PST)
In-Reply-To: <1452022374-20206-1-git-send-email-xerofoify@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>, Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Uday Lingala <uday.lingala@avagotech.com>, JBottomley@odin.com, martin.petersen@oracle.com, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Nicholas Krause [mailto:xerofoify@gmail.com]
> Sent: Wednesday, January 06, 2016 1:03 AM
> To: kashyap.desai@avagotech.com
> Cc: sumit.saxena@avagotech.com; uday.lingala@avagotech.com;
> JBottomley@odin.com; martin.petersen@oracle.com;
> megaraidlinux.pdl@avagotech.com; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] megaraid:Fix possible NULL pointer deference in
> mraid_mm_ioctl
>
> This adds the needed check after the call to the function
mraid_mm_alloc_kioc
> in order to make sure that this function has not returned NULL and
therefore
> makes sure we do not deference a NULL pointer if one is returned by
> mraid_mm_alloc_kioc.
> Further more add needed comments explaining that this function call can
return
> NULL if the list head is empty for the pointer passed in order to allow
furture
> users to understand this required pointer check.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/scsi/megaraid/megaraid_mm.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/scsi/megaraid/megaraid_mm.c
> b/drivers/scsi/megaraid/megaraid_mm.c
> index a706927..215ddbc 100644
> --- a/drivers/scsi/megaraid/megaraid_mm.c
> +++ b/drivers/scsi/megaraid/megaraid_mm.c
> @@ -179,8 +179,12 @@ mraid_mm_ioctl(struct file *filep, unsigned int
cmd,
> unsigned long arg)
>
>  	/*
>  	 * The following call will block till a kioc is available
> +	 * or return NULL if the list head is empty for the pointer
> +	 * of type mraid_mmapt passed to mraid_mm_alloc_kioc
>  	 */
>  	kioc = mraid_mm_alloc_kioc(adp);
> +	if (!kioc)
> +		return -ENXIO;
>
>  	/*
>  	 * User sent the old mimd_t ioctl packet. Convert it to uioc_t.

Acked-by: Sumit Saxena <sumit.saxena@avagotech.com>

> --
> 2.5.0
