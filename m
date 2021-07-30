Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA367C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 22:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90B7C60FE7
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 22:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbhG3WEe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jul 2021 18:04:34 -0400
Received: from mailout.easymail.ca ([64.68.200.34]:40910 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbhG3WEe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jul 2021 18:04:34 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Jul 2021 18:04:33 EDT
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id 77EAD8280F;
        Fri, 30 Jul 2021 21:57:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo01-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo01-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qb7Laqtfqbm5; Fri, 30 Jul 2021 21:57:17 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id 26CCF8262C;
        Fri, 30 Jul 2021 21:57:17 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id 6AF7A3EE3E;
        Fri, 30 Jul 2021 15:57:16 -0600 (MDT)
Subject: Re: [PATCH] scsi: BusLogic: use %X for u32 sized integer rather than
 %lX
To:     Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210730095031.26981-1-colin.king@canonical.com>
From:   Khalid Aziz <khalid@gonehiking.org>
Message-ID: <c0d9a73c-3817-ea12-8cda-8970ac849191@gonehiking.org>
Date:   Fri, 30 Jul 2021 15:57:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210730095031.26981-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/30/21 3:50 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> An earlier fix changed the print format specifier for adapter->bios_addr
> to use %lX however the integer is a u32 so the fix was wrong. Fix this
> by using the correct %X format specifier.
> 
> Addresses-Coverity: ("Invalid type in argument")
> Fixes: 43622697117c ("scsi: BusLogic: use %lX for unsigned long rather than %X")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/BusLogic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index adddcd589941..bd615db5c58c 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -1711,7 +1711,7 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
>  	if (adapter->adapter_bus_type != BLOGIC_PCI_BUS) {
>  		blogic_info("  DMA Channel: None, ", adapter);
>  		if (adapter->bios_addr > 0)
> -			blogic_info("BIOS Address: 0x%lX, ", adapter,
> +			blogic_info("BIOS Address: 0x%X, ", adapter,
>  					adapter->bios_addr);
>  		else
>  			blogic_info("BIOS Address: None, ", adapter);
> 

Acked-by: Khalid Aziz <khalid@gonehiking.org>
