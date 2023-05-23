Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2131AC77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 19:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238275AbjEWT5Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 15:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjEWT5X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 15:57:23 -0400
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBF711D
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 12:57:22 -0700 (PDT)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1ae52ce3250so633735ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 12:57:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684871842; x=1687463842;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aEMR/1fYgZN6Ufgt/aUQUbsl8vCT2KNtFgYxGRfJPxg=;
        b=kXyAlR+evnCnuI+i55ssRRRGam7vts9Z24zUtFqI3e6du6w/EMS2JUC8TZYQHylPTv
         2NhN5iQll+oxxols7Xs3TOuN9mnb4tD/7hY/m9znNDI0ywtECGYCGNbQy0X6Q77HwbGw
         ilVp95+3BcOEnzj8qvP87MhcGI1gJUOMUTqyq6uRHCZdPsp8sqTvi0jn+o5VWh3BGriI
         o7tyUXZyLNlNztwUgcfPhRUi6JqjPrR7bJOOPquit1gfwXtDubi5e2odQvMa3Md+Jkqc
         D0WzVnOszVkJSlLFTGaOVEbTp1DGGokZJgVnl9yxETpXiinrBsRwCTyhWr8eF2AEZUKS
         Phww==
X-Gm-Message-State: AC+VfDwkiymkmDNU/BHd8lfgXc/jOQHWqIePfxQlpEWm38Ic/8HIQBR7
        chYooZAJV82N97XNe+BqmCeb47Jq9sM=
X-Google-Smtp-Source: ACHHUZ4i1vezEVX5Nb+E0HnDxfokdOCsQCeWsUhkgQj5LjDgTj3Y68eaEU+DKZgU2Z6Eka/Ki+7/8w==
X-Received: by 2002:a05:6a20:4315:b0:100:74c5:f916 with SMTP id h21-20020a056a20431500b0010074c5f916mr13899724pzk.40.1684871841931;
        Tue, 23 May 2023 12:57:21 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:24d2:69cd:ef9a:8f83? ([2620:15c:211:201:24d2:69cd:ef9a:8f83])
        by smtp.gmail.com with ESMTPSA id e26-20020a63501a000000b005143448896csm6390734pgb.58.2023.05.23.12.57.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 12:57:21 -0700 (PDT)
Message-ID: <2d37028b-c7a1-f2ac-abb5-e85c00aceba2@acm.org>
Date:   Tue, 23 May 2023 12:57:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 3/4] scsi: ufs: Enable the BLK_MQ_F_BLOCKING flag
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230517222359.1066918-1-bvanassche@acm.org>
 <20230517222359.1066918-4-bvanassche@acm.org>
 <957fb6d6-83db-6230-d81c-646e12ed7bf1@intel.com>
 <343be0eb-0650-cc5e-3154-ffe30f92c17d@acm.org>
 <cac55dea-ec77-2802-f975-89a1cb1c734f@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cac55dea-ec77-2802-f975-89a1cb1c734f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/23 12:19, Adrian Hunter wrote:
> On 23/05/23 20:10, Bart Van Assche wrote:
>> The overhead of BLK_MQ_F_BLOCKING is small relative to the time required to
>> queue a UFS command so I think enabling BLK_MQ_F_BLOCKING for all UFS host
>> controllers is fine.
> 
> Doesn't it also force the queue to be run asynchronously always?
> 
> But in any case, it doesn't seem like something to force on drivers
> just because it would take a bit more coding to make it optional.
Making BLK_MQ_F_BLOCKING optional would complicate testing of the UFS 
driver. Although it is possible to make BLK_MQ_F_BLOCKING optional, I'm 
wondering whether it is worth it? I haven't noticed any performance 
difference in my tests with BLK_MQ_F_BLOCKING enabled compared to 
BLK_MQ_F_BLOCKING disabled.

Thanks,

Bart.
