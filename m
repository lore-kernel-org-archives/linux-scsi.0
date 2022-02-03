Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D74AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 22:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355822AbiBCW2C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 17:28:02 -0500
Received: from mail-pj1-f44.google.com ([209.85.216.44]:39733 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiBCW2B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 17:28:01 -0500
Received: by mail-pj1-f44.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so11338604pjj.4;
        Thu, 03 Feb 2022 14:28:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=duGMxGsB/QuPA1bGwv9ppb+K/mMk4EUk821rVNi53dg=;
        b=iZxWByy6GVPYkvikPlaL5Z/m3rDjRSYQ/jXiqD1WNgRKfOeSpZZkydnbHtAzcGA+UM
         XdDfnCcYuqO7iuG3vh1M1K8KqeoWbyoXEx83fESi8OxPJ8xBLBGl8ZvtnKTGYXt3EVAz
         B8BMkyuwEbYd1Kwny2cI6Vn5zsyqaEL/v8ITCfa+54Nx7rpetoVIS424ylCwHXMSunIc
         G2zU+RPwr+Kdry05AzcnQT/bxYFHHPKWCJFzxlFuog2RnUOh5T2j9VZqlaYCjWNfRx7j
         p4HZPJxCh2HflkFkSmlNnCayjOkPOa50wKBak1jYAn+aUAEJUzqF2rcUKOX2Mt2dUZgQ
         p/xA==
X-Gm-Message-State: AOAM532xfW9QCbV8Rat16ebZxfWxPksS+X/LeoevQFk9VIVXyzW9gwpl
        6EXRVniajL1XAKioGFuLiRU=
X-Google-Smtp-Source: ABdhPJw39uPY/9UWfY02QkgFnEA8TScYvODGhpxt/GorKORgIIEj3g5vP9N6YeBH7YakcAl5Rozokg==
X-Received: by 2002:a17:902:7fc9:: with SMTP id t9mr38122072plb.53.1643927281364;
        Thu, 03 Feb 2022 14:28:01 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id h21sm32407pfv.135.2022.02.03.14.27.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 14:28:00 -0800 (PST)
Message-ID: <62b6c21c-7dde-0eba-7fae-a63ec168e766@acm.org>
Date:   Thu, 3 Feb 2022 14:27:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/2] scsi: Add scsi_done_direct() for immediate
 completion.
Content-Language: en-US
To:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc:     linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20220201210954.570896-1-sebastian@breakpoint.cc>
 <20220201210954.570896-2-sebastian@breakpoint.cc>
 <c8402f76-7397-77c3-232c-c825c52ea826@acm.org> <YfwxJPUFCo5/55yI@flow>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YfwxJPUFCo5/55yI@flow>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/3/22 11:46, Sebastian Andrzej Siewior wrote:
> On 2022-02-02 12:49:16 [-0800], Bart Van Assche wrote:
>> On 2/1/22 13:09, Sebastian Andrzej Siewior wrote:
>>> -void scsi_done(struct scsi_cmnd *cmd)
>>> +static bool scsi_done_need_blk_compl(struct scsi_cmnd *cmd)
>>
>> I'm not happy about the name of this function. The word "need" in the
>> function name suggests that this function does not modify any state.
>> However, the body of the function shows that it may complete a SCSI command.
>> How about renaming the existing scsi_done() function into
>> scsi_done_internal() or so and adding a "bool complete_directly" argument to
>> that function?
> 
> Let me see what I can do.
> 
>> BTW, I only received patch 1/2 but not patch 2/2. Please Cc the linux-scsi
>> mailing list for the entire patch series when reposting the patch series.
> 
> I did and based on lore's archive it made it to the list:
> 	https://lore.kernel.org/linux-scsi/20220201210954.570896-1-sebastian@breakpoint.cc/

I agree that patch 2/2 seems to have made it to the linux-scsi list. 
However, I can't find that patch in my mailbox nor in my spam folder. I 
think this is the first time that I did not receive a patch sent to the 
linux-scsi mailing list. Weird ...

Bart.
