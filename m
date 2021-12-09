Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FEA1C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Dec 2021 23:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhLIXT3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Dec 2021 18:19:29 -0500
Received: from mail-pj1-f51.google.com ([209.85.216.51]:40817 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhLIXT3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2021 18:19:29 -0500
Received: by mail-pj1-f51.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so8110994pjb.5
        for <linux-scsi@vger.kernel.org>; Thu, 09 Dec 2021 15:15:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9kAfmSn6unkehs+qcAn35zX1qdlQQFkVEhYVNytbkdc=;
        b=rG144Wq+itNB01Bkrscnow6tzpwYBifvpjtuJe6u4luuGzoxdhze0YO1VzkeqexbnE
         TTgjjOSP8ikVq5icl4Nyin/dRr0wrxnezd5W+nCtvEHGPWRnaHEB4Xqb2utMtQhEydxi
         a7PdxhOrk6b4GC0t8RpOM/MYLgqx5ocQzpwqm5JZpT4RNzEVP074RP5yPht5HJG3/6y5
         BMZsP58je4D8rVD7EAynD3Eqi1bQRFswXK4MyetUuIknETnHTeetCWAOkOwWJB4biyhU
         zp5A1hqjQO44ZA5Wr8QyHK/6b7ln/BHn03l459JXuO9rOJ+d5ZreKJ8z5iyrxaWpYnE2
         xDCQ==
X-Gm-Message-State: AOAM532pqo11EFQZqGWgpDuJGPb/Pxs2y1nak98JnYEH4RVL2tOksO2g
        MHe3ZWgJJJVkvqAZDV6lBFI=
X-Google-Smtp-Source: ABdhPJxjx7TN7j0kWLevVV3SIN3rYd4Rvk4SFBlsahc+1FphXAIgxtwTUIbPKa2LaR6uvVXM6s0+oA==
X-Received: by 2002:a17:90b:4ad1:: with SMTP id mh17mr19381595pjb.33.1639091754655;
        Thu, 09 Dec 2021 15:15:54 -0800 (PST)
Received: from ?IPv6:2620:0:1000:2514:4f5b:f494:7264:b4d4? ([2620:0:1000:2514:4f5b:f494:7264:b4d4])
        by smtp.gmail.com with ESMTPSA id u9sm765903pfi.23.2021.12.09.15.15.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 15:15:54 -0800 (PST)
Subject: Re: [PATCH V2] scsi:spraid: initial commit of Ramaxel spraid driver
To:     Yanling Song <songyl@ramaxel.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, yujiang@ramaxel.com
References: <20211126073310.87683-1-songyl@ramaxel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <399c013b-aaf9-1781-09a1-1acbc82b49ae@acm.org>
Date:   Thu, 9 Dec 2021 15:15:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211126073310.87683-1-songyl@ramaxel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/21 11:33 PM, Yanling Song wrote:
> +struct spraid_dev {
> +	struct pci_dev *pdev;

Why a pointer to struct pci_dev instead of embedding struct pci_dev in this structure? The
latter approach is more efficient.

> +	struct device *dev;

What does this pointer represent? There is already a struct device inside struct pci_dev. Can
this member be left out?

> +	struct spraid_cmd *adm_cmds;
> +	struct list_head adm_cmd_list;
> +	spinlock_t adm_cmd_lock; /* spinlock for lock handling */
> +
> +	struct spraid_cmd *ioq_ptcmds;
> +	struct list_head ioq_pt_list;
> +	spinlock_t ioq_pt_lock; /* spinlock for lock handling */
> +
> +	struct work_struct scan_work;
> +	struct work_struct timesyn_work;
> +	struct work_struct reset_work;
> +
> +	enum spraid_state state;
> +	spinlock_t state_lock; /* spinlock for lock handling */
> +	struct request_queue *bsg_queue;

The "spinlock for lock handling" comments are not useful. Please make these comments useful or
remove these.

> +#include <linux/version.h>

Upstream drivers should not include this header file.

> +static u32 admin_tmout = 60;
> +module_param(admin_tmout, uint, 0644);
> +MODULE_PARM_DESC(admin_tmout, "admin commands timeout (seconds)");
> +
> +static u32 scmd_tmout_pt = 30;
> +module_param(scmd_tmout_pt, uint, 0644);
> +MODULE_PARM_DESC(scmd_tmout_pt, "scsi commands timeout for passthrough(seconds)");
> +
> +static u32 scmd_tmout_nonpt = 180;
> +module_param(scmd_tmout_nonpt, uint, 0644);
> +MODULE_PARM_DESC(scmd_tmout_nonpt, "scsi commands timeout for rawdisk&raid(seconds)");
> +
> +static u32 wait_abl_tmout = 3;
> +module_param(wait_abl_tmout, uint, 0644);
> +MODULE_PARM_DESC(wait_abl_tmout, "wait abnormal io timeout(seconds)");
> +
> +static bool use_sgl_force;
> +module_param(use_sgl_force, bool, 0644);
> +MODULE_PARM_DESC(use_sgl_force, "force IO use sgl format, default false");

Consider leaving out all kernel module parameters. Kernel module parameters are easy to introduce
but can't be removed. Is it really necessary that the above parameters can be configured? If so,
most of the above parameters probably should be per SCSI host or SCSI device instead of module
parameters.

> +static u32 io_queue_depth = 1024;
> +module_param_cb(io_queue_depth, &ioq_depth_ops, &io_queue_depth, 0644);
> +MODULE_PARM_DESC(io_queue_depth, "set io queue depth, should >= 2");

How does this differ from the SCSI sysfs attribute "can_queue"?

> +static unsigned char log_debug_switch;
> +module_param_cb(log_debug_switch, &log_debug_switch_ops, &log_debug_switch, 0644);
> +MODULE_PARM_DESC(log_debug_switch, "set log state, default non-zero for switch on");

Can this parameter be left out by using pr_debug()?

> +static unsigned char small_pool_num = 4;
> +module_param_cb(small_pool_num, &small_pool_num_ops, &small_pool_num, 0644);
> +MODULE_PARM_DESC(small_pool_num, "set prp small pool num, default 4, MAX 16");

The description of the above parameter is too cryptic.

Thanks,

Bart.
