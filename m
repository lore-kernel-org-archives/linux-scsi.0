Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B82C11F68
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 17:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C906613EB
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 17:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhGBRMz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jul 2021 13:12:55 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3349 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhGBRMy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2021 13:12:54 -0400
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GGh7H2rzZz6F8M8;
        Sat,  3 Jul 2021 00:56:27 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 2 Jul 2021 19:10:20 +0200
Received: from [10.47.88.0] (10.47.88.0) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 2 Jul 2021
 18:10:19 +0100
From:   John Garry <john.garry@huawei.com>
Subject: SCSI layer RPM deadlock debug suggestion
To:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.com>
CC:     chenxiang <chenxiang66@hisilicon.com>,
        Xiejianqin <xiejianqin@hisilicon.com>
Message-ID: <9e90d035-fac1-432a-1d34-de5805d8f799@huawei.com>
Date:   Fri, 2 Jul 2021 18:03:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.88.0]
X-ClientProxiedBy: lhreml732-chm.china.huawei.com (10.201.108.83) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi guys,

We're experiencing a deadlock between trying to remove a SATA device and 
doing a rescan in scsi_rescan_device().

I'm just looking for a suggestion on how to solve.

The background is that the host (hisi sas v3 hw) uses SAS SCSI transport 
and supports RPM. In the testcase, the host and disks are put to 
suspend. Then we run fio on the disk to make them active and then 
immediately hard reset the disk link, which causes the disk to be 
disconnected (please don't ask why ...).

We find that there is a conflict between the rescan and the device 
removal code, resulting in a deadlock:

a 1158050441d:06[ 607.429281] Call trace:
[ 607.433083] __switch_to+0x164/0x1d4
[ 607.437596] __schedule+0x8f8/0x1450
[ 607.441183] schedule+0x7c/0x110
[ 607.444422] blk_queue_enter+0x290/0x490
[ 607.448358] blk_mq_alloc_request+0x50/0xb4
[ 607.452547] blk_get_request+0x38/0x80
[ 607.456305] __scsi_execute+0x6c/0x1c4
[ 607.460064] scsi_vpd_inquiry+0x88/0xf0
[ 607.463908] scsi_get_vpd_buf+0x68/0xb0
[ 607.467752] scsi_attach_vpd+0x58/0x170
[ 607.471596] scsi_rescan_device+0x40/0xac
[ 607.475612] ata_scsi_dev_rescan+0xb4/0x14c
[ 607.479802] process_one_work+0x29c/0x6fc
[ 607.483819] worker_thread+0x80/0x470
[ 607.487489] kthread+0x15c/0x170
[ 607.490727] ret_from_fork+0x10/0x18

sas_phy_event_worker [libsas]
[ 607.529831] Call trace:
[ 607.532312] __switch_to+0x164/0x1d4
[ 607.535900] __schedule+0x8f8/0x1450
[ 607.539484] schedule+0x7c/0x110
[ 607.542724] schedule_preempt_disabled+0x30/0x4c
[ 607.547345] __mutex_lock+0x308/0x8b0
[ 607.551016] mutex_lock_nested+0x44/0x70
[ 607.554947] device_del+0x4c/0x450
[ 607.558341] __scsi_remove_device+0x11c/0x14c
[ 607.562702] scsi_remove_target+0x1bc/0x240
[ 607.566891] sas_rphy_remove+0x90/0x94
[ 607.570649] sas_rphy_delete+0x24/0x40
[ 607.574388] sas_destruct_devices+0x64/0xa0 [libsas]
[ 607.579359] sas_deform_port+0x178/0x1bc [libsas]
[ 607.584069] sas_phye_loss_of_signal+0x28/0x34 [libsas]
[ 607.589298] sas_phy_event_worker+0x34/0x50 [libsas]
[ 607.594268] process_one_work+0x29c/0x6fc
[ 607.598284] worker_thread+0x80/0x470
[ 607.601955] kthread+0x15c/0x170
[ 607.605193] ret_from_fork+0x10/0x18
[ 607.608845] INFO: task fio:3382 blocked for more than 121

The rescan holds the sdev_gendev.device lock in scsi_rescan_device(), 
while the removal code in __scsi_remove_device() wants to grab it.

However the rescan will not release (the lock) until the 
blk_queue_enter() succeeds, above. That can happen 2x ways:

- the queue is dying, which would not happen until after the 
device_del() in __scsi_remove_device(), so not going to happen

- q->pm_only falls to 0. This would be when scsi_runtime_resume() -> 
sdev_runtime_resume() -> blk_post_runtime_resume(err = 0) -> 
blk_set_runtime_active() is called. However, I find that the err 
argument for me is -5, which comes from sdev_runtime_resume() -> 
pm->runtime_resume (=sd_resume()), which fails. That sd_resume() -> 
sd_start_stop_device() fails as the disk is not attached. So we go into 
error state:

$:more 
/sys/devices/pci0000:b4/0000:b4:04.0/host3/port-3:0/end_device-3:0/target3:0:0/3:0:0:0/power/runtime_status
error

Removing commit e27829dc92e5 ("scsi: serialize ->rescan against 
->remove") solves this issue for me, but that is there for a reason.

Any suggestion on how to fix this deadlock?

Thanks,
John
