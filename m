From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 2/4] scsi_debug: fix logical block provisioning support
 when unmap_alignment != 0
Date: Mon, 19 Aug 2013 23:16:18 +0900
Message-ID: <CAC5umyh8+zBtKrpoFXdO+1D_5vOQS-P82LkocmaVY+FXb5YHRA@mail.gmail.com>
References: <1373889127-17083-1-git-send-email-akinobu.mita@gmail.com>
	<1373889127-17083-3-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:38849 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3HSOQV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Aug 2013 10:16:21 -0400
Received: by mail-oa0-f41.google.com with SMTP id j6so3636501oag.28
        for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2013 07:16:19 -0700 (PDT)
In-Reply-To: <1373889127-17083-3-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Hi Douglas, Martin,

Could you review this patch when you have a time?  I would like to
submit at least this patch 2/4, and 1/4 which has already been acked
by Douglas for the next merge window.

Although the patches 2/4 ~ 4/4 are all related to the logical block
provisioning support, the problems that fixed by 3/4 and 4/4 only
happen with virtual_gb option enabled, too.  On the other hand, the
problem that fixed by 2/4 is easily reproduced by, for example,
'modprobe scsi_debug lbpu=1 unmap_alignment=1 unmap_granularity=4'.
So the patch 2/4 has rather higher severity than others.

2013/7/15 Akinobu Mita <akinobu.mita@gmail.com>:
> Commit b90ebc3d5c41c9164ae04efd2e4f8204c2a186f1 ("[SCSI] scsi_debug:
> fix logical block provisioning support") fixed several issues with
> logical block provisioning support, but it still doesn't properly fix
> the cases when unmap_alignment > 0.  (for example, unmap_alignment=1
> and unmap_granularity=3)
>
> The problem is in map_index_to_lba(), which should return the first
> LBA which is corresponding to a given index of provisioning map
> (map_storep).
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/scsi_debug.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 2f39b13..01c0ffa 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -1997,8 +1997,14 @@ static unsigned long lba_to_map_index(sector_t lba)
>
>  static sector_t map_index_to_lba(unsigned long index)
>  {
> -       return index * scsi_debug_unmap_granularity -
> -               scsi_debug_unmap_alignment;
> +       sector_t lba = index * scsi_debug_unmap_granularity;
> +
> +       if (scsi_debug_unmap_alignment) {
> +               lba -= scsi_debug_unmap_granularity -
> +                       scsi_debug_unmap_alignment;
> +       }
> +
> +       return lba;
>  }
>
>  static unsigned int map_state(sector_t lba, unsigned int *num)
> --
> 1.8.3.1
>
