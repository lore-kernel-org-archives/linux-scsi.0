Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502A5C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 03:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34EAE21927
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 03:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGNDwZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 23:52:25 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33300 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbgGNDwY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 23:52:24 -0400
Received: by mail-pg1-f195.google.com with SMTP id o13so7018045pgf.0;
        Mon, 13 Jul 2020 20:52:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=UXE751zIIFgh027qDCVtDdLdHQV0rMbRG0ZLyfRJL5o=;
        b=X5rrr3WkkAYyJsVHx0qRRJwQYGoS5slwnMX6H2XfJxFbmMxkEjMu9MfP+3jpMnQmwv
         9swlTMdx5Czv4IuVGaHnedrsODB979xtQUkI65QgdKMdFCz/Ou0//+QKXkjZulaG7zLX
         tkXmWWmTd4IghenO9tWM1Gl3bLwjCuiQNRGmMQZ8CYk1Q02os1QFqmhcVhLB1flvnqOw
         JO2Tt91Mmtis6HEsXrT6ZaJ2bFbNMrzSoagnrdMY5FSMM3JffJaYoLEGX14IhFQMle1W
         bVxpy+ETZAHeazCaTpnFx0M+OyTaMa9E25nedVRc5FIk8vxwK4Iab3NbL7kOU56yu4TN
         z0kg==
X-Gm-Message-State: AOAM531cOeeJpC9GxLaoCk1IZixNW7doHtPIXTCUWdsq11Wwa8G7Rmxt
        cvYYgxCL4Hq0jmsv3jiXRBSfcQh3
X-Google-Smtp-Source: ABdhPJztFKkCdsXY/+4DSxvIjYYbd4u86P1Gq3ocS4ILMJhgrDS6nc+g38ftAGIdwMigaknjaEfx3Q==
X-Received: by 2002:a62:8c92:: with SMTP id m140mr2539318pfd.245.1594698743187;
        Mon, 13 Jul 2020 20:52:23 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id az16sm899808pjb.7.2020.07.13.20.52.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 20:52:22 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] scsi: ufs: Fix up and simplify error recovery
 mechanism
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1594693693-22466-1-git-send-email-cang@codeaurora.org>
 <1594693693-22466-5-git-send-email-cang@codeaurora.org>
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
Message-ID: <fe00619c-f337-397f-9ccf-7babda095210@acm.org>
Date:   Mon, 13 Jul 2020 20:52:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594693693-22466-5-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-13 19:28, Can Guo wrote:
> o Queue eh_work on a single threaded workqueue to avoid concurrency between
>   eh_works.

Please use another approach (mutex?) to serialize error handling. There are
already way too workqueues in a running Linux system.

> o According to the UFSHCI JEDEC spec, hibern8 enter/exit error occurs when
>   the link is broken. This actaully applies to any power mode change
>   operations. In this change, if a power mode change operation (including
>   AH8 enter/exit) fails, mark the link state as UIC_LINK_BROKEN_STATE and
>   schedule eh_work. eh_work needs to do full reset and restore to recover
>   the link back to active. Before the link state is recovered to active by
>   eh_work, any power mode change attempts just return -ENOLINK to avoid
>   consecutive HW error.
> 
> o To avoid concurrency between eh_work and link recovery, remove link
>   recovery from hibern8 enter/exit func. If hibern8 enter/exit func fails,
>   simply return error code and let eh_work run in parallel.
> 
> o Recover UFS hba runtime PM error in eh_work. If ufschd_suspend/resume
>   fails due to UFS error, e.g. hibern8 enter/exit error and SSU cmd error,
>   the runtime PM framework saves the error to dev.power.runtime_error.
>   After that, hba runtime suspend/resume would not be invoked anymore until
>   dev.power.runtime_error is cleared. The runtime PM error can be recovered
>   in eh_work by calling pm_runtime_set_active() after reset and restore
>   succeeds. Meanwhile, if pm_runtime_set_active() returns no error, which
>   means dev.power.runtime_error is cleared, we also need to explicitly
>   resume those scsi devices under hba in case any of them has failed to be
>   resumed due to hba runtime resume error.
> 
> o Fix a racing problem between eh_work and ufshcd_suspend/resume. In the
>   old code, it blocks scsi requests before schedules eh_work, but when
>   eh_work calls pm_runtime_get_sync(), if ufshcd_suspend/resume is sending
>   a scsi cmd, most likely the SSU cmd, pm_runtime_get_sync() will never
>   return because scsi requests were blocked. To fix this racing problem,
>   o Don't block scsi requests before schedule eh_work, but let eh_work
>     block scsi requests when eh_work is ready to start error recovery.
>   o Meanwhile, if eh_work is schueduled due to fatal error, don't requeue
>     the scsi cmds sent from ufshcd_suspend/resume path, but simply let the
>     scsi cmds fail. If the scsi cmds fail, hba runtime suspend/resume fails
>     too, but it does hurt since eh_work recovers hba runtime PM error.
> 
> o Move host/regs dump in ufshcd_check_errors() to eh_work because heavy
>   dump in IRQ context can lead to stability issues. In addition, some clean
>   up in ufshcd_print_host_regs() and ufshcd_print_host_state().

The above list is a long list. To me that is a sign that this patch needs to
be split into multiple patches.

Thanks,

Bart.
