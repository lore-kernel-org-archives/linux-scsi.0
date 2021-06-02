Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74E8C4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9ABB613BF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhFBCbg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 22:31:36 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:13505 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229975AbhFBCbf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Jun 2021 22:31:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622600993; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=mrS8FjuiuckPwfzV6XWwylgTgo9N2E/xkBAnOaFFiqY=;
 b=N6PvkDMAX/FqMHRbpj+wKku9CN+ueilX/euKbiP2eDLx+WayYHKv1KOjWESQA58YmqDv6K5c
 qRviZ3u80MCch80VbWdt9OZszuCZhn4Q9WBHvB7x2N1wUl+u9YwshQOvoH4e0Sxl86QAn//g
 bhzqJDNERXqWFNWnBxS4K/Dqwpk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 60b6ed1de27c0cc77f058798 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Jun 2021 02:29:49
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 36F05C43217; Wed,  2 Jun 2021 02:29:49 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1E64AC43460;
        Wed,  2 Jun 2021 02:29:47 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 02 Jun 2021 10:29:47 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] scsi: ufs: Use UPIU query trace in devman_upiu_cmd
In-Reply-To: <20210531104308.391842-5-huobean@gmail.com>
References: <20210531104308.391842-1-huobean@gmail.com>
 <20210531104308.391842-5-huobean@gmail.com>
Message-ID: <7689e5022787716596534e9123fdc295@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

On 2021-05-31 18:43, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Since devman_upiu_cmd is not COMMAND UPIU, and doesn't have
> CDB, it is better to use UPIU query trace, which provides more
> helpful information for issue shooting.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c84bd8e045f6..deb9e232b349 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6701,6 +6701,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
> 
>  	hba->dev_cmd.complete = &wait;
> 
> +	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
>  	/* Make sure descriptors are ready before ringing the doorbell */
>  	wmb();
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> @@ -6732,6 +6733,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>  			err = -EINVAL;
>  		}
>  	}
> +	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : 
> UFS_QUERY_COMP,
> +				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
> 
>  out:
>  	blk_put_request(req);

What about ufshcd_exec_dev_cmd()?

Thanks,
Can Guo.
