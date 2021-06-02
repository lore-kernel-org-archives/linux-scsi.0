Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF652C47080
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2EDD613BE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhFBCeX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 22:34:23 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:13345 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230021AbhFBCeW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Jun 2021 22:34:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622601160; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=N2aWNaK6HbPpRc2PN5lxaYs+zFYsZrJUqGdXKGBg3Nw=;
 b=IHo3m9FP6jdI53s/7HokI9Cibpcd35yFcE3IcgBki5jJzXlZXXEACHo5DkLPWi1SUoVZjSwC
 /OXqhCEgQJ/fMsM5tQmnzzs9fd65Gf6W3oY+lznq/Zq1PYCf6fLPV3Zlv1Kq5GJlOLiVxl00
 MnK33fSHDsKqvzc+U8xYhyKhcwA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 60b6edbcabfd22a3dcf05629 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Jun 2021 02:32:28
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 60100C43144; Wed,  2 Jun 2021 02:32:27 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4F10AC43460;
        Wed,  2 Jun 2021 02:32:26 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 02 Jun 2021 10:32:26 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] scsi: ufs: Let command trace only for the cmd !=
 null case
In-Reply-To: <20210531104308.391842-4-huobean@gmail.com>
References: <20210531104308.391842-1-huobean@gmail.com>
 <20210531104308.391842-4-huobean@gmail.com>
Message-ID: <309e9bacdc0a6ab78913036f4c95f142@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-05-31 18:43, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> For the query request, we already have query_trace, but in
> ufshcd_send_command (), there will add two more redundant
> traces. Since lrbp->cmd is null in the query request, the
> below these two trace events provide nothing except the tag
> and DB. Instead of letting them take up the limited trace
> ring buffer, it’s better not to print these traces in case
> of cmd == null.
> 
> ufshcd_command: send_req: ff3b0000.ufs: tag: 28, DB: 0x0, size: -1,
> IS: 0, LBA: 18446744073709551615, opcode: 0x0 (0x0), group_id: 0x0
> ufshcd_command: dev_complete: ff3b0000.ufs: tag: 28, DB: 0x0, size:
> -1, IS: 0, LBA: 18446744073709551615, opcode: 0x0 (0x0), group_id: 0x0
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 44 +++++++++++++++++++--------------------
>  1 file changed, 21 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c5754d5486c9..c84bd8e045f6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -378,35 +378,33 @@ static void ufshcd_add_command_trace(struct
> ufs_hba *hba, unsigned int tag,
>  	struct scsi_cmnd *cmd = lrbp->cmd;
>  	int transfer_len = -1;
> 
> +	if (!cmd)
> +		return;
> +
>  	if (!trace_ufshcd_command_enabled()) {
>  		/* trace UPIU W/O tracing command */
> -		if (cmd)
> -			ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
> +		ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
>  		return;
>  	}
> 
> -	if (cmd) { /* data phase exists */
> -		/* trace UPIU also */
> -		ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
> -		opcode = cmd->cmnd[0];
> -		lba = sectors_to_logical(cmd->device, blk_rq_pos(cmd->request));
> +	/* trace UPIU also */
> +	ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
> +	opcode = cmd->cmnd[0];
> +	lba = sectors_to_logical(cmd->device, blk_rq_pos(cmd->request));
> 
> -		if ((opcode == READ_10) || (opcode == WRITE_10)) {
> -			/*
> -			 * Currently we only fully trace read(10) and write(10)
> -			 * commands
> -			 */
> -			transfer_len = be32_to_cpu(
> -				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
> -			if (opcode == WRITE_10)
> -				group_id = lrbp->cmd->cmnd[6];
> -		} else if (opcode == UNMAP) {
> -			/*
> -			 * The number of Bytes to be unmapped beginning with the
> -			 * lba.
> -			 */
> -			transfer_len = blk_rq_bytes(cmd->request);
> -		}
> +	if (opcode == READ_10 || opcode == WRITE_10) {
> +		/*
> +		 * Currently we only fully trace read(10) and write(10) commands
> +		 */
> +		transfer_len =
> +		       be32_to_cpu(lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
> +		if (opcode == WRITE_10)
> +			group_id = lrbp->cmd->cmnd[6];
> +	} else if (opcode == UNMAP) {
> +		/*
> +		 * The number of Bytes to be unmapped beginning with the lba.
> +		 */
> +		transfer_len = blk_rq_bytes(cmd->request);
>  	}
> 
>  	intr = ufshcd_readl(hba, REG_INTERRUPT_STATUS);

Reviewed-by: Can Guo <cang@codeaurora.org>
