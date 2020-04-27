Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 203B1C4CECC
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 17:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02688215A4
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 17:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgD0Ruf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 13:50:35 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43624 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbgD0Ruf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 13:50:35 -0400
Received: by mail-pg1-f194.google.com with SMTP id x26so9002832pgc.10
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2020 10:50:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=EOgJz/e+KWP1+Ikt6E1jHaBmmnotVUP+07pDBSbsznI=;
        b=D6DHyK4EH9sENrfvGjHqM/pTHGMUjfkdK3fHUxhov/EpJKwAWn0ohSxVtIyWDfrkzZ
         AV3bsfe/+nDQubI9+mFGNo6rfoHxbrG3dtWfxTDvl0PCcFcTLzFgiYl7VhcP1LZirjV0
         wtZsgr8bQ2WDoRa0zm4/VCAwMpYuWzVRDVh1Mo2+DdT3rIba8d812zk2IiPlMJmtvU0Z
         Ib7m2r3ArBgBXlJ1abARs2AcOXTw0Yg5+DXeukkBb7XphvkYs4I08LjEtSO1qb7yXF4F
         zgSY+rKxE/8F7KopXv9lv29gXBoFR+Uqd6MJcKT0zoSgaSKHDHg9nJ7W6sdlphazXXRF
         97YA==
X-Gm-Message-State: AGi0PuawHkIKzY/qZzWH1YPIupFFOnwE9Ne8kZ48f74I1qTzLlFaNXw2
        ALEeVpAJm9cR83YjNrW80d0=
X-Google-Smtp-Source: APiQypIrMXGzQAR4h7dBwzrQLTBQXyOTwPWWmAM8WPkRLiwkJjdd97wGFgtUma1yFFLdLE8tvZAT6g==
X-Received: by 2002:a63:6d4a:: with SMTP id i71mr23889515pgc.445.1588009834486;
        Mon, 27 Apr 2020 10:50:34 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:a598:4365:d06:a875? ([2601:647:4000:d7:a598:4365:d06:a875])
        by smtp.gmail.com with ESMTPSA id o12sm10869269pgl.87.2020.04.27.10.50.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 10:50:33 -0700 (PDT)
Subject: Re: [PATCH 1/3] scsi: qla2xxx: Fix warning after FC target reset
To:     Viacheslav Dubeyko <v.dubeiko@yadro.com>,
        linux-scsi@vger.kernel.org
Cc:     hmadhani@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux@yadro.com, r.bolshakov@yadro.com
References: <1d7b21bf9f7676643239eb3d60eaca7cfa505cf0.camel@yadro.com>
 <fcbbfdac-1a79-51ac-beae-ea4b38f21798@acm.org>
 <b8648e0b817def5416d73215c1174589547e336d.camel@yadro.com>
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
Message-ID: <8db0599b-909d-d787-fc8b-10b2c08b3176@acm.org>
Date:   Mon, 27 Apr 2020 10:50:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <b8648e0b817def5416d73215c1174589547e336d.camel@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-27 02:18, Viacheslav Dubeyko wrote:
> Hi Bart,
> 
> On Sun, 2020-04-26 at 18:55 -0700, Bart Van Assche wrote:
>> On 2020-04-24 05:10, Viacheslav Dubeyko wrote:
>>> From: Viacheslav Dubeyko <v.dubeiko@yadro.com>
>>> Date: Fri, 10 Apr 2020 11:07:08 +0300
>>> Subject: [PATCH 1/3] scsi: qla2xxx: Fix warning after FC target
>>> reset
>>>
>>> Currently, FC target reset finishes with the warning
>>> message.
>>
>> Hi Slava,
>>
>> For future patch submissions, please include a cover letter with the
>> patch series and also use threaded mode, e.g. by setting
>> sendemail.thread = true in ~/.gitconfig.
>>
>> A summary of what Martin Petersen expects from contributors is
>> available
>> at 
>> https://lore.kernel.org/ksummit-discuss/yq1o8zqeqhb.fsf@oracle.com/.
>>
> 
> Frankly speaking, I don't see the logical relations among these three
> fixes. So, I didn't prepare the cover letter because of this. I believe
> that three independent patches could be better than patchset. What do
> you think?

Most people who are subscribed to kernel mailing lists use an e-mail
client that supports threaded mode. Including a cover letter helps
e-mail clients that support threaded mode a lot.

> I am using the Evolution for sending the patches. I am not completely
> sure that sendemail.thread = true in ~/.gitconfig can change the
> Evolution's behavior. Is it something wrong with the Evolution's
> settings?

Please consider to use git send-email instead of Evolution. Most kernel
developers use git branches to prepare patches. Using git send-email to
send out a patch series from a git branch is much less work than copying
these patches into Evolution and next telling Evolution to send out the
patch series. Additionally, last time I used Evolution myself to send
out patches I encountered a weird character encoding bug. I had to
change character encoding from UTF-8 into UTF-7 to make sure that
Evolution handles diacritics in names of people correctly.

Bart.
