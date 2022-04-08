Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8395C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 14:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbiDHOno (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 10:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237129AbiDHOnj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 10:43:39 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5D1EFF91
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 07:41:35 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a6so17899011ejk.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Apr 2022 07:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tjDThIRIxO5eG4TZnceuw1yUZbikQUzYOc7ZiF8v3QY=;
        b=dgarG2H+5baVdk6FIVhaeFEUY9byb22S/v8bfgLoJHSNv+o/FfXGfoDKf2POnMlF6c
         YI+aIBlVgcFbCf7THAB99kDMkdp6TFegES9b2ho2Lgiv3/t7FTy+s3wYVfmzdMqnG9Ba
         NDJEjQrpiZvPW9Qhvul5Rg4/0k45OvirII1KRs3BfBecZHlZolKwnr3y0ArYnN896Q9L
         8JY0mM+zLUlZh7cF1a4+HSRZ12Bu0KX9ikMeSlAYXktkuNStt5bEBgLFSVtQgBWxGKpt
         6l9Hd51Qw05dnsQX0nj5ovpG8fsOZS6DEfl/myhNZ/L/EsgsJG4Ya0XMPhwXuNUW9HF5
         BoEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tjDThIRIxO5eG4TZnceuw1yUZbikQUzYOc7ZiF8v3QY=;
        b=1AzIFcjH4LiJVauv5R7Um3bxQz+SH7MlFKhuS+dklN1ZZiyAbpDqU3BpdgMyouLobs
         m1FAQfRuaqtudTXcjiDJVYMr/NLR+zb3O/ROi4dcUqnewJJqIEdI1/Igzfii3T4dVNgs
         X9/+rezHgYKFX/oJ73v0Ssuk3R4PVherlUdSi/jkr8Dwb8EdE+d0MoPQizRrjTPSkqDv
         LcmvUA2GnNC+VvzXbxxooig33TBQOI/Jn0G/3MH4D/olAo0gpgFsDZ/4YMi6Gwwpq+RY
         MFd07MmK30bgY6MNmmj5pEJoOfRppFDUU2zzmERTK+JsiRQ8DKZit/fpzaQTMS2CtHRq
         Eh9Q==
X-Gm-Message-State: AOAM531jdNiUUOtJQ7lOsgKn7Z6x6+j7jhcWk663kgOf3QYz2ThJ3PB2
        I6KjbZOJskvngrS6qrakoqwFGg==
X-Google-Smtp-Source: ABdhPJyyggb51fgdSRA7BCvi8AyGJFsfkV1+HCUn6DaeGXxOXrb4tnz/fNEfYv8aKl3RE/V7R6b2Qw==
X-Received: by 2002:a17:906:69d1:b0:6ce:7201:ec26 with SMTP id g17-20020a17090669d100b006ce7201ec26mr18532694ejs.105.1649428894176;
        Fri, 08 Apr 2022 07:41:34 -0700 (PDT)
Received: from [192.168.0.188] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id o3-20020aa7c7c3000000b00410d407da2esm10112114eds.13.2022.04.08.07.41.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 07:41:33 -0700 (PDT)
Message-ID: <3144f7f7-38d1-3d8d-e5cf-233c0515591f@linaro.org>
Date:   Fri, 8 Apr 2022 16:41:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 09/29] scsi: ufs: Declare the quirks array const
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-10-bvanassche@acm.org>
 <DM6PR04MB65757609D6D12BA09C6DEC4FFCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
 <f5213385-b57e-af9d-721c-0316dd4151cc@acm.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <f5213385-b57e-af9d-721c-0316dd4151cc@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/04/2022 23:14, Bart Van Assche wrote:
> On 4/1/22 12:56, Avri Altman wrote:
>>> Declare the quirks array and also its 'model' member const to make it explicit
>>> that these are not modified.
>>
>> Sometimes it's useful to be able to add a quirk as part of e.g. a debug session in the OEM premises.
>> And not always we are able to recompile the kernel.
>> Since we have a debugfs now, how about adding this capability, instead of blocking it?
> 
> Hmm ... does declaring data const prevent from modifying that data from 
> inside a kernel debugger? Don't kernel debuggers allow to cast away 
> constness?

We strive to make all initdata const for several safety reasons, so such
debugging/hacking session without recompiling the kernel is not a good
reason to abandon that goal.

Such data is already const (or constified in progress) in most of the
kernel places, so why UFS is special? Other subsystems are not...

Best regards,
Krzysztof
