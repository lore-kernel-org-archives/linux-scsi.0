Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66ACC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Oct 2022 20:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiJNUpv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Oct 2022 16:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiJNUpt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2022 16:45:49 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC09D03AB;
        Fri, 14 Oct 2022 13:45:46 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id y1so5964540pfr.3;
        Fri, 14 Oct 2022 13:45:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V6F4cqScoAnyG62i61m4oJ0MGIQvNAp6Biva4swYu9g=;
        b=CPR1GPSR9p8XPYplL4jnpZDVA8mVxl/7kICuPJ/Z5OC6ZVbDvEMGd9xs/YuWwFptwu
         7SIT4YEuWo5Ev4UQYhXcag2E2jThUwZKhU+MouhdFsMFGM+UATnTXTxRp/wCkv4jY0uD
         zGCjQu/qid5KfRdVN4BRefUsoLsosP+k3bpyIj56s481GMGQctYSlw3zGN9XScAUu4Al
         bv+wzxPF6ywWk06xOrkDs6Z4I0uR5e8zMELDWAyyE/+PFTeC85UzK4uBjVzKCALv4qj6
         a8N4Tzb0JdpNH4wYNtKcgLNbGhF6sItGMkxWX/830nDEbmo6htJBe/X5ZU9QTvQ4X+yS
         7DiA==
X-Gm-Message-State: ACrzQf2wUD/QG79wsst+Dp6/caD4XWYv4EL6OvT4nmrkLTDfgSJe1xAJ
        5FjP7/MsEYDWJe1UtQ9++kg=
X-Google-Smtp-Source: AMsMyM5MKBbUdqmwvx5/5F4v7bmbYZsgm3kn8yLzjJML5o9xvFokP77MQT0uLCsCIJAB97rQdw2YQQ==
X-Received: by 2002:a63:1353:0:b0:457:3e87:7883 with SMTP id 19-20020a631353000000b004573e877883mr6039567pgt.172.1665780345440;
        Fri, 14 Oct 2022 13:45:45 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:7bd3:5500:b9cd:d90d? ([2620:15c:211:201:7bd3:5500:b9cd:d90d])
        by smtp.gmail.com with ESMTPSA id c12-20020a170902d48c00b0017a032d7ae4sm2147835plg.104.2022.10.14.13.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Oct 2022 13:45:44 -0700 (PDT)
Message-ID: <16bee8e7-a9ec-0847-9d89-92484b0399a0@acm.org>
Date:   Fri, 14 Oct 2022 13:45:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: Remove unnecessary if statement
Content-Language: en-US
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org,
        daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221010092937.520013-1-beanhuo@iokpp.de>
 <20221010092937.520013-2-beanhuo@iokpp.de>
 <a1cd6719-a743-fc96-e0e7-364a52b62952@acm.org>
 <227f117ee9491cc9d2ae4bb2211a99ccd1dd3c21.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <227f117ee9491cc9d2ae4bb2211a99ccd1dd3c21.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/14/22 13:30, Bean Huo wrote:
> I double-checked the changelog and the stack overflow issue was double
> fixed by your commit:
> 
> commit d3d9c4570285 ("scsi: ufs: Fix memory corruption by
> ufshcd_read_desc_param()"),
> 
> For example, if the user wants to read wb_buf_alloc_units in the RPMB
> unit descriptor,
> 
> parameter offset = 41, parameter size = 4,
> buff_len = 45;
> 
> After ufshcd_query_descriptor_retry(), buff_len will be updated to 35.
> 
> param_offset > buff_len, then -EINVAL will be returned.
> 
> So we can safely remove this check, and if you still have concerns, I
> can verify when I get back to the office.

Hi Bean,

Thank you for having looked this up. I agree with the above.

Bart.
