Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81166C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Feb 2023 07:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjBPHlB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Feb 2023 02:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBPHlA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2023 02:41:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567243A875;
        Wed, 15 Feb 2023 23:40:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0F1E61EB0;
        Thu, 16 Feb 2023 07:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F04C433D2;
        Thu, 16 Feb 2023 07:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676533258;
        bh=CsjYBJv3KoyajR+dTDD6EPW6J8/wsE97iPGoBTCmLjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=asoBJcP4g5hiqe6+H63ficVX5ZhIUHvvvRqgP/o21FJASYhO+1Q0dELVGFI3Of2+7
         czmYWZd+RqRnQRT8PJJgScEeKS5aJvlxx9qiuL2z5NOfeNUy5RQBmeB4oyrK47Y78B
         WTL+PMlJkVxcIqKoy1977rXuV7I5EOtKreScHcDwtPEQkfyMeItcPiDFIwVttVBmpN
         zcssRomtuKczYGSQc/jBu4qOGj/TocjNzf4eqYd/Vlo5GWaNY0BAh+SRYORWX2BHpj
         gqsOC9hKXvLPXIIxuWP6NTtO5EyRmSUcVgloTCQxaI3rqUZ0EIrSurOeM2AQ1PLPNc
         li1Edq5IRJ7KQ==
Date:   Thu, 16 Feb 2023 13:10:40 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Po-Wen Kao <powen.kao@mediatek.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        wsd_upstream@mediatek.com, peter.wang@mediatek.com,
        stanley.chu@mediatek.com, alice.chao@mediatek.com,
        chun-hung.wu@mediatek.com, cc.chou@mediatek.com,
        chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
        mason.zhang@mediatek.com, quic_asutoshd@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 1/2] scsi: ufs: core: Fix mcq tag calcualtion
Message-ID: <20230216074040.GB2420@thinkpad>
References: <20230215123750.15785-1-powen.kao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230215123750.15785-1-powen.kao@mediatek.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 15, 2023 at 08:37:45PM +0800, Po-Wen Kao wrote:
> Transfer command descriptor is allocated in ufshcd_memory_alloc()
> and referenced by transfer request descriptor with stride size
> sizeof_utp_transfer_cmd_desc()
> instead of
> sizeof(struct utp_transfer_cmd_desc).
> 
> Consequently, computing tag by address offset should also refer to the
> same stride.
> 
> Signed-off-by: Po-Wen Kao <powen.kao@mediatek.com>

Fixes tag?

> ---
>  drivers/ufs/core/ufs-mcq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 31df052fbc41..3a27fa4b0024 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -265,7 +265,7 @@ static int ufshcd_mcq_get_tag(struct ufs_hba *hba,
>  	addr = (le64_to_cpu(cqe->command_desc_base_addr) & CQE_UCD_BA) -
>  		hba->ucdl_dma_addr;
>  
> -	return div_u64(addr, sizeof(struct utp_transfer_cmd_desc));
> +	return div_u64(addr, sizeof_utp_transfer_cmd_desc(hba));

I think it is not a good practice to name variables after the standard
operators like sizeof(). It is confusing at its best.

How about renaming this function to get_ucd_size() or something relevant?

But the change itself LGTM!

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

Thanks,
Mani

>  }
>  
>  static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
> -- 
> 2.18.0
> 

-- 
மணிவண்ணன் சதாசிவம்
