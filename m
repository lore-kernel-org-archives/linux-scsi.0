Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B18EC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 17:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B01164E7A
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 17:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhBARR7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:17:59 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2468 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhBARR4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 12:17:56 -0500
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DTvdc5YNNz67flr;
        Tue,  2 Feb 2021 01:12:36 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 1 Feb 2021 18:17:12 +0100
Received: from [10.47.11.37] (10.47.11.37) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Mon, 1 Feb 2021
 17:17:11 +0000
Subject: Re: [RFC/RFT PATCH] scsi: pm8001: Expose HW queues for pm80xx hw
To:     <Viswas.G@microchip.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <akshatzen@google.com>,
        <Ruksar.devadi@microchip.com>, <radha@google.com>,
        <bjashnani@google.com>, <vishakhavc@google.com>,
        <jinpu.wang@cloud.ionos.com>, <Ashokkumar.N@microchip.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hare@suse.de>, <kashyap.desai@broadcom.com>, <ming.lei@redhat.com>
References: <1609845423-110410-1-git-send-email-john.garry@huawei.com>
 <SN6PR11MB34882CBBF9CF1C6EA2C50EB29DB79@SN6PR11MB3488.namprd11.prod.outlook.com>
 <0a20dc79-a462-f3fb-14af-db151b688e5a@huawei.com>
 <SN6PR11MB34882607FCD824C9C790AEFC9DB69@SN6PR11MB3488.namprd11.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <1b491d44-996c-2131-2eb6-5348460f9b5b@huawei.com>
Date:   Mon, 1 Feb 2021 17:15:44 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB34882607FCD824C9C790AEFC9DB69@SN6PR11MB3488.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.11.37]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/02/2021 17:08, Viswas.G@microchip.com wrote:
> Hi John,
> 
> AFAIK, there is no such restrictions. Any queue can be used for internal/external commands.
> 

ok, understood.

BTW, to see even more performance improvement, it would be good to use 
request->tag for ccb tag, rather that the LLDD manage this itself. I 
mentioned this perviously elsewhere. Do you plan to make that change? 
hisi_sas and megaraid sas are examples of drivers who do this.

Thanks,
John

