Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E600EC2BA1E
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3DD264EDB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447020AbhCCMrb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:47:31 -0500
Received: from z11.mailgun.us ([104.130.96.11]:35355 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1449264AbhCCKUG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Mar 2021 05:20:06 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614766783; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=wj9yRsgWncKIVARUwCuj7pr3e/bua+APomfcTLjUaCM=;
 b=ejIu4MsXLgG3BDvjamq+4gmDBUdF5oS/p8Hb/cJ0p4GlKN5K1OvUBNV8hEWegQt958NplzRh
 i6OoFoGOyvmmhk/laSJYejW/Sz08YJpHtDeLMBdplAUk/nCGixjvrwlGOSXMKp4a/eLSuQEP
 KhhvfTEbQ95SvaFJ+O7PIL8AZi4=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 603f5f5639ef37211490cf5b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 03 Mar 2021 10:05:10
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D6EC5C43462; Wed,  3 Mar 2021 10:05:10 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E4384C433CA;
        Wed,  3 Mar 2021 10:05:07 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 03 Mar 2021 18:05:07 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH] scsi: ufs: Fix incorrect ufshcd_state after
 ufshcd_reset_and_restore()
In-Reply-To: <20210301191940.15247-1-adrian.hunter@intel.com>
References: <20210301191940.15247-1-adrian.hunter@intel.com>
Message-ID: <d3298a76c4b7b77f159c4bf362b5c9f2@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-02 03:19, Adrian Hunter wrote:
> If ufshcd_probe_hba() fails it sets ufshcd_state to UFSHCD_STATE_ERROR,
> however, if it is called again, as it is within a loop in
> ufshcd_reset_and_restore(), and succeeds, then it will not set the 
> state
> back to UFSHCD_STATE_OPERATIONAL unless the state was
> UFSHCD_STATE_RESET.
> 
> That can result in the state being UFSHCD_STATE_ERROR even though
> ufshcd_reset_and_restore() is successful and returns zero.
> 
> Fix by initializing the state to UFSHCD_STATE_RESET in the start of 
> each
> loop in ufshcd_reset_and_restore().  If there is an error,
> ufshcd_reset_and_restore() will change the state to UFSHCD_STATE_ERROR,
> otherwise ufshcd_probe_hba() will have set the state appropriately.
> 
> Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and
> other error recovery paths")
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 77161750c9fb..91a403afe038 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7031,6 +7031,8 @@ static int ufshcd_reset_and_restore(struct 
> ufs_hba *hba)
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> 
>  	do {
> +		hba->ufshcd_state = UFSHCD_STATE_RESET;
> +
>  		/* Reset the attached device */
>  		ufshcd_device_reset(hba);

Hi Adrian,

I've proposed a fix to get it addressed - 
https://lore.kernel.org/patchwork/patch/1383817/

Thanks,

Can Guo.
