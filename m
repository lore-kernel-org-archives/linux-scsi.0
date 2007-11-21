From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [PATCH UPDATE] zfcp: add some internal zfcp adapter statistics
Date: Wed, 21 Nov 2007 14:40:54 +0100
Message-ID: <200711211440.54743.swen@vnet.ibm.com>
References: <200710311133.52090.swen@vnet.ibm.com> <20071103091722.GA7807@osiris.boeblingen.de.ibm.com> <200711091407.57796.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:39595 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbXKUNk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Nov 2007 08:40:58 -0500
In-Reply-To: <200711091407.57796.swen@vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

James

can you give me the status of the below patch ?
Is there anything missing from my side or is the patch still in review =
by you ?

Cheers Swen

On Friday 09 November 2007 14:07, Swen Schillig wrote:
> Updated the statistics patch to cover the issues pointed out by Heiko=
=2E
>=20
> James, could you please apply.
>=20
> Thanks
> Swen
>=20
> ---
> From: Swen Schillig <swen@vnet.ibm.com>
>=20
> add some statistics provided by the zFCP adapter to the sysfs
>=20
> The new zFCP adapter statistics provide a variety of information
> about the virtual adapter (subchannel). In order to collect this info=
rmation
> the zFCP driver is extended on one side to query the adapter and
> on the other side summarize certain values which can then be fetched =
on demand.
> This information is made available via files(attributes) in the sysfs=
 filesystem.
>=20
> The information provided by the new zFCP adapter statistics can be fe=
tched
> by reading from the following files in the sysfs filesystem
>=20
> =A0/sys/class/scsi_host/host<n>/seconds_active
> =A0/sys/class/scsi_host/host<n>/requests
> =A0/sys/class/scsi_host/host<n>/megabytes
> =A0/sys/class/scsi_host/host<n>/utilization
>=20
> These are the statistics on a virtual adapter (subchannel) level.
> In addition latency information is provided on a SCSI device level (L=
UN) which
> can be found at the following location
>=20
> =A0/sys/class/scsi_device/<H:C:T:L>/device/cmd_latency
> =A0/sys/class/scsi_device/<H:C:T:L>/device/read_latency
> =A0/sys/class/scsi_device/<H:C:T:L>/device/write_latency
>=20
>=20
> The information provided is raw and not modified or interpreted by an=
y means.
> No interpretation or modification of the values is done by the zFCP d=
river.
> The individual values are summed up during normal operation of the vi=
rtual adapter.
> An overrun of the variables is neither detected nor treated. The conc=
lusion is that
> the file has to be read twice to make a meaningful statement, because=
 only the differences of the values
