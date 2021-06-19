Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FEBC49361
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 15:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F08D961208
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 15:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbhFSPqU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Jun 2021 11:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbhFSPqT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Jun 2021 11:46:19 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61429C061574;
        Sat, 19 Jun 2021 08:44:08 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t19-20020a17090ae513b029016f66a73701so2576629pjy.3;
        Sat, 19 Jun 2021 08:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mJ8ciRbQ2lO8UHWJfa628WqKJFKR2FlL5ojoM+D1QKE=;
        b=G9YLY8t1z5ZuvZp2cN8iCFOLS2Dz8F3r+WuxZW4k9hhosNt1H/Gk+hneR2xPAEOm/J
         Xq95p2RyvGskZLnvKyxQw8+oaBCbvZWABcIRAVKb5aSow3SNAD6xamX9NhFmJO2lPEkT
         0956IyXRbqMNvkVYHvsf2KOPx9mqpyGbn1gAgjuH6MMzywlOh28U/LDTv7yOGJxjzBe+
         WrlF5n3GIaoRQ+RARwV4DlI22tXUvnNEkcRslzTbsl9hra2N/lbshaXyYaErw7yZCTB5
         ViwranLvyI8LnCunawX6FoJCZg2/Hs5LzbLxYiV8WeLe3rYP85ydHSz8lHYvfQmxIJAo
         5/ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mJ8ciRbQ2lO8UHWJfa628WqKJFKR2FlL5ojoM+D1QKE=;
        b=qgLGwoqiEGojl5yPexnalM0iVA5Z6nqh4l6UU4QAwPywDyJQeNLgI+0iFdQzWTWG4S
         69FmLM3gzF2Bt42wSVATamq8P3M5G+esYKMmoTIqCNKLmJamTXfdcSkVDDkK16S7owlY
         hAvlRj0h3iX8z9FwGBJLkjQi7zFNno9Bi0zTm8Ef4U+OxsEJ/tOLsENJWCzANeoc04+X
         JM4La9Gb38n+vztI7TlmKVc46iOvPdlkR9P/h2RfarFjFMK9X9l7n27vNQyHizXjRvGZ
         qBlSM1LD40AyQ5GsKgl9ZWZrCJG1hi6MNCZOio0LVTbKzTrGkQofHnOo9kc+L/KDZd33
         rhAw==
X-Gm-Message-State: AOAM531smMANGQmf3hdFk2SBHDwRPnfx9aU+uq70E6+ZUiNTk8Twa/+B
        lqQ5oz2vVvTKgXG2HFkF8Qtq+6KtzeY=
X-Google-Smtp-Source: ABdhPJyUThXxvTOclcRSXBYnmcpLsVOYUMGTXzVz71kVo4oc4TA7M2/woazVn8O45HxcNLF81s2CqA==
X-Received: by 2002:a17:902:d211:b029:110:a94c:74b3 with SMTP id t17-20020a170902d211b0290110a94c74b3mr9791253ply.54.1624117447842;
        Sat, 19 Jun 2021 08:44:07 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k21sm11656920pgb.56.2021.06.19.08.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Jun 2021 08:44:07 -0700 (PDT)
Subject: Re: [PATCH] scsi: elx: libefc: signedness bug in
 efc_d_send_prli_rsp()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        James Smart <james.smart@broadcom.com>
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <YMyi4LNaVmD7kQEN@mwanda>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <2bd91d5f-5dac-bbaf-361a-7594c1e84f6f@gmail.com>
Date:   Sat, 19 Jun 2021 08:44:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YMyi4LNaVmD7kQEN@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/18/2021 6:42 AM, Dan Carpenter wrote:
> The "rc" variable needs to be signed for the error handling to work.
> It holds either a negative error code, EFC_SCSI_CALL_COMPLETE (0),
> or EFC_SCSI_CALL_ASYNC (1).
> 
> Fixes: 202bfdffae27 ("scsi: elx: libefc: FC node ELS and state handling")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/scsi/elx/libefc/efc_device.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks!

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james

