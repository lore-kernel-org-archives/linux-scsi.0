From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/19] Fix RCU handling of scsi_device.vpd_pg8[03]
Date: Fri, 25 Aug 2017 17:49:16 +0200
Message-ID: <8abaa903-7150-b7a0-ffc8-2fb4d2695e6c@suse.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
 <20170823214009.15015-8-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42734 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933662AbdHYPtT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 11:49:19 -0400
In-Reply-To: <20170823214009.15015-8-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Shane Seymour <shane.seymour@hpe.com>

On 08/23/2017 11:39 PM, Bart Van Assche wrote:
> Only annotate pointers that are shared across threads with __rcu.
> Use rcu_dereference() when dereferencing an RCU pointer. Protect
> also the RCU pointer dereferences when freeing RCU pointers. This
> patch suppresses about twenty sparse complaints about the vpd_pg8[03]
> pointers.
> 
> Fixes: commit 09e2b0b14690 ("scsi: rescan VPD attributes")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Shane Seymour <shane.seymour@hpe.com>
> ---
>  drivers/scsi/scsi.c       | 6 +++---
>  drivers/scsi/scsi_lib.c   | 8 ++++----
>  drivers/scsi/scsi_sysfs.c | 7 +++++--
>  3 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 3d38c6d463b8..5bb15e698969 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -426,7 +426,7 @@ void scsi_attach_vpd(struct scsi_device *sdev)
>  	int vpd_len = SCSI_VPD_PG_LEN;
>  	int pg80_supported = 0;
>  	int pg83_supported = 0;
> -	unsigned char __rcu *vpd_buf, *orig_vpd_buf = NULL;
> +	unsigned char *vpd_buf, *orig_vpd_buf = NULL;
>  
>  	if (!scsi_device_supports_vpd(sdev))
>  		return;
Why drop the __rcu annotation here?
vpd_buf and orig_vpd_buf should always be accessed via rcu pointers.
Did I misunderstood the meaning of the __rcu annotation?

> @@ -474,7 +474,7 @@ void scsi_attach_vpd(struct scsi_device *sdev)
>  			goto retry_pg80;
>  		}
>  		mutex_lock(&sdev->inquiry_mutex);
> -		orig_vpd_buf = sdev->vpd_pg80;
> +		orig_vpd_buf = rcu_dereference(sdev->vpd_pg80);
>  		sdev->vpd_pg80_len = result;
>  		rcu_assign_pointer(sdev->vpd_pg80, vpd_buf);
>  		mutex_unlock(&sdev->inquiry_mutex);
Yeah, I wasn't quite sure if I need to use rcu_dereference here.

> @@ -503,7 +503,7 @@ void scsi_attach_vpd(struct scsi_device *sdev)
>  			goto retry_pg83;
>  		}
>  		mutex_lock(&sdev->inquiry_mutex);
> -		orig_vpd_buf = sdev->vpd_pg83;
> +		orig_vpd_buf = rcu_dereference(sdev->vpd_pg83);
>  		sdev->vpd_pg83_len = result;
>  		rcu_assign_pointer(sdev->vpd_pg83, vpd_buf);
>  		mutex_unlock(&sdev->inquiry_mutex);
Same here.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 1905962fb992..2ca91d251c5f 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -3282,7 +3282,7 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
>  	u8 cur_id_type = 0xff;
>  	u8 cur_id_size = 0;
>  	unsigned char *d, *cur_id_str;
> -	unsigned char __rcu *vpd_pg83;
> +	unsigned char *vpd_pg83;
>  	int id_size = -EINVAL;
>  
>  	rcu_read_lock();
> @@ -3431,7 +3431,7 @@ EXPORT_SYMBOL(scsi_vpd_lun_id);
>  int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
>  {
>  	unsigned char *d;
> -	unsigned char __rcu *vpd_pg83;
> +	unsigned char *vpd_pg83;
>  	int group_id = -EAGAIN, rel_port = -1;
>  
>  	rcu_read_lock();
> @@ -3441,8 +3441,8 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
>  		return -ENXIO;
>  	}
>  
> -	d = sdev->vpd_pg83 + 4;
> -	while (d < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
> +	d = vpd_pg83 + 4;
> +	while (d < vpd_pg83 + sdev->vpd_pg83_len) {
>  		switch (d[1] & 0xf) {
>  		case 0x4:
>  			/* Relative target port */
Bah. Yeah, of course.

> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 5ed473a87589..cf8a2088a9ba 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -456,8 +456,11 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>  	/* NULL queue means the device can't be used */
>  	sdev->request_queue = NULL;
>  
> -	kfree(sdev->vpd_pg83);
> -	kfree(sdev->vpd_pg80);
> +	mutex_lock(&sdev->inquiry_mutex);
> +	kfree(rcu_dereference(sdev->vpd_pg83));
> +	kfree(rcu_dereference(sdev->vpd_pg80));
> +	mutex_unlock(&sdev->inquiry_mutex);
> +
>  	kfree(sdev->inquiry);
>  	kfree(sdev);
>  
> 
As indicated by Shane, I think using 'kfree_rcu()' here might not be a
bad idea. You never know ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
