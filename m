Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C14C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 00:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6374F206F2
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 00:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597192167;
	bh=kiXRkDKP4hQ4jadvGyuR/t2yeuUqrE4Jh9tgwknMefU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=FF+2BQGboNcIZ6/iArWyCOdSz+fyWg9+341yhorROWsC/ipGcsRvCkdmx+wesAxK/
	 C+UrDn3liPRL1VjldLkhIvkox9TnTdhnvhqt5yDdrPxSrxZp/posSTjbB4tLlQjmQI
	 KfsoorgW4xNpow4+KhZAqDiuTvTKzVbm+cApjbMQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgHLA3Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Aug 2020 20:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726221AbgHLA3Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Aug 2020 20:29:24 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F3D1206F2;
        Wed, 12 Aug 2020 00:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597192162;
        bh=kiXRkDKP4hQ4jadvGyuR/t2yeuUqrE4Jh9tgwknMefU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MkCAIemXaUr7Ue6tLTjfClBz/vamOZ9wT2HtpItC+40tqpL99lUoPAOO4Yx8F7UCB
         0YahAcYceYu9k+uHFL9bpeZwpUo8qHGXGUEA1A38fB+4ZSkJyYa/8S0H39/VrwHqei
         mPQE6cYbHPHhdx/QraxdBXTjM2GsHHe5knls0rxo=
Date:   Tue, 11 Aug 2020 17:29:20 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     robh@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, krzk@kernel.org, avri.altman@wdc.com,
        martin.petersen@oracle.com, kwmad.kim@samsung.com,
        stanley.chu@mediatek.com, cang@codeaurora.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com
Subject: Re: [RESEND PATCH v10 04/10] scsi: ufs: introduce
 UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk
Message-ID: <20200812002920.GA1352011@gmail.com>
References: <20200613024706.27975-1-alim.akhtar@samsung.com>
 <CGME20200613030445epcas5p4428da322cd9527d1075ff0f1ccc75d23@epcas5p4.samsung.com>
 <20200613024706.27975-5-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200613024706.27975-5-alim.akhtar@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Alim,

On Sat, Jun 13, 2020 at 08:17:00AM +0530, Alim Akhtar wrote:
> Some UFS host controllers like Exynos uses granularities of PRDT length and
> offset as bytes, whereas others uses actual segment count.
> 
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 30 +++++++++++++++++++++++-------
>  drivers/scsi/ufs/ufshcd.h |  6 ++++++
>  2 files changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ee30ed6cc805..ba093d0d0942 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2151,8 +2151,14 @@ static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  		return sg_segments;
>  
>  	if (sg_segments) {
> -		lrbp->utr_descriptor_ptr->prd_table_length =
> -			cpu_to_le16((u16)sg_segments);
> +
> +		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
> +			lrbp->utr_descriptor_ptr->prd_table_length =
> +				cpu_to_le16((sg_segments *
> +					sizeof(struct ufshcd_sg_entry)));
> +		else
> +			lrbp->utr_descriptor_ptr->prd_table_length =
> +				cpu_to_le16((u16) (sg_segments));
>  
>  		prd_table = (struct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
>  
> @@ -3500,11 +3506,21 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
>  				cpu_to_le32(upper_32_bits(cmd_desc_element_addr));
>  
>  		/* Response upiu and prdt offset should be in double words */
> -		utrdlp[i].response_upiu_offset =
> -			cpu_to_le16(response_offset >> 2);
> -		utrdlp[i].prd_table_offset = cpu_to_le16(prdt_offset >> 2);
> -		utrdlp[i].response_upiu_length =
> -			cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
> +		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN) {
> +			utrdlp[i].response_upiu_offset =
> +				cpu_to_le16(response_offset);
> +			utrdlp[i].prd_table_offset =
> +				cpu_to_le16(prdt_offset);
> +			utrdlp[i].response_upiu_length =
> +				cpu_to_le16(ALIGNED_UPIU_SIZE);
> +		} else {
> +			utrdlp[i].response_upiu_offset =
> +				cpu_to_le16(response_offset >> 2);
> +			utrdlp[i].prd_table_offset =
> +				cpu_to_le16(prdt_offset >> 2);
> +			utrdlp[i].response_upiu_length =
> +				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
> +		}
>  
>  		ufshcd_init_lrb(hba, &hba->lrb[i], i);
>  	}

Isn't this patch missing an update to ufshcd_print_trs()?  It uses
->prd_table_length as the number of segments, not the number of bytes.

- Eric
