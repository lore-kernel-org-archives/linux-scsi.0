Return-Path: <SRS0=vR/u=Z4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CEF0C43603
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Dec 2019 15:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32DA824659
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Dec 2019 15:13:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="KCufpaE4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfLFPNk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Dec 2019 10:13:40 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:33372 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbfLFPNj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Dec 2019 10:13:39 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB6FDC3h046787;
        Fri, 6 Dec 2019 09:13:12 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575645192;
        bh=wWya3K6I8EFzGGNqXQjTcOmeLD3WYHW3qDVDi6nLJbM=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=KCufpaE4WIMA5BwrA97CtwnEFoA3jy7pfIPnJpQpjkhCh9s1Hxc+E0vpCORm60pOh
         FfTRzQNkKDTDpkfpvF0YRxTHhc+sJoIpR+TyslFY5Zt+Wz2TJoq+4hnV23V12tzZw1
         RY1xajLl1761LcF/9ricd29PclHqru9zh0JKjAn8=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB6FDCx9024589;
        Fri, 6 Dec 2019 09:13:12 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 6 Dec
 2019 09:13:12 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 6 Dec 2019 09:13:11 -0600
Received: from [10.250.133.44] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB6FD5Th021803;
        Fri, 6 Dec 2019 09:13:06 -0600
Subject: Re: [PATCH v2] scsi: ufs: Update L4 attributes on manual hibern8 exit
 in Cadence UFS.
To:     sheebab <sheebab@cadence.com>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <pedrom.sousa@synopsys.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <stanley.chu@mediatek.com>, <beanhuo@micron.com>,
        <yuehaibing@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <rafalc@cadence.com>, <mparab@cadence.com>
References: <1575606303-10917-1-git-send-email-sheebab@cadence.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <849dfea6-a2ba-2d52-cb16-733c767dbbbe@ti.com>
Date:   Fri, 6 Dec 2019 20:43:04 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1575606303-10917-1-git-send-email-sheebab@cadence.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 12/6/2019 9:55 AM, sheebab wrote:
> Backup L4 attributes duirng manual hibern8 entry
> and restore the L4 attributes on manual hibern8 exit as per JESD220C.
> 
> Signed-off-by: Sheeba B <sheebab@cadence.com>
> 
> Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

Tested-by: Vignesh Raghavendra <vigneshr@ti.com>


