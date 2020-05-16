Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA834C433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 03:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA25D20758
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 03:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgEPDkL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 23:40:11 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38049 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgEPDkK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 23:40:10 -0400
Received: by mail-pj1-f67.google.com with SMTP id t40so1891487pjb.3;
        Fri, 15 May 2020 20:40:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=iSiunfbFed5LhfPInyZxUADGX4qATzSBG/rUZUGtTEE=;
        b=nN0ZLn3rImiTw/lZWXGSIfVgChDIxrRW3b0g2ON86vC0OiRt+9snl0R8X5Wq488L7v
         4akY/APqs0Uq00qYdQ52g5R338/nNpGOjoQjUkuqM96fuZ25PeMrLw7AEsF5wgrwDrcQ
         O4nBbuzSFTnX8co3pxgloXh64nZrOE7X5iSFmxPEevNfJsc7kqjg3HQ2QOuakEJTekAT
         tSPxx+SBJWr4j7RuC4+Yu/NBPJR52RkPBiVsoZPCSEJjvU4ghgwphe5bjDkzMau7IbDh
         djtlE0JbgZYD6YuycgI7lOU4ZTvNsZjueB44JSbl3jgpGGqYIUFXPe/4ShohiDfQx4g8
         Rc2g==
X-Gm-Message-State: AOAM530YwYeKWj4AE0udzq5wAyAxouPoUYtMc1CGoqksiwR234It21L8
        VGV7MTJHyOcjbHGnN1z0yPM=
X-Google-Smtp-Source: ABdhPJwnDRSlgQpHmsmg6tFxzaanWoSEw9ekvMJ6hzjVoMmI6xLEBpyOOakzKoYFBL/JE8oML59WZA==
X-Received: by 2002:a17:902:ac97:: with SMTP id h23mr6463962plr.89.1589600407846;
        Fri, 15 May 2020 20:40:07 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f99a:ee92:9332:42a? ([2601:647:4000:d7:f99a:ee92:9332:42a])
        by smtp.gmail.com with ESMTPSA id q62sm3168768pfc.132.2020.05.15.20.40.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 20:40:07 -0700 (PDT)
Subject: Re: [RFC PATCH 12/13] scsi: dh: ufshpb: Add prep_fn handler
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
 <1589538614-24048-13-git-send-email-avri.altman@wdc.com>
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
Message-ID: <9433c3b6-ae8d-e14c-12ff-2bde6bdba752@acm.org>
Date:   Fri, 15 May 2020 20:40:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589538614-24048-13-git-send-email-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-15 03:30, Avri Altman wrote:
> diff --git a/drivers/scsi/device_handler/scsi_dh_ufshpb.c b/drivers/scsi/device_handler/scsi_dh_ufshpb.c
> index affc143..04e3d56 100644
> --- a/drivers/scsi/device_handler/scsi_dh_ufshpb.c
> +++ b/drivers/scsi/device_handler/scsi_dh_ufshpb.c
> @@ -15,6 +15,7 @@
>  #include <scsi/scsi_eh.h>
>  #include <scsi/scsi_dh.h>
>  #include <scsi/scsi_dh_ufshpb.h>
> +#include "../sd.h"

Please add a comment that explains why this include directive is necessary.

