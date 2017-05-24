From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/31] Make __scsi_remove_device go straight from BLOCKED
 to DEL
Date: Wed, 24 May 2017 07:52:40 +0200
Message-ID: <42091173-a80e-801d-9b3b-56d2b4feebaa@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-6-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55093 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S938322AbdEXFwm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 01:52:42 -0400
In-Reply-To: <20170524003420.5381-6-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Benjamin Block <bblock@linux.vnet.ibm.com>

On 05/24/2017 02:33 AM, Bart Van Assche wrote:
> If a device is blocked, make __scsi_remove_device() cause it to
> transition to the DEL state. This means that all the commands
> issued in .shutdown() will error in the mid-layer, thus making
> the removal proceed without being stopped.
> 
> This patch is a slightly modified version of a patch from James
> Bottomley. This patch avoids that the following lockup occurs:
> 
> Call Trace:
>  schedule+0x35/0x80
>  schedule_timeout+0x237/0x2d0
>  io_schedule_timeout+0xa6/0x110
>  wait_for_completion_io+0xa3/0x110
>  blk_execute_rq+0xdf/0x120
>  scsi_execute+0xce/0x150 [scsi_mod]
>  scsi_execute_req_flags+0x8f/0xf0 [scsi_mod]
>  sd_sync_cache+0xa9/0x190 [sd_mod]
>  sd_shutdown+0x6a/0x100 [sd_mod]
>  sd_remove+0x64/0xc0 [sd_mod]
>  __device_release_driver+0x8d/0x120
>  device_release_driver+0x1e/0x30
>  bus_remove_device+0xf9/0x170
>  device_del+0x127/0x240
>  __scsi_remove_device+0xc1/0xd0 [scsi_mod]
>  scsi_forget_host+0x57/0x60 [scsi_mod]
>  scsi_remove_host+0x72/0x110 [scsi_mod]
>  srp_remove_work+0x8b/0x200 [ib_srp]
> 
> Reported-by: Israel Rukshin <israelr@mellanox.com>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Israel Rukshin <israelr@mellanox.com>
> Cc: Max Gurtovoy <maxg@mellanox.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Benjamin Block <bblock@linux.vnet.ibm.com>
> ---
>  drivers/scsi/scsi_lib.c   |  2 +-
>  drivers/scsi/scsi_sysfs.c | 13 +++++++++++++
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
