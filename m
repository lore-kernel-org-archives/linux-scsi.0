From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] sd: Increase SCSI disk probing concurrency
Date: Sun, 10 Dec 2017 15:44:37 +0100
Message-ID: <c3116e4b-bd48-d72c-52ff-972b9e03fc9a@suse.com>
References: <20171208172124.32685-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:39887 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751616AbdLJOo6 (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Sun, 10 Dec 2017 09:44:58 -0500
In-Reply-To: <20171208172124.32685-1-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

On 12/08/2017 06:21 PM, Bart Van Assche wrote:
> The scsi_sd_probe_domain allows to wait until all disk-probing
> activity has finished system-wide. This slows down SCSI host removal
> that occurs concurrently with SCSI disk probing because sd_remove()
> waits on scsi_sd_probe_domain. Additionally, since each function that
> waits on scsi_sd_probe_domain specifies for which disk to wait until
> probing has finished, replace waiting on scsi_sd_probe_domain by
> waiting until probing for a specific disk has finished. Introduce a
> .sync() function pointer in struct scsi_driver to make it possible
> for the SCSI power management code to wait until probing of a
> specific disk has finished.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi.c        |  5 -----
>  drivers/scsi/scsi_pm.c     |  6 ++++--
>  drivers/scsi/scsi_priv.h   |  1 -
>  drivers/scsi/sd.c          | 26 +++++++++++++++++++++-----
>  drivers/scsi/sd.h          |  1 +
>  include/scsi/scsi_driver.h |  1 +
>  6 files changed, 27 insertions(+), 13 deletions(-)
> 
You know what, I have been working on a similar patch for quite some
time now; however, I've taken the simpler approach of not using
async_synchronize_full_domain() but rather async_synchronize_cookie(),
which makes for a simpler patch :-)

However, in doing so I have encountered several issues which have been
exposed by that; the most trivial one being that del_gendisk() doesn't
check if GENHD_FL_UP is set, so it'll crash if sd_remove is called
before sd_async_probe() is run.

The other one is an imbalance between sd_probe and sd_remove;
when sd_probe_async() is called _after_ scsi_device_remove_device()
(which it will as the synchronization is only after device_del() has
been called) it will trip over non-existent sysfs directories in add_disk().
So one need to short-circuit sd_probe_async() for devices in SDEV_CANCEL
or SDEV_DEL.

However, I'm still waiting for a final confirmation on the latter issue,
hence I haven't posted the patchset.
If there's interest I can post them, though.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
