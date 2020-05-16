Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E18C433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 02:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67103206D4
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 02:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgEPCoY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 22:44:24 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35206 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgEPCoY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 22:44:24 -0400
Received: by mail-pl1-f194.google.com with SMTP id q16so1680511plr.2;
        Fri, 15 May 2020 19:44:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pL+AUd0A7OCcde1sHZtLCMWs3WJ63whbQI17iOw+8mU=;
        b=dY4XNLpIleDLbaKMy571EXOYSKIK0Aqw/26TYj591o2dLKWgJfMp9ibJ2teQb3D9bX
         IRZDPH4Tqk3zgLYKp0C6qAmYlJ6k1KHA4bF9KfF2BQ7ElxpfGVGWnmjWE1tVMZ9G7FYy
         ZUvyW1DJOgVXCTQGlj0waKc4vNMRjM2fkMEluRbY21LU1XSlBRBsJOiOmG+xkS3QYsfz
         0dg62OeMVIFGSHqAofv07+VY1Pi5hohXWiJvl0j8GJfXfCVsWubiBbUsQs61ThEGDHfq
         6txGvlgyWTvyI9WlFtkKYPOOWIKAh0nVIWM5vfwVH0PymKgZY85V3NHfF4CxFBP2ptHA
         HjSQ==
X-Gm-Message-State: AOAM533WfwR9RCdvHocbFrpYgU9GZDBuMVETEsc7cMYjWIEzBw32BBHg
        w3qPw5bJ4wzPJgd2SNhe/tg=
X-Google-Smtp-Source: ABdhPJzOl9wD6JC4RziF0YOhf7EXg5TPvtwYouNgCoHf7pXBp28aU4WEOlA+sEEsejtKZmfDMX/fUA==
X-Received: by 2002:a17:90a:a590:: with SMTP id b16mr6811042pjq.177.1589597063216;
        Fri, 15 May 2020 19:44:23 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f99a:ee92:9332:42a? ([2601:647:4000:d7:f99a:ee92:9332:42a])
        by smtp.gmail.com with ESMTPSA id w2sm2512857pja.53.2020.05.15.19.44.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 19:44:22 -0700 (PDT)
Subject: Re: [RFC PATCH 07/13] scsi: scsi_dh: ufshpb: Add ufshpb state machine
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
 <1589538614-24048-8-git-send-email-avri.altman@wdc.com>
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
Message-ID: <5fd7224f-3bbd-863f-ffd4-b049aeeb5456@acm.org>
Date:   Fri, 15 May 2020 19:44:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589538614-24048-8-git-send-email-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-15 03:30, Avri Altman wrote:
> @@ -17,6 +18,13 @@
>  
>  #define UFSHPB_NAME	"ufshpb"
>  
> +#define UFSHPB_WRITE_BUFFER (0xfa)
> +#define WRITE_BUFFER_TIMEOUT (3 * HZ)
> +#define WRITE_BUFFER_RETRIES (3)
> +#define UFSHPB_READ_BUFFER (0xf9)
> +#define READ_BUFFER_TIMEOUT (3 * HZ)
> +#define READ_BUFFER_RETRIES (3)

Parentheses around expressions are normal but parentheses around
constants are unusual. I think the parentheses around constants can be
left out.

> +#define to_subregion() (container_of(work, struct ufshpb_subregion, hpb_work))

Could this have been defined as an inline function?

