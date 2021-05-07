Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC98EC43461
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 00:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA90E601FD
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 00:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbhEGAC7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 20:02:59 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:58227 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhEGAC6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2021 20:02:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620345720; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=YOl3aYMv+dWb0t6xB47jyPequxGMsHNJAu7CXu4/IC0=;
 b=MZ9VifQyM/kfipgzotKdfYYBSZljpFjDipY+z4f80NXAzH8xTIdC99p07dhOiZfCUbd8NIS8
 Usq90GnV9kyQdxtTLLsJqNVfG7ebi7dnXBT9ohL5ZVNjZ8m+Dy6yRAPysJ1ov4bup+q9zq9Q
 G51rihisFnCM7ZbfwLAMJ5RVHwA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 609483538166b7eff7c72cf9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 07 May 2021 00:01:23
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 68555C43145; Fri,  7 May 2021 00:01:22 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6ED0AC4338A;
        Fri,  7 May 2021 00:01:21 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 07 May 2021 08:01:21 +0800
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
Subject: Re: [PATCH 100/117] ufs: Use enum sam_status where appropriate
In-Reply-To: <20210420021402.27678-10-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420021402.27678-10-bvanassche@acm.org>
Message-ID: <df985de8344616dfa92a5de359bd4365@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-20 10:13, Bart Van Assche wrote:
> Make it explicit that the second ufshcd_scsi_cmd_status() argument is a
> SAM status code.
> 
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 0c2c18f2acf3..391947e4db72 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4898,7 +4898,7 @@ static void ufshcd_slave_destroy(struct 
> scsi_device *sdev)
>   * Returns value base on SCSI command status
>   */
>  static inline int
> -ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status)
> +ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, enum sam_status 
> scsi_status)
>  {
>  	int result = 0;

Reviewed-by: Can Guo <cang@codeaurora.org>
