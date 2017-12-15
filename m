From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 2/7] scsi: libsas: shut down the PHY if events reached
 the threshold
Date: Fri, 15 Dec 2017 13:18:32 +0100
Message-ID: <c1accdc7-00a7-06a3-5531-ae64ef797cd2@suse.de>
References: <20171208094210.24887-1-yanaijie@huawei.com>
 <20171208094210.24887-3-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171208094210.24887-3-yanaijie@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Raj.Dinesh@microsemi.com, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiyou.wangcong@gmail.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 12/08/2017 10:42 AM, Jason Yan wrote:
> If the PHY burst too many events, we will alloc a lot of events for the
> worker. This may leads to memory exhaustion.
> 
> Dan Williams suggested to shut down the PHY if the events reached the
> threshold, because in this case the PHY may have gone into some
> erroneous state. Users can re-enable the PHY by sysfs if they want.
> 
> We cannot use the fixed memory pool because if we run out of events, the
> shut down event and loss of signal event will lost too. The events still
> need to be allocated and processed in this case.
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> CC: John Garry <john.garry@huawei.com>
> CC: Johannes Thumshirn <jthumshirn@suse.de>
> CC: Ewan Milne <emilne@redhat.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/libsas/sas_init.c | 33 ++++++++++++++++++++++++++++++++-
>  drivers/scsi/libsas/sas_phy.c  | 27 ++++++++++++++++++++++++++-
>  include/scsi/libsas.h          |  6 ++++++
>  3 files changed, 64 insertions(+), 2 deletions(-)
> 
Well, this still looks a bit error prone; what if the system runs out of
memory before the pool is exhausted?
(Also a threshold of 1024 events is a bit arbitrary; one might want to
adjust that).

Couldn't you allocate two static events always (for shutdown and signal
loss), and then use a fixed pool?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
