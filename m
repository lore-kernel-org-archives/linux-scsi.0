From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: kernel BUG at block/bio.c:1787! while initializing scsi_debug on
 ppc64 host
Date: Wed, 16 Dec 2015 09:17:43 +0800
Message-ID: <CACVXFVPEK4TM9XtY-WGs=9--3NvxpsO8au+L2ex5xKKpHpdM-g@mail.gmail.com>
References: <20151211115340.GB19209@eguan.usersys.redhat.com>
	<20151215112057.GC19209@eguan.usersys.redhat.com>
	<CACVXFVOPgONuXjGhBnFVxuRVr+=LFe36QR-VTGVvTkEK+V0JLw@mail.gmail.com>
	<20151215130631.GD19209@eguan.usersys.redhat.com>
	<yq1egenwons.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:33933 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800AbbLPBRo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2015 20:17:44 -0500
Received: by mail-wm0-f53.google.com with SMTP id l126so18714427wml.1
        for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2015 17:17:44 -0800 (PST)
In-Reply-To: <yq1egenwons.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Linux SCSI List <linux-scsi@vger.kernel.org>

On Wed, Dec 16, 2015 at 2:29 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Eryu" == Eryu Guan <guaneryu@gmail.com> writes:
>
> Eryu,
>
> Does the patch below fix the issue?

No, it can't.

As the debug log shows, it is because you use 'OPTIMAL
TRANSFER LENGTH' to set queue's max_sectors.

Thanks,

>
> --
> Martin K. Petersen      Oracle Linux Engineering
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3d22fc3e3c1a..d1eb7aa78b8d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2667,8 +2667,9 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
>
>         if (buffer[3] == 0x3c) {
>                 unsigned int lba_count, desc_count;
> +               u64 max_ws = get_unaligned_be64(&buffer[36]);
>
> -               sdkp->max_ws_blocks = (u32)get_unaligned_be64(&buffer[36]);
> +               sdkp->max_ws_blocks = (u32)max_ws;
>
>                 if (!sdkp->lbpme)
>                         goto out;



-- 
Ming Lei
