Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CEEDC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 20:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiI2U3u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 16:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiI2U3s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 16:29:48 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3939220F79
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 13:29:47 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id i6so2448200pfb.2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 13:29:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=35ySAnnwzlDvS9vcQ7ALMkeWOPy+N4NHz7FvCZdNarc=;
        b=022sDkPO3xTLXC/VeXS3HBYlS4dUG12Yn+MouTW/TzgFCgy1yJ5GOE8fJJxeQVh2Af
         Z9HU5w3L9k3KFu0qMcbR5xQd5hDmY6hVSN1mCIVpyzYlYO040JXyLGwZGt6ZCqZLFVkj
         Z52MlK0o3mMRqVXtuA3Nhx0kMaT8TqxpkptgEIm8Pzp9fHtL0yjBng1H82IwSk3HiSIx
         CCJLLRfPOpCTsQAdei1S5Q82DxgqhuoxAn8yJU0EuOOaXfCG1XJ1g27MozoGIgSQkY51
         bNDjr149SgZG2YbHs7mPSLXjQUcn0J2uQ9OTE0ZzrrdQNI/9Uu6KXr6qSSK70Wp8Mog8
         f9lA==
X-Gm-Message-State: ACrzQf0ZeL91qdXCtHRghGn6tw9xvtp2iGmGy/XL5bect95zvcRsyl7p
        VvLJmyrNseeY4bmqDnm97w0=
X-Google-Smtp-Source: AMsMyM68rIpTQLk1cLpilM0y1Q+Y3ixdTj6ieJsFFJFb/GyA23Vl4C+q81yUPDpYB9UvNWb/p4cAew==
X-Received: by 2002:a63:1f5f:0:b0:440:5310:4b0e with SMTP id q31-20020a631f5f000000b0044053104b0emr3263660pgm.293.1664483386453;
        Thu, 29 Sep 2022 13:29:46 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:56f2:482f:20c2:1d35? ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id b2-20020a621b02000000b00536aa488062sm79992pfb.163.2022.09.29.13.29.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 13:29:45 -0700 (PDT)
Message-ID: <73e01bcb-71db-005a-c872-f64bd68278bd@acm.org>
Date:   Thu, 29 Sep 2022 13:29:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 03/35] scsi: Add struct for args to execution functions
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220929025407.119804-1-michael.christie@oracle.com>
 <20220929025407.119804-4-michael.christie@oracle.com>
 <d77c03f3-9908-1d3d-0526-57cdfb5d5ce7@acm.org>
 <167f3346-7823-eda4-fcc1-61727f98acee@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <167f3346-7823-eda4-fcc1-61727f98acee@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/22 13:24, Mike Christie wrote:
> You mean like:
> 
> #define scsi_exec_req(_args)                                            \
> ({                                                                      \
>          BUILD_BUG_ON((_args).sense &&                                   \
>                       (_args).sense_len != SCSI_SENSE_BUFFERSIZE);       \
>          __scsi_exec_req(&(_args));                                      \
> })
> 
> right? That didn't help. You still get the error:
> 
> error: macro "scsi_exec_req" passed 8 arguments, but takes just 1

Interesting. That may be a compiler bug but means that we need to keep the
parentheses ...

I would appreciate it if the parentheses could be inserted in the
scsi_exec_req() definition as shown above since this is the recommended kernel
coding style.

Thanks,

Bart.


