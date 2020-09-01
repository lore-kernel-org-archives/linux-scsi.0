Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24740C43461
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 05:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0742B2087D
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 05:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgIAFAk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 01:00:40 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36391 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgIAFAg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2020 01:00:36 -0400
Received: by mail-pl1-f196.google.com with SMTP id y6so4378741plt.3
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2020 22:00:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=DX1BqXzRsS3pqdr8DoTUlwvDeth2UbVNFZ/Rf4jKPmQ=;
        b=p+0PnYQx0fUHfX90L8TGNccn8znOtJzVD3/uy7XfyORpgCwERxePU2BjgZsmtrhJWk
         s3Nm+aLVEXUgVJjO+MHuZJeZDc1SvDnqtnbVhH/6KjZe7Ag/qQZ18k7H+oCeZ5jo9aKy
         fuTRqCCJ6vwVr50NNC6dqD51oPJ0Sa/wxGftbDu65whqyU1lq0phfxfwUxMb7iXdGxjT
         emjxColkChsBw9Mzy/WUueTPXUF9IjNbcpkwdH1m3x8/MzYAasv55TMD3nNUSiSk/5dl
         muyLmaoA8KkOqJF+NRpOJ4cZtN9v6gC7eLeFD/GqIIS7ZL/rpwZ1MQKJSMrMzcU8eOpo
         9NKg==
X-Gm-Message-State: AOAM533x1OoBUhOtGVg9JU9aPulRKMRmOBOqq0lRt73KBwxHRQNBNcOK
        Yax4ivq08c4jj21V4fuN+qJfYDudAkQ=
X-Google-Smtp-Source: ABdhPJwRI0fzcCaxz+fntVyz5UFq0gLRQnRD7octMGb8Nh1AWk+itwBXIGgKvhMGFpR/jTrGlODiQg==
X-Received: by 2002:a17:90a:3e4f:: with SMTP id t15mr290874pjm.19.1598936433493;
        Mon, 31 Aug 2020 22:00:33 -0700 (PDT)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id g32sm272727pgl.89.2020.08.31.22.00.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 22:00:32 -0700 (PDT)
Subject: Re: [PATCH RFC 6/6] block, scsi, ide: Only submit power management
 requests in state RPM_SUSPENDED
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-scsi@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Can Guo <cang@codeaurora.org>
References: <20200831025357.32700-1-bvanassche@acm.org>
 <20200831025357.32700-7-bvanassche@acm.org>
 <20200831182526.GA558270@rowland.harvard.edu>
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
Message-ID: <e84a8098-0c5f-93fb-9055-292104cb2483@acm.org>
Date:   Mon, 31 Aug 2020 22:00:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200831182526.GA558270@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-31 11:25, Alan Stern wrote:
> Let me clarify this description.
> 
> Firstly, the second-to-last sentence is ambiguous.  The word "only" is
> all too easy to misuse through carelessness.  In this case you meant
> to say "by accepting only power management requests while suspended",
> but what you actually wrote was equivalent to "by accepting power
> management requests only while suspended".  And as it happens, both
> meanings are incorrect because we don't want to accept _any_ requests
> while the device is suspended -- not even power-management requests.
> The description should have said "by postponing all non-power-management 
> requests while the device is suspending, suspended, or resuming."
> 
> Secondly, the scenario described above is not a deadlock; it is a race 
> leading to a command failure.  Namely, the thread setting q->rpm_status 
> to RPM_SUSPENDED races with the thread testing q->rpm_status.
> 
> Thirdly, this race is _not_ the problem that Martin encountered.  His 
> problem was a simple bug (failure to postpone a request), not a race or 
> a deadlock.
> 
> Fourthly, the race illustrated above is, for now, theoretical.  It 
> cannot occur with the existing code base (mostly because the existing 
> code is buggy).  The advantage of your series over the patch I submitted 
> on Aug. 23 ("block: Fix bug in runtime-resume handling") is that it 
> fixes Martin's problem without introducing this new race.

Hi Alan,

Thanks for having taken a look at this patch. Do you perhaps plan to
review the other patches in this series too?

Thanks,

Bart.
