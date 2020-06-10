Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D28C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 04:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FF4C207ED
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 04:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgFJEQC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 00:16:02 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45044 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgFJEQC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 00:16:02 -0400
Received: by mail-pl1-f194.google.com with SMTP id bh7so439842plb.11;
        Tue, 09 Jun 2020 21:16:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RqJlNuE+oKm71404ZfCQQBtWLTSA3KmIj1RN+yZNXxs=;
        b=OjK9U0e9Urr1apXajP2jbz8B1039eO94176ll0KaAa1aNDT9871PW5k+ZqUV49Zxmf
         Kg5DWaHx/Xg+FiOZJLeySg4m8SUzY4NWCTI63GiPvy8gvVsx5Bjk6tZ9lsCGTENn4cgc
         xkeJgjxkpaI9zhHkBTuBAMKdF1qElJy+VuyfLbsk2E54vpzCQKGoQyHlLU0o81mPgCLM
         CtiKVYe03BgyAhPNsfpGdBRgmeGMnvaGnhshs0hEF3jA+J6h3IHJhUfMkfRQA4T6MhxK
         1h8Fwh1kcUo++/nOdWotzwXV7BVXBeLiQDVqOMrNXwm1W5ZebwzdHtug////0XVzE7T7
         9HlA==
X-Gm-Message-State: AOAM533o0A6gIwWpDHgZCo2sBzyedRUf+yI+7bvEB7XPDqYsDjq+u7G0
        K64XWGHnSHClKzIZoj0bfiU=
X-Google-Smtp-Source: ABdhPJwjFynqU6qbv9N4e8LJgf0giKNqhBQu1F2J+/XeoSw/unIKLR7cvhQUVBe2sD+HmqdPt5lwog==
X-Received: by 2002:a17:90a:d188:: with SMTP id fu8mr1043148pjb.149.1591762561352;
        Tue, 09 Jun 2020 21:16:01 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id i14sm3844655pju.24.2020.06.09.21.15.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 21:16:00 -0700 (PDT)
Subject: Re: [RFC PATCH 2/5] scsi: ufs: Add UFS-feature layer
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
References: <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
 <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
 <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p1>
 <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
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
Message-ID: <1319810e-a323-c022-5e27-902f88cefe8f@acm.org>
Date:   Tue, 9 Jun 2020 21:15:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-04 18:30, Daejun Park wrote:
> +inline void ufsf_slave_configure(struct ufs_hba *hba,
> +				 struct scsi_device *sdev)
> +{
> +	/* skip well-known LU */
> +	if (sdev->lun >= UFS_UPIU_MAX_UNIT_NUM_ID)
> +		return;
> +
> +	if (!(hba->dev_info.b_ufs_feature_sup & UFS_FEATURE_SUPPORT_HPB_BIT))
> +		return;
> +
> +	atomic_inc(&hba->ufsf.slave_conf_cnt);
> +	smp_mb__after_atomic(); /* for slave_conf_cnt */
> +
> +	/* waiting sdev init.*/
> +	if (waitqueue_active(&hba->ufsf.sdev_wait))
> +		wake_up(&hba->ufsf.sdev_wait);
> +}

Guarding a wake_up() call with a waitqueue_active() check is an
anti-pattern. Please don't do that and call wake_up() directly.
Additionally, wake_up() includes a barrier if it wakes up a kernel
thread so the smp_mb__after_atomic() can be left out if the
waitqueue_active() call is removed.

> +/**
> + * struct ufsf_operation - UFS feature specific callbacks
> + * @prep_fn: called after construct upiu structure
> + * @reset: called after proving hba
                           ^^^^^^^
Is this a typo? Should "proving" perhaps be changed into "probing"?

> +struct ufshpb_driver {
> +	struct device_driver drv;
> +	struct list_head lh_hpb_lu;
> +
> +	struct ufsf_operation ufshpb_ops;
> +
> +	/* memory management */
> +	struct kmem_cache *ufshpb_mctx_cache;
> +	mempool_t *ufshpb_mctx_pool;
> +	mempool_t *ufshpb_page_pool;
> +
> +	struct workqueue_struct *ufshpb_wq;
> +};

Why is a dedicated workqueue needed? Why are the standard workqueues not
good enough?

> @@ -2525,6 +2525,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  
>  	ufshcd_comp_scsi_upiu(hba, lrbp);
>  
> +	ufsf_ops_prep_fn(hba, lrbp);
> +
>  	err = ufshcd_map_sg(hba, lrbp);
>  	if (err) {
>  		lrbp->cmd = NULL;

What happens if a SCSI command is retried and hence ufsf_ops_prep_fn()
is called multiple times for the same SCSI command?

Thanks,

Bart.
