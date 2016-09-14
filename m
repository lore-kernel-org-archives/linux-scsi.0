From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC][PATCH v1 1/2] libsas: Alloc dynamic work to avoid missing
 sas events
Date: Wed, 14 Sep 2016 13:52:55 +0200
Message-ID: <691d9b9b-050f-5313-3ab4-74bdf9259f27@suse.de>
References: <1473733835-26950-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49637 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756249AbcINLxB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Sep 2016 07:53:01 -0400
In-Reply-To: <1473733835-26950-1-git-send-email-wangyijing@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Tejun Heo <tj@kernel.org>, Qilin Chen <chenqilin2@huawei.com>, Wei Fang <fangwei1@huawei.com>, Yousong He <heyousong@huawei.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 09/13/2016 04:30 AM, Yijing Wang wrote:
> Now libsas hotplug work is static, LLDD driver queue
> the hotplug work into shost->work_q. If LLDD driver
> burst post lots hotplug event to libsas, the hotplug
> events may pending in the workqueue like
> 
> shost->workq
> tail | PHYE_LOSS_OF_SIGNAL  | PORTE_BYTES_DMAED | head
> 
> In this case, if a new PORTE_BYTES_DMAED event coming,
> it would be lost, because we can not queue a work which
> is already pending in the workqueue, also libsas has a
> pending bit to avoid queue the same event.
> 
> The lost hotplug event make something confusing, e.g.
> we have sas disks connected hardware, but we can not
> found them in kernel.
> 
> This patch remove the static defined hotplug work,
> and use dynamic work to avoid missing hotplug events.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Yousong He <heyousong@huawei.com>
> Signed-off-by: Qilin Chen <chenqilin2@huawei.com>
> ---
>  drivers/scsi/libsas/sas_event.c    |   61 ++++++++++++++++++++---------------
>  drivers/scsi/libsas/sas_init.c     |    5 +--
>  drivers/scsi/libsas/sas_internal.h |    3 ++
>  drivers/scsi/libsas/sas_phy.c      |   50 ++++++++---------------------
>  drivers/scsi/libsas/sas_port.c     |   23 ++++++++------
>  include/scsi/libsas.h              |    8 -----
>  6 files changed, 66 insertions(+), 84 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
