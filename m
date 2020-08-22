Return-Path: <SRS0=DDJn=CA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABDBC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Aug 2020 15:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56D0F20714
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Aug 2020 15:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgHVPxZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Aug 2020 11:53:25 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39640 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbgHVPxZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Aug 2020 11:53:25 -0400
Received: by mail-pf1-f195.google.com with SMTP id u128so2590406pfb.6
        for <linux-scsi@vger.kernel.org>; Sat, 22 Aug 2020 08:53:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=rViAx0oHFSOJV2+b4fvXq5/hXshGFZd92Y4135x6eWk=;
        b=QzAaeUVzEN/e5cg8V1U1wjsvCuHnbxIFtZklmXGgRE5O3WdUOGt6b2tOsJ6ZWq03q/
         IlyQn/kI9nVgrHP8nXTS0NhOnP+KM6PAL+VQhlsZ0xXlnFhKziwb8MpBb1I/Oa8USIjC
         rSTcfEcqrBRgAQnl8owcn5yFAksMwdni+88K8XfQSpSyTr1dqUfyLk7USFUeUDJKQM82
         jQGo5zahJ8v2CpAgdqa/w/ZsgkB7ITanmJs/dYVIDItQgnXgwa9u9RuInZKYbM9ATzbY
         XLxgG8JdzDctCkYx6/V/VtqiQJVwpzUvi9EPgZllY5bDJgGE4/lzl8uGX6JUv4lMK8FQ
         Pp+g==
X-Gm-Message-State: AOAM532eZAcGdancC0UPa1R7RN6GOjvUvKPRMBjW4DScPZLslTSSTVrd
        xyO3s33bWPcI8RVFsctCjyQ=
X-Google-Smtp-Source: ABdhPJwOR/W3v5dH1+AvRvwkG60e8josMlgZipnGPmoL+t6FeDh5w4nZQ+pHiFltXzNsBXtAyeYJ0A==
X-Received: by 2002:a63:4543:: with SMTP id u3mr5389970pgk.398.1598111604414;
        Sat, 22 Aug 2020 08:53:24 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id z15sm5020758pgz.13.2020.08.22.08.53.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2020 08:53:23 -0700 (PDT)
Subject: Re: [PATCH] fix qla2xxx regression on sparc64
To:     Rene Rebe <rene@exactcode.com>, linux-scsi@vger.kernel.org
Cc:     Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20200822.135941.315149880460809536.rene@exactcode.com>
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
Message-ID: <b7719680-e451-5687-1fb7-c8c059a880d4@acm.org>
Date:   Sat, 22 Aug 2020 08:53:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200822.135941.315149880460809536.rene@exactcode.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-22 04:59, Rene Rebe wrote:
> Commit 98aee70d19a7e3203649fa2078464e4f402a0ad8 in 2014 broke qla2xxx on
> sparc64, e.g. as in the Sun Blade 1000 / 2000. Unbreak by partial revert to
> fix endianess in nvram firmware default initialization.
> 
> Fixes: 98aee70d19a7e ("qla2xxx: Add endianizer to max_payload_size modifier.")
> Signed-off-by: René Rebe <rene@exactcode.de>
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 57a2d76aa691..0916c33eb076 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4603,18 +4603,18 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
>  			nv->firmware_options[1] = BIT_7 | BIT_5;
>  			nv->add_firmware_options[0] = BIT_5;
>  			nv->add_firmware_options[1] = BIT_5 | BIT_4;
> -			nv->frame_payload_size = 2048;
> +			nv->frame_payload_size = __constant_cpu_to_le16(2048);
>  			nv->special_options[1] = BIT_7;
>  		} else if (IS_QLA2200(ha)) {
>  			nv->firmware_options[0] = BIT_2 | BIT_1;
>  			nv->firmware_options[1] = BIT_7 | BIT_5;
>  			nv->add_firmware_options[0] = BIT_5;
>  			nv->add_firmware_options[1] = BIT_5 | BIT_4;
> -			nv->frame_payload_size = 1024;
> +			nv->frame_payload_size = __constant_cpu_to_le16(1024);
>  		} else if (IS_QLA2100(ha)) {
>  			nv->firmware_options[0] = BIT_3 | BIT_1;
>  			nv->firmware_options[1] = BIT_5;
> -			nv->frame_payload_size = 1024;
> +			nv->frame_payload_size = __constant_cpu_to_le16(1024);
>  		}
>  
>  		nv->max_iocb_allocation = cpu_to_le16(256);

Drivers should use cpu_to_le16() instead of __constant_cpu_to_le16().

Additionally, this patch introduces the following new sparse warnings:

$ make C=2 M=drivers/scsi/qla2xxx
  CC [M]  drivers/scsi/qla2xxx/qla_os.o
  CHECK   drivers/scsi/qla2xxx/qla_os.c
  CC [M]  drivers/scsi/qla2xxx/qla_init.o
  CHECK   drivers/scsi/qla2xxx/qla_init.c
drivers/scsi/qla2xxx/qla_init.c:4606:48: warning: incorrect type in assignment (different base types)
drivers/scsi/qla2xxx/qla_init.c:4606:48:    expected unsigned short [usertype] frame_payload_size
drivers/scsi/qla2xxx/qla_init.c:4606:48:    got restricted __le16 [usertype]
drivers/scsi/qla2xxx/qla_init.c:4613:48: warning: incorrect type in assignment (different base types)
drivers/scsi/qla2xxx/qla_init.c:4613:48:    expected unsigned short [usertype] frame_payload_size
drivers/scsi/qla2xxx/qla_init.c:4613:48:    got restricted __le16 [usertype]
drivers/scsi/qla2xxx/qla_init.c:4617:48: warning: incorrect type in assignment (different base types)
drivers/scsi/qla2xxx/qla_init.c:4617:48:    expected unsigned short [usertype] frame_payload_size
drivers/scsi/qla2xxx/qla_init.c:4617:48:    got restricted __le16 [usertype]

Please fix these.

Bart.
