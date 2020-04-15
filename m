Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CF6C2BB1D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 02:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BFBB20737
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 02:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387802AbgDOCab (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 22:30:31 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34651 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729186AbgDOCa0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 22:30:26 -0400
Received: by mail-pl1-f193.google.com with SMTP id a23so711788plm.1;
        Tue, 14 Apr 2020 19:30:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YQZHyePF+6j26BRIml82egHgGBTgMnsKmOETdnWup7g=;
        b=PKoqCRrVeLDhASeRwfTe0ykNXIA9jtad5NM9Y706hOmRVgbhtSuy1q8dyDXBPsejEG
         +bWhxsCj3fLXmOV12B8CA9qyT60S2IJZclXZdb+w6T2V/dw7sjyWSq2ps6qblGWWhlWS
         T1TtW9VSJUhdtrDosyGNGqKNVI2kSYrmLeVhnvYt3DMKjHjUTdcwddy23YEUbUftxZ0f
         /e9wkEbqSi2EqBT23y/RgeQQxYz8gueYVdKyC1UgmEUCh5nd2/fyJzPGW/x6Ee6YF4ga
         XKJUpBQFP3cRJb9hZ52LFlre5/hw9IjwVTcCFkzFoD0AoYEAXwJ7+76B4yp39Puken9o
         291A==
X-Gm-Message-State: AGi0PuYoaPPnsL6hari6GTdVeVBvfRkYirr9Sk/70iAoY7nWolgY5SKD
        aoL2haS0qEjTjG3TAQ3X2To=
X-Google-Smtp-Source: APiQypJRUFERYBe9V2BYDvjopeuL57TsOJM31eVaKMTUG3plWE1uO8KvnPgS0OMKSmXaHeVCCRggtA==
X-Received: by 2002:a17:90a:4809:: with SMTP id a9mr3502672pjh.73.1586917823617;
        Tue, 14 Apr 2020 19:30:23 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:3d9e:6f43:1883:92f0? ([2601:647:4000:d7:3d9e:6f43:1883:92f0])
        by smtp.gmail.com with ESMTPSA id q201sm12417021pfq.32.2020.04.14.19.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 19:30:21 -0700 (PDT)
Subject: Re: [RFC PATCH 2/5] target: add sysfs session helper functions
To:     Mike Christie <mchristi@redhat.com>, jsmart2021@gmail.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, nab@linux-iscsi.org
References: <20200414051514.7296-1-mchristi@redhat.com>
 <20200414051514.7296-3-mchristi@redhat.com>
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
Message-ID: <20ecaf0e-698c-fb9c-26fd-a1f2dc79392e@acm.org>
Date:   Tue, 14 Apr 2020 19:30:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200414051514.7296-3-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-13 22:15, Mike Christie wrote:
> @@ -537,8 +538,15 @@ void transport_deregister_session_configfs(struct se_session *se_sess)
>  }
>  EXPORT_SYMBOL(transport_deregister_session_configfs);
>  
> +

A single blank line is probably sufficient here?

>  void transport_free_session(struct se_session *se_sess)
>  {
> +	kobject_put(&se_sess->kobj);
> +}
> +EXPORT_SYMBOL(transport_free_session);
> +
> +void __target_free_session(struct se_session *se_sess)
> +{
>  	struct se_node_acl *se_nacl = se_sess->se_node_acl;
>  
>  	/*
> @@ -582,7 +590,6 @@ void transport_free_session(struct se_session *se_sess)
>  	percpu_ref_exit(&se_sess->cmd_count);
>  	kmem_cache_free(se_sess_cache, se_sess);
>  }
> -EXPORT_SYMBOL(transport_free_session);

Does this patch defer execution of the code inside
transport_free_session() from when transport_free_session() is called to
when the last reference to a session is dropped? Can that have
unintended side effects? How about keeping most of the code that occurs
in transport_free_session() in that function and only freeing the memory
associated with the session if the last reference is dropped?

Thanks,

Bart.
