From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH 1/4] scsi_dh: Change the scsidh_activate interface to be
 asynchronous
Date: Fri, 2 Oct 2009 16:04:17 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474ED88E7@cosmail01.lsi.com>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
 <20090930020817.11455.52042.sendpatchset@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:47433 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754811AbZJBWEn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2009 18:04:43 -0400
In-Reply-To: <20090930020817.11455.52042.sendpatchset@chandra-ubuntu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Benoit_Arthur@emc.com" <Benoit_Arthur@emc.com>, "Eddie.Williams@steeleye.com" <Eddie.Williams@steeleye.com>, "berthiaume_wayne@emc.com" <berthiaume_wayne@emc.com>


Chandra, I have one comment on this patch..=20

>  static inline int scsi_dh_handler_exist(const char *name)
> Index: linux-2.6.31/drivers/scsi/device_handler/scsi_dh.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.31.orig/drivers/scsi/device_handler/scsi_dh.c
> +++ linux-2.6.31/drivers/scsi/device_handler/scsi_dh.c
> @@ -214,7 +214,7 @@ store_dh_state(struct device *dev, struc
>  			 * Activate a device handler
>  			 */
>  			if (scsi_dh->activate)
> -				err =3D scsi_dh->activate(sdev);
> +				err =3D scsi_dh->activate(sdev, NULL, NULL);


This might cause problems in handlers.  We don=92t do NULL check in att=
ach routine.


>  			else
>  				err =3D 0;
>  		}
> @@ -411,10 +411,17 @@ EXPORT_SYMBOL_GPL(scsi_unregister_device
>  /*
>   * scsi_dh_activate - activate the path associated with the
> scsi_device
>   *      corresponding to the given request queue.
> - * @q - Request queue that is associated with the scsi_device to be
> - *      activated.
> + *     Returns immediately without waiting for activation to be
> completed.
> + * @q    - Request queue that is associated with the scsi_device to =
be
> + *         activated.
> + * @fn   - Function to be called upon completion of the activation.
> + *         Function fn is called with data (below) and the error cod=
e.
> + *         Function fn may be called from the same calling context.
> So,
> + *         do not hold the lock in the caller which may be needed in
> fn.
> + * @data - data passed to the function fn upon completion.
> + *
>   */
> -int scsi_dh_activate(struct request_queue *q)
> +int scsi_dh_activate(struct request_queue *q, activate_complete fn,
> void *data)
>  {
>  	int err =3D 0;
>  	unsigned long flags;
> @@ -433,7 +440,7 @@ int scsi_dh_activate(struct request_queu
>  		return err;
>=20
>  	if (scsi_dh->activate)
> -		err =3D scsi_dh->activate(sdev);
> +		err =3D scsi_dh->activate(sdev, fn, data);
>  	put_device(&sdev->sdev_gendev);
>  	return err;
>  }
> Index: linux-2.6.31/drivers/scsi/device_handler/scsi_dh_rdac.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.31.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
> +++ linux-2.6.31/drivers/scsi/device_handler/scsi_dh_rdac.c
> @@ -516,7 +516,7 @@ done:
>  	return err;
>  }
>=20
> -static int rdac_activate(struct scsi_device *sdev)
> +static int rdac_activate(struct scsi_device *sdev, activate_complete
> fn, void *data)
>  {
>  	struct rdac_dh_data *h =3D get_rdac_data(sdev);
>  	int err =3D SCSI_DH_OK;
> @@ -539,7 +539,9 @@ static int rdac_activate(struct scsi_dev
>  	if (h->lun_state =3D=3D RDAC_LUN_UNOWNED)
>  		err =3D send_mode_select(sdev, h);
>  done:
> -	return err;
> +	if (fn)
> +		fn(data, err);
> +	return 0;
>  }
>=20
>  static int rdac_prep_fn(struct scsi_device *sdev, struct request *re=
q)
> Index: linux-2.6.31/drivers/scsi/device_handler/scsi_dh_alua.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.31.orig/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ linux-2.6.31/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -652,7 +652,7 @@ out:
>   * based on a certain policy. But until we actually encounter them i=
t
>   * should be okay.
>   */
> -static int alua_activate(struct scsi_device *sdev)
> +static int alua_activate(struct scsi_device *sdev, activate_complete
> fn, void *data)
>  {
>  	struct alua_dh_data *h =3D get_alua_data(sdev);
>  	int err =3D SCSI_DH_OK;
> @@ -667,7 +667,9 @@ static int alua_activate(struct scsi_dev
>  		err =3D alua_stpg(sdev, TPGS_STATE_OPTIMIZED, h);
>=20
>  out:
> -	return err;
> +	if (fn)
> +		fn(data, err);
> +	return 0;
>  }
>=20
>  /*
> Index: linux-2.6.31/drivers/scsi/device_handler/scsi_dh_emc.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.31.orig/drivers/scsi/device_handler/scsi_dh_emc.c
> +++ linux-2.6.31/drivers/scsi/device_handler/scsi_dh_emc.c
> @@ -528,7 +528,7 @@ retry:
>  	return err;
>  }
>=20
> -static int clariion_activate(struct scsi_device *sdev)
> +static int clariion_activate(struct scsi_device *sdev,
> activate_complete fn, void *data)
>  {
>  	struct clariion_dh_data *csdev =3D get_clariion_data(sdev);
>  	int result;
> @@ -559,7 +559,9 @@ done:
>  		    csdev->port, lun_state[csdev->lun_state],
>  		    csdev->default_sp + 'A');
>=20
> -	return result;
> +	if (fn)
> +		fn(data, result);
> +	return 0;
>  }
>=20
>  static const struct scsi_dh_devlist clariion_dev_list[] =3D {
> Index: linux-2.6.31/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.31.orig/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> +++ linux-2.6.31/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> @@ -268,7 +268,7 @@ static int hp_sw_prep_fn(struct scsi_dev
>   * activate the passive path (and deactivate the
>   * previously active one).
>   */
> -static int hp_sw_activate(struct scsi_device *sdev)
> +static int hp_sw_activate(struct scsi_device *sdev, activate_complet=
e
> fn, void *data)
>  {
>  	int ret =3D SCSI_DH_OK;
>  	struct hp_sw_dh_data *h =3D get_hp_sw_data(sdev);
> @@ -283,7 +283,9 @@ static int hp_sw_activate(struct scsi_de
>  				    HP_SW_NAME);
>  	}
>=20
> -	return ret;
> +	if (fn)
> +		fn(data, ret);
> +	return 0;
>  }
>=20
>  static const struct scsi_dh_devlist hp_sw_dh_data_list[] =3D {
> Index: linux-2.6.31/include/scsi/scsi_device.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.31.orig/include/scsi/scsi_device.h
> +++ linux-2.6.31/include/scsi/scsi_device.h
> @@ -174,6 +174,7 @@ struct scsi_dh_devlist {
>  	char *model;
>  };
>=20
> +typedef void (*activate_complete)(void *, int);
>  struct scsi_device_handler {
>  	/* Used by the infrastructure */
>  	struct list_head list; /* list of scsi_device_handlers */
> @@ -185,7 +186,7 @@ struct scsi_device_handler {
>  	int (*check_sense)(struct scsi_device *, struct scsi_sense_hdr
> *);
>  	int (*attach)(struct scsi_device *);
>  	void (*detach)(struct scsi_device *);
> -	int (*activate)(struct scsi_device *);
> +	int (*activate)(struct scsi_device *, activate_complete, void *);
>  	int (*prep_fn)(struct scsi_device *, struct request *);
>  };
>=20
> Index: linux-2.6.31/drivers/md/dm-mpath.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.31.orig/drivers/md/dm-mpath.c
> +++ linux-2.6.31/drivers/md/dm-mpath.c
> @@ -1086,8 +1086,9 @@ static int pg_init_limit_reached(struct
>  	return limit_reached;
>  }
>=20
> -static void pg_init_done(struct dm_path *path, int errors)
> +static void pg_init_done(void *data, int errors)
>  {
> +	struct dm_path *path =3D data;
>  	struct pgpath *pgpath =3D path_to_pgpath(path);
>  	struct priority_group *pg =3D pgpath->pg;
>  	struct multipath *m =3D pg->m;
> @@ -1153,12 +1154,11 @@ static void pg_init_done(struct dm_path
>=20
>  static void activate_path(struct work_struct *work)
>  {
> -	int ret;
>  	struct pgpath *pgpath =3D
>  		container_of(work, struct pgpath, activate_path);
>=20
> -	ret =3D scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev));
> -	pg_init_done(&pgpath->path, ret);
> +	scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
> +				pg_init_done, &pgpath->path);
>  }
>=20
>  /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
