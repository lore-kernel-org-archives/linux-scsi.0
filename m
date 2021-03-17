Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEEB1C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 17:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A97664E98
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 17:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhCQRBy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 13:01:54 -0400
Received: from mailout.easymail.ca ([64.68.200.34]:35962 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbhCQRBi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 13:01:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id A22DAA0E13;
        Wed, 17 Mar 2021 17:01:37 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo05-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo05-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yY_tvHsFiwWa; Wed, 17 Mar 2021 17:01:37 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id DCCBDA021E;
        Wed, 17 Mar 2021 17:01:31 +0000 (UTC)
Received: from [192.168.1.4] (rhapsody.internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id 025E83EF3B;
        Wed, 17 Mar 2021 11:01:30 -0600 (MDT)
Subject: Re: [PATCH 1/8] scsi: BusLogic: Supply __printf(x, y) formatting for
 blogic_msg()
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20210317091125.2910058-1-lee.jones@linaro.org>
 <20210317091125.2910058-2-lee.jones@linaro.org>
From:   Khalid Aziz <khalid@gonehiking.org>
Message-ID: <08dddf10-d020-93ae-3783-2a911ff88f42@gonehiking.org>
Date:   Wed, 17 Mar 2021 11:01:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210317091125.2910058-2-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/17/21 3:11 AM, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  In file included from drivers/scsi/BusLogic.c:51:
>  drivers/scsi/BusLogic.c: In function ‘blogic_msg’:
>  drivers/scsi/BusLogic.c:3591:2: warning: function ‘blogic_msg’ might be a candidate for ‘gnu_printf’ format attribute [-Wsuggest-attribute=format]
> 
> Cc: Khalid Aziz <khalid@gonehiking.org>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: "Leonard N. Zubkoff" <lnz@dandelion.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/scsi/BusLogic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index ccb061ab0a0ad..0ac3f713fc212 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -3578,7 +3578,7 @@ Target	Requested Completed  Requested Completed  Requested Completed\n\
>  /*
>    blogic_msg prints Driver Messages.
>  */
> -
> +__printf(2, 4)
>  static void blogic_msg(enum blogic_msglevel msglevel, char *fmt,
>  			struct blogic_adapter *adapter, ...)
>  {
> 

Acked-by: Khalid Aziz <khalid@gonehiking.org>
