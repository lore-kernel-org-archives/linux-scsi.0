From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] scsi: avoid a permanent stop of the scsi device's
 request queue
Date: Fri, 09 Dec 2016 08:02:42 -0800
Message-ID: <1481299362.2403.19.camel@linux.vnet.ibm.com>
References: <1481276138-570-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33842 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932461AbcLIQCu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2016 11:02:50 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uB9G00LQ126002
        for <linux-scsi@vger.kernel.org>; Fri, 9 Dec 2016 11:02:49 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0b-001b2d01.pphosted.com with ESMTP id 277ymj0mg6-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 09 Dec 2016 11:02:49 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Fri, 9 Dec 2016 09:02:48 -0700
In-Reply-To: <1481276138-570-1-git-send-email-fangwei1@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com, emilne@redhat.com

On Fri, 2016-12-09 at 17:35 +0800, Wei Fang wrote:
> A scan work can run simultaneously with fc_remote_port_delete().
> If a scsi device is added to the ->__devices list in the scan work,
> it can be touched and will be blocked in scsi_target_block(), which
> will be called in fc_remote_port_delete(), and QUEUE_FLAG_STOPPED
> flag will be setted to the scsi device's request queue.
>  
> The scsi device is being setted to the SDEV_RUNNING state in
> scsi_sysfs_add_sdev() at the end of the scan work. When the remote
> port reappears, scsi_target_unblock() will be called, but the
> QUEUE_FLAG_STOPPED flag will not be cleared, since
> scsi_internal_device_unblock() ignores SCSI devices in SDEV_RUNNING
> state. It results in a permanent stop of the scsi device's request
> queue. Every requests sended to it will be blocked.

This is a bit unclear as a description of the problem

> Since the scsi device shouldn't be unblocked in this case, fix
> it by removing scsi_device_set_state() in scsi_sysfs_add_sdev().

So is this as a description of the solution, because the reader doesn't
know there's a prior place where SDEV_RUNNING was previously set.

How about

---
A race between scanning and fc_remote_port_delete() may result in a
permanent stop if the device gets blocked before scsi_sysfs_add_lun()
and unblocked after.  The reason is that blocking a device sets both
the SDEV_BLOCKED state and the QUEUE_FLAG_STOPPED.  However,
scsi_sysfs_add_sdev() unconditionally sets SDEV_RUNNING which causes
the device to be ignored by scsi_target_unblock() and thus never have
its QUEUE_FLAG_STOPPED cleared leading to a device which is apparently
running but has a stopped queue.

We actually have two places where SDEV_RUNNING is set: once in
scsi_add_lun() which respects the blocked flag and once in
scsi_sysfs_add_sdev() which doesn't.  Since the second set is entirely
spurious, simply remove it to fix the problem.
---

James

