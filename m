Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A14BCC47254
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 20:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B7F120731
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 20:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgD3UdB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 16:33:01 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41587 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgD3UdB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2020 16:33:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id 18so439017pfv.8;
        Thu, 30 Apr 2020 13:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6s9zyXezq5p776V1QmCkWHOA/JnlTVaHafoWYsRDGG8=;
        b=LPnAbA9FV+Wva1Hxm7feA09jV4AFPxTj7l0c5yM0L4s0nqkJco7iDOsZbC5hCgZu12
         LGWeSXqH9mU4EJ9WpKzV9a2DfLJiPr93UcD70d7yz9zGx342mjX5uLc/hc6fdzkNclF+
         rTCSXANogL9hpGVQZt2BA71qENCfKCcaFe1zyOjJSCh5FbTrbx47BS9Lme+Ov7SE/YRF
         vBYzLF4NAfBsZHN3XENcWkcvOjeLKN36svptWusKSeXOJi5Sp0NytJIxEJSj75LgXtyd
         K4LBVpwrXaToDiPKT2dSTtGy1fO3sMoOj5m5YEMwaynVhewj10Wz2iPGZw6c4+/wRFNR
         omaw==
X-Gm-Message-State: AGi0PuaCkg8pzuUZr5UBMuvzrLaccn6kcJyXstWeR9cfPDVyDZmUaXT4
        pSkO9vnXEQ7a2i39YITKpjCeZrb4nlA=
X-Google-Smtp-Source: APiQypLalz/1qsTwLLlHmgoWxhiB2BCqnpcg9GqicOpeG3sSeT84UxD+okjpYt5cECDi6jZ24D3lTA==
X-Received: by 2002:a63:564e:: with SMTP id g14mr768413pgm.63.1588278778510;
        Thu, 30 Apr 2020 13:32:58 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:8cd3:cd23:3cea:980a? ([2601:647:4000:d7:8cd3:cd23:3cea:980a])
        by smtp.gmail.com with ESMTPSA id d8sm543938pfd.159.2020.04.30.13.32.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 13:32:57 -0700 (PDT)
Subject: Re: [PATCH v3 1/1] scsi: pm: Balance pm_only counter of request queue
 during system resume
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        stanley.chu@mediatek.com, alim.akhtar@samsung.com,
        beanhuo@micron.com, Avri.Altman@wdc.com,
        bjorn.andersson@linaro.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1588219805-25794-1-git-send-email-cang@codeaurora.org>
 <9e15123e-4315-15cd-3d23-2df6144bd376@acm.org>
 <1ef85ee212bee679f7b2927cbbc79cba@codeaurora.org>
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
Message-ID: <ef23a815-118a-52fe-4880-19e7fc4fcd10@acm.org>
Date:   Thu, 30 Apr 2020 13:32:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1ef85ee212bee679f7b2927cbbc79cba@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-29 22:40, Can Guo wrote:
> On 2020-04-30 13:08, Bart Van Assche wrote:
>> On 2020-04-29 21:10, Can Guo wrote:
>>> During system resume, scsi_resume_device() decreases a request queue's
>>> pm_only counter if the scsi device was quiesced before. But after that,
>>> if the scsi device's RPM status is RPM_SUSPENDED, the pm_only counter is
>>> still held (non-zero). Current scsi resume hook only sets the RPM status
>>> of the scsi device and its request queue to RPM_ACTIVE, but leaves the
>>> pm_only counter unchanged. This may make the request queue's pm_only
>>> counter remain non-zero after resume hook returns, hence those who are
>>> waiting on the mq_freeze_wq would never be woken up. Fix this by calling
>>> blk_post_runtime_resume() if pm_only is non-zero to balance the pm_only
>>> counter which is held by the scsi device's RPM ops.
>>
>> How was this issue discovered? How has this patch been tested?
> 
> As the issue was found after system resumes, so the issue was discovered
> during system suspend/resume test, and it is very easy to be replicated.
> After system resumes, if this issue hits some scsi devices, all bios sent
> to their request queues are blocked, which may cause a system hang if the
> scsi devices are vital to system functionality.
> 
> To make sure the patch work well, we have tested system suspend/resume
> and made sure no system hang happen due to request queues got blocked
> by imbalanced pm_only counter.

Thanks, that's very interesting information. My concern with this patch
is that the power management code is not the only caller of
blk_set_pm_only() / blk_clear_pm_only(). E.g. the SCSI SPI code also
calls scsi_device_quiesce() and scsi_device_resume(). These last
functions call blk_set_pm_only() and blk_clear_pm_only(). More calls of
scsi_device_quiesce() and scsi_device_resume() might be added in the future.

Has it been considered to test directly whether a SCSI device has been
runtime suspended instead of relying on blk_queue_pm_only()? How about
using pm_runtime_status_suspended() or adding a function in
block/blk-pm.h that checks whether q->rpm_status == RPM_SUSPENDED?

Thanks,

Bart.
