Return-Path: <SRS0=mhd7=ZW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC27C432C0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Nov 2019 02:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1269820869
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Nov 2019 02:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfK3CS4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Nov 2019 21:18:56 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6733 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727142AbfK3CS4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Nov 2019 21:18:56 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5480DFFEACADBA293485;
        Sat, 30 Nov 2019 10:18:53 +0800 (CST)
Received: from [127.0.0.1] (10.173.221.195) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Sat, 30 Nov 2019
 10:18:42 +0800
Subject: Re: [PATCH] scsi: libsas: stop discovering if oob mode is
 disconnected
To:     John Garry <john.garry@huawei.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "jthumshirn@suse.de" <jthumshirn@suse.de>,
        "hch@lst.de" <hch@lst.de>, chenxiang <chenxiang66@hisilicon.com>
References: <20191129032413.36092-1-yanaijie@huawei.com>
 <b59a5d52-f663-2772-fc5d-201eeaed1d52@huawei.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <437a8952-780a-aa5c-d060-c20a530f3808@huawei.com>
Date:   Sat, 30 Nov 2019 10:18:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <b59a5d52-f663-2772-fc5d-201eeaed1d52@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.221.195]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2019/11/29 21:58, John Garry 写道:
> On 29/11/2019 03:24, yanaijie wrote:
>> The discovering of sas port is driving by workqueue in libsas. When
>> libsas is processing port events or phy events in workqueue, new evnets
> 
> /s/evnets/events/
> 
>> may rise up and change the state of some structures such as asd_sas_phy.
>> This may cause some problems such as follows:
>>
>> ==>thread 1                       ==>thread 2
>>
>>                                    ==>phy up
>>                                    ==>phy_up_v3_hw()
>>                                      ==>oob_mode = SATA_OOB_MODE;
>>                                    ==>phy donw quickly
> 
> down
> 
>>                                    ==>hisi_sas_phy_down()
>>                                      ==>sas_ha->notify_phy_event()
>>                                      ==>sas_phy_disconnected()
>>                                        ==>oob_mode = OOB_NOT_CONNECTED
>> ==>workqueue wakeup
>> ==>sas_form_port()
>>    ==>sas_discover_domain()
>>      ==>sas_get_port_device()
>>        ==>oob_mode is OOB_NOT_CONNECTED and device
>>           is wrongly taken as expander
>>
>> This at last lead to the panic when libsas trying to issue a command to
>> discover the device.
>>
>> [183047.614035] Unable to handle kernel NULL pointer dereference at
>> virtual address 0000000000000058
>> [183047.622896] Mem abort info:
>> [183047.625762]   ESR = 0x96000004
>> [183047.628893]   Exception class = DABT (current EL), IL = 32 bits
>> [183047.634888]   SET = 0, FnV = 0
>> [183047.638015]   EA = 0, S1PTW = 0
>> [183047.641232] Data abort info:
>> [183047.644189]   ISV = 0, ISS = 0x00000004
>> [183047.648100]   CM = 0, WnR = 0
>> [183047.651145] user pgtable: 4k pages, 48-bit VAs, pgdp =
>> 00000000b7df67be
>> [183047.657834] [0000000000000058] pgd=0000000000000000
>> [183047.662789] Internal error: Oops: 96000004 [#1] SMP
>> [183047.667740] Process kworker/u16:2 (pid: 31291, stack limit =
>> 0x00000000417c4974)
>> [183047.675208] CPU: 0 PID: 3291 Comm: kworker/u16:2 Tainted: G
>> W  OE 4.19.36-vhulk1907.1.0.h410.eulerosv2r8.aarch64 #1
>> [183047.687015] Hardware name: N/A N/A/Kunpeng Desktop Board D920S10,
>> BIOS 0.15 10/22/2019
>> [183047.695007] Workqueue: 0000:74:02.0_disco_q sas_discover_domain
>> [183047.700999] pstate: 20c00009 (nzCv daif +PAN +UAO)
>> [183047.705864] pc : prep_ata_v3_hw+0xf8/0x230 [hisi_sas_v3_hw]
> 
> Can you explain how we discover an expander device yet try to send an 
> ATA command?

In sas_get_port_device() when oob mode is not SATA_OOB_MODE, we get into 
the branch that use the sas_identify_frame instead of dev_to_host_fis to 
determine the device type and protocal, which is a totally wrong 
structure. And the dev_type is expander, but the tproto is 
SAS_PROTOCOL_SATA or SAS_PROTOCOL_STP in this case:



	if (dev->frame_rcvd[0] == 0x34 && port->oob_mode == SATA_OOB_MODE) {
		struct dev_to_host_fis *fis =
			(struct dev_to_host_fis *) dev->frame_rcvd;
		if (fis->interrupt_reason == 1 && fis->lbal == 1 &&
		    fis->byte_count_low==0x69 && fis->byte_count_high == 0x96
		    && (fis->device & ~0x10) == 0)
			dev->dev_type = SAS_SATA_PM;
		else
			dev->dev_type = SAS_SATA_DEV;
		dev->tproto = SAS_PROTOCOL_SATA;
	} else {
		struct sas_identify_frame *id =
			(struct sas_identify_frame *) dev->frame_rcvd;
		dev->dev_type = id->dev_type;
		dev->iproto = id->initiator_bits;
		dev->tproto = id->target_bits;
	}


> 
>> [183047.711510] lr : prep_ata_v3_hw+0xb0/0x230 [hisi_sas_v3_hw]
>> [183047.717153] sp : ffff00000f28ba60
>> [183047.720541] x29: ffff00000f28ba60 x28: ffff8026852d7228
>> [183047.725925] x27: ffff8027dba3e0a8 x26: ffff8027c05fc200
>> [183047.731310] x25: 0000000000000000 x24: ffff8026bafa8dc0
>> [183047.736695] x23: ffff8027c05fc218 x22: ffff8026852d7228
>> [183047.742079] x21: ffff80007c2f2940 x20: ffff8027c05fc200
>> [183047.747464] x19: 0000000000f80800 x18: 0000000000000010
>> [183047.752848] x17: 0000000000000000 x16: 0000000000000000
>> [183047.758232] x15: ffff000089a5a4ff x14: 0000000000000005
>> [183047.763617] x13: ffff000009a5a50e x12: ffff8026bafa1e20
>> [183047.769001] x11: ffff0000087453b8 x10: ffff00000f28b870
>> [183047.774385] x9 : 0000000000000000 x8 : ffff80007e58f9b0
>> [183047.779770] x7 : 0000000000000000 x6 : 000000000000003f
>> [183047.785154] x5 : 0000000000000040 x4 : ffffffffffffffe0
>> [183047.790538] x3 : 00000000000000f8 x2 : 0000000002000007
>> [183047.795922] x1 : 0000000000000008 x0 : 0000000000000000
>> [183047.801307] Call trace:
>> [183047.803827]  prep_ata_v3_hw+0xf8/0x230 [hisi_sas_v3_hw]
>> [183047.809127]  hisi_sas_task_prep+0x750/0x888 [hisi_sas_main]
>> [183047.814773]  hisi_sas_task_exec.isra.7+0x88/0x1f0 [hisi_sas_main]
>> [183047.820939]  hisi_sas_queue_command+0x28/0x38 [hisi_sas_main]
>> [183047.826757]  smp_execute_task_sg+0xec/0x218
>> [183047.831013]  smp_execute_task+0x74/0xa0
>> [183047.834921]  sas_discover_expander.part.7+0x9c/0x5f8
>> [183047.839959]  sas_discover_root_expander+0x90/0x160
>> [183047.844822]  sas_discover_domain+0x1b8/0x1e8
>> [183047.849164]  process_one_work+0x1b4/0x3f8
>> [183047.853246]  worker_thread+0x54/0x470
>> [183047.856981]  kthread+0x134/0x138
>> [183047.860283]  ret_from_fork+0x10/0x18
>> [183047.863931] Code: f9407a80 528000e2 39409281 72a04002 (b9405800)
>> [183047.870097] kernel fault(0x1) notification starting on CPU 0
>> [183047.875828] kernel fault(0x1) notification finished on CPU 0
>> [183047.881559] Modules linked in: unibsp(OE) hns3(OE) hclge(OE)
>> hnae3(OE) mem_drv(OE) hisi_sas_v3_hw(OE) hisi_sas_main(OE)
>> [183047.892418] ---[ end trace 4cc26083fc11b783  ]---
>> [183047.897107] Kernel panic - not syncing: Fatal exception
>> [183047.902403] kernel fault(0x5) notification starting on CPU 0
>> [183047.908134] kernel fault(0x5) notification finished on CPU 0
>> [183047.913865] SMP: stopping secondary CPUs
>> [183047.917861] Kernel Offset: disabled
>> [183047.921422] CPU features: 0x2,a2a00a38
>> [183047.925243] Memory Limit: none
>> [183047.928372] kernel reboot(0x2) notification starting on CPU 0
>> [183047.934190] kernel reboot(0x2) notification finished on CPU 0
>> [183047.940008] ---[ end Kernel panic - not syncing: Fatal exception
>> ]---
>>
>> Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
> 
> I am not sure if it is appropriate to identify this as what we're 
> fixing, since we changed significantly the event processing in libsas 
> since 2908d778ab3e?
> 

It's ok. Even before 2908d778ab3e we have this issue too. The workqueue 
process is always late and far after the interrupt.

>> Reported-by: Gao Chuan <gaochuan4@huawei.com>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
>>   drivers/scsi/libsas/sas_discover.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_discover.c 
>> b/drivers/scsi/libsas/sas_discover.c
>> index f47b4b281b14..23fdbc8fa05a 100644
>> --- a/drivers/scsi/libsas/sas_discover.c
>> +++ b/drivers/scsi/libsas/sas_discover.c
>> @@ -81,12 +81,18 @@ static int sas_get_port_device(struct asd_sas_port 
>> *port)
>>           else
>>               dev->dev_type = SAS_SATA_DEV;
>>           dev->tproto = SAS_PROTOCOL_SATA;
>> -    } else {
>> +    } else if (port->oob_mode == SAS_OOB_MODE) {
> 
> This just looks racy. We're sending an event and then checking some 
> volatile shared memory in the event processing :(

It's not me doing this. I add this here because the branch above which 
already doing this.

And It's true that it is racy. libsas is doing this all the time, not 
only here. The LLDD and libsas share many structures such as 
asd_sas_port, asd_sas_phy and so on and they access these structures in 
deferent contexts. This is a wrong design.

Or we can delete the
"port->oob_mode == SATA_OOB_MODE" above to fix this issue?

Becuase "dev->frame_rcvd[0] == 0x34" is enough to determine that if this 
is a "dev_to_host_fis" or a "sas_identify_frame":


	if (dev->frame_rcvd[0] == 0x34) {
		struct dev_to_host_fis *fis =
			(struct dev_to_host_fis *) dev->frame_rcvd;
		if (fis->interrupt_reason == 1 && fis->lbal == 1 &&
		    fis->byte_count_low==0x69 && fis->byte_count_high == 0x96
		    && (fis->device & ~0x10) == 0)
			dev->dev_type = SAS_SATA_PM;
		else
			dev->dev_type = SAS_SATA_DEV;
		dev->tproto = SAS_PROTOCOL_SATA;
	} else {
		struct sas_identify_frame *id =
			(struct sas_identify_frame *) dev->frame_rcvd;
		dev->dev_type = id->dev_type;
		dev->iproto = id->initiator_bits;
		dev->tproto = id->target_bits;
	}

> 
>>           struct sas_identify_frame *id =
>>               (struct sas_identify_frame *) dev->frame_rcvd;
>>           dev->dev_type = id->dev_type;
>>           dev->iproto = id->initiator_bits;
>>           dev->tproto = id->target_bits;
>> +    } else {
>> +        /* If the oob mode is OOB_NOT_CONNECTED, the port is
>> +         * disconnected due to race with PHY down. We cannot
>> +         * continue to discover this port */
>> +        sas_put_device(dev);
>> +        return rc;
>>       }
>>       sas_init_dev(dev);
>>
> 
> 
> .

