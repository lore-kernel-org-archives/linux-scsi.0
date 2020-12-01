Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE2DC64E8A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 18:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93A2120870
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 18:02:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hMesW0T9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404242AbgLASCS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 13:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404222AbgLASCS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 13:02:18 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4482C0613D4;
        Tue,  1 Dec 2020 10:01:37 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id l23so1732264pjg.1;
        Tue, 01 Dec 2020 10:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=uFEAfZo3EGZ57zkwr0Z5gVNfzF2/pBqb9CkqNLIpmIM=;
        b=hMesW0T9+moc5aBkbRGY8udmssiEYRpYM+zgew8O3tmZwj9K77EvzzCNSfvwZ0hbWn
         j95MZQL7+/+X65hWzGuEG2R2tOvJasrHVtU8muzSEq+MeU/FzYI2EGEZAWiFV0yaXWCP
         teICXmCX2YwRfUA53yqee5jsfyBUQ4NWX1VaoordN3fTjrKBUM7/EjxNSbj8Di67gQxa
         jjmAtU3Kb8MTJvXqTUVlZCmQOKhLSSVQU/T4Dqto4MMZGtsD6OaLv52e9FB0N7tK4t4F
         x4gbZ62SamoYQGYZm5XS/Sml6xXTSDUxK/QoVSbAAGe3AqgPWabj4u7z3gLyEhf1GWtt
         1TXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=uFEAfZo3EGZ57zkwr0Z5gVNfzF2/pBqb9CkqNLIpmIM=;
        b=oNKB0ilglEyyD56I3m7geKNDaRZfjMQMVKjVrJuY2bMOMwo+ktY2InFAMP6Wf40gL7
         xww08qiwkwJ8BsGhgd2hcbdgrX+htvmiCRfYLHzMPwO7cZ7/SMorpvXW3Opa8aI0rsx7
         B0Sl48/8iyyBhaADp8vqgaQ/nEWpHwEZaT+nJeSchVu1ps334SoNh5iIQbuFniBfomk6
         VzdE/T9vnzF4rUQb3Dc4ZNOx/PFGX0jjocThuisjoxvlIi5z+wOM7hTxk/Np8V9zmk3N
         TZCPQZZeNzGMNX/efsoTWD0MpHqdZW9LHRVF7bjP+V3g+e1SDIXuCkQSWpFxPyHJqa/2
         oTzA==
X-Gm-Message-State: AOAM532M9hk7mBCNVOfWQ0MQQYNXDtWa0zyk/m5QUTN8TpoHBXKR/lfV
        S/61JpPrN+5KynDNGO5RFZ+XQxc9dT0=
X-Google-Smtp-Source: ABdhPJwbcyjA1bd6s8ABJpvmTLYyuQhrxDyZPHj7iXc0w+Anid3Gh1ZZywjeGxqrU03q9qvyDGmIww==
X-Received: by 2002:a17:90a:bf81:: with SMTP id d1mr4045889pjs.108.1606845697111;
        Tue, 01 Dec 2020 10:01:37 -0800 (PST)
Received: from ?IPv6:2001:df0:0:200c:9894:d951:15f8:53bf? ([2001:df0:0:200c:9894:d951:15f8:53bf])
        by smtp.gmail.com with ESMTPSA id a4sm6417713pjq.0.2020.12.01.10.01.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Dec 2020 10:01:36 -0800 (PST)
Subject: Re: [PATCH] scsi/NCR5380: Remove in_interrupt() test
To:     Finn Thain <fthain@telegraphics.com.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <58cf6feeaf5dae1ee0c78c1b25c00c73de15b087.1606805196.git.fthain@telegraphics.com.au>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <0673d357-1b04-299b-3e53-169fddf9ae5e@gmail.com>
Date:   Wed, 2 Dec 2020 07:01:27 +1300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <58cf6feeaf5dae1ee0c78c1b25c00c73de15b087.1606805196.git.fthain@telegraphics.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Finn,

works fine, thanks!

Tested-By: Michael Schmitz <schmitzmic@gmail.com>


On 1/12/20 7:46 PM, Finn Thain wrote:
> The in_interrupt() macro is deprecated. Also, it's usage in
> NCR5380_poll_politely2() has long been redundant.
>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Link: https://lore.kernel.org/r/20201126132952.2287996-1-bigeasy@linutronix.de
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> ---
>   drivers/scsi/NCR5380.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 462d911a89f2..6972e7ceb81a 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -223,7 +223,10 @@ static int NCR5380_poll_politely2(struct NCR5380_hostdata *hostdata,
>   		cpu_relax();
>   	} while (n--);
>   
> -	if (irqs_disabled() || in_interrupt())
> +	/* Sleeping is not allowed when in atomic or interrupt contexts.
> +	 * Callers in such contexts always disable local irqs.
> +	 */
> +	if (irqs_disabled())
>   		return -ETIMEDOUT;
>   
>   	/* Repeatedly sleep for 1 ms until deadline */
