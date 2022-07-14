Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50D7C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 18:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240562AbiGNSPR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 14:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240560AbiGNSPQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 14:15:16 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21DF6870E
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 11:15:15 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id x21so1136001plb.3
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 11:15:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6+8n/459vihykwjROlfXuMRYTGK27Xw615HBOX51GGM=;
        b=2h6KKKw8XsoMnhxkY3QFi1mE/YLFlxTxkah0bUldmr9ceANnadR8BkFU3f5bzyTjR9
         WoabFA48SCu69e10yhnzWKDBrL0LrIWWRSJtcxn/uM95lioS/aoXQmuP3PW1ibD9va/R
         9DxN1k4YTBrYb4TNWv0kaVufTmMDi+idTph/jT6aeGEkiIbx9lO/JxYw7nv97wjQMURv
         rK1XifK1IJwL6Mn7efhUGHdLRjjNmj7Ic6Qp8diHgqTVpknktRDv2Wr2Mbecwlsa8Ewt
         NrVPe88lRXUrDnnYMZphTWbFEttL3wMOEPzFUPGVrLWomFSsmGnQTy417y4BItZm+Qab
         vpqg==
X-Gm-Message-State: AJIora/4JiGGVKREbKJ4P3YUOF0fwqVZ3foeXh3UCnHDDwHA1JWdXiYM
        JoBmctz3bpjgtehl2DIsEn+rMk7ZjZU=
X-Google-Smtp-Source: AGRyM1vXLqPvSoMzrj9AoSxsVp+b+HzLVNL00Kg7qrgpz0KUd3IM2kK0VV5pBPERMBiF8flI63B3rA==
X-Received: by 2002:a17:902:e5c4:b0:16c:3af6:149e with SMTP id u4-20020a170902e5c400b0016c3af6149emr9683936plf.69.1657822515214;
        Thu, 14 Jul 2022 11:15:15 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:9fab:70d1:f0e7:922b? ([2620:15c:211:201:9fab:70d1:f0e7:922b])
        by smtp.gmail.com with ESMTPSA id e3-20020a17090301c300b0016bdf3d630fsm1811251plh.27.2022.07.14.11.15.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 11:15:14 -0700 (PDT)
Message-ID: <d5f800ea-09c2-b677-ffb6-3d6f2c294115@acm.org>
Date:   Thu, 14 Jul 2022 11:15:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] ufs: host: ufschd-pltfrm: Hold reference returned by
 of_parse_phandle()
Content-Language: en-US
To:     Liang He <windhl@126.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20220714055413.373449-1-windhl@126.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220714055413.373449-1-windhl@126.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/22 22:54, Liang He wrote:
> +static bool is_of_parse_phandle(const struct device_node *np,
> +						const char *phandle_name,
> +						int index)
> +{

The function name sounds weird to me. Would phandle_exists() perhaps be 
a better name?

Thanks,

Bart.
