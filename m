Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E60C25B50
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 09:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbjAWJzD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 04:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbjAWJzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 04:55:02 -0500
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7F91350C;
        Mon, 23 Jan 2023 01:55:01 -0800 (PST)
Received: by mail-wm1-f43.google.com with SMTP id o17-20020a05600c511100b003db021ef437so8078194wms.4;
        Mon, 23 Jan 2023 01:55:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xoZh4wbyAqj1PKjLuBn+ARXWiME+hVfFOSg4PftRAO8=;
        b=FC4bTcsqc4S0BN5ttyPVXKrCnSdjjplHOZ9uFS83rqAQ3gK4PpVJ4WpF5GHbgVCNdW
         OlUnh1w/9K6maAGoQfQO7vrEa35M7mQqkAgKpLPXoM4KDGmqCe6T/xOTUtBrm4CcKHSw
         W/ArwyZmM+08qItSaWI/ON5ERppFLsXgcgLTPl6DOT6Mm5ko9+0CLYLPsFxIZkE4q+36
         qBCit7OROXmOC1rddF8mV+L6xWVEaXR2Xk/MUFCtqMUEFE7qEW69I4P7R8mt9qyVaMPy
         EgsYTMQ2/QWQ9cvG5bQ3uth9uGP39AZRe2tDOAK5/vlauR495DyPqMZjlMM7hZ4vvZ+c
         EnnQ==
X-Gm-Message-State: AFqh2kpqIrgvjv5MtFtbqrtCSaAfXyAMQfHUsdGLU0LIzM6bCHw/N9df
        lrLI+678hiKkY1H65mAJnXU=
X-Google-Smtp-Source: AMrXdXs/gNSw7BTq3Z5gAvnr5VE6l/EVCkRaiT/mV23xsZRS9yC5nOt/y4SdTe5jXIVyQ7OlhXxH2g==
X-Received: by 2002:a05:600c:1c2a:b0:3cf:d0b1:8aa1 with SMTP id j42-20020a05600c1c2a00b003cfd0b18aa1mr22821921wms.0.1674467700230;
        Mon, 23 Jan 2023 01:55:00 -0800 (PST)
Received: from [192.168.64.80] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id bg24-20020a05600c3c9800b003d9ed40a512sm14077677wmb.45.2023.01.23.01.54.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 01:54:59 -0800 (PST)
Message-ID: <50b0840b-6cd6-9796-407d-6d6f6bcb4bdf@grimberg.me>
Date:   Mon, 23 Jan 2023 11:54:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 00/13] target task management fixes
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mlombard@redhat.com,
        martin.petersen@oracle.com, mgurtovoy@nvidia.com,
        d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230112030832.110143-1-michael.christie@oracle.com>
 <c1a395a3-74e2-c77f-c8e6-1cade30dfac6@oracle.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <c1a395a3-74e2-c77f-c8e6-1cade30dfac6@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 1/12/23 05:13, Mike Christie wrote:
> On 1/11/23 9:08 PM, Mike Christie wrote:
>> The following patches apply over Martin's 6.2 and 6.3 branches or
>> Linus's tree. They fix a couple regressions in iscsit that occur when
>> there are multiple sessions accessing the same se_device and TMRs are
>> executing and a connection is closed. And they fix some bugs in isert
>> for the single session case when there are TMRs executing and the
>> connection is closed.
>>
> 
> Oh yeah Sagi and Max,
> 
> I didn't post the write_data_done fix. Let me know how you want it
> fixed and I can post it.

I think just fixing the write_data_done to add the data read via
the rdma operation.
