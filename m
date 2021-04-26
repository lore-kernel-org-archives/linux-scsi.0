Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874C3C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E92861263
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbhDZDTo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:19:44 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:40449 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhDZDTn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:19:43 -0400
Received: by mail-pf1-f176.google.com with SMTP id a12so38023796pfc.7
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 20:19:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P0r/5jyX1Q44eaCxrcmZXzjExvfnNZb34Z3M9IA7gB0=;
        b=CtJfvmc00iBvFLOEoPxsgaKACO+gDNmJxU4Y4IFrB3RNNY8wafuHL19524j1HBS+Tf
         U/LwNqfI18YdgDBtyOaD0slV0ZT6twaKIxzxkyL2dAyh3jtdhA0a/B6KfGw15y6WcB2g
         YDWlEZVGpfNVPms5MJGu0khn5/zyyXBJe0LfAGwobgS6EPhy6YkZ6TMvk9ho8MW9/yb+
         JVUeD+aLsN8ft9gjaCJADb90gwwywOku/9x9BYyvVvPUIyiQm0dYDRTqsPrH5II8XSKE
         f8yC8TTAuKo9C1ZR2RtZV8cUHeIMFvemGMGXO6Ge72nW2JHu2iMjFJu7kcU/SNNS7vUO
         Fzvw==
X-Gm-Message-State: AOAM530OG19AlQ2lI/sKmznvH81Q5U+q17Vis5VmA37n04y4EYkEHF7i
        eGjJyX3wDxVG9T86eIdmownso4HAFAsMzg==
X-Google-Smtp-Source: ABdhPJx0sN6nakeVCtMH3OwrLgmTfMxlB2l7bNoAscKAKoq/PdMrDCfwqBBVaB1Q8m/6sSxDgewYIA==
X-Received: by 2002:aa7:8f3b:0:b029:276:93c:6a29 with SMTP id y27-20020aa78f3b0000b0290276093c6a29mr4039799pfr.1.1619407142204;
        Sun, 25 Apr 2021 20:19:02 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id ms8sm10283295pjb.57.2021.04.25.20.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 20:19:01 -0700 (PDT)
Subject: Re: [PATCH 01/39] st: return error code in st_scsi_execute()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-2-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4a45f32e-2fe6-d000-9878-fd378804532b@acm.org>
Date:   Sun, 25 Apr 2021 20:19:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210423113944.42672-2-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/21 4:39 AM, Hannes Reinecke wrote:
> The callers to st_scsi_execute already check for negative
> return values, so we can drop the use of DRIVER_ERROR and
> return the actual error code.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
