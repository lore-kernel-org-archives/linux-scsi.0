Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E9DC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 01:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00BF8206C3
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 01:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgF2Bg3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 21:36:29 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:38617 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgF2Bg3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 21:36:29 -0400
Received: by mail-pj1-f68.google.com with SMTP id d6so7305513pjs.3;
        Sun, 28 Jun 2020 18:36:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=s4x1Od24FXLrarpF97nRPGvbMk3D5kp3VfdEZSEmDhw=;
        b=p8sUSbMCdb+dAckjgIHn0PSamNBXz+CWb996fZ8BMckQKBGAly16RpEO45p29CecKX
         N51FLwyyRodzJdbnWt4SZlcsv/Vxq+WjI3T90Mop35uE5YqQ0GJ5p6sq7ssOOz1W85fj
         ZUeBGNdoWYMiDQnc5DOaKgUBY9NYlGNI8/75rjtsfNHqAeS4mwS8zVGj/+woZw1lNhcA
         CigSb5MqkbxhB9Wk1mTST6SLEHp/E9gjBGmqA9nPbUH63Dzk86g4PBvB1WQoTdoXZQBa
         5Dm+bckrb/iDxHUVyU012SB8CMoSD686240LmIGJoWkRVZUfOxHVeoDDp5hbp2Pb6E6e
         fGAw==
X-Gm-Message-State: AOAM532ZOvOWavjzvW+Wbm4fD6fjGq12FPH9GwK7n/MhZ5oCyMYXcbQu
        Q+QM+YyKk8148kr7GWjUDXI=
X-Google-Smtp-Source: ABdhPJz7xUgN970SnEgTAeV9FLe4mfvopgGs1JOIp0QPQ6aC2kw6RkTdzy4i7BI5V2xGik2Bz3QRBA==
X-Received: by 2002:a17:902:6181:: with SMTP id u1mr11517203plj.205.1593394588106;
        Sun, 28 Jun 2020 18:36:28 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id z1sm27702053pgk.89.2020.06.28.18.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 18:36:27 -0700 (PDT)
Subject: Re: [PATCH 2/2] block: add BLKSETDESCZONE ioctl for Zoned Block
 Devices
To:     =?UTF-8?Q?Matias_Bj=c3=b8rling?= <matias.bjorling@wdc.com>,
        axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, damien.lemoal@wdc.com,
        niklas.cassel@wdc.com, hans.holmberg@wdc.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
References: <20200628230102.26990-1-matias.bjorling@wdc.com>
 <20200628230102.26990-3-matias.bjorling@wdc.com>
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
Message-ID: <cbb91e7d-5cc8-eeb7-5219-b712545cb5c4@acm.org>
Date:   Sun, 28 Jun 2020 18:36:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200628230102.26990-3-matias.bjorling@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-28 16:01, Matias Bjørling wrote:
> +	/* This may take a while, so be nice to others */
> +	cond_resched();
> +
> +	return submit_bio_wait(&bio);

A cond_resched() call before a submit_bio_wait() call? I think it's the
first time that I see this. Is that call really necessary? Isn't the
wait_for_completion() call inside submit_bio_wait() sufficient?

> +	/* no flags is currently supported */
                    ^^
                    are?

> +	/* allocate the size of the zone descriptor extension and fill
> +	 * with the data in the user data buffer. If the data size is less
> +	 * than the zone descriptor extension size, then the rest of the
> +	 * zone description extension data buffer is zero-filled.
> +	 */
> +	zsd_data = (void *) get_zeroed_page(GFP_KERNEL);
> +	if (!zsd_data)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(zsd_data, argp + sizeof(struct blk_zone_set_desc),
> +			   zsd.len)) {
> +		ret = -EFAULT;
> +		goto free;
> +	}

Has it been considered to use kmalloc() instead of get_zeroed_page()?

> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index ccb895f911b1..53b7b05b0004 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -316,6 +316,8 @@ enum req_opf {
>  	REQ_OP_ZONE_FINISH	= 12,
>  	/* write data at the current zone write pointer */
>  	REQ_OP_ZONE_APPEND	= 13,
> +	/* associate zone desc extension data to a zone */
> +	REQ_OP_ZONE_SET_DESC	= 14,
>  
>  	/* SCSI passthrough using struct scsi_request */
>  	REQ_OP_SCSI_IN		= 32,

Does REQ_OP_ZONE_SET_DESC count as a read or as a write operation? See also:

static inline bool op_is_write(unsigned int op)
{
	return (op & 1);
}

> +/**
> + * struct blk_zone_set_desc - BLKSETDESCZONE ioctl requests
> + * @sector: Starting sector of the zone to operate on.
> + * @flags: Feature flags.
> + * @len: size, in bytes, of the data to be associated to the zone.
> + * @data: data to be associated.
> + */
> +struct blk_zone_set_desc {
> +	__u64		sector;
> +	__u32		flags;
> +	__u32		len;
> +	__u8		data[0];
> +};

Isn't the recommended style to use a flexible array ([] instead of [0])?
See also https://lore.kernel.org/lkml/20200608213711.GA22271@embeddedor/.

Thanks,

Bart.
