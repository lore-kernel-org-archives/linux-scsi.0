Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C186FC43334
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 05:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbiFCFPD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 01:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbiFCFO5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 01:14:57 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188E01DA7A
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 22:14:57 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id o6so1031944plg.2
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jun 2022 22:14:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hoUPzzig0R6NiWGQTQAqogz5hc7rd8EyuLc04Iz3ogs=;
        b=Rt1wKJSO6FOBOJM7KNMKxIoQ9K3Vx9GRvzIK0i0x4/ClH86xqO800RtLRfjua74LGN
         nQaHKZT8F32PUupz0OUkhOoZb/+cxHF1i37qVLlXQaH2vYRH6LuLANQHv0eg5H/jKBCy
         tqu0/SHiHzB4IP7G1m4DeIszYObZfBiuP89D9vPjJkld0aayZ9BCxQoalJ1TCOw0v9Zf
         QVijQ5qIcPaxwBTflty3rLCV2yWAMKmq4+x1BZBXWhPvdk96jETz4AuA2Nvqk62M8JDB
         UPShawdIaOrFjYT5dzXNavAW8vFCho/Od+Pcyxi/3JGlvJlvlUb0BCFgo6b3gI/q7TNS
         5d4w==
X-Gm-Message-State: AOAM532WKK3ovuRFT5Gi6uOmJVQpXuX32ODI2veFLtpl1KwV/PqW4pyk
        tALiTqCGHjrlH9LzUEy05aY=
X-Google-Smtp-Source: ABdhPJy6gbCvQR+JeWSJAx76vSOR5ki3q1h4k8UpGd5m9QNf5zHTgkhJdwzCKLdntmGXahirPo3diQ==
X-Received: by 2002:a17:90b:1d06:b0:1e6:7a84:3c6e with SMTP id on6-20020a17090b1d0600b001e67a843c6emr9302202pjb.202.1654233296439;
        Thu, 02 Jun 2022 22:14:56 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id 205-20020a6216d6000000b0050dc76281f0sm4395602pfw.202.2022.06.02.22.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jun 2022 22:14:55 -0700 (PDT)
Message-ID: <993827cb-47be-6579-83b2-ad3bf4c52500@acm.org>
Date:   Thu, 2 Jun 2022 22:14:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] scsi: ufs: Split struct ufs_hba
Content-Language: en-US
To:     keosung.park@samsung.com,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        cpgsproxy2 <cpgsproxy2@samsung.com>,
        cpgsproxy3 <cpgsproxy3@samsung.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Eric Biggers <ebiggers@google.com>
References: <CGME20220531035501epcas2p33ef286ea964e39f45a0696edf2d8ae32@epcms2p3>
 <1891546521.01654139701937.JavaMail.epsvc@epcpadp3>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1891546521.01654139701937.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/1/22 20:13, Keoseong Park wrote:
>> diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
>> index e3baed6c70bd..12ff7bdf84aa 100644
>> --- a/drivers/ufs/core/ufs-debugfs.c
>> +++ b/drivers/ufs/core/ufs-debugfs.c
>> @@ -34,7 +34,8 @@ void ufs_debugfs_exit(void)
>> static int ufs_debugfs_stats_show(struct seq_file *s, void *data)
>> {
>>          struct ufs_hba *hba = hba_from_file(s->file);
>> -        struct ufs_event_hist *e = hba->ufs_stats.event;
>> +        struct ufs_hba_priv *priv = container_of(hba, typeof(*priv), hba);
> 
> How about functionalizing container_of in ufshcd-priv.h like below?
> 
> static inline struct ufs_hba_priv *hba_to_hba_priv(struct ufs_hba *hba)
> {
>          return container_of(hba, struct ufs_hba_priv, hba);
> }
> 
> I think it will be easy to understand.

Hi Keoseong,

That's an interesting suggestion. I will look into this.

Thanks,

Bart.
