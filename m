From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 2/2] libsas: Enhance libsas hotplug
Date: Wed, 14 Jun 2017 10:57:28 +0200
Message-ID: <1fa27c30-aad7-2f19-4715-0ec02ef1a976@suse.de>
References: <1497425597-18799-1-git-send-email-wangyijing@huawei.com>
 <1497425597-18799-3-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1497425597-18799-3-git-send-email-wangyijing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com
List-Id: linux-scsi@vger.kernel.org

On 06/14/2017 09:33 AM, Yijing Wang wrote:
> Libsas complete a hotplug event notified by LLDD in several works,
> for example, if libsas receive a PHYE_LOSS_OF_SIGNAL, we process it
> in following steps:
> 
> notify_phy_event	[interrupt context]
> 	sas_queue_event		[queue work on shost->work_q]
> 		sas_phye_loss_of_signal		[running in shost->work_q]
> 			sas_deform_port		[remove sas port]
> 				sas_unregister_dev
> 					sas_discover_event	[queue destruct work on shost->work_q tail]
> 
> In above case, complete whole hotplug in two works, remove sas port first, then
> put the destruction of device in another work and queue it on in the tail of
> workqueue, since sas port is the parent of the children rphy device, so if remove
> sas port first, the children rphy device would also be deleted, when the destruction
> work coming, it would find the target has been removed already, and report a
> sysfs warning calltrace.
> 
> queue tail                                             queue head
> DISCE_DESTRUCT----> PORTE_BYTES_DMAED event ----->PHYE_LOSS_OF_SIGNAL[running]
> 
> There are other hotplug issues in current framework, in above case, if there is
> hotadd sas event queued between hotremove works, the hotplug order would be broken
> and unexpected issues would happen.
> 
> In this patch, we try to solve these issues in following steps:
> 1. create a new workqueue used to run sas event work, instead of scsi host workqueue,
>    because we may block sas event work, we cannot block the normal scsi works.
>    When libsas receive a phy down event, sas_deform_port would be called, and now we
>    block sas_deform_port and wait for destruction work finish, in sas_destruct_devices,
>    we may wait ata error handler, it would take a long time, so if do all stuff in scsi
>    host workq, libsas may block other scsi works too long.
> 2. create a new workqueue used to run sas discovery events work, instead of scsi host
>    workqueue, because in some cases, eg. in revalidate domain event, we may unregister
>    a sas device and discover new one, we must sync the execution, wait the remove process
>    finish, then start a new discovery. So we must put the probe and destruct discovery
>    events in a new workqueue to avoid deadlock.
> 3. introudce a asd_sas_port level wait-complete and a sas_discovery level wait-complete
>    we use former wait-complete to achieve a sas event atomic process and use latter to
>    make a sas discovery sync.
> 4. remove disco_mutex in sas_revalidate_domain, since now sas_revalidate_domain sync
>    the destruct discovery event execution, it's no need to lock disco mutex there.

The way you've written the changelog suggests this patch should be split
into 4 patches, each one taking care of one of your change items.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
