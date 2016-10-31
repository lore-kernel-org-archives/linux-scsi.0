From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v3 04/12] phy: qcom-ufs-14nm: Add new compatible for
 msm8996 based phy
Date: Mon, 31 Oct 2016 14:11:38 -0700
Message-ID: <bee1a974145c606c40d61781fc2f3c9c@codeaurora.org>
References: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
 <1477772534-14170-5-git-send-email-vivek.gautam@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37274 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S946933AbcJaVLk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2016 17:11:40 -0400
In-Reply-To: <1477772534-14170-5-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, sboyd@codeaurora.org, ygardi@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org

On 2016-10-29 13:22, Vivek Gautam wrote:
> Add a new compatible string for 14nm ufs phy present on msm8996
> chipset. This phy is bit different from the legacy 14nm ufs phy
> in terms of the clocks that are needed to be handled in the driver.
> 
> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
> ---
> 
> New patch in v3 of this cleanup series.
> 
>  Documentation/devicetree/bindings/ufs/ufs-qcom.txt | 7 +++++--
>  drivers/phy/phy-qcom-ufs-qmp-14nm.c                | 1 +
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-qcom.txt
> b/Documentation/devicetree/bindings/ufs/ufs-qcom.txt
> index 070baf4..b6b5130 100644
> --- a/Documentation/devicetree/bindings/ufs/ufs-qcom.txt
> +++ b/Documentation/devicetree/bindings/ufs/ufs-qcom.txt
> @@ -7,8 +7,11 @@ To bind UFS PHY with UFS host controller, the
> controller node should
>  contain a phandle reference to UFS PHY node.
> 
>  Required properties:
> -- compatible        : compatible list, contains 
> "qcom,ufs-phy-qmp-20nm"
> -		      or "qcom,ufs-phy-qmp-14nm" according to the relevant phy in 
> use.
> +- compatible        : compatible list, contains one of the following -
> +			"qcom,ufs-phy-qmp-20nm" for 20nm ufs phy,
> +			"qcom,ufs-phy-qmp-14nm" for legacy 14nm ufs phy,
> +			"qcom,msm8996-ufs-phy-qmp-14nm" for 14nm ufs phy
> +			 present on MSM8996 chipset.

For future chipsets (after MSM8996), we have to use this same compatible 
strings? If yes, "msm8996" in compatible string name may cause 
confusions? may be we should start following v1/v2/... terminologies for 
this?
something like "qcom,ufs-phy-qmp-v2" to start with?

>  - reg               : should contain PHY register address space 
> (mandatory),
>  - reg-names         : indicates various resources passed to driver
> (via reg proptery) by name.
>                        Required "reg-names" is "phy_mem".
> diff --git a/drivers/phy/phy-qcom-ufs-qmp-14nm.c
> b/drivers/phy/phy-qcom-ufs-qmp-14nm.c
> index e3bede7..b3d2612 100644
> --- a/drivers/phy/phy-qcom-ufs-qmp-14nm.c
> +++ b/drivers/phy/phy-qcom-ufs-qmp-14nm.c
> @@ -180,6 +180,7 @@ static int ufs_qcom_phy_qmp_14nm_remove(struct
> platform_device *pdev)
> 
>  static const struct of_device_id ufs_qcom_phy_qmp_14nm_of_match[] = {
>  	{.compatible = "qcom,ufs-phy-qmp-14nm"},
> +	{.compatible = "qcom,msm8996-ufs-phy-qmp-14nm"},
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, ufs_qcom_phy_qmp_14nm_of_match);

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
