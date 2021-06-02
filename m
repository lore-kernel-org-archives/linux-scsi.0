Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5028C47092
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8545613BE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhFBCfy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 22:35:54 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:22751 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbhFBCfx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 22:35:53 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622601251; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=7Xn3A6fVS46RBZmcAtbEyiPLKhOi7x8dz+VLSnh3H3w=;
 b=Bn0FHRj4uhegFwYfmKZ6B8D3s69d9oD+fS+NF22/R7uqVRgTUlHf8EBWkBPaw7IHz0OUjkyt
 J5HEHN/ydsf5+8GHxSP++q30jHVX0VH5MK5qrVcG534PDLEv+6OdJVeGluUdoQufC3XZkJvR
 ZOH8twwaQHSDSUSTQcvdgwiPkcI=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 60b6ee1e2eaeb98b5e609d1f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Jun 2021 02:34:06
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D9597C4360C; Wed,  2 Jun 2021 02:34:06 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2808BC433F1;
        Wed,  2 Jun 2021 02:34:05 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 02 Jun 2021 10:34:05 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] scsi: ufs: Let UPIU completion trace print RSP
 UPIU header
In-Reply-To: <20210531104308.391842-3-huobean@gmail.com>
References: <20210531104308.391842-1-huobean@gmail.com>
 <20210531104308.391842-3-huobean@gmail.com>
Message-ID: <361f7611bc5193694487831bfd912ad1@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-05-31 18:43, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> The current UPIU completion event trace still prints the COMMAND UPIU
> header, rather than the RSP UPIU header. This makes UPIU command trace
> useless in problem shooting in case we receive a trace log from the
> customer/field.
> 
> There are two important fields in RSP UPIU:
>  1. The response field, which indicates the UFS defined overall success
>     or failure of the series of Command, Data and RESPONSE UPIU’s that
>     make up the execution of a task.
>  2. The Status field, which contains the command set specific status 
> for
>     a specific command issued by the initiator device.
> 
> Before this patch, the UPIU paired trace events:
> 
> ufshcd_upiu: send_req: fe3b0000.ufs: HDR:01 20 00 1c 00 00 00 00 00 00
> 00 00, CDB:3b e1 00 00 00 00 00 00 30 00 00 00 00 00 00 00
> ufshcd_upiu: complete_rsp: fe3b0000.ufs: HDR:01 20 00 1c 00 00 00 00
> 00 00 00 00, CDB:3b e1 00 00 00 00 00 00 30 00 00 00 00 00 00 00
> 
> After the patch:
> 
> ufshcd_upiu: send_req: fe3b0000.ufs: HDR:01 20 00 1c 00 00 00 00 00 00
> 00 00, CDB:3b e1 00 00 00 00 00 00 30 00 00 00 00 00 00 00
> ufshcd_upiu: complete_rsp: fe3b0000.ufs: HDR:21 00 00 1c 00 00 00 00
> 00 00 00 00, CDB:3b e1 00 00 00 00 00 00 30 00 00 00 00 00 00 00
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 85590d3a719e..c5754d5486c9 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -302,11 +302,17 @@ static void ufshcd_add_cmd_upiu_trace(struct
> ufs_hba *hba, unsigned int tag,
>  				      enum ufs_trace_str_t str_t)
>  {
>  	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
> +	struct utp_upiu_header *header;
> 
>  	if (!trace_ufshcd_upiu_enabled())
>  		return;
> 
> -	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq->header, 
> &rq->sc.cdb,
> +	if (str_t == UFS_CMD_SEND)
> +		header = &rq->header;
> +	else
> +		header = &hba->lrb[tag].ucd_rsp_ptr->header;
> +
> +	trace_ufshcd_upiu(dev_name(hba->dev), str_t, header, &rq->sc.cdb,
>  			  UFS_TSF_CDB);
>  }

Reviewed-by: Can Guo <cang@codeaurora.org>
