Return-Path: <SRS0=+Znx=2C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53E2C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 05:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA1A42073D
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 05:40:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="lYYutyf1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfLLFk2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Dec 2019 00:40:28 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:49040 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfLLFk2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Dec 2019 00:40:28 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xBC5drRP090357;
        Wed, 11 Dec 2019 23:39:53 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1576129193;
        bh=3gRPp7QTPo2KX2Jgdg4xkb4upfF2WCRyDYht55ZZcFM=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=lYYutyf1HVfDfxyI4MVbUzwAuUZY9hiOJE882HhTHOThvNUGFXoM/OGlzAYAm/YIe
         YIO8xKjBNcuehcvWXhYSvYOEwEj//W6PeTNBADSGvTb7SRC6bjBOxC6do1iX2syYLC
         myAJCGpOmbdmzw+E7fmLe72kUv1z+9GMMTP5f/JM=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xBC5drQ8079608
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Dec 2019 23:39:53 -0600
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 11
 Dec 2019 23:39:53 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 11 Dec 2019 23:39:53 -0600
Received: from [172.24.145.136] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xBC5dkSB093209;
        Wed, 11 Dec 2019 23:39:47 -0600
Subject: Re: [PATCH v2 2/3] scsi: ufs: Modulize ufs-bsg
To:     Can Guo <cang@codeaurora.org>, <asutoshd@codeaurora.org>,
        <nguyenb@codeaurora.org>, <rnayak@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <kernel-team@android.com>,
        <saravanak@google.com>, <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef425ed74-071c2ec2-5aeb-44fa-8889-d9ec60192d44-000000@us-west-2.amazonses.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <c6a7f35f-289d-ff92-f8b1-e3e0731b30ab@ti.com>
Date:   Thu, 12 Dec 2019 11:10:15 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <0101016ef425ed74-071c2ec2-5aeb-44fa-8889-d9ec60192d44-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 11/12/19 2:19 pm, Can Guo wrote:
> In order to improve the flexibility of ufs-bsg, modulizing it is a good
> choice. This change introduces tristate to ufs-bsg to allow users compile
> it as an external module.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
[...]
> -int ufs_bsg_probe(struct ufs_hba *hba)
> +static int ufs_bsg_probe(struct ufs_hba *hba)
>  {
> -	struct device *bsg_dev = &hba->bsg_dev;
> +	struct device *bsg_dev;
>  	struct Scsi_Host *shost = hba->host;
>  	struct device *parent = &shost->shost_gendev;
>  	struct request_queue *q;
>  	int ret;
>  
> +	bsg_dev = kzalloc(sizeof(*bsg_dev), GFP_KERNEL);
> +	if (!bsg_dev)
> +		return -ENOMEM;
> +
> +	hba->bsg_dev = bsg_dev;
>  	device_initialize(bsg_dev);
>  
>  	bsg_dev->parent = get_device(parent);
> @@ -217,6 +225,41 @@ int ufs_bsg_probe(struct ufs_hba *hba)
>  
>  out:
>  	dev_err(bsg_dev, "fail to initialize a bsg dev %d\n", shost->host_no);
> +	hba->bsg_dev = NULL;

Don't we need to free the associated memory before assigning to NULL?
Alternatively can allocation be made with devm_ APIs instead?

>  	put_device(bsg_dev);
>  	return ret;
>  }
> +
> +static int __init ufs_bsg_init(void)
> +{
> +	struct list_head *hba_list = NULL;
> +	struct ufs_hba *hba;
> +	int ret = 0;
> +
> +	ufshcd_get_hba_list_lock(&hba_list);
> +	list_for_each_entry(hba, hba_list, list) {
> +		ret = ufs_bsg_probe(hba);
> +		if (ret)
> +			break;
> +	}

So IIUC, if ufs_bsg_probe() fails for one of the hba instances in the
list, then we fail to create bsg device for all remaining instances that
follow, which seems too harsh.

Regards
Vignesh

