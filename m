Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3758C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 01:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E01C207BB
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 01:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgEPB5H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 21:57:07 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42985 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgEPB5G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 21:57:06 -0400
Received: by mail-pl1-f195.google.com with SMTP id k19so1637224pll.9;
        Fri, 15 May 2020 18:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=8gIG7Ro5+GZfq1WU05K668cQDKxs4qudc7VUCmlsKwU=;
        b=e/kqwFRIV5J2fDqtHT5vlR1x3gY3yBREqS9ANCqz6kNjHx7FpjZ00cMh1NapBhP03E
         oI5ARNtNDy/3DZqg8OWWEzLUoDOlWG1p4bpe8fe0amVSaJJV2HXYid/tcATcZ9e7Q56i
         X4zDzX8a9EmFNdoNcMkvkED7gWDtfhAIQ1OXqtzytCC0OoMaYKXKxkqeRLvru7ToCqF5
         qTQ1WGuqkhCvo7MxBS09f8Fm6MpUVF8hPbotvi7QsnQe+9OWSS0G3YEvjllD1xTLpCYR
         IURM/hV3yo1hvQkxidpNBbIOD6ZEI8ivjx1fZvRmjyNqDjfKl2szxSRkFOU4jRVLXZaF
         v3iQ==
X-Gm-Message-State: AOAM530FjSnh/sHnhgRxNmpMWpmWOEzHIxvgRPtBNegnlv4LAekU0Evk
        FCEUkvGjlVGv9qTLPKF7PbQ=
X-Google-Smtp-Source: ABdhPJwXgeQgYl+efgQSdKq9LG3uhQeRf6+rf76aGNer+6j4wVnSXIWBDX7lMCBNbQQxyz4xWsSG8A==
X-Received: by 2002:a17:90a:77c4:: with SMTP id e4mr3510473pjs.223.1589594225691;
        Fri, 15 May 2020 18:57:05 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f99a:ee92:9332:42a? ([2601:647:4000:d7:f99a:ee92:9332:42a])
        by smtp.gmail.com with ESMTPSA id b140sm2819106pfb.119.2020.05.15.18.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 18:57:04 -0700 (PDT)
Subject: Re: [RFC PATCH 02/13] scsi: ufshpb: Init part I - Read HPB config
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
 <1589538614-24048-3-git-send-email-avri.altman@wdc.com>
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
Message-ID: <eca7c95b-3b11-561e-d3a4-b62d5b08dd30@acm.org>
Date:   Fri, 15 May 2020 18:57:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589538614-24048-3-git-send-email-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-15 03:30, Avri Altman wrote:
> +struct ufshpb_lun_config *ufshpb_luns_conf;
> +struct ufshpb_lun *ufshpb_luns;
> +static unsigned long ufshpb_lun_map[BITS_TO_LONGS(UFSHPB_MAX_LUNS)];
> +static u8 ufshpb_lun_lookup[UFSHPB_MAX_LUNS];
> +
> +/**
> + * ufshpb_remove - ufshpb cleanup
> + *
> + * Should be called when unloading the driver.
> + */
> +void ufshpb_remove(struct ufs_hba *hba)
> +{
> +	kfree(ufshpb_conf);
> +	kfree(ufshpb_luns_conf);
> +	kfree(ufshpb_luns);
> +	ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_SET_FLAG,
> +			  QUERY_FLAG_IDN_HPB_RESET, 0, NULL);
> +}
> +
> +static int ufshpb_hpb_init(void)
> +{
> +	u8 num_hpb_luns = ufshpb_conf->num_hpb_luns;
> +	int i;
> +
> +	ufshpb_luns = kcalloc(num_hpb_luns, sizeof(*ufshpb_luns), GFP_KERNEL);
> +	if (!ufshpb_luns)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < num_hpb_luns; i++) {
> +		struct ufshpb_lun *hpb = ufshpb_luns + i;
> +
> +		hpb->lun = (ufshpb_luns_conf + i)->lun;
> +	}
> +
> +	return 0;
> +}

Do the ufshpb_lun... data structures perhaps duplicate SCSI core data
structures? If so, please don't introduce duplicates of SCSI core data
structures.

Thanks,

Bart.
