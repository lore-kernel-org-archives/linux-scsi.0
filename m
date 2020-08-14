Return-Path: <SRS0=qkKg=BY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CF9C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 09:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2E4520781
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 09:28:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="eKGPcGeB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgHNJ2l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Aug 2020 05:28:41 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:26715 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgHNJ2k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Aug 2020 05:28:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597397320; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=J9GOjecEvlxXTNYvre81uurmGdRyGcLvJz15EEp+TWM=;
 b=eKGPcGeBHfUC3vElFPaH6tKI7lgATFcfjVyIRtcT2aknu5iDbUGJyjOxdWZ5SbRE2AYNVDZI
 VKPoSz/GgbQmk5ept+Tnunbkm4Bzje8ZVXfMDJPw0wmjgNzH+aIqpMCfkXhBC4Es1uZuLXw+
 AL8euJbuwfXTYbs8j+oEa7eVfps=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5f3659162b87d6604964c0b0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 14 Aug 2020 09:27:50
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A9834C433AD; Fri, 14 Aug 2020 09:27:48 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ADF36C433C6;
        Fri, 14 Aug 2020 09:27:47 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 14 Aug 2020 17:27:47 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] scsi: ufs: no need to send one Abort Task TM in
 case the task in DB was cleared
In-Reply-To: <20200811141859.27399-3-huobean@gmail.com>
References: <20200811141859.27399-1-huobean@gmail.com>
 <20200811141859.27399-3-huobean@gmail.com>
Message-ID: <50ed9345dc9873fcfb84f3b919eda7f8@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-11 22:18, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> If the bit corresponds to a task in the Doorbell register has been
> cleared, no need to poll the status of the task on the device side
> and to send an Abort Task TM. Instead, let it directly goto cleanup.
> 
> Meanwhile, to keep original debug print, move this goto below the debug
> print.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufshcd.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 66fe814c8725..5f09cda7b21c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6434,14 +6434,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  		goto out;
>  	}
> 
> -	if (!(reg & (1 << tag))) {
> -		dev_err(hba->dev,
> -		"%s: cmd was completed, but without a notifying intr, tag = %d",
> -		__func__, tag);
> -	}
> -
>  	/* Print Transfer Request of aborted task */
> -	dev_err(hba->dev, "%s: Device abort task at tag %d\n", __func__, 
> tag);
> +	dev_info(hba->dev, "%s: Device abort task at tag %d\n", __func__, 
> tag);
> 
>  	/*
>  	 * Print detailed info about aborted request.
> @@ -6462,6 +6456,13 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  	}
>  	hba->req_abort_count++;
> 
> +	if (!(reg & (1 << tag))) {
> +		dev_err(hba->dev,
> +		"%s: cmd was completed, but without a notifying intr, tag = %d",
> +		__func__, tag);
> +		goto cleanup;
> +	}
> +
>  	/* Skip task abort in case previous aborts failed and report failure 
> */
>  	if (lrbp->req_abort_skip) {
>  		err = -EIO;
