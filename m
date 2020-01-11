Return-Path: <SRS0=vbb9=3A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FCABC33CA7
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 22:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 295EB2084D
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 22:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731620AbgAKWuV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jan 2020 17:50:21 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45686 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731610AbgAKWuV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jan 2020 17:50:21 -0500
Received: by mail-pl1-f195.google.com with SMTP id b22so2275768pls.12;
        Sat, 11 Jan 2020 14:50:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1Y+eakPpLPu3QpHBaVl40IWgpXF2l/AUF3kqpcxzchk=;
        b=oMu7K7YZpxVwP/ckYBEDYqxAgT+8dS6kHsrpuW17ez1UBhJnf8rF6//ANjTDRrDwhY
         r2U1tXNG88C+XodsDWICX3F1m1uSXOpbt2WvKxHr8Yin4d/CigLGCbbB9oSfGgJrYr+Q
         pkyWmlNqKMwY36k9zPSZ8l9JAhB304xmgIojZsLAe3iqH8G4TduxLfDBDdTWx9KGkhUd
         esz2pSLGz1ONJQW/Je7sdD7NonBw5yXeLZGdr0vvtsseFfml4F2IBPsyshcnwlOSBWor
         XaPjkDL5TX4EtIKJMOq+D3brWmprhqeBc4q5HvrYrrBnxYVCE1fTFjOvrcP2I5OYXKrm
         1iyw==
X-Gm-Message-State: APjAAAWNu4CvfiQyVKdusfmM9+y7Y0VW2BPI+mnvsLpn3G5m+45kAyuE
        UMkSSZ/jZHHUjUNqv81CK/bst6/R
X-Google-Smtp-Source: APXvYqzEUV0kN51ktgkt703j8Uthv6pVQHOwe2ELZNieFA4afv9fNsA3xtF7FC7Ne19z3STzWvJRMg==
X-Received: by 2002:a17:902:968b:: with SMTP id n11mr12109209plp.120.1578783019935;
        Sat, 11 Jan 2020 14:50:19 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:7c72:26f5:20:bf58? ([2601:647:4000:d7:7c72:26f5:20:bf58])
        by smtp.gmail.com with ESMTPSA id d3sm7419410pjx.16.2020.01.11.14.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2020 14:50:19 -0800 (PST)
Subject: Re: [PATCH 3/3] scsi: ufs: use UFS device indicated maximum LU number
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, pedrom.sousa@synopsys.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200110183606.10102-1-huobean@gmail.com>
 <20200110183606.10102-4-huobean@gmail.com>
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
Message-ID: <9f26bde7-0c78-c56c-4f15-5bf2dba71506@acm.org>
Date:   Sat, 11 Jan 2020 14:50:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200110183606.10102-4-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-10 10:36, Bean Huo wrote:
> @@ -548,12 +547,19 @@ struct ufs_dev_desc {
>  
>  /**
>   * ufs_is_valid_unit_desc_lun - checks if the given LUN has a unit descriptor
> + * @dev_info: pointer of instance of struct ufs_dev_info
>   * @lun: LU number to check
>   * @return: true if the lun has a matching unit descriptor, false otherwise
>   */
> -static inline bool ufs_is_valid_unit_desc_lun(u8 lun)
> +static inline bool ufs_is_valid_unit_desc_lun(struct ufs_dev_info *dev_info,
> +		u8 lun)
>  {

Can the dev_info be declared 'const' (const truct ufs_dev_info *dev_info)?

> -	return lun == UFS_UPIU_RPMB_WLUN || (lun < UFS_UPIU_MAX_GENERAL_LUN);
> +	if (!dev_info || !dev_info->max_lu_supported) {
> +		pr_err("Max General LU supported by UFS isn't initilized\n");
                                                              ^^^^^^^^^^
                                                            initialized?
> +		return false;
> +	}
> +
> +	return lun == UFS_UPIU_RPMB_WLUN || (lun < dev_info->max_lu_supported);
>  }

Are the parentheses in the above expression necessary?

Thanks,

Bart.
