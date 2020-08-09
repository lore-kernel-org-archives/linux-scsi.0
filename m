Return-Path: <SRS0=1wnw=BT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D43C433E1
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 00:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8DFE206C3
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 00:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgHIA3b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Aug 2020 20:29:31 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37372 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgHIA3a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2020 20:29:30 -0400
Received: by mail-pj1-f66.google.com with SMTP id mw10so2929904pjb.2;
        Sat, 08 Aug 2020 17:29:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=k0Q617GOOxsvAC/qWphQFDLOhIM15Suvk09+e7APeMc=;
        b=Ny8iCLmLvYqXA2Qh5ci/RKuSMJ6yN/taSI5CJtQ7EJGx2nNDYCfNLfX4OwacV+Ay91
         k1Mt4EOP/Gp7xETdRvwiLuspjA4Le7bLpvE0Dx4VYUfz1ch+BEQ/21tILUno5dipGSZg
         eykIOwReCno6T8xf3uLh1fz0Fh/hqGbXjusSjAQkiHKieHELiMgUGxOvhw1bDedec26r
         Z7XNFXfRZ5xVkuWynaYpxCMwlO8krSwlZMKScG96CjFqepUX1TA6DE2lzJuYXkQF4HqZ
         dLLAqFggICl2boxBfnXM0UTCwgyN51jkvhQCRvZlloMbfkVqo8sQU3srbGgoUwIEfpM0
         Q88Q==
X-Gm-Message-State: AOAM5325TzTzYw66ReMUj4FoPNuEfgDvQYGXPNhFdwW620V6Lqmkx4BR
        xEYjG0dJKVvKO/JmRxWOOJo=
X-Google-Smtp-Source: ABdhPJxAXJgUl9eao4GGGiqBo2jRE3ZEDtN/XTPLmTD+8g4tnCK3YJfMH0t/SE8ieE3Uxc9ja3Ul1w==
X-Received: by 2002:a17:902:900b:: with SMTP id a11mr18140800plp.315.1596932969668;
        Sat, 08 Aug 2020 17:29:29 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id f195sm17756723pfa.96.2020.08.08.17.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2020 17:29:28 -0700 (PDT)
Subject: Re: [PATCH v8 3/4] scsi: ufs: L2P map management for HPB read
To:     daejun7.park@samsung.com,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
References: <231786897.01596705302142.JavaMail.epsvc@epcpadp1>
 <231786897.01596705001840.JavaMail.epsvc@epcpadp1>
 <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
 <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p2>
 <336371513.41596705485601.JavaMail.epsvc@epcpadp2>
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
Message-ID: <86a04d4f-bb6f-9bc8-cb64-a50b0ed2fdb7@acm.org>
Date:   Sat, 8 Aug 2020 17:29:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <336371513.41596705485601.JavaMail.epsvc@epcpadp2>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-06 02:15, Daejun Park wrote:
> +	req->end_io_data = (void *)map_req;

Please leave the (void *) cast out since explicit casts from a non-void
to a void pointer are not necessary in C.

> +static inline struct
> +ufshpb_rsp_field *ufshpb_get_hpb_rsp(struct ufshcd_lrb *lrbp)
> +{
> +	return (struct ufshpb_rsp_field *)&lrbp->ucd_rsp_ptr->sr.sense_data_len;
> +}

Please introduce a union in struct utp_cmd_rsp instead of using casts
to reinterpret a part of a data structure.

> +/* routine : isr (ufs) */

The above comment looks very cryptic. Should it perhaps be expanded?

> +struct ufshpb_active_field {
> +	__be16 active_rgn;
> +	__be16 active_srgn;
> +} __packed;

Since "__packed" is not necessary for the above data structure, please
remove it. Note: a typical approach in the Linux kernel to verify that
the compiler has not inserted any padding bytes is to add a BUILD_BUG_ON()
statement in an initialization function that verifies the size of ABI data
structures. See also the output of the following command:

git grep -nH 'BUILD_BUG_ON.sizeof.*!='

> +struct ufshpb_rsp_field {
> +	__be16 sense_data_len;
> +	u8 desc_type;
> +	u8 additional_len;
> +	u8 hpb_type;
> +	u8 reserved;
> +	u8 active_rgn_cnt;
> +	u8 inactive_rgn_cnt;
> +	struct ufshpb_active_field hpb_active_field[2];
> +	__be16 hpb_inactive_field[2];
> +} __packed;

I think the above __packed statement should also be left out.

Thanks,

Bart.
