From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] scsi: ufs: enable no_write_same for ufs
Date: Fri, 8 May 2015 22:33:44 +0900
Message-ID: <CAC5umyisxmQh9=vKDHPf5gcjF0-u8m8=rbpZTyaVZN6AbsLBEw@mail.gmail.com>
References: <1431003981-7106-1-git-send-email-kyuho.choi@sk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:36380 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbbEHNdq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2015 09:33:46 -0400
Received: by lbbqq2 with SMTP id qq2so53252249lbb.3
        for <linux-scsi@vger.kernel.org>; Fri, 08 May 2015 06:33:45 -0700 (PDT)
In-Reply-To: <1431003981-7106-1-git-send-email-kyuho.choi@sk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kyuho Choi <chlrbgh0@gmail.com>
Cc: vinayak holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kyuho Choi <kyuho.choi@sk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Hi Kyuho,

2015-05-07 22:06 GMT+09:00 Kyuho Choi <chlrbgh0@gmail.com>:
> This patch disables write_same for ufs.
>
> Signed-off-by: Kyuho Choi <kyuho.choi@sk.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 648a446..6f770cd 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4255,6 +4255,7 @@ static struct scsi_host_template ufshcd_driver_template = {
>         .max_host_blocked       = 1,
>         .use_blk_tags           = 1,
>         .track_queue_depth      = 1,
> +       .no_write_same          = 1,
>  };

Is there any specific reason to disable WRITE_SAME in the host
controller level?

no_write_same flag in scsi_host_template was introduced by commit
54b2b50c ("[SCSI] Disable WRITE SAME for RAID and virtual host adapter
drivers") for RAID and virtual host adapter drivers which can lead
to adapter firmware hangs or excessive I/O errors.

The UFS device that does not support WRITE SAME should return
ILLEGAL_REQUEST sense key (and with INVALID COMMAND OPCODE code for
example).  If there is a specific product model/revision which causes
an undesirable result by WRITE_SAME, we should disable only when
such device is detected.  Otherwise I think this patch could conflict
with any attempts to support WRITE SAME by some vendors who want it in
their products or future UFS specification change.
