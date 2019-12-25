Return-Path: <SRS0=On0Q=2P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E68C2D0DA
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 08:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A858920643
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 08:17:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="K9FX5qbF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfLYIR6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Dec 2019 03:17:58 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:39699 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726552AbfLYIR6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Dec 2019 03:17:58 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1577261877; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=SW14vR2Dtzn4hx01MxZQNXMAkIZRW+vrNYkODa/qgvc=;
 b=K9FX5qbF8dkQ3rZ8MK8Bw0wG0kONm51pKd7DfRaTogwAwWkngkkyCLHjdGezTIk5tPdjGw3C
 IrTht1r160gnojKgYyEpL0RZguswLAhcP6OSqyjsWGurvRy3kJp7Rx4dI8kJYl7dcJ5HWL4/
 VP7t6DdxSatuI1pvUTOz6NSaYYU=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e031b35.7fb377d9b110-smtp-out-n03;
 Wed, 25 Dec 2019 08:17:57 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E630AC4479F; Wed, 25 Dec 2019 08:17:56 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 232CBC43383;
        Wed, 25 Dec 2019 08:17:56 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 25 Dec 2019 16:17:56 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 2/6] ufs: Make ufshcd_add_command_trace() easier to read
In-Reply-To: <20191224220248.30138-3-bvanassche@acm.org>
References: <20191224220248.30138-1-bvanassche@acm.org>
 <20191224220248.30138-3-bvanassche@acm.org>
Message-ID: <99cfc53d23c1830807a604567f1b63e7@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-25 06:02, Bart Van Assche wrote:
> Since the lrbp->cmd expression occurs multiple times, introduce a new
> local variable to hold that pointer. This patch does not change any
> functionality.
> 
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufshcd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 48f2f94d51bc..acc84e964e8f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -327,27 +327,27 @@ static void ufshcd_add_command_trace(struct 
> ufs_hba *hba,
>  	u8 opcode = 0;
>  	u32 intr, doorbell;
>  	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
> +	struct scsi_cmnd *cmd = lrbp->cmd;
>  	int transfer_len = -1;
> 
>  	if (!trace_ufshcd_command_enabled()) {
>  		/* trace UPIU W/O tracing command */
> -		if (lrbp->cmd)
> +		if (cmd)
>  			ufshcd_add_cmd_upiu_trace(hba, tag, str);
>  		return;
>  	}
> 
> -	if (lrbp->cmd) { /* data phase exists */
> +	if (cmd) { /* data phase exists */
>  		/* trace UPIU also */
>  		ufshcd_add_cmd_upiu_trace(hba, tag, str);
> -		opcode = (u8)(*lrbp->cmd->cmnd);
> +		opcode = cmd->cmnd[0];
>  		if ((opcode == READ_10) || (opcode == WRITE_10)) {
>  			/*
>  			 * Currently we only fully trace read(10) and write(10)
>  			 * commands
>  			 */
> -			if (lrbp->cmd->request && lrbp->cmd->request->bio)
> -				lba =
> -				  lrbp->cmd->request->bio->bi_iter.bi_sector;
> +			if (cmd->request && cmd->request->bio)
> +				lba = cmd->request->bio->bi_iter.bi_sector;
>  			transfer_len = be32_to_cpu(
>  				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
>  		}
