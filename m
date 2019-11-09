Return-Path: <SRS0=dDgG=ZB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1492C17441
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 03:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D17CE215EA
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 03:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfKIDCa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 22:02:30 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40349 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfKIDC3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 22:02:29 -0500
Received: by mail-pl1-f193.google.com with SMTP id e3so5140062plt.7;
        Fri, 08 Nov 2019 19:02:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q9w9/CL3tvrcZwNSUDDdOh70mNMnFLTdHmVRbGH/fsQ=;
        b=RhkDx30JD54fYQo9hP8I2p1pTObKb63mZVBQBWqpUxZUL/9hzxk97nBljGD0tAAAN3
         2jKcOpyi71U7i0KEh6INLZ73cCGICF1H7Fb+M6GWNZ4LE8RFulhX8R1Tn0zODqLC6b6n
         b9OujTqi7eTHKE3f22ftHVEzmvez3PIhyhke4IR9A+dLN3OVtR0Fbo9KOrbD9YAeByTe
         aPcJ3YOXeaMRVD/dAK9zLSDIv9/3b9jC5hiiKw8uVpsz1dIN1ZOPNLgq5xqcsFQuL6lE
         exe6I+dmMJVOJC3yUhPQNFhGoh5oabAs2czDm3CQv4aSagmE8QQmecdTfcE3D8k7F1ew
         QAJg==
X-Gm-Message-State: APjAAAUKgBIOSh+tv9mb8I+dgwmtPc6YoN0yNMKbgGNmhWZ+SzkNAkiL
        64fXCaPQiInkr0niho7A+t0=
X-Google-Smtp-Source: APXvYqznA2/Hflt4r+QC31lnQ7K+Dgy87EIN0nH4QqGDSy7xTZp2MWCmVVsOPoz64ej9OUuavrLuaw==
X-Received: by 2002:a17:902:b482:: with SMTP id y2mr5337175plr.128.1573268548891;
        Fri, 08 Nov 2019 19:02:28 -0800 (PST)
Received: from localhost.localdomain ([2601:647:4000:a8:64c1:7f03:d411:a61])
        by smtp.gmail.com with ESMTPSA id d8sm6983723pfo.47.2019.11.08.19.02.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2019 19:02:28 -0800 (PST)
Subject: Re: [dm-devel] [PATCH 8/9] scsi: sd_zbc: Cleanup
 sd_zbc_alloc_report_buffer()
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
 <20191108015702.233102-9-damien.lemoal@wdc.com>
 <6a1e0a08-d65c-b075-9bac-23519e9e91c3@acm.org>
 <BYAPR04MB5816C442BE08F9973C2CDF15E77A0@BYAPR04MB5816.namprd04.prod.outlook.com>
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
Message-ID: <639eae70-bb57-0c49-0ae9-aed8d33df271@acm.org>
Date:   Fri, 8 Nov 2019 19:02:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5816C442BE08F9973C2CDF15E77A0@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-08 18:54, Damien Le Moal wrote:
> On 2019/11/09 4:06, Bart Van Assche wrote:
>> On 11/7/19 5:57 PM, Damien Le Moal wrote:
>>> -	buf = vzalloc(bufsize);
>>> -	if (buf)
>>> -		*buflen = bufsize;
>>> +	while (bufsize >= SECTOR_SIZE) {
>>> +		buf = vzalloc(bufsize);
>>> +		if (buf) {
>>> +			*buflen = bufsize;
>>> +			return buf;
>>> +		}
>>> +		bufsize >>= 1;
>>> +	}
>>
>> Hi Damien,
>>
>> Has it been considered to pass the __GFP_NORETRY flag to this vzalloc() 
>> call?
> 
> Do you mean using
> 
> __vmalloc(bufsize,
> 	  GFP_KERNEL | __GFP_ZERO | __GFP_NORETRY, PAGE_KERNEL);
> 
> instead of vzalloc() ? (since we cannot pass GFP flags to vzalloc()...)
> 
> Note that this is called with GFP_NOIO set for the caller context in the
> case of revalidate zones, and default to GFP_KERNEL for
> blkdev_report_zones() unless the caller also tweaks the context memalloc
> flags.

Hi Damien,

Yes, that's what I meant. The following comment from mm/util.c explains
why __GFP_RETRY should be used if it is OK for an allocation to fail:

/*
 * We want to attempt a large physically contiguous block first because
 * it is less likely to fragment multiple larger blocks and therefore
 * contribute to a long term fragmentation less than vmalloc fallback.
 * However make sure that larger requests are not too disruptive - no
 * OOM killer and no allocation failure warnings as we have a fallback.
 */

Thanks,

Bart.
