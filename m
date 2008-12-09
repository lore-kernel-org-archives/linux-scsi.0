From: "Cheng Renquan" <crquan@gmail.com>
Subject: Re: [PATCH 1/2] mpt fusion: updated mpt drivers from lsi upstream "4.00.43.00"
Date: Tue, 9 Dec 2008 11:35:56 +0800
Message-ID: <91b13c310812081935n7edb610esbb322e57156b8c8f@mail.gmail.com>
References: <1228483610-18502-1-git-send-email-crquan@gmail.com>
	 <20081208140742.1c3a026d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.180]:45655 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbYLIDf7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Dec 2008 22:35:59 -0500
Received: by ik-out-1112.google.com with SMTP id c29so1170250ika.5
        for <linux-scsi@vger.kernel.org>; Mon, 08 Dec 2008 19:35:57 -0800 (PST)
In-Reply-To: <20081208140742.1c3a026d.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Eric Moore <Eric.Moore@lsi.com>
Cc: support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Dec 8, 2008 at 11:17 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2008-12-05 at 21:26 +0800, crquan@gmail.com wrote:
>> From: Cheng Renquan <crquan@gmail.com>
>>
>> this one just can build with mainstream git kernel, I did not even test it.
>>
>> I just have tested it with kernel 2.6.26.2, that patch is very similar to
>> this, and it did work well with 2.6.26.2.
>>
>> Signed-off-by: Cheng Renquan <crquan@gmail.com>
>> ---
>>  drivers/message/fusion/linux_compat.h |    3 +-
>
> I don't quite understand what this patch is about.  This file isn't in
> the upstream and hasn't been for a while if I recall, so what is this
> patch actually patching?

James, please notice the first patch, it's about the mpt vendor
driver, the upstream device vendor maintained three series of mpt
drivers, specially for RHEL3,4,5/SLES8,9,10
but they didn't maintain one for the latest mainstream git kernel,

