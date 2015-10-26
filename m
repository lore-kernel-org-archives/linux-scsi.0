From: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2 17/17] scsi: ufs-qcom: fix compilation warnings
Date: Mon, 26 Oct 2015 14:56:46 -0700
Message-ID: <562EA19E.2070007@codeaurora.org>
References: <1445874072-25909-1-git-send-email-ygardi@codeaurora.org>
 <1445874072-25909-18-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33301 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbbJZV4t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2015 17:56:49 -0400
In-Reply-To: <1445874072-25909-18-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>

On 10/26/2015 08:41 AM, Yaniv Gardi wrote:
> Tnis patch fixes the following compilation warnings:
> ...ufs-qcom.c:1201:40:
> 	warning: incorrect type in argument 1 (different address spaces)
> ...ufs-qcom.c:1201:40:
> 	expected void const *ptr
> ...ufs-qcom.c:1201:40:
> 	got void [noderef] <asn:2>*dev_ref_clk_ctrl_mmio
> ...ufs-qcom.c:1207:53:
> 	warning: incorrect type in argument 1 (different address spaces)
> ...ufs-qcom.c:1207:53:
> 	expected void const *ptr
> ...ufs-qcom.c:1207:53:
> 	got void [noderef] <asn:2>*dev_ref_clk_ctrl_mmio
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---

What version of sparse do you use? You shouldn't need to do this.

>  drivers/scsi/ufs/ufs-qcom.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 72b0ef7..b57f88a 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1226,11 +1226,12 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  		if (res) {
>  			host->dev_ref_clk_ctrl_mmio =
>  					devm_ioremap_resource(dev, res);
> -			if (IS_ERR(host->dev_ref_clk_ctrl_mmio)) {
> -				dev_warn(dev,
> -					"%s: could not map dev_ref_clk_ctrl_mmio, err %ld\n",
> +			if (IS_ERR((__force void const *)
> +				   host->dev_ref_clk_ctrl_mmio)) {
> +				dev_warn(dev, "%s: could not map dev_ref_clk_ctrl_mmio, err %ld\n",
>  					__func__,
> -					PTR_ERR(host->dev_ref_clk_ctrl_mmio));
> +					PTR_ERR((__force void const *)
> +						 host->dev_ref_clk_ctrl_mmio));
>  				host->dev_ref_clk_ctrl_mmio = NULL;
>  			}
>  			host->dev_ref_clk_en_mask = BIT(5);


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

