Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA5DEE4991
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 17:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379220AbjHRR5O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 13:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379336AbjHRR4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 13:56:54 -0400
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840074214;
        Fri, 18 Aug 2023 10:56:52 -0700 (PDT)
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3a7d7de894bso819673b6e.3;
        Fri, 18 Aug 2023 10:56:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692381412; x=1692986212;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yuI8MkzJJoYh9dvd2xid2uOhj8pnHKRXjd43RBRg0rA=;
        b=YRUUy0d97cF3EieH1zBYnulOqjt0CsKF2rXIm82o4FR16NisD7RhgXHmotxszwon8z
         57CGrasuoKfew3m9keBTB4ZS0zDSIFzXiAloZk0QbewZdTw62duZHeYt4bJ2Wzj7lLhf
         83Lp2XT0tfrQkoiR4kCgJqhF/XFWquWR76NNDeWawpQVGNKmmPc7NzXP9jOeC23o3uCx
         ngDpUBrgx6IcOulaZcvbHgSPVERIcOrMwlEHI3sWJPie75YHjS709dWw1T6LfuEaGDg6
         AiUl/o2wokk0Lxs8+jYrv9CpVeGLYHxaks49riXKkE0Q/f+z1QL7RSAfwY4AzWEaFGv/
         Iy9A==
X-Gm-Message-State: AOJu0YxOHQweRRjSnu0FghZjwi9vd3jGBNNuil+6MRUlExo6+zlUba70
        jVkAjJoX/q2VjPLO2hn6qI7HMckwKus=
X-Google-Smtp-Source: AGHT+IG3s71S8mL+h2YgIMAHMOvvnlkeYHbs5HTsCQlY3OPhMzNh2LAEGZwiYZ2jf+LcFR/QsYV4Xg==
X-Received: by 2002:a05:6808:1307:b0:3a4:894a:9f57 with SMTP id y7-20020a056808130700b003a4894a9f57mr4428972oiv.6.1692381411564;
        Fri, 18 Aug 2023 10:56:51 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:5012:5192:47aa:c304? ([2620:15c:211:201:5012:5192:47aa:c304])
        by smtp.gmail.com with ESMTPSA id p8-20020a63ab08000000b005642a68a508sm1858800pgf.35.2023.08.18.10.56.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Aug 2023 10:56:50 -0700 (PDT)
Message-ID: <06d34c2f-a89e-3134-d78f-3c071aa490cf@acm.org>
Date:   Fri, 18 Aug 2023 10:56:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v9 17/17] scsi: ufs: Inform the block layer about write
 ordering
Content-Language: en-US
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-18-bvanassche@acm.org>
 <666c6d78-d975-c9f9-4ad2-c9fa86497b47@quicinc.com>
 <4f332520-329c-6355-3aa3-cd5e29716a06@acm.org>
 <97100392-0c17-e950-1dd4-c52b97aecbe8@quicinc.com>
 <5d8e90b9-34c8-5cab-2653-6f28e68eda94@acm.org>
 <8299025e-e895-8fdb-c62d-80f1d4c9b64c@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8299025e-e895-8fdb-c62d-80f1d4c9b64c@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 17:19, Bao D. Nguyen wrote:
> For example, in SDB mode, after the probe and you want to enable auto-hibern8, you would call ufshcd_auto_hibern8_update() which then calls
> ufshcd_update_preserves_write_order(). Before auto-hibern8 is enabled, you would check this condition:
>      if (blk_queue_is_zoned(q) && !q->elevator)
> 
> In other words, auto-hibern8 is enabled only if the above condition false.
> 
> However, the during a normal operation, the ufshcd_auto_hibern8_update() may not get called at all, and auto-hibern8 can be enabled in SDB mode as part of ufs init. Would that be a problem to have auto-hibern8 enabled without checking whether the above condition is false?

Hi Bao,

Probing the host controller happens as follows:
* The host controller probing function is called, e.g. ufs_qcom_probe().
* ufshcd_alloc_host() and ufshcd_init() are called directly or indirectly
   by the host controller probe function.
* ufshcd_init() calls scsi_add_host() and async_schedule(ufshcd_async_scan, hba).

Once ufshcd_async_scan() is called asynchronously, it performs the
following actions:
* ufs_probe_hba() is called. This function calls ufshcd_link_startup()
   indirectly. That function invokes the link_startup_notify vop if it has
   been defined. Some host drivers set hba->ahit from inside that vop.
* scsi_scan_host() is called and calls scsi_alloc_sdev() indirectly.
* scsi_alloc_sdev() calls blk_mq_init_queue() and shost->hostt->slave_alloc().
* scsi_add_lun() calls sdev->host->hostt->slave_configure().
* scsi_add_lun() calls scsi_sysfs_add_sdev(). This indirectly causes sd_probe()
   to be called asynchronously.
* sd_probe() calls sd_revalidate_disk(). This results in an indirect call of
   disk_set_zoned(). Additionally, the ELEVATOR_F_ZBD_SEQ_WRITE flag is set by
   the sd driver if q->limits.driver_preserves_write_order has not been set.
* Still from inside sd_probe(), device_add_disk() is called and a scheduler
   is selected based on the value of q->required_elevator_features.

There are two ways in which host drivers initialize auto-hibernation:
* Either by setting hba->ahit before ufshcd_init() is called.
* Or by calling ufshcd_auto_hibern8_update() from the link_startup_notify
   vop.

I think the above shows that the zoned model is queried *after* the above methods
for enabling auto-hibernation have completed and hence that blk_queue_is_zoned()
evaluates to false if a host driver calls ufshcd_auto_hibern8_update() from
inside the link_startup_notify vop.

If auto-hibernation is enabled from inside the host driver then that should
happen before sd_probe() is called. sd_probe() will use the value of
q->limits.driver_preserves_write_order that has been set by
ufshcd_slave_configure() so there is no risk for inconsistencies between the
auto-hibernation configuration and the request queue configuration.

Bart.



