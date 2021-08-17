Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7585AC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 17:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 517BF60EE5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 17:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhHQRiO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 13:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhHQRiO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 13:38:14 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54AFC061764
        for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2021 10:37:40 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n12so24995031plf.4
        for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2021 10:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zDGtu7poFpYqUt/Ue2PKQOUTpV7xOXjZRAWM8a6lc7M=;
        b=EJu+UfEKsD2Wf1tmuDuIaXMjm6D1hBMRBi9czrjme/o7SQcHlYvSAQNuj3N+60ZVqL
         voE6pvGBOP+bsADO6eypndOAl9qiBEbpnyw8U1sICKmlrbQC0zTgs0yB91shW3tL3tTB
         h8FeYyRrHbL3UKjsbGnIs0P0PgTouSWcoqb1bkxb1hGuygI+OUaGVQrxxjSipXlTdWO7
         vB4HF8cIj1+a8f+vTzELInJssXdjQS5Oez4SEvmxWxIBuC3trkTXlCdA8jyjubPy+OGZ
         rmTLz8Jgw7Rn/Eg8iObbFUnz6EOf+ZHSq8pi+R1RIHy0oALuC7rjkhBo7e5dFyKSDuz+
         v3fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zDGtu7poFpYqUt/Ue2PKQOUTpV7xOXjZRAWM8a6lc7M=;
        b=IQY7bDb/0DP/tRlDjgciJn/6+eF7C7KZ1ccmFt+E3eq1YoqcEQ2dymwJ2cOf9v9pOn
         oAKTrqENowrLAOEQN3UsUg1W9x30aBzBJ2ndSSG1C615eAxMgZeBCUY4yGZ8+AP8uIY3
         0VWzf+ljVaG8vW+4XQmC9t/Yd4BkJtWQQxFRyh5eYPhPMfUP8Yryb/gFPCFP12KN3SI9
         Sci1YWpd6YbIhKyiCTEkNRrNOVGOQ2M0Q4yKM6VfIxTPgq6v0YZzP2xDhutDWf/84Emp
         JbrwiT2dzyDAt3au1HwlMvaVPRihc7D76lewxZTpgC+lRC4WFqjvjFuegB9IP/eLmwQi
         knQg==
X-Gm-Message-State: AOAM530MwpzEmEmadbolFG023yph23I/O8SGDcva1JMyZGs03Q4FP2UN
        /I/y/PJBd7csSRbUdt5AlEA=
X-Google-Smtp-Source: ABdhPJyfhdpY+iAt3LNXvvtqX5TKskBNZ9D5R95rV9pRBqKPIHhr6Zc9NE0ipX/kpgn+phE+UYSIYA==
X-Received: by 2002:a62:7b50:0:b029:3cd:e227:3486 with SMTP id w77-20020a627b500000b02903cde2273486mr4835065pfc.74.1629221860245;
        Tue, 17 Aug 2021 10:37:40 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x20sm3291372pfh.188.2021.08.17.10.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 10:37:40 -0700 (PDT)
Subject: Re: [PATCH 01/51] lpfc: kill lpfc_bus_reset_handler
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-2-hare@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <1ec03f7f-815c-548c-3b0c-5b1f879f08e8@gmail.com>
Date:   Tue, 17 Aug 2021 10:37:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817091456.73342-2-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/2021 2:14 AM, Hannes Reinecke wrote:
> lpfc_bus_reset_handler is really just a loop calling
> lpfc_target_reset_handler() over all targets, which is what
> the error handler will be doing anyway.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: James Smart <james.smart@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 91 -----------------------------------
>   1 file changed, 91 deletions(-)
> 

looks fine

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james
