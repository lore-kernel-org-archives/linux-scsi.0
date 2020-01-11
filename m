Return-Path: <SRS0=vbb9=3A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E4EC33CA8
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 22:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9A6720882
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 22:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731619AbgAKWnA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jan 2020 17:43:00 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44979 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731594AbgAKWnA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jan 2020 17:43:00 -0500
Received: by mail-pg1-f196.google.com with SMTP id x7so2778329pgl.11;
        Sat, 11 Jan 2020 14:43:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=JZbps7b/CAXQ/B9mFq94QfGwpN3OGq2H5UovsYGxvCc=;
        b=D+q1/Bb0K80tnvIjVGSw8bk3UiklSz3+vrMSydQsyzzUtS6Y/X5IBSdYA/7oo1oJd2
         xbFxlVaOZLcHY/JlY0dW9WEiKVjYAFRqGdY7N8XiuZlQBAKMTbwmQ6hu09SI9UiP/f8D
         h0hayl1rnzxz9ZQpG5gxozlflP7HjBkqNE5H/XsNSoGKAzxEj8e3m4tz3jKIVaQxNXKw
         XdozoC+OWi1tR1ustbExtbeUOar57UDWp9XSV7ew3+wW8e4Vynu9acEM//xtc91sd9yA
         z927CDRA31QVqL3ws9VMztsH/LbG/GOkJU14kaPLvh4wWsdWBm/lYsMIl+fn/Izl+0ap
         VLkQ==
X-Gm-Message-State: APjAAAUYKa01gjHexIhURG0qBc6sqF/3pJRPrJucCnlaezNnHv6XgUj3
        FjowBY4NxITSGZvdt7blT83JskqX
X-Google-Smtp-Source: APXvYqzflOHLPOobQtpN/GH6ZrWZqmSYZTLEgI8sqe8xo4pDFHOfuPXNBQYCtLp07h4k0uVBpe1Qeg==
X-Received: by 2002:a63:213:: with SMTP id 19mr13565019pgc.160.1578782579382;
        Sat, 11 Jan 2020 14:42:59 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:7c72:26f5:20:bf58? ([2601:647:4000:d7:7c72:26f5:20:bf58])
        by smtp.gmail.com with ESMTPSA id r14sm7840412pfh.10.2020.01.11.14.42.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2020 14:42:58 -0800 (PST)
Subject: Re: [PATCH 2/3] scsi: ufs: initialize max_lu_supported while booting
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, pedrom.sousa@synopsys.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200110183606.10102-1-huobean@gmail.com>
 <20200110183606.10102-3-huobean@gmail.com>
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
Message-ID: <95d093b6-591c-1f16-befe-3d192d7c0e2d@acm.org>
Date:   Sat, 11 Jan 2020 14:42:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200110183606.10102-3-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-10 10:36, Bean Huo wrote:
> +static int ufshcd_read_geometry_desc(struct ufs_hba *hba, u8 *buf, u32 size)
> +{
> +	return ufshcd_read_desc(hba, QUERY_DESC_IDN_GEOMETRY, 0, buf, size);
> +}

The declaration of this function is longer than its body. Do we really
need this function? Has it been considered to inline this function into
its caller?

> +static int ufshcd_init_device_param(struct ufs_hba *hba)
> +{
> +	int err;
> +	size_t buff_len;
> +	u8 *desc_buf;
> +
> +	buff_len = QUERY_DESC_MAX_SIZE;
> +	desc_buf = kmalloc(buff_len, GFP_KERNEL);
> +	if (!desc_buf) {
> +		err = -ENOMEM;
> +		goto out;
> +	}

Has it been considered to use hba->desc_size.geom_desc instead of
QUERY_DESC_MAX_SIZE?

> +	err = ufshcd_read_geometry_desc(hba, desc_buf,
> +			hba->desc_size.geom_desc);
> +	if (err) {
> +		dev_err(hba->dev, "%s: Failed reading Geometry Desc. err = %d\n",
> +			__func__, err);
> +		goto out;
> +	}
> +
> +	if (desc_buf[GEOMETRY_DESC_PARAM_MAX_NUM_LUN] == 1)
> +		hba->dev_info.max_lu_supported = 32;
> +	else if (desc_buf[GEOMETRY_DESC_PARAM_MAX_NUM_LUN] == 0)
> +		hba->dev_info.max_lu_supported = 8;

Can it happen that GEOMETRY_DESC_PARAM_MAX_NUM_LUN >=
hba->desc_size.geom_desc and hence that the above code reads
uninitialized data?

> @@ -7016,13 +7052,22 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>  
>  	/*
>  	 * If we are in error handling context or in power management callbacks
> -	 * context, no need to scan the host
> +	 * context, no need to scan the host and to reinitialize the parameters
>  	 */
>  	if (!ufshcd_eh_in_progress(hba) && !hba->pm_op_in_progress) {
>  		bool flag;
>  
>  		/* clear any previous UFS device information */
>  		memset(&hba->dev_info, 0, sizeof(hba->dev_info));
> +		/* Init parameters according to UFS relevant descriptors */
> +		ret = ufshcd_init_device_param(hba);
> +		if (ret) {
> +			dev_err(hba->dev,
> +				"%s: Init of device param failed. err = %d\n",
> +				__func__, ret);
> +			goto out;
> +		}
> +
>  		if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
>  				QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
>  			hba->dev_info.f_power_on_wp_en = flag;

The context check in ufshcd_probe_hba() looks ugly to me. Has it been
considered to move all code that is controlled by the if-statement with
the context check into ufshcd_async_scan()?

Thanks,

Bart.


