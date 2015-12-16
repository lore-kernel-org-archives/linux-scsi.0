From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: kernel BUG at block/bio.c:1787! while initializing scsi_debug on
 ppc64 host
Date: Wed, 16 Dec 2015 15:25:42 +0800
Message-ID: <20151216071608.GG19209@eguan.usersys.redhat.com>
References: <20151211115340.GB19209@eguan.usersys.redhat.com>
 <20151215112057.GC19209@eguan.usersys.redhat.com>
 <CACVXFVOPgONuXjGhBnFVxuRVr+=LFe36QR-VTGVvTkEK+V0JLw@mail.gmail.com>
 <20151215130631.GD19209@eguan.usersys.redhat.com>
 <yq1egenwons.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35122 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637AbbLPH0t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 02:26:49 -0500
Received: by mail-pa0-f42.google.com with SMTP id hk6so19184357pad.2
        for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2015 23:26:49 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <yq1egenwons.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Linux SCSI List <linux-scsi@vger.kernel.org>

On Tue, Dec 15, 2015 at 01:29:59PM -0500, Martin K. Petersen wrote:
> >>>>> "Eryu" == Eryu Guan <guaneryu@gmail.com> writes:
> 
> Eryu,
> 
> Does the patch below fix the issue?

Unfortunately no, still BUG_ON.

Thanks,
Eryu

> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3d22fc3e3c1a..d1eb7aa78b8d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2667,8 +2667,9 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
>  
>  	if (buffer[3] == 0x3c) {
>  		unsigned int lba_count, desc_count;
> +		u64 max_ws = get_unaligned_be64(&buffer[36]);
>  
> -		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&buffer[36]);
> +		sdkp->max_ws_blocks = (u32)max_ws;
>  
>  		if (!sdkp->lbpme)
>  			goto out;
