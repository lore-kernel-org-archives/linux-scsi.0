Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D26EB64DD
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 23:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjHAXX2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 19:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjHAXX1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 19:23:27 -0400
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574EFB4
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 16:23:26 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-563f752774fso3632199a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2023 16:23:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690932206; x=1691537006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D88o907lNN2lO8wyEg1oXR0GwGcoGl4Tzq1oVFdFa+o=;
        b=cA1rhEsUk2s+dXWuTIxDzcy2+pE+qGB7vM7p3rnp1BHJDXa1ni3dB8Jp1qpSEr7X0V
         ynyjvZ7apf0aeOoOMAqL+TLt+b0wYfg7E4V4iYTdgec+b4bP2xmVj+Gd3ZQAt0cLltcZ
         npAYP9uvjpb658q/Bo9MKXgl8QPkUt3RKNbAgVyErb3JMaw0/yfZVMlFIOZ1qDIiwRYz
         66pUfkNJv53WksgUnUex/gWvbAosRiU5ci6w4x1coRfOBvToreywZDVAnGtkbL92R7Hy
         qvqwwi9ZlHSSQANAJgWd3+BdnUokNf4kdestfLTpPQdKpiqkcBvKtOXJNWy/B4YlbCu6
         Ripw==
X-Gm-Message-State: ABy/qLYghbkHXOfWUypJF4h+oUubNZPH81ZBivuK1wCKPu6lvjZMmPgv
        T8EWsqMnR5J7fxriqagiVjo=
X-Google-Smtp-Source: APBJJlHaRLFkt7gDfX7uryX/ds/6acyxNbGLePDypJ8k6akLl61wLJ0WvJEaL/1JNtvsaobKFHfRCA==
X-Received: by 2002:a05:6a20:a104:b0:118:e70:6f7d with SMTP id q4-20020a056a20a10400b001180e706f7dmr14628412pzk.10.1690932205565;
        Tue, 01 Aug 2023 16:23:25 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id iw14-20020a170903044e00b001bb54abfc07sm10923944plb.252.2023.08.01.16.23.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 16:23:24 -0700 (PDT)
Message-ID: <8f7404dd-dab7-e599-31ff-3204b6a11943@acm.org>
Date:   Tue, 1 Aug 2023 16:23:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] scsi: ufs: Fix the build for gcc 9 and before
Content-Language: en-US
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Can Guo <quic_cang@quicinc.com>, llvm@lists.linux.dev
References: <20230801201337.1007617-1-bvanassche@acm.org>
 <20230801215240.GA534984@dev-arch.thelio-3990X>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230801215240.GA534984@dev-arch.thelio-3990X>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 14:52, Nathan Chancellor wrote:
> On Tue, Aug 01, 2023 at 01:13:23PM -0700, Bart Van Assche wrote:
>>   static void ufshcd_check_header_layout(void)
>>   {
>> +#if defined(__GNUC__) && __GNUC__ -0 < 10
> 
> clang defines __GNUC__ and it does not sound like it is impacted by this
> issue? I just built with LLVM 11 through 17 and did not see it. Can this
> be made more specific?
> 
> Also, can we use IS_ENABLED() and not rely on the preprocessor? This
> appears to work for me.
> 
>      if (IS_ENABLED(CONFIG_CC_IS_GCC) && CONFIG_GCC_VERSION < 100000)
>          return;

Thanks for the feedback. A new version of this patch has been posted.

Bart.

