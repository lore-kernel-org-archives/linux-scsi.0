Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F2DC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 15:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5CA3610E8
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 15:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238120AbhHXPL5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 11:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238059AbhHXPLz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2021 11:11:55 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EC1C061757
        for <linux-scsi@vger.kernel.org>; Tue, 24 Aug 2021 08:11:11 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id e15so12416014plh.8
        for <linux-scsi@vger.kernel.org>; Tue, 24 Aug 2021 08:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F67ac31IUqZfO988GqI94wpoikStxk7CmlqdiJwLIAs=;
        b=LddFsKapeOUBXEI1HvtXGJp8kaROz4fXNEcZXZ1iKR9b4FtRHbSzVSX2DdBwY9Fyuc
         IFfvWuQrFGUfMyHxOGEPStVWbd5dOEUbtUHQhcP/+VidJ2BiDLgTMG9xyAN3oMMySfAu
         f+C+Jv3OGfkJ/mb2JWu577cI10dQcvWeI19cW1e4t5WBzb199/TXdaDmrBxKXXfAQis4
         Oxi6d1Ad6o66eR4+ny4zngiWBYjPtKK/6I9OWK4QeKoZKz1gBCoztMD4jGBPekcv+NkE
         b2FlonlWsw/dmzMZO5HQswHWRTIM9XvIme5Obmt/LLt2aXbskIRiIKaDLbrecqF3hXqA
         kLlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F67ac31IUqZfO988GqI94wpoikStxk7CmlqdiJwLIAs=;
        b=NaKlRQweTVPcF5MqQ6pnvw1FHVPFuAa2J7GQCOykSu+bOkEiU0rUyUpT3qKgKHmbZE
         /fMC/CUfDc/i817QTYILUYxNPlwqie0cp/ehk2+Stq9EYj0AwdFL9pm/ML/RKtvLy9kx
         qakJo+p/QMoC/Ts1I960UUIt63OoFt/YJSxGBuZENixmaYgVjvkNX1ULHUOQfZR4W/KU
         Ja5AcmX4uFPle7JQNppWlBYW7sE7y2jw2zVqzaYWJPOT9uydB8cxs7yUdilZl0/feZ7Y
         ePqIAMGKi/r3yoUXoUYII5Fk9Y5u6nMHcnW9tlccps4emyT24SFsQg23H0CVsuyu4Iq8
         UOFQ==
X-Gm-Message-State: AOAM531e3kDmU3rL8v1ldlS89wbD4AxG2NjnHm0BVwgehOzNDub8E28c
        lrXMnc5xAZBdkiIFvhfKpMc=
X-Google-Smtp-Source: ABdhPJwzUKCmxyhM94XZud6vEEjHziGaFUAdGPBevT4Je/R9qdPelfrzfDPzpQ9zzFyfeXyvjQl2eg==
X-Received: by 2002:a17:902:e2d4:b0:134:17c2:14da with SMTP id l20-20020a170902e2d400b0013417c214damr10500700plc.52.1629817870547;
        Tue, 24 Aug 2021 08:11:10 -0700 (PDT)
Received: from [192.168.1.40] (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id f71sm20643273pfa.176.2021.08.24.08.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 08:11:10 -0700 (PDT)
Subject: Re: [PATCH v2 5/5] scsi: lpfc: Use the proper SCSI midlayer
 interfaces for PI
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
References: <20210806040023.5355-1-martin.petersen@oracle.com>
 <20210806040023.5355-6-martin.petersen@oracle.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <0312fe17-1536-3b57-a1e9-2b551652de07@gmail.com>
Date:   Tue, 24 Aug 2021 08:11:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210806040023.5355-6-martin.petersen@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/5/2021 9:00 PM, Martin K. Petersen wrote:
> Use the SCSI midlayer interfaces to query protection interval, reference
> tag, per-command DIX flags, and logical block count.
> 
> CC: James Smart <james.smart@broadcom.com>
> CC: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 116 ++++++++++++++--------------------
>   1 file changed, 46 insertions(+), 70 deletions(-)
> 

Looks good.

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james
