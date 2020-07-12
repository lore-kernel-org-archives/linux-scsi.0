Return-Path: <SRS0=csMy=AX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB6AC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 04:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB24C20748
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 04:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgGLENK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jul 2020 00:13:10 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37697 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgGLENJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jul 2020 00:13:09 -0400
Received: by mail-pg1-f193.google.com with SMTP id d4so4526967pgk.4
        for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2020 21:13:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Q+Iuxj2tV4jqU+Jkl7CgmY/3MT6AJ7nvgpdZ/2MJldg=;
        b=R0F+yBGH8h/pHnuTC2srIWp09sjM729+xAmHh1mQb3IgR5Ui81SyFjV0X1fYLb4e9B
         j93v8vHA+0Fytn2B2QLb2j6U7aDvVZyYKb2zZ2F7jNX/Nrz92oRN61OYyhhJE8cnUXwP
         XicPMlCXuwveKVUiuIrNXC+AIWudob3ZG8uMMU26q8tZLjvSVPddCnDjHyCbBJJ1F+5V
         +JOorpYIKNoc2I4te+OIaugmqBFkbYiRJRocpFdKGbE6RJzt/lHaBhySiUrPou6DazLh
         V3sEFbVSAwSlgW8PkC47jjG+uXYYM7QhFAqMEq0soVqkW5PdmptErA6BaQRw3x9IzvQW
         MkeQ==
X-Gm-Message-State: AOAM531iDomw6UUeueYNQ9BhDdxLoZp6y7QyF1qoJ9uzXWyJJ6xxEWyk
        LoCmEc7EGiq7qK45Msadcy4piRvR
X-Google-Smtp-Source: ABdhPJyhW0VP5abOcT7EEhif0JSoYBIp1g4BJ8SDw1BKsFZyYVSPD8NCoq+JWZu5V1l9mlNyZwbMBQ==
X-Received: by 2002:aa7:8391:: with SMTP id u17mr23928072pfm.156.1594527188617;
        Sat, 11 Jul 2020 21:13:08 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id y7sm10350718pjy.54.2020.07.11.21.13.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 21:13:07 -0700 (PDT)
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
Message-ID: <a2db3f6a-44de-2d2c-6dd1-69d5af8f7e84@acm.org>
Date:   Sat, 11 Jul 2020 21:13:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <97d4882d-2f26-de93-672a-6395e8fedf0c@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-05 23:22, Hannes Reinecke wrote:
> That will still have a duplicate call as scsi_target_block() has been called already (cf scsi_target_block() in line 539 right at the start of srp_reconnect_rport()).
> 
> (And I don't think we need the WARN_ON_ONCE() here; we are checking for rport->state == SRP_RPORT_BLOCKED just before that line...)

How about the patch below? The approach implemented by that
patch is only to call scsi_target_block() after a successful
transition to the SRP_RPORT_BLOCKED state and to only call
scsi_target_unblock() when leaving the SRP_RPORT_BLOCKED state.

Thanks,

Bart.

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index d4d1104fac99..0334f86f0879 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -402,13 +402,9 @@ static void __rport_fail_io_fast(struct srp_rport *rport)

 	lockdep_assert_held(&rport->mutex);

+	WARN_ON_ONCE(rport->state != SRP_RPORT_BLOCKED);
 	if (srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST))
 		return;
-	/*
-	 * Call scsi_target_block() to wait for ongoing shost->queuecommand()
-	 * calls before invoking i->f->terminate_rport_io().
-	 */
-	scsi_target_block(rport->dev.parent);
 	scsi_target_unblock(rport->dev.parent, SDEV_TRANSPORT_OFFLINE);

 	/* Involve the LLD if possible to terminate all I/O on the rport. */
@@ -541,7 +537,8 @@ int srp_reconnect_rport(struct srp_rport *rport)
 	res = mutex_lock_interruptible(&rport->mutex);
 	if (res)
 		goto out;
-	scsi_target_block(&shost->shost_gendev);
+	if (srp_rport_set_state(rport, SRP_RPORT_BLOCKED) == 0)
+		scsi_target_block(&shost->shost_gendev);
 	res = rport->state != SRP_RPORT_LOST ? i->f->reconnect(rport) : -ENODEV;
 	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
 		 dev_name(&shost->shost_gendev), rport->state, res);
@@ -569,9 +566,9 @@ int srp_reconnect_rport(struct srp_rport *rport)
 		 * and dev_loss off. Mark the port as failed and start the TL
 		 * failure timers if these had not yet been started.
 		 */
+		WARN_ON_ONCE(srp_rport_set_state(rport, SRP_RPORT_BLOCKED));
+		scsi_target_block(rport->dev.parent);
 		__rport_fail_io_fast(rport);
-		scsi_target_unblock(&shost->shost_gendev,
-				    SDEV_TRANSPORT_OFFLINE);
 		__srp_start_tl_fail_timers(rport);
 	} else if (rport->state != SRP_RPORT_BLOCKED) {
 		scsi_target_unblock(&shost->shost_gendev,
