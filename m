Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43AFC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AE15613E6
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238701AbhDVRbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 13:31:11 -0400
Received: from mailout.easymail.ca ([64.68.200.34]:41150 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239023AbhDVRay (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 13:30:54 -0400
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id 33FFBC3842;
        Thu, 22 Apr 2021 17:30:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo04-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo04-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ErfpVt9ZJzcN; Thu, 22 Apr 2021 17:30:18 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id 38B7AC3757;
        Thu, 22 Apr 2021 17:30:11 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id F2D1A3EE3E;
        Thu, 22 Apr 2021 11:30:10 -0600 (MDT)
Subject: Re: [PATCH v2 2/5] scsi: BusLogic: Avoid unbounded `vsprintf' use
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <alpine.DEB.2.21.2104201934280.44318@angie.orcam.me.uk>
 <alpine.DEB.2.21.2104201939390.44318@angie.orcam.me.uk>
From:   Khalid Aziz <khalid@gonehiking.org>
Message-ID: <55356910-b46e-cfab-bb67-fc364ebf5740@gonehiking.org>
Date:   Thu, 22 Apr 2021 11:30:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.2104201939390.44318@angie.orcam.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/21 12:01 PM, Maciej W. Rozycki wrote:
> Existing `blogic_msg' invocations do not appear to overrun its internal 
> buffer of a fixed length of 100, which would cause stack corruption, but 
> it's easy to miss with possible further updates and a fix is cheap in 
> performance terms, so limit the output produced into the buffer by using 
> `vscnprintf' rather than `vsprintf'.
> 
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> ---
> Changes from v1:
> 
> - use `vscnprintf' instead of `vsnprintf' for the correct character count.
> ---
>  drivers/scsi/BusLogic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> linux-buslogic-vscnprintf.diff
> Index: linux-macro-ide/drivers/scsi/BusLogic.c
> ===================================================================
> --- linux-macro-ide.orig/drivers/scsi/BusLogic.c
> +++ linux-macro-ide/drivers/scsi/BusLogic.c
> @@ -3588,7 +3588,7 @@ static void blogic_msg(enum blogic_msgle
>  	int len = 0;
>  
>  	va_start(args, adapter);
> -	len = vsprintf(buf, fmt, args);
> +	len = vscnprintf(buf, sizeof(buf), fmt, args);
>  	va_end(args);
>  	if (msglevel == BLOGIC_ANNOUNCE_LEVEL) {
>  		static int msglines = 0;
> 

Acked-by: Khalid Aziz <khalid@gonehiking.org>
