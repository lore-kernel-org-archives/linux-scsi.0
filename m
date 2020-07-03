Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88ACC433E1
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 17:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C96072084C
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 17:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgGCRhq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 13:37:46 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41762 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGCRhp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 13:37:45 -0400
Received: by mail-pl1-f195.google.com with SMTP id f2so12872632plr.8;
        Fri, 03 Jul 2020 10:37:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FKz3ED/z8BcmOmlSMRSUek5a9fXyrBNAWkBaskV0LPQ=;
        b=S0Ico9jhH5UqioSgXdw+0VOeOBJiqRKodJh9SVEa+EN69mROtDQCUJe+3C5BUiSAh9
         nb0RlzmreqnEsg/x9f1z03wPVYicw2QZTTOQ83nFu6VyOYjIgIIYMncCZKAYkS9myPms
         2y8LRrJ+BcOlSpufs5wVZhxidVwMZU+PGv1//jsUuHPiIXClNSbMS+GbpJWnB+HV3kvI
         dnA5m5ohASYz5s2FzvJTelwGy4TL1kQKbQzOWPG0AIXon6RSKVSB7rWybUof9SEAjz9z
         rMHdenoZvJKb/BTpM+kw3YENzI/cjsth3MF5VMcY1THkGT4lq/pEW3MfdrPGs2lr9ogn
         ImFg==
X-Gm-Message-State: AOAM533rMY40rjmAd1fr/RMoJ32TOooLDFEIx7FoM54VvfvEHIfvmyIi
        qLf+Y8A8RAWfQkGL3FuJ8BePJhtU
X-Google-Smtp-Source: ABdhPJzZesB16sorEnkqH652PJ3SQxitOgQ4s3gjialzi7QDhrrl4EvIgMcrZmHL11wF8JsL+cxukg==
X-Received: by 2002:a17:90a:df11:: with SMTP id gp17mr36492456pjb.188.1593797864353;
        Fri, 03 Jul 2020 10:37:44 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n18sm12919039pfd.99.2020.07.03.10.37.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 10:37:43 -0700 (PDT)
Subject: Re: [RFC PATCH 00/10] target: add configfs interface
To:     Mike Christie <michael.christie@oracle.com>, hare@suse.de,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
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
Message-ID: <0b59d643-61bf-6876-cc42-83ee8040da10@acm.org>
Date:   Fri, 3 Jul 2020 10:37:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-26 21:34, Mike Christie wrote:
> With Hannes not liking the refcounting/tricks in the sysfs approach
> I took another stab at configfs. This approach works similar to the
> loop/vhost/usb/xen nexus interface where there is a special file
> that allows userspace to add/remove sessions.

Hi Mike,

Are you perhaps referring to the comment in the following message?
https://lore.kernel.org/linux-scsi/f0bd2a33-c084-6c9b-faa1-9d92bdb2df7a@suse.de/
The duplication of strings in that patch also looks weird to me.
I think kobject_del() waits for ongoing sysfs show and store callbacks to finish.
Since patch 12/15 adds a kobject_del() call in target_sysfs_remove_session(), is
that call perhaps sufficient to guarantee that the
se_sess->se_node_acl->initiatorname pointer and similar pointers are all valid
at least as long the session sysfs object exists?

Thanks,

Bart.
