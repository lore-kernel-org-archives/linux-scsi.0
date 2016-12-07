From: Wei Fang <fangwei1@huawei.com>
Subject: Re: [PATCH] scsi: avoid a permanent stop of the scsi device's request
 queue
Date: Wed, 7 Dec 2016 11:41:11 +0800
Message-ID: <584784D7.1070009@huawei.com>
References: <1481015547-23474-1-git-send-email-fangwei1@huawei.com>
 <BLUPR02MB16838CCF3E631720279B921781820@BLUPR02MB1683.namprd02.prod.outlook.com>
 <584763FB.9010602@huawei.com>
 <BLUPR02MB168364C1D3A8A2C7CF367D5481850@BLUPR02MB1683.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:34501 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752560AbcLGDsC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2016 22:48:02 -0500
In-Reply-To: <BLUPR02MB168364C1D3A8A2C7CF367D5481850@BLUPR02MB1683.namprd02.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tyasui@redhat.com" <tyasui@redhat.com>

Hi, Bart,

On 2016/12/7 10:45, Bart Van Assche wrote:
> On 12/06/16 17:21, Wei Fang wrote:
>> The state of the scsi device first is changed to SDEV_BLOCK in
>> scsi_add_lun() as you mentioned, then it will be changed to SDEV_RUNNING
>> in scsi_sysfs_add_sdev().
> 
> Hello Wei,
> 
> The purpose of the scsi_device_set_state(sdev, SDEV_RUNNING) call in 
> scsi_sysfs_add_sdev() is to change the device state from SDEV_CREATED 
> into SDEV_RUNNING. Have you tried to modify scsi_sysfs_add_sdev() such 
> that it only changes the device state into SDEV_RUNNING if the current 
> state is SDEV_CREATED and also such that it changes SDEV_CREATED_BLOCK 
> into SDEV_BLOCK?

Does those code in scsi_add_lun() have done this thing?
        ...
        ret = scsi_device_set_state(sdev, SDEV_RUNNING);
        if (ret) {
                ret = scsi_device_set_state(sdev, SDEV_BLOCK);
                ...
        }
        ...
You mean we shouldn't change the device state from SDEV_BLOCK
into SDEV_RUNNING in scsi_sysfs_add_sdev()?

I thought it doesn't matter that the state is changed from SDEV_BLOCK
to SDEV_RUNNING in scsi_sysfs_add_sdev(), if the queue can be unblocked
in scsi_internal_device_unblock() in SDEV_RUNNING state. But it
was broken since commit 5c10e63c943b.

Thanks,
Wei

