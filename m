Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FB0C0650F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 08:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 292AD2084D
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 08:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aBPUev9Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfHNIDP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 04:03:15 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50431 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbfHNIDO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 04:03:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id v15so3725695wml.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 01:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u1kTruUi3YdB800wT1pXkaOjMSivOUWKVyyY/Zt731g=;
        b=aBPUev9Ze7ZpXmccQd1KFcRQ9+YZEvEIJ2mXE7D/eE4mW0NWELCy32Z9swdThfnFBF
         uwtFZsx0n+nZPSfcdbUAoi2maYUPyAGE6VZvX1lxXucBNdBbPTrKrpL+APlXG6nq0usR
         7T3hKQZ8OfkYXRqYiqYd86anCcfqziM9dMWWG97DVfu1X0mjwovdY+J6TV25XUuh6Vhq
         Xi3Ng7NKhUr4M0lpXoNBdpFRyjhTf0YlPodDH3z4Nge4kVC3ptXr9zrGX9HD6K0+NbYi
         EuCHR8LyYsg3WfxgBZyJ7LK6acjuYTK/s2Uy/3kWehj3pEeX80Z6NVS08CjMjM7+MPUt
         6B4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=u1kTruUi3YdB800wT1pXkaOjMSivOUWKVyyY/Zt731g=;
        b=IvmpiV+VoPNzADYBSlOxuyNKdaO7ciGeXCdBgvHjuYmLWmnG/fI7McxywbVNE3K3Rr
         eNr4r3+Cq7Qu5kU+PXulEQSVGafwCitJH9+MfXD1PHSxQ73sEuohrSXELY0wV4vECqd7
         8q7D2VERs/8mUOeids6E9hYsWNyBKNr2CCL/9Cw7iey8qMkkipNQeP6788cIae9GzBnn
         H0PCQAdTXL23wALw4t2n7sjLUJN9i/iFMZSHfHDhZXuWBv5nxPMoVyg1ARwNY0AiTATD
         s+sbTGQ5QAcpRuGdfXfZfGOc9sCqI61WQWY6dSYLsi247Ak3YJiaNH+23I3ke35sBlhV
         wc3A==
X-Gm-Message-State: APjAAAWGQ9bX/n5WOrOcVzZbhAQeYQIuuoClg5ke00WQE7st04XYZwL+
        /5zubVC35CKVKeMepjRHjgqXdg==
X-Google-Smtp-Source: APXvYqyO4XowUPOEjHkeHqWq8ZGkAY6pJn5+D2BnJD4VZsQpxWmvikwHKafPm0DLCyolBG2iDeLJ6w==
X-Received: by 2002:a7b:ca5a:: with SMTP id m26mr6573824wml.134.1565769792542;
        Wed, 14 Aug 2019 01:03:12 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:e8f7:125b:61e9:733d])
        by smtp.gmail.com with ESMTPSA id 39sm28546562wrc.45.2019.08.14.01.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 01:03:11 -0700 (PDT)
Date:   Wed, 14 Aug 2019 09:03:07 +0100
From:   Matthias Maennich <maennich@google.com>
To:     Himanshu Jha <himanshujha199640@gmail.com>
Cc:     linux-kernel@vger.kernel.org, maco@android.com,
        kstewart@linuxfoundation.org, linux-m68k@vger.kernel.org,
        oneukum@suse.com,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        usb-storage@lists.one-eyed-alien.net, hpa@zytor.com,
        joel@joelfernandes.org, sam@ravnborg.org, cocci@systeme.lip6.fr,
        linux-arch@vger.kernel.org, linux-scsi@vger.kernel.org,
        x86@kernel.org, lucas.de.marchi@gmail.com, mingo@redhat.com,
        geert@linux-m68k.org, stern@rowland.harvard.edu,
        kernel-team@android.com, sspatil@google.com, arnd@arndb.de,
        linux-kbuild@vger.kernel.org,
        Nicolas Palix <nicolas.palix@imag.fr>, jeyu@kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        tglx@linutronix.de, michal.lkml@markovi.net,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>, maco@google.com,
        pombredanne@nexb.com, "David S. Miller" <davem@davemloft.net>,
        linux-modules@vger.kernel.org
Subject: Re: [Cocci] [PATCH v2 08/10] scripts: Coccinelle script for
 namespace dependencies.
Message-ID: <20190814080307.GA2911@google.com>
References: <20180716122125.175792-1-maco@android.com>
 <20190813121733.52480-1-maennich@google.com>
 <20190813121733.52480-9-maennich@google.com>
 <20190814063611.GA22387@himanshu-Vostro-3559>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190814063611.GA22387@himanshu-Vostro-3559>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 14, 2019 at 12:06:11PM +0530, Himanshu Jha wrote:
>On Tue, Aug 13, 2019 at 01:17:05PM +0100, Matthias Maennich wrote:
>> A script that uses the '<module>.ns_deps' file generated by modpost to
>> automatically add the required symbol namespace dependencies to each
>> module.
>>
>> Usage:
>> 1) Move some symbols to a namespace with EXPORT_SYMBOL_NS() or define
>>    DEFAULT_SYMBOL_NAMESPACE
>> 2) Run 'make' (or 'make modules') and get warnings about modules not
>>    importing that namespace.
>> 3) Run 'make nsdeps' to automatically add required import statements
>>    to said modules.
>>
>> This makes it easer for subsystem maintainers to introduce and maintain
>> symbol namespaces into their codebase.
>>
>> Co-developed-by: Martijn Coenen <maco@android.com>
>> Signed-off-by: Martijn Coenen <maco@android.com>
>> Signed-off-by: Matthias Maennich <maennich@google.com>
>> ---
>
>[]
>
>>  MAINTAINERS                                 |  5 ++
>>  Makefile                                    | 12 +++++
>>  scripts/Makefile.modpost                    |  4 +-
>>  scripts/coccinelle/misc/add_namespace.cocci | 23 +++++++++
>>  scripts/nsdeps                              | 54 +++++++++++++++++++++
>>  5 files changed, 97 insertions(+), 1 deletion(-)
>>  create mode 100644 scripts/coccinelle/misc/add_namespace.cocci
>>  create mode 100644 scripts/nsdeps
>
>[]
>
>> +if [ "$SPATCH_VERSION_NUM" -lt "$SPATCH_REQ_VERSION_NUM" ] ; then
>> +    echo 'spatch needs to be version 1.06 or higher'
>
>Nitpick: 1.0.6
>

Good catch! Thanks!
Actually it needs to be even 1.0.4, so I will just use
$SPATCH_REQ_VERSION from above.

>> +    exit 1
>> +fi
>
>
>-- 
>Himanshu Jha
>Undergraduate Student
>Department of Electronics & Communication
>Guru Tegh Bahadur Institute of Technology
