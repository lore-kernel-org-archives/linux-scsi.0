Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B1EC433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45710619AD
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhCWE0q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:26:46 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:28036 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhCWE0e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 00:26:34 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1616473594; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=5AsBctBdaWVT+v92mk/yhzK9ngv5dDQ8x25+1Ap7qhc=;
 b=pP7ncWmmhzHRIHLw0aLexElWIuJTtR9x6VanmOUoqNmgTbFwQa8y0s4VNqSjiXMN9DX6f8fd
 FlyMOgojo5LvtzanDAce4Lxt0W4ueRw4D0xKaqje7kUC3c+pzuPVm531WvR9naC4YF56WYyo
 GzVHnPnHYUNRk3+8H506Hfm9bQ0=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60596df81de5dd7b99a7cfa8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 23 Mar 2021 04:26:32
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 03E62C433ED; Tue, 23 Mar 2021 04:26:32 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 47DA8C433CA;
        Tue, 23 Mar 2021 04:26:31 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 23 Mar 2021 12:26:31 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kael_w@yeah.net
Subject: Re: [PATCH] drivers: scsi: Remove duplicate include of blkdev.h
In-Reply-To: <20210322122847.128375-1-wanjiabing@vivo.com>
References: <20210322122847.128375-1-wanjiabing@vivo.com>
Message-ID: <4357768675f6adac86059b98e29a78a5@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-22 20:28, Wan Jiabing wrote:
> linux/blkdev.h has been included at line 18, so remove
> the duplicate include at line 27.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c86760788c72..e8aa7de17d0a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -24,7 +24,6 @@
>  #include "ufs_bsg.h"
>  #include "ufshcd-crypto.h"
>  #include <asm/unaligned.h>
> -#include <linux/blkdev.h>
> 
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/ufs.h>

Someone has addressed it before you - check 
https://git.kernel.org/mkp/scsi/c/b4388e3db56a

Can Guo.
