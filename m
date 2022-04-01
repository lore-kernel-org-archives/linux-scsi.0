Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C5EC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 14:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346744AbiDAOOe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 10:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346742AbiDAOOd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 10:14:33 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AA028255D
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 07:12:44 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so2701012pjm.0
        for <linux-scsi@vger.kernel.org>; Fri, 01 Apr 2022 07:12:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JQA1XcUQ+BrWkC433VlBYbaA4Xjf9WzlTFwUjSbVr04=;
        b=RJ3SjSWktPJb3hXlcLS1kQGGsao4sVzEOiX8BNvM0YzWTSugw8vfJnwvkdIuuL+cOT
         1Zj6j1e9vPFJ1r+hwfRjINwC0tJSPIzb06XLNMlwnmnviTr63g8mDB9cEikcb++QECgF
         01vYIrEWgj++2eF03ZPobNQ6qsFm2EqL3a6cYf/Z20KNfJ00bgbYXijZSMm5Qz84OttW
         67qybFkjMeUYPvmmp/BGExMJuCRzDiBBXF4ZemYPoN3HVgo/Stz3rgDB26tHF2mdpwyg
         oI7LGGqXbWE75JVBosHoixOTxKvzsLH2hwjBQazsAXFMowwZEQHLhVLM9V8Ie2gIvGwU
         9Jvg==
X-Gm-Message-State: AOAM532wCVVK5InVSE1VKx6Vz9ZyCwE38Bp40vVj+ZerrcmkOA8mZKrq
        tBBy8sIQbZD21ogqOAwP2mo=
X-Google-Smtp-Source: ABdhPJzu5NJiX/8UOK2v1AM22waWxpPU8Epgn/EIwSJiN80gc7uXhfmIoM/zXNHLMy972zPx7k1qUg==
X-Received: by 2002:a17:903:2309:b0:156:137b:8ba5 with SMTP id d9-20020a170903230900b00156137b8ba5mr26399191plh.84.1648822363967;
        Fri, 01 Apr 2022 07:12:43 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id l185-20020a6388c2000000b0038614ed80c0sm2798862pgd.41.2022.04.01.07.12.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 07:12:43 -0700 (PDT)
Message-ID: <eee8d304-aacd-9116-9e2d-92e2e3682b5b@acm.org>
Date:   Fri, 1 Apr 2022 07:12:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 00/29] UFS patches for kernel v5.19
Content-Language: en-US
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Can Guo <cang@codeaurora.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <60dc8a92c7eda8f190a8a6123bc927e8403bdbb1.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <60dc8a92c7eda8f190a8a6123bc927e8403bdbb1.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/1/22 02:32, Bean Huo wrote:
> Agree that the current UFS driver is messy, but I don't think there was
> such a big structural change before UFS 4.0 was released, especially
> the design of the UFS CQE driver. If you already have a plan for CQE,
> it's best to state it in the patch. If you have made such a big change
> in an environment that is now very stable, do we have to make changes
> after UFS 4.0? ?

Hi Bean,

Although this patch series will make it easier to add UFSHCI 4.0 
support, I think that UFSHCI 4.0 support can also be added without this 
patch series.

I'm not sure what CQE stands for in this context? Did you perhaps want 
to refer to MCQ?

The following changes will have to be made to add UFSHCI 4.0 support 
(this list is probably incomplete):
* At driver initialization time, query how many queues are supported by 
the UFS controller and set scsi_host->nr_hw_queues accordingly.
* Modify all code that submits SCSI commands to a UFS controller or that 
processes completions such that it uses the UFSHCI 3.0 registers for 
controllers that do not support MCQ and the UFSHCI 4.0 registers for 
controllers that do support MCQ.
* In ufshcd_queuecommand(), use blk_mq_unique_tag_to_hwq() to derive the 
controller queue index from the SCSI command data structure.
* In the command completion path, use scsi_host_find_tag() to convert 
the (MCQ index, command ID) pair into a SCSI command pointer.
* Add a mechanism to fall back to the UFSHCI 3.0 registers (no MCQ) to 
make it easy to test the UFSHCI 3.0 code paths with UFSHCI 4.0 controllers.

Thanks,

Bart.
