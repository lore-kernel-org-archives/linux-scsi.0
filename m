Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C0FC76196
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 19:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbjDCT4i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Apr 2023 15:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbjDCT4h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2023 15:56:37 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D052105
        for <linux-scsi@vger.kernel.org>; Mon,  3 Apr 2023 12:56:36 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so33790866pjt.2
        for <linux-scsi@vger.kernel.org>; Mon, 03 Apr 2023 12:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680551796;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U0BucDsz4QwnNvJ9wAZhsOYrXi0oInghPHJCceEJBiU=;
        b=MBLUI8PWwK8Y/H28PY3Lr1II0SiF5BMtwrjVrzRtXNKGrkMUWzdTdxbNb+C2nw9Kyg
         4vT/ymFq8zzDXRcX19aiKJzZoRpXDbBzgdwTFAnP0Awyrk3MjBouWDoIjNrjFwX9LxwB
         8cEL5SWYn9RoG5lCVIU0uAlSAFyjX1EG0Mc4QZzWPAFXfwtFjztVsS67+NJYT4NDyE4+
         isotia6m4zY2RTW4L/0ovscEqrVSCPP1MYz0udA65h/INAa4Hycxm9Z2ftD91S0fbreK
         rZD1spzaUGWac1T2LyyX7CLeoazFih2FGhxXpAgC6dDjcOly5RVHQ5nB8zwDFUUZGgVE
         bm/g==
X-Gm-Message-State: AAQBX9dcivnxJ2I7dcu/dfhH6FhixVsu7Pl72UVJunw6n4pjE0en+/KW
        QZm/OYcL1mFijXluwHgXU1HMEJdg5jI=
X-Google-Smtp-Source: AKy350aIaRXEzY1r/sSfF6px/LQ3Lgqv/z1gdvHNp68TZ045W3Tr+ufduR0kIbNRjqdFYkOtaWrZQg==
X-Received: by 2002:a17:90b:1d8e:b0:23f:37b6:48f4 with SMTP id pf14-20020a17090b1d8e00b0023f37b648f4mr41166547pjb.43.1680551796059;
        Mon, 03 Apr 2023 12:56:36 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:270b:3345:6931:bb28? ([2620:15c:211:201:270b:3345:6931:bb28])
        by smtp.gmail.com with ESMTPSA id x3-20020a17090a8a8300b00234465cd2a7sm6455381pjn.56.2023.04.03.12.56.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 12:56:35 -0700 (PDT)
Message-ID: <eb5335bc-760d-4591-8a73-71f10dcd8155@acm.org>
Date:   Mon, 3 Apr 2023 12:56:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] scsi: sd: mark the scsi device in shutdown as deleted
Content-Language: en-US
To:     Tomas Henzl <thenzl@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20230330164943.11607-1-thenzl@redhat.com>
 <af17886b-5b18-f71f-9fe7-ea929f30b5a6@oracle.com>
 <e4dd3ea37807166820e3b3b7e5102e23ab6b3898.camel@HansenPartnership.com>
 <457808a0-1ec2-d846-075c-7f8812a7a416@redhat.com>
 <488bb066654104bc6b84fdc45595232305519597.camel@HansenPartnership.com>
 <33501374-2cc7-ba1c-9d42-0da2aeed4341@redhat.com>
 <0afc900c-2717-6751-de54-9f65bf127484@acm.org>
 <3b5cf6e6-9dec-880f-7807-6d0461cbf514@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3b5cf6e6-9dec-880f-7807-6d0461cbf514@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/2/23 14:49, Tomas Henzl wrote:
> On 3/31/23 20:48, Bart Van Assche wrote:
>> I'm interested in failing future I/O from inside sd_shutdown() because
>> it would allow me to remove the I/O quiescing code from the UFS driver
>> shutdown callback.
> I'm aware of this, other drivers do have similar code and so it would
> help elsewhere as well. The patch as it is doesn't however ensure that
> there isn't for example an I/O started before sd.shutdown which may
> arrive in a driver after his shutdown has been called. Because of that I
> haven't used this as an argument in the discussion here.

Has it been considered to call blk_mq_freeze_queue() and 
blk_mq_unfreeze_queue() to wait for I/O that started earlier?

Has it been considered to set QUEUE_FLAG_DYING to make future SCSI 
commands fail? See also blk_mq_destroy_queue().

Thanks,

Bart.

