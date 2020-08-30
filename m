Return-Path: <SRS0=rOw5=CI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129DCC433E2
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 00:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9084208CA
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 00:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbgH3Aiy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Aug 2020 20:38:54 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33061 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbgH3Aix (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Aug 2020 20:38:53 -0400
Received: by mail-pf1-f193.google.com with SMTP id u20so2612448pfn.0;
        Sat, 29 Aug 2020 17:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4HQjIC+m0Ct4LRAVaT/dUJNLGDayEDQaHB2mVguVBOI=;
        b=sjyfiPIE7C8xn4B7Woy46eI0y7BjX1yJSmPOGzmudynO542eYgcD5VT3kIrcVURvsj
         ZIwoK014dsiV5Q61aV0DH8/t1WXonMdZ71Ye0F74INcaLGx4f7ICLBip41RFeAbzKHRf
         e9geWWbO+VKykJLJag4CBvxU20tutOl8y25/6eFCZciLi0BJJTY12050F691csHkWV19
         o0rQCVDRvTqcKxTMU6VGQNNKB8xMDtOqIZqYsmr0G5opBuph0Q7KCstM2s06qHShPDdM
         VtEMMx1tMrq69FquaBHybRsyQncH+dHVYAuBadsndohCmYuucNO53Shk1c/OzxEdKMTT
         jIaQ==
X-Gm-Message-State: AOAM530fmROsW7Y2ECDCJHhEazwlfu+MKP5XBS14ir/BlXfrHMp+LkCW
        3X3Ry7DSDDGxhlYi1JeWd/09fev6Bp8=
X-Google-Smtp-Source: ABdhPJxESy+80ZCUR9L/uGx9o4mWCBGVCrkBnK6QHYf8u8/iRHZP07jvTuIPM07JGb2UhQBGhU5BBQ==
X-Received: by 2002:a62:1d49:: with SMTP id d70mr4464811pfd.197.1598747932288;
        Sat, 29 Aug 2020 17:38:52 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id e12sm3055670pjd.55.2020.08.29.17.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Aug 2020 17:38:51 -0700 (PDT)
Subject: Re: [PATCH] block: Fix bug in runtime-resume handling
To:     Alan Stern <stern@rowland.harvard.edu>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, kernel@puri.sm
References: <6f0c530f-4309-ab1e-393b-83bf8367f59e@puri.sm>
 <20200823145733.GC303967@rowland.harvard.edu>
 <3e5a465e-8fe0-b379-a80e-23e2f588c71a@acm.org>
 <20200824201343.GA344424@rowland.harvard.edu>
 <5152a510-bebf-bf33-f6b3-4549e50386ab@puri.sm>
 <4c636f2d-af7f-bbde-a864-dbeb67c590ec@puri.sm>
 <20200827202952.GA449067@rowland.harvard.edu>
 <478fdc57-f51e-f480-6fde-f34596394624@puri.sm>
 <20200829152635.GA498519@rowland.harvard.edu>
 <6d22ec22-a0c7-6a9d-439e-38ef87b0207c@puri.sm>
 <20200829185653.GB501978@rowland.harvard.edu>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <eb208ee3-b94b-c020-990f-c7151ecaae03@acm.org>
Date:   Sat, 29 Aug 2020 17:38:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200829185653.GB501978@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-29 11:56, Alan Stern wrote:
> A third possibility is the approach I outlined before, adding a 
> BLK_MQ_REQ_PM flag.  But to avoid the deadlock you pointed out, I would 
> make blk_queue_enter smarter about whether to postpone a request.  The 
> logic would go like this:
> 
> 	If !blk_queue_pm_only:
> 		Allow
> 	If !BLK_MQ_REQ_PREEMPT:
> 		Postpone
> 	If q->rpm_status is RPM_ACTIVE:
> 		Allow
> 	If !BLK_MQ_REQ_PM:
> 		Postpone
> 	If q->rpm_status is RPM_SUSPENDED:
> 		Postpone
> 	Else:
> 		Allow
> 
> The assumption here is that the PREEMPT flag is set whenever the PM flag 
> is.

Hi Alan,

Although interesting, these solutions sound like workarounds to me. How
about fixing the root cause by modifying the SCSI DV implementation such
that it doesn't use scsi_device_quiesce() anymore()? That change would
allow to remove BLK_MQ_REQ_PREEMPT / RQF_PREEMPT from the block layer and
move these flags into the SCSI and IDE code.

Thanks,

Bart.
