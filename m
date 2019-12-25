Return-Path: <SRS0=On0Q=2P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C545C2D0DA
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 10:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2D392077B
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 10:32:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="SG0/GQLf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfLYKcD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Dec 2019 05:32:03 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:56358 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726025AbfLYKcD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Dec 2019 05:32:03 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1577269922; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=o2fbME7+PLAiiGCRk1M6/Q3MMwT9xHj72vOThOAvxmU=;
 b=SG0/GQLfiBlyChJoHIa038h1GhEaY+aKQH5weVzMPIsvhrhaOSRAKY1THXXTkudgzWRwYfWH
 BAYWVKwsdwn6RnyeNgwfhaqzdsWbjj70mrzsCt9zc/MwdGdZmlUb9/QeDYck5NOTlM9gICry
 WRl5erYnwElJDL9XAFurlzkFPhU=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e033aa1.7f9520f9ef80-smtp-out-n03;
 Wed, 25 Dec 2019 10:32:01 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D5314C447A2; Wed, 25 Dec 2019 10:32:00 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AA83DC43383;
        Wed, 25 Dec 2019 10:31:59 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 25 Dec 2019 18:31:59 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 5/6] ufs: Remove superfluous memory barriers
In-Reply-To: <20191224220248.30138-6-bvanassche@acm.org>
References: <20191224220248.30138-1-bvanassche@acm.org>
 <20191224220248.30138-6-bvanassche@acm.org>
Message-ID: <aba850f956421c187e0b88343f6d5070@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-25 06:02, Bart Van Assche wrote:
> Calling wmb() after having written to a doorbell slows down code and 
> does
> not help to commit the doorbell write faster. Hence remove such wmb()
> calls. Note: detailed information about the semantics of writel() is
> available in Documentation/driver-api/device-io.rst.
> 
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 4d9bb1932b39..edcc137c436b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1879,8 +1879,6 @@ void ufshcd_send_command(struct ufs_hba *hba,
> unsigned int task_tag)
>  	ufshcd_clk_scaling_start_busy(hba);
>  	__set_bit(task_tag, &hba->outstanding_reqs);
>  	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -	/* Make sure that doorbell is committed immediately */
> -	wmb();
>  }
> 
>  /**
> @@ -5766,8 +5764,6 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba 
> *hba,
>  	wmb();
> 
>  	ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
> -	/* Make sure that doorbell is committed immediately */
> -	wmb();
> 
>  	spin_unlock_irqrestore(host->host_lock, flags);

Hi Bart,

Three wmb()s were added in commit ad1a1b9cd because we did see instances 
on
which OCS=3(MISMATCH_DATA_BUFFER_SIZE) error were observed in large 
scale
test. Commit ad1a1b9cd fixed the error and we had confirmed it through
large amount of tests. I am not sure removing the 2 wmb()s here would 
cause
regression or not.

Thanks,

Can Guo.
