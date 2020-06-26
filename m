Return-Path: <SRS0=Z0Y/=AH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62592C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 15:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BA02206E9
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 15:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgFZPHy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 11:07:54 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36305 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgFZPHy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2020 11:07:54 -0400
Received: by mail-pf1-f194.google.com with SMTP id 207so4575480pfu.3;
        Fri, 26 Jun 2020 08:07:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pezo6deaXXT56sW35t3xeRXe694C5+nAYWzpivEgcPs=;
        b=lhsNqIG4OC01BB5w3vOMH833h0ZjxbmdcxMPief2QadFJJhXjguge4d2eZ9VBOGyYU
         xLeF7WTRXzcGFcaMT1hL6tCc6JHum1MqWnRjz7KPecmQMwqEtpynswxw+SOnlHaLvIL/
         k3OceUz+Kz7UP9jZC9ZyKLkzDzvnE8x5e0UW6MHQBaNALECEVJDpz128JaGFr3OcQNFH
         FaN+ewBXrz2fc192LU+zVLDsUSiwLYHwhj/ZLN59SE2E9yyb6fF2bQwEi3g9S+z8s09z
         Y9RB5kjCdmUeD66F5/P76gcdIbDPRzlF8Z8RWc6RG7Sl1v3lSkvcunTJ5IunGkv390Z9
         fwgQ==
X-Gm-Message-State: AOAM5333eBlLinlLx/9kb4TUworjxSe418/Gn//exp3X71l3Rgo+3+90
        +6GDqr67ydgGQO2Y0T2ZYyVLUB8g
X-Google-Smtp-Source: ABdhPJwHciM7R6x2BPpcOFyCWOhcQAXgI0TDwIfYGl7MeAIcvv6wBH1QE/uHpWg8V6nfs8eULfsbmA==
X-Received: by 2002:a62:fc15:: with SMTP id e21mr2407912pfh.167.1593184073522;
        Fri, 26 Jun 2020 08:07:53 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id o22sm26208646pfd.114.2020.06.26.08.07.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 08:07:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
To:     Martin Kepplinger <martin.kepplinger@puri.sm>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
References: <20200623111018.31954-1-martin.kepplinger@puri.sm>
 <ed9ae198-4c68-f82b-04fc-2299ab16df96@acm.org>
 <eccacce9-393c-ca5d-e3b3-09961340e0db@puri.sm>
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
Message-ID: <1379e21d-c51a-3710-e185-c2d7a9681fb7@acm.org>
Date:   Fri, 26 Jun 2020 08:07:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <eccacce9-393c-ca5d-e3b3-09961340e0db@puri.sm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-25 01:16, Martin Kepplinger wrote:
> here's roughly what happens when enabling runtime PM in sysfs (again,
> because sd_probe() calls autopm_put() and thus allows it:
> 
> [   27.384446] sd 0:0:0:0: scsi_runtime_suspend
> [   27.432282] blk_pre_runtime_suspend
> [   27.435783] sd_suspend_common
> [   27.438782] blk_post_runtime_suspend
> [   27.442427] scsi target0:0:0: scsi_runtime_suspend
> [   27.447303] scsi host0: scsi_runtime_suspend
> 
> then I "mount /dev/sda1 /mnt" and none of the resume() functions get
> called. To me it looks like the sd driver should initiate resuming, and
> that's not implemented.
> 
> what am I doing wrong or overlooking? how exactly does (or should) the
> block layer initiate resume here?

As far as I know runtime power management support in the sd driver is working
fine and is being used intensively by the UFS driver. The following commit was
submitted to fix a bug encountered by an UFS developer: 05d18ae1cc8a ("scsi:
pm: Balance pm_only counter of request queue during system resume") # v5.7.
I'm not sure which bug is causing trouble on your setup but I think it's likely
that the root cause is somewhere else than in the block layer, the SCSI core
or the SCSI sd driver.

Bart.
