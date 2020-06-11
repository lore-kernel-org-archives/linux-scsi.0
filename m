Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C91EC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 01:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 285CC2074B
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 01:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgFKBhY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 21:37:24 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36624 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgFKBhX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 21:37:23 -0400
Received: by mail-pg1-f195.google.com with SMTP id t7so1811080pgt.3;
        Wed, 10 Jun 2020 18:37:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=JvLFQ/Pp9kYuh584xFsBL9APcPBK2H+2UekyjU/1FqE=;
        b=WcJD95bSa1R7aRxUWz+AwIO5g52jUnW5HDjS3Uy7odYA+boSggBQnkSxLeKnhKrt7Z
         R3VFM0JgRBhCd9cpcl+90yhcC2bsJ3pqsrQNQwPjBqyAVdYqo710XBOMMxv3FLMl28JE
         MoUCODTomejVnk26ajQ1BhDV9fLMxmmT4mW4Z/IRBfa/3djlU1ZbszCWEvnpSVZc9da7
         Vqkci/ZtVZyl/5RUYbMAhwU6zdPrX54v0+waN0mvp17MfxHtGi42Ax00G0VgDdHvC42Z
         SnHWRq0G7BV2ahzcxl6eB3+SV13Um+chtgPck8xScq5mYgV9NrjSowFeU5zktHGshreL
         PhcA==
X-Gm-Message-State: AOAM530Rvku4516IJc1ah7mFnEUq19uaJR1y1D2m8RdPbMyqSXwyAPyC
        ocVPXXFnF86IDEx9JpKzCgA=
X-Google-Smtp-Source: ABdhPJzj+fe92903mWOb5clQ1lpl9X+6fAWCf7LUIk8xYHC62+FrSX4ERbSQ/8EVjaxuzEZ7NS258Q==
X-Received: by 2002:a62:5ac5:: with SMTP id o188mr5242642pfb.37.1591839441335;
        Wed, 10 Jun 2020 18:37:21 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id cm13sm891721pjb.5.2020.06.10.18.37.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 18:37:20 -0700 (PDT)
Subject: Re: [RFC PATCH 5/5] scsi: ufs: Prepare HPB read for cached sub-region
To:     daejun7.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
References: <963815509.21591323002276.JavaMail.epsvc@epcpadp1>
 <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
 <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
 <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
 <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
 <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p2>
 <336371513.41591323603173.JavaMail.epsvc@epcpadp1>
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
Message-ID: <bdc420e4-3f2e-cf52-eb42-f85e747b2fb1@acm.org>
Date:   Wed, 10 Jun 2020 18:37:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <336371513.41591323603173.JavaMail.epsvc@epcpadp1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-04 19:12, Daejun Park wrote:
> +static inline bool ufshpb_is_read_cmd(struct scsi_cmnd *cmd)
> +{
> +	if (cmd->cmnd[0] == READ_10 || cmd->cmnd[0] == READ_16)
> +		return true;
> +
> +	return false;
> +}

Has it been considered to check req_op(cmd->request) instead of checking
the SCSI CDB?

> +static inline bool ufshpb_is_write_discard_cmd(struct scsi_cmnd *cmd)
> +{
> +	if (cmd->cmnd[0] == WRITE_10 || cmd->cmnd[0] == WRITE_16 ||
> +	    cmd->cmnd[0] == UNMAP)
> +		return true;
> +
> +	return false;
> +}

Does the above code depend on how the sd driver translates write and
discard requests? Do UFS devices support the WRITE SAME SCSI command?
Has it been considered to check req_op(cmd->request) instead of checking
the SCSI CDB?

> +static inline bool ufshpb_is_support_chunk(int transfer_len)
> +{
> +	return transfer_len <= HPB_MULTI_CHUNK_HIGH;
> +}

The names used in the above function are mysterious. What is a support
chunk? What does "multi chunk high" mean? Please add a comment.

