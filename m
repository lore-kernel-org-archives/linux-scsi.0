Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF88EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 18:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343982AbhLOSr6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 13:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343962AbhLOSrt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2021 13:47:49 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AA6C06173F
        for <linux-scsi@vger.kernel.org>; Wed, 15 Dec 2021 10:47:49 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso25993523otf.12
        for <linux-scsi@vger.kernel.org>; Wed, 15 Dec 2021 10:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hfna//jfptCZLjQuovu81eh2+KkCsvsnrTfol/ajmJ8=;
        b=XUjOpBpixK84kehHLA+0Dy4y2yayB70U62dg4yZVzOKAnNSJj/IIGD1HGDkQm4s/XC
         osxLO9t8sYNP8VEEgV4nXZWIwhSA8I1ehR8uaEralPHDWS7+0AC1Ex1AbVfURGa9mHgm
         /M5lMORhlTiTjfJ33x+7kyHF6axQQaG1pVMGYm7qbEZKtzJ10Ge/0gPkLmiqR5uRYk83
         7YktnpkJ8Jq37uyTMJTmpYqysWIL+ZCj0M3JXzBOaQ+npy47z2tzWUYJC1OKHLW7yXkG
         3DKti8Rw4O6DG+O5IpGA7VtK6CpnHDLBGZKbStCasKtesyFpmkFCblcrTQgwZZhHi16h
         09fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hfna//jfptCZLjQuovu81eh2+KkCsvsnrTfol/ajmJ8=;
        b=fhrDLi+y6S+24ZYy+iK96iQAsVPhWv3PtFINVwpcIBSqAex3QWV/4cHuz5TEisS0ar
         vIw2+NoFpoCbqi39T2jP8RHK3FivQCd/aWlt1PLz22a27mxYUrtX2B/MwAq9uJWg2vPe
         VpU8SBLkvZasol4OY/J/KbKVBRKCt5JOdiud8JcuaIhNpnmu5uHzf0QZc7sAdAm9C0aH
         WjFiqLoWGKAwIC6tcSxTT7GDFnvzM/72VnrNnU0qNFgpgJqoALrQGp9AHeDLqDHYXgnr
         z1NUAJ9Kp7pFDslvm5/iqKz9fcFrxhM09b/pFJXxNMTTOSTu2pzq3y0ZJDX1TpEO3tPm
         zkNw==
X-Gm-Message-State: AOAM5319YbXy1EKuofTHn8EjjuMQpoGUU+i60BcHVwo/YJ+0dHBReAXX
        xXaO/AMddHwZy2wxNE203fRc4g==
X-Google-Smtp-Source: ABdhPJzUB7g4NaqI3OjMW487/RZ2mxCKnpwgUtciA1wLA7miCnzoWeBZveVX6DRqZi9lCeLKk1EgBQ==
X-Received: by 2002:a05:6830:22cf:: with SMTP id q15mr9839708otc.255.1639594067330;
        Wed, 15 Dec 2021 10:47:47 -0800 (PST)
Received: from ripper (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id t12sm550786ood.22.2021.12.15.10.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 10:47:46 -0800 (PST)
Date:   Wed, 15 Dec 2021 10:49:02 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, YongQin Liu <yongqin.liu@linaro.org>,
        Amit Pundir <amit.pundir@linaro.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2] scsi: ufs: Fix deadlock issue in
 ufshcd_wait_for_doorbell_clr()
Message-ID: <Ybo4no2n+fS4BOaV@ripper>
References: <20211214120537.531628-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214120537.531628-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue 14 Dec 04:05 PST 2021, Bean Huo wrote:

> From: Bean Huo <beanhuo@micron.com>
> 
> Call shost_for_each_device() with holding host->host_lock will cause
> a deadlock situation, which will cause the system to stall (the log
> as follow). Fix this issue by using __shost_for_each_device() in
> ufshcd_pending_cmds().
> 
> stalls on CPUs/tasks:
> all trace:
> __switch_to+0x120/0x170
> 0xffff800011643998
> ask dump for CPU 5:
> ask:kworker/u16:2   state:R  running task     stack:    0 pid:   80 ppid:     2 flags:0x0000000a
> orkqueue: events_unbound async_run_entry_fn
> all trace:
> __switch_to+0x120/0x170
> 0x0
> ask dump for CPU 6:
> ask:kworker/u16:6   state:R  running task     stack:    0 pid:  164 ppid:     2 flags:0x0000000a
> orkqueue: events_unbound async_run_entry_fn
> all trace:
> __switch_to+0x120/0x170
> 0xffff54e7c4429f80
> ask dump for CPU 7:
> ask:kworker/u16:4   state:R  running task     stack:    0 pid:  153 ppid:     2 flags:0x0000000a
> orkqueue: events_unbound async_run_entry_fn
> all trace:
> __switch_to+0x120/0x170
> blk_mq_run_hw_queue+0x34/0x110
> blk_mq_sched_insert_request+0xb0/0x120
> blk_execute_rq_nowait+0x68/0x88
> blk_execute_rq+0x4c/0xd8
> __scsi_execute+0xec/0x1d0
> scsi_vpd_inquiry+0x84/0xf0
> scsi_get_vpd_buf+0x34/0xb8
> scsi_attach_vpd+0x34/0x140
> scsi_probe_and_add_lun+0xa6c/0xab8
> __scsi_scan_target+0x438/0x4f8
> scsi_scan_channel+0x6c/0xa8
> scsi_scan_host_selected+0xf0/0x150
> do_scsi_scan_host+0x88/0x90
> scsi_scan_host+0x1b4/0x1d0
> ufshcd_async_scan+0x248/0x310
> async_run_entry_fn+0x30/0x178
> process_one_work+0x1e8/0x368
> worker_thread+0x40/0x478
> kthread+0x174/0x180
> ret_from_fork+0x10/0x20
> 
> Fixes: 8d077ede48c1 ("scsi: ufs: Optimize the command queueing code")
> Reported-by: YongQin Liu <yongqin.liu@linaro.org>
> Reported-by: Amit Pundir <amit.pundir@linaro.org>
> Tested-by: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Bean Huo <beanhuo@micron.com>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  drivers/scsi/ufs/ufshcd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 6dd517267f1b..fbebb8309ef7 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1082,7 +1082,8 @@ static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
>  	struct scsi_device *sdev;
>  	u32 pending = 0;
>  
> -	shost_for_each_device(sdev, hba->host)
> +	lockdep_assert_held(hba->host->host_lock);
> +	__shost_for_each_device(sdev, hba->host)
>  		pending += sbitmap_weight(&sdev->budget_map);
>  
>  	return pending;
> -- 
> 2.25.1
> 
> 
