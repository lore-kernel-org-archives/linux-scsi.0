From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v5 0/7] Enhance libsas hotplug feature
Date: Tue, 2 Jan 2018 11:06:00 +0000
Message-ID: <8f6e3763-2b04-23e8-f1ec-8ed3c58f55d3@huawei.com>
References: <20171208094210.24887-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171208094210.24887-1-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: Jason Yan <yanaijie@huawei.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Raj.Dinesh@microsemi.com, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiyou.wangcong@gmail.com
List-Id: linux-scsi@vger.kernel.org

On 08/12/2017 09:42, Jason Yan wrote:
> Now the libsas hotplug has some issues, Dan Williams report
> a similar bug here before
> https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg39187.html
>

Hi Martin, James,

At this point we feel that we have a decent solution to the 
long-standing libsas hotplug issues.

Hannes has kindly reviewed the series.

Can you let us know what else you require for acceptance? More 
independent review or testing?

Thanks,
John

> The issues we have found
> 1. if LLDD burst reports lots of phy-up/phy-down sas events, some events
>    may lost because a same sas events is pending now, finally libsas topo
>    may different the hardware.
> 2. receive a phy down sas event, libsas call sas_deform_port to remove
>    devices, it would first delete the sas port, then put a destruction
>    discovery event in a new work, and queue it at the tail of workqueue,
>    once the sas port be deleted, its children device will be deleted too,
>    when the destruction work start, it will found the target device has
>    been removed, and report a sysfs warnning.
> 3. since a hotplug process will be devided into several works, if a phy up
>    sas event insert into phydown works, like
>    destruction work  ---> PORTE_BYTES_DMAED (sas_form_port) ---->PHYE_LOSS_OF_SIGNAL
>    the hot remove flow would broken by PORTE_BYTES_DMAED event, it's not
>    we expected, and issues would occur.
>
> v4->v5: -process only one expander's revalidation in sas_ex_revalidate_domain()
>         -notify event PORTE_BROADCAST_RCVD in sas_enable_revalidation()
> v3->v4: -use dynamic alloced work and support shutting down the phy if active event reached the threshold
>         -use flush_workqueue instead of wait-completion to process discover events synchronously
>         -direct call probe and destruct function
> v2->v3: some code improvements suggested by Johannes and John,
>         split v2 patch 2 into several small pathes.
> v1->v2: some code improvements suggested by John Garry
>
> Jason Yan (7):
>   scsi: libsas: Use dynamic alloced work to avoid sas event lost
>   scsi: libsas: shut down the PHY if events reached the threshold
>   scsi: libsas: make the event threshold configurable
>   scsi: libsas: Use new workqueue to run sas event and disco event
>   scsi: libsas: use flush_workqueue to process disco events
>     synchronously
>   scsi: libsas: direct call probe and destruct
>   scsi: libsas: notify event PORTE_BROADCAST_RCVD in
>     sas_enable_revalidation()
>
>  drivers/scsi/hisi_sas/hisi_sas_main.c |   6 ++
>  drivers/scsi/libsas/sas_ata.c         |   1 -
>  drivers/scsi/libsas/sas_discover.c    |  34 ++++++-----
>  drivers/scsi/libsas/sas_event.c       |  86 ++++++++++++++++++++-------
>  drivers/scsi/libsas/sas_expander.c    |   8 +--
>  drivers/scsi/libsas/sas_init.c        | 107 +++++++++++++++++++++++++++++++++-
>  drivers/scsi/libsas/sas_internal.h    |   7 +++
>  drivers/scsi/libsas/sas_phy.c         |  69 +++++++++++-----------
>  drivers/scsi/libsas/sas_port.c        |  25 ++++----
>  include/scsi/libsas.h                 |  30 +++++++---
>  include/scsi/scsi_transport_sas.h     |   1 +
>  11 files changed, 277 insertions(+), 97 deletions(-)
>