> @@ -76,6 +118,7 @@ struct ufshpb_subregion {
>   * @writes - sum over subregions @writes
>   * @region - region index
>   * @active_subregions - actual active subregions
> + * @evicted - to indicated if this region is currently being evicted
>   */
>  struct ufshpb_region {
>  	struct ufshpb_subregion *subregion_tbl;
> @@ -85,6 +128,7 @@ struct ufshpb_region {
>  	unsigned int region;
>  
>  	atomic_t active_subregions;
> +	atomic_t evicted;
>  };

Declaring a state variable as atomic_t is unusual. How are changes of
the @evicted member variable serialized?

>  /**
> @@ -93,6 +137,7 @@ struct ufshpb_region {
>   * @lh_map_ctx - list head of mapping context
>   * @map_list_lock - to protect mapping context list operations
>   * @region_tbl - regions/subregions table
> + * @pinned_map - to mark pinned regions
>   * @sdev - scsi device for that lun
>   * @regions_per_lun
>   * @subregions_per_lun - lun size is not guaranteed to be region aligned
> @@ -105,6 +150,7 @@ struct ufshpb_dh_lun {
>  	struct list_head lh_map_ctx;
>  	spinlock_t map_list_lock;
>  	struct ufshpb_region *region_tbl;
> +	unsigned long *pinned_map;
>  	struct scsi_device *sdev;
>  
>  	unsigned int regions_per_lun;
> @@ -113,6 +159,10 @@ struct ufshpb_dh_lun {
>  	unsigned int max_active_regions;
>  
>  	atomic_t active_regions;
> +
> +	struct mutex eviction_lock;
> +
> +	struct workqueue_struct *wq;
>  };

Please document what the eviction_lock protects.

> +static inline void ufshpb_set_write_buf_cmd(unsigned char *cmd,
> +					    unsigned int region)
> +{
> +	cmd[0] = UFSHPB_WRITE_BUFFER;
> +	cmd[1] = 0x01;
> +	put_unaligned_be16(region, &cmd[2]);
> +}

Please follow the example of the sd driver and use the verb "setup"
instead of "set" for functions that initialize a SCSI CDB.

> +static int ufshpb_submit_write_buf_cmd(struct scsi_device *sdev,
> +				       unsigned int region)
> +{
> +	unsigned char cmd[10] = {};
> +	struct scsi_sense_hdr sshdr = {};
> +	u64 flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
> +		    REQ_FAILFAST_DRIVER;
> +	int timeout = WRITE_BUFFER_TIMEOUT;
> +	int cmd_retries = WRITE_BUFFER_RETRIES;
> +	int ret = 0;
> +
> +	ufshpb_set_write_buf_cmd(cmd, region);
> +
> +	ret = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
> +			   timeout, cmd_retries, flags, 0, NULL);
> +
> +	/* HPB spec does not define any error handling */
> +	sdev_printk(KERN_INFO, sdev, "%s: WRITE_BUFFER %s result %d\n",
> +		    UFSHPB_NAME, ret ? "failed" : "succeeded", ret);
> +
> +	return ret;
> +}

I don't think that unconditionally printing the result of the WRITE
BUFFER command is acceptable. How about only reporting failures?

> +static void ufshpb_set_read_buf_cmd(unsigned char *cmd, unsigned int region,
> +				    unsigned int subregion,
> +				    unsigned int alloc_len)
> +{
> +	cmd[0] = UFSHPB_READ_BUFFER;
> +	cmd[1] = 0x01;
> +	put_unaligned_be16(region, &cmd[2]);
> +	put_unaligned_be16(subregion, &cmd[4]);
> +
> +	cmd[6] = alloc_len >> 16;
> +	cmd[7] = (alloc_len >> 8) & 0xff;
> +	cmd[8] = alloc_len & 0xff;
> +	cmd[9] = 0x00;
> +}

Please use put_unaligned_be24() instead of open-coding it.

> +static int ufshpb_subregion_alloc_pages(struct ufshpb_dh_lun *hpb,
> +					struct ufshpb_subregion *s)
> +{
> +	struct ufshpb_map_ctx *mctx;
> +
> +	spin_lock(&hpb->map_list_lock);
> +	mctx = list_first_entry_or_null(&hpb->lh_map_ctx,
> +					struct ufshpb_map_ctx, list);
> +	if (!mctx) {
> +		spin_unlock(&hpb->map_list_lock);
> +		return -EINVAL;
> +	}
> +
> +	list_del_init(&mctx->list);
> +	spin_unlock(&hpb->map_list_lock);
> +
> +	s->mctx = mctx;
> +	mctx->pages = (char *)__get_free_pages(GFP_KERNEL, order);
> +	if (!mctx->pages)
> +		return -ENOMEM;
> +
> +	return 0;
> +}

Relying on higher order pages is not acceptable because memory gets
fragmented easily. See also
https://elinux.org/images/a/a8/Controlling_Linux_Memory_Fragmentation_and_Higher_Order_Allocation_Failure-_Analysis%2C_Observations_and_Results.pdf.

> +	hpb->pinned_map = kcalloc(BITS_TO_LONGS(hpb->regions_per_lun),
> +				  sizeof(unsigned long), GFP_KERNEL);

Is this perhaps an open-coded version of bitmap_alloc()? If so, please
use bitmap_alloc() instead.

> +	snprintf(wq_name, ARRAY_SIZE(wq_name), "ufshpb_wq_%d", sdev->id);
> +	wq = alloc_workqueue(wq_name, WQ_HIGHPRI, WQ_MAX_ACTIVE);
> +	if (!wq) {
> +		ret = -ENOMEM;
> +		goto out_free;
> +	}

What is the purpose of the ufshpb_wq_%d workqueues? Why to allocate
dedicated workqueues instead of using one of the existing system
workqueues? If the scsi_execute() calls would be changed into
asynchronous SCSI command submission, would these workqueues still be
necessary?

Thanks,

Bart.
