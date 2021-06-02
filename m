Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACBE7C47080
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 852A7613BE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhFBChF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 22:37:05 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:41290 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbhFBCg7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 22:36:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622601317; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=+uWNv/7Q+eLyPKvuqi7nUotZbu54u7L732mJwg+peRo=;
 b=c7eoyVaqSpM1EojLF73tls0g+Z6n0lImeifVIH5RStk7rEskfF1NJxg/bcqhXBab28cLDqZw
 HKKq3AXKYuLdkK/uhROTHDD9+SeJJqTF6ubAuYSzF4rWcxJKKTATgnRCyhBo1xnQ6KYQrcRV
 01zZJtGqucg1n1sTPM2tR67vmNU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 60b6ee60ed59bf69ccd04ae7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Jun 2021 02:35:12
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3F096C4360C; Wed,  2 Jun 2021 02:35:12 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 66C22C433F1;
        Wed,  2 Jun 2021 02:35:06 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 02 Jun 2021 10:35:06 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] scsi: ufs: Cleanup ufshcd_add_command_trace()
In-Reply-To: <20210531104308.391842-2-huobean@gmail.com>
References: <20210531104308.391842-1-huobean@gmail.com>
 <20210531104308.391842-2-huobean@gmail.com>
Message-ID: <810c58442d4bdfb5e58009d87766dd7a@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-05-31 18:43, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> To consistent with trace event print, convert the value of the
> variable 'lba' in the unit of LBA (logical block address).
> 
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 02267b090729..85590d3a719e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -25,6 +25,7 @@
>  #include "ufs_bsg.h"
>  #include "ufshcd-crypto.h"
>  #include <asm/unaligned.h>
> +#include "../sd.h"
> 
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/ufs.h>
> @@ -364,7 +365,7 @@ static void ufshcd_add_uic_command_trace(struct
> ufs_hba *hba,
>  static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int 
> tag,
>  				     enum ufs_trace_str_t str_t)
>  {
> -	sector_t lba = -1;
> +	u64 lba = -1;
>  	u8 opcode = 0, group_id = 0;
>  	u32 intr, doorbell;
>  	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
> @@ -382,22 +383,23 @@ static void ufshcd_add_command_trace(struct
> ufs_hba *hba, unsigned int tag,
>  		/* trace UPIU also */
>  		ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
>  		opcode = cmd->cmnd[0];
> +		lba = sectors_to_logical(cmd->device, blk_rq_pos(cmd->request));
> +
>  		if ((opcode == READ_10) || (opcode == WRITE_10)) {
>  			/*
>  			 * Currently we only fully trace read(10) and write(10)
>  			 * commands
>  			 */
> -			if (cmd->request && cmd->request->bio)
> -				lba = cmd->request->bio->bi_iter.bi_sector;
>  			transfer_len = be32_to_cpu(
>  				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
>  			if (opcode == WRITE_10)
>  				group_id = lrbp->cmd->cmnd[6];
>  		} else if (opcode == UNMAP) {
> -			if (cmd->request) {
> -				lba = scsi_get_lba(cmd);
> -				transfer_len = blk_rq_bytes(cmd->request);
> -			}
> +			/*
> +			 * The number of Bytes to be unmapped beginning with the
> +			 * lba.
> +			 */
> +			transfer_len = blk_rq_bytes(cmd->request);
>  		}
>  	}

Reviewed-by: Can Guo <cang@codeaurora.org>
