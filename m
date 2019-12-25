Return-Path: <SRS0=On0Q=2P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168D1C2D0DA
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 08:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDEA42072A
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 08:18:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Cpe0gpXU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfLYISW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Dec 2019 03:18:22 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:39699 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726552AbfLYISW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Dec 2019 03:18:22 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1577261902; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Z1MfObVEY8GM5Drnofs8f6MPMJ/b7v/6OUrCb8/FnA8=;
 b=Cpe0gpXUUOXfOThegJtIc4gPCUk4N8n85udmpCkJvbeDp87isbq+Zl0JT9ISHJafh9N5wYZW
 oZ8Wn+Uj029DitP6uf2dn4/5g7jd007nASjqUkxdI34uar0Fj5+ztcwbHt/ux6FEzH4IAFKY
 AUfoFWi5BuXtNd2Mmsi4vQTzHYM=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e031b47.7f95a7f991b8-smtp-out-n03;
 Wed, 25 Dec 2019 08:18:15 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 136A2C4479C; Wed, 25 Dec 2019 08:18:15 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 512A4C433CB;
        Wed, 25 Dec 2019 08:18:14 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 25 Dec 2019 16:18:14 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 3/6] ufs: Make ufshcd_prepare_utp_scsi_cmd_upiu() easier
 to read
In-Reply-To: <20191224220248.30138-4-bvanassche@acm.org>
References: <20191224220248.30138-1-bvanassche@acm.org>
 <20191224220248.30138-4-bvanassche@acm.org>
Message-ID: <4a635b9d554e3c4a717035018d069832@codeaurora.org>
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
>  drivers/scsi/ufs/ufshcd.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index acc84e964e8f..80b028ba39e9 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2233,6 +2233,7 @@ static void ufshcd_prepare_req_desc_hdr(struct
> ufshcd_lrb *lrbp,
>  static
>  void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u32 
> upiu_flags)
>  {
> +	struct scsi_cmnd *cmd = lrbp->cmd;
>  	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
>  	unsigned short cdb_len;
> 
> @@ -2246,12 +2247,11 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct
> ufshcd_lrb *lrbp, u32 upiu_flags)
>  	/* Total EHS length and Data segment length will be zero */
>  	ucd_req_ptr->header.dword_2 = 0;
> 
> -	ucd_req_ptr->sc.exp_data_transfer_len =
> -		cpu_to_be32(lrbp->cmd->sdb.length);
> +	ucd_req_ptr->sc.exp_data_transfer_len = cpu_to_be32(cmd->sdb.length);
> 
> -	cdb_len = min_t(unsigned short, lrbp->cmd->cmd_len, UFS_CDB_SIZE);
> +	cdb_len = min_t(unsigned short, cmd->cmd_len, UFS_CDB_SIZE);
>  	memset(ucd_req_ptr->sc.cdb, 0, UFS_CDB_SIZE);
> -	memcpy(ucd_req_ptr->sc.cdb, lrbp->cmd->cmnd, cdb_len);
> +	memcpy(ucd_req_ptr->sc.cdb, cmd->cmnd, cdb_len);
> 
>  	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
>  }
