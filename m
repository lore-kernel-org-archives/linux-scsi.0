Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C256DC77B6C
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Mar 2023 18:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbjCaSsN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Mar 2023 14:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbjCaSsM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2023 14:48:12 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5631EFD6
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 11:48:11 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso9257855pjf.0
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 11:48:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680288491;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dYENOeIa1+gTH+pykQxA10q3p2sV4bavyyOLRM2MKqU=;
        b=77iHHgn934pYLvEedXg6+n0/64lfLHOLllQ1FKUmE2xUeXZlENLZustL1MpZhnra+f
         S0w6UYqF2cQDySNy9Q1nTfeBX+WHVtoUMh7UsFwJrxuvlMKpuDUzQl4MKDVznYhkxPf8
         g+ysr2FhoXt1VoaA6yOmHZnIPljy4VMtvS0c8IKMyMEe5MOzUbQwfMnuqMbK235ufJtv
         v55gK7T44jZC4Kyq8R9k3qMq1REPfbPcJVgAlTL8RMtY4p1x1eh/YXQG/9esqxLfwk45
         m/FJqddtJZL6QEY3Db2c+NT0fYcc3nf7tFXYDUmeQdbQFriGq3SJB2a30IHOxnaBHLKR
         C/BA==
X-Gm-Message-State: AAQBX9f+UWe5F3TujP6OeO85Cx+JWCrobwWccGShKqavUlqG6yC/7ujW
        nmno92KVxq1ysDW6NxwGaMc=
X-Google-Smtp-Source: AKy350Zdb8bJgC8v7yugEV/i8K4tPG7TfPF0rtH9k1tO9/Gw7hpzr6w0vdN5L2NOuF/xXk3px7tmZw==
X-Received: by 2002:a17:90b:388e:b0:23f:7d05:8762 with SMTP id mu14-20020a17090b388e00b0023f7d058762mr30342435pjb.23.1680288490700;
        Fri, 31 Mar 2023 11:48:10 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:8ee9:5b72:a038:11e1? ([2620:15c:211:201:8ee9:5b72:a038:11e1])
        by smtp.gmail.com with ESMTPSA id t6-20020a170902bc4600b001a19f3a661esm1877171plz.138.2023.03.31.11.48.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 11:48:10 -0700 (PDT)
Message-ID: <0afc900c-2717-6751-de54-9f65bf127484@acm.org>
Date:   Fri, 31 Mar 2023 11:48:08 -0700
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
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <33501374-2cc7-ba1c-9d42-0da2aeed4341@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/23 11:32, Tomas Henzl wrote:
> The patch doesn't fix a real bug so it isn't urgent nor important,
> seeing the congestion it creates please just drop it.

Hi Tomas,

I'm interested in failing future I/O from inside sd_shutdown() because 
it would allow me to remove the I/O quiescing code from the UFS driver 
shutdown callback.

Thanks,

Bart.
