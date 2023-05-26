Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7634DC77B7A
	for <linux-scsi@archiver.kernel.org>; Fri, 26 May 2023 17:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbjEZR1q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 May 2023 13:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjEZR1o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 May 2023 13:27:44 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87B1189
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2023 10:27:42 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-64d2981e3abso1005936b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2023 10:27:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685122062; x=1687714062;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6SgvqZclBsbrQ6Noq6Bp4if5AukP3ccIM+FDuaxMSf8=;
        b=F4vTXHtTCDrsWgsyeeo7w+cLuTW/JKtHOZMVNTdmqrWzThHto3yu7bmFLu7P3V4sAB
         6lE2i8Xrin57/8gTE/PNT9u45LBN7+qse+QTFI9GKEy6tQHpZ4o3/6ic6svDUs/GCR51
         uNNDx9AYbvenNDGzWV0+LAXDfVv6cnDVqBajrhqRdipUKF75xSetruYKWWA1W8W47k6Z
         8k/YgytpHDq0//KxwNo3qzgfdiu+7cIA/GStd6DtSiZ4ZadK7bdv23VZ95nNTlFZHiSj
         sa62WvlIxolWOcmyyjjXz/ExNbPklV5POYKCjpNNcGB8qDWrOGT8KH/QeiKHXAyfsafU
         wNag==
X-Gm-Message-State: AC+VfDxAPtkZ4LXN3nnxIGu6vRaMg6NB8UoYB6ErAnZIjQCgVuS9VLDQ
        7zKoUkEYxxfU5XV4W0JFwM8=
X-Google-Smtp-Source: ACHHUZ74oOLdfo1wA0w6kZszxgBCpW7ZBxxrTHK5Unwd33usTqmKcy7SDDd1+v52QseUJR5BmtoO3Q==
X-Received: by 2002:a05:6a20:7fa7:b0:101:9344:bf82 with SMTP id d39-20020a056a207fa700b001019344bf82mr144885pzj.15.1685122061753;
        Fri, 26 May 2023 10:27:41 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id n23-20020aa79057000000b0064867dc8719sm2945263pfo.118.2023.05.26.10.27.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 10:27:41 -0700 (PDT)
Message-ID: <13c4abf1-19e0-190c-4c2f-543243955986@acm.org>
Date:   Fri, 26 May 2023 10:27:40 -0700
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
 <2d37028b-c7a1-f2ac-abb5-e85c00aceba2@acm.org>
 <096e1a7e-ea0d-de46-ef82-02a755635640@intel.com>
 <6112c17a-15f3-4517-c73f-8cbbdde20a6b@acm.org>
 <182cc063-e897-cd7d-d859-809da0e4fc2d@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <182cc063-e897-cd7d-d859-809da0e4fc2d@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/26/23 00:11, Adrian Hunter wrote:
> Why would we want to when we don't have to?

Anyone is allowed to formulate objections to a patch but when objecting 
to a patch or an approach please explain *why*. I think I already 
explained that unconditionally enabling BLK_MQ_F_BLOCKING makes testing 
the UFS host controller driver easier.

> So with those fixed and the vops->may_block instead of vops->nonblocking:

[ ... ]

I think a much simpler solution exists. I plan to post a new version of 
this patch series soon.

Bart.

