Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA026C38A30
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 04:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A93C20706
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 04:29:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q27zU9FW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgDVE3B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 00:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725355AbgDVE3A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 00:29:00 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A657C061BD3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 21:28:59 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t40so366673pjb.3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 21:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XLitEYkWVm42iZUPW3b7n1Y2cYaZL+XmLkg1cIhyiyw=;
        b=Q27zU9FWWEH4uuR2HCTrJstlJB0CV64h7DtvtZIwu3dRTfyXe0friT1asaF40r21Yc
         EZ0vHQ67194CBTthwmK0zvHZ/0FptSZC1viH1TmieRt14HgMPsOXasq1b8QK9v1h9fLH
         YiWPLctu2k6GtkFBy3qEKvlF6tl3bF2k1Ph8lDNX354aMoLtNektS18pa2yfUKfSn+fQ
         eWG8c6kv/noDzwJcR6dTA4831LkGBj+Un8Cef5Xw6phVesXuIKb2l5pbQE16syPm6zrm
         quOjoSuE0C3fQE6+PYGei+D5Mw5KAOiYbuPmUBD7A1UxL13baXeADq402nApkihmQFNQ
         7JuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XLitEYkWVm42iZUPW3b7n1Y2cYaZL+XmLkg1cIhyiyw=;
        b=ePBzbX6I41YrGbL3MRprpgNAH8p9QrES5v2XSVYe1mEYzxJHwLlnjqFZvltmx0DVln
         mDwZCUhZSgPd/2YMEyhZ9SBqVcSU9Et7KgdY+t2hu6E9jfZhaaVwf7pGig2YdnVtNRyo
         3R3isJ9HdyTLPcfrLIkJpdgKQFtheVQTED3GQMqUBx8mevEpK6FlVAMtg8zI7Wis6et5
         +hDWSa3/X0bjn9t2BOlk6TA6lhA4OwqovfPBAI84Kby+gMUKSxthoaDNy2GNa0sFGazx
         6LUa0Vyimhs2z3xZ9W6QOHZ7AQQIKfcfiYEyCSjVYhihNXcm4dS/J+lzhdR7f4YLh5rH
         H+VQ==
X-Gm-Message-State: AGi0PuYhQ/rQ1Q6O8BxamO18AFwECKxwnX7Z+v2BYxODY2I1YRTSI7iK
        GUCFbTYFmziYqJvd9W1UQjO2/Jwd
X-Google-Smtp-Source: APiQypKFNUXMHWvtvWrRAxH1qgGauNkMO1Vl7UCA+UFG+zjI68GCtbfNaMSz3PhGktCwH72CuVeoAw==
X-Received: by 2002:a17:90a:30a5:: with SMTP id h34mr9056769pjb.171.1587529738245;
        Tue, 21 Apr 2020 21:28:58 -0700 (PDT)
Received: from [10.230.185.141] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e7sm3954162pfj.97.2020.04.21.21.28.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 21:28:57 -0700 (PDT)
Subject: Re: [PATCH v3 01/31] elx: libefc_sli: SLI-4 register offsets and
 field definitions
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-2-jsmart2021@gmail.com>
 <20200414152326.4xphopo6pv7g4x4h@carbon.lan>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <7030a6f4-110e-0599-66fe-87a26bb2b973@gmail.com>
Date:   Tue, 21 Apr 2020 21:28:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200414152326.4xphopo6pv7g4x4h@carbon.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/14/2020 8:23 AM, Daniel Wagner wrote:
> Hi James,
> 
> On Sat, Apr 11, 2020 at 08:32:33PM -0700, James Smart wrote:
>> This is the initial patch for the new Emulex target mode SCSI
>> driver sources.
>>
>> This patch:
>> - Creates the new Emulex source level directory drivers/scsi/elx
>>    and adds the directory to the MAINTAINERS file.
> 
> I would drop this. It's clear from the diff stat.
> 
>> - Creates the first library subdirectory drivers/scsi/elx/libefc_sli.
>>    This library is a SLI-4 interface library.
> 
> Instead saying what this patch does, it would be better the explain
> why it structured this way.

Ok. I will see what I can come up with.

> 
...
> 
> BTW, why is it called SLI4_BMBX_WRITE_HI and not just SLI4_BMBX_HI?
> Because below with the doorbell registers there is a different pattern.

Because the semantics of the BMBX register involve writing it (as a u32) 
once for the high address bits and a second time for the low address 
bits. The format is slightly different on each write.

I'll see how to comment this and clarify.  inlines will help.

Agree with the rest of the comments and will clarify

-- james


