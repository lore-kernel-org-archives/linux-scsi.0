Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 901C9C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A87F61A6C
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbhKSTmg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 14:42:36 -0500
Received: from mail-pl1-f179.google.com ([209.85.214.179]:39662 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235775AbhKSTmf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 14:42:35 -0500
Received: by mail-pl1-f179.google.com with SMTP id z6so7705164plk.6
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:39:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y4Mipi8KfW+FxLWz+h7xa73fwcA50nZTj+lIi+BiR+c=;
        b=2C/v2YitJEX5fsVVxmrIIXcv7T555w8fyWMCRPycQhWZcuOhV/YlnZvHYh+mk6O78O
         +S0GzhbHV2pH20+GFI0Dfn70bymkWqthRUtF/BShgfMYLmslUUzU6AfA3TIq6vNbxIwR
         l0izdLII/GP2bGqoz204LdJG3def5SjI64vxboBzCjXxyF+hlKIaV7gO01DuMb7XmHqA
         3lwYJFivgrxMHIF4XFzvcSz1WYEKL4vFq+0tV/ucWiIHib4h1le8WZ0gSHmgwiMxukib
         Id1N5HQvQ1qOmNbC3/pYLSnNIeDr0qTlpov9rWgrHm7Nm1VxEDA/Sc4x1EJF6vSwGUh2
         wXqA==
X-Gm-Message-State: AOAM531+oJmYu2Hl6B1lPCJH/f0dlpDrwXDfEW1qhwhdsGBF4+k+W/9p
        nqOqMYx9NQTy8cp0rk7IRZM=
X-Google-Smtp-Source: ABdhPJzbr35fuXRGPPmAi+t/MicCLAnj68POgwG2ljM8g0+ccHuVSOIRHraj4LAZesOg/0fdm/+WYA==
X-Received: by 2002:a17:90a:7004:: with SMTP id f4mr2615478pjk.156.1637350769338;
        Fri, 19 Nov 2021 11:39:29 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id k12sm364895pgi.23.2021.11.19.11.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 11:39:28 -0800 (PST)
Message-ID: <209216ac-878a-3e96-5e8e-eaa92fad7f35@acm.org>
Date:   Fri, 19 Nov 2021 11:39:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 11/11] scsi: ufs: Implement polling support
Content-Language: en-US
To:     dgilbert@interlog.com,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-12-bvanassche@acm.org>
 <b921b85e-1685-da71-2ee7-806d8e75ce9d@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b921b85e-1685-da71-2ee7-806d8e75ce9d@interlog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/21 17:36, Douglas Gilbert wrote:
> On 2021-11-09 7:44 p.m., Bart Van Assche wrote:
>> The time spent in io_schedule() is significant when submitting direct
>> I/O to a UFS device. Hence this patch that implements polling support.
>> User space software can enable polling by passing the RWF_HIPRI flag to
>> the preadv2() system call or the IORING_SETUP_IOPOLL flag to the
>> io_uring interface.
> 
> There have been some changes recently (i.e. in linux-stable now),
> "HIPRI" seems to be on the out, replaced by "POLLED". [I'm using
> poll_lld in my sg rewrite to refer to this type of polling, as "poll"
> is an overloaded term in the kernel].
> 
> REQ_HIPRI has become REQ_POLLED and blk_poll() is now bio_poll().
> That said RWF_HIPRI is still in fs.h and there is no RWF_POLLED (yet).

Hi Doug,

My reference to RWF_HIPRI in the patch description refers to the flag
defined in the uapi headers. As far as I know that flag is still there:

$ PAGER= git grep define.RWF_HIPRI include/uapi
include/uapi/linux/fs.h:#define RWF_HIPRI       ((__force __kernel_rwf_t)0x00000001)

Thanks,

Bart.
