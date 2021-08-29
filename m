Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649BEC432BE
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Aug 2021 22:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AAFD60F46
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Aug 2021 22:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236116AbhH2WT1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Aug 2021 18:19:27 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:38467 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235757AbhH2WT0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Aug 2021 18:19:26 -0400
Received: by mail-pg1-f177.google.com with SMTP id w8so11607262pgf.5
        for <linux-scsi@vger.kernel.org>; Sun, 29 Aug 2021 15:18:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BmTBvtFEIPgnB/YG4W4TP0MDZLSjAiuFsXo46IPi/qM=;
        b=pIeVeuOJJMG0dHeIS7XdAFgGK+tO3eu/xKwBD3CYS7PYwgCX2T/OcLMLmhAeUwIHIa
         xC+3X+sgaHNFWypNfqAKjErG6vfPOkKnJaSFx/eQo2I4E9+KapZM8b3vRIKFjxXOHU/l
         eq2wz7v8IeQosflYjUEbZ8hywWTjldgSxLR93K8jbQZo5VJQt+2ZQKc2zd0ymTRuLX7U
         oBF/Mh+A2sfwd3CD/tFHUAkL4qYLtRYZo2JBggbeEEvJU1fwrHFwnoQCt89cf6Xcm1gK
         r3KlwJgKEXh6jh8lQTPNP++TPFC8JFdmhSGXgaTEPaYqJJfIpRoJuP5e2EREDuMrtnEA
         ACrw==
X-Gm-Message-State: AOAM533KqqR0m4iO7mJp+8MpecofM9BenU2t4m7+pOuOLhjmQNbz8gRg
        yuJfqbi9JKDJF+oJNOBH4zo=
X-Google-Smtp-Source: ABdhPJxYdK814PVsBmFzdzrCou8CPgPf2RHVD27A2VgN8Di3lcJgTq8PYERjPonuKBpGvsFIRFybeQ==
X-Received: by 2002:a63:e74b:: with SMTP id j11mr18614208pgk.322.1630275513789;
        Sun, 29 Aug 2021 15:18:33 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:3a42:154:b70e:7868? ([2601:647:4000:d7:3a42:154:b70e:7868])
        by smtp.gmail.com with UTF8SMTPSA id a15sm12416521pfn.219.2021.08.29.15.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Aug 2021 15:18:32 -0700 (PDT)
Message-ID: <020bd6be-0944-8e25-c9fd-972cab5e6746@acm.org>
Date:   Sun, 29 Aug 2021 15:18:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [PATCH v3 16/18] scsi: ufs: Synchronize SCSI and UFS error
 handling
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20210722033439.26550-1-bvanassche@acm.org>
 <20210722033439.26550-17-bvanassche@acm.org>
 <88e0dc4c-34ff-6d87-fa9f-2fc924f50369@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <88e0dc4c-34ff-6d87-fa9f-2fc924f50369@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/28/21 02:47, Adrian Hunter wrote:
> There is a deadlock that seems to be related to this patch, because now
> requests are blocked while the error handler waits on the host_sem.

Hi Adrian,

Some but not all of the issues mentioned below have been introduced by 
patch 16/18. Anyway, thank you for having shared your concerns.

> Example:
> 
> ufshcd_err_handler() races with ufshcd_wl_suspend() for host_sem.
> ufshcd_wl_suspend() wins the race but now PM requests deadlock:
> 
> because:
>   scsi_queue_rq() -> scsi_host_queue_ready() -> scsi_host_in_recovery() is FALSE
> 
> because:
>   scsi_schedule_eh() has done:
> 	    scsi_host_set_state(shost, SHOST_RECOVERY) == 0 ||
> 	    scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY) == 0)
> 
> 
> Some questions for thought:
> 
> Won't any holder of host_sem deadlock if it tries to do SCSI requests
> and the error handler is waiting on host_sem?
> 
> Won't runtime resume deadlock if it is initiated by the error handler?

My understanding is that host_sem is used for the following purposes:
- To prevent that sysfs attributes are read or written after shutdown
   has started (hba->shutting_down).
- To serialize sysfs attribute access, clock scaling, error handling,
   the ufshcd_probe_hba() call from ufshcd_async_scan() and hibernation.

I propose to make the following changes:
- Instead of checking the value of hba->shutting_down from inside sysfs
   attribute callbacks, remove sysfs attributes before starting shutdown.
   That will remove the need to check hba->shutting_down from inside
   sysfs attribute callbacks.
- Leave out the host_sem down() and up() calls from ufshcd_wl_suspend()
   and ufshcd_wl_resume(). Serializing hibernation against e.g. sysfs
   attribute access is not the responsibility of a SCSI LLD - this is the
   responsibility of the power management core.
- Split host_sem. I don't see how else to address the potential deadlock
   between the error handler and runtime resume.

Do you agree with the above?

Thanks,

Bart.
