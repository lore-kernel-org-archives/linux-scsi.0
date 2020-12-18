Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625F4C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 06:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A8322151B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 06:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732756AbgLRGRf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 01:17:35 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:49812 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbgLRGRf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 01:17:35 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608272241; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=9s16Fx+eSayOPAeY7YlBM42jsEYbvw5opfyr9V59Zhk=;
 b=BVSc8fWJAzsYqNb0HvweZI4wtPW34ZpiLpRX0rOs2JHS2pnu5S8Z+4UjPcwd6Akw5sMq6xPm
 /zQOpND6WVo1W7+9hQWVCdM3xLhRFn+GDGjcpoV/M+GmqHHqHqXUMle2u+2jF9DTWiHsJZEv
 TvvFTrqKO23W9VB+ke6AgqPTtjc=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5fdc49470564dfefcd04677f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 18 Dec 2020 06:16:39
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 29665C43462; Fri, 18 Dec 2020 06:16:39 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 509C2C433CA;
        Fri, 18 Dec 2020 06:16:38 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 18 Dec 2020 14:16:38 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, alice.chao@mediatek.com
Subject: Re: [PATCH v2 4/4] scsi: ufs: Fix build warning by incorrect function
 description
In-Reply-To: <20201216131639.4128-5-stanley.chu@mediatek.com>
References: <20201216131639.4128-1-stanley.chu@mediatek.com>
 <20201216131639.4128-5-stanley.chu@mediatek.com>
Message-ID: <57e1d462ae012108080dd16f967d5e42@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-16 21:16, Stanley Chu wrote:
> Fix build warnings as below due to incorrect function description
> of ufshcd_try_to_abort_task().
> 
> ufshcd.c:6651: warning: Function parameter or member 'hba' not
> described in 'ufshcd_try_to_abort_task'
> ufshcd.c:6651: warning: Function parameter or member 'tag' not
> described in 'ufshcd_try_to_abort_task'
> ufshcd.c:6651: warning: Excess function parameter 'cmd' description in
> 'ufshcd_try_to_abort_task'
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ce0528f2e2ed..79287fdd049b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6652,7 +6652,8 @@ static void ufshcd_set_req_abort_skip(struct
> ufs_hba *hba, unsigned long bitmap)
> 
>  /**
>   * ufshcd_try_to_abort_task - abort a specific task
> - * @cmd: SCSI command pointer
> + * @hba: per adapter instance
> + * @tag: position of the bit to be aborted
>   *
>   * Abort the pending command in device by sending UFS_ABORT_TASK task
> management
>   * command, and in host controller by clearing the door-bell
> register. There can

Thanks for the fix.

Reviewed-by: Can Guo <cang@codeaurora.org>