Regards
Vignesh
> ---
> v2:
> Dropped patch 1/2 for this series and rebased to include only manual hibernation fixes
> ---
>  drivers/scsi/ufs/cdns-pltfrm.c | 106 +++++++++++++++++++++++++++++++++
>  1 file changed, 106 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
> index 6feeb0faf123..1c80f9633da6 100644
> --- a/drivers/scsi/ufs/cdns-pltfrm.c
> +++ b/drivers/scsi/ufs/cdns-pltfrm.c
> @@ -19,6 +19,85 @@
>  
>  #define CDNS_UFS_REG_HCLKDIV	0xFC
>  #define CDNS_UFS_REG_PHY_XCFGD1	0x113C
> +#define CDNS_UFS_MAX_L4_ATTRS 12
> +
> +struct cdns_ufs_host {
> +	/**
> +	 * cdns_ufs_dme_attr_val - for storing L4 attributes
> +	 */
> +	u32 cdns_ufs_dme_attr_val[CDNS_UFS_MAX_L4_ATTRS];
> +};
> +
> +/**
> + * cdns_ufs_get_l4_attr - get L4 attributes on local side
> + * @hba: per adapter instance
> + *
> + */
> +static void cdns_ufs_get_l4_attr(struct ufs_hba *hba)
> +{
> +	struct cdns_ufs_host *host = ufshcd_get_variant(hba);
> +
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERDEVICEID),
> +		       &host->cdns_ufs_dme_attr_val[0]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERCPORTID),
> +		       &host->cdns_ufs_dme_attr_val[1]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_TRAFFICCLASS),
> +		       &host->cdns_ufs_dme_attr_val[2]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_PROTOCOLID),
> +		       &host->cdns_ufs_dme_attr_val[3]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_CPORTFLAGS),
> +		       &host->cdns_ufs_dme_attr_val[4]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_TXTOKENVALUE),
> +		       &host->cdns_ufs_dme_attr_val[5]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_RXTOKENVALUE),
> +		       &host->cdns_ufs_dme_attr_val[6]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_LOCALBUFFERSPACE),
> +		       &host->cdns_ufs_dme_attr_val[7]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERBUFFERSPACE),
> +		       &host->cdns_ufs_dme_attr_val[8]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_CREDITSTOSEND),
> +		       &host->cdns_ufs_dme_attr_val[9]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_CPORTMODE),
> +		       &host->cdns_ufs_dme_attr_val[10]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_CONNECTIONSTATE),
> +		       &host->cdns_ufs_dme_attr_val[11]);
> +}
> +
> +/**
> + * cdns_ufs_set_l4_attr - set L4 attributes on local side
> + * @hba: per adapter instance
> + *
> + */
> +static void cdns_ufs_set_l4_attr(struct ufs_hba *hba)
> +{
> +	struct cdns_ufs_host *host = ufshcd_get_variant(hba);
> +
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 0);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERDEVICEID),
> +		       host->cdns_ufs_dme_attr_val[0]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERCPORTID),
> +		       host->cdns_ufs_dme_attr_val[1]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS),
> +		       host->cdns_ufs_dme_attr_val[2]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PROTOCOLID),
> +		       host->cdns_ufs_dme_attr_val[3]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTFLAGS),
> +		       host->cdns_ufs_dme_attr_val[4]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_TXTOKENVALUE),
> +		       host->cdns_ufs_dme_attr_val[5]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_RXTOKENVALUE),
> +		       host->cdns_ufs_dme_attr_val[6]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_LOCALBUFFERSPACE),
> +		       host->cdns_ufs_dme_attr_val[7]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERBUFFERSPACE),
> +		       host->cdns_ufs_dme_attr_val[8]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CREDITSTOSEND),
> +		       host->cdns_ufs_dme_attr_val[9]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTMODE),
> +		       host->cdns_ufs_dme_attr_val[10]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE),
> +		       host->cdns_ufs_dme_attr_val[11]);
> +}
>  
>  /**
>   * Sets HCLKDIV register value based on the core_clk
> @@ -77,6 +156,22 @@ static int cdns_ufs_hce_enable_notify(struct ufs_hba *hba,
>  	return cdns_ufs_set_hclkdiv(hba);
>  }
>  
> +/**
> + * Called around hibern8 enter/exit.
> + * @hba: host controller instance
> + * @cmd: UIC Command
> + * @status: notify stage (pre, post change)
> + *
> + */
> +static void cdns_ufs_hibern8_notify(struct ufs_hba *hba, enum uic_cmd_dme cmd,
> +				    enum ufs_notify_change_status status)
> +{
> +	if (status == PRE_CHANGE && cmd == UIC_CMD_DME_HIBER_ENTER)
> +		cdns_ufs_get_l4_attr(hba);
> +	if (status == POST_CHANGE && cmd == UIC_CMD_DME_HIBER_EXIT)
> +		cdns_ufs_set_l4_attr(hba);
> +}
> +
>  /**
>   * Called before and after Link startup is carried out.
>   * @hba: host controller instance
> @@ -117,6 +212,14 @@ static int cdns_ufs_link_startup_notify(struct ufs_hba *hba,
>  static int cdns_ufs_init(struct ufs_hba *hba)
>  {
>  	int status = 0;
> +	struct cdns_ufs_host *host;
> +	struct device *dev = hba->dev;
> +
> +	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> +
> +	if (!host)
> +		return -ENOMEM;
> +	ufshcd_set_variant(hba, host);
>  
>  	if (hba->vops && hba->vops->phy_initialization)
>  		status = hba->vops->phy_initialization(hba);
> @@ -144,8 +247,10 @@ static int cdns_ufs_m31_16nm_phy_initialization(struct ufs_hba *hba)
>  
>  static const struct ufs_hba_variant_ops cdns_ufs_pltfm_hba_vops = {
>  	.name = "cdns-ufs-pltfm",
> +	.init = cdns_ufs_init,
>  	.hce_enable_notify = cdns_ufs_hce_enable_notify,
>  	.link_startup_notify = cdns_ufs_link_startup_notify,
> +	.hibern8_notify = cdns_ufs_hibern8_notify,
>  };
>  
>  static const struct ufs_hba_variant_ops cdns_ufs_m31_16nm_pltfm_hba_vops = {
> @@ -154,6 +259,7 @@ static const struct ufs_hba_variant_ops cdns_ufs_m31_16nm_pltfm_hba_vops = {
>  	.hce_enable_notify = cdns_ufs_hce_enable_notify,
>  	.link_startup_notify = cdns_ufs_link_startup_notify,
>  	.phy_initialization = cdns_ufs_m31_16nm_phy_initialization,
> +	.hibern8_notify = cdns_ufs_hibern8_notify,
>  };
>  
>  static const struct of_device_id cdns_ufs_of_match[] = {
> 
