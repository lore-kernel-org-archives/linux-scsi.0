Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 036F8C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 23:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6B8560F6E
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 23:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237112AbhITX4x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 19:56:53 -0400
Received: from gateway24.websitewelcome.com ([192.185.51.196]:29840 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239850AbhITXyx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Sep 2021 19:54:53 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 3A7B718D1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Sep 2021 18:53:24 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id ST6Cmz27mHlR1ST6CmQLko; Mon, 20 Sep 2021 18:53:24 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9dKrNFiIoQV/+gE4BwQR5jmTOuHAiTPni8wW5D6aAnw=; b=cdVSmnaDElW698bbPVn0JtIKyf
        gE92q9CxgK48XjHTjzj0tT4urlocEEFLNJCrL/p+SrAu5yLIuWpZkRd1aXGaXkDCv/lr4j8mo0Kar
        edZhkIfGJ45lpzKJTJ4sjCKgi//nuVY9PhVs7Pm8kiJZPvCWE3I9oB/Ml3bWp906I2ei9X+r6104M
        cGD4fEBPxky90cZrwmarkSfsqM65AZkt2Qj6G8ykeCq0J76mQzLds0h9FOH83UMFcOXXBhDEzEu9U
        ef0aEemZKD+J+lZb0i5JsvW8ETSq1aOyxxLsY8Zv5SD+cCjbfJcyV67Pci6QeSd0GKcj1w1cV9AHI
        pHQjx/Og==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:33600 helo=[192.168.15.9])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1mST6B-000NEv-NP; Mon, 20 Sep 2021 18:53:23 -0500
Subject: Re: [PATCH] scsi: advansys: Prefer struct_size over open coded
 arithmetic
To:     Len Baker <len.baker@gmx.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210918111805.15471-1-len.baker@gmx.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <422fbbe3-6f22-b16d-7af2-23efeb6dd125@embeddedor.com>
Date:   Mon, 20 Sep 2021 18:57:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210918111805.15471-1-len.baker@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1mST6B-000NEv-NP
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.9]) [187.162.31.110]:33600
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 9
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 9/18/21 06:18, Len Baker wrote:
> As noted in the "Deprecated Interfaces, Language Features, Attributes,
> and Conventions" documentation [1], size calculations (especially
> multiplication) should not be performed in memory allocator (or similar)
> function arguments due to the risk of them overflowing. This could lead
> to values wrapping around and a smaller allocation being made than the
> caller was expecting. Using those allocations could lead to linear
> overflows of heap memory and other misbehaviors.
> 
> So, refactor the code a bit to use the struct_size() helper instead of
> the argument "size + count * size" in the kzalloc() function.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> 
> Signed-off-by: Len Baker <len.baker@gmx.com>
> ---
>  drivers/scsi/advansys.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index ffb391967573..fe882502e7bf 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -7465,6 +7465,7 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
>  		return ASC_BUSY;
>  	} else if (use_sg > 0) {
>  		int sgcnt;
> +		size_t size;

I don't think a new variable is needed.

>  		struct scatterlist *slp;
>  		struct asc_sg_head *asc_sg_head;
> 
> @@ -7477,8 +7478,8 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
>  			return ASC_ERROR;
>  		}
> 
> -		asc_sg_head = kzalloc(sizeof(asc_scsi_q->sg_head) +
> -			use_sg * sizeof(struct asc_sg_list), GFP_ATOMIC);
> +		size = struct_size(asc_scsi_q->sg_head, sg_list, use_sg);
> +		asc_sg_head = kzalloc(size, GFP_ATOMIC);

You can go with this:

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ffb391967573..e341b3372482 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7477,8 +7477,8 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
                        return ASC_ERROR;
                }

-               asc_sg_head = kzalloc(sizeof(asc_scsi_q->sg_head) +
-                       use_sg * sizeof(struct asc_sg_list), GFP_ATOMIC);
+               asc_sg_head = kzalloc(struct_size(asc_sg_head, sg_list, use_sg),
+                                     GFP_ATOMIC);
                if (!asc_sg_head) {
                        scsi_dma_unmap(scp);
                        set_host_byte(scp, DID_SOFT_ERROR);

It perfectly fits withing the 80 columns, which by the way is deprecated
but still good-to-have.

Also, if you are finding these instances with the help of Coccinelle, it'd be nice
if you mention that in the changelog text. :)

Thanks!
--
Gustavo

>  		if (!asc_sg_head) {
>  			scsi_dma_unmap(scp);
>  			set_host_byte(scp, DID_SOFT_ERROR);
> --
> 2.25.1
> 
