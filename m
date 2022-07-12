Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858DCC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 17:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbiGLRJz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 13:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbiGLRJn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 13:09:43 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011C42714B
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 10:09:42 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id cp18-20020a17090afb9200b001ef79e8484aso1650920pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 10:09:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TBWdw56eZI8s1d9+d0OKjJQx9tXYjMQLlO+6Bepl8OQ=;
        b=q+JHkpUAF6KcFXaO0Tjs2rx81ju85Nno/ikVlphOi3K8uNIXv9iwQjHjWJEqXRPKZ5
         IpWlc8w4ZyVaXt8wEg3b6X4fFkNA5mpaogdlYQLCNTfvydcBHbqzUCksk4PJoSqFlI3f
         OrqzodH+lmOR9v1oooRT16E/sfCXiXYj0ECogQi3H3R0afqs21Ai611dW7qaQFeq/Kuc
         dQ3Ee2B/cLUOxOZDBI7VLA2tpR8/bVcReBh7zuwKXLiPDzHCAlcEuMWtLnTgSThhA9o/
         2pdkY/7uW2a0Cg/TVLZ4n0+/mkxpL8+sYE8QAR9Xt5A3Kjc/FKxNPX9IvibgpqHsoA8Y
         uY5w==
X-Gm-Message-State: AJIora90bJTREcHyDI700YyK2Ufv2740+VOOplxRQVM4m60bmpwFNw53
        xOA6dejzdbEnxj/xvyXmvXY=
X-Google-Smtp-Source: AGRyM1uLVNdihNQBNwi+sUIF5wgxrL1B8B/CAZFX5qABoWJ7rO/Qfz1WPJ1LSloueRiiwICdGsTQcg==
X-Received: by 2002:a17:902:ec8a:b0:16c:4baa:a50c with SMTP id x10-20020a170902ec8a00b0016c4baaa50cmr11508831plg.62.1657645782336;
        Tue, 12 Jul 2022 10:09:42 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:de3c:137c:f4d2:d291? ([2620:15c:211:201:de3c:137c:f4d2:d291])
        by smtp.gmail.com with ESMTPSA id kk8-20020a17090b4a0800b001ef899eb51fsm9324042pjb.29.2022.07.12.10.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 10:09:41 -0700 (PDT)
Message-ID: <c5a1e410-091d-5338-a9e0-d5b9a968154d@acm.org>
Date:   Tue, 12 Jul 2022 10:09:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/3] scsi_debug: Make the READ CAPACITY response compliant
 with ZBC
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>
References: <20220711230051.15372-1-bvanassche@acm.org>
 <20220711230051.15372-3-bvanassche@acm.org>
 <625056aa-0604-d1a9-e1a1-0efef70a5de1@opensource.wdc.com>
 <35c22b90-13d5-10b9-4677-fd3214298105@acm.org>
 <8e69a9f9-b0ef-b129-da6a-9ea7bfbd58a6@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8e69a9f9-b0ef-b129-da6a-9ea7bfbd58a6@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/11/22 17:53, Damien Le Moal wrote:
> On 7/12/22 09:33, Bart Van Assche wrote:
>> The above looks valid to me from the point-of-view of the ZBC-spec.
>> However, reducing patch 2/3 to the above would reduce the number of code
>> paths in the sd_zbc.c code that can be triggered with the scsi_debug driver.
> 
> You lost me... I do not understand what you are trying to say here.
> You patch as is repeatedly sets devid->rc_basis to one for every zone in
> the zone initialization loop. Not a big problem, but not necessary either.

No worries - I plan to use your implementation because it is simpler.

Bart.