> between the two reads can be used.
>=20
> The statistics make use of the SCSI mid-layer interface to provide it=
s data to the user.
> In detail two hooks from the scsi_host_template are used to integrate
> the zFCP statistics.
>=20
> =A0 =A0 struct scsi_host_template {
> =A0 =A0 =A0 =A0 =A0 =A0 ...
> =A0 =A0 =A0 =A0 =A0 =A0 .shost_attrs =3D zfcp_a_stats_attrs,
> =A0 =A0 =A0 =A0 =A0 =A0 .sdev_attrs =A0=3D zfcp_sysfs_sdev_attrs,
> =A0 =A0 =A0 =A0 =A0 =A0 ...
> =A0 =A0 };
>=20
>=20
> Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
> Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
> Signed-off-by: Michael Loehr <mloehr@de.ibm.com>
>=20
> ---
>  drivers/s390/scsi/zfcp_aux.c  |    2=20
>  drivers/s390/scsi/zfcp_def.h  |   14 +++
>  drivers/s390/scsi/zfcp_fsf.c  |   39 ++++++++++
>  drivers/s390/scsi/zfcp_fsf.h  |   29 +++++++-
>  drivers/s390/scsi/zfcp_scsi.c |  149 +++++++++++++++++++++++++++++++=
+++++++++++
>  5 files changed, 230 insertions(+), 3 deletions(-)
>=20
> Index: scsi-misc/drivers/s390/scsi/zfcp_def.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- scsi-misc.orig/drivers/s390/scsi/zfcp_def.h
> +++ scsi-misc/drivers/s390/scsi/zfcp_def.h
> @@ -869,6 +869,18 @@ struct zfcp_erp_action {
>  	struct timer_list timer;
>  };
> =20
> +struct latency_cont {
> +	u32 channel;
> +	u32 fabric;
> +	u32 counter;
> +};
> +
> +struct zfcp_latencies {
> +	struct latency_cont read;
> +	struct latency_cont write;
> +	struct latency_cont cmd;
> +	spinlock_t	lock;
> +};
> =20
>  struct zfcp_adapter {
>  	struct list_head	list;              /* list of adapters */
> @@ -884,6 +896,7 @@ struct zfcp_adapter {
>  	u32			adapter_features;  /* FCP channel features */
>  	u32			connection_features; /* host connection features */
>          u32			hardware_version;  /* of FCP channel */
> +	u16			timer_ticks;       /* time int for a tick */
>  	struct Scsi_Host	*scsi_host;	   /* Pointer to mid-layer */
>  	struct list_head	port_list_head;	   /* remote port list */
>  	struct list_head        port_remove_lh;    /* head of ports to be
> @@ -983,6 +996,7 @@ struct zfcp_unit {
>          struct scsi_device     *device;        /* scsi device struct=
 pointer */
>  	struct zfcp_erp_action erp_action;     /* pending error recovery */
>          atomic_t               erp_counter;
> +	struct zfcp_latencies  latencies;
>  };
> =20
>  /* FSF request */
> Index: scsi-misc/drivers/s390/scsi/zfcp_fsf.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- scsi-misc.orig/drivers/s390/scsi/zfcp_fsf.c
> +++ scsi-misc/drivers/s390/scsi/zfcp_fsf.c
> @@ -2079,6 +2079,7 @@ zfcp_fsf_exchange_config_evaluate(struct
>  		fc_host_supported_classes(shost) =3D
>  				FC_COS_CLASS2 | FC_COS_CLASS3;
>  		adapter->hydra_version =3D bottom->adapter_type;
> +		adapter->timer_ticks =3D bottom->timer_interval;
>  		if (fc_host_permanent_port_name(shost) =3D=3D -1)
>  			fc_host_permanent_port_name(shost) =3D
>  				fc_host_port_name(shost);
> @@ -3823,6 +3824,36 @@ zfcp_fsf_send_fcp_command_task_managemen
>  	return fsf_req;
>  }
> =20
> +static void zfcp_fsf_req_latency(struct zfcp_fsf_req *fsf_req)
> +{
> +	struct fsf_qual_latency_info *lat_inf;
> +	struct zfcp_unit *unit;
> +	unsigned long flags;
> +
> +	lat_inf =3D &fsf_req->qtcb->prefix.prot_status_qual.latency_info;
> +	unit =3D fsf_req->unit;
> +
> +	spin_lock_irqsave(&unit->latencies.lock, flags);
> +	switch (fsf_req->qtcb->bottom.io.data_direction) {
> +	case FSF_DATADIR_READ:
> +		unit->latencies.read.channel +=3D lat_inf->channel_lat;
> +		unit->latencies.read.fabric +=3D lat_inf->fabric_lat;
> +		unit->latencies.read.counter++;
> +		break;
> +	case FSF_DATADIR_WRITE:
> +		unit->latencies.write.channel +=3D lat_inf->channel_lat;
> +		unit->latencies.write.fabric +=3D lat_inf->fabric_lat;
> +		unit->latencies.write.counter++;
> +		break;
> +	case FSF_DATADIR_CMND:
> +		unit->latencies.cmd.channel +=3D lat_inf->channel_lat;
> +		unit->latencies.cmd.fabric +=3D lat_inf->fabric_lat;
> +		unit->latencies.cmd.counter++;
> +		break;
> +	}
> +	spin_unlock_irqrestore(&unit->latencies.lock, flags);
> +}
> +
>  /*
>   * function:    zfcp_fsf_send_fcp_command_handler
>   *
> @@ -4036,9 +4067,17 @@ zfcp_fsf_send_fcp_command_handler(struct
>  		break;
> =20
>  	case FSF_GOOD:
> +		if (fsf_req->adapter->adapter_features &
> +		    FSF_FEATURE_MEASUREMENT_DATA)
> +			zfcp_fsf_req_latency(fsf_req);
>  		break;
> =20
>  	case FSF_FCP_RSP_AVAILABLE:
> +		if ((fsf_req->qtcb->prefix.prot_status &
> +		     FSF_PROT_FSF_STATUS_PRESENTED) &&
> +		    (fsf_req->adapter->adapter_features &
> +		     FSF_FEATURE_MEASUREMENT_DATA))
> +			zfcp_fsf_req_latency(fsf_req);
>  		break;
> =20
>  	default:
> Index: scsi-misc/drivers/s390/scsi/zfcp_fsf.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- scsi-misc.orig/drivers/s390/scsi/zfcp_fsf.h
> +++ scsi-misc/drivers/s390/scsi/zfcp_fsf.h
> @@ -213,6 +213,7 @@
>  #define FSF_FEATURE_HBAAPI_MANAGEMENT           0x00000010
>  #define FSF_FEATURE_ELS_CT_CHAINED_SBALS        0x00000020
>  #define FSF_FEATURE_UPDATE_ALERT		0x00000100
> +#define FSF_FEATURE_MEASUREMENT_DATA		0x00000200
> =20
>  /* host connection features */
>  #define FSF_FEATURE_NPIV_MODE			0x00000001
> @@ -322,11 +323,18 @@ struct fsf_link_down_info {
>  	u8 vendor_specific_code;
>  } __attribute__ ((packed));
> =20
> +struct fsf_qual_latency_info {
> +	u32 channel_lat;
> +	u32 fabric_lat;
> +	u8 res1[8];
> +} __attribute__ ((packed));
> +
>  union fsf_prot_status_qual {
>  	u64 doubleword[FSF_PROT_STATUS_QUAL_SIZE / sizeof(u64)];
>  	struct fsf_qual_version_error   version_error;
>  	struct fsf_qual_sequence_error  sequence_error;
>  	struct fsf_link_down_info link_down_info;
> +	struct fsf_qual_latency_info latency_info;
>  } __attribute__ ((packed));
> =20
>  struct fsf_qtcb_prefix {
> @@ -340,6 +348,15 @@ struct fsf_qtcb_prefix {
>  	u8  res1[20];
>  } __attribute__ ((packed));
> =20
> +struct fsf_statistics_info {
> +	u64 input_req;
> +	u64 output_req;
> +	u64 control_req;
> +	u64 input_mb;
> +	u64 output_mb;
> +	u64 seconds_act;
> +} __attribute__ ((packed));
> +
>  union fsf_status_qual {
>  	u8  byte[FSF_STATUS_QUALIFIER_SIZE];
>  	u16 halfword[FSF_STATUS_QUALIFIER_SIZE / sizeof (u16)];
> @@ -427,7 +444,9 @@ struct fsf_qtcb_bottom_config {
>  	u32 fc_link_speed;
>  	u32 adapter_type;
>  	u32 peer_d_id;
> -	u8 res2[12];
> +	u8 res1[2];
> +	u16 timer_interval;
> +	u8 res2[8];
>  	u32 s_id;
>  	struct fsf_nport_serv_param nport_serv_param;
>  	u8 reserved_nport_serv_param[16];
> @@ -436,7 +455,8 @@ struct fsf_qtcb_bottom_config {
>  	u32 hardware_version;
>  	u8 serial_number[32];
>  	struct fsf_nport_serv_param plogi_payload;
> -	u8 res4[160];
> +	struct fsf_statistics_info stat_info;
> +	u8 res4[112];
>  } __attribute__ ((packed));
> =20
>  struct fsf_qtcb_bottom_port {
> @@ -469,7 +489,10 @@ struct fsf_qtcb_bottom_port {
>  	u64 control_requests;
>  	u64 input_mb;		/* where 1 MByte =3D=3D 1.000.000 Bytes */
>  	u64 output_mb;		/* where 1 MByte =3D=3D 1.000.000 Bytes */
> -	u8 res2[256];
> +	u8 cp_util;
> +	u8 cb_util;
> +	u8 a_util;
> +	u8 res2[253];
>  } __attribute__ ((packed));
> =20
>  union fsf_qtcb_bottom {
> Index: scsi-misc/drivers/s390/scsi/zfcp_scsi.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- scsi-misc.orig/drivers/s390/scsi/zfcp_scsi.c
> +++ scsi-misc/drivers/s390/scsi/zfcp_scsi.c
> @@ -39,6 +39,7 @@ static struct zfcp_unit *zfcp_unit_looku
>  					  unsigned int, unsigned int);
> =20
>  static struct device_attribute *zfcp_sysfs_sdev_attrs[];
> +static struct class_device_attribute *zfcp_a_stats_attrs[];
> =20
>  struct zfcp_data zfcp_data =3D {
>  	.scsi_host_template =3D {
> @@ -59,6 +60,7 @@ struct zfcp_data zfcp_data =3D {
>  		.use_clustering		=3D 1,
>  		.sdev_attrs		=3D zfcp_sysfs_sdev_attrs,
>  		.max_sectors		=3D ZFCP_MAX_SECTORS,
> +		.shost_attrs		=3D zfcp_a_stats_attrs,
>  	},
>  	.driver_version =3D ZFCP_VERSION,
>  };
> @@ -803,6 +805,35 @@ struct fc_function_template zfcp_transpo
>  	.disable_target_scan =3D 1,
>  };
> =20
> +#define ZFCP_DEFINE_LATENCY_ATTR(_name) 				  \
> +static ssize_t 								  \
> +zfcp_sysfs_unit_##_name##_latency_show(struct device *dev,		  \
> +				       struct device_attribute *attr,	  \
> +				       char *buf) {			  \
> +	struct scsi_device *sdev =3D to_scsi_device(dev);			  \
> +	struct zfcp_unit *unit =3D sdev->hostdata;			  \
> +	struct zfcp_latencies *lat =3D &unit->latencies;			  \
> +	struct zfcp_adapter *adapter =3D unit->port->adapter;		  \
> +	int    retval;							  \
> +	unsigned long flags;						  \
> +									  \
> +									  \
> +	spin_lock_irqsave(&lat->lock, flags);				  \
> +	retval =3D sprintf(buf, "%u %u %u\n",				  \
> +			 lat->_name.fabric * adapter->timer_ticks / 1000, \
> +			 lat->_name.channel * adapter->timer_ticks / 1000,\
> +			 lat->_name.counter);				  \
> +	spin_unlock_irqrestore(&lat->lock, flags);			  \
> +									  \
> +	return retval;							  \
> +}									  \
> +static DEVICE_ATTR(_name##_latency, S_IRUGO,				  \
> +		   zfcp_sysfs_unit_##_name##_latency_show, NULL);
> +
> +ZFCP_DEFINE_LATENCY_ATTR(read);
> +ZFCP_DEFINE_LATENCY_ATTR(write);
> +ZFCP_DEFINE_LATENCY_ATTR(cmd);
> +
>  /**
>   * ZFCP_DEFINE_SCSI_ATTR
>   * @_name:   name of show attribute
> @@ -833,6 +864,124 @@ static struct device_attribute *zfcp_sys
>  	&dev_attr_fcp_lun,
>  	&dev_attr_wwpn,
>  	&dev_attr_hba_id,
> +	&dev_attr_read_latency,
> +	&dev_attr_write_latency,
> +	&dev_attr_cmd_latency,
> +	NULL
> +};
> +
> +
> +static ssize_t
> +zfcp_sysfs_adapter_utilization_show(struct class_device *cdev, char =
*buf)
> +{
> +	struct Scsi_Host *scsi_host =3D class_to_shost(cdev);
> +	struct zfcp_adapter *adapter =3D (struct zfcp_adapter *)
> +						scsi_host->hostdata[0];
> +	struct fsf_qtcb_bottom_port *qtcb_port;
> +	int retval;
> +
> +	if (!(adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA))
> +		return -EOPNOTSUPP;
> +
> +	qtcb_port =3D kzalloc(sizeof(struct fsf_qtcb_bottom_port), GFP_KERN=
EL);
> +	if (!qtcb_port)
> +		return -ENOMEM;
> +
> +	retval =3D zfcp_fsf_exchange_port_data_sync(adapter, qtcb_port);
> +	if (!retval)
> +		retval =3D sprintf(buf, "%u %u %u\n", qtcb_port->cp_util,
> +				 qtcb_port->cb_util, qtcb_port->a_util);
> +	kfree(qtcb_port);
> +	return retval;
> +}
> +
> +static
> +CLASS_DEVICE_ATTR(utilization, S_IRUGO, zfcp_sysfs_adapter_utilizati=
on_show,
> +		   NULL);
> +
> +static int
> +zfcp_sysfs_adapter_ex_config(struct class_device *cdev,
> +			     struct fsf_qtcb_bottom_config **qtcb_config)
> +{
> +	struct Scsi_Host *scsi_host =3D class_to_shost(cdev);
> +	struct zfcp_adapter *adapter =3D (struct zfcp_adapter *)
> +						scsi_host->hostdata[0];
> +
> +	if (!(adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA))
> +		return -EOPNOTSUPP;
> +
> +	*qtcb_config =3D kzalloc(sizeof(struct fsf_qtcb_bottom_config),
> +			       GFP_KERNEL);
> +	if (!*qtcb_config)
> +		return -ENOMEM;
> +
> +	return zfcp_fsf_exchange_config_data_sync(adapter, *qtcb_config);
> +}
> +
> +static ssize_t
> +zfcp_sysfs_adapter_request_show(struct class_device *cdev, char *buf=
)
> +{
> +	struct fsf_qtcb_bottom_config *qtcb_config;
> +	int retval;
> +
> +	retval =3D zfcp_sysfs_adapter_ex_config(cdev, &qtcb_config);
> +
> +	if (!retval) {
> +		retval =3D sprintf(buf, "%lu %lu %lu\n",
> +				 qtcb_config->stat_info.input_req,
> +				 qtcb_config->stat_info.output_req,
> +				 qtcb_config->stat_info.control_req);
> +		kfree(qtcb_config);
> +	}
> +	return retval;
> +}
> +
> +static CLASS_DEVICE_ATTR(requests, S_IRUGO, zfcp_sysfs_adapter_reque=
st_show,
> +NULL);
> +
> +static ssize_t
> +zfcp_sysfs_adapter_mb_show(struct class_device *cdev, char *buf)
> +{
> +	struct fsf_qtcb_bottom_config *qtcb_config;
> +	int retval;
> +
> +	retval =3D zfcp_sysfs_adapter_ex_config(cdev, &qtcb_config);
> +
> +	if (!retval) {
> +		retval =3D sprintf(buf, "%lu %lu\n",
> +				 qtcb_config->stat_info.input_mb,
> +				 qtcb_config->stat_info.output_mb);
> +		kfree(qtcb_config);
> +	}
> +	return retval;
> +}
> +
> +static CLASS_DEVICE_ATTR(megabytes, S_IRUGO, zfcp_sysfs_adapter_mb_s=
how, NULL);
> +
> +static ssize_t
> +zfcp_sysfs_adapter_seconds_active_show(struct class_device *cdev, ch=
ar *buf)
> +{
> +	struct fsf_qtcb_bottom_config *qtcb_config;
> +	int retval;
> +
> +	retval =3D zfcp_sysfs_adapter_ex_config(cdev, &qtcb_config);
> +	if (!retval) {
> +		retval =3D sprintf(buf, "%lu\n",
> +				 qtcb_config->stat_info.seconds_act);
> +		kfree(qtcb_config);
> +	}
> +	return retval;
> +}
> +
> +static CLASS_DEVICE_ATTR(seconds_active, S_IRUGO,
> +		   zfcp_sysfs_adapter_seconds_active_show, NULL);
> +
> +
> +static struct class_device_attribute *zfcp_a_stats_attrs[] =3D {
> +	&class_device_attr_utilization,
> +	&class_device_attr_requests,
> +	&class_device_attr_megabytes,
> +	&class_device_attr_seconds_active,
>  	NULL
>  };
> =20
> Index: scsi-misc/drivers/s390/scsi/zfcp_aux.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- scsi-misc.orig/drivers/s390/scsi/zfcp_aux.c
> +++ scsi-misc/drivers/s390/scsi/zfcp_aux.c
> @@ -847,6 +847,8 @@ zfcp_unit_enqueue(struct zfcp_port *port
>  	/* mark unit unusable as long as sysfs registration is not complete=
 */
>  	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
> =20
> +	spin_lock_init(&unit->latencies.lock);
> +
>  	if (device_register(&unit->sysfs_device)) {
>  		kfree(unit);
>  		return NULL;
>
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
