Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46011C4345E
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76ABB22D70
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:13:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="htgTb5Jo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgHFJDm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 05:03:42 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:53827 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728981AbgHFJDl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Aug 2020 05:03:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596704620; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=ZIO+8hqUYeBnO7dLtKhWRl9zvjGqCBhvytYo3OMVUuM=;
 b=htgTb5Jotw9147/RuqLCy5HlUbUeIHWH5HUNSHvkwvRCsYFGHrF0qdwcNB1xB9kB480jq8xI
 JzxT49dY23n+wwl6QH0XIJ9wjgqFaxZrzpknGY3DhahqKR4nWVQGi9o2+owgWy9rldCtijyw
 KAAqP74rjgB7e75hd6WDd74OMLc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n16.prod.us-west-2.postgun.com with SMTP id
 5f2bc768c85a1092b01860e7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 06 Aug 2020 09:03:36
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 53DF3C433AF; Thu,  6 Aug 2020 09:03:36 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 56FC7C433C6;
        Thu,  6 Aug 2020 09:03:35 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 06 Aug 2020 17:03:35 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] scsi: ufs: no need to send one Abort Task TM in case
 the task in DB was cleared
In-Reply-To: <20200804123534.29104-1-huobean@gmail.com>
References: <20200804123534.29104-1-huobean@gmail.com>
Message-ID: <a68a1bdf74bdf8ada29808537290b35b@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

On 2020-08-04 20:35, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> If the bit corresponds to a task in the Doorbell register has been
> cleared, no need to poll the status of the task on the device side
> and to send an Abort Task TM.
> This patch also deletes dispensable dev_err() in case of the task
> already completed.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 307622284239..581b4ab52bf4 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6425,19 +6425,16 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  		return ufshcd_eh_host_reset_handler(cmd);
> 
>  	ufshcd_hold(hba, false);
> -	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>  	/* If command is already aborted/completed, return SUCCESS */
> -	if (!(test_bit(tag, &hba->outstanding_reqs))) {
> -		dev_err(hba->dev,
> -			"%s: cmd at tag %d already completed, outstanding=0x%lx, 
> doorbell=0x%x\n",
> -			__func__, tag, hba->outstanding_reqs, reg);
> +	if (!(test_bit(tag, &hba->outstanding_reqs)))
>  		goto out;
> -	}
> 
> +	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>  	if (!(reg & (1 << tag))) {
>  		dev_err(hba->dev,
>  		"%s: cmd was completed, but without a notifying intr, tag = %d",
>  		__func__, tag);
> +		goto out;

Please check Stanley's recent change to ufshcd_abort, you may
want to rebase your change on his and do goto cleanup here.
@Stanley correct me if I am wrong.

But even if you do a goto cleanup here, we still lost the
chances to dump host infos/regs like it does in the old code.
If a cmd was completed but without a notifying intr, this is
kind of a problem that we/host should look into, because it's
pasted at least 30 sec since the cmd was sent, so those dumps
are necessary to debug the problem. How about moving blow prints
in front of this part?

Thanks,

Can Guo.

>  	}
> 
>  	/* Print Transfer Request of aborted task */
