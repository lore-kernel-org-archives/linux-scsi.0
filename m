Return-Path: <SRS0=uhQV=4K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6C1C35641
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 02:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22AD0206D7
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 02:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgBVCkV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 21:40:21 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:32826 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbgBVCkV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2020 21:40:21 -0500
Received: by mail-pf1-f176.google.com with SMTP id n7so2272387pfn.0
        for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2020 18:40:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5GfUZ5+xFFUc8swffX9Wu3QPinfKFzgnfzYfREcsOK0=;
        b=pF1N5JiUJmIkv/BAVtC3TA3t5m0YI8kf2tutIsDD84vkqNTrLRfNr0XQwiMUIImR3r
         j2nWlVtJrkF6RzYH8o3t+S6lw5XBxa3Y75S/WOglVaYHPWivhvNu9CSEf7vsg1a6nYSk
         cUoX7z1xUJexM2SELT2yliAL79vERq8/ewijw+5EtDv95Cmr/ZjM1nVFpuPUf4usNp37
         VIIbAWFLwZvKU9dJiu9G04ArhEJVEeyXxCWPvC+3syQ9exV7nKsrKj73EX27WtpcOu1Q
         y/olvXYq9y3rCKLWZBDimNjO8sUEk9tYJDMwsH9PN6/bXtTLqidRSCWRUkBj8opB3ogi
         u9hA==
X-Gm-Message-State: APjAAAUCfXk6pTwr/QSN6mfYL3yR0TQUrdYUOGqgBYTi86n8Cf7WOCRS
        +uSbi/MbDa/VaUzo14TO5bhsRV8b7Lc=
X-Google-Smtp-Source: APXvYqz4bXgK87izp29JJQJIoXo6ZbrnXOXZ5sIJdi51jKRs/X0xRCrU1736WuPMb3wQ4qd3nAeA8Q==
X-Received: by 2002:a63:5508:: with SMTP id j8mr40113227pgb.170.1582339219909;
        Fri, 21 Feb 2020 18:40:19 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:89d3:733:bb73:c1a4? ([2601:647:4000:d7:89d3:733:bb73:c1a4])
        by smtp.gmail.com with ESMTPSA id s130sm4391758pfc.62.2020.02.21.18.40.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 18:40:18 -0800 (PST)
Subject: Re: [<RFC PATCH v1> 1/2] scsi: ufs: add write booster feature support
To:     Asutosh Das <asutoshd@codeaurora.org>, asutoshd@qti.qualcomm.com,
        linux-scsi@vger.kernel.org
References: <cover.1582330473.git.asutoshd@codeaurora.org>
 <0eb182e6731bc4ce0c1d6a97f102155d7186520f.1582330473.git.asutoshd@codeaurora.org>
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
Message-ID: <a5a45551-8852-a8de-3ea5-f7cf761c7a15@acm.org>
Date:   Fri, 21 Feb 2020 18:40:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <0eb182e6731bc4ce0c1d6a97f102155d7186520f.1582330473.git.asutoshd@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-21 16:38, Asutosh Das wrote:
> @@ -371,6 +379,12 @@ UFS_GEOMETRY_DESC_PARAM(enh4_memory_max_alloc_units,
>  	_ENM4_MAX_NUM_UNITS, 4);
>  UFS_GEOMETRY_DESC_PARAM(enh4_memory_capacity_adjustment_factor,
>  	_ENM4_CAP_ADJ_FCTR, 2);
> +UFS_GEOMETRY_DESC_PARAM(wb_max_alloc_units, _WB_MAX_ALLOC_UNITS, 4);
> +UFS_GEOMETRY_DESC_PARAM(wb_max_wb_luns, _WB_MAX_WB_LUNS, 1);
> +UFS_GEOMETRY_DESC_PARAM(wb_buff_cap_adj, _WB_BUFF_CAP_ADJ, 1);
> +UFS_GEOMETRY_DESC_PARAM(wb_sup_red_type, _WB_SUP_RED_TYPE, 1);
> +UFS_GEOMETRY_DESC_PARAM(wb_sup_wb_type, _WB_SUP_WB_TYPE, 1);
> +
>  
>  static struct attribute *ufs_sysfs_geometry_descriptor[] = {

This patch converts a bunch of single blank lines into double blank
lines. Are such changes useful?

> +	/* Enable WB only for UFS-3.1 OR if desc len >= 0x59 */
> +	if (dev_info->wspecversion >= 0x310) {
> +		hba->dev_info.d_ext_ufs_feature_sup =
> +			desc_buf[DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP]
> +								<< 24 |
> +			desc_buf[DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 1]
> +								<< 16 |
> +			desc_buf[DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 2]
> +								<< 8 |
> +			desc_buf[DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 3];

Please use get_unaligned_be32() instead of open-coding it.

> +			res = wb_buf[0] << 24 | wb_buf[1] << 16 |
> +				wb_buf[2] << 8 | wb_buf[3];

Same comment here.

Thanks,

Bart.
