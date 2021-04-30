Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 825E0C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 15:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A1A56145D
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 15:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhD3PoG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Apr 2021 11:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbhD3PoG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2021 11:44:06 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB06C06174A;
        Fri, 30 Apr 2021 08:43:15 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id t4so22633654ejo.0;
        Fri, 30 Apr 2021 08:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DxLuz6zxlWQreauy+362yBCD+2mrUuEObBBoPF+b4Lo=;
        b=JF389vOx/7hgJ0QZ7mJVp93d+3s1Yduyp4zgZC36QBIsm+ktTWU+jrLaRQ+dPT9onu
         8PouW6XdWGwNtGWZdTEU0B25x5ZRlf+bH5wzHXgy+ETBLiIz/4p2ScQjYlVtV8c6sDHS
         xSmtTWm4D2KJDaih6TF8xVBqPYnASRLaNr/CXUy3DlNWSnUVJFXkEL+B4pKUe44NQw/O
         1TTIATL5UJQiTTH3kkpsnu5e7kgGQbu23f5fuxuwsWVC4ugfJoJKE7XhRiRsOo8wBIgU
         vPDEHSM4mi4JIkQp6ieeTvP0hYZpJOb35L5DXv3Ugtk/g6DWDwgxgLXxS1rVFvV/3q0f
         +lIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DxLuz6zxlWQreauy+362yBCD+2mrUuEObBBoPF+b4Lo=;
        b=Z8fDMSctqKzNOZtQjBr19hO0qgovc3tBODg3sM/sxX1fzjM3yGayiG/pQ7GOlEID/x
         2VQag7e9Vm+bk1iZhGDMB39GV2+Ict8BmGgyoFlJ+PO1bRkzhgSgXMkMAfgn/ODTf3VF
         PuY0V2qR5c3pBX6AP8kuE8mVGfO0aLumkBdLN59w0Bq4AClH2eyzZg1CyqaN852x6HA5
         75u38svrJG3OCPuWI4hFHKtdxkkJP4ap48cp01+Q0cxXg8sMPjM9J/r3HRQY67hrdDfM
         ieM0u9pJkTMjW0MQzMZU6ZaerQROrCxPhtq/wnEcjGgIIlKkrzZXavRW1Is9guALEPAP
         NyHw==
X-Gm-Message-State: AOAM530yGYfxW4R7K1Xv5FeXIpm0jcr2ok8+lt0eA69Wjery/DLt73tg
        lbGUdQFTihzbVESnacm0uhL6JsTGom8=
X-Google-Smtp-Source: ABdhPJx4lt4NPgik3Npc5jEdzsOqNJ39xlemogXfnYRBoORbSiVjWiIICt1MEopwjEu4TOzgcv4JbA==
X-Received: by 2002:a17:906:33da:: with SMTP id w26mr5147543eja.472.1619797394382;
        Fri, 30 Apr 2021 08:43:14 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id e11sm1590716edq.76.2021.04.30.08.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 08:43:14 -0700 (PDT)
Subject: Re: [PATCH] scsi: target: configfs: Remove redundant assignment to
 ret
To:     michael.christie@oracle.com,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1619774627-118766-1-git-send-email-jiapeng.chong@linux.alibaba.com>
 <69ef77bd-4ef8-6446-8192-6d8569516f33@gmail.com>
 <90e67d9f-e524-62b4-df04-2ea2ea28559c@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <3fad772f-51da-6415-76a4-ed248736ced5@gmail.com>
Date:   Fri, 30 Apr 2021 17:43:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <90e67d9f-e524-62b4-df04-2ea2ea28559c@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30.04.21 17:40, michael.christie@oracle.com wrote:
> On 4/30/21 9:29 AM, Bodo Stroesser wrote:
>> BTW: why is "initiator_sid" input handled as string?
>> core_scsi3_alloc_aptpl_registration later calls get_unaligned_be64 for
>> that string. I don't think this makes sense.
> 
> It's broken.
> 
> Remember the isid patches that you reviewed of mine trying to fix the
> isid code in target_core_transport.c? I can't remember all the details but
> I think it was that the aptpl code thinks the buffer is in the format that
> sess_get_initiator_sid uses and is trying to do something similar as
> target_core_transport.c.
> 
> I can't find the version of the patches you had looked at. This was the first
> version of the patch:
> 
> https://patchwork.kernel.org/project/target-devel/patch/1531696591-8558-3-git-send-email-mchristi@redhat.com/
> 

Ahh, yes. I remember. Thank you.



