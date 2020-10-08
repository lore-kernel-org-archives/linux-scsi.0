Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A2D8C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1796B207C3
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgJHCPx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 22:15:53 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43196 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbgJHCPx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 22:15:53 -0400
Received: by mail-pg1-f195.google.com with SMTP id r10so2920093pgb.10;
        Wed, 07 Oct 2020 19:15:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=rZahkeOsv/7ZzLVwrKkKpR6UG2rhwoDGH2eZn5qcB+Y=;
        b=YHai8hY+cjiDqb7tC5tqo61iv+gd2u2MQaESmIj/Wo+7/Z1NhURQHJXC4IO2oWgmXI
         IyCD5gTMHs9SYVSpuy+i+SBN5iSqYbuYdtsokEmNavLoqaYZsGA0F1RnNGjEB/VR9nWy
         8z7bNkoRtlCmF85Dfr+EypOGx5xjwjWj4OwbCH64rI20vEFghMvkmooFVH1cR01a3H9Y
         2KjegS0P9BIV+mYm4csx/WqxRl7GDI/iaUtt7F0ah62N0YOcczj8cQ9lzcUf05WBYImu
         dAxVD39HY6T8sjd1771nzkkPALQYOA2hC1cc8WF8Mqkda0yLYP83eueNMe9E3YcK4UC9
         UfoA==
X-Gm-Message-State: AOAM531cq+7WBY7lowoxaSfaPaWOgvtPZGS/DFqHbCQBSteBeGt5slry
        tHo+t+HPp7pooxZA9LhjoRvx1w5V8kY=
X-Google-Smtp-Source: ABdhPJwK/fEJ6aFXB/4rvPMahH/XYEcANVJRIh82GP0nNEXbBdW2324O7agiqB/7/CpjnWv7L32/DQ==
X-Received: by 2002:aa7:9af1:0:b029:152:6101:ad12 with SMTP id y17-20020aa79af10000b02901526101ad12mr5406637pfp.40.1602123352282;
        Wed, 07 Oct 2020 19:15:52 -0700 (PDT)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id o6sm4018613pjp.33.2020.10.07.19.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 19:15:51 -0700 (PDT)
Subject: Re: [PATCH 1/2] target: iscsi: prevent a race condition in
 iscsit_unmap_cmd()
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        michael.christie@oracle.com
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-2-mlombard@redhat.com>
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
Message-ID: <1bff131d-d451-2597-7751-fac0269a6e37@acm.org>
Date:   Wed, 7 Oct 2020 19:15:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201007145326.56850-2-mlombard@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-07 07:53, Maurizio Lombardi wrote:
> A potential race condition may occur in iscsit_unmap_cmd() if the
> __iscsit_free_cmd() function is called by two different threads.
> 
> This patch adds a spinlock to serialize the calls to
> iscsit_unmap_cmd()
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target_login.c | 1 +
>  drivers/target/iscsi/iscsi_target_util.c  | 5 ++++-
>  include/target/iscsi/iscsi_target_core.h  | 1 +
>  3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
> index 893d1b406c29..e16ceee87bba 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c
> @@ -1110,6 +1110,7 @@ static struct iscsi_conn *iscsit_alloc_conn(struct iscsi_np *np)
>  	spin_lock_init(&conn->nopin_timer_lock);
>  	spin_lock_init(&conn->response_queue_lock);
>  	spin_lock_init(&conn->state_lock);
> +	spin_lock_init(&conn->unmap_cmd_lock);
>  
>  	timer_setup(&conn->nopin_response_timer,
>  		    iscsit_handle_nopin_response_timeout, 0);
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index 45ba07c6ec27..3082f5bde9fa 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -755,8 +755,11 @@ void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool check_queues)
>  		iscsit_remove_cmd_from_response_queue(cmd, conn);
>  	}
>  
> -	if (conn && conn->conn_transport->iscsit_unmap_cmd)
> +	if (conn && conn->conn_transport->iscsit_unmap_cmd) {
> +		spin_lock(&conn->unmap_cmd_lock);
>  		conn->conn_transport->iscsit_unmap_cmd(conn, cmd);
> +		spin_unlock(&conn->unmap_cmd_lock);
> +	}
>  }

This looks weird to me. Shouldn't the iSCSI target code make sure that
__iscsit_free_cmd() is called once per command instead of allowing concurrent
calls of that function and serializing iscsit_unmap_cmd() calls?

Thanks,

Bart.
