Return-Path: <SRS0=mW7r=XC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49211C43331
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Sep 2019 00:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18B87208C3
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Sep 2019 00:13:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ms8Y1p4g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393239AbfIGANr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 20:13:47 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44093 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389288AbfIGANr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2019 20:13:47 -0400
Received: by mail-pf1-f193.google.com with SMTP id q21so5610638pfn.11
        for <linux-scsi@vger.kernel.org>; Fri, 06 Sep 2019 17:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Spvdc33clcoI+a6vwSzgftHLqivHojmlm8yoJkvlMzU=;
        b=Ms8Y1p4gyEo0DXVX5rev360ZCZyD0SDw+Y87Hf6XX4cugwvj7vCB9Lsza2DOdKD3jq
         lr7MZCM0fGBPsLl9mKd8Y2d7YH4Sikv41Zx4IQjNm6ZDogLQGveBPsRDdNEKUWD+Cerm
         TKGVUd4/6qwaZBD0+fbHXSHmir9VZX5qtAIfk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Spvdc33clcoI+a6vwSzgftHLqivHojmlm8yoJkvlMzU=;
        b=TWBgMJd8hnrYUP3WWr3bcbLzaRWkZh1vZs7a6QCl9OUWZd0CjlvVy81I3wIuktqoU7
         Jljm8B5Gz55ucUi6eWiKrkGYaAfT0PQ2cKXzLYxc8nv6GHGz5GbEs+cALlzwTZFWfv1D
         0kJtFXEllHhdcU6ASsw5yxTNlanqaxdSY/LW2r1cbp0wpx1GDMcoKsGbW1HKH7ubpWCq
         VjsVINSwRQSDzMMdh/rS9IPv/+gYNxJWOyQ2tKGp6OrkhL28tqjSHzwHAZ8cnDclaPMo
         LCoJBxVcFLKLKfi+LhZtok6nnqYoXsSAlIRnAURvY3937el6n0AU2k1hioxfSpr9OvwO
         bMvg==
X-Gm-Message-State: APjAAAWpGdLS3QfPzYJnk4/ZAuCE5jlyWRDsSomTHw2iwre3Acyue50s
        PziuvrLItcgagk0aUAIfXZqD9A==
X-Google-Smtp-Source: APXvYqwHMYt2NA8Keg2hMSHk1i0NAI1EvBz+X7y74Qq0MJVHD+jKY8xfnoV2v5mCJiF/nyKcxcDpdg==
X-Received: by 2002:a63:595d:: with SMTP id j29mr10443950pgm.134.1567815226830;
        Fri, 06 Sep 2019 17:13:46 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i9sm17103419pgo.46.2019.09.06.17.13.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 17:13:46 -0700 (PDT)
Subject: Re: [GIT PULL] SCSI fixes for 5.3-rc7
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <1567802352.26275.3.camel@HansenPartnership.com>
 <CAHk-=wiqV2T03rOx=8DTttZkL-N8b-anRkvT2F_w7hOGfjH92Q@mail.gmail.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <63ffa77c-8a60-05ae-4694-e0b7b0e679a1@broadcom.com>
Date:   Fri, 6 Sep 2019 17:13:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wiqV2T03rOx=8DTttZkL-N8b-anRkvT2F_w7hOGfjH92Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/6/2019 4:18 PM, Linus Torvalds wrote:
> On Fri, Sep 6, 2019 at 1:39 PM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
>> index 8d8c495b5b60..d65558619ab0 100644
>> --- a/drivers/scsi/lpfc/lpfc_attr.c
>> +++ b/drivers/scsi/lpfc/lpfc_attr.c
>> @@ -5715,7 +5715,7 @@ LPFC_ATTR_RW(nvme_embed_cmd, 1, 0, 2,
>>    *      0    = Set nr_hw_queues by the number of CPUs or HW queues.
>>    *      1,128 = Manually specify the maximum nr_hw_queue value to be set,
>>    *
>> - * Value range is [0,128]. Default value is 8.
>> + * Value range is [0,256]. Default value is 8.
>>    */
> Shouldn't that "1,128 = Manually specify.." line also have been updated?
>
> Not that I really care, and I'll pul this, but..
>
>                        Linus

Yes - thanks

-- james

