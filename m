Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F22C64ED6
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 07:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjCAHFW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 02:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjCAHFV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 02:05:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4288938E8C;
        Tue, 28 Feb 2023 23:05:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFB0DB80F62;
        Wed,  1 Mar 2023 07:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3283C433D2;
        Wed,  1 Mar 2023 07:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677654316;
        bh=Al/hzYxPcRCS7bADT/4upQd1+LQPsshgrv4FzlQuAqE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o119JuOiXUBGz/aR+cbhSd1P84LqBk+owW5pTlnOzVA7hKAOHIb9rtlf9KXaJT8TX
         dNKkXOelNgAzI+4ZTFWNYKpQzajrrDjgKJpYypUjatUAtIRQEiwO8k4p3MWiCU1Oxn
         vmnwV1MkUI6eVP6xA/UBJBzNNe2TLRMtj4EKAB8OWwSHo3A0BEzKj9+Lw4VfFSreW6
         68oF45JXqecWuAY48DDSqzHeHiBkn7kPF5nZ6gErjXrH/IhHSbRsE6rRh/PF0AoNt3
         WQHmisCezMbHl9wRlxEb1X9BVv+jQZ2ijKqFr+74ha4x75LJuoccJzA36c14xyPjIp
         typfch/4qtWMw==
Date:   Wed, 1 Mar 2023 12:35:08 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Asutosh Das <quic_asutoshd@quicinc.com>
Cc:     quic_cang@quicinc.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, quic_nguyenb@quicinc.com,
        quic_xiaosenh@quicinc.com, stanley.chu@mediatek.com,
        adrian.hunter@intel.com, bvanassche@acm.org, avri.altman@wdc.com,
        beanhuo@micron.com, linux-arm-msm@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] ufs: mcq: qcom: Fix Smatch static checker warning
Message-ID: <20230301070508.GA5409@thinkpad>
References: <80523aada69f5cab90cac76c84aa153b1ea648ad.1677608784.git.quic_asutoshd@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <80523aada69f5cab90cac76c84aa153b1ea648ad.1677608784.git.quic_asutoshd@quicinc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 28, 2023 at 10:27:06AM -0800, Asutosh Das wrote:
> The patch (c263b4ef737e: "scsi: ufs: core: mcq: Configure resource
> regions") from Jan 13, 2023, leads to the following Smatch static
> checker warning:
> 
> drivers/ufs/host/ufs-qcom.c:1455 ufs_qcom_mcq_config_resource() warn:
> passing zero to 'PTR_ERR'
> drivers/ufs/host/ufs-qcom.c:1469 ufs_qcom_mcq_config_resource() info:
> returning a literal zero is cleaner
> 
> Fix the above warnings.
> 

You should not name the subject after the tool that used to find the issues.
Instead, subject should mention the actual issue like fixing return values,
removing the devm_kfree in error path etc...

Provided that, you should also split this patch into two as you are fixing
two independent issues.

Thanks,
Mani

> Fixes: c263b4ef737e ("scsi: ufs: core: mcq: Configure resource regions")
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Asutosh Das <quic_asutoshd@quicinc.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 34fc453f3eb1..cb20c7136c2c 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1451,8 +1451,8 @@ static int ufs_qcom_mcq_config_resource(struct ufs_hba *hba)
>  		if (IS_ERR(res->base)) {
>  			dev_err(hba->dev, "Failed to map res %s, err=%d\n",
>  					 res->name, (int)PTR_ERR(res->base));
> -			res->base = NULL;
>  			ret = PTR_ERR(res->base);
> +			res->base = NULL;
>  			return ret;
>  		}
>  	}
> @@ -1466,7 +1466,7 @@ static int ufs_qcom_mcq_config_resource(struct ufs_hba *hba)
>  	/* Explicitly allocate MCQ resource from ufs_mem */
>  	res_mcq = devm_kzalloc(hba->dev, sizeof(*res_mcq), GFP_KERNEL);
>  	if (!res_mcq)
> -		return ret;
> +		return -ENOMEM;
>  
>  	res_mcq->start = res_mem->start +
>  			 MCQ_SQATTR_OFFSET(hba->mcq_capabilities);
> @@ -1478,7 +1478,7 @@ static int ufs_qcom_mcq_config_resource(struct ufs_hba *hba)
>  	if (ret) {
>  		dev_err(hba->dev, "Failed to insert MCQ resource, err=%d\n",
>  			ret);
> -		goto insert_res_err;
> +		return ret;
>  	}
>  
>  	res->base = devm_ioremap_resource(hba->dev, res_mcq);
> @@ -1495,8 +1495,6 @@ static int ufs_qcom_mcq_config_resource(struct ufs_hba *hba)
>  ioremap_err:
>  	res->base = NULL;
>  	remove_resource(res_mcq);
> -insert_res_err:
> -	devm_kfree(hba->dev, res_mcq);
>  	return ret;
>  }
>  
> -- 
> 2.7.4
> 

-- 
மணிவண்ணன் சதாசிவம்
