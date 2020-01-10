Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 437D2C282DD
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 17:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 145D42084D
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 17:17:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="GTMe4FPl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbgAJRRc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 12:17:32 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:51069 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726751AbgAJRRc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Jan 2020 12:17:32 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1578676651; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=xBPYgJDEwJiK3m8b7fV9s9qyj5id/MbB23qfyHS3psY=;
 b=GTMe4FPl0OVcIoJpwCwMZXWZUTjgeTI3wfw9Dx7gZRXq3I3xlo13Q5uO8dlap5QQ85pGUcyK
 LorubXs/V380lj9TSlB8pvkftUmsAbNXBO3e3DPUbQR36c9noUMFwR3g+cJjjuOeLmswOYrd
 +L35gJex2o3AMAE+YAmLnJhQE2U=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e18b1aa.7f207cabbf10-smtp-out-n03;
 Fri, 10 Jan 2020 17:17:30 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E41C5C4479F; Fri, 10 Jan 2020 17:17:29 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 90A9DC4479C;
        Fri, 10 Jan 2020 17:17:28 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 10 Jan 2020 09:17:28 -0800
From:   asutoshd@codeaurora.org
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-scsi-owner@vger.kernel.org
Subject: Re: [PATCH 3/4] ufs: Simplify two tests
In-Reply-To: <20200107192531.73802-4-bvanassche@acm.org>
References: <20200107192531.73802-1-bvanassche@acm.org>
 <20200107192531.73802-4-bvanassche@acm.org>
Message-ID: <3d2d62d9e3bf8524fdf14fbd820bdbf3@codeaurora.org>
X-Sender: asutoshd@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-07 11:25, Bart Van Assche wrote:
> lrbp->cmd is set only for SCSI commands. Use this knowledge to simplify
> two boolean expressions.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 6f55d72e7fdd..15e65248597d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2474,7 +2474,7 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
> 
>  	/* issue command to the controller */
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> -	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
> +	ufshcd_vops_setup_xfer_req(hba, tag, true);
>  	ufshcd_send_command(hba, tag);
>  out_unlock:
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> @@ -2661,7 +2661,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba 
> *hba,
>  	/* Make sure descriptors are ready before ringing the doorbell */
>  	wmb();
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> -	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
> +	ufshcd_vops_setup_xfer_req(hba, tag, false);
>  	ufshcd_send_command(hba, tag);
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
