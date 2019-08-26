Return-Path: <SRS0=IeCF=WW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD70C3A59F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 12:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23DFB217F5
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 12:07:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="HweVH68I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731378AbfHZMHm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Aug 2019 08:07:42 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:42980 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729961AbfHZMHm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2019 08:07:42 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x7QC7OvV051639;
        Mon, 26 Aug 2019 07:07:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1566821244;
        bh=tCXNjmhATrStRBQuVkSpDgDyQKbAcrP9nCBe2iY6MHk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=HweVH68IpZIYb26a+UAZiOlWFQhNCfV+2yVgdpfW+KIKzTd84n+vQcVyGccx8nGeY
         CKjN8T9yToh/w2snbrqTjVgRIukmfrue9Bi+dpExJAJhDZSWQPYhRjVMWX76P3+h5x
         W4oVIF/HG7YoceRw+xRFws7pF3V0LgJyll8MmzSM=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x7QC7OsL125832
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Aug 2019 07:07:24 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Mon, 26
 Aug 2019 07:07:24 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Mon, 26 Aug 2019 07:07:24 -0500
Received: from [172.24.145.136] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x7QC7I1O059086;
        Mon, 26 Aug 2019 07:07:19 -0500
Subject: Re: [PATCH v1] scsi: ufs: Disable local LCC in .link_startup_notify()
 in Cadence UFS
To:     Anil Varughese <aniljoy@cadence.com>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <pedrom.sousa@synopsys.com>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <hare@suse.de>,
        <rafalc@cadence.com>, <mparab@cadence.com>, <jank@cadence.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20190813074250.28177-1-aniljoy@cadence.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <ef91f93a-89d9-e49b-e9f3-dd5a9cd98b91@ti.com>
Date:   Mon, 26 Aug 2019 17:37:56 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813074250.28177-1-aniljoy@cadence.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 13/08/19 1:12 PM, Anil Varughese wrote:
> Some UFS devices have issues if LCC is enabled. So we
> are setting PA_LOCAL_TX_LCC_Enable to 0 before link
> startup which will make sure that both host and device
> TX LCC are disabled once link startup is completed.
> 
> Signed-off-by: Anil Varughese <aniljoy@cadence.com>> ---

Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>

Regards
Vignesh

>  drivers/scsi/ufs/cdns-pltfrm.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
> index 993519080..b2af04c57 100644
> --- a/drivers/scsi/ufs/cdns-pltfrm.c
> +++ b/drivers/scsi/ufs/cdns-pltfrm.c
> @@ -77,6 +77,31 @@ static int cdns_ufs_hce_enable_notify(struct ufs_hba *hba,
>  	return cdns_ufs_set_hclkdiv(hba);
>  }
>  
> +/**
> + * Called before and after Link startup is carried out.
> + * @hba: host controller instance
> + * @status: notify stage (pre, post change)
> + *
> + * Return zero for success and non-zero for failure
> + */
> +static int cdns_ufs_link_startup_notify(struct ufs_hba *hba,
> +					enum ufs_notify_change_status status)
> +{
> +	if (status != PRE_CHANGE)
> +		return 0;
> +
> +	/*
> +	 * Some UFS devices have issues if LCC is enabled.
> +	 * So we are setting PA_Local_TX_LCC_Enable to 0
> +	 * before link startup which will make sure that both host
> +	 * and device TX LCC are disabled once link startup is
> +	 * completed.
> +	 */
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
> +
> +	return 0;
> +}
> +
>  /**
>   * cdns_ufs_init - performs additional ufs initialization
>   * @hba: host controller instance
> @@ -114,12 +139,14 @@ static int cdns_ufs_m31_16nm_phy_initialization(struct ufs_hba *hba)
>  static const struct ufs_hba_variant_ops cdns_ufs_pltfm_hba_vops = {
>  	.name = "cdns-ufs-pltfm",
>  	.hce_enable_notify = cdns_ufs_hce_enable_notify,
> +	.link_startup_notify = cdns_ufs_link_startup_notify,
>  };
>  
>  static const struct ufs_hba_variant_ops cdns_ufs_m31_16nm_pltfm_hba_vops = {
>  	.name = "cdns-ufs-pltfm",
>  	.init = cdns_ufs_init,
>  	.hce_enable_notify = cdns_ufs_hce_enable_notify,
> +	.link_startup_notify = cdns_ufs_link_startup_notify,
>  	.phy_initialization = cdns_ufs_m31_16nm_phy_initialization,
>  };
>  
> 

-- 
Regards
Vignesh
