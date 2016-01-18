From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] Separate target visibility from reaped state information
Date: Mon, 18 Jan 2016 09:55:33 +0100
Message-ID: <20160118085533.GB2742@c203.arch.suse.de>
References: <568FE922.9090004@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbcARIzi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2016 03:55:38 -0500
Content-Disposition: inline
In-Reply-To: <568FE922.9090004@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Sebastian Herbszt <herbszt@gmx.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Jan 08, 2016 at 05:51:46PM +0100, Bart Van Assche wrote:
> Instead of representing the states "visible in sysfs" and
> "has been removed from the target list" by a single state
> variable, use two variables to represent this information.
>=20
> This patch avoids that SCSI device removal can trigger the
> following soft lockup:
>=20
> NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [kworker/1:1:29=
]
> CPU: 1 PID: 29 Comm: kworker/1:1 Tainted: G           O    4.4.0-rc5-=
2.g1e923a3-default #1
> Workqueue: fc_wq_4 fc_rport_final_delete [scsi_transport_fc]
> Call Trace:
>  [<c066b0f7>] scsi_remove_target+0x167/0x1c0
>  [<f8f0a4ed>] fc_rport_final_delete+0x9d/0x1e0 [scsi_transport_fc]
>  [<c026cb25>] process_one_work+0x155/0x3e0
>  [<c026cde7>] worker_thread+0x37/0x490
>  [<c027214b>] kthread+0x9b/0xb0
>  [<c07e72c1>] ret_from_kernel_thread+0x21/0x40
>=20
> See also commit bc3f02a795d3 ("scsi_remove_target: fix softlockup
> regression on hot remove").
>=20
> Reported-by: Sebastian Herbszt <herbszt@gmx.de>
> Tested-by: Sebastian Herbszt <herbszt@gmx.de>
> Fixes: commit 40998193560d ("scsi: restart list search after unlock i=
n scsi_remove_target")
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: stable <stable@vger.kernel.org>
> ---
>  drivers/scsi/scsi_scan.c   | 31 +++----------------------------
>  drivers/scsi/scsi_sysfs.c  |  7 ++++---
>  include/scsi/scsi_device.h |  9 ++-------
>  3 files changed, 9 insertions(+), 38 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 054923e..c455a88 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -314,7 +314,6 @@ static void scsi_target_destroy(struct scsi_targe=
t *starget)
>  	struct Scsi_Host *shost =3D dev_to_shost(dev->parent);
>  	unsigned long flags;
> =20
> -	starget->state =3D STARGET_DEL;
>  	transport_destroy_device(dev);
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	if (shost->hostt->target_destroy)
> @@ -379,19 +378,15 @@ static void scsi_target_reap_ref_release(struct=
 kref *kref)
>  	struct scsi_target *starget
>  		=3D container_of(kref, struct scsi_target, reap_ref);
> =20
> -	/*
> -	 * if we get here and the target is still in the CREATED state that
> -	 * means it was allocated but never made visible (because a scan
> -	 * turned up no LUNs), so don't call device_del() on it.
> -	 */
> -	if (starget->state !=3D STARGET_CREATED) {
> +	if (starget->is_visible) {
> +		starget->is_visible =3D false;
>  		transport_remove_device(&starget->dev);
>  		device_del(&starget->dev);
>  	}
>  	scsi_target_destroy(starget);
>  }
> =20
> -static void scsi_target_reap_ref_put(struct scsi_target *starget)
> +void scsi_target_reap(struct scsi_target *starget)
>  {
>  	kref_put(&starget->reap_ref, scsi_target_reap_ref_release);
>  }
> @@ -437,7 +432,6 @@ static struct scsi_target *scsi_alloc_target(stru=
ct device *parent,
>  	starget->can_queue =3D 0;
>  	INIT_LIST_HEAD(&starget->siblings);
>  	INIT_LIST_HEAD(&starget->devices);
> -	starget->state =3D STARGET_CREATED;
>  	starget->scsi_level =3D SCSI_2;
>  	starget->max_target_blocked =3D SCSI_DEFAULT_TARGET_BLOCKED;
>   retry:
> @@ -498,25 +492,6 @@ static struct scsi_target *scsi_alloc_target(str=
uct device *parent,
>  }
> =20
>  /**
> - * scsi_target_reap - check to see if target is in use and destroy i=
f not
> - * @starget: target to be checked
> - *
> - * This is used after removing a LUN or doing a last put of the targ=
et
> - * it checks atomically that nothing is using the target and removes
> - * it if so.
> - */
> -void scsi_target_reap(struct scsi_target *starget)
> -{
> -	/*
> -	 * serious problem if this triggers: STARGET_DEL is only set in the=
 if
> -	 * the reap_ref drops to zero, so we're trying to do another final =
put
> -	 * on an already released kref
> -	 */
> -	BUG_ON(starget->state =3D=3D STARGET_DEL);
> -	scsi_target_reap_ref_put(starget);
> -}
> -
> -/**
>   * sanitize_inquiry_string - remove non-graphical chars from an INQU=
IRY result string
>   * @s: INQUIRY result string to sanitize
>   * @len: length of the string
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 21930c9..532c062 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1000,7 +1000,7 @@ static int scsi_target_add(struct scsi_target *=
starget)
>  {
>  	int error;
> =20
> -	if (starget->state !=3D STARGET_CREATED)
> +	if (starget->is_visible)
>  		return 0;
> =20
>  	error =3D device_add(&starget->dev);
> @@ -1009,7 +1009,7 @@ static int scsi_target_add(struct scsi_target *=
starget)
>  		return error;
>  	}
>  	transport_add_device(&starget->dev);
> -	starget->state =3D STARGET_RUNNING;
> +	starget->is_visible =3D true;
> =20
>  	pm_runtime_set_active(&starget->dev);
>  	pm_runtime_enable(&starget->dev);
> @@ -1198,10 +1198,11 @@ void scsi_remove_target(struct device *dev)
>  restart:
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	list_for_each_entry(starget, &shost->__targets, siblings) {
> -		if (starget->state =3D=3D STARGET_DEL)
> +		if (starget->reaped)
>  			continue;
>  		if (starget->dev.parent =3D=3D dev || &starget->dev =3D=3D dev) {
>  			kref_get(&starget->reap_ref);
> +			starget->reaped =3D true;
>  			spin_unlock_irqrestore(shost->host_lock, flags);
>  			__scsi_remove_target(starget);
>  			scsi_target_reap(starget);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index fe89d7c..f11c794 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -236,12 +236,6 @@ scmd_printk(const char *, const struct scsi_cmnd=
 *, const char *, ...);
>  			sdev_dbg((scmd)->device, fmt, ##a);		   \
>  	} while (0)
> =20
> -enum scsi_target_state {
> -	STARGET_CREATED =3D 1,
> -	STARGET_RUNNING,
> -	STARGET_DEL,
> -};
> -
>  /*
>   * scsi_target: representation of a scsi target, for now, this is on=
ly
>   * used for single_lun devices. If no one has active IO to the targe=
t,
> @@ -267,6 +261,8 @@ struct scsi_target {
>  	unsigned int		expecting_lun_change:1;	/* A device has reported
>  						 * a 3F/0E UA, other devices on
>  						 * the same target will also. */
> +	unsigned int		is_visible:1; /* visible in sysfs */
> +	unsigned int		reaped:1; /* removed from target list */
>  	/* commands actually active on LLD. */
>  	atomic_t		target_busy;
>  	atomic_t		target_blocked;
> @@ -280,7 +276,6 @@ struct scsi_target {
>  #define SCSI_DEFAULT_TARGET_BLOCKED	3
> =20
>  	char			scsi_level;
> -	enum scsi_target_state	state;
>  	void 			*hostdata; /* available to low-level driver */
>  	unsigned long		starget_data[0]; /* for the transport */
>  	/* starget_data must be the last element!!!! */
> --=20
> 2.1.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks fine to me.
Thanks

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
