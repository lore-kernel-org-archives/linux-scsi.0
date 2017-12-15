From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 4/7] scsi: libsas: Use new workqueue to run sas event
 and disco event
Date: Fri, 15 Dec 2017 13:20:40 +0100
Message-ID: <0555e7fa-6466-0e93-4f58-86a189752ce7@suse.de>
References: <20171208094210.24887-1-yanaijie@huawei.com>
 <20171208094210.24887-5-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171208094210.24887-5-yanaijie@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Raj.Dinesh@microsemi.com, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiyou.wangcong@gmail.com, Yijing Wang <wangyijing@huawei.com>, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 12/08/2017 10:42 AM, Jason Yan wrote:
> Now all libsas works are queued to scsi host workqueue,
> include sas event work post by LLDD and sas discovery
> work, and a sas hotplug flow may be divided into several
> works, e.g libsas receive a PORTE_BYTES_DMAED event,
> currently we process it as following steps:
> sas_form_port  --- run in work in shost workq
> 	sas_discover_domain  --- run in another work in shost workq
> 		...
> 		sas_probe_devices  --- run in new work in shost workq
> We found during hot-add a device, libsas may need run several
> works in same workqueue to add device in system, the process is
> not atomic, it may interrupt by other sas event works, like
> PHYE_LOSS_OF_SIGNAL.
> 
> This patch is preparation of execute libsas sas event in sync. We need
> to use different workqueue to run sas event and disco event. Otherwise
> the work will be blocked for waiting another chained work in the same
> workqueue.
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
>  drivers/scsi/libsas/sas_discover.c |  2 +-
>  drivers/scsi/libsas/sas_event.c    |  6 +++---
>  drivers/scsi/libsas/sas_init.c     | 18 ++++++++++++++++++
>  include/scsi/libsas.h              |  3 +++
>  4 files changed, 25 insertions(+), 4 deletions(-)
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
