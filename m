From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/3] Unblock SCSI devices even if the LLD is being
 unloaded
Date: Thu, 16 Mar 2017 15:53:17 -0700
Message-ID: <1489704797.4650.8.camel@HansenPartnership.com>
References: <20170316205650.3322-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36400 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752563AbdCPWxk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Mar 2017 18:53:40 -0400
In-Reply-To: <20170316205650.3322-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>

On Thu, 2017-03-16 at 13:56 -0700, Bart Van Assche wrote:
> scsi_target_unblock() must unblock SCSI devices even if this function
> is called after unloading of the LLD that created these devices has
> started. This is necessary to prevent that __scsi_remove_device() 
> hangs on the SYNCHRONIZE CACHE command issued by the sd driver during
> shutdown.

Your special get function misses the try_module_get().  But this is all
really a bit ugly. Since the only problem is the SYNC CACHE triggered
by device_del, isn't a better solution a new state: SDEV_CANCEL_BLOCK. 
 This will make the device visible to scsi_get_device() and we can take
it back from CANCEL_BLOCKED->CANCEL when the queue is unblocked.  I
suspect we could also simply throw away the sync cache command when the
device is blocked (the cache should destage naturally in the time it
takes for the device to be unblocked).

James
