From: Wei Fang <fangwei1@huawei.com>
Subject: Re: [PATCH v2] scsi: avoid a permanent stop of the scsi device's
 request queue
Date: Mon, 12 Dec 2016 09:54:45 +0800
Message-ID: <584E0365.6040301@huawei.com>
References: <1481276138-570-1-git-send-email-fangwei1@huawei.com>
 <1481299362.2403.19.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:63234 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753804AbcLLBz0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Dec 2016 20:55:26 -0500
In-Reply-To: <1481299362.2403.19.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com, emilne@redhat.com

Hi, James,

On 2016/12/10 0:02, James Bottomley wrote:
> On Fri, 2016-12-09 at 17:35 +0800, Wei Fang wrote:
>> A scan work can run simultaneously with fc_remote_port_delete().
>> If a scsi device is added to the ->__devices list in the scan work,
>> it can be touched and will be blocked in scsi_target_block(), which
>> will be called in fc_remote_port_delete(), and QUEUE_FLAG_STOPPED
>> flag will be setted to the scsi device's request queue.
>>  
>> The scsi device is being setted to the SDEV_RUNNING state in
>> scsi_sysfs_add_sdev() at the end of the scan work. When the remote
>> port reappears, scsi_target_unblock() will be called, but the
>> QUEUE_FLAG_STOPPED flag will not be cleared, since
>> scsi_internal_device_unblock() ignores SCSI devices in SDEV_RUNNING
>> state. It results in a permanent stop of the scsi device's request
>> queue. Every requests sended to it will be blocked.
> 
> This is a bit unclear as a description of the problem
> 
>> Since the scsi device shouldn't be unblocked in this case, fix
>> it by removing scsi_device_set_state() in scsi_sysfs_add_sdev().
> 
> So is this as a description of the solution, because the reader doesn't
> know there's a prior place where SDEV_RUNNING was previously set.
> 
> How about
> 
> ---
> A race between scanning and fc_remote_port_delete() may result in a
> permanent stop if the device gets blocked before scsi_sysfs_add_lun()
> and unblocked after.  The reason is that blocking a device sets both
> the SDEV_BLOCKED state and the QUEUE_FLAG_STOPPED.  However,
> scsi_sysfs_add_sdev() unconditionally sets SDEV_RUNNING which causes
> the device to be ignored by scsi_target_unblock() and thus never have
> its QUEUE_FLAG_STOPPED cleared leading to a device which is apparently
> running but has a stopped queue.
> 
> We actually have two places where SDEV_RUNNING is set: once in
> scsi_add_lun() which respects the blocked flag and once in
> scsi_sysfs_add_sdev() which doesn't.  Since the second set is entirely
> spurious, simply remove it to fix the problem.

That's much clearer, thanks. I'll use this in patch v3.

Thanks,
Wei

