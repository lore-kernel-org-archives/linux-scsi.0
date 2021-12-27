Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7FE4C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Dec 2021 07:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhL0H4g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Dec 2021 02:56:36 -0500
Received: from email.unionmem.com ([221.4.138.186]:22538 "EHLO
        VLXDG1SPAM1.ramaxel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231146AbhL0H4g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2021 02:56:36 -0500
Received: from V12DG1MBS01.ramaxel.local (v12dg1mbs01.ramaxel.local [172.26.18.31])
        by VLXDG1SPAM1.ramaxel.com with ESMTPS id 1BR7tbEQ064860
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 27 Dec 2021 15:55:37 +0800 (GMT-8)
        (envelope-from songyl@ramaxel.com)
Received: from localhost (172.20.2.155) by V12DG1MBS01.ramaxel.local
 (172.26.18.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 27
 Dec 2021 15:55:36 +0800
Date:   Mon, 27 Dec 2021 15:55:35 +0800
From:   Yanling Song <songyl@ramaxel.com>
To:     <yanling.song@linux.dev>
CC:     Bart Van Assche <bvanassche@acm.org>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <yujiang@ramaxel.com>,
        <xuyun@ramaxel.com>, <yanggan@ramaxel.com>
Subject: Re: [PATCH V2] scsi:spraid: initial commit of Ramaxel spraid driver
Message-ID: <20211227155535.0000119a@ramaxel.com>
In-Reply-To: <52b05051cf00a9ad617c31f227654dcc@linux.dev>
References: <399c013b-aaf9-1781-09a1-1acbc82b49ae@acm.org>
        <20211126073310.87683-1-songyl@ramaxel.com>
        <52b05051cf00a9ad617c31f227654dcc@linux.dev>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.2.155]
X-ClientProxiedBy: V12DG1MBS03.ramaxel.local (172.26.18.33) To
 V12DG1MBS01.ramaxel.local (172.26.18.31)
X-DNSRBL: 
X-MAIL: VLXDG1SPAM1.ramaxel.com 1BR7tbEQ064860
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 12 Dec 2021 02:56:01 +0000
yanling.song@linux.dev wrote:

> December 10, 2021 7:15 AM, "Bart Van Assche" <bvanassche@acm.org>
> wrote:
> 
> > On 11/25/21 11:33 PM, Yanling Song wrote:
> >   
> >> +struct spraid_dev {
> >> + struct pci_dev *pdev;  
> > 
> > Why a pointer to struct pci_dev instead of embedding struct pci_dev
> > in this structure? The latter approach is more efficient.
> >   
> The pointer of pci_dev is from linux driver frame work probe()
> function, spraid driver does not allocate memory for it, just save
> the pointer.
> 
> >> + struct device *dev;  
> > 
> > What does this pointer represent? There is already a struct device
> > inside struct pci_dev. Can this member be left out?
> >   
> The pointer of dev is from struct pci_dev. It is saved in struct
> spraid_dev just for convenience: so that we do not need to get the
> dev from pci_dev every time when using dev.
> 
> >> + struct spraid_cmd *adm_cmds;
> >> + struct list_head adm_cmd_list;
> >> + spinlock_t adm_cmd_lock; /* spinlock for lock handling */
> >> +
> >> + struct spraid_cmd *ioq_ptcmds;
> >> + struct list_head ioq_pt_list;
> >> + spinlock_t ioq_pt_lock; /* spinlock for lock handling */
> >> +
> >> + struct work_struct scan_work;
> >> + struct work_struct timesyn_work;
> >> + struct work_struct reset_work;
> >> +
> >> + enum spraid_state state;
> >> + spinlock_t state_lock; /* spinlock for lock handling */
> >> + struct request_queue *bsg_queue;  
> > 
> > The "spinlock for lock handling" comments are not useful. Please
> > make these comments useful or remove these.
> >   
> Comments will be removed in the next version.
> 
> >> +#include <linux/version.h>  
> > 
> > Upstream drivers should not include this header file.
> >  
> Ok. Changes will be included in the next version.
> 
> >> +static u32 admin_tmout = 60;
> >> +module_param(admin_tmout, uint, 0644);
> >> +MODULE_PARM_DESC(admin_tmout, "admin commands timeout (seconds)");
> >> +  
> Will be changed to per SCSI host.
> 
> >> +static u32 scmd_tmout_pt = 30;
> >> +module_param(scmd_tmout_pt, uint, 0644);
> >> +MODULE_PARM_DESC(scmd_tmout_pt, "scsi commands timeout for
> >> passthrough(seconds)");
> >> +  
> Will be deleted.
> 
> >> +static u32 scmd_tmout_nonpt = 180;
> >> +module_param(scmd_tmout_nonpt, uint, 0644);
> >> +MODULE_PARM_DESC(scmd_tmout_nonpt, "scsi commands timeout for
> >> rawdisk&raid(seconds)");
> >> +  
> Will be splitted into two attributes of scsi host:scmd_tmout_rawdisk,
> scmd_tmout_vd
> 

After the internal discussion, the two parameters will be removed for
now.

> >> +static u32 wait_abl_tmout = 3;
> >> +module_param(wait_abl_tmout, uint, 0644);
> >> +MODULE_PARM_DESC(wait_abl_tmout, "wait abnormal io
> >> timeout(seconds)");
> >> +  
> Will be deleted.
> 
> >> +static bool use_sgl_force;
> >> +module_param(use_sgl_force, bool, 0644);
> >> +MODULE_PARM_DESC(use_sgl_force, "force IO use sgl format, default
> >> false");  
> >  
> Will be deleted.
>  
> > Consider leaving out all kernel module parameters. Kernel module
> > parameters are easy to introduce but can't be removed. Is it really
> > necessary that the above parameters can be configured? If so, most
> > of the above parameters probably should be per SCSI host or SCSI
> > device instead of module parameters. 
> Comments as the above.
> 
> >> +static u32 io_queue_depth = 1024;
> >> +module_param_cb(io_queue_depth, &ioq_depth_ops, &io_queue_depth,
> >> 0644); +MODULE_PARM_DESC(io_queue_depth, "set io queue depth,
> >> should >= 2");  
> > 
> > How does this differ from the SCSI sysfs attribute "can_queue"?
> >  
> Yes. it is the same as SCSI sysfs attribute "can_queue". 
> The maximum queue depth supported by hardware is 1024.  
> The parameter is to change the queue depth for different usages to
> get the best performance.
> 
>  
> >> +static unsigned char log_debug_switch;
> >> +module_param_cb(log_debug_switch, &log_debug_switch_ops,
> >> &log_debug_switch, 0644); +MODULE_PARM_DESC(log_debug_switch, "set
> >> log state, default non-zero for switch on");  
> > 
> > Can this parameter be left out by using pr_debug()?
> >  
> Ye. Will use pr_debug in the next version.
> 
>  
> >> +static unsigned char small_pool_num = 4;
> >> +module_param_cb(small_pool_num, &small_pool_num_ops,
> >> &small_pool_num, 0644); +MODULE_PARM_DESC(small_pool_num, "set prp
> >> small pool num, default 4, MAX 16");  
> > 
> > The description of the above parameter is too cryptic.
> >  
> Will add more comments:
> It was found that the spindlock of a single pool conflicts a lot with
> multiple CPUs. So multiple pools are introduced to reduce the
> conflictions. 
> 
>  
> > Thanks,
> > 
> > Bart.  

