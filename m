Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE0C7C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 723B36008E
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbhDVQMp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 12:12:45 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:33736 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236485AbhDVQMp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 12:12:45 -0400
Received: by mail-pg1-f173.google.com with SMTP id t22so1713593pgu.0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Apr 2021 09:12:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NohxHKB5lHqk76gOAgjW2wFojiixu6xpRrMGFUnsLdQ=;
        b=X/fGeO3ko2Hv694aMdhezFkItrvUmoOMY1RcKpoXo0+zJVhyxg1MGlukjdgw5AgKJx
         tuYCD8keERvDCGl/vxD/9Q2Oyf2/wziGwUTGrMQOfK8MZnkT7bN44PZxoijSWYkHBMvH
         tvuUQ5kiPTeBuUBcPAFLcVHHNvGL7P6Jy+5TXAGrsQncteS26cuian2fkua9G1U0xHdY
         Abce278ukSGzKicn73M/5eQ9PYvukHwbiX0dadZ+5gOH/qMRGI3f53M/U4xMVKLiMkz+
         YFAxVk2oozYCw6322jyr7YohenI8Q/z+xJcACSG0NDsYEjCxpMtlkSMJFCXwtlGXqVLD
         bKdQ==
X-Gm-Message-State: AOAM531C/V8IOL7598ktfpeI40/3cwPqiMI8eLQEEHzXcFHJfuJYhciP
        eGlOFqUxjrTp00FDWlevyApYIodUPgo=
X-Google-Smtp-Source: ABdhPJyyn1ZN/fOV5FU9llGeNYA6j7JX8+x329msMBsRPgF9fjZUWWnJ5Dl3zGCHMnxxfiiL05OAtw==
X-Received: by 2002:a63:ec4e:: with SMTP id r14mr4429250pgj.153.1619107929838;
        Thu, 22 Apr 2021 09:12:09 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:ca3e:c761:2ef0:61cd? ([2601:647:4000:d7:ca3e:c761:2ef0:61cd])
        by smtp.gmail.com with ESMTPSA id w4sm2655452pjk.55.2021.04.22.09.12.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 09:12:09 -0700 (PDT)
Subject: Re: [PATCH 18/42] dc395: use standard macros to set SCSI result
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-19-hare@suse.de>
 <d92fd9b0-c10d-a3a3-99ba-e4d34e0888a0@acm.org>
 <c99025f2-eb24-87ca-61be-97ca11f8945d@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9714f812-3a33-54ad-a3b6-06154ce24d68@acm.org>
Date:   Thu, 22 Apr 2021 09:12:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <c99025f2-eb24-87ca-61be-97ca11f8945d@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/22/21 1:52 AM, Hannes Reinecke wrote:
> On 4/22/21 12:26 AM, Bart Van Assche wrote:
>> On 4/21/21 10:47 AM, Hannes Reinecke wrote:
>>> Use standard macros to set the SCSI result and drop the internal ones.
>>
>> This patch looks almost identical to a patch from my patch series?
>
> That might well be; please do note that this patch is from the previous
> version and is dated January 2021, with a previous version dating back
> to mid-2019. I just didn't check your patchset for duplicates, sorry.
> 
> Hence the 'RFC' bit :-)
> 
> But if you insist I can fold your patch into this series and drop mine.

Since your patch is probably older than mine, feel free to keep your patch.

Thanks,

Bart.