> +static void __update_read_counters(struct ufshpb_dh_lun *hpb,
> +				   struct ufshpb_region *r,
> +				   struct ufshpb_subregion *s, u64 nr_blocks)
> +{
> +	enum ufshpb_state s_state;
> +
> +	atomic64_add(nr_blocks, &s->reads);
> +	atomic64_add(nr_blocks, &r->reads);
> +
> +	/* normalize read counters if needed */
> +	if (atomic64_read(&r->reads) >= READ_NORMALIZATION * entries_per_region)
> +		queue_work(hpb->wq, &hpb->reads_normalization_work);
> +
> +	rcu_read_lock();
> +	s_state = s->state;
> +	rcu_read_unlock();

We don't use locking in the Linux kernel to read a scalar that can be
read with a single load instruction, even if it can be modified while it
is being read.

> +/* Call this on read from prep_fn */
> +static bool ufshpb_test_block_dirty(struct ufshpb_dh_data *h,
> +				    struct request *rq, u64 start_lba,
> +				    u32 nr_blocks)
> +{
> +	struct ufshpb_dh_lun *hpb = h->hpb;
> +	u64 end_lba = start_lba + nr_blocks;
> +	unsigned int region = ufshpb_lba_to_region(start_lba);
> +	unsigned int subregion = ufshpb_lba_to_subregion(start_lba);
> +	struct ufshpb_region *r = hpb->region_tbl + region;
> +	struct ufshpb_subregion *s = r->subregion_tbl + subregion;
> +	enum ufshpb_state s_state;
> +
> +	__update_rw_counters(hpb, start_lba, end_lba, REQ_OP_READ);
> +
> +	rcu_read_lock();
> +	s_state = s->state;
> +	rcu_read_unlock();
> +
> +	if (s_state != HPB_STATE_ACTIVE)
> +		return true;
> +
> +	return (atomic64_read(&s->writes) >= SET_AS_DIRTY);
> +}

No parentheses around returned values please.

>  /*
>   * ufshpb_dispatch - ufshpb state machine
>   * make the various decisions based on region/subregion state & events
> @@ -631,6 +875,9 @@ static void ufshpb_work_handler(struct work_struct *work)
>  	ufshpb_dispatch(s->hpb, s->r, s);
>  
>  	mutex_unlock(&s->state_lock);
> +
> +	/* the subregion state might has changed */
> +	synchronize_rcu();
>  }

What is the purpose of this synchronize_rcu() call? This is the first
time that I see a synchronize_rcu() call at the end of a work handler.

>  static int ufshpb_activate_pinned_regions(struct ufshpb_dh_data *h, bool init)
> @@ -679,6 +926,12 @@ static int ufshpb_activate_pinned_regions(struct ufshpb_dh_data *h, bool init)
>  		set_bit(start_idx + i, hpb->pinned_map);
>  	}
>  
> +	/*
> +	 * those subregions of the pinned regions changed their state - they
> +	 * are active now
> +	 */
> +	synchronize_rcu();
> +
>  	return ret;
>  }

Same question here: what is the purpose of this synchronize_rcu() call?

> @@ -713,6 +966,9 @@ static void ufshpb_lun_reset_work_handler(struct work_struct *work)
>  		__region_reset(hpb, r);
>  	}
>  
> +	/* update rcu post lun reset */
> +	synchronize_rcu();
> +

Also here: what is the purpose of this synchronize_rcu() call?

> +/*
> + * ufshpb_prep_fn - Construct HPB_READ when possible
> + */
> +static blk_status_t ufshpb_prep_fn(struct scsi_device *sdev, struct request *rq)
> +{
> +	struct ufshpb_dh_data *h = sdev->handler_data;
> +	struct ufshpb_dh_lun *hpb = h->hpb;
> +	u64 lba = sectors_to_logical(sdev, blk_rq_pos(rq));
> +	u32 nr_blocks = sectors_to_logical(sdev, blk_rq_sectors(rq));
> +
> +	if (op_is_write(req_op(rq)) || op_is_discard(req_op(rq))) {
> +		ufshpb_set_block_dirty(h, rq, lba, nr_blocks);
> +		goto out;
> +	}
> +
> +	if (req_op(rq) != REQ_OP_READ || nr_blocks > 255)
> +		goto out;
> +
> +	if (ufshpb_test_block_dirty(h, rq, lba, nr_blocks))
> +		goto out;
> +
> +	ufshpb_prepare_hpb_read_cmd(rq, hpb, lba, (u8)nr_blocks);
> +
> +out:
> +	return BLK_STS_OK;
> +}

So this prep function calls ufshpb_prepare_hpb_read_cmd(), and that
function does the following:

	memcpy(scsi_req(rq)->cmd, cmnd, sizeof(cmnd));

I'm not sure that such a construct would be acceptable in any SCSI LLD
or device handler. The SCSI CDB is overwritten without updating the
other members of the request structure, e.g. the page pointers in the
bvecs of the bio attached to a request structure. What will e.g. happen
if rq_for_each_segment() would be called? Will it iterate over the data
buffer of the original REQ_OP_READ or will it iterate over the data
buffer of the UFSHPB_READ command?

Bart.
