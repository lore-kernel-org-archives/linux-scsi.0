Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28906C4724C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 01:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 148D020A8B
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 01:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgEHBE7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 21:04:59 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37105 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgEHBE7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 21:04:59 -0400
Received: by mail-pf1-f196.google.com with SMTP id d184so46481pfd.4;
        Thu, 07 May 2020 18:04:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=CdVlUxwo7cu5JapJM3IpDqoWtOxvT8VHoCz6wz28+XI=;
        b=l7yFqXsQ0acUmfUPzH1he53oxyb1A6+IzDk+0VBKpfKW+kF7XuCJxk7aJ6n+KPAikd
         hAVqd7BegdP4U4s0cvxfWsWCAXTwZZTlfiuLdaSC0XuspO+MNEsdBCs981KT1SVP2Wzv
         M6HA3A73Yrl5SKwPW7ufEKM3r1S3traPoJ/Wh7DoO8MMHa73EMpjHzQmZN6Ny+Jpc0/X
         ohFMIxrb+kGM4XgtPGBFjXRo9xQzV9wSKnt2vSQsJoYFT5btClJhFbMMEfywkW+97V3m
         27t2CP3wLiOkY3fNW7j03VYhj0D68c1M2nZKZUBLi5YEcfEZ3jqAG7YGCI6uk9F/FRjI
         AEtQ==
X-Gm-Message-State: AGi0PuYFygy4hyNIdpMvPf3OHO+fHbV3wwhIX0DsQSJkqbXlBlOC0pyX
        Xu2Af8VZqGUhS5P0p7z4pCB+KZGcMB9HpA==
X-Google-Smtp-Source: APiQypJiYpC1G8QSxybe2/A3iqBuFjhixWz2/8rlSTdqp7+99ROvhCzpRIjLIlRAX9Xa8EB+H4G57g==
X-Received: by 2002:a62:7cca:: with SMTP id x193mr126058pfc.96.1588899897004;
        Thu, 07 May 2020 18:04:57 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:8ce8:d4c:1f4f:21e0? ([2601:647:4000:d7:8ce8:d4c:1f4f:21e0])
        by smtp.gmail.com with ESMTPSA id w2sm6022957pfc.194.2020.05.07.18.04.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 18:04:56 -0700 (PDT)
Subject: Re: [RESENT PATCH RFC v3 4/5] scsi: ufs: add unit and geometry
 parameters for HPB
To:     huobean@gmail.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org,
        rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
References: <20200504142032.16619-1-beanhuo@micron.com>
 <20200504142032.16619-5-beanhuo@micron.com>
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
Message-ID: <c398bc0c-c87c-3260-471d-85f0d10cf917@acm.org>
Date:   Thu, 7 May 2020 18:04:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504142032.16619-5-beanhuo@micron.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-04 07:20, huobean@gmail.com wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Add HPB related parameters introduced in Unit Descriptor and
> Geometry Descriptor.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufs.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 1f2d4b4950b8..6210e489d2ce 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -219,6 +219,9 @@ enum unit_desc_param {
>  	UNIT_DESC_PARAM_PHY_MEM_RSRC_CNT	= 0x18,
>  	UNIT_DESC_PARAM_CTX_CAPABILITIES	= 0x20,
>  	UNIT_DESC_PARAM_LARGE_UNIT_SIZE_M1	= 0x22,
> +	UNIT_DESC_PARAM_HPB_MAX_ACTIVE_REGIONS	= 0x23,
> +	UNIT_DESC_PARAM_HPB_PIN_REGION_START_OFFSET	= 0x25,
> +	UNIT_DESC_PARAM_HPB_NUM_PIN_REGIONS             = 0x27,
>  };
>  
>  /* Device descriptor parameters offsets in bytes*/
> @@ -304,6 +307,10 @@ enum geometry_desc_param {
>  	GEOMETRY_DESC_PARAM_ENM4_MAX_NUM_UNITS	= 0x3E,
>  	GEOMETRY_DESC_PARAM_ENM4_CAP_ADJ_FCTR	= 0x42,
>  	GEOMETRY_DESC_PARAM_OPT_LOG_BLK_SIZE	= 0x44,
> +	GEOMETRY_DESC_PARAM_HPB_REGION_SIZE	= 0x48,
> +	GEOMETRY_DESC_PARAM_HPB_NUMBER_LU	= 0x49,
> +	GEOMETRY_DESC_PARAM_HPB_SUBREGION_SIZE  = 0x4A,
> +	GEOMETRY_DESC_PARAM_HPB_MAX_ACTIVE_REGIONS = 0x4B,
>  };

How about adding the names from the spec as a comment above the new
constants, e.g. as follows?

	/* wHPBPinnedRegionStartIdx */
	UNIT_DESC_PARAM_HPB_PIN_REGION_START_OFFSET = 0x25,

Thanks,

Bart.
