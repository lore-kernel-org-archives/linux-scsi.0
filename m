From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH] [SCSI] ufs: Assign UTRLBAU = upper_32_ bits(UTRLD base address)
Date: Tue, 24 Apr 2012 13:56:41 +0900
Message-ID: <CAKYAXd-aLSBvAGGRYmVDSBunBd8diAhzJ_PHmg7j+XbVbtde0g@mail.gmail.com>
References: <1335187331-2672-1-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41093 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2DXE4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Apr 2012 00:56:41 -0400
Received: by iadi9 with SMTP id i9so456934iad.19
        for <linux-scsi@vger.kernel.org>; Mon, 23 Apr 2012 21:56:41 -0700 (PDT)
In-Reply-To: <1335187331-2672-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, rene.dejong@arm.com, vinholikatti@gmail.com

2012/4/23 Santosh Y <santoshsy@gmail.com>:
> From: Santosh Yaraganavi <santoshsy@gmail.com>
>
> UTP Transfer request list base registers UTRLBA and UTRLBAU
> must be assigned, lower-32 and upper-32 bits of UTRLD list
> physical base addresses respectively.
>
> Currently UTRLBAU is being assigned lower-32 bits of UTRLD
> physical base address. This will cause an issue with
> controllers that can support 64-bit addressing.
>
> This patch correctly assigns upper-32 bits of UTRLD physical
> base address to UTRLBAU.
Hi. Santosh.
0 : 9 bits are reserved in UTRLBA of specification. is it considered al=
so ?
Thanks.

>
> Reported-by: Rene De Jong <rene.dejong@arm.com>
> Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
> Reviewed-by: Vinayak Holikatti <vinholikatti@gmail.com>
> ---
> =C2=A0drivers/scsi/ufs/ufshcd.c | =C2=A0 =C2=A06 +++---
> =C2=A01 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 52b96e8..ea32ade 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1032,11 +1032,11 @@ static int ufshcd_initialize_hba(struct ufs_h=
ba *hba)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EIO;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Configure UTRL and UTMRL base address r=
egisters */
> - =C2=A0 =C2=A0 =C2=A0 writel(hba->utrdl_dma_addr,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(hba->mmio_base + R=
EG_UTP_TRANSFER_REQ_LIST_BASE_L));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0writel(lower_32_bits(hba->utrdl_dma_addr),
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(hba->mmio_base + R=
EG_UTP_TRANSFER_REQ_LIST_BASE_L));
> + =C2=A0 =C2=A0 =C2=A0 writel(upper_32_bits(hba->utrdl_dma_addr),
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (hba->mmio_base + RE=
G_UTP_TRANSFER_REQ_LIST_BASE_H));
> - =C2=A0 =C2=A0 =C2=A0 writel(hba->utmrdl_dma_addr,
> + =C2=A0 =C2=A0 =C2=A0 writel(lower_32_bits(hba->utmrdl_dma_addr),
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (hba->mmio_base + RE=
G_UTP_TASK_REQ_LIST_BASE_L));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0writel(upper_32_bits(hba->utmrdl_dma_addr)=
,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (hba->mmio_base + RE=
G_UTP_TASK_REQ_LIST_BASE_H));
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
