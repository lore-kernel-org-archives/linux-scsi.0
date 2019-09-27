Return-Path: <SRS0=gVs6=XW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57DEBC4360C
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 02:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3742520872
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 02:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbfI0Cpx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 22:45:53 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40499 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbfI0Cpx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2019 22:45:53 -0400
Received: by mail-pf1-f195.google.com with SMTP id x127so646229pfb.7;
        Thu, 26 Sep 2019 19:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=a8QnptXlbNqNWh8h555NDUYz0htmZzCXZ6ahm6pCgL8=;
        b=JQg3Fy0x+QaTUWq/mfE4UiLOfvxxS3fer6jWpBVYokE/IBMS1WItLqfB8iJ1E0+dAT
         S3/6agpqvyODTd1TM660oImFqt4fN1WPvk4ePK4Fs28XmPkj2O9vVDQb3IxjsxTEGeqT
         W0Jk0EVRIn5/i0d8CHprnZ9OEqBVZi0MgL6ijd8UwLAU+Oh+LMIByxJZRtgINqQMVfSS
         ZuuIsSQTeU188HT7oT/qIJusV1spI6mMIyLSP1lTF5xjSND6wJlZouOLZpn0UTW+PEoT
         fR8SkuPAogX7/IpbSLjzIeCp1qLayJf8rSisPRjoPg13ilwX/H6s9tg3Gip+svQ2IxBj
         LtBg==
X-Gm-Message-State: APjAAAUyWUKSZxXXFPE21RGSC8aPjIYYTq+CHKdCB5kE10fJugdQlrmn
        5XWR4NdNkDvMG2f78R8wIbODsJtmsaQ=
X-Google-Smtp-Source: APXvYqwPy+lTnAffuw77QUljt+n75IETbFV50p92KjAk70OVXhf4ffxDz2LlpiLrs3bRIWlHoL2F8A==
X-Received: by 2002:a63:f5f:: with SMTP id 31mr6672160pgp.265.1569552352089;
        Thu, 26 Sep 2019 19:45:52 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:a9:2083:a241:50c7:8f37])
        by smtp.gmail.com with ESMTPSA id a17sm598301pfi.178.2019.09.26.19.45.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 19:45:51 -0700 (PDT)
Subject: Re: [PATCH] scsi: qla2xxx: Remove WARN_ON_ONCE in
 qla2x00_status_cont_entry()
To:     Daniel Wagner <dwagner@suse.de>, qla2xxx-upstream@qlogic.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190926074637.77721-1-dwagner@suse.de>
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
Message-ID: <5d5931ef-7ffa-3f3f-bb5e-5379c1716d04@acm.org>
Date:   Thu, 26 Sep 2019 19:45:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190926074637.77721-1-dwagner@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-09-26 00:46, Daniel Wagner wrote:
> Commit 88263208dd23 ("scsi: qla2xxx: Complain if sp->done() is not
> called from the completion path") introduced the WARN_ON_ONCE in
> qla2x00_status_cont_entry(). The assumption was that there is only one
> status continuations element. According to the firmware documentation
> it is possible that multiple status continuations are emitted by the
> firmware.
> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  drivers/scsi/qla2xxx/qla_isr.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 4c26630c1c3e..009fd5a33fcd 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2837,8 +2837,6 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
>  	if (sense_len == 0) {
>  		rsp->status_srb = NULL;
>  		sp->done(sp, cp->result);
> -	} else {
> -		WARN_ON_ONCE(true);
>  	}
>  }

Should the following be added?

Fixes: 88263208dd23 ("scsi: qla2xxx: Complain if sp->done() is not
called from the completion path")

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
