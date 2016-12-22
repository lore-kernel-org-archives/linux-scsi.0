From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 02/13] be2iscsi: Fix for crash in
 beiscsi_eh_device_reset
Date: Thu, 22 Dec 2016 13:53:51 +0100
Message-ID: <09b58bcd-4509-9207-4240-1b1571a4b9e4@suse.de>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1481624766-13846-3-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41277 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754500AbcLVMxx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 07:53:53 -0500
In-Reply-To: <1481624766-13846-3-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 12/13/2016 11:25 AM, Jitendra Bhivare wrote:
> System crashes when sg_reset is executed in a loop.
> CPU: 13 PID: 7073 Comm: sg_reset Tainted: G            E   4.8.0-rc1+ #4
> RIP: 0010:[<ffffffffa0825370>]  [<ffffffffa0825370>]
> beiscsi_eh_device_reset+0x160/0x520 [be2iscsi]
> Call Trace:
> [<ffffffff814c7c77>] ? scsi_host_alloc_command+0x47/0xc0
> [<ffffffff814caafa>] scsi_try_bus_device_reset+0x2a/0x50
> [<ffffffff814cb46e>] scsi_ioctl_reset+0x13e/0x260
> [<ffffffff814ca477>] scsi_ioctl+0x137/0x3d0
> [<ffffffffa05e4ba2>] sg_ioctl+0x572/0xc20 [sg]
> [<ffffffff8123f627>] do_vfs_ioctl+0xa7/0x5d0
>
> The accesses to beiscsi_io_task is being protected in device reset handler
> with frwd_lock but the freeing of task can happen under back_lock.
>
> Hold the reference of iscsi_task till invalidation completes.
> This prevents use of ICD when invalidation of that ICD is being processed.
> Use frwd_lock for iscsi_tasks looping and back_lock to access
> beiscsi_io_task structures.
>
> Rewrite mgmt_invalidation_icds to handle allocation and freeing of IOCTL
> buffer in one place.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 121 +++++++++++++++++-----------------------
>  drivers/scsi/be2iscsi/be_mgmt.c | 107 ++++++++++++++++++++---------------
>  drivers/scsi/be2iscsi/be_mgmt.h |   8 +--
>  3 files changed, 114 insertions(+), 122 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
