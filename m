From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4] scsi: avoid a permanent stop of the scsi device's request queue
Date: Wed, 14 Dec 2016 15:52:11 -0500
Message-ID: <yq137hqb5dw.fsf@sermon.lab.mkp.net>
References: <1481592321-10796-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28686 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753022AbcLNUwd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2016 15:52:33 -0500
In-Reply-To: <1481592321-10796-1-git-send-email-fangwei1@huawei.com> (Wei
        Fang's message of "Tue, 13 Dec 2016 09:25:21 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com, emilne@redhat.com, chenzengxi@huawei.com

>>>>> "Wei" == Wei Fang <fangwei1@huawei.com> writes:

Wei> A race between scanning and fc_remote_port_delete() may result in a
Wei> permanent stop if the device gets blocked before
Wei> scsi_sysfs_add_sdev() and unblocked after.  The reason is that
Wei> blocking a device sets both the SDEV_BLOCKED state and the
Wei> QUEUE_FLAG_STOPPED.  However, scsi_sysfs_add_sdev() unconditionally
Wei> sets SDEV_RUNNING which causes the device to be ignored by
Wei> scsi_target_unblock() and thus never have its QUEUE_FLAG_STOPPED
Wei> cleared leading to a device which is apparently running but has a
Wei> stopped queue.

Wei> We actually have two places where SDEV_RUNNING is set: once in
Wei> scsi_add_lun() which respects the blocked flag and once in
Wei> scsi_sysfs_add_sdev() which doesn't.  Since the second set is
Wei> entirely spurious, simply remove it to fix the problem.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
