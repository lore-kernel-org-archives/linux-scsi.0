Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A31C433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 00:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E94461177
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 00:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhEGAEa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 20:04:30 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:58227 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbhEGAE3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2021 20:04:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620345811; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=0z7zklnl0fN63Vk52TLw4N5ArrkclZXIhp4SHb4ntAQ=;
 b=aDrGguaMTj/T0NDR3S5oSPC4ET89Gosf8zbX98Y6/ni/xBO2Jf5eIJ0sVFpBU3D99U0GkSp1
 REx6pM/w+6sPiDaNcgLQGAd0q00KcRzhGgYM4xYJwqlEIrR5D91hY/ual5XDcKSKpYf6iKv0
 6Ekx8ahXsqq45WrmTpNeWhfdaKM=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 609483bb87ce1fbb5634af35 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 07 May 2021 00:03:07
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B010FC43145; Fri,  7 May 2021 00:03:06 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 91750C433D3;
        Fri,  7 May 2021 00:03:04 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 07 May 2021 08:03:04 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Don Brace <don.brace@microchip.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: Re: [PATCH 101/117] ufs: Remove an assignment from
 ufshcd_transfer_rsp_status()
In-Reply-To: <20210420021402.27678-11-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420021402.27678-11-bvanassche@acm.org>
Message-ID: <962568efd99f3bf7c9e650321304011b@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-20 10:13, Bart Van Assche wrote:
> Since a later patch will change the type of the 'result' variable, use 
> this
> variable only for one purpose.
> 
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 391947e4db72..d966d80838fb 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4947,9 +4947,8 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
> 
>  	switch (ocs) {
>  	case OCS_SUCCESS:
> -		result = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
>  		hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
> -		switch (result) {
> +		switch (ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr)) {
>  		case UPIU_TRANSACTION_RESPONSE:
>  			/* Propagate the SCSI status to the SCSI midlayer. */
>  			result = ufshcd_scsi_cmd_status(lrbp,

Reviewed-by: Can Guo <cang@codeaurora.org>
