Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCCE9C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 02:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4896207E8
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 02:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgF1Ch6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 22:37:58 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42686 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgF1Ch5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 22:37:57 -0400
Received: by mail-pg1-f194.google.com with SMTP id e9so6737465pgo.9;
        Sat, 27 Jun 2020 19:37:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ApaT5mQiC8dLYKF7pAl+GBx+g0XuFrutiTFXiajlTbc=;
        b=HcLXENjpX9NOIlhYVxo7+91//rdfKaR8U9tafxD8/P+cw2w2+G3Pgz7XEL4tIsZ2tf
         /xDyQyz5HvOvF3b6mFvRe/jgR2tYJ80c9RCXAMu3wX9zWO52A/ew8IB62rHeaeJFHLjr
         BwJqH9JGTFeS3qluspFAFW+f/F2WaJf4H9y/kuO6vvyv1lds+CVqN7ucZaWij3I6GVbD
         U3vBArmHLOZaZrti4kUskBT33Fe1a6nRIX7UlqDsFml/ZqA0gjiCOAi7SNhW9HY3DSqQ
         PstnwVyp0nxMJP7BncYV8YziTv4TptqCxDFogQ+GHOwr7I6GeHlstNIx+ghB5qLYsHM5
         pvIQ==
X-Gm-Message-State: AOAM533TyDbtG4lagBmqDTi46q6uzc6yo1a4KPcc65adyutF/WkXiyNL
        wAs6j+eHVnD0y7C6Y/glOBU=
X-Google-Smtp-Source: ABdhPJySqv6Aj7fPV9OuSBdIfBeylZZk/RmSNNvXNSuez1iqbw6tjEiTGvJs2ZjoD62pJz+e7HqcDQ==
X-Received: by 2002:a65:6415:: with SMTP id a21mr5158350pgv.129.1593311876540;
        Sat, 27 Jun 2020 19:37:56 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id t24sm26283053pgm.10.2020.06.27.19.37.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Jun 2020 19:37:55 -0700 (PDT)
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>, jejb@linux.ibm.com,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
References: <20200623111018.31954-1-martin.kepplinger@puri.sm>
 <ed9ae198-4c68-f82b-04fc-2299ab16df96@acm.org>
 <eccacce9-393c-ca5d-e3b3-09961340e0db@puri.sm>
 <1379e21d-c51a-3710-e185-c2d7a9681fb7@acm.org>
 <20200626154441.GA296771@rowland.harvard.edu>
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
Message-ID: <5c10d65c-14ba-d2d5-ee7f-c4579432823e@acm.org>
Date:   Sat, 27 Jun 2020 19:37:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200626154441.GA296771@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-26 08:44, Alan Stern wrote:
> On Fri, Jun 26, 2020 at 08:07:51AM -0700, Bart Van Assche wrote:
>> As far as I know runtime power management support in the sd driver is working
>> fine and is being used intensively by the UFS driver. The following commit was
>> submitted to fix a bug encountered by an UFS developer: 05d18ae1cc8a ("scsi:
>> pm: Balance pm_only counter of request queue during system resume") # v5.7.
> 
> I just looked at that commit for the first time.
> 
> Instead of making the SCSI driver do the work of deciding what routine to 
> call, why not redefine blk_set_runtime_active(q) to simply call 
> blk_post_runtime_resume(q, 0)?  Or vice versa: if err == 0 have 
> blk_post_runtime_resume call blk_set_runtime_active?
> 
> After all, the two routines do almost the same thing -- and the bug 
> addressed by this commit was caused by the difference in their behaviors.
> 
> If the device was already runtime-active during the system suspend, doing 
> an extra clear of the pm_only counter won't hurt anything.

Hi Alan,

Do you want to submit a patch that implements this change or do you
perhaps expect me to do that?

Thanks,

Bart.
