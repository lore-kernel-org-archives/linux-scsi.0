Return-Path: <SRS0=n0Yx=CO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397E7C43461
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 19:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F22F72074D
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 19:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgIETdA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 15:33:00 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40642 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgIETc7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 15:32:59 -0400
Received: by mail-pf1-f196.google.com with SMTP id c142so6455462pfb.7
        for <linux-scsi@vger.kernel.org>; Sat, 05 Sep 2020 12:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Ni0DxUDz3xn1jtmFnkaMCDJK5Y3pKWHCWWkcmoNGpDw=;
        b=nX89Rs9UY7jtKJG4Tm44L7/JIMPW1QaH+bY3Uec48iabd5EpNwM1PQ+xhxRfHDpwb0
         ABsNX5XasZMTuodj4OCmvEFMuyaKkyRjKAikIORZjxU65mYBnc1r1DstvXaMKnB+zUf/
         4NpjRVF4QT1YbEquB6L9qORLU44REm9YEK/jumBLdmeoub44Nm6tPsTLSXxBEwiUaEE5
         PQ0P42+KEIQ31dMh3SREpt7v5Bzelbua53PIoPxbiVCuCMNvSNNEYBYmuRHTddtj42JA
         VrU7/o++RpVRSJCmCtiXu8nEVQbpzh1KAu05w+xhFim16NNJH+Z4l5DC5eHN43Sph8DM
         nYdw==
X-Gm-Message-State: AOAM533Z06uU+H19snzP1svRt25nJC2pBtHQRelvaiBaakqWvEYV22QF
        GwdqAW111CGxr2+4tKgAb8c=
X-Google-Smtp-Source: ABdhPJw8VfySYMGGF5mfqVnirp6k4yZdnSZJY/ga+3fITADokWT80vlQwfa2nh0VyQITAgi9Wer9hQ==
X-Received: by 2002:a63:29c6:: with SMTP id p189mr11438608pgp.148.1599334378626;
        Sat, 05 Sep 2020 12:32:58 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:cd46:435a:ac98:84de? ([2601:647:4000:d7:cd46:435a:ac98:84de])
        by smtp.gmail.com with ESMTPSA id i1sm10534437pfk.21.2020.09.05.12.32.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 12:32:57 -0700 (PDT)
Subject: Re: [PATCH 1/4] scsi: sg: fix BLKSECTGET ioctl
To:     Tom Yan <tom.ty89@gmail.com>, linux-scsi@vger.kernel.org,
        dgilbert@interlog.com
Cc:     stern@rowland.harvard.edu, James.Bottomley@SteelEye.com,
        akinobu.mita@gmail.com, hch@lst.de, jens.axboe@oracle.com
References: <CAGnHSE=fY2wkzNeZTSHC37Sp-uD4D8YMEb7LesDkPcQWAfiK=w@mail.gmail.com>
 <20200904200554.168979-1-tom.ty89@gmail.com>
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
Message-ID: <caf0aa91-3e54-f8bd-d818-587f4318716c@acm.org>
Date:   Sat, 5 Sep 2020 12:32:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200904200554.168979-1-tom.ty89@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-04 13:05, Tom Yan wrote:
> It should give out the maximum number of sectors per request
> instead of maximum number of bytes.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> ---
>  drivers/scsi/sg.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 20472aaaf630..e57831910228 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -922,6 +922,7 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
>  	int result, val, read_only;
>  	Sg_request *srp;
>  	unsigned long iflags;
> +	unsigned int max_sectors;
>  
>  	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
>  				   "sg_ioctl: cmd=0x%x\n", (int) cmd_in));
> @@ -1114,8 +1115,9 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
>  		sdp->sgdebug = (char) val;
>  		return 0;
>  	case BLKSECTGET:
> -		return put_user(max_sectors_bytes(sdp->device->request_queue),
> -				ip);
> +		max_sectors = min_t(unsigned int, USHRT_MAX,
> +				    queue_max_sectors(sdp->device->request_queue));
> +		return put_user(max_sectors, ip);
>  	case BLKTRACESETUP:
>  		return blk_trace_setup(sdp->device->request_queue,
>  				       sdp->disk->disk_name,

Is this perhaps a backwards-incompatible change to the kernel ABI, the
kind of change Linus totally disagrees with?

Additionally, please Cc linux-api for patches that modify the kernel ABI.
From https://www.kernel.org/doc/man-pages/linux-api-ml.html: "The kernel
source file Documentation/SubmitChecklist notes that all Linux kernel
patches that change userspace interfaces should be CCed to
linux-api@vger.kernel.org, so that the various parties who are interested
in API changes are informed. For further information, see
https://www.kernel.org/doc/man-pages/linux-api-ml.html"

Thanks,

Bart.


