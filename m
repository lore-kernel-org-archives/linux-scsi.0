Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169DBC433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 23:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAABD610D2
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 23:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbhEFX6B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 19:58:01 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:38323 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233079AbhEFX6B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 May 2021 19:58:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620345422; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=3MIsE8W6AgzWdnlTbJuC6GCNBcSH43iE9ewFWxtWhB0=;
 b=Q2vjxGxzB2e425o2U9UekpibIfCM5n4YZxtriAlmtus9JL7zJoZxcmwJQEOb6PqnmaIREVia
 98zJojnaiB+VuxSOJYwb9SidwtOTr/NfN09WHtHTZZmGrFjcSE+pn1oKF/66xnNWZ7vbd32e
 SvVt8rFhdurgCk5EWW45TiaMqQM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60948247e0e9c9a6b6ba5be7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 06 May 2021 23:56:55
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6706AC43147; Thu,  6 May 2021 23:56:55 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 179C1C4338A;
        Thu,  6 May 2021 23:56:54 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 07 May 2021 07:56:54 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 010/117] ufs: Add a compile-time structure size check
In-Reply-To: <20210420000845.25873-11-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-11-bvanassche@acm.org>
Message-ID: <e421820b472ef5223bc22685c249ec77@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-20 08:06, Bart Van Assche wrote:
> Before modifying the definition of struct ufs_bsg_reply, add a 
> compile-time
> structure size check.
> 
> Cc: Can Guo <cang@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 0625da7a42ee..fa596cf66c23 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -9455,6 +9455,8 @@ EXPORT_SYMBOL_GPL(ufshcd_init);
> 
>  static int __init ufshcd_core_init(void)
>  {
> +	BUILD_BUG_ON(offsetof(struct ufs_bsg_reply, upiu_rsp) != 8);
> +
>  	ufs_debugfs_init();
>  	return 0;
>  }

Reviewed-by: Can Guo <cang@codeaurora.org>
