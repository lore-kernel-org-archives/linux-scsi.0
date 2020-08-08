Return-Path: <SRS0=ejtk=BS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE075C433E0
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Aug 2020 23:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2B91206B5
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Aug 2020 23:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgHHXAW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Aug 2020 19:00:22 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35551 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgHHXAW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2020 19:00:22 -0400
Received: by mail-pj1-f68.google.com with SMTP id t6so2845133pjr.0;
        Sat, 08 Aug 2020 16:00:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=03s0FrguY+5Vsw5VcUN9hRTd+zm+8TlvlWIEd814HQA=;
        b=jDuY4fCSEWSXhrCCZsIAceb+ZjKs2VlVYFXjuEGnMIoiAOQIlITfuGeBYCh+fzfmFB
         Bxq4kVZjzEU9wHWzXyUiUDEeEVLdJQ/fK8f8oxX0pOpdhybjqb9abF720i2XFUsj/GRV
         t+cPv9xo0F7lvdOlziU+F2HofnbBPRJzMBswFbTtCfPUu0fWUTHU7CniFroeu8sfD8dq
         PDjnSKlAE6OdnYc6Qt8SDu2tJ9N/NrQLBIldOLQyAfMkfuv5OhKHwc85U3v81SqSTsbO
         8oXQHtN2O8Yb+FRXykR9MMwyn7sOL+8QBkJdVXvxvo9LheLK352K0IorHqAC2SFGN6M/
         lpWA==
X-Gm-Message-State: AOAM531FywZkdPT3C93Vge9YHbBpW0Lc+XL5Kp15UKumIw8hF92bJfDS
        i4XameItQHQn2tkeYEoyV5k=
X-Google-Smtp-Source: ABdhPJwbpBTfg2/oaWQvHBKZvsf3ofbIA43CMdwToZX9yxA8hK4yDqzAFXPE9qWHYhgJNDNbN/gOWw==
X-Received: by 2002:a17:90b:a45:: with SMTP id gw5mr19388020pjb.80.1596927621388;
        Sat, 08 Aug 2020 16:00:21 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n18sm15064408pgd.91.2020.08.08.16.00.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2020 16:00:20 -0700 (PDT)
Subject: Re: [PATCH v8 1/4] scsi: ufs: Add UFS feature related parameter
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
References: <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
 <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p6>
 <231786897.01596705001840.JavaMail.epsvc@epcpadp1>
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
Message-ID: <adb044b2-67e0-b451-332c-37789ded99f9@acm.org>
Date:   Sat, 8 Aug 2020 16:00:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <231786897.01596705001840.JavaMail.epsvc@epcpadp1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-06 02:02, Daejun Park wrote:
> @@ -537,6 +548,7 @@ struct ufs_dev_info {
>  	u8 *model;
>  	u16 wspecversion;
>  	u32 clk_gating_wait_us;
> +	u8 b_ufs_feature_sup;
>  	u32 d_ext_ufs_feature_sup;
>  	u8 b_wb_buffer_type;
>  	u32 d_wb_alloc_units;
> 

Hmm ... shouldn't this variable be introduced in the patch that introduces
the code that sets and uses this variable?

How about making it clear in the patch subject that this patch adds protocol
constants related to HPB?

Otherwise this patch looks good to me.

Bart.
