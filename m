Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1330C54EE9
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 15:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbiIHPEr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 11:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbiIHPEn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 11:04:43 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F211C921
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 08:04:39 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id i26so12462100lfp.11
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2022 08:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=zNFutFccZT6f6iuYGNI8lXkDka4OOINY+aGWpjk7wGk=;
        b=iVZ/SYDZx1v252YZLFQsnEGK+gB2G9E/S8LCryr60OUZ2ORINLyw0Rk3fCnT9TWeNv
         qu/UlLr7euqcgpTvHBp7VsLkdzFU4Ilvr/4P4wmDV8Cz1Oul4q4Zxndyi6AGXHHJxDR8
         LlB9rMeh/YB4hYf2iNVYNqfPE138ZGjwsqTxTdnuqlNHsLtINsIYNLvkM9HDQ7D3xav1
         IhVyrJtHmdoW0pHt3movFeNu2GHJyJLrP7sP+BHWWDFtlBYM9fw6+wLwsamvxrllcLUW
         fQ5oS2loXNvB3wH4HDU0wXaIn/l4oibJFqdl6FDXnAMmcSQydFDwajMK/cLIskWiuGpY
         rKkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=zNFutFccZT6f6iuYGNI8lXkDka4OOINY+aGWpjk7wGk=;
        b=a0FbtPyCdkLDyyCv93Ci5JWd54WCPp59CgGDRqRLsYNKrrdZTtBSXrclCiW1kCE5Xu
         nEWJx5+DfaCHxl4nKg++SytTNe/wRwvVmNsI/dwQrwM8CVpKXQEowt3edmHqI+Ahj4yO
         uWyQu8uuFUNbE6rvJ7yJRRHmLXqMdbEFibRqC9KW5uiP6w/g4/M8nE/l/h6CxIR+Np1r
         CqBSmJSLKCJ2vBA0E6+NzulRmgXgrW6d03MHZ7lgxIqGwroI611/aZBIeF+VY27Y7WII
         aWFInCfPRLr8OrQAMj0ER3vi+c5L4933KzLYsoqQ3pGVQQbUZwpZkj3+tMUVug2mNKsy
         6LOQ==
X-Gm-Message-State: ACgBeo3latiIFTFHsT1lacyPwU7+8zgnmyh2ulox5TzNu8+kdCulQDWz
        aa+leQDlCS9VX2NqFCVxNg3HKEII5+0Dtg==
X-Google-Smtp-Source: AA6agR4OcuIE7HLJ1utkPyvJLKZ305HRhk00gp/ZvZBnKlBS/jhFempGJHli2uO1lQlobv9kFoqPmg==
X-Received: by 2002:a05:6512:1316:b0:48d:2549:1158 with SMTP id x22-20020a056512131600b0048d25491158mr2686132lfu.626.1662649477395;
        Thu, 08 Sep 2022 08:04:37 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id g1-20020a0565123b8100b00494767f1a4fsm3070507lfv.21.2022.09.08.08.04.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 08:04:36 -0700 (PDT)
Message-ID: <e22609d9-f5bc-4e03-b6d6-1393e8df6214@linaro.org>
Date:   Thu, 8 Sep 2022 17:04:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 0/2] Prepare for constifying SCSI host templates
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-scsi@vger.kernel.org
References: <20220830210509.1919493-1-bvanassche@acm.org>
 <9e9a24a0-3d04-306f-b8f6-dfe5fe03efab@huawei.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <9e9a24a0-3d04-306f-b8f6-dfe5fe03efab@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/09/2022 16:23, John Garry wrote:
> On 30/08/2022 22:05, Bart Van Assche wrote:
> 
> + Krzysztof
> 
> This is the same topic as what Krzysztof was working on in 
> https://lore.kernel.org/linux-scsi/6f28acde-2177-0bc7-b06d-c704153489c0@linaro.org/
> 
> And at least we have the scsi_host_template.module issue to solve - any 
> plan or progress for that?

I won't have time to work on that anytime soon, so feel free to pickup
my patchset and rework or continue on your own.

Best regards,
Krzysztof
