Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E57BC33CAF
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 19:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 340B9206B7
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 19:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgASTgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 14:36:20 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38744 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbgASTgU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2020 14:36:20 -0500
Received: by mail-pf1-f193.google.com with SMTP id x185so14678667pfc.5
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jan 2020 11:36:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=SzNS8Sfc9xhwTWlvA1n3EuNN/8i20MFOYEn4FJAOPac=;
        b=K3FYF0SAhWHicm/DsY8Cht2ybhS1Fqw7AdteFKu039IL5mj7H0LPO4zw59Q1mrLN+S
         e6m5Xo+LPaj/kAEnVuiNMhVr8e8IP2gR35U2xJ3aKyZOytgmMJ0FKNjMxikVAn2v9lNy
         BthlvQB1BGxaTniFD7j7E3zeIbKLwojicyRZsKhwJjzWgYD3opU429/lNkzYGTkO2K0l
         EpYpKqmvu3X8End9lVphQ24bN4hER95+S22q+DqIZqY9BJXINq0aj5g9e04+BcZu0f2+
         DzkIoXPTteAOaRegV2tidApKerRD9qZhCi1tgucPf91WS4EEIsRu44Qzy9s2QGqATX4X
         BfHg==
X-Gm-Message-State: APjAAAXUaDUtDLQ9v22x0njgxSkdeJ4u0Lug3H2QcAYByQi90dGvy1iJ
        Ww+4KDgm2maUUGMbYd3838M=
X-Google-Smtp-Source: APXvYqzCKW3uxMTqyr5n78HZoTYHIifqfAKuCl9db0ccmTJQ1YoqDI3jpK2WZ9Jvv1Gb2eSMfD1Hjg==
X-Received: by 2002:a63:5807:: with SMTP id m7mr52589251pgb.83.1579462579986;
        Sun, 19 Jan 2020 11:36:19 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:781f:ca33:6085:f83a? ([2601:647:4000:d7:781f:ca33:6085:f83a])
        by smtp.gmail.com with ESMTPSA id y6sm35182249pgc.10.2020.01.19.11.36.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 11:36:18 -0800 (PST)
Subject: Re: [PATCH] scsi: sd: provide a new module parameter to set whether
 SCSI disks support WRITE_SAME_16 by default
To:     AlexChen <alex.chen@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, zhengchuan@huawei.com,
        jiangyiwen@huawei.com, robin.yb@huawei.com
References: <5E246413.8010408@huawei.com>
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
Message-ID: <c3c8c949-b557-1e34-5143-7a0b348a609e@acm.org>
Date:   Sun, 19 Jan 2020 11:36:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <5E246413.8010408@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-19 06:13, AlexChen wrote:
> When the SCSI device is initialized, check whether it supports
> WRITE_SAME_16 or WRITE_SAME_10 in the sd_read_write_same(). If
> the back-end storage device does not support queries, it will not set
> sdkp->ws16 as 1.
> 
> When the WRITE_SAME io is issued through the blkdev_issue_write_same(),
> the WRITE_SAME type is set to WRITE_SAME_10 by default in the
> sd_setup_write_same_cmnd() since of "sdkp->ws16=0". If the storage device
> does not support WRITE_SAME_10, then the SCSI device is set to not support
> WRITE_SAME.
> 
> Currently, some storage devices do not provide queries for
> WRITE_SAME_16/WRITE_SAME_10 support, but they do support WRITE_SAME_16 and
> do not support WRITE_SAME_10. So in order for these devices to use
> WRITE_SAME, we need a new module parameter to set whether SCSI disks
> support WRITE_SAME_16 by default.
> 
> Signed-off-by: AlexChen <alex.chen@huawei.com>
> ---
>  drivers/scsi/sd.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 4f7e7b607..ff368701d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -104,6 +104,9 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
>  #define SD_MINORS	0
>  #endif
> 
> +static int sd_default_support_ws16;
> +module_param(sd_default_support_ws16, int, 0644);
> +
>  static void sd_config_discard(struct scsi_disk *, unsigned int);
>  static void sd_config_write_same(struct scsi_disk *);
>  static int  sd_revalidate_disk(struct gendisk *);
> @@ -3014,7 +3017,8 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
>  			sdev->no_write_same = 1;
>  	}
> 
> -	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1)
> +	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1 ||
> +			sd_default_support_ws16)
>  		sdkp->ws16 = 1;
> 
>  	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME) == 1)

Should this be fixed using the quirk mechanism instead of introducing a
new kernel module parameter? Kernel module parameters apply to all SCSI
disk devices irrespective of their vendor and model. The quirk mechanism
can be used to introduce special behavior for certain disk models and
types. See also the output of the following grep command:

$ git grep -nH '& BLIST'

Bart.

