Return-Path: <SRS0=8IEi=A5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75122C433E2
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 02:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A7112070E
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 02:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgGRCvx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 22:51:53 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38381 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgGRCvv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 22:51:51 -0400
Received: by mail-pg1-f195.google.com with SMTP id e8so7539526pgc.5
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2020 19:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=QfsHcoowj1NE3YZrGcTNFUHa1RrpnCcez76hIDwRoVs=;
        b=qDsKwaVVOgk0549tbAM6zouejCM8ZrMjupUyUW0+mxWvIXltI5xWtteT8kHYYRUd46
         rTtaQAIEiTAjiKr3jtvxjvhPwx3W7pZ6vFMZWLos/DZrQtr4X7M41UNl+1CEKW/zVcyB
         Q2BPMwDsCuor6g4XecutFLB4vhq2jklJJNWpANpUFzEqdHPH1yrTCik4yVSgsExn0f8P
         f80dufwSxRPsdCyVGL72Fsspz2ziOxA9hHmA9uHti3LuHrT48taBAWucq6YPy5BSJ4IL
         R+n5o+EBS82f/rhWEEEjh/mH7IVpKwceKH5pWmw/AdrbGnUMEfyEfr6AJHajzQt8fXOu
         7ptw==
X-Gm-Message-State: AOAM531kSsLF19ZsuVxFAJQLIVMP6mleJ7xsuxEVxis4rXls8vKLn3Yp
        Lh36jhaShYEbOofBrb2DzL7dDWb8
X-Google-Smtp-Source: ABdhPJylQ0wZDHqfy4XruBrMwrz/ptJIfGiZvVRzl7HhAYmVrkvISZUS9u7i0BbKhcKgJk+Ycedb2g==
X-Received: by 2002:a63:1e4d:: with SMTP id p13mr10548873pgm.387.1595040710322;
        Fri, 17 Jul 2020 19:51:50 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id g26sm8884437pfq.205.2020.07.17.19.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 19:51:49 -0700 (PDT)
Subject: Re: [PATCH] scsi: allow state transitions BLOCK -> BLOCK
To:     Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
References: <20200702142436.98336-1-hare@suse.de>
 <1593700443.9652.2.camel@HansenPartnership.com>
 <0c1ce7fc-98ba-0a14-d1a7-889bf1ce794f@suse.de>
 <2dd291ba-1e59-5e88-de96-5d3965f20317@acm.org>
 <819ce023-93c3-249d-2221-97438f229e03@suse.de>
 <b4842dfd-f385-64a9-6421-03765f60d0d9@acm.org>
 <97d4882d-2f26-de93-672a-6395e8fedf0c@suse.de>
 <a2db3f6a-44de-2d2c-6dd1-69d5af8f7e84@acm.org>
 <b31a9be0-1e42-f49f-d5e7-e4568dafa8b2@suse.de>
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
Message-ID: <68eb8671-e8ea-4a52-0679-f7c4e0c0ee3b@acm.org>
Date:   Fri, 17 Jul 2020 19:51:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b31a9be0-1e42-f49f-d5e7-e4568dafa8b2@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-12 23:19, Hannes Reinecke wrote:
> I think this should be sufficient:
> 
> diff --git a/drivers/scsi/scsi_transport_srp.c
> b/drivers/scsi/scsi_transport_srp.c
> index d4d1104fac99..180b323f46b8 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -404,11 +404,6 @@ static void __rport_fail_io_fast(struct srp_rport
> *rport)
> 
>         if (srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST))
>                 return;
> -       /*
> -        * Call scsi_target_block() to wait for ongoing
> shost->queuecommand()
> -        * calls before invoking i->f->terminate_rport_io().
> -        */
> -       scsi_target_block(rport->dev.parent);
>         scsi_target_unblock(rport->dev.parent, SDEV_TRANSPORT_OFFLINE);
> 
>         /* Involve the LLD if possible to terminate all I/O on the
> rport. */
> @@ -570,8 +565,6 @@ int srp_reconnect_rport(struct srp_rport *rport)
>                  * failure timers if these had not yet been started.
>                  */
>                 __rport_fail_io_fast(rport);
> -               scsi_target_unblock(&shost->shost_gendev,
> -                                   SDEV_TRANSPORT_OFFLINE);
>                 __srp_start_tl_fail_timers(rport);
>         } else if (rport->state != SRP_RPORT_BLOCKED) {
>                 scsi_target_unblock(&shost->shost_gendev,

Adding a comment like this above __rport_fail_io_fast() would be welcome:

/*
 * scsi_target_block() must have been called before this function is
 * called to guarantee that no .queuecommand() calls are in progress.
 */

Otherwise the above patch looks fine to me.

Bart.
