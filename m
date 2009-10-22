From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH 1/4] scsi_dh: Change the scsidh_activate interface to be
 asynchronous
Date: Thu, 22 Oct 2009 17:29:54 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF48737424C@cosmail01.lsi.com>
References: <20091021162240.8473.99556.sendpatchset@chandra-ubuntu>
 <20091021162246.8473.68316.sendpatchset@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:47583 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbZJVXa3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Oct 2009 19:30:29 -0400
In-Reply-To: <20091021162246.8473.68316.sendpatchset@chandra-ubuntu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Benoit_Arthur@emc.com" <Benoit_Arthur@emc.com>, "Eddie.Williams@steeleye.com" <Eddie.Williams@steeleye.com>, "berthiaume_wayne@emc.com" <berthiaume_wayne@emc.com>

Correcting the type in my earlier response.. I have tested this patch on LSI rdac storage. It works pretty well..

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Chandra Seetharaman
> Sent: Wednesday, October 21, 2009 11:23 AM
> To: linux-scsi@vger.kernel.org
> Cc: dm-devel@redhat.com; Moger, Babu; michaelc@cs.wisc.edu;
> Benoit_Arthur@emc.com; Eddie.Williams@steeleye.com;
> berthiaume_wayne@emc.com; Chandra Seetharaman
> Subject: [PATCH 1/4] scsi_dh: Change the scsidh_activate interface to
> be asynchronous
> 
> Make scsi_dh_activate() function asynchronous, by taking in two
> additional
> parameters, one is the callback function and the other is the data to
> call
> the callback function with.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Tested-by: Babu Moger <babu.moger@lsi.com>

