Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85309C4363D
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 02:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EB1821531
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 02:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbgJACyy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 22:54:54 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34595 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgJACyy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2020 22:54:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id k13so3065300pfg.1
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2020 19:54:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ba6kCSnHTvYSJ7tkav1SA5XtG8mriR1CcIvRzfUMOK8=;
        b=O6LYCA1LHue1wCVv847AiGd3Mf+oi1zz83ke7wsiMOycKKhOi0RIxtX5OirtR350qS
         xgp3BuQbzPgjyWwHy7mwGrHaouhos/jeWeR5pst/yNx4fMWr05t6UH4nbj1ziDdFJDWN
         XH5m/EXAySVNCdgviOYBgs89z/xFVkzQgYrszAvDpzpzHeuykjpy+tTMDEntT4QBtRGQ
         oGDQkk6ZXQPGztKLcJQKnpMEG0Vgh+xBhYWogXIbUINDaVVvZKg2UrusFpkw8efnliBw
         7yNUbkm15IH7txlgfkl+CsPKUQXeFGtyVIkqSIO+gGH9LOAxBlgrDB9brS9WFL8xWJS6
         iRtA==
X-Gm-Message-State: AOAM532EyuAczZMpNR3XETbiiQyv9TU4ESGQ7QK1+HYq3Lsl6doGsLUM
        x8sNdKUe5eS/2jV/4uu9o20=
X-Google-Smtp-Source: ABdhPJw+rdRkKOy2hSmwWeA5nd6+DEHxRik9hDGMQ6rECO2DRiT+6eMeRCukfRRwz49S/lJTdQO4xw==
X-Received: by 2002:a05:6a00:23cc:b029:142:2501:35cf with SMTP id g12-20020a056a0023ccb0290142250135cfmr5361411pfc.47.1601520892469;
        Wed, 30 Sep 2020 19:54:52 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:74c0:38d3:8092:91f1? ([2601:647:4000:d7:74c0:38d3:8092:91f1])
        by smtp.gmail.com with ESMTPSA id y7sm3454310pgk.73.2020.09.30.19.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 19:54:51 -0700 (PDT)
Subject: Re: [PATCH 2/2] scsi sd: Allow user to config cmd retries
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <1601398908-28443-1-git-send-email-michael.christie@oracle.com>
 <1601398908-28443-3-git-send-email-michael.christie@oracle.com>
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
Message-ID: <0a68e3b4-5a1f-ff59-a6cd-4eafc593e9e6@acm.org>
Date:   Wed, 30 Sep 2020 19:54:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1601398908-28443-3-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-29 10:01, Mike Christie wrote:
> Some iSCSI targets went the traditional export N ports and then allowed
> the initiator to multipath over them. Other targets went the opposite
> direction and export 1 port, and then software on the target side
> performs load balancing and failover to other targets via a iscsi
> specific feature or IP takover.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