> +static inline u32 ufshpb_get_lpn(struct scsi_cmnd *cmnd)
> +{
> +	return blk_rq_pos(cmnd->request) >>
> +		(ilog2(cmnd->device->sector_size) - 9);
> +}
>
> +static inline unsigned int ufshpb_get_len(struct scsi_cmnd *cmnd)
> +{
> +	return blk_rq_sectors(cmnd->request) >>
> +		(ilog2(cmnd->device->sector_size) - 9);
> +}

Do the above two functions perhaps each include a duplicate of
sectors_to_logical()?

> +/* routine : READ10 -> HPB_READ  */
> +static void ufshpb_prep_fn(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> +{
> +	struct ufshpb_lu *hpb;
> +	struct ufshpb_region *rgn;
> +	struct ufshpb_subregion *srgn;
> +	struct scsi_cmnd *cmd = lrbp->cmd;
> +	u32 lpn;
> +	u64 ppn;
> +	unsigned long flags;
> +	int transfer_len, rgn_idx, srgn_idx, srgn_offset;
> +	int err = 0;
> +
> +	hpb = ufshpb_get_hpb_data(cmd);
> +	err = ufshpb_lu_get(hpb);
> +	if (unlikely(err))
> +		return;
> +
> +	WARN_ON(hpb->lun != cmd->device->lun);
        ^^^^^^^
        WARN_ON_ONCE()?

> +	if (!ufshpb_is_write_discard_cmd(cmd) &&
> +	    !ufshpb_is_read_cmd(cmd))
> +		goto put_hpb;
> +
> +	transfer_len = ufshpb_get_len(cmd);
> +	if (unlikely(!transfer_len))
> +		goto put_hpb;
> +
> +	lpn = ufshpb_get_lpn(cmd);
> +	ufshpb_get_pos_from_lpn(hpb, lpn, &rgn_idx, &srgn_idx, &srgn_offset);
> +	rgn = hpb->rgn_tbl + rgn_idx;
> +	srgn = rgn->srgn_tbl + srgn_idx;
> +
> +	/* If commnad type is WRITE and DISCARD, set bitmap as drity */
              ^^^^^^^               ^^^                        ^^^^^
              command?              or?                        dirty?
> +	if (ufshpb_is_write_discard_cmd(cmd)) {
> +		spin_lock_irqsave(&hpb->hpb_state_lock, flags);
> +		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
> +				 transfer_len);
> +		spin_unlock_irqrestore(&hpb->hpb_state_lock, flags);
> +		goto put_hpb;
> +	}
> +
> +	WARN_ON(!ufshpb_is_read_cmd(cmd));
        ^^^^^^^
        WARN_ON_ONCE()?

> +	if (!ufshpb_is_support_chunk(transfer_len))
> +		goto put_hpb;
> +
> +	spin_lock_irqsave(&hpb->hpb_state_lock, flags);
> +	if (ufshpb_test_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
> +				   transfer_len)) {
> +		atomic_inc(&hpb->stats.miss_cnt);
> +		spin_unlock_irqrestore(&hpb->hpb_state_lock, flags);
> +		goto put_hpb;
> +	}
> +
> +	ppn = ufshpb_get_ppn(hpb, srgn->mctx, srgn_offset, &err);
> +	spin_unlock_irqrestore(&hpb->hpb_state_lock, flags);
> +	if (unlikely(err)) {
> +		/*
> +		 * In this case, the region state is active,
> +		 * but the ppn table is not allocated.
> +		 * Make sure that ppn tabie must be allocated on
                                      ^^^^^
                                      table?
> +		 * active state
> +		 */
> +		WARN_ON(true);
> +		dev_err(&hpb->hpb_lu_dev,
> +			"ufshpb_get_ppn failed. err %d\n", err);
> +		goto put_hpb;
> +	}
> +
> +	ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len);
> +
> +	atomic_inc(&hpb->stats.hit_cnt);
> +put_hpb:
> +	ufshpb_lu_put(hpb);
> +}

Thanks,

Bart.
