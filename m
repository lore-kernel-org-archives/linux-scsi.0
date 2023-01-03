Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C5CC46467
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Jan 2023 00:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbjACA3d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Jan 2023 19:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjACA3b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jan 2023 19:29:31 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529801014
        for <linux-scsi@vger.kernel.org>; Mon,  2 Jan 2023 16:29:30 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id p24so8462434plw.11
        for <linux-scsi@vger.kernel.org>; Mon, 02 Jan 2023 16:29:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/MnITQApAqGQU0QBeGTJ/eq1/ZzbivYJ6b2oO8a28Ng=;
        b=Iy3GtnG2QcwZJpYSzkWtl30obJFwjf5oSTaIgbGMXiHLVCpMHs5MRJrVZ1mEL6VZhb
         Jvyb4k8pOHr3h3EUSOUSgmgxOOK4DGLKzNf+UHY5EgnpbcxHUdm85u3LCbQKhEZ//5dJ
         OfbaT5y2Ksq/onvoKa+eg1lWF5sltCFHTXONsdardo+ldGyL5pDLgeNDa90fJiYP8ROP
         CrzGRzp6BFb1zfJm2kmV6Fx1Cian0OdLq94TqQRJmZGkuTmaYvWkcTm9e8oD1C3w1ZeX
         qd3GodLa9ZR7UZRcnBwd43Te3qSD6vvRVjyZucgkdFuFjXfzdL0pQKCj/LoU45/Vff9F
         YVeQ==
X-Gm-Message-State: AFqh2kqLfn0BIgWw5aei+zvNTvH42Sce8gLbjrhSdXoxw4q2wgrgu68Z
        6xBUJoQ4C+9e2VVJ85njqEw=
X-Google-Smtp-Source: AMrXdXtqfub/hBM0Uw1eKDREL7qYr9jb50OAT5j+Dudh7sJ5HdcFhy0szSnXcAt0K2XEEtznLuhLvg==
X-Received: by 2002:a17:90b:601:b0:20d:bd5f:ced2 with SMTP id gb1-20020a17090b060100b0020dbd5fced2mr46820362pjb.34.1672705769653;
        Mon, 02 Jan 2023 16:29:29 -0800 (PST)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id nk7-20020a17090b194700b00225d7c0dc14sm15185653pjb.28.2023.01.02.16.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jan 2023 16:29:28 -0800 (PST)
Message-ID: <9d142dc5-6a31-3f79-69c8-9967e833a671@acm.org>
Date:   Mon, 2 Jan 2023 16:29:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3] ufs: core: wlun resume SSU(Acitve) fail recovery
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com
References: <20221228060157.24852-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221228060157.24852-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/27/22 22:01, peter.wang@mediatek.com wrote:
> When wlun resume SSU(Active) timeout, scsi try eh_host_reset_handler.
                    ^^^^^^^^^^^
Please use the same spelling in the patch subject (Acitve -> Active).

timeout -> times out
scsi try -> the SCSI core invokes

> But ufshcd_eh_host_reset_handler hang at wait flush_work(&hba->eh_work).

hang at -> hangs in

> And ufshcd_err_handler hang at wait rpm resume.

hang at wait rpm resume -> hangs in rpm_resume().

 > <ffffffdd78e02b34> schedule+0x110/0x204
 > <ffffffdd78e0be60> schedule_timeout+0x98/0x138
 > <ffffffdd78e040e8> wait_for_common_io+0x130/0x2d0
 > <ffffffdd77d6a000> blk_execute_rq+0x10c/0x16c
 > <ffffffdd78126d90> __scsi_execute+0xfc/0x278
 > <ffffffdd7813891c> ufshcd_set_dev_pwr_mode+0x1c8/0x40c
 > <ffffffdd78137d1c> __ufshcd_wl_resume+0xf0/0x5cc
 > <ffffffdd78137ae0> ufshcd_wl_runtime_resume+0x40/0x18c
 > <ffffffdd78136108> scsi_runtime_resume+0x88/0x104
 > <ffffffdd7809a4f8> __rpm_callback+0x1a0/0xaec
 > <ffffffdd7809b624> rpm_resume+0x7e0/0xcd0
 > <ffffffdd7809a788> __rpm_callback+0x430/0xaec
 > <ffffffdd7809b644> rpm_resume+0x800/0xcd0
 > <ffffffdd780a0778> pm_runtime_work+0x148/0x198
 >
 > <ffffffdd78e02b34> schedule+0x110/0x204
 > <ffffffdd78e0be10> schedule_timeout+0x48/0x138
 > <ffffffdd78e03d9c> wait_for_common+0x144/0x2dc
 > <ffffffdd7758bba4> __flush_work+0x3d0/0x508
 > <ffffffdd7815572c> ufshcd_eh_host_reset_handler+0x134/0x3a8
 > <ffffffdd781216f4> scsi_try_host_reset+0x54/0x204
 > <ffffffdd78120594> scsi_eh_ready_devs+0xb30/0xd48
 > <ffffffdd7812373c> scsi_error_handler+0x260/0x874
 >
 > <ffffffdd78e02b34> schedule+0x110/0x204
 > <ffffffdd7809af64> rpm_resume+0x120/0xcd0
 > <ffffffdd7809fde8> __pm_runtime_resume+0xa0/0x17c
 > <ffffffdd7815193c> ufshcd_err_handling_prepare+0x40/0x430
 > <ffffffdd7814cce8> ufshcd_err_handler+0x1c4/0xd4c

On top of which kernel version has this patch been developed?
I think this deadlock has already been fixed by commit 7029e2151a7c 
("scsi: ufs: Fix a deadlock between PM and the SCSI error handler").
Please check whether that commit by itself (without this patch) is 
sufficient to fix the reported deadlock.

> ---
>   drivers/ufs/core/ufshcd.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)

The changelog is missing. Please include a changelog when posting v2 or 
a later version of a patch.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index e18c9f4463ec..0dfb9a35bf66 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7366,6 +7366,23 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
>   
>   	hba = shost_priv(cmd->device->host);
>   
> +	/*
> +	 * If pm op resume fail and wait err recovery, do link recovery only.
> +	 * Because schedule eh work will get dead lock in ufshcd_rpm_get_sync
> +	 * and wait wlun resume, but wlun resume error wait eh work finish.
> +	 */

The above comment has grammar issues and some parts are 
incomprehensible. What does e.g. "wait err recovery" mean? Please 
improve this source code comment.

Thanks,

Bart.
