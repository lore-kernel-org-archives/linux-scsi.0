Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC13CC33CA1
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 14:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B030E2072A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 14:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgAHOu6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 09:50:58 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2237 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726697AbgAHOu6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jan 2020 09:50:58 -0500
Received: from lhreml709-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 0093749BC070E3369E34;
        Wed,  8 Jan 2020 14:50:56 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml709-cah.china.huawei.com (10.201.108.32) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 8 Jan 2020 14:50:55 +0000
Received: from [127.0.0.1] (10.202.226.43) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 8 Jan 2020
 14:50:55 +0000
Subject: Re: [PATCH v1] driver core: Use list_del_init to replace list_del at
 device_links_purge()
To:     Greg KH <gregkh@linuxfoundation.org>,
        Luo Jiaxing <luojiaxing@huawei.com>
CC:     <saravanak@google.com>, <jejb@linux.ibm.com>,
        <James.Bottomley@hansenpartnership.com>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <1578483244-50723-1-git-send-email-luojiaxing@huawei.com>
 <20200108122658.GA2365903@kroah.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <73252c08-ac46-5d0d-23ec-16c209bd9b9a@huawei.com>
Date:   Wed, 8 Jan 2020 14:50:54 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200108122658.GA2365903@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.43]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/01/2020 12:26, Greg KH wrote:
> On Wed, Jan 08, 2020 at 07:34:04PM +0800, Luo Jiaxing wrote:
>> We found that enabling kernel compilation options CONFIG_SCSI_ENCLOSURE and
>> CONFIG_ENCLOSURE_SERVICES, repeated initialization and deletion of the same
>> SCSI device will cause system panic, as follows:
>> [72.425705] Unable to handle kernel paging request at virtual address
>> dead000000000108
>> ...
>> [72.595093] Call trace:
>> [72.597532] device_del + 0x194 / 0x3a0
>> [72.601012] enclosure_remove_device + 0xbc / 0xf8
>> [72.605445] ses_intf_remove + 0x9c / 0xd8
>> [72.609185] device_del + 0xf8 / 0x3a0
>> [72.612576] device_unregister + 0x14 / 0x30
>> [72.616489] __scsi_remove_device + 0xf4 / 0x140
>> [72.620747] scsi_remove_device + 0x28 / 0x40
>> [72.624745] scsi_remove_target + 0x1c8 / 0x220
>>
>> After analysis, we see that in the error scenario, the ses module has the
>> following calling sequence:
>> device_register() -> device_del() -> device_add() -> device_del().
>> The first call to device_del() is fine, but the second call to device_del()
>> will cause a system panic.
> 
> Is this all on the same device structure?  If so, that's not ok, you
> can't do that, once device_del() is called on the memory location, you
> can not call device_add() on it again.
> 
> How are you triggering this from userspace?

This can be triggered by causing the SCSI device to be lost, found, and 
lost again:

root@(none)$ pwd
/sys/class/sas_phy/phy-0:0:2
root@(none)$ echo 0 > enable
[   48.828139] sas: smp_execute_task_sg: task to dev 500e004aaaaaaa1f 
response: 0x0 status 0x2
root@(none)$
[   48.837040] sas: ex 500e004aaaaaaa1f phy02 change count has changed
[   48.846961] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   48.852120] sd 0:0:0:0: [sda] Synchronize Cache(10) failed: Result: 
hostbyte=0x04 driverbyte=0x00
[   48.898111] hisi_sas_v3_hw 0000:74:02.0: dev[2:1] is gone

root@(none)$ echo 1 > enable
root@(none)$
[   51.967416] sas: ex 500e004aaaaaaa1f phy02 change count has changed
[   51.974022] hisi_sas_v3_hw 0000:74:02.0: dev[7:1] found
[   51.991305] scsi 0:0:5:0: Direct-Access     SEAGATE  ST2000NM0045 
N004 PQ: 0 ANSI: 6
[   52.003609] sd 0:0:5:0: [sda] 3907029168 512-byte logical blocks: 
(2.00 TB/1.82 TiB)
[   52.012010] sd 0:0:5:0: [sda] Write Protect is off
[   52.022643] sd 0:0:5:0: [sda] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[   52.052429]  sda: sda1
[   52.064439] sd 0:0:5:0: [sda] Attached SCSI disk

