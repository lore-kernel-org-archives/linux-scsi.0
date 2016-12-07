From: Wei Fang <fangwei1@huawei.com>
Subject: Re: [PATCH] scsi: avoid a permanent stop of the scsi device's request
 queue
Date: Wed, 7 Dec 2016 14:59:33 +0800
Message-ID: <5847B355.2050100@huawei.com>
References: <1481015547-23474-1-git-send-email-fangwei1@huawei.com>
 <BLUPR02MB16838CCF3E631720279B921781820@BLUPR02MB1683.namprd02.prod.outlook.com>
 <584763FB.9010602@huawei.com>
 <BLUPR02MB168364C1D3A8A2C7CF367D5481850@BLUPR02MB1683.namprd02.prod.outlook.com>
 <584784D7.1070009@huawei.com>
 <BLUPR02MB1683A85CB4376E9904F1B38881850@BLUPR02MB1683.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:15493 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752423AbcLGHDU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2016 02:03:20 -0500
In-Reply-To: <BLUPR02MB1683A85CB4376E9904F1B38881850@BLUPR02MB1683.namprd02.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tyasui@redhat.com" <tyasui@redhat.com>

Hi, Bart,

On 2016/12/7 12:40, Bart Van Assche wrote:
> I am aware that commit 5c10e63c943b caused the behavior change. But that 
> doesn't mean that a fix has to undo the changes introduced by that 
> commit. We do not only want to make sure that the SCSI core works as 
> intended but also that the SCSI core code is as easy to comprehend as 
> reasonably possible. Adding "&& sdev->sdev_state != SDEV_RUNNING" in 
> scsi_internal_device_unblock() would require a long comment to explain 
> why that code has been added. I think modifying scsi_sysfs_add_sdev() 
> such that it does not unblock devices will result in code that is easier 
> to understand.

Agree that we should make the code easier to comprehend if possible :)

If we modify scsi_sysfs_add_sdev() as below:
        ...
        if (scsi_device_created(sdev))
                error = scsi_device_set_state(sdev, SDEV_RUNNING);
                if (error)
                        error = scsi_device_set_state(sdev, SDEV_BLOCK);
        ...
there's a chance that the state will be changed to SDEV_RUNNING.

If a SCSI device is blocked after the check of the device's creating
and before being changed to SDEV_RUNNING state, the state will still
become SDEV_RUNNING. If we fix this problem in this way, we need
introduce a way to synchronize those code.

Actually I don't know quite well about the synchronization of
scsi_device_set_state(). There are so many cases it can be called
simultaneously, will the state become a unpredictable value, or this
is tolerated?

Thanks,
Wei

