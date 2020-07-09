Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58444C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 15:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40E9320720
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 15:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgGIPjV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:39:21 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52788 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgGIPjU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 11:39:20 -0400
Received: by mail-pj1-f67.google.com with SMTP id gc9so1288527pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 08:39:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c+y8KrA+UCP3CShmyqGCas45iG0VsY2dy2U+ElijnIw=;
        b=huCu6KD6yWO3uaPzVD5PP2dnyuTsTU8ZZaVGmR58vnHDyM/SOWfEQCy6nhZNf0GEcv
         gIN+GRBabkbkLf8TWrKSYaQSKVYKy7vmF07LZ4Kh17sl0k/PiRj0bNLaEbyI/F04h/au
         i1Vwakc+riJO0JE1SLqVZnWJ3vs6nqYvpg4POqfmsQNJtHEUbl4R0AnfzxmjlYxi0bJf
         JRVNiR1lj0/p7wwlXqKLYYsvVU5OSvWSGKZuQAW6nky2/I2kiP34ixBKa3Q5WBXcaB2x
         BbrVPM9d12ow16w6MgmxTvSkq59k5Plr9/Bk3bozWNFpdZ8eUTwW4fIcZMpkO+tAv8U3
         cgQg==
X-Gm-Message-State: AOAM530bNjmceMfc+sdzSI+LBwuOojHtslnX6WKKDV5ICCHzGKhBxbUb
        TshdIJ8qEOaKtw3DKoKSBBaD4/fR
X-Google-Smtp-Source: ABdhPJy4GsuRWkKIIhL11excVp4RWJEYAzRLqSd89kF8SlKsk97qWV5+jQoat4BwiH8GN77vqZyqGQ==
X-Received: by 2002:a17:90a:3684:: with SMTP id t4mr607490pjb.91.1594309159767;
        Thu, 09 Jul 2020 08:39:19 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id nl8sm3303527pjb.13.2020.07.09.08.39.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 08:39:18 -0700 (PDT)
Subject: Re: [RFC PATCH v1] sd: drain a request queue during sd_shutdown()
To:     Lee Sang Hyun <sh425.lee@samsung.com>, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        kwmad.kim@samsung.com
References: <CGME20200709063102epcas2p1e2a624bd881d02b6d3f137f9955eb4b8@epcas2p1.samsung.com>
 <1594275791-20662-1-git-send-email-sh425.lee@samsung.com>
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
Message-ID: <1d902c93-1b4a-0f64-ca96-1989327621ec@acm.org>
Date:   Thu, 9 Jul 2020 08:39:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1594275791-20662-1-git-send-email-sh425.lee@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-08 23:23, Lee Sang Hyun wrote:
> Need to set a request queue like below in sd_shutdown()
> to prevent pending IOs before UFS shutdown.
> 
> Change-Id: I2818cf95944d85baa50b626fcf538f19d06d6d54
> Signed-off-by: Lee Sang Hyun <sh425.lee@samsung.com>
> ---
>  drivers/scsi/sd.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d90feff..7418d27 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3564,6 +3564,8 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>  static void sd_shutdown(struct device *dev)
>  {
>  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> +	struct request_queue *q = sdp->request_queue;
> +	unsigned long flags;
>  
>  	if (!sdkp)
>  		return;         /* this can happen */
> @@ -3580,6 +3582,12 @@ static void sd_shutdown(struct device *dev)
>  		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>  		sd_start_stop_device(sdkp, 0);
>  	}
> +
> +	spin_lock_irqsave(q->queue_lock, flags);
> +	queue_flag_set(QUEUE_FLAG_DYING, q);
> +	__blk_drain_queue(q, true);
> +	queue_flag_set(QUEUE_FLAG_DEAD, q);
> +	spin_unlock_irqrestore(q->queue_lock, flags);
>  }

This patch is unacceptable because:
(a) It introduces a layering violation. The code added in sd_shutdown()
    belongs in the block layer instead of the sd driver.
(b) A description of which problem has been observed and why the sd
    driver is being modified is missing.
(c) An explanation is missing why the blk_cleanup_queue() call in
    __scsi_remove_device() is not sufficient. As you may know
    blk_cleanup_queue() already drains the request queue.
(d) The above patch breaks the kernel build. __blk_drain_queue() was
    removed from the kernel almost two years ago. See also commit
    a1ce35fa4985 ("block: remove dead elevator code") # v5.0.

Bart.
