Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D096BECAAD3
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Sep 2022 13:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiISNyZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Sep 2022 09:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiISNyX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2022 09:54:23 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C519C220C0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 06:54:22 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id v4so26807510pgi.10
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 06:54:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Aw/3MnWTGb8Jqn9vYqcMwJeVw1rb4axfXLcTclYmo80=;
        b=b2HiU++8fyKhQ8sba5YnPRakoYmC6G1oWykTNO5fkbHBhBa+3FQu506O1X8jLZxVno
         96xUnrl6sE7pVp6VJy+x3BP/hpc5NHpDrAa3k7UZIC6F2oZ8qySI/C5mTIm2fMiaFyie
         w99CtizKpwzEZDbeimUHTrDkzbbG2Nyt1suixDMJZI5/57dVqnKLeci46ESZtcRbn2OT
         m/M/gwEV0SO67vEc9++X/88DJ4s3CIYQxJl3QU6x/0Qlpi34Rp7X/Ti6lKZwUgU1+ZOC
         NRIW1S7+nCbXlsyr3JmOC9gr7wvwb8vKWuwi73j9J7P0G5AKrp2+Zv5uYUIbvbIZ9YQI
         4u2A==
X-Gm-Message-State: ACrzQf2JxvZg193c4UuCM+luPGqcXFTXeHhiomF1Fr4SZUf1Yo8U6AZf
        c2PKInE3dKBxAK1rOQdN6gA=
X-Google-Smtp-Source: AMsMyM5JMsG6i7GXf6xoRaXLSGdTb9BJprWNTJgxUs2JOBBaYQZr7d65Na78/Py0b9EvHFjd0bPjBg==
X-Received: by 2002:a63:2bcc:0:b0:439:36bb:c036 with SMTP id r195-20020a632bcc000000b0043936bbc036mr15721493pgr.447.1663595662021;
        Mon, 19 Sep 2022 06:54:22 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id m12-20020a17090a4d8c00b00202aa2b5295sm6666747pjh.36.2022.09.19.06.54.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 06:54:21 -0700 (PDT)
Message-ID: <913f72ad-7f6f-9067-df36-f9507359c816@acm.org>
Date:   Mon, 19 Sep 2022 06:54:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] scsi: ufs: Fix deadlocks between power management and
 error handler
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        dh0421.hwang@samsung.com, Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220916184220.867535-1-bvanassche@acm.org>
 <3712590b-20cb-7d27-3017-4567f1fcddc2@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3712590b-20cb-7d27-3017-4567f1fcddc2@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/19/22 04:34, Adrian Hunter wrote:
> Did you consider something like:
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 7256e6c43ca6..dc83b38dfde9 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7374,6 +7374,9 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
>   
>   	hba = shost_priv(cmd->device->host);
>   
> +	if (hba->pm_op_in_progress)
> +		return FAST_IO_FAIL;
> +
>   	spin_lock_irqsave(hba->host->host_lock, flags);
>   	hba->force_reset = true;
>   	ufshcd_schedule_eh_work(hba);

The above change could cause error handling to be skipped if an error 
happened that requires the link to be reset. That seems wrong to me.

> The original commit for host_sem was aimed at sysfs (see commit below).
> Did you consider how sysfs access is affected?
> 
>    commit 9cd20d3f473619d8d482551d15d4cebfb3ce73c8
>    Author: Can Guo <cang@codeaurora.org>
>    Date:   Wed Jan 13 19:13:28 2021 -0800
> 
>      scsi: ufs: Protect PM ops and err_handler from user access through sysfs
>      
>      User layer may access sysfs nodes when system PM ops or error handling is
>      running. This can cause various problems. Rename eh_sem to host_sem and use
>      it to protect PM ops and error handling from user layer intervention.

The sysfs and debugfs attribute callback methods already call 
pm_runtime_get_sync() and pm_runtime_put_sync() so how could the power 
state change while a sysfs or debugfs attribute callback method is in 
progress?

>> The ufshcd_rpm_get_sync() call at the start of
>> ufshcd_err_handling_prepare() may deadlock since calling scsi_execute()
>> is required by the UFS runtime resume implementation. Fixing that
>> deadlock falls outside the scope of this patch.
> 
> Do you mean:
> 
> static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
> {
> 	ufshcd_rpm_get_sync(hba);
> 
> because that is the host controller, not the UFS device, that is
> being resumed.

Hmm ... I think that ufshcd_rpm_get_sync() affects the power state of 
the UFS device and not the power state of the UFS host controller. From 
ufshcd-priv.h:

static inline int ufshcd_rpm_get_sync(struct ufs_hba *hba)
{
	return pm_runtime_get_sync(&hba->ufs_device_wlun->sdev_gendev);
}

Thanks,

Bart.
