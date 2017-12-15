From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 1/7] scsi: libsas: Use dynamic alloced work to avoid
 sas event lost
Date: Fri, 15 Dec 2017 13:14:08 +0100
Message-ID: <844f24da-63a8-b949-2c0d-5c15159b25e0@suse.de>
References: <20171208094210.24887-1-yanaijie@huawei.com>
 <20171208094210.24887-2-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46967 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754996AbdLOMON (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Dec 2017 07:14:13 -0500
In-Reply-To: <20171208094210.24887-2-yanaijie@huawei.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Raj.Dinesh@microsemi.com, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiyou.wangcong@gmail.com, Yijing Wang <wangyijing@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>

On 12/08/2017 10:42 AM, Jason Yan wrote:
> Now libsas hotplug work is static, every sas event type has its own
> static work, LLDD driver queues the hotplug work into shost->work_q.
> If LLDD driver burst posts lots hotplug events to libsas, the hotplug
> events may pending in the workqueue like
> 
> shost->work_q
> new work[PORTE_BYTES_DMAED] --> |[PHYE_LOSS_OF_SIGNAL][PORTE_BYTES_DMAED] -> processing
>                                 |<-------wait worker to process-------->|
> 
> In this case, a new PORTE_BYTES_DMAED event coming, libsas try to queue
> it to shost->work_q, but this work is already pending, so it would be
> lost. Finally, libsas delete the related sas port and sas devices, but
> LLDD driver expect libsas add the sas port and devices(last sas event).
> 
> This patch use dynamic allocated work to avoid this issue.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> CC: John Garry <john.garry@huawei.com>
> CC: Johannes Thumshirn <jthumshirn@suse.de>
> CC: Ewan Milne <emilne@redhat.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Tomas Henzl <thenzl@redhat.com>
> CC: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  drivers/scsi/libsas/sas_event.c    | 74 +++++++++++++++++++++++++++++---------
>  drivers/scsi/libsas/sas_init.c     | 27 ++++++++++++--
>  drivers/scsi/libsas/sas_internal.h |  6 ++++
>  drivers/scsi/libsas/sas_phy.c      | 44 +++++------------------
>  drivers/scsi/libsas/sas_port.c     | 18 +++++-----
>  include/scsi/libsas.h              | 17 +++++----
>  6 files changed, 115 insertions(+), 71 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
