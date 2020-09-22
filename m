Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA328C4346E
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 02:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEBBE22262
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 02:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbgIVCsN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 22:48:13 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51724 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729572AbgIVCsH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 22:48:07 -0400
Received: by mail-pj1-f66.google.com with SMTP id a9so777710pjg.1;
        Mon, 21 Sep 2020 19:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3TVQRlLIwo6pFNEjT7YYd7yU5ajthHTiel3UE6DCXq4=;
        b=INFGYdDyybcpufrVYxx/82bVqXKAdHuksa2JedCJwezrtluWuJ5xu1eP8eRNcJ7quM
         NlEXidyRvCpzsNgGvjFF/cBLmpMSaoN3DbJb6O8ijFayVnq9PIUxo7U/TxvZ4VRZ/Ef0
         4uxW91UWrNcHlnSPjAP0yRWjFSWq1A34Q4W64q+Mq359p0pNnSBGHOBibZKFeJZP0HqG
         UkyTgch7wU2ADvVLDyeCKYq04oftIXw6jkrgnEuu3fS4n1OMCAX2Aqawl6Bq+6nc3/CI
         cjiqT+9sBzIicjzdki5wL9Wsr/v9c8RxsacGGHG0emrYJRlos2Zph9yXFIgMQBVFSF9J
         Wjgw==
X-Gm-Message-State: AOAM5304aIkL450e4E5qQH3lslAMilRNIWY4XmhtD7Jl0dgz1sJhVJFC
        UauSsxBzkErtp/1GJxkYsoQ=
X-Google-Smtp-Source: ABdhPJxk5EP7QY4Q94Hxa9jFIomYpClQyz42Yh5wl7CpLijNh7pXzf5iOjaRviQwsIONP665auPvAw==
X-Received: by 2002:a17:90a:49c8:: with SMTP id l8mr1895046pjm.24.1600742886378;
        Mon, 21 Sep 2020 19:48:06 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:5e05:892c:575b:24c7? ([2601:647:4000:d7:5e05:892c:575b:24c7])
        by smtp.gmail.com with ESMTPSA id k5sm13599229pfp.214.2020.09.21.19.48.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 19:48:05 -0700 (PDT)
Subject: Re: [PATCH 4/8] vhost scsi: fix cmd completion race
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
 <1600712588-9514-5-git-send-email-michael.christie@oracle.com>
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
Message-ID: <cf8e5b11-dfd2-4570-1dab-25486c591dde@acm.org>
Date:   Mon, 21 Sep 2020 19:48:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1600712588-9514-5-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-21 11:23, Mike Christie wrote:
> We might not do the final se_cmd put from vhost_scsi_complete_cmd_work.
> If the last put happens a little later then we could race where
> vhost_scsi_complete_cmd_work does vhost_signal, the guest runs and sends
> more IO, and vhost_scsi_handle_vq runs but does not find any free cmds.
> 
> This patch has us delay completing the cmd until the last lio core ref
> is dropped. We then know that once we signal to the guest that the cmd
> is completed that if it queues a new command it will find a free cmd.

It seems weird to me to see a reference to LIO in the description of a
vhost patch? Since this driver supports more backends than LIO, shouldn't
the patch description be made more generic?

Thanks,

Bart.