> 
> --------------
>  drivers/md/dm-mpath.c                       |    8 ++++----
>  drivers/scsi/device_handler/scsi_dh.c       |   17 ++++++++++++-----
>  drivers/scsi/device_handler/scsi_dh_alua.c  |    7 +++++--
>  drivers/scsi/device_handler/scsi_dh_emc.c   |    7 +++++--
>  drivers/scsi/device_handler/scsi_dh_hp_sw.c |    7 +++++--
>  drivers/scsi/device_handler/scsi_dh_rdac.c  |    7 +++++--
>  include/scsi/scsi_device.h                  |    3 ++-
>  include/scsi/scsi_dh.h                      |    6 ++++--
>  8 files changed, 42 insertions(+), 20 deletions(-)
> 
> Index: linux-2.6.32-rc5/include/scsi/scsi_dh.h
> ===================================================================
> --- linux-2.6.32-rc5.orig/include/scsi/scsi_dh.h	2009-10-20
> 18:26:03.000000000 -0700
> +++ linux-2.6.32-rc5/include/scsi/scsi_dh.h	2009-10-20
> 18:26:14.000000000 -0700
> @@ -56,14 +56,16 @@
>  	SCSI_DH_DRIVER_MAX,
>  };
>  #if defined(CONFIG_SCSI_DH) || defined(CONFIG_SCSI_DH_MODULE)
> -extern int scsi_dh_activate(struct request_queue *);
> +extern int scsi_dh_activate(struct request_queue *, activate_complete,
> void *);
>  extern int scsi_dh_handler_exist(const char *);
>  extern int scsi_dh_attach(struct request_queue *, const char *);
>  extern void scsi_dh_detach(struct request_queue *);
>  extern int scsi_dh_set_params(struct request_queue *, const char *);
>  #else
> -static inline int scsi_dh_activate(struct request_queue *req)
> +static inline int scsi_dh_activate(struct request_queue *req,
> +					activate_complete fn, void *data)
>  {
> +	fn(data, 0);
>  	return 0;
>  }
>  static inline int scsi_dh_handler_exist(const char *name)
> Index: linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh.c
> ===================================================================
> --- linux-2.6.32-rc5.orig/drivers/scsi/device_handler/scsi_dh.c	2009-
> 10-20 18:26:03.000000000 -0700
> +++ linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh.c	2009-10-20
> 18:26:14.000000000 -0700
> @@ -226,7 +226,7 @@
>  			 * Activate a device handler
>  			 */
>  			if (scsi_dh->activate)
> -				err = scsi_dh->activate(sdev);
> +				err = scsi_dh->activate(sdev, NULL, NULL);
>  			else
>  				err = 0;
>  		}
> @@ -423,10 +423,17 @@
>  /*
>   * scsi_dh_activate - activate the path associated with the
> scsi_device
>   *      corresponding to the given request queue.
> - * @q - Request queue that is associated with the scsi_device to be
> - *      activated.
> + *     Returns immediately without waiting for activation to be
> completed.
> + * @q    - Request queue that is associated with the scsi_device to be
> + *         activated.
> + * @fn   - Function to be called upon completion of the activation.
> + *         Function fn is called with data (below) and the error code.
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
>  	int err = 0;
>  	unsigned long flags;
> @@ -445,7 +452,7 @@
>  		return err;
> 
>  	if (scsi_dh->activate)
> -		err = scsi_dh->activate(sdev);
> +		err = scsi_dh->activate(sdev, fn, data);
>  	put_device(&sdev->sdev_gendev);
>  	return err;
>  }
> Index: linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c
> ===================================================================
> --- linux-2.6.32-rc5.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
> 	2009-10-20 18:26:03.000000000 -0700
> +++ linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-
> 10-20 18:26:14.000000000 -0700
> @@ -568,7 +568,8 @@
>  	return err;
>  }
> 
> -static int rdac_activate(struct scsi_device *sdev)
> +static int rdac_activate(struct scsi_device *sdev,
> +			activate_complete fn, void *data)
>  {
>  	struct rdac_dh_data *h = get_rdac_data(sdev);
>  	int err = SCSI_DH_OK;
> @@ -580,7 +581,9 @@
>  	if (h->lun_state == RDAC_LUN_UNOWNED)
>  		err = send_mode_select(sdev, h);
>  done:
> -	return err;
> +	if (fn)
> +		fn(data, err);
> +	return 0;
>  }
> 
>  static int rdac_prep_fn(struct scsi_device *sdev, struct request *req)
> Index: linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_alua.c
> ===================================================================
> --- linux-2.6.32-rc5.orig/drivers/scsi/device_handler/scsi_dh_alua.c
> 	2009-10-20 18:26:03.000000000 -0700
> +++ linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_alua.c	2009-
> 10-20 18:26:14.000000000 -0700
> @@ -652,7 +652,8 @@
>   * based on a certain policy. But until we actually encounter them it
>   * should be okay.
>   */
> -static int alua_activate(struct scsi_device *sdev)
> +static int alua_activate(struct scsi_device *sdev,
> +			activate_complete fn, void *data)
>  {
>  	struct alua_dh_data *h = get_alua_data(sdev);
>  	int err = SCSI_DH_OK;
> @@ -667,7 +668,9 @@
>  		err = alua_stpg(sdev, TPGS_STATE_OPTIMIZED, h);
> 
>  out:
> -	return err;
> +	if (fn)
> +		fn(data, err);
> +	return 0;
>  }
> 
>  /*
> Index: linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_emc.c
> ===================================================================
> --- linux-2.6.32-rc5.orig/drivers/scsi/device_handler/scsi_dh_emc.c
> 	2009-10-20 18:26:03.000000000 -0700
> +++ linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_emc.c	2009-
> 10-20 18:26:14.000000000 -0700
> @@ -528,7 +528,8 @@
>  	return err;
>  }
> 
> -static int clariion_activate(struct scsi_device *sdev)
> +static int clariion_activate(struct scsi_device *sdev,
> +				activate_complete fn, void *data)
>  {
>  	struct clariion_dh_data *csdev = get_clariion_data(sdev);
>  	int result;
> @@ -559,7 +560,9 @@
>  		    csdev->port, lun_state[csdev->lun_state],
>  		    csdev->default_sp + 'A');
> 
> -	return result;
> +	if (fn)
> +		fn(data, result);
> +	return 0;
>  }
>  /*
>   * params - parameters in the following format
> Index: linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> ===================================================================
> --- linux-2.6.32-rc5.orig/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> 	2009-10-20 18:26:03.000000000 -0700
> +++ linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_hp_sw.c	2009-
> 10-20 18:26:14.000000000 -0700
> @@ -268,7 +268,8 @@
>   * activate the passive path (and deactivate the
>   * previously active one).
>   */
> -static int hp_sw_activate(struct scsi_device *sdev)
> +static int hp_sw_activate(struct scsi_device *sdev,
> +				activate_complete fn, void *data)
>  {
>  	int ret = SCSI_DH_OK;
>  	struct hp_sw_dh_data *h = get_hp_sw_data(sdev);
> @@ -283,7 +284,9 @@
>  				    HP_SW_NAME);
>  	}
> 
> -	return ret;
> +	if (fn)
> +		fn(data, ret);
> +	return 0;
>  }
> 
>  static const struct scsi_dh_devlist hp_sw_dh_data_list[] = {
> Index: linux-2.6.32-rc5/include/scsi/scsi_device.h
> ===================================================================
> --- linux-2.6.32-rc5.orig/include/scsi/scsi_device.h	2009-10-20
> 18:26:03.000000000 -0700
> +++ linux-2.6.32-rc5/include/scsi/scsi_device.h	2009-10-20
> 18:26:14.000000000 -0700
> @@ -174,6 +174,7 @@
>  	char *model;
>  };
> 
> +typedef void (*activate_complete)(void *, int);
>  struct scsi_device_handler {
>  	/* Used by the infrastructure */
>  	struct list_head list; /* list of scsi_device_handlers */
> @@ -185,7 +186,7 @@
>  	int (*check_sense)(struct scsi_device *, struct scsi_sense_hdr
> *);
>  	int (*attach)(struct scsi_device *);
>  	void (*detach)(struct scsi_device *);
> -	int (*activate)(struct scsi_device *);
> +	int (*activate)(struct scsi_device *, activate_complete, void *);
>  	int (*prep_fn)(struct scsi_device *, struct request *);
>  	int (*set_params)(struct scsi_device *, const char *);
>  };
> Index: linux-2.6.32-rc5/drivers/md/dm-mpath.c
> ===================================================================
> --- linux-2.6.32-rc5.orig/drivers/md/dm-mpath.c	2009-10-20
> 18:26:03.000000000 -0700
> +++ linux-2.6.32-rc5/drivers/md/dm-mpath.c	2009-10-20
> 18:26:14.000000000 -0700
> @@ -1116,8 +1116,9 @@
>  	return limit_reached;
>  }
> 
> -static void pg_init_done(struct dm_path *path, int errors)
> +static void pg_init_done(void *data, int errors)
>  {
> +	struct dm_path *path = data;
>  	struct pgpath *pgpath = path_to_pgpath(path);
>  	struct priority_group *pg = pgpath->pg;
>  	struct multipath *m = pg->m;
> @@ -1183,12 +1184,11 @@
> 
>  static void activate_path(struct work_struct *work)
>  {
> -	int ret;
>  	struct pgpath *pgpath =
>  		container_of(work, struct pgpath, activate_path);
> 
> -	ret = scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev));
> -	pg_init_done(&pgpath->path, ret);
> +	scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
> +				pg_init_done, &pgpath->path);
>  }
> 
>  /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
