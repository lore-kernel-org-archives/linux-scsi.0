Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E0DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 21:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391619AbiEFVEQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 17:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444309AbiEFVEP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 17:04:15 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1BF1EADE
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 14:00:31 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g184so4518415pgc.1
        for <linux-scsi@vger.kernel.org>; Fri, 06 May 2022 14:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=rHDXE8PeP2Ay8M4994Qn3PWFDqlwloSb9G5ggCzXMG4=;
        b=AjQki6uyITSGgBUl6bjMKbxapKdWr5xm6NLMY3vvY5eOPKDcLGmnYkjS6JJAzniukc
         q9gD74c+Ro496jjVWB3vb5UpKBxH2Vk2V57RDf+w0h6mequInP7DgLtul89kTahSNV0s
         U3lr+5j+nJRS280DxalOUgES5gn/0PM5E2lya06ajxTZJnFLqhl4QQ+YIyO11RIOT7wL
         qFWv6Zs1KmmMSV0ym5wERVziBTTgkztOGm86vUX8UCOf85IGwm0FUSAvH7HLaiCoMtB0
         d9eIQIB3mCXofRtThyuDkQCw4LnE/LqGBNmOQw9mcAcNBQ7UjDda04D6fHm6FQ0XYYRg
         rNYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=rHDXE8PeP2Ay8M4994Qn3PWFDqlwloSb9G5ggCzXMG4=;
        b=mk/GUg9/FEuAQHczZCGCagAD1Tf0mQPNkvnP1XLx1m1MiH4mX1Z/obb2Q4RtgNrHiC
         pZtQk/e0Qvi1fTdvS+jcbvHTd+PxVzojn5KGrsIRbyELF5ueGQ66mSibNSI8jDT/0spx
         OCDtWDJsKt+3K95DGySNeCXo7XDqWgN+EQ61BL7Z26ZeIfjCNFLzCC0I1a4g7OXJduzF
         7j/0st1funueutVvNXWaY07p+VeDNVMd8nQqMso+BX3ukyOmsH9WeknTq8jjvd8WT2YT
         MEyD3se3PzydALRiv8tzHGAI+o612yxqff+8N2YCuVap9wO0cH5Ge5wSBKUcj9BpI2O7
         ZHdw==
X-Gm-Message-State: AOAM531EjReaP0LjC32OqRcIfSMRSWELD4/H9MrUWAmrXG+XQC74qiPX
        xG2WKoyOFA8Ct/RJHEQ75Mg=
X-Google-Smtp-Source: ABdhPJw4LP0nfV/TP9syjjBE3wR0rKrOJVbS43F9poqTnBHqPbEtO+UzaWSR0Hs9tf6RnylJmjmkgw==
X-Received: by 2002:a65:6051:0:b0:39d:1b00:e473 with SMTP id a17-20020a656051000000b0039d1b00e473mr4162828pgp.578.1651870831486;
        Fri, 06 May 2022 14:00:31 -0700 (PDT)
Received: from [10.69.47.244] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bt19-20020a056a00439300b0050dc76281f2sm3709589pfb.204.2022.05.06.14.00.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 14:00:31 -0700 (PDT)
Message-ID: <47fab09c-641a-b827-ecc6-7af55c44144e@gmail.com>
Date:   Fri, 6 May 2022 14:00:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: lpfc: regression with lpfc 14.2.0.0 / Skyhawk: FLOGI failure
Content-Language: en-US
From:   James Smart <jsmart2021@gmail.com>
To:     Martin Wilck <mwilck@suse.com>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Justin Tee <justin.tee@broadcom.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        David Bond <dbond@suse.com>, Hannes Reinecke <hare@suse.com>
References: <9d7e7a5613decc1737ef2601ebb2506890790930.camel@suse.com>
 <4a7f19b6330c3017c45074854cf86b04224e7706.camel@suse.com>
 <f9b4c954-b5b5-d40c-b3dc-974757134daf@gmail.com>
In-Reply-To: <f9b4c954-b5b5-d40c-b3dc-974757134daf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/5/2022 8:08 PM, James Smart wrote:
> On 5/4/2022 8:55 AM, Martin Wilck wrote:
>> On Wed, 2022-05-04 at 09:11 +0200, Martin Wilck wrote:
>>>
>>> Hints appreciated. Complete logs and additional debug data can be
>>> provided on request.
>>
>> Further analysis by David showed that the FLOGI via FCoE was using the
>> VLAN ID.
>>
>> Martin
>>
> 
> We believe we understand the issue and are testing fixes.  Will keep you 
> posted.
> 
> -- james
> 

FYI - patches just posted:

lpfc: Fix split code for FLOGI on FCoE
https://lore.kernel.org/linux-scsi/20220506205528.61590-1-jsmart2021@gmail.com/T/#u

lpfc: Correct BDE DMA address assignment for GEN_REQ_WQE
https://lore.kernel.org/linux-scsi/20220506205548.61644-1-jsmart2021@gmail.com/T/#u

-- james
