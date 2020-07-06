Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37ACC433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 02:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8FC620747
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 02:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgGFCaH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jul 2020 22:30:07 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:33560 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728566AbgGFCaH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2020 22:30:07 -0400
Received: by mail-pj1-f65.google.com with SMTP id gc15so5872261pjb.0
        for <linux-scsi@vger.kernel.org>; Sun, 05 Jul 2020 19:30:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=OSQfOVSrGE86t/p2weAgH+JgNr0Q5olZkfN8ToK5eEE=;
        b=kipP1EdcWeTu3Q63XLqWSTj65718x4+1W9VWfdGzLFrs6Jh1v7TYbWMgJIC6epCyeg
         yL/8tI/FM6xsRftH+YG0Af7sMhvlGbDB/1j7zzRDK79t7KkUVlGdeO3DWpiUK6onPPnB
         kYN9Iwikvw0+HEMQhbN076KSDKaCwULcNhDR1kONIpQlYtA70DvIes8nrIkLxjVet+z5
         G076YaUcZ1kx77b/F2XKj3fKzBwlrXglHuc1x8VxWfHRPNS38FyAJSNdoet1ZeYJlsPi
         91s+MHujwXKkPYTRF+PjwA/lIsXawltCwJurg2nGpEZug4DHgbInSxWKZhjBKoRALWmc
         Mryg==
X-Gm-Message-State: AOAM530NTgMZALe3pSaID7M3JYqxefZJ/cTOKKyOamG5W/7VBkYLO1qt
        KUiXqx/8zwLZN02BWhIPGFU9J++m
X-Google-Smtp-Source: ABdhPJztpFZHVIcN6GBTaHU427rSWrkpnFpMv3BJ4Z4dkJbiKx31Xt9ZSW1kXeXDIB2LS8P4F1Z+yA==
X-Received: by 2002:a17:90a:35c:: with SMTP id 28mr38428263pjf.63.1594002605803;
        Sun, 05 Jul 2020 19:30:05 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u128sm16464617pfu.148.2020.07.05.19.30.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 19:30:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
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
Message-ID: <b4842dfd-f385-64a9-6421-03765f60d0d9@acm.org>
Date:   Sun, 5 Jul 2020 19:30:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <819ce023-93c3-249d-2221-97438f229e03@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-02 22:30, Hannes Reinecke wrote:
> And it's called from srp_reconnect_rport() and __rport_fail_io_fast(),
> so we have this call chain:
> 
> srp_reconnect_rport()
>   - scsi_target_block()
>   -> __rport_fail_io_fast()
>        - scsi_target_block()

How about the (untested) patch below?


diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index d4d1104fac99..bfb240675f06 100644
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
@@ -569,9 +565,9 @@ int srp_reconnect_rport(struct srp_rport *rport)
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