> Regards,
> Viswas G
> 
>> -----Original Message-----
>> From: John Garry <john.garry@huawei.com>
>> Sent: Monday, February 1, 2021 4:53 PM
>> To: Viswas G - I30667 <Viswas.G@microchip.com>; jejb@linux.ibm.com;
>> martin.petersen@oracle.com; akshatzen@google.com; Ruksar Devadi -
>> I52327 <Ruksar.devadi@microchip.com>; radha@google.com;
>> bjashnani@google.com; vishakhavc@google.com;
>> jinpu.wang@cloud.ionos.com; Ashokkumar N - X53535
>> <Ashokkumar.N@microchip.com>
>> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; hare@suse.de;
>> kashyap.desai@broadcom.com; ming.lei@redhat.com
>> Subject: Re: [RFC/RFT PATCH] scsi: pm8001: Expose HW queues for pm80xx
>> hw
>>
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>> content is safe
>>
>> On 31/01/2021 07:19, Viswas.G@microchip.com wrote:
>>> Thanks Johns.
>>>
>>> We could see a kernel crash while testing this patch.
>>
>> Thanks for testing.
>>
>>>
>>> [  246.724632] scsi host10: pm80xx
>>> [  248.005258] sas: Enter sas_scsi_recover_host busy: 0 failed: 0 [
>>> 248.168973] BUG: kernel NULL pointer dereference, address:
>>> 0000000000000110 [  248.175926] #PF: supervisor read access in kernel
>>> mode [  248.181065] #PF: error_code(0x0000) - not-present page [
>>> 248.186196] PGD 0 P4D 0 [  248.188736] Oops: 0000 [#1] SMP PTI
>>> [  248.192230] CPU: 10 PID: 77 Comm: kworker/u26:2 Kdump: loaded
>> Tainted: G S         OE     5.11.0-rc3 #2
>>> [  248.201614] Hardware name: Supermicro Super Server/X10DRi-LN4+,
>>> BIOS 3.1 06/08/2018 [  248.209258] Workqueue: events_unbound
>>> async_run_entry_fn [  248.214571] RIP:
>>> 0010:pm80xx_chip_sata_req+0x7f/0x5e0 [pm80xx] [  248.220413] Code: c1
>>> 7c c1 e9 03 4d 8b ac 24 80 01 00 00 48 c7 44 24 14 00 00 00 00 89 04
>>> 24 31 c0 48 c7 84 24 88 00 00 00 00 00 00 00 f3 48 ab <48> 8b ba 10 01
>>> 00 00 e8 35 35 c6 ef c1 e8 10 89 44 24 04 0f b6 43 [  248.239157] RSP:
>>> 0018:ffffb98d834979f0 EFLAGS: 00010046 [  248.244384] RAX:
>>> 0000000000000000 RBX: ffff9523c321c000 RCX: 0000000000000000 [
>>> 248.251516] RDX: 0000000000000000 RSI: ffff952450720048 RDI:
>>> ffffb98d83497a80 [  248.258641] RBP: ffff9523c7420000 R08:
>>> 0000000000000100 R09: 0000000000000001 [  248.265764] R10:
>>> 0000000000000001 R11: ffff9523c9e40000 R12: ffff9523ca1c3600 [
>>> 248.272887] R13: ffff9523c9e40000 R14: ffffb98d83497a04 R15:
>> ffff952450720048 [  248.280013] FS:  0000000000000000(0000)
>> GS:ffff9527afd00000(0000) knlGS:0000000000000000 [  248.288090] CS:  0010
>> DS: 0000 ES: 0000 CR0: 0000000080050033 [  248.293826] CR2:
>> 0000000000000110 CR3: 000000029ac10001 CR4: 00000000001706e0 [
>> 248.300952] Call Trace:
>>
>> I think that the problem here is that ata_queued_cmd->scmd is NULL for the
>> ata internal command.
>>
>> Please try this fix:
>>
>> ---->8-----
>>
>> @@ -4451,7 +4451,7 @@ static int pm80xx_chip_sata_req(struct
>> pm8001_hba_info *pm8001_ha,
>>          struct scsi_cmnd *scmd = qc->scsicmd;
>>          u32 tag = ccb->ccb_tag;
>>          int ret;
>> -       u32 q_index, blk_tag;
>> +       u32 q_index = 0, blk_tag;
>>          struct sata_start_req sata_cmd;
>>          u32 hdr_tag, ncg_tag = 0;
>>          u64 phys_addr, start_addr, end_addr; @@ -4463,8 +4463,10 @@ static
>> int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>>          u32 opc = OPC_INB_SATA_HOST_OPSTART;
>>          memset(&sata_cmd, 0, sizeof(sata_cmd));
>>
>> -       blk_tag = blk_mq_unique_tag(scmd->request);
>> -       q_index = blk_mq_unique_tag_to_hwq(blk_tag);
>> +       if (scmd) {
>> +               blk_tag = blk_mq_unique_tag(scmd->request);
>> +               q_index = blk_mq_unique_tag_to_hwq(blk_tag);
>> +       }
>>          circularQ = &pm8001_ha->inbnd_q_tbl[q_index];
>>
>> ----8<-----
>>
>> You may need similar for other dispatch paths also - like smp - but I don't
>> think that you will.
>>
>> BTW, do you know if there is actually a limitation on the HW that queue
>> #0 is used for all "internal" IO (mpi), like phy control operation? Jack?
>>
>> Thanks,
>> John
>>
>>
>>> [  248.303402]  pm8001_task_exec.isra.9+0x2a4/0x460 [pm80xx] [
>>> 248.308805]  sas_ata_qc_issue+0x187/0x220 [libsas] [  248.313607]
>>> ata_qc_issue+0x107/0x1e0 [libata] [  248.318069]
>>> ata_exec_internal_sg+0x2c8/0x580 [libata] [  248.323217]
>>> ata_exec_internal+0x5f/0x90 [libata] [  248.327931]
>>> ata_dev_read_id+0x306/0x480 [libata] [  248.332647]
>>> ata_eh_recover+0x7ea/0x12a0 [libata] [  248.337369]  ?
>>> vprintk_emit+0x114/0x220 [  248.341208]  ? sas_ata_sched_eh+0x60/0x60
>>> [libsas] [  248.346002]  ? sas_ata_prereset+0x50/0x50 [libsas] [
>>> 248.350795]  ? printk+0x58/0x6f [  248.353941]  ?
>>> sas_ata_sched_eh+0x60/0x60 [libsas] [  248.358733]  ?
>>> sas_ata_prereset+0x50/0x50 [libsas] [  248.363525]
>>> ata_do_eh+0x40/0xb0 [libata] [  248.367556]
>>> ata_scsi_port_error_handler+0x354/0x770 [libata] [  248.373318]
>>> async_sas_ata_eh+0x44/0x7b [libsas] [  248.377938]
>>> async_run_entry_fn+0x39/0x160 [  248.382040]
>>> process_one_work+0x1cb/0x360 [  248.386050]
>> worker_thread+0x30/0x370
>>> [  248.389706]  ? processe_work+0x360/0x360 [  248.393884]
>>> kthread+0x116/0x130 [  248.397116]  ? kthread_park+0x80/0x80 [
>>> 248.400773]  ret_from_fork+0x22/0x30 [  248.404355] Modules linked in:
>>> pm80xx(OE) libsas scsi_transport_sas xt_CHECKSUM xt_MASQUERADE
>>> xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_counter
>> nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables
>> nfnetlink tun bridge stp llc rfkill sunrpc vfat fat intel_rapl_msr
>> intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp
>> coretemp kvm_intel kvm irqbypass joydev crct10dif_pclmul crc32_pclmul
>> ghash_clmulni_intel ipmi_ssif iTCO_wdt iTCO_vendor_support mei_me rapl
>> i2c_i801 intel_cstate mei acpi_ipmi lpc_ich intel_uncore pcspkr ipmi_si
>> i2c_smbus ipmi_devintf ipmi_msghandler acpi_power_meter acpi_pad
>> ioatdma ip_tables xfs libcrc32c sr_mod sd_mod cdrom t10_pi sg ast
>> drm_vram_helper drm_kms_helper syscopyarea igb sysfillrect sysimgblt
>> fb_sys_fops drm_ttm_helper ttm ahci libahci dca drm crc32c_intel libata
>> i2c_algo_bit wmi dm_mirror dm_region_hash dm_log dm_mod fuse [
>> 248.483431] CR2: 0000000000000110
>>> [    0.000000] Linux version 5.11.0-rc3 (root@localhost.localdomain) (gcc
>> (GCC) 8.3.1 20191121 (Red Hat 8.3.1-5), GNU ld version 2.30-79.el8) #2 SMP
>> Mon Jan 25 23:56:12 IST 2021
>>> [    0.000000] Command line: elfcorehr=0x45000000
>> BOOT_IMAGE=(hd14,gpt2)/vmlinuz-5.11.0-rc3 ro
>> resume=/dev/mapper/rhel-swap rhgb console=ttyS1,115200 loglevel=7
>> irqpoll nr_cpus=1 reset_devices cgroup_disable=memory mce=off numa=off
>> udev.children-max=2 panic=10 rootflags=nofail acpi_no_memhotplug
>> transparent_hugepage=never nokaslr novmcoredd hest_disable
>> disable_cpu_apicid=0
>>>
>>>
>>>> -----Original Message-----
>>>> From: John Garry <john.garry@huawei.com>
>>>> Sent: Tuesday, January 5, 2021 4:47 PM
>>>> To: jejb@linux.ibm.com; martin.petersen@oracle.com;
>>>> akshatzen@google.com; Viswas G - I30667 <Viswas.G@microchip.com>;
>>>> Ruksar Devadi - I52327 <Ruksar.devadi@microchip.com>;
>>>> radha@google.com; bjashnani@google.com; vishakhavc@google.com;
>>>> jinpu.wang@cloud.ionos.com; Ashokkumar N - X53535
>>>> <Ashokkumar.N@microchip.com>
>>>> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
>>>> hare@suse.de; kashyap.desai@broadcom.com; ming.lei@redhat.com;
>> John
>>>> Garry <john.garry@huawei.com>
>>>> Subject: [RFC/RFT PATCH] scsi: pm8001: Expose HW queues for pm80xx
>> hw
>>>>
>>>> EXTERNAL EMAIL: Do not click links or open attachments unless you
>>>> know the content is safe
>>>>
>>>> In commit 05c6c029a44d ("scsi: pm80xx: Increase number of supported
>>>> queues"), support for 80xx chip was improved by enabling multiple HW
>>>> queues.
>>>>
>>>> In this, like other SCSI MQ HBA drivers, the HW queues were not
>>>> exposed to upper layer, and instead the driver managed the queues
>> internally.
>>>>
>>>> However, this management duplicates blk-mq code. In addition, the HW
>>>> queue management is sub-optimal for a system where the number of
>> CPUs
>>>> exceeds the HW queues - this is because queues are selected in a
>>>> round- robin fashion, when it would be better to make adjacent CPUs
>>>> submit on the same queue. And finally, the affinity of the completion
>>>> queue interrupts is not set to mirror the cpu<->HQ queue mapping, which
>> is suboptimal.
>>>>
>>>> As such, for when MSIX is supported, expose HW queues to upper layer.
>>>> Flag PCI_IRQ_AFFINITY is set for allocating the MSIX vectors to
>>>> automatically assign affinity for the completion queue interrupts.
>>>>
>>>> Signed-off-by: John Garry <john.garry@huawei.com>
>>>>
>>>> ---
>>>> I sent as an RFC/RFT as I have no HW to test. In addition, since HW
>>>> queue
>>>> #0 is used always for internal commands (like in send_task_abort()),
>>>> if all CPUs associated with HW queue #0 are offlined, the interrupt
>>>> for that queue will be shutdown, and no CPUs would be available to
>>>> service any internal commands completion. To solve that, we need [0]
>>>> merged first and switch over to use the new API. But we can still test
>> performance in the meantime.
>>>>
>>>> I assume someone else is making the change to use the request tag for
>>>> IO tag management.
>>>>
>>>> [0] https://lore.kernel.org/linux-scsi/47ba045e-a490-198b-1744-
>>>> 529f97192d3b@suse.de/
>>>>
>>>> diff --git a/drivers/scsi/pm8001/pm8001_init.c
>>>> b/drivers/scsi/pm8001/pm8001_init.c
>>>> index ee2de177d0d0..73479803a23e 100644
>>>> --- a/drivers/scsi/pm8001/pm8001_init.c
>>>> +++ b/drivers/scsi/pm8001/pm8001_init.c
>>>> @@ -81,6 +81,15 @@ LIST_HEAD(hba_list);
>>>>
>>>>    struct workqueue_struct *pm8001_wq;
>>>>
>>>> +static int pm8001_map_queues(struct Scsi_Host *shost) {
>>>> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
>>>> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
>>>> +       struct blk_mq_queue_map *qmap =
>>>> +&shost->tag_set.map[HCTX_TYPE_DEFAULT];
>>>> +
>>>> +       return blk_mq_pci_map_queues(qmap, pm8001_ha->pdev, 0); }
>>>> +
>>>>    /*
>>>>     * The main structure which LLDD must register for scsi core.
>>>>     */
>>>> @@ -106,6 +115,7 @@ static struct scsi_host_template pm8001_sht = {
>>>> #ifdef CONFIG_COMPAT
>>>>           .compat_ioctl           = sas_ioctl,
>>>>    #endif
>>>> +       .map_queues                     = pm8001_map_queues,
>>>>           .shost_attrs            = pm8001_host_attrs,
>>>>           .track_queue_depth      = 1,
>>>>    };
>>>> @@ -923,9 +933,8 @@ static int pm8001_configure_phy_settings(struct
>>>> pm8001_hba_info *pm8001_ha)  static u32 pm8001_setup_msix(struct
>>>> pm8001_hba_info *pm8001_ha)  {
>>>>           u32 number_of_intr;
>>>> -       int rc, cpu_online_count;
>>>> +       int rc;
>>>>           unsigned int allocated_irq_vectors;
>>>> -
>>>>           /* SPCv controllers supports 64 msi-x */
>>>>           if (pm8001_ha->chip_id == chip_8001) {
>>>>                   number_of_intr = 1;
>>>> @@ -933,16 +942,15 @@ static u32 pm8001_setup_msix(struct
>>>> pm8001_hba_info *pm8001_ha)
>>>>                   number_of_intr = PM8001_MAX_MSIX_VEC;
>>>>           }
>>>>
>>>> -       cpu_online_count = num_online_cpus();
>>>> -       number_of_intr = min_t(int, cpu_online_count, number_of_intr);
>>>> -       rc = pci_alloc_irq_vectors(pm8001_ha->pdev, number_of_intr,
>>>> -                       number_of_intr, PCI_IRQ_MSIX);
>>>> +       /* Use default affinity descriptor, which spreads *all* vectors */
>>>> +       rc = pci_alloc_irq_vectors(pm8001_ha->pdev, 1,
>>>> +                       number_of_intr, PCI_IRQ_MSIX |
>>>> + PCI_IRQ_AFFINITY);
>>>>           allocated_irq_vectors = rc;
>>>>           if (rc < 0)
>>>>                   return rc;
>>>>
>>>>           /* Assigns the number of interrupts */
>>>> -       number_of_intr = min_t(int, allocated_irq_vectors, number_of_intr);
>>>> +       number_of_intr = allocated_irq_vectors;
>>>>           pm8001_ha->number_of_intr = number_of_intr;
>>>>
>>>>           /* Maximum queue number updating in HBA structure */ @@
>>>> -1113,6
>>>> +1121,16 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>>>>           if (rc)
>>>>                   goto err_out_enable;
>>>>
>>>> +       if (pm8001_ha->number_of_intr > 1) {
>>>> +               shost->nr_hw_queues = pm8001_ha->number_of_intr;
>>>> +               /*
>>>> +                * For now, ensure we're not sent too many commands by
>> setting
>>>> +                * host_tagset. This is also required if we start using request
>>>> +                * tag.
>>>> +                */
>>>> +               shost->host_tagset = 1;
>>>> +       }
>>>> +
>>>>           rc = scsi_add_host(shost, &pdev->dev);
>>>>           if (rc)
>>>>                   goto err_out_ha_free; diff --git
>>>> a/drivers/scsi/pm8001/pm8001_sas.h
>>>> b/drivers/scsi/pm8001/pm8001_sas.h
>>>> index f2c8cbad3853..74bc6fed693e 100644
>>>> --- a/drivers/scsi/pm8001/pm8001_sas.h
>>>> +++ b/drivers/scsi/pm8001/pm8001_sas.h
>>>> @@ -55,6 +55,8 @@
>>>>    #include <scsi/scsi_tcq.h>
>>>>    #include <scsi/sas_ata.h>
>>>>    #include <linux/atomic.h>
>>>> +#include <linux/blk-mq.h>
>>>> +#include <linux/blk-mq-pci.h>
>>>>    #include "pm8001_defs.h"
>>>>
>>>>    #define DRV_NAME               "pm80xx"
>>>> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c
>>>> b/drivers/scsi/pm8001/pm80xx_hwi.c
>>>> index 6772b0924dac..31d65ce91e7d 100644
>>>> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
>>>> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
>>>> @@ -4299,12 +4299,13 @@ static int pm80xx_chip_ssp_io_req(struct
>>>> pm8001_hba_info *pm8001_ha,
>>>>           struct domain_device *dev = task->dev;
>>>>           struct pm8001_device *pm8001_dev = dev->lldd_dev;
>>>>           struct ssp_ini_io_start_req ssp_cmd;
>>>> +       struct scsi_cmnd *scmd = task->uldd_task;
>>>>           u32 tag = ccb->ccb_tag;
>>>>           int ret;
>>>>           u64 phys_addr, start_addr, end_addr;
>>>>           u32 end_addr_high, end_addr_low;
>>>>           struct inbound_queue_table *circularQ;
>>>> -       u32 q_index, cpu_id;
>>>> +       u32 blk_tag, q_index;
>>>>           u32 opc = OPC_INB_SSPINIIOSTART;
>>>>           memset(&ssp_cmd, 0, sizeof(ssp_cmd));
>>>>           memcpy(ssp_cmd.ssp_iu.lun, task->ssp_task.LUN, 8); @@
>>>> -4323,8
>>>> +4324,8 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info
>>>> *pm8001_ha,
>>>>           ssp_cmd.ssp_iu.efb_prio_attr |= (task->ssp_task.task_attr & 7);
>>>>           memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cmd->cmnd,
>>>>                          task->ssp_task.cmd->cmd_len);
>>>> -       cpu_id = smp_processor_id();
>>>> -       q_index = (u32) (cpu_id) % (pm8001_ha->max_q_num);
>>>> +       blk_tag = blk_mq_unique_tag(scmd->request);
>>>> +       q_index = blk_mq_unique_tag_to_hwq(blk_tag);
>>>>           circularQ = &pm8001_ha->inbnd_q_tbl[q_index];
>>>>
>>>>           /* Check if encryption is set */ @@ -4446,9 +4447,11 @@
>>>> static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>>>>           struct sas_task *task = ccb->task;
>>>>           struct domain_device *dev = task->dev;
>>>>           struct pm8001_device *pm8001_ha_dev = dev->lldd_dev;
>>>> +       struct ata_queued_cmd *qc = task->uldd_task;
>>>> +       struct scsi_cmnd *scmd = qc->scsicmd;
>>>>           u32 tag = ccb->ccb_tag;
>>>>           int ret;
>>>> -       u32 q_index, cpu_id;
>>>> +       u32 q_index, blk_tag;
>>>>           struct sata_start_req sata_cmd;
>>>>           u32 hdr_tag, ncg_tag = 0;
>>>>           u64 phys_addr, start_addr, end_addr; @@ -4459,8 +4462,9 @@
>>>> static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>>>>           unsigned long flags;
>>>>           u32 opc = OPC_INB_SATA_HOST_OPSTART;
>>>>           memset(&sata_cmd, 0, sizeof(sata_cmd));
>>>> -       cpu_id = smp_processor_id();
>>>> -       q_index = (u32) (cpu_id) % (pm8001_ha->max_q_num);
>>>> +
>>>> +       blk_tag = blk_mq_unique_tag(scmd->request);
>>>
>>> Here the scsi command is NULL.
>>>
>>>     if(scmd) {
>>>                   blk_tag = blk_mq_unique_tag(scmd->request);
>>>                   q_index = blk_mq_unique_tag_to_hwq(blk_tag);
>>>           } else {
>>>                   q_index = 0;
>>>     }
>>>
>>> With this change, we have started our testing. We will update you the
>> result soon.
>>>
>>>> +       q_index = blk_mq_unique_tag_to_hwq(blk_tag);
>>>>           circularQ = &pm8001_ha->inbnd_q_tbl[q_index];
>>>>
>>>>           if (task->data_dir == DMA_NONE) {
>>>> --
>>>> 2.26.2
>>>
>>> .
>>>
> 

