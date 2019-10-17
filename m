Return-Path: <SRS0=lSD6=YK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D5BECE599
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 02:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51A0B21925
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 02:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407207AbfJQCfk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Oct 2019 22:35:40 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36296 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730039AbfJQCfk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2019 22:35:40 -0400
Received: by mail-pl1-f194.google.com with SMTP id j11so369564plk.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2019 19:35:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=8xz2EIOHnE9pcrgsKr0wuKDQPp37Ki0K3BzdU/tVV1U=;
        b=FfcE2IhoaOpFKLr2ENpolb2pupl6YilnUT8EljuGCKYUt1xUY1XM9kdCxrwDI3brRV
         C3OVOpAXlNf+DjI4gVOZ0QHgx9RvHUc8264rSPhg11CwtjftxMFeBg4kEvCItCstO5dt
         oRggf9uqfke3wpCnGoaBpB7kIkvW2f3kxp0xFCEn3Gj6sX5WY5f3XiRpTh8NZdv4InzY
         yGPVSFFF6ALKxg+mnV6lFtMpqH+YSgN2Bn2t/sEsL7An5i7uCih0RhPrV8yQwv8k7Tpj
         CbLlA66cdE7NU+hG6pzuOFerFqw+D4t+qY/MyjAnIpNaWkxZgNv+mIfcd6rYAM1GQ/wz
         iIQA==
X-Gm-Message-State: APjAAAWdmXpdY4QNW1f/zvq+kv+3/mBRu0dyZEIc+R8yVIk+9wQnj2j2
        MqJw7++fHcMjCN4bAJClf13SY+5A
X-Google-Smtp-Source: APXvYqx+IizVCYouTY+6Ib2ONg/8M5U8lDp2EH/rn+P57CTvdCtP0D8Q/gjROEzARFybMHd6d6Me3w==
X-Received: by 2002:a17:902:8207:: with SMTP id x7mr1420219pln.225.1571279739447;
        Wed, 16 Oct 2019 19:35:39 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:6f7:39e3:62ec:4c0a:9f8e])
        by smtp.gmail.com with ESMTPSA id cx22sm449684pjb.19.2019.10.16.19.35.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 19:35:38 -0700 (PDT)
Subject: Re: [PATCH] scsi: core: try to get module before removing devcie
To:     Yufen Yu <yuyufen@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <20191015130556.18061-1-yuyufen@huawei.com>
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
Message-ID: <2a4e5565-d1a1-514f-02a3-0fecb321f93b@acm.org>
Date:   Wed, 16 Oct 2019 19:35:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191015130556.18061-1-yuyufen@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-15 06:05, Yufen Yu wrote:
> We have a test case like block/001 in blktests, which will
> create a scsi device by loading scsi_debug module and then
> try to delete the device by sysfs interface. At the same time,
> it may remove the scsi_debug module.

Please consider to contribute the test case to the blktests project. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
