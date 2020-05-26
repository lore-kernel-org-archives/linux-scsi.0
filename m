Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DFEC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 10:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C630F20787
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 10:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="K+o+pIws"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbgEZKH4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 06:07:56 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:39848 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgEZKH4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 06:07:56 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04QA7ohB041436;
        Tue, 26 May 2020 05:07:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590487670;
        bh=/BGWhUoahct9sPexqcQmvPETdyf33wnSqtAtsBi70aw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=K+o+pIwsWpDAwYncrxj06wp1KeJnaYO+yE0eMoSAU9EEttOTGLhvFoewTYSu7oZBS
         MgfEfxCfvqt+GvlNi+leq4+EzHf5dDz7RSporC3gG7eCgB8DH4FAX4p5BI/MQuzKRw
         FPAQ29aQV3mT5SnGbTPckvSmX+2qzv0u7BukvtwA=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04QA7oBn013718
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 26 May 2020 05:07:50 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 26
 May 2020 05:07:49 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 26 May 2020 05:07:49 -0500
Received: from [10.250.234.195] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04QA7kQr038590;
        Tue, 26 May 2020 05:07:46 -0500
Subject: Re: [PATCH] scsi: ufs: Fix runtime PM imbalance on error
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>, <kjlu@umn.edu>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200522045335.30556-1-dinghao.liu@zju.edu.cn>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <73cb87f7-52ac-1a18-364e-977080cc149c@ti.com>
Date:   Tue, 26 May 2020 15:37:45 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200522045335.30556-1-dinghao.liu@zju.edu.cn>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 22/05/20 10:23 am, Dinghao Liu wrote:
> When devm_clk_get() returns an error code, a pairing
> runtime PM usage counter decrement is needed to keep
> the counter balanced.
> 
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> ---

Thanks for the patch! But this fix is incomplete, I have posted 
a more comprehensive fix at [1].. Please take a look!

[1] https://lore.kernel.org/linux-scsi/20200526100340.15032-1-vigneshr@ti.com/T/#u

>  drivers/scsi/ufs/ti-j721e-ufs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/ufs/ti-j721e-ufs.c b/drivers/scsi/ufs/ti-j721e-ufs.c
> index 5216d228cdd9..f3f212f6f9a9 100644
> --- a/drivers/scsi/ufs/ti-j721e-ufs.c
> +++ b/drivers/scsi/ufs/ti-j721e-ufs.c
> @@ -39,6 +39,7 @@ static int ti_j721e_ufs_probe(struct platform_device *pdev)
>  	clk = devm_clk_get(dev, NULL);
>  	if (IS_ERR(clk)) {
>  		dev_err(dev, "Cannot claim MPHY clock.\n");
> +		pm_runtime_put_sync(dev);
>  		return PTR_ERR(clk);
>  	}
>  	clk_rate = clk_get_rate(clk);
> 


Regards
Vignesh
