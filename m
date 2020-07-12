Return-Path: <SRS0=csMy=AX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527EAC433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 03:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38B212076D
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 03:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgGLDVV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jul 2020 23:21:21 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:37981 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgGLDVV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2020 23:21:21 -0400
Received: by mail-pj1-f68.google.com with SMTP id k5so4538803pjg.3;
        Sat, 11 Jul 2020 20:21:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/xlF8D0YRhQkJt0cwXY5nQaiVavowdpy7MweO/IsN48=;
        b=i/+cYjrtV3PSXd9nRA3f0h6yZAK1CQcFc9qyy9zZ0u1fX2rSq08JRJMezBRHPvlM5q
         s2VzSFiKCIbsQetZk6vkGcXDEUQrpG3Kx5yQ/7KZmQAM2088wkN0uMuyhzZ0wdEFfCMG
         wmpOxQScGdeLdmUvC69ulAOsOBLWTyuh+whmtvuSymD9slrKwBzXdt0Z+rUz+ifqZy10
         khPjUJAv6PVkmPyKv6RR3OojPAlqKjjmk6yS8wDdxLz5g082bVRoXYhgYNb72k3mkIra
         vFP6MWxmP1rWFqhscbr1bZUvxSfkSur2LKuqguyhZzJdZ2v5+F/q9T/QqYoZT++ho0jq
         9P5g==
X-Gm-Message-State: AOAM53175e0U9aBWrtSx1HMshnGgzVGd2Abkc/JTZRW2G/opjVWZ6E45
        CgqPRw42/yth0DDhqjEbcP3RPEU0
X-Google-Smtp-Source: ABdhPJzXmEbUDGyIuGAaVXGgQaDU4PJB2eOJ5b7IxTqEBZ4e+uzIDi437EURznXXRWI60suwSG0TMg==
X-Received: by 2002:a17:90a:db0b:: with SMTP id g11mr13404424pjv.11.1594524080197;
        Sat, 11 Jul 2020 20:21:20 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id z26sm10462649pfr.187.2020.07.11.20.21.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 20:21:19 -0700 (PDT)
Subject: Re: [RFC PATCH v3] scsi: ufs: Quiesce all scsi devices before
 shutdown
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, asutoshd@codeaurora.org, cang@codeaurora.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com
References: <20200706132218.21171-1-stanley.chu@mediatek.com>
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
Message-ID: <2465978d-28d3-e30f-248e-87333c789743@acm.org>
Date:   Sat, 11 Jul 2020 20:21:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200706132218.21171-1-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-06 06:22, Stanley Chu wrote:
> +static void ufshcd_cleanup_queue(struct scsi_device *sdev, void *data)
> +{
> +	if (sdev->request_queue)
> +		blk_cleanup_queue(sdev->request_queue);
> +}

No SCSI LLD should ever call blk_cleanup_queue() directly for
sdev->request_queue. Only the SCSI core should call blk_cleanup_queue()
directly for that queue.

>  int ufshcd_shutdown(struct ufs_hba *hba)
>  {
>  	int ret = 0;
> +	struct scsi_target *starget;
>  
>  	if (!hba->is_powered)
>  		goto out;
> @@ -8612,7 +8632,25 @@ int ufshcd_shutdown(struct ufs_hba *hba)
>  			goto out;
>  	}
>  
> +	/*
> +	 * Quiesce all SCSI devices to prevent any non-PM requests sending
> +	 * from block layer during and after shutdown.
> +	 *
> +	 * Here we can not use blk_cleanup_queue() since PM requests
> +	 * (with BLK_MQ_REQ_PREEMPT flag) are still required to be sent
> +	 * through block layer. Therefore SCSI command queued after the
> +	 * scsi_target_quiesce() call returned will block until
> +	 * blk_cleanup_queue() is called.
> +	 *
> +	 * Besides, scsi_target_"un"quiesce (e.g., scsi_target_resume) can
> +	 * be ignored since shutdown is one-way flow.
> +	 */
> +	ufshcd_scsi_for_each_sdev(ufshcd_quiece_sdev);
> +
>  	ret = ufshcd_suspend(hba, UFS_SHUTDOWN_PM);
> +
> +	/* Set queue as dying to not block queueing commands */
> +	ufshcd_scsi_for_each_sdev(ufshcd_cleanup_queue);
>  out:
>  	if (ret)
>  		dev_err(hba->dev, "%s failed, err %d\n", __func__, ret);
> 

What is the purpose of ufshcd_shutdown()? Why does this function exist?
How about removing the calls to ufshcd_shutdown() and invoking power down
code from inside sd_suspend_common() instead?

Thanks,

Bart.
