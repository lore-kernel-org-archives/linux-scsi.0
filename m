Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEFBC001B0
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 15:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbjHJPEY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 11:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbjHJPEY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 11:04:24 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207B72686
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 08:04:23 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-686b9920362so740293b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 08:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691679862; x=1692284662;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wi0QeqkTxyfwO3yE8dM2dEfhNbz9+I8YMxeKmTfYnLU=;
        b=RJtFIojfgMo3ZCIfiSOYiIXoE5LgfTKiJdQw9ugo0LDYTETNLLFF5KQeuKI8zZbtV2
         xCimn+LCa1wC3OPzb2c7VsRyeLu3MQFx84cLqudfBaEKFBP2h2vb/q/oh494/PABmitx
         uGBy+qEmGuTZg9boNjRZVhUpNzhP7Dwrbo37Xb5uxw0+FLUq7kJln1jHnGiVNaJf+Y9A
         8gSPiAKOL2fNfEkfCel79V3AI5xcojdJ3b+mVQ6djmXSVsOlcelhKJdE3NoTdwVKHWw4
         8nZtko4CpaoLbryOOsPW72OW9UZGntlCcrAvtR4zQGwAdL7uvY/UrfbXgzU2p6qWH/rv
         i5yA==
X-Gm-Message-State: AOJu0YxGS822kOT9wWA1jnY3H2sH2tw97ZPyVIkNdgfpGHaHcox0Pdmy
        2tu/pV8AehhCL5ez/2F99zI=
X-Google-Smtp-Source: AGHT+IFxxP8S4PsCspJNPVTmv+aFos2002eIl5MJdcYd/Hr44LwOdwWr61tptGhHF3ZJrOUUn2SX6g==
X-Received: by 2002:a05:6a00:2284:b0:686:5e0d:bd4f with SMTP id f4-20020a056a00228400b006865e0dbd4fmr2841075pfe.0.1691679862228;
        Thu, 10 Aug 2023 08:04:22 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id 24-20020aa79218000000b006827c26f148sm1611958pfo.195.2023.08.10.08.04.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 08:04:21 -0700 (PDT)
Message-ID: <5b991ddb-5e32-0870-a196-c3139aec86a4@acm.org>
Date:   Thu, 10 Aug 2023 08:04:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [bug report] scsi: core: Fix possible memory leak if device_add()
 fails
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@linaro.org>,
        wangzhu <wangzhu9@huawei.com>
Cc:     linux-scsi@vger.kernel.org
References: <5121c883-ef71-41d9-8153-472cf319a7b8@moroto.mountain>
 <470fb552-7356-4a62-a4bd-545b4f94e040@huawei.com>
 <26b9c8c4-70b8-4517-91b8-9eafa2b81aca@kadam.mountain>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <26b9c8c4-70b8-4517-91b8-9eafa2b81aca@kadam.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/10/23 05:26, Dan Carpenter wrote:
> On Thu, Aug 10, 2023 at 08:05:21PM +0800, wangzhu wrote:
>> Hello Dan Carpenter:
>>
>>
>> Sorry for the patch 04b5b5cb0136 I submitted, I thought put_dev(&rc->dev) is
>> not the same as kfree(rc).
>>
>> Then should I submit a revert patch again, or you can fix it yourself?
>> please let me know what I can do.
> 
> The original code was buggy and the new code is slightly buggier.
> 
> Instead of reverting, lets see if anyone knows the correct way to fix
> this.  If no one comments within a week then I agree that reverting is
> better than a double free.

The standard solution is to have two error paths: one error path that
cleans up the actions performed before device_add() and a second error
path with a put_device() call in case device_add() fails. See e.g.
sd_probe().

Bart.

