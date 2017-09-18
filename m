From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v4 00/11] Enhance libsas hotplug feature
Date: Mon, 18 Sep 2017 13:54:47 +0100
Message-ID: <f1698b1a-8d80-8ea2-868b-dd4c9b50ea61@huawei.com>
References: <1504689314-20072-1-git-send-email-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504689314-20072-1-git-send-email-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, jack.wang@profitbricks.com, lindar_liu@usish.com
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenweilong@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Raj.Dinesh@microsemi.com, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com
List-Id: linux-scsi@vger.kernel.org

On 06/09/2017 10:15, Jason Yan wrote:
> Hello all, Yijing Wang handed over this topic to me. We are working
> on it the last two months. We have tested the patchset for a long
> time. Here is the new version.
>
> Now the libsas hotplug has some issues, Dan Williams report
> a similar bug here before
> https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg39187.html
>
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
> 3. since a hotplug process will be divided into several works, if a phy up
>    sas event insert into phydown works, like
>    destruction work  ---> PORTE_BYTES_DMAED (sas_form_port) ---->PHYE_LOSS_OF_SIGNAL
>    the hot remove flow would broken by PORTE_BYTES_DMAED event, it's not
>    we expected, and issues would occur.
>

I have tried to verify PM suspend/resume feature with this patchset to 
ensure that it is not broken.

Since our hisi_sas driver does not support PM yet, I have got my hands 
on an adaptec card which uses pm8001 driver (it's vendor 9065, device 
8088) to test.

So in the PM resume, sometimes I find the console locks up with and 
without this patchset. In these cases, I find this log:
[   59.344266] pm80xx pm80xx_chip_init 1098:Firmware is not ready!

Is this a known issue? Should we have a chip reset in all cases in the 
resume code, marked ***:
static int pm8001_pci_resume(struct pci_dev *pdev)
{
...	

	rc = pci_go_44(pdev);
	if (rc)
		goto err_out_disable;

	/* chip soft rst only for spc */
	if (pm8001_ha->chip_id == chip_8001) { **** HERE
		PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
		PM8001_INIT_DBG(pm8001_ha,
			pm8001_printk("chip soft reset successful\n"));
	}
	rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
	if (rc)
		goto err_out_disable;

...
}

John

> v3->v4: -get rid of unused ha event and do some cleanup
>         -use dynamic alloced work and support shutting down the phy if active event reached the threshold
> 		-use flush_workqueue instead of wait-completion to process discover events synchronously
> 		-direct call probe and destruct function
> 		-other small code improvements
> v2->v3: some code improvements suggested by Johannes and John,
> 	    split v2 patch 2 into several small patches.
> v1->v2: some code improvements suggested by John Garry
>
> Jason Yan (10):
>   libsas: kill useless ha_event and do some cleanup
>   libsas: remove the numbering for each event enum
>   libsas: remove unused port_gone_completion and DISCE_PORT_GONE
>   libsas: rename notify_port_event() for consistency
>   libsas: Use dynamic alloced work to avoid sas event lost
>   libsas: shut down the PHY if events reached the threshold
>   libsas: make the event threshold configurable
>   libsas: Use new workqueue to run sas event and disco event
>   libsas: libsas: use flush_workqueue to process disco events
>     synchronously
>   libsas: direct call probe and destruct
>
> chenxiang (1):
>   libsas: add event to defer list tail instead of head when draining
>
>  drivers/scsi/aic94xx/aic94xx_hwi.c    |   3 -
>  drivers/scsi/hisi_sas/hisi_sas_main.c |   7 ++-
>  drivers/scsi/libsas/sas_ata.c         |   1 -
>  drivers/scsi/libsas/sas_discover.c    |  36 +++++++-----
>  drivers/scsi/libsas/sas_dump.c        |  10 ----
>  drivers/scsi/libsas/sas_dump.h        |   1 -
>  drivers/scsi/libsas/sas_event.c       |  97 +++++++++++++++++++-------------
>  drivers/scsi/libsas/sas_expander.c    |   2 +-
>  drivers/scsi/libsas/sas_init.c        | 101 +++++++++++++++++++++++++++++-----
>  drivers/scsi/libsas/sas_internal.h    |   7 +++
>  drivers/scsi/libsas/sas_phy.c         |  73 ++++++++++++------------
>  drivers/scsi/libsas/sas_port.c        |  25 +++++----
>  include/scsi/libsas.h                 |  81 ++++++++++++---------------
>  include/scsi/scsi_transport_sas.h     |   1 +
>  14 files changed, 270 insertions(+), 175 deletions(-)
>
