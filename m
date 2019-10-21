Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D385CA9EAE
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 02:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE1D1218BA
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 02:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfJUCMm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Oct 2019 22:12:42 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43160 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbfJUCMm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Oct 2019 22:12:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id a2so7388390pfo.10
        for <linux-scsi@vger.kernel.org>; Sun, 20 Oct 2019 19:12:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=zUF9Txr7hahCUXDoO9eT8IH0c3v53+w46zwRQpzEbPk=;
        b=MfCXHBisY/T3M86w11ao24dQlW5tV0igO1BYqEk1Kv/5YriNvPGnNWp2ubwYx/uR0H
         R2eN9iSZIs2RsoVwiOzqcFYBOrrmGG1DuamqfetteojH77pEMoHAL+2QtA3v+sE+HWGs
         kaX9Pu41lUcDMZv51D/sBwnEqo65745d6Sx2WY1uYat+LfPjmg3vV1dIiJtECa4tzbIF
         RV1hj+RClqL8Zg1wNzNAVodkYypWHgkWQTAjuACXY6wLF44s3GX1TIzAwLfAwfvchrtJ
         5S5K0HuDcbGBl0iVAEKHCC8DFFuysLDGn0Mxnias2cdsQv8xkFQayHg5K0s9RlGmPESY
         3mMQ==
X-Gm-Message-State: APjAAAWAlH0z7fW26X8u5oJ60wwUgT6ZWWJBZr+iSvVvXlfaXmhzahu7
        lGnpmgmUYZU4uXl0DW1Uh2Q=
X-Google-Smtp-Source: APXvYqwyR76jI1GZEghJzsu97MZzdevGKubX1WOrPZiJUWiLoTMmkig424Zn5G/YAl39c5Dy3div9Q==
X-Received: by 2002:a17:90a:c405:: with SMTP id i5mr26946805pjt.9.1571623961372;
        Sun, 20 Oct 2019 19:12:41 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:ce:256c:d417:b24b:327f])
        by smtp.gmail.com with ESMTPSA id 2sm15881707pfa.43.2019.10.20.19.12.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2019 19:12:40 -0700 (PDT)
Subject: Re: [PATCH] scsi: sd: fix uninit access of sshdr
To:     zhengbin <zhengbin13@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     yi.zhang@huawei.com, yanaijie@huawei.com
References: <1571392910-137272-1-git-send-email-zhengbin13@huawei.com>
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
Message-ID: <fb2f4e78-27f2-140b-d3be-acdc608f3b55@acm.org>
Date:   Sun, 20 Oct 2019 19:12:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1571392910-137272-1-git-send-email-zhengbin13@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-18 03:01, zhengbin wrote:
> @@ -1648,16 +1651,20 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
>  	if (res) {
>  		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
> 
> -		if (driver_byte(res) == DRIVER_SENSE)
> +		/* we need to evaluate the error return  */
> +		if (driver_byte(res) == DRIVER_SENSE &&
> +		    scsi_sense_valid(sshdr)) {
>  			sd_print_sense_hdr(sdkp, sshdr);
> 

Does Hannes' comment about DRIVER_SENSE also apply to this patch?

Thanks,

Bart.
