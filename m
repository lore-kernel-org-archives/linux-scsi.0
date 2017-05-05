From: Johannes Thumshirn <jth@kernel.org>
Subject: Re: [PATCH 2/5] scsi: bnx2fc: convert per-CPU thread to workqueue
Date: Fri, 5 May 2017 12:33:22 +0200
Message-ID: <1a5bff55-0a50-739e-89c0-620bee7f21fb@kernel.org>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
 <20170410171254.30367-3-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34976 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751702AbdEEKdZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2017 06:33:25 -0400
Received: by mail-wr0-f194.google.com with SMTP id g12so244503wrg.2
        for <linux-scsi@vger.kernel.org>; Fri, 05 May 2017 03:33:25 -0700 (PDT)
In-Reply-To: <20170410171254.30367-3-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: rt@linutronix.de, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>


On 04/10/2017 07:12 PM, Sebastian Andrzej Siewior wrote:
> The driver creates its own per-CPU threads which are updated based on CPU
> hotplug events. It is also possible to use kworkers and remove some of the
> infrastructure get the same job done while saving a few lines of code.
>
> bnx2fc_percpu_io_thread() becomes bnx2fc_percpu_io_work() which is
> mostly the same code. The outer loop (kthread_should_stop()) gets
> removed and the remaining code is shifted to the left.
> In bnx2fc_process_new_cqes() the code checked for ->iothread to
> decide if there is an active per-CPU thread. With the kworkers this
> is no longer possible nor required. The allocation of a new work item
> (via bnx2fc_alloc_work()) does no longer happen with the ->fp_work_lock
> lock held. It performs only a memory allocation + initialization which
> does not require any kind of serialization. The lock is held while
> adding the new member to fps->work_list list.
>
> The remaining part is the removal CPU hotplug notifier since it is taken
> care by the workqueue code.
>
> This patch was only compile-tested due to -ENODEV.
>
> Cc: QLogic-Storage-Upstream@qlogic.com
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
