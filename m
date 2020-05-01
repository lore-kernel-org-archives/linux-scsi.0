Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5F7C47253
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 17:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5DEF24954
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 17:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbgEAR4E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 13:56:04 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39360 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729612AbgEAR4E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 13:56:04 -0400
Received: by mail-pl1-f194.google.com with SMTP id s20so3882495plp.6;
        Fri, 01 May 2020 10:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1aqquKGO2wHWbUexSvjMjT6g8z9HBOodi6i/dl3yEfk=;
        b=cQexM/kYFYJpXn6aS1izW2XzHWcS6NIZp3yX/iYwfjesflUlXNwEBP0VzUb6d6cGTC
         npa1SoRQprM5fKyjcHgUbxwMi4fH+oYi4fU9bp3djO4xEDuJdWaq38hZk4Sdp9+eow3G
         ElsbczAfvUhpeVJ+k0XgnaFlrmX6mJ8NxPuGPVJ8Pwo+YwD69MYVaIfTlUplOm5ZEc5T
         lJTNSG6WRmXrUchstmHApfMI11r7h7E/TtS+Oh5vi87Nki1zBG1nV3nxTiE7q73P/iv+
         MScnsYGIksWgIlO2bnuQrTkIZo/cmBjjrU5aLNRZZM43EvvKHwZoKQqi8wQALQTEiLHZ
         XRMA==
X-Gm-Message-State: AGi0PubKu09CnpWV2A5fie44HWOEJRPh1z34uVtKPPF7q+xyRFwyh3AF
        FU0A77zZvq0KVa1AeepTfT0SIaiI5Yc=
X-Google-Smtp-Source: APiQypIT3opjLOUaHJ3jc4/L/Xy850luB3XjovfnMiVpHV7k3y4Xa8smFGSFG2H3Tp3fwi3Jrnu5zA==
X-Received: by 2002:a17:90a:e2c1:: with SMTP id fr1mr910145pjb.124.1588355762840;
        Fri, 01 May 2020 10:56:02 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:81bd:8aa3:a8d:a322? ([2601:647:4000:d7:81bd:8aa3:a8d:a322])
        by smtp.gmail.com with ESMTPSA id kb10sm297454pjb.6.2020.05.01.10.56.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 10:56:01 -0700 (PDT)
Subject: Re: [PATCH v3 1/1] scsi: pm: Balance pm_only counter of request queue
 during system resume
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        stanley.chu@mediatek.com, alim.akhtar@samsung.com,
        beanhuo@micron.com, Avri.Altman@wdc.com,
        bjorn.andersson@linaro.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1588219805-25794-1-git-send-email-cang@codeaurora.org>
 <9e15123e-4315-15cd-3d23-2df6144bd376@acm.org>
 <1ef85ee212bee679f7b2927cbbc79cba@codeaurora.org>
 <ef23a815-118a-52fe-4880-19e7fc4fcd10@acm.org>
 <1e2a2e39dbb3a0f06fe95bbfd66e1648@codeaurora.org>
 <226048f7-6ad3-a625-c2ed-d9d13e096803@acm.org>
 <3bfa692ce706c5c198f565e674afb56f@codeaurora.org>
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
Message-ID: <2356ab42-bbdd-d214-30f5-a533fe978dcb@acm.org>
Date:   Fri, 1 May 2020 10:56:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <3bfa692ce706c5c198f565e674afb56f@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-30 22:12, Can Guo wrote:
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index 3717eea..d18271d 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -74,12 +74,15 @@ static int scsi_dev_type_resume(struct device *dev,
>  {
>         const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>         int err = 0;
> +       bool was_rpm_suspended = false;
> 
>         err = cb(dev, pm);
>         scsi_device_resume(to_scsi_device(dev));
>         dev_dbg(dev, "scsi resume: %d\n", err);
> 
>         if (err == 0) {
> +               was_rpm_suspended = pm_runtime_suspended(dev);
> +

How about renaming this variable into "was_runtime_suspended"? How about
moving the declaration of that variable inside the if-statement?

>                 pm_runtime_disable(dev);
>                 err = pm_runtime_set_active(dev);
>                 pm_runtime_enable(dev);
> @@ -93,8 +96,10 @@ static int scsi_dev_type_resume(struct device *dev,
>                  */
>                 if (!err && scsi_is_sdev_device(dev)) {
>                         struct scsi_device *sdev = to_scsi_device(dev);
> -
> -                       blk_set_runtime_active(sdev->request_queue);
> +                       if (was_rpm_suspended)
> +                              blk_post_runtime_resume(sdev->request_queue, 0);
> +                       else
> +                              blk_set_runtime_active(sdev->request_queue);
>                 }
>         }

Does other code always call both blk_pre_runtime_resume() and
blk_post_runtime_resume() upon runtime resume? How about adding a
blk_pre_runtime_resume() call before the blk_post_runtime_resume() call?

Thanks,

Bart.

