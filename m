Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D994C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jan 2022 18:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244081AbiANSWW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jan 2022 13:22:22 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4413 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbiANSWV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jan 2022 13:22:21 -0500
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jb8gc0fCyz689Pv;
        Sat, 15 Jan 2022 02:18:36 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 14 Jan 2022 19:22:18 +0100
Received: from [10.47.83.126] (10.47.83.126) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Fri, 14 Jan
 2022 18:22:17 +0000
From:   John Garry <john.garry@huawei.com>
Subject: Re: [issue report] pm8001 issues (was driver crashes with IOMMU
 enabled)
To:     <Ajish.Koshy@microchip.com>, <jinpu.wang@ionos.com>,
        <Viswas.G@microchip.com>
CC:     <linux-scsi@vger.kernel.org>, <vishakhavc@google.com>,
        <ipylypiv@google.com>, <Ruksar.devadi@microchip.com>,
        <damien.lemoal@opensource.wdc.com>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>
References: <894f766f-74b7-62b1-f6d2-82ac85b6478f@huawei.com>
 <CAMGffEkvrAxhrsL=azkVzQHHyDczZwJ3uiNWydSA6o2K+Xh_Jw@mail.gmail.com>
 <00505633-c8c0-8213-8909-482bf43661cd@huawei.com>
 <1cc92b2d-3670-7843-d68a-06fe68521d24@huawei.com>
 <fd0eafc6-9443-fe5e-2c2f-91d6bbe8b174@huawei.com>
 <PH0PR11MB5112EBE80F9A4AD199866CA7EC429@PH0PR11MB5112.namprd11.prod.outlook.com>
 <0cc0c435-b4f2-9c76-258d-865ba50a29dd@huawei.com>
 <PH0PR11MB5112F2D4A506B0FE6DC5B01BEC4D9@PH0PR11MB5112.namprd11.prod.outlook.com>
 <34319d65-104d-55a0-175d-96cf3f0aea89@huawei.com>
 <PH0PR11MB511238B8FF7B44C375DDDFADEC519@PH0PR11MB5112.namprd11.prod.outlook.com>
 <75d042c1-cee5-ce91-e1cb-9e2b7bb1ce72@huawei.com>
 <PH0PR11MB5112E3E9787F20EDEB58D481EC539@PH0PR11MB5112.namprd11.prod.outlook.com>
 <05bec388-946d-057d-20d7-67ebe5f2cfdf@huawei.com>
Message-ID: <477acff4-b9f7-f395-4bb1-c7d4985e2cac@huawei.com>
Date:   Fri, 14 Jan 2022 18:21:58 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <05bec388-946d-057d-20d7-67ebe5f2cfdf@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.83.126]
X-ClientProxiedBy: lhreml722-chm.china.huawei.com (10.201.108.73) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/01/2022 14:17, John Garry wrote:
>>>   From an earlier mail [0] I got the impression that you tested on an 
>>> arm
>>> platform – did you?
>> Yes, with respect to my previous mail update, at that time got the 
>> chance to
>> load the driver on ARM server/enclosure connected in one of our tester's
>> arm server after attaching the controller card.
>> There this error handling issue was observed.
>>
>> The card/driver was never tested or validated on ARM server before,
>> was curious to see the behavior for the first time. Whereas driver
>> loads smoothly on x86 server.
>>
>> Currently busy with some other issues, debugging on ARM server is not
>> planned for now.
>>
> 
> OK, since you do see this same/similar issue with another card on arm 
> then I think that it is safe to assume that it is a driver issue.
> 
> If you can share the dmesg on the arm machine then at least that would 
> be helpful.

I notice that UBSAN complains:

    19.231481] 
================================================================================ 

[   19.239926] UBSAN: shift-out-of-bounds in 
drivers/scsi/pm8001/pm80xx_hwi.c:1743:17
[   19.247490] shift exponent 32 is too large for 32-bit type 'int'
[   19.253490] CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 
5.16.0-rc3-00389-g1758b8fcdbf7 #1018
[   19.261915] Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI 
RC0 - V1.16.01 03/15/2019
[   19.270426] Workqueue: events work_for_cpu_fn
[   19.274777] Call trace:
[   19.277211]  dump_backtrace+0x0/0x1b0
[   19.280863]  show_stack+0x1c/0x30
[   19.284167]  dump_stack_lvl+0x7c/0xa8
[   19.287818]  dump_stack+0x1c/0x38
[   19.291121]  ubsan_epilogue+0x10/0x54
[   19.294771]  __ubsan_handle_shift_out_of_bounds+0x148/0x180
[   19.300332]  pm80xx_chip_interrupt_enable+0x74/0x19c
[   19.305287]  pm8001_pci_probe+0xf8c/0x1610
[   19.309372]  local_pci_probe+0x44/0xb0
[   19.313112]  work_for_cpu_fn+0x20/0x34
[   19.316851]  process_one_work+0x224/0x42c
[   19.320849]  worker_thread+0x204/0x44c
[   19.324585]  kthread+0x174/0x190
[   19.327802]  ret_from_fork+0x10/0x20
[   19.331377] ==========================

Here's the code:
static void
pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
{
#ifdef PM8001_USE_MSIX
	u32 mask;
	mask = (u32)(1 << vec);

	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, (u32)(mask & 0xFFFFFFFF));
	return;
#endif
	pm80xx_chip_intx_interrupt_enable(pm8001_ha);

}

So vec can be >= 32 now and those interrupts are now used - are we 
missing some operations for the upper bits?

Something else I notice is that pm80xx_set_sas_protocol_timer_config() 
is called before the tags are setup in pm8001_init_ccb_tag(), and this 
always fails silently as no tags are available for the command.

I also think that for the tags management, since you use spinlock in 
alloc, spinlock in the free path should also be used, like:

diff --git a/drivers/scsi/pm8001/pm8001_sas.c 
b/drivers/scsi/pm8001/pm8001_sas.c
index 83e73009db5c..0a5e5b5f6975 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -65,7 +65,11 @@ static int pm8001_find_tag(struct sas_task *task, u32 
*tag)
  void pm8001_tag_free(struct pm8001_hba_info *pm8001_ha, u32 tag)
  {
  	void *bitmap = pm8001_ha->tags;
-	clear_bit(tag, bitmap);
+	unsigned long flags;
+
+	spin_lock_irqsave(&pm8001_ha->bitmap_lock, flags);
+	__clear_bit(tag, bitmap);
+	spin_unlock_irqrestore(&pm8001_ha->bitmap_lock, flags);
  }

  /**
@@ -85,7 +89,7 @@ inline int pm8001_tag_alloc(struct pm8001_hba_info 
*pm8001_ha, u32 *tag_out)
  		spin_unlock_irqrestore(&pm8001_ha->bitmap_lock, flags);
  		return -SAS_QUEUE_FULL;
  	}
-	set_bit(tag, bitmap);
+	__set_bit(tag, bitmap);
  	spin_unlock_irqrestore(&pm8001_ha->bitmap_lock, flags);
  	*tag_out = tag;
  	return 0;


Thanks,
John
