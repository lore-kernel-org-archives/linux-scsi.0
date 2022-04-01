Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FF4C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 13:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346361AbiDANyv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 09:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346524AbiDANyt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 09:54:49 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB79280C18
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 06:53:00 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so2646862pjm.0
        for <linux-scsi@vger.kernel.org>; Fri, 01 Apr 2022 06:53:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=a0X7Y2yZEan5z+7sY+CJGpGU5EMTJBwgy9Z6myyAb+w=;
        b=rRjB2G8Gq8n3AwSoqnBqAEev2zzvrAIimVzat0+sMo3caPx9yNGquAtmWkRKC7KUen
         cBPhx+E10i2LD6Qz2yEL0dZcj/MzyKS/u9tt0wf9meIbvNJIYpVJyC6NfwtJsfVENX1Q
         8SP3uHSE4zGTQnFCLeKT2pRQKbECjLmNsWiex1pjLb2N7KV4KWLfI6e6m35JeuAUqNKN
         HKIpXg5fdcJvAq/UepTFrWvRMSC5e3tPqqm1N62+/rZHINz3i2u/bo80u/7K1bfRlmfM
         S8Ow1AYm3JlU8JSSWB5KeL9Q+Q2elshosiQ3n9j9too/US9lbKuUv6/hdJ+nkotHczbU
         Y69Q==
X-Gm-Message-State: AOAM5316G2gGGEvs03zu3SSs0AFF05bD9ugQO7EYMMmDbuWHhXmZ8Hh4
        1y0BA/O3bLMnzEHq3A8+gLw=
X-Google-Smtp-Source: ABdhPJyma+eOtZtGRuIqoMFaGxRmkD+7kbMeslDzOeKJGF02tV4DIWTGRq39I/Rpgvc4ZzhXdIP7Lg==
X-Received: by 2002:a17:902:c40a:b0:154:2302:9b88 with SMTP id k10-20020a170902c40a00b0015423029b88mr10322092plk.165.1648821180371;
        Fri, 01 Apr 2022 06:53:00 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id z15-20020a056a001d8f00b004fda37855ddsm2823866pfw.168.2022.04.01.06.52.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 06:52:59 -0700 (PDT)
Message-ID: <38ff5342-6cc0-f83c-c162-151711e5e68b@acm.org>
Date:   Fri, 1 Apr 2022 06:52:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 25/29] scsi: ufs: Minimize #include directives
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Can Guo <cang@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-26-bvanassche@acm.org>
 <3b9c8411-b778-3eb3-ef7b-0fcef2863724@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3b9c8411-b778-3eb3-ef7b-0fcef2863724@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/22 23:53, Adrian Hunter wrote:
> On 01/04/2022 1.34, Bart Van Assche wrote:
>> Sort #include directives alphabetically.
> 
> I do not think we should start the "what is the correct order for includes" debate.
> Can't we leave them alone.

Where to insert new #include directives if the existing include 
directives are not sorted alphabetically? Anyway, I will drop this patch.

Bart.
