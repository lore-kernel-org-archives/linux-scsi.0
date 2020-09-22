Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45222C4346E
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 02:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA7E021941
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 02:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgIVCpQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 22:45:16 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40511 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728575AbgIVCpP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 22:45:15 -0400
Received: by mail-pj1-f65.google.com with SMTP id gf14so741667pjb.5;
        Mon, 21 Sep 2020 19:45:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lebGQ0WgPCez2R35wa3urhdXxY/Bn5Nlo8FdNbn1LQ8=;
        b=XqPffxEsBqCLR+pCQ0ggC5HWrnzN0wmJBOgYClrpILlc4oi29NTnajgTC3V7C65F3R
         E6Evzb6P1dqczHQdshOkJZ8ARpIynKmWOlU/lByxVK9FLLu99W0sG44Fxl81ZWzDQTj/
         xVnRMd+158Eh6GuDxnxFgfVhAcrnamn3CmZ2c06MBfuxWjYdI7dqHVV7LnQyO+Y2h37e
         IexLJhW/TL8GEIhDgQE1KPEWblVf3dEjbzNRGU7gs5rucYnH6LWDiQWEmNOAq98Y086D
         Q7oNkQMvBmNhYH/zm/jXYIMZTtDSz5DOUo1OV7CjNd2KetVpjxqJaW/PF9BDQOw0iope
         x+/g==
X-Gm-Message-State: AOAM533/hci9u7ljs3XYM1NvERc4JVuEMQOrWWBcxaMbMFCzZkj2Ow4Y
        xmpxa35NnYbuUYGE/7VCmLI=
X-Google-Smtp-Source: ABdhPJx1GFSufCEXFHwvrnyZqsBLdfFAJf+3amrY8P7gTNNNAQW9ZHB/Zk1bFJXKuO94vvn4SLP1aw==
X-Received: by 2002:a17:90a:ed8e:: with SMTP id k14mr2003130pjy.178.1600742714879;
        Mon, 21 Sep 2020 19:45:14 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:5e05:892c:575b:24c7? ([2601:647:4000:d7:5e05:892c:575b:24c7])
        by smtp.gmail.com with ESMTPSA id a18sm12420584pgw.50.2020.09.21.19.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 19:45:13 -0700 (PDT)
Subject: Re: [PATCH 2/8] vhost: add helper to check if a vq has been setup
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
 <1600712588-9514-3-git-send-email-michael.christie@oracle.com>
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
Message-ID: <ce73f019-a247-7913-47fd-b3e5e7bdf81f@acm.org>
Date:   Mon, 21 Sep 2020 19:45:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1600712588-9514-3-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-21 11:23, Mike Christie wrote:
> +bool vhost_vq_is_setup(struct vhost_virtqueue *vq)
> +{
> +	if (vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq))
> +		return true;
> +	else
> +		return false;
> +}

Has it been considered changing the body of this function into
"return vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq)"? I'm
concerned otherwise one or another build bot will suggest to make that
change.

Thanks,

Bart.
