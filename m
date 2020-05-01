Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14476C47247
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 01:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE88920873
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 01:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgEABuI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 21:50:08 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37509 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgEABuI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2020 21:50:08 -0400
Received: by mail-pg1-f194.google.com with SMTP id r4so3915711pgg.4;
        Thu, 30 Apr 2020 18:50:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=qkIeoMHtgOsTJkY1aDcu+fBY2Ht3cDIXeezTTJRV748=;
        b=QqGCXmjbW+PYtlg11P9wKIWUwHk0uNxTHOP1L0zwN87Jb6fsch4miK4RlJ9po258AY
         tc7ZUPOyxqUFPwp0Kffxs+GHERahlyQllqxy55/+QTRiuMfxg8UnR5S+Pc6IlAz1cPAi
         jZWlPG3+OaECOPmf6WBpQUam2l8zLQvLKt2KV+ZrlnB4NNQATIARnhLjCoFwLaom4aFB
         9wRF1ojb7CWE9J8Db2UEiJ/I9eujtK1INHKcfoZDXi9bR8veOITMwX69+qRCBYx69VJR
         ftKB4o005UQFhNhruZri+AtWmUKtzWT60D9lTUIdki/PWN6XU4PQcAUci5GZyxkL4M26
         Zccw==
X-Gm-Message-State: AGi0PuaDbC26VMuzb5dFicCOsUzvpwgocPKdyTbPTFjzr9+nmqbULJA4
        no3SpL1XYiteIMo44bfFzYOAOWA/N3s=
X-Google-Smtp-Source: APiQypLEgLff28ZP2x8zYd3YtoDlBcERGP54sgg8E6/dfD6WzPsDz+pvqx9X0aPESAV+eI5E/lgazQ==
X-Received: by 2002:a63:7801:: with SMTP id t1mr1882676pgc.192.1588297805676;
        Thu, 30 Apr 2020 18:50:05 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:8cd3:cd23:3cea:980a? ([2601:647:4000:d7:8cd3:cd23:3cea:980a])
        by smtp.gmail.com with ESMTPSA id l64sm816022pjb.44.2020.04.30.18.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 18:50:04 -0700 (PDT)
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
 <ef23a815-118a-52fe-4880-19e7fc4fcd10@acm.org>
 <1e2a2e39dbb3a0f06fe95bbfd66e1648@codeaurora.org>
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
Message-ID: <226048f7-6ad3-a625-c2ed-d9d13e096803@acm.org>
Date:   Thu, 30 Apr 2020 18:50:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1e2a2e39dbb3a0f06fe95bbfd66e1648@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-30 18:42, Can Guo wrote:
> On 2020-05-01 04:32, Bart Van Assche wrote:
> > Has it been considered to test directly whether a SCSI device has been
> > runtime suspended instead of relying on blk_queue_pm_only()? How about
> > using pm_runtime_status_suspended() or adding a function in
> > block/blk-pm.h that checks whether q->rpm_status == RPM_SUSPENDED?
> 
> Yes, I used to make the patch like that way, and it also worked well, as
> both ways are equal actually. I kinda like the current code because we
> should be confident that after scsi_dev_type_resume() returns, pm_only
> must be 0. Different reviewers may have different opinions, either way
> works well anyways.

Hi Can,

Please note that this is not a matter of personal preferences of a
reviewer but a matter of correctness. blk_queue_pm_only() does not only
return a value > 0 if a SCSI device has been runtime suspended but also
returns true if scsi_device_quiesce() was called for another reason.
Hence my request to test the "runtime suspended" status directly and not
to rely on blk_queue_pm_only().

Thanks,

Bart.
