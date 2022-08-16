Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C73FCC38159
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Aug 2022 18:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236869AbiHPSGv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Aug 2022 14:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236918AbiHPSGj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2022 14:06:39 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014AB82F8E
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 11:06:39 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id d10so9907390plr.6
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 11:06:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=gQwLXwcP3vw8TMXsVaS3McREnnqjiuTzK8itSzItDd8=;
        b=7LaTvYV2YHonjBoF5xyxXL2TW3/eUt9M/bhn10/vMBy4ki0QP3cUVBiL0S0yruHIL7
         wVaOkstARv4LMln0wxJg9diUl9+O9+xzsWiunK5qgrTwZSCRijwr+CwSdKg98rf6hIij
         lEPE2GTfEZQD2SvoSUhdSpI0BbkzQzQ8N8TXljhS/pGcgRvtxceO+ojHuV3EFgcmtAP2
         7W8hTDubga719kOXkfTxuNcJAoVJ+5NN7zJ1mN5sIqrjeIpqLwE8/mMlb1BVbHccLoNT
         hje+ScUVDtVbFXkZV1ohI0sLlinWFcRR48FddCYNmCSuBRZJJdp0mp0RBSwrQlERdNUq
         zUKw==
X-Gm-Message-State: ACgBeo0iOfyXqVsgoktq6NDVYu0WMWm0Bj65GBtleXYzGi+yfHXZ1XbN
        PtxjYUS6u7IAhOmJAdjBT7W+mxD3aOg=
X-Google-Smtp-Source: AA6agR7rBAkPjqTbCxve3gxc/Z5tLVdX3VVehqlCeQOnuJyHS3MPNK6r8L7qgO1+P7eGJYndI8P+oA==
X-Received: by 2002:a17:90b:1bc7:b0:1f5:37a6:e473 with SMTP id oa7-20020a17090b1bc700b001f537a6e473mr24380421pjb.87.1660673198353;
        Tue, 16 Aug 2022 11:06:38 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ff4b:545d:11c8:da9f? ([2620:15c:211:201:ff4b:545d:11c8:da9f])
        by smtp.gmail.com with ESMTPSA id 10-20020a63020a000000b0041d6d37deb5sm7890269pgc.81.2022.08.16.11.06.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 11:06:37 -0700 (PDT)
Message-ID: <f6b710f8-2c66-c6f8-8441-a0e9edb2ae8e@acm.org>
Date:   Tue, 16 Aug 2022 11:06:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] scsi: sd: Revert "Rework asynchronous resume support"
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>, gzhqyz@gmail.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220816172638.538734-1-bvanassche@acm.org>
 <8a83665a-1951-a326-f930-8fcbb0c4dd9a@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8a83665a-1951-a326-f930-8fcbb0c4dd9a@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/16/22 11:00, John Garry wrote:
> JFYI, Just now I see that 88f1669019bd also causes me issues for my SATA 
> disk: [ ... ]
Hi John,

Does reverting commit 88f1669019bd help on your setup?

Thanks,

Bart.
