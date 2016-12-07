From: Wei Fang <fangwei1@huawei.com>
Subject: Re: [PATCH] scsi: avoid a permanent stop of the scsi device's request
 queue
Date: Wed, 7 Dec 2016 09:20:59 +0800
Message-ID: <584763FB.9010602@huawei.com>
References: <1481015547-23474-1-git-send-email-fangwei1@huawei.com>
 <BLUPR02MB16838CCF3E631720279B921781820@BLUPR02MB1683.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:7150 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751266AbcLGBV1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2016 20:21:27 -0500
In-Reply-To: <BLUPR02MB16838CCF3E631720279B921781820@BLUPR02MB1683.namprd02.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tyasui@redhat.com" <tyasui@redhat.com>

Hi, Bart,

On 2016/12/6 23:51, Bart Van Assche wrote:
> On 12/06/16 01:12, Wei Fang wrote:
>> The scsi device is being setted to the SDEV_RUNNING state at the end of
>> the scan work. When the remote port reappears, scsi_target_unblock()
>> will be called, but the QUEUE_FLAG_STOPPED flag will not be cleared,
>> since scsi_internal_device_unblock() ignores SCSI devices in SDEV_RUNNING
>> state. It results in a permanent stop of the scsi device's request
>> queue. Every requests sended to it will be blocked.
> 
> Hello Wei,
> 
> scsi_device_set_state() does not allow the transition from 
> SDEV_CREATED_BLOCK to SDEV_RUNNING. If a SCSI device is blocked after it 
> has been added to the __devices list and before scsi_add_lun() finishes 
> then I think the scan code will change its state into SDEV_BLOCK. Are 
> you sure what you described above is what happened?

Yes, we already encountered this case on out machine:

The state of the scsi device first is changed to SDEV_BLOCK in
scsi_add_lun() as you metioned, then it will be changed to SDEV_RUNNING
in scsi_sysfs_add_sdev().

Thanks,
Wei

