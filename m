Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C0DC33CB6
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 04:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40F7620728
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 04:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbgAQECW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 23:02:22 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46727 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729130AbgAQECW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 23:02:22 -0500
Received: by mail-pl1-f196.google.com with SMTP id y8so9282175pll.13;
        Thu, 16 Jan 2020 20:02:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=iZLHewdiazY8g29gXR8XVb0QIOZ1/vZnvJEkR0A8Ghc=;
        b=PMQXEGEESNybgAMU2DWPiTUvpw6T7hZBN7omG91ZZ37csw0dWJga++ezXmU9PQ2OIo
         8LHKNhtxawXL4Nx5MABiILR04voy7E2fkQvStpWLnhT6P7XJpkJcUnZ19IKoycDRCRWL
         0gqKD3yPPD1KwiGqEHn2GsHQV7MlLE4zqImtsXJ4n2dKD8DqMpbppV17huzqwdmhzBcF
         G/AUtdYEPvYFeIyxQPnd0rlm/AR4bIp5VDjtF8oeHJQt93O4Wvx5RMb05rHxi/hKAi+a
         WS2yHmWXW85vufdOU+pC37HA423DyJ3mkFIpAEwLC8k1KbacWMMjr3/UfK0n/2OIGbod
         OuzA==
X-Gm-Message-State: APjAAAWbtYJyOeVR9cZS9y0/yikfIVXKGh04wZQMqthWOytb4Qrayszd
        tYGc9nShGaALlAYYGS4D75SYIxL7NX4=
X-Google-Smtp-Source: APXvYqxayaXfvR3peMmx3z+a8M/X5c/6qvfRnpe/y5JQq/mAz1SSjB/0WlXgfP1jlqyC3SZuS0m42Q==
X-Received: by 2002:a17:90a:22a5:: with SMTP id s34mr3383674pjc.8.1579233741640;
        Thu, 16 Jan 2020 20:02:21 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:8dfb:7edd:e01b:b201? ([2601:647:4000:d7:8dfb:7edd:e01b:b201])
        by smtp.gmail.com with ESMTPSA id r8sm2896564pjo.22.2020.01.16.20.02.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 20:02:20 -0800 (PST)
Subject: Re: [PATCH v2 7/9] scsi: ufs: Add max_lu_supported in struct
 ufs_dev_info
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200116215914.16015-1-huobean@gmail.com>
 <20200116215914.16015-8-huobean@gmail.com>
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
Message-ID: <3332e2a9-f720-4127-af57-afb6cccef9a2@acm.org>
Date:   Thu, 16 Jan 2020 20:02:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200116215914.16015-8-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-16 13:59, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Add one new parameter max_lu_supported in struct ufs_dev_info,
> which will be used to express exactly how many general LUs being
> supported by UFS device.
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufs.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index fcc9b4d4e56f..c982bcc94662 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -530,6 +530,8 @@ struct ufs_dev_info {
>  	bool f_power_on_wp_en;
>  	/* Keeps information if any of the LU is power on write protected */
>  	bool is_lu_power_on_wp;
> +	/* Maximum number of general LU supported by the UFS device */
> +	u8 max_lu_supported;
>  	u16 wmanufacturerid;
>  	/*UFS device Product Name */
>  	u8 *model;

There is a strong tradition in the Linux kernel community of introducing
structure members in the same patch that introduces the first user of
such a structure member. I think patch 8/9 is the first patch that uses
this structure member. Please consider combining patches 7/9 and 8/9
into a single patch.

Thanks,

Bart.


