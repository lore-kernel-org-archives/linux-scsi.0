From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 3/7] libsas: Use new workqueue to run sas event
Date: Fri, 14 Jul 2017 08:42:34 +0200
Message-ID: <3e53940a-0913-1d08-3719-c45ffa854db7@suse.de>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
 <1499670369-44143-4-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499670369-44143-4-git-send-email-wangyijing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, john.garry@huawei.com, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 07/10/2017 09:06 AM, Yijing Wang wrote:
> Now all libsas works are queued to scsi host workqueue,
> include sas event work post by LLDD and sas discovery
> work, and a sas hotplug flow may be divided into several
> works, e.g libsas receive a PORTE_BYTES_DMAED event,
> now we process it as following steps:
> sas_form_port  --- run in work in shot workq
> 	sas_discover_domain  --- run in another work in shost workq
> 		...
> 		sas_probe_devices  --- run in new work in shost workq
> We found during hot-add a device, libsas may need run several
> works in same workqueue to add device in system, the process is
> not atomic, it may interrupt by other sas event works, like
> PHYE_LOSS_OF_SIGNAL. Finally, we would found lots unexpected
> errors. This patch is preparation of execute libsas sas event
> in sync.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> CC: John Garry <john.garry@huawei.com>
> CC: Johannes Thumshirn <jthumshirn@suse.de>
> CC: Ewan Milne <emilne@redhat.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Tomas Henzl <thenzl@redhat.com>
> CC: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/libsas/sas_event.c | 4 ++--
>  drivers/scsi/libsas/sas_init.c  | 7 +++++++
>  include/scsi/libsas.h           | 1 +
>  3 files changed, 10 insertions(+), 2 deletions(-)
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
