Return-Path: <SRS0=xzXz=2F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA29DC2D0CE
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 21:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 792832467B
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 21:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfLOVzp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Dec 2019 16:55:45 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34590 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbfLOVzo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Dec 2019 16:55:44 -0500
Received: by mail-pf1-f193.google.com with SMTP id l127so2716845pfl.1;
        Sun, 15 Dec 2019 13:55:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=W0zPH2/BqhFasq2P2pWi0vzcKpg+nZm2Y/FTYzm0w8k=;
        b=Eguhfrapgw1EZX4syAkpmFWN20OZU25uxVQynwTR9fnRZKUR511EurYzdr4ZCsDZLf
         tPA7kwze7YheOAmIVCcSm8kl+m7Dc6Fp0bhw0BgS6o7R+nKhZXRr0mEqzwPewnUdZLGG
         tQ6zZS9hazvIlnl7AP2g03K01N7lXikbWC/6mFXiDof5RrB/0hZ4Sph1IG46ds+OjJ3K
         C8+pbm7qV7XVON9ztL63vaZldlGz5kCT85Rom7YHjz4re/TAe+5swCFf5kmXYvD1ABCn
         doNZVPb9MNEJwdFuZ1l/yKa7RRbQT0dbslJUHv+xf3/14yQkr7Y6x3fFfumY3SbVdXWx
         UqLQ==
X-Gm-Message-State: APjAAAW+FrrHwp0Q0zhE86GFbWxsN883/w4A1fsjPcIlRIvziWKyD2kv
        R/gU+olIyvZP1/2Tp9wvBVo0XBhGTO8=
X-Google-Smtp-Source: APXvYqy8cwzox8ErpEH04JNFrlQPTauKbTKfLbKdGI14vASw3zCR+/Q6lSm8kqt+yCEPU2DR7dc2eA==
X-Received: by 2002:a65:5a4d:: with SMTP id z13mr14231624pgs.21.1576446943533;
        Sun, 15 Dec 2019 13:55:43 -0800 (PST)
Received: from ?IPv6:2601:647:4000:110a:d014:2a0a:ea98:f50e? ([2601:647:4000:110a:d014:2a0a:ea98:f50e])
        by smtp.gmail.com with ESMTPSA id x33sm18752908pga.86.2019.12.15.13.55.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Dec 2019 13:55:42 -0800 (PST)
Subject: Re: [PATCH 1/2] scsi: ufs: Put SCSI host after remove it
To:     cang@codeaurora.org
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1576328616-30404-1-git-send-email-cang@codeaurora.org>
 <1576328616-30404-2-git-send-email-cang@codeaurora.org>
 <85475247-efd5-732e-ae74-6d9a11e1bdf2@acm.org>
 <5aa3a266e3db3403e663b36ddfdc4d60@codeaurora.org>
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
Message-ID: <2956b9c7-b019-e2b3-7a1b-7b796b724add@acm.org>
Date:   Sun, 15 Dec 2019 13:55:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5aa3a266e3db3403e663b36ddfdc4d60@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-14 14:24, cang@codeaurora.org wrote:
> How do you think if I replace my patch with below one?
> In this way, you can also move blk_cleanup_queue() behind
> cancel_work_sync(eh_work).
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b5966fa..bd4ae75 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8251,15 +8251,17 @@ void ufshcd_remove(struct ufs_hba *hba)
>         ufs_bsg_remove(hba);
>         ufs_sysfs_remove_nodes(hba->dev);
>         scsi_remove_host(hba->host);
> -       /* disable interrupts */
> -       ufshcd_disable_intr(hba, hba->intr_mask);
> -       ufshcd_hba_stop(hba, true);
> -
>         ufshcd_exit_clk_scaling(hba);
>         ufshcd_exit_clk_gating(hba);
>         if (ufshcd_is_clkscaling_supported(hba))
>                 device_remove_file(hba->dev,
> &hba->clk_scaling.enable_attr);
> +       cancel_work_sync(&hba->eeh_work);
> +       cancel_work_sync(&hba->eh_work);
> +       /* disable interrupts */
> +       ufshcd_disable_intr(hba, hba->intr_mask);
> +       ufshcd_hba_stop(hba, true);
>         ufshcd_hba_exit(hba);
> +       ufshcd_dealloc_host(hba);
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_remove);

Hi Can,

To which kernel tree does the above patch apply? I'm asking this because
I don't see the recently added blk_cleanup_queue() calls in the above
patch. Please start from Martin's latest scsi-queue branch when
preparing SCSI patches.

Additionally, is it on purpose that there is no scsi_host_put() call in
the above code? I'd like to keep that call because without that call a
memory leak will occur when unloading the ufshcd-core kernel driver.

Thanks,

Bart.