the first patch (130KB after bzip2'ed) is just replace
drivers/message/fusion/ with code "4.00.43.00" from vendor. You can
extracting the source from vendor into drivers/message/fusion/ instead
of applying this patch.

>>  drivers/message/fusion/mptbase.c      |   10 +-
>>  drivers/message/fusion/mptbase.h      |    6 +-
>>  drivers/message/fusion/mptfc.c        |    4 +-
>>  drivers/message/fusion/mptsas.c       |   14 +---
>>  drivers/message/fusion/mptscsih.c     |  169 +++++++++++++--------------------
>>  drivers/message/fusion/mptscsih.h     |    2 +-
>>  7 files changed, 79 insertions(+), 129 deletions(-)
>>
>> diff --git a/drivers/message/fusion/linux_compat.h b/drivers/message/fusion/linux_compat.h
>> index 24ad3f1..92e9797 100644
>> --- a/drivers/message/fusion/linux_compat.h
>> +++ b/drivers/message/fusion/linux_compat.h
>> @@ -31,7 +31,6 @@ static inline void *shost_private(struct Scsi_Host *shost)
>>  #define spi_dv_pending(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_pending)
>>  #endif
>>
>> -#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23))
>>  /**
>>   * mpt_scsilun_to_int: convert a scsi_lun to an int
>>   * @scsilun:    struct scsi_lun to be converted.
>> @@ -62,7 +61,7 @@ static inline int mpt_scsilun_to_int(struct scsi_lun *scsilun)
>>                                scsilun->scsi_lun[i + 1]) << (i * 8));
>>          return lun;
>>  }
>> -#endif
>> +
>>  #if (defined(CONFIG_SUSE_KERNEL) && !defined(scsi_is_sas_phy_local))
>>  #define SUSE_KERNEL_BASE     1
>>  #endif
>> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
>> index 2979b63..36dd62a 100644
>> --- a/drivers/message/fusion/mptbase.c
>> +++ b/drivers/message/fusion/mptbase.c
>> @@ -1618,7 +1618,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
>>       }
>>  #else
>>       ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
>> -     if (pci_enable_device_bars(pdev, ioc->bars)) {
>> +     if (pci_enable_device(pdev)) {
>
> API reversal.
>
>>               printk(MYIOC_s_ERR_FMT "pci_enable_device_bars() with MEM "
>>                   "failed\n",ioc->name);
>>               return r;
>> @@ -1826,7 +1826,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>>  #endif
>>
>>       /* Initialize workqueue */
>> -     snprintf(ioc->reset_work_q_name, KOBJ_NAME_LEN, "mpt_poll_%d", ioc->id);
>> +     snprintf(ioc->reset_work_q_name, sizeof(ioc->reset_work_q_name),
>> +                     "mpt_poll_%d", ioc->id);
>>       ioc->reset_work_q =
>>               create_singlethread_workqueue(ioc->reset_work_q_name);
>>       if (!ioc->reset_work_q) {
>> @@ -1949,7 +1950,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>>
>>       INIT_LIST_HEAD(&ioc->fw_event_list);
>>       spin_lock_init(&ioc->fw_event_lock);
>> -     snprintf(ioc->fw_event_q_name, KOBJ_NAME_LEN, "mpt/%d", ioc->id);
>> +     snprintf(ioc->fw_event_q_name, sizeof(ioc->fw_event_q_name),
>> +                     "mpt/%d", ioc->id);
>>       ioc->fw_event_q = create_singlethread_workqueue(ioc->fw_event_q_name);
>>
>>       if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
>> @@ -2303,7 +2305,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
>>               pci_release_selected_regions(ioc->pcidev, ioc->bars);
>>               ioc->bars = pci_select_bars(ioc->pcidev, IORESOURCE_MEM |
>>                   IORESOURCE_IO);
>> -             if (pci_enable_device_bars(ioc->pcidev, ioc->bars))
>> +             if (pci_enable_device(ioc->pcidev))
>
> Things like this are reversing kernel API changes and can't go in.

All the work in the second patch is just let it can build.

The vendor driver "4.00.43.00" is for RHEL5.1 (2.6.18-53.el5), and
cannot build on 2.6.26 and latest git kernel,

with applying the second patch, it can build. I have tested it, and
verified that it fixed the bug described on:

http://bugzilla.kernel.org/show_bug.cgi?id=12163


>
> What you need to do is isolate the necessary changes to current git head
> (or scsi-misc) and then send it to the LSI maintainers.  The route to
> inclusion is via them.

Yes, I have tried, but the vendor LSI people just ignored, they were
not co-operative, then how we can deal?

Again, I hope LSI people in the Cc'ed list can read this mail and give replies.

>
> Alternatively, we can just continue on with debugging the actual problem
> you have rather than trying to upport some vendor driver.

That approach almost cannot solve the bug, we don't have the
card/firmware specification, the debugging will be very hard.

>
> James

On Tue, Dec 9, 2008 at 6:07 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> (off-list)
>
> On Fri,  5 Dec 2008 21:26:49 +0800
> crquan@gmail.com wrote:
>
>> Occasionally I'm working with LSI SAS 1068E controllers on 2.6.26.2 kernel,
>> it has a nasty bug that some hotplugged disks cannot be auto discovered,
>> the detailed description is on bugzilla.kernel:
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=12163
>>
>> After some inspecting the vendor's website, I found there are "4.00.43.00"
>> drivers for RHEL5.1, but the drivers in main stream kernel are still "3.04.07",
>> and the changelogs of "4.00.43.00" have records on solving that BUG,
>>
>> but the default "4.00.43.00" downloaded from lsi.com cannot even build on
>> kernel-2.6.26.2, and after some work, I get it run on 2.6.26.2, then can build
>> with mainstream git kernel (the HEAD currently),
>>
>> http://www.lsi.com/storage_home/products_home/standard_product_ics/sas_ics/lsisas1068e/index.html
>>

>>    -#define MPT_LINUX_VERSION_COMMON  "3.04.07"
>>    +#define MPT_LINUX_VERSION_COMMON  "4.00.43.00"

Please James notice this, the major version difference, but the mpt in
the mainstream is "3.04.07", outdated.

>> This patch is just the upstream "4.00.43.00", it's very big, about 130K after
>> bzip2'ed
>
> Eric, is this as bad as it looks?  LSI's driver is 130kbytes and a
> major version increment ahead of the mainline driver?
>
> If so, is there anything we can do to bring the mainline driver more
> up-to-date and to keep it there?  Should we (ie: me, James, distros,
> etc) be seeking additional developers to help make all this happen?

Cool, if Eric can read this, I'm willing to help make all this happen.


>
> Thanks.
>


Thanks.

-- 
Cheng Renquan, Shenzhen, China
Marie von Ebner-Eschenbach  - "Even a stopped clock is right twice a day."
