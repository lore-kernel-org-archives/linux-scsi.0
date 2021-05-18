Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CFBC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 21:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F052161353
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 21:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbhERWA7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 18:00:59 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:42712 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbhERWA7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 18:00:59 -0400
Received: by mail-pf1-f176.google.com with SMTP id x18so4150185pfi.9
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 14:59:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TTLponXUteGuQL/U0smckJUhrm+m4vvmJIBQAfILAoA=;
        b=V3l2h5Cq4VO7V6XkSbuR4bZ3uXIKDvfDPvo6NjuxVyiJ26fvAOQp71WSYATfmBECqW
         G45vI79CmWaU8yK+qUULB3vSckyG94G76kCI7jjMiWcXOjVs1CBf7FTelY25o6KCyITy
         FsSmpnsUhpCIILbwmw82ev9PvMisrQGS8zE/NcQsloFXtuKFSpU0mZPs9DXghAskrFPZ
         y+6LxwDzRR2xR+JUMYccpPYm2vmAZHvYuAEO+VigEtCzbjh9xmYwAx4S2nKKmiTFPANL
         SbxqHsXRpsVMOFEq3pngcXAP8utZT59qXd/xIdzpX6nmn7GA7WnRXE6el5KwI302XP2U
         4z+w==
X-Gm-Message-State: AOAM532XWcrJ9SrIIpL2wyKD3kSg3hgnNf/Wghp2sjtGy9TnQdbrXogQ
        CvFeEPbL+ztjF5AlMtlkvwY=
X-Google-Smtp-Source: ABdhPJz/dzekeVsjFFmnmOp8IkMTV3WY28WqDi+OdGJINdgYgsfPuXJGWt6gx5gGoSuODvbHNXrtiQ==
X-Received: by 2002:a62:1d0e:0:b029:2d8:30a3:687f with SMTP id d14-20020a621d0e0000b02902d830a3687fmr7227595pfd.17.1621375180746;
        Tue, 18 May 2021 14:59:40 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:4ae4:fc49:eafe:4150? ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id y24sm1969337pfn.81.2021.05.18.14.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 14:59:40 -0700 (PDT)
Subject: Re: [PATCH v2 02/50] core: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     dgilbert@interlog.com,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210518174450.20664-1-bvanassche@acm.org>
 <20210518174450.20664-3-bvanassche@acm.org>
 <088b4699-6e96-adcc-34e5-7926279df923@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <3dd52887-edb9-d9b8-00b2-8fc4e6ca4830@acm.org>
Date:   Tue, 18 May 2021 14:59:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <088b4699-6e96-adcc-34e5-7926279df923@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/18/21 1:01 PM, Douglas Gilbert wrote:
> On 2021-05-18 1:44 p.m., Bart Van Assche wrote:
>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>> index ac6ab16abee7..09797a2b779d 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -265,13 +265,15 @@ sdev_prefix_printk(const char *, const struct
>> scsi_device *, const char *,
>>   __printf(3, 4) void
>>   scmd_printk(const char *, const struct scsi_cmnd *, const char *, ...);
>>   -#define scmd_dbg(scmd, fmt, a...)                       \
>> -    do {                                   \
>> -        if ((scmd)->request->rq_disk)                   \
>> -            sdev_dbg((scmd)->device, "[%s] " fmt,           \
>> -                 (scmd)->request->rq_disk->disk_name, ##a);\
>> -        else                               \
>> -            sdev_dbg((scmd)->device, fmt, ##a);           \
>> +#define scmd_dbg(scmd, fmt, a...)                \
>> +    do {                            \
>> +        struct request *rq = scsi_cmd_to_rq((scmd));    \
> 
> When introducing a new name (e.g. rq) in a macro, shouldn't it be prefixed
> with either a single or double underscore? There is a good chance rq maybe
> in use in the enclosing scope causing a compiler warning.

Hi Doug,

Thanks for having taken a look. I will insert one or more underscores in
front of the 'rq' variable name or remove that variable again. It is not
clear to me whether there is a general rule. In include/linux/kernel.h I
found a variable that has a prefix of seven underscores:

#define trace_printk(fmt, ...)                          \
do {                                                    \
        char _______STR[] = __stringify((__VA_ARGS__)); \
        if (sizeof(_______STR) > 3)                     \
                do_trace_printk(fmt, ##__VA_ARGS__);    \
        else                                            \
                trace_puts(fmt);                        \
} while (0)

Bart.
