Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F483C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52EE8613D1
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243642AbhDUUU6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 16:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239205AbhDUUU5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 16:20:57 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B4CC06174A;
        Wed, 21 Apr 2021 13:20:23 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c3so11166655pfo.3;
        Wed, 21 Apr 2021 13:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jae3Hw3SWDj7jWLYD6f3SsT1PsOuBFLti/qy9DGNGts=;
        b=YIFeWOnNbrzhj2tciJ47rw3epSBGPTfFGW4KToLEuXCmkGW3Yx9WRpheVLxx0Q4ygY
         N0vfuP1w39UbQEa97Ho+Wz6/rQ2xf7YvECjcZaAi6IUTH7QB7dIJV+I7BLC2DkvhNP0e
         yvs0aMQSkjBRSdtedHuhbR8hq+Dh9iHiRiux2OgrXlrtiEOZHRmWfiEXKmsAay+eGwWl
         /SdOLGDBP+eZbT/OAv8E/tzAKlZtwa5uFlNrT1okx5wf1wc0VvXS1KeV4NmzNRLFBNmb
         hMwG6JLsmtExz2WquMg6NUKte0xBviXUuTAqAdQhfWT23QxsJpbck6/7k9uizlNPQpKS
         a+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jae3Hw3SWDj7jWLYD6f3SsT1PsOuBFLti/qy9DGNGts=;
        b=so53cZd/zohzfM+qXrOXEtEzfaBcf+47NbJcmUIkNOcIPaZIgmDY2/M/WL/sQWfErB
         x8bLejGUyEN2YDqTgLyab0f019uzz6K83CppN316vFJNo/fNpyXC1pGsDvUjCGbjz6YY
         ZDcVIXalSiljmKVOglOY28+uC2WMsEhG57GEpCamSsGu1Ubr371qRLqiyhQWhK1byI75
         Of/xra76MmekJUsUOM/SmcWyz6fxGgQeWn21ggLY+HK2vncSdnwVEYpAvPTjsgbXV8o+
         JpKIq2ODPyHIYXI37BelHnUSeyycZpzvcbBnfy/8TSulVqbgGar8tN6zbFye2AyNVdnc
         vH3Q==
X-Gm-Message-State: AOAM533dq9ABf+ypOCMyW42V3fdKfrWB9Yj+d3+aK0NCYB/uNzZd9Lnp
        CtjdHTPNWhnRYBclAGb3SGD0SYFGVvI=
X-Google-Smtp-Source: ABdhPJwCERt83sS3P4ZAgNpy2u38gdnZEDFG2XZKImDNJoDP2gCCS9eeWYws68doDLCdQqqCf0QKCw==
X-Received: by 2002:a63:6ec3:: with SMTP id j186mr23051120pgc.249.1619036423003;
        Wed, 21 Apr 2021 13:20:23 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x18sm3052590pjn.51.2021.04.21.13.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 13:20:22 -0700 (PDT)
Subject: Re: [PATCH] scsi: lpfc: remove redundant assignment to pointer
 temp_hdr
To:     Colin King <colin.king@canonical.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210420104123.376420-1-colin.king@canonical.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <fc6b1a12-de2e-de91-021e-30bb0a1e5732@gmail.com>
Date:   Wed, 21 Apr 2021 13:20:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210420104123.376420-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/2021 3:41 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer tmp_hdr is being assigned a value that is never
> read, the assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Thanks

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james

