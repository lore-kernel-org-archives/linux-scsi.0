Return-Path: <SRS0=+pba=Z2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9167EC43603
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 13:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6053420803
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 13:36:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Le1QT0gf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfLDNgV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 08:36:21 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:53522 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbfLDNgU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2019 08:36:20 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB4DZgfg076462;
        Wed, 4 Dec 2019 07:35:42 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575466542;
        bh=xCS1lfwtIPofr9BfV2xLTa/QhcNCHCI0ym0C/edSDAw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Le1QT0gfKf0J1Zmr9pgZT9X4k12QhPopGG8dlQQnQX17lGcjpYaQEaHQIDQIuB5SZ
         Nau+DeyJIwhRkh8TnJxm2B8csKx1i7fkqPQeKFe6wB/yfcqY/zD+yUO53XMcrzdyz6
         FvNdmCsdCiPdp3KBEcryhCKib2EYO0TMAtA5OIg4=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB4DZg7J115194;
        Wed, 4 Dec 2019 07:35:42 -0600
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 4 Dec
 2019 07:35:42 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 4 Dec 2019 07:35:42 -0600
Received: from [172.24.145.136] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB4DZcZa084113;
        Wed, 4 Dec 2019 07:35:38 -0600
Subject: Re: [PATCH] scsi: ufs: Disable autohibern8 feature in Cadence UFS
To:     sheebab <sheebab@cadence.com>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <pedrom.sousa@synopsys.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <stanley.chu@mediatek.com>, <beanhuo@micron.com>,
        <yuehaibing@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <mparab@cadence.com>, <rafalc@cadence.com>
References: <1575367635-22662-1-git-send-email-sheebab@cadence.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <38cfe842-c07a-410f-97f1-f2bf13fd2655@ti.com>
Date:   Wed, 4 Dec 2019 19:06:09 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <1575367635-22662-1-git-send-email-sheebab@cadence.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 03/12/19 3:37 pm, sheebab wrote:
> This patch disables autohibern8 feature in Cadence UFS. 
> The autohibern8 feature has issues due to which unexpected interrupt
> trigger is happening. After the interrupt issue is sorted out autohibern8
> feature will be re-enabled
> 
> Signed-off-by: sheebab <sheebab@cadence.com>
> ---

Tested-by: Vignesh Raghavendra <vigneshr@ti.com>

You will have to repost patch 2/2[1] of your previous series as that
patch no longer applies cleanly anymore given that we no longer want 1/2
to be merged.

[1]
https://lore.kernel.org/linux-scsi/1574147082-22725-3-git-send-email-sheebab@cadence.com/


>  drivers/scsi/ufs/cdns-pltfrm.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
> index b2af04c57a39..882425d1166b 100644
> --- a/drivers/scsi/ufs/cdns-pltfrm.c
> +++ b/drivers/scsi/ufs/cdns-pltfrm.c
> @@ -98,6 +98,12 @@ static int cdns_ufs_link_startup_notify(struct ufs_hba *hba,
>  	 * completed.
>  	 */
>  	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
> +
> +	/*
> +	 * Disabling Autohibern8 feature in cadence UFS
> +	 * to mask unexpected interrupt trigger.
> +	 */
> +	hba->ahit = 0;
>  
>  	return 0;
>  }
> 

-- 
Regards
Vignesh
