Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F49FC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 14:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC47320787
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 14:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgEROje (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 10:39:34 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39217 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgEROjd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2020 10:39:33 -0400
Received: by mail-pf1-f194.google.com with SMTP id b190so5044322pfg.6;
        Mon, 18 May 2020 07:39:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=v/Lrwkj7ubPYecCIOxmLzR7ynh9p8lUjesL2Dh/wkrM=;
        b=GH2AGYyJyuVwur+ava7+7Xq/o/bCLkYGr+aSOcanDeM2tZLls9m/EJgvl2L5x9+XMC
         e9+mtiMayO4x8+vZSxbgRaW/xJDVb0o3OwiYy+mRWJ1Lg3E1+2jkRWOhcjzp4UrKHEio
         sf/2pfdO4wi4ygU1wPlNYNwXr51+jF2AirJWHKFM3WK5KY7f9GOm7n527xcD7DMzVmjF
         GeE/xw7O8uC9v8KmqW/WWuilItn9qhixj9YFU/twBWaKokR0Rckbw+QNunfDAfwJtItX
         sgbuwvb/cdHqQj0Ma5cLJRcbWWsTW/BaIbzLyTDjWrwOOcwad8hzd0YhFoBR6nP8ntSP
         p9Rg==
X-Gm-Message-State: AOAM532qFBktGoso1J1vbPK97QJR8emKRpQ1GpnetT1+hZWZPgeWBMPx
        rAqRizLo34bOHgn2F5tQxKlS3Au/
X-Google-Smtp-Source: ABdhPJzMQhYMNQKtT9vPjCMAFxD4Keq2xnycG6+758d06IuIzPOgKFwolz+FoBqqNFBCyyBfHolgvQ==
X-Received: by 2002:a63:f925:: with SMTP id h37mr15995306pgi.112.1589812772347;
        Mon, 18 May 2020 07:39:32 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:dc5d:b628:d57b:164? ([2601:647:4000:d7:dc5d:b628:d57b:164])
        by smtp.gmail.com with ESMTPSA id h7sm3194729pgn.60.2020.05.18.07.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 07:39:31 -0700 (PDT)
Subject: Re: [PATCH] scsi: Fix incorrect usage of shost_for_each_device
To:     Ye Bin <yebin10@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200518074420.39275-1-yebin10@huawei.com>
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
Message-ID: <95d13fe2-e267-a536-def4-083a20c016be@acm.org>
Date:   Mon, 18 May 2020 07:39:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200518074420.39275-1-yebin10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-18 00:44, Ye Bin wrote:
> shost_for_each_device(sdev, shost) \
> 	for ((sdev) = __scsi_iterate_devices((shost), NULL); \
> 	     (sdev); \
> 	     (sdev) = __scsi_iterate_devices((shost), (sdev)))
> 
> When terminating shost_for_each_device() iteration with break or return,
> scsi_device_put() should be used to prevent stale scsi device references from
> being left behind.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