root@(none)$ echo 0 > enable
[   54.112100] sas: smp_execute_task_sg: task to dev 500e004aaaaaaa1f 
response: 0x0 status 0x2
root@(none)$ [   54.120909] sas: ex 500e004aaaaaaa1f phy02 change count 
has changed
[   54.130202] Unable to handle kernel paging request at virtual address 
dead000000000108
[   54.138110] Mem abort info:
[   54.140892]   ESR = 0x96000044
[   54.143936]   EC = 0x25: DABT (current EL), IL = 32 bits
[   54.149236]   SET = 0, FnV = 0
[   54.152278]   EA = 0, S1PTW = 0
[   54.155408] Data abort info:
[   54.158275]   ISV = 0, ISS = 0x00000044
[   54.162098]   CM = 0, WnR = 1
[   54.165055] [dead000000000108] address between user and kernel 
address ranges
[   54.172179] Internal error: Oops: 96000044 [#1] PREEMPT SMP
[   54.177737] Modules linked in:
[   54.180780] CPU: 5 PID: 741 Comm: kworker/u192:2 Not tainted 
5.5.0-rc5-dirty #1535
[   54.188334] Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI 
RC0 - V1.16.01 03/15/2019
[   54.196847] Workqueue: 0000:74:02.0_disco_q sas_revalidate_domain
[   54.202927] pstate: 60c00009 (nZCv daif +PAN +UAO)
[   54.207705] pc : device_del+0x194/0x398
[   54.211527] lr : device_del+0x190/0x398
[   54.215349] sp : ffff80001cc7bb20
[   54.218650] x29: ffff80001cc7bb20 x28: ffff0023be042188
[   54.223948] x27: ffff0023c04c0000 x26: ffff0023be042000
[   54.229246] x25: ffff8000119f0f30 x24: ffff0023be268a30
[   54.234544] x23: ffff0023be268018 x22: ffff800011879000
[   54.239842] x21: ffff8000119f0000 x20: ffff8000119f06e0
[   54.245140] x19: ffff0023be268990 x18: 0000000000000004
[   54.250438] x17: 0000000000000007 x16: 0000000000000001
[   54.255736] x15: ffff0023eac13610 x14: ffff0023eb74a7f8
[   54.261034] x13: 0000000000000000 x12: ffff0023eac13610
[   54.266332] x11: ffff0023eb74a6c8 x10: 0000000000000000
[   54.271630] x9 : ffff0023eac13618 x8 : 0000000040040000
[   54.276928] x7 : 0000000000000000 x6 : ffff0023be268a90
[   54.282226] x5 : ffff0023be74aa00 x4 : 0000000000000000
[   54.287524] x3 : ffff8000119f0f30 x2 : dead000000000100
[   54.292821] x1 : dead000000000122 x0 : 0000000000000000
[   54.298119] Call trace:
[   54.300553]  device_del+0x194/0x398
[   54.304030]  enclosure_remove_device+0xb4/0x100
[   54.308548]  ses_intf_remove+0x98/0xd8
[   54.312283]  device_del+0xfc/0x398
[   54.315671]  device_unregister+0x14/0x30
[   54.319580]  __scsi_remove_device+0xf0/0x130
[   54.323836]  scsi_remove_device+0x28/0x40
[   54.327832]  scsi_remove_target+0x1bc/0x250
[   54.332002]  sas_rphy_remove+0x5c/0x60
[   54.335738]  sas_rphy_delete+0x14/0x28
[   54.339473]  sas_destruct_devices+0x5c/0x98
[   54.343642]  sas_revalidate_domain+0xa0/0x178
[   54.347986]  process_one_work+0x1e0/0x358
[   54.351982]  worker_thread+0x40/0x488
[   54.355631]  kthread+0x118/0x120
[   54.358846]  ret_from_fork+0x10/0x18
[   54.362410] Code: 91028278 aa1903e0 9415f01f a94c0662 (f9000441)
[   54.368489] ---[ end trace 38c672fcf89c95f7 ]---

I tested on v5.4 and no such issue, but maybe the driver core changes 
have exposed a ses/enclosure issue.

Checking:

int enclosure_remove_device(struct enclosure_device *edev, struct device 
*dev)
{
	struct enclosure_component *cdev;
	int i;

	if (!edev || !dev)
		return -EINVAL;

	for (i = 0; i < edev->components; i++) {
		cdev = &edev->component[i];
		if (cdev->dev == dev) {
			enclosure_remove_links(cdev);
			device_del(&cdev->cdev);
			put_device(dev);
			cdev->dev = NULL;
			return device_add(&cdev->cdev);
		}
	}
	return -ENODEV;
}

This has device_del(&cdev->cdev) followed by device_add(&cdev->cdev).

This cdev.dev memory looks to be dynamically allocated for the lifetime 
of the enclosure_device.

John
