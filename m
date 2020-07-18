Return-Path: <SRS0=8IEi=A5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D07C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 20:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE3F920684
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 20:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgGRUaV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 16:30:21 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42788 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgGRUaU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2020 16:30:20 -0400
Received: by mail-pg1-f193.google.com with SMTP id m22so8334179pgv.9
        for <linux-scsi@vger.kernel.org>; Sat, 18 Jul 2020 13:30:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5l1oUi0ded7jPbHH8GCXJFTu8vPnPeAzIYUCobnsvqs=;
        b=mZoYUzfkUjdonIopb4UA9U2gyZoj+PWUx8Lk0tE0mf2fp+KiX9jmkDGy8eRtXA7xA8
         rpPUmHxwABBhcM1qxN8pAY+Xs96EWiD7ISU6XMIQaa42JoSjOFmKBdNxcMkMKg6oDKYo
         Q4wK5dQu0NK4JFczguBUiqb0A5u8qlO7Vc9P5Pm8sy+wrwRQQWJxW4x99r5x19RGzC5/
         Nc8E/IiUXxWbt1LGl7wmyG54RYeKH+17nYEXx6oXLlET3SalgKAAnsWIOLHpkmTn4aAt
         h5DXINhrznbuOFowEmdcB4A49giGtM4GHWBU6qV6b8j0f55Q9VypO8Hh6aJ90yM28Qwi
         VUOg==
X-Gm-Message-State: AOAM5327cWARnZa+iOE63JpnY74jeMo75Ds8FH22xLguXfPVmIjJfmY3
        OlbCvQUFHrVU8g8zQbESj1k=
X-Google-Smtp-Source: ABdhPJyzjQVOhKUUSjdcd02/1zFW1NOggFP5nnVQjLZX/Os2uvKaXG6+uZb6i+AozAQ6naQTv0taKQ==
X-Received: by 2002:a63:338c:: with SMTP id z134mr13163839pgz.245.1595104219317;
        Sat, 18 Jul 2020 13:30:19 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id a2sm11232753pgf.53.2020.07.18.13.30.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 13:30:18 -0700 (PDT)
Subject: Re: [RESEND RFC PATCH v1] scsi: ufs: add retries for SSU
To:     Lee Sang Hyun <sh425.lee@samsung.com>, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        kwmad.kim@samsung.com
References: <CGME20200717074740epcas2p2b1c8e7bf7dc28f13c5a9999373f4601b@epcas2p2.samsung.com>
 <1594971576-40264-1-git-send-email-sh425.lee@samsung.com>
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
Message-ID: <6ac05df5-71ff-e71d-a4df-94118f67caf1@acm.org>
Date:   Sat, 18 Jul 2020 13:30:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594971576-40264-1-git-send-email-sh425.lee@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-17 00:39, Lee Sang Hyun wrote:
> -	ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
> -			START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
> -	if (ret) {
> -		sdev_printk(KERN_WARNING, sdp,
> -			    "START_STOP failed for power mode: %d, result %x\n",
> -			    pwr_mode, ret);
> -		if (driver_byte(ret) == DRIVER_SENSE)
> -			scsi_print_sense_hdr(sdp, NULL, &sshdr);
> +	for (retries = 0; retries < SSU_RETRIES; retries++) {
> +		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
> +				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
> +		if (ret) {
> +			sdev_printk(KERN_WARNING, sdp,
> +				    "START_STOP failed for power mode: %d, result %x\n",
> +				    pwr_mode, ret);
> +			if (driver_byte(ret) == DRIVER_SENSE)
> +				scsi_print_sense_hdr(sdp, NULL, &sshdr);
> +		} else {
> +			break;
> +		}

The ninth argument of scsi_execute() is called 'retries'. Wouldn't it be
better to pass a nonzero value as the 'retries' argument of
scsi_execute() instead of adding a loop around the scsi_execute() call?

Thanks,

Bart.
