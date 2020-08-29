Return-Path: <SRS0=Q1Hz=CH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 750CBC433E7
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Aug 2020 22:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CDB320776
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Aug 2020 22:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgH2W6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Aug 2020 18:58:23 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38667 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbgH2W6W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Aug 2020 18:58:22 -0400
Received: by mail-pg1-f193.google.com with SMTP id l191so2238563pgd.5;
        Sat, 29 Aug 2020 15:58:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5kDI73MBKU4UNIZcJDLdLNHA3UpS5PxH/adyOdviNXA=;
        b=qu0OoIY42UPXXcqgKnGUOv35hwM6SMgg5cIOUErxNaj2RsJO/20g+qIpmh6O9ng5B+
         GK4Dw/cytyMOeGurf9YMXNHUwTwVtRGChK3RxDziH8lSY3SSiB4TEmDXqkOssYtwMLeD
         k0LonUsZPFOizcZv9jDsY+iD2gpc6jWmV1+Lo3Vqdown+Ez7TCzvv0O3GVJVps1ZoLYv
         yET3NZ5jf4Vsq0GMQIN/7Df6peYCNmlNmC0cLR/mhYyhArJVF11MexsUxim+MxUJIJG9
         R9O5V20IR7g+ERy1IZnmjcd4RWkYwuZdSOcFCHjJNn589o5QyOIbH//z0OB980mJ+Ap9
         AUTw==
X-Gm-Message-State: AOAM530JExlJGj9z4W52DMMYRRIdBIf9AVMyvN0VvRj0g3dOgKciriP6
        BX8idoZ+ssRpcRBRdg5HLJMYhdEHbTw=
X-Google-Smtp-Source: ABdhPJxGrGbZ/c4NO0wLU0ypl8ZkvfxI/D2WeKg3D6BFh66411AaO/MWQS9Zo+TYW8Pd3wy/MC4KKg==
X-Received: by 2002:aa7:924b:: with SMTP id 11mr4286576pfp.185.1598741900658;
        Sat, 29 Aug 2020 15:58:20 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id y29sm3388963pfp.141.2020.08.29.15.58.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Aug 2020 15:58:19 -0700 (PDT)
Subject: Re: [PATCH v9 2/4] scsi: ufs: Introduce HPB feature
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
References: <963815509.21598598782155.JavaMail.epsvc@epcpadp2>
 <CGME20200828070950epcms2p5470bd43374be18d184dd802da09e73c8@epcms2p2>
 <231786897.01598601302183.JavaMail.epsvc@epcpadp1>
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
Message-ID: <93f1cf18-30da-4482-9a0d-c46d2f70bd15@acm.org>
Date:   Sat, 29 Aug 2020 15:58:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <231786897.01598601302183.JavaMail.epsvc@epcpadp1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-28 00:18, Daejun Park wrote:
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 618b253e5ec8..df30622a2b67 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -588,6 +588,24 @@ struct ufs_hba_variant_params {
>  	u16 hba_enable_delay_us;
>  	u32 wb_flush_threshold;
>  };
> +#ifdef CONFIG_SCSI_UFS_HPB
> +/**
> + * struct ufshpb_dev_info - UFSHPB device related info
> + * @num_lu: the number of user logical unit to check whether all lu finished
> + *          initialization
> + * @rgn_size: device reported HPB region size
> + * @srgn_size: device reported HPB sub-region size
> + * @slave_conf_cnt: counter to check all lu finished initialization
> + * @hpb_disabled: flag to check if HPB is disabled
> + */
> +struct ufshpb_dev_info {
> +	int num_lu;
> +	int rgn_size;
> +	int srgn_size;
> +	atomic_t slave_conf_cnt;
> +	bool hpb_disabled;
> +};
> +#endif

Please insert a blank line above "#ifdef CONFIG_SCSI_UFS_HPB"

> +/* HPB enabled lu list */
> +static LIST_HEAD(lh_hpb_lu);

Is it necessary to maintain this list? Or in other words, is it possible to
change all list_for_each_entry(hpb, &lh_hpb_lu, list_hpb_lu) calls into
shost_for_each_device() calls?

> +/* SYSFS functions */
> +#define ufshpb_sysfs_attr_show_func(__name)				\
> +static ssize_t __name##_show(struct device *dev,			\
> +	struct device_attribute *attr, char *buf)			\
> +{									\
> +	struct scsi_device *sdev = to_scsi_device(dev);			\
> +	struct ufshpb_lu *hpb = sdev->hostdata;				\
> +	if (!hpb)							\
> +		return -ENOENT;						\
> +	return snprintf(buf, PAGE_SIZE, "%d\n",				\
> +			atomic_read(&hpb->stats.__name));		\
> +}									\
> +static DEVICE_ATTR_RO(__name)

Please leave a blank line after declarations (between the "hpb" declaration
and "if (!hpb)").

> +#ifndef CONFIG_SCSI_UFS_HPB
> +[...]
> +static struct attribute *hpb_dev_attrs[] = { NULL,};
> +static struct attribute_group ufs_sysfs_hpb_stat_group = {.attrs = hpb_dev_attrs,};
> +#else
> +[...]
> +extern struct attribute_group ufs_sysfs_hpb_stat_group;
> +#endif

Defining static variables or arrays in header files is questionable because
the definition of these variables will be duplicated in each source file that
header file is included in. Although the general rule for kernel code is to
confine #ifdefs to header files, for ufs_sysfs_hpb_stat_group I think that
it is better to surround its use with #ifndef CONFIG_SCSI_UFS_HPB / #endif
instead of defining a dummy structure as static variable in a header file if
HPB support is disabled.

Otherwise this patch looks good to me.

Thanks,

Bart.
