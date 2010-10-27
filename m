From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH] scsi: hpsa: fix information leak to userland
Date: Wed, 27 Oct 2010 15:47:57 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77887D0E579A63@GVW0547EXC.americas.hpqcorp.net>
References: <1288194054-9276-1-git-send-email-segooon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:11327 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760749Ab0J0P4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2010 11:56:18 -0400
In-Reply-To: <1288194054-9276-1-git-send-email-segooon@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasiliy Kulikov <segooon@gmail.com>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, ISS StorageDev <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



> -----Original Message-----
> From: Vasiliy Kulikov [mailto:segooon@gmail.com]
> Sent: Wednesday, October 27, 2010 10:41 AM
> To: kernel-janitors@vger.kernel.org
> Cc: Stephen M. Cameron; James E.J. Bottomley; Miller, Mike (OS Dev);
> ISS StorageDev; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] scsi: hpsa: fix information leak to userland
> 
> Structure IOCTL_Command_struct is copied to userland with
> some padding fields at the end of the struct unitialized.
> It leads to leaking of contents of kernel stack memory.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
> 
>  drivers/scsi/hpsa.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index c5d0606..641a38c 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -2298,6 +2298,7 @@ static int hpsa_ioctl32_passthru(struct
> scsi_device *dev, int cmd, void *arg)
>  	int err;
>  	u32 cp;
> 
> +	memset(&arg64, 0, sizeof(arg64));
>  	err = 0;
>  	err |= copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
>  			   sizeof(arg64.LUN_info));
> @@ -2334,6 +2335,7 @@ static int hpsa_ioctl32_big_passthru(struct
> scsi_device *dev,
>  	int err;
>  	u32 cp;
> 
> +	memset(&arg64, 0, sizeof(arg64));
>  	err = 0;
>  	err |= copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
>  			   sizeof(arg64.LUN_info));
> --
> 1.7.0.4

Acked-by: Mike Milelr <mike.miller@hp.com>

