Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17967C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 16:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F048920814
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 16:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404918AbgE1QMM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 12:12:12 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43931 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404861AbgE1QML (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 12:12:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id g5so2233679pfm.10
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 09:12:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=HIjIS1CEjzB2Td/1CLxAcnyC0Dm8sp2VfJBhxZ1VJNw=;
        b=AFKByfG2UAySkBtx8WOvqE+M6HOEd2XsfR82WodyKbpPTgDxSathXcYxpGMIwyZQnW
         RWIxQNICXnrWtkG6ceI4wzWEXDcVJaHAHnwpojpTUvx3p84GaU9qF9AC9YpdwOMReJbT
         sSB1RwuaNOV/VxUbXVclyylz9/6UdmQy64kOByOzVc5PfOZHiv7NLfYhRCN4dI32HwdJ
         jUoXHQzfteHunCs+9QQ5YNT8as4kPX4gFpzWWvh0Y0eQYLkZ3FxdmFwD1+7Ens/zeOiz
         1hrDCFYRFRXn+tCPqHXgf4X6e5T4Fyds/zbgjamLeYqwOS3Z2w7zza+QQjveCNVT/MUD
         L7jQ==
X-Gm-Message-State: AOAM5311zqaN7m0x5rarpvqhVG9KySYN3CnGMZUsphULMhcbVrSZV7Ei
        BFrP5XqGkDI6hGsMilhEmVA=
X-Google-Smtp-Source: ABdhPJx4dMYXn8sqnRB4Hc7wJyGY+NXSFJwVp5dS2sznTtxXnLLzqInyk8zm2Ij2FrfJPJkf7LTjZw==
X-Received: by 2002:a63:9d0a:: with SMTP id i10mr3620232pgd.209.1590682328776;
        Thu, 28 May 2020 09:12:08 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:40e6:aa88:9c03:e0b4? ([2601:647:4000:d7:40e6:aa88:9c03:e0b4])
        by smtp.gmail.com with ESMTPSA id nl5sm2436681pjb.36.2020.05.28.09.12.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 09:12:07 -0700 (PDT)
Subject: Re: [PATCH 6/6] ufs: Remove the SCSI timeout handler
To:     Can Guo <cang@codeaurora.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191224220248.30138-1-bvanassche@acm.org>
 <20191224220248.30138-7-bvanassche@acm.org>
 <4fe9074323178a0b006f08402dd08b51@codeaurora.org>
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
Message-ID: <1728e2d6-5b00-e71f-5476-b082f4201aa1@acm.org>
Date:   Thu, 28 May 2020 09:12:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <4fe9074323178a0b006f08402dd08b51@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-28 02:47, Can Guo wrote:
> Hi Bart,
> 
> On 2019-12-25 06:02, Bart Van Assche wrote:
>> The UFS SCSI timeout handler was needed to compensate that
>> ufshcd_queuecommand() could return SCSI_MLQUEUE_HOST_BUSY for a long
>> time. Commit a276c19e3e98 ("scsi: ufs: Avoid busy-waiting by eliminating
>> tag conflicts") fixed this so the timeout handler is no longer necessary.
>>
>> See also commit f550c65b543b ("scsi: ufs: implement scsi host timeout
>> handler").
>>
> 
> Sorry for bugging you on this old change. I am afraid we may need to add
> this timeout handler back. Because there is till chances that a request
> gets stuck somewhere in ufshcd_queuecommand() path before
> ufshcd_send_command() gets called. e.g.
> 
> ufshcd_queuecommand()
> ->ufshcd_map_sg()
> -->scsi_dma_map()
> --->dma_map_sg()
> ---->dev->ops->map_sg()
> 
> map_sg() ops may get stuck. map_sg() method can vary on different platforms
> based on actual IOMMU engines. We cannot gaurantee map_sg() ops must return
> immediately as we don't know what is actually inside map_sg() ops.
> 
> And if it gets stuck there for a long time till the request times out,
> without
> the UFS timeout handler, scsi layer will try to abort this request from UFS
> driver by calling ufshcd_abort() eventually. ufshcd_abort() will think this
> request has been completed due to its tag is not in hba->outstanding_reqs
> or UFS host's door bell reg. However, actually, this request is still in
> ufshcd_queuecommand() path. I don't need to continue on the subsequent
> impact
> to UFS driver if ufshcd_abort() happens in this case. This is a corner
> case,
> but it is still possible (I did see map_sg() ops hangs on real devices).
> 
> Having the UFS timeout handler back will prevent this situation as UFS
> timeout
> handler checks if the tag is in hba->outstanding_reqs (for our case, it
> is not
> in there), if no, it returns BLK_EH_RESET_TIMER so that scsi/block layer
> will
> keep waiting.
> 
> What do you think? Please let me know your ideas on this, thanks!

Hi Can,

I see the following issues with the above proposal:
- Although I haven't been able to find explicit documentation of this, I
  think that dma_map_sg() must not sleep. If it would sleep that would
  break most block and SCSI drivers because many of these drivers call
  dma_map_sg() from their .queue_rq() or .queuecommand() implementation
  and if BLK_MQ_F_BLOCKING has not been set these functions must not
  sleep.
- A timeout handler must not be invoked while .queuecommand() is still
  in progress. The SCSI core calls blk_mq_start_request() before it
  calls ufshcd_queuecommand(). The blk_mq_start_request() activates the
  block layer timeout mechanism. ufshcd_queuecommand() must have
  finished before the block layer timeout handler is activated.

Please fix the root cause, namely the map_sg implementation that may get
stuck.

Thanks,

Bart.
