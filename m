From: "Zou, Yi" <yi.zou@intel.com>
Subject: RE: [PATCH 15/18] fcoe: Move common functions to fcoe_transport
 library
Date: Thu, 4 Aug 2011 16:09:53 -0700
Message-ID: <5A9BD224CEA58D4CB62235967D650C1609BBC45B@orsmsx509.amr.corp.intel.com>
References: <1312483633-479-1-git-send-email-bprakash@broadcom.com>
 <1312483633-479-16-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:48993 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab1HDXJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2011 19:09:56 -0400
In-Reply-To: <1312483633-479-16-git-send-email-bprakash@broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "mchan@broadcom.com" <mchan@broadcom.com>, "Love, Robert W" <robert.w.love@intel.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>

> Export fcoe_get_wwn, fcoe_validate_vport_create and fcoe_wwn_to_str so
> that all
> LLDs can use these common function.
> Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

This looks good to me.

-thanks,

Acked-by: Yi Zou <yi.zou@intel.com>


>
> ---
>  drivers/scsi/fcoe/fcoe.c           |   66 +-----------------------------
> ---
>  drivers/scsi/fcoe/fcoe.h           |   10 -----
>  drivers/scsi/fcoe/fcoe_transport.c |   72
> ++++++++++++++++++++++++++++++++++++
>  include/scsi/libfcoe.h             |    3 +
>  4 files changed, 76 insertions(+), 75 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index ba710e3..c30fa27 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -138,7 +138,6 @@ static int fcoe_vport_create(struct fc_vport *, bool
> disabled);
>  static int fcoe_vport_disable(struct fc_vport *, bool disable);
>  static void fcoe_set_vport_symbolic_name(struct fc_vport *);
>  static void fcoe_set_port_id(struct fc_lport *, u32, struct fc_frame *);
> -static int fcoe_validate_vport_create(struct fc_vport *);
> 
>  static struct libfc_function_template fcoe_libfc_fcn_templ = {
>  	.frame_send = fcoe_xmit,
> @@ -577,23 +576,6 @@ static int fcoe_lport_config(struct fc_lport *lport)
>  }
> 
>  /**
> - * fcoe_get_wwn() - Get the world wide name from LLD if it supports it
> - * @netdev: the associated net device
> - * @wwn: the output WWN
> - * @type: the type of WWN (WWPN or WWNN)
> - *
> - * Returns: 0 for success
> - */
> -static int fcoe_get_wwn(struct net_device *netdev, u64 *wwn, int type)
> -{
> -	const struct net_device_ops *ops = netdev->netdev_ops;
> -
> -	if (ops->ndo_fcoe_get_wwn)
> -		return ops->ndo_fcoe_get_wwn(netdev, wwn, type);
> -	return -EINVAL;
> -}
> -
> -/**
>   * fcoe_netdev_features_change - Updates the lport's offload flags based
>   * on the LLD netdev's FCoE feature flags
>   */
> @@ -2444,7 +2426,7 @@ static int fcoe_vport_create(struct fc_vport *vport,
> bool disabled)
> 
>  	rc = fcoe_validate_vport_create(vport);
>  	if (rc) {
> -		wwn_to_str(vport->port_name, buf, sizeof(buf));
> +		fcoe_wwn_to_str(vport->port_name, buf, sizeof(buf));
>  		printk(KERN_ERR "fcoe: Failed to create vport, "
>  			"WWPN (0x%s) already exists\n",
>  			buf);
> @@ -2596,49 +2578,3 @@ static void fcoe_set_port_id(struct fc_lport
> *lport,
>  	if (fp && fc_frame_payload_op(fp) == ELS_FLOGI)
>  		fcoe_ctlr_recv_flogi(&fcoe->ctlr, lport, fp);
>  }
> -
> -/**
> - * fcoe_validate_vport_create() - Validate a vport before creating it
> - * @vport: NPIV port to be created
> - *
> - * This routine is meant to add validation for a vport before creating
> it
> - * via fcoe_vport_create().
> - * Current validations are:
> - *      - WWPN supplied is unique for given lport
> - *
> - *
> -*/
> -static int fcoe_validate_vport_create(struct fc_vport *vport)
> -{
> -	struct Scsi_Host *shost = vport_to_shost(vport);
> -	struct fc_lport *n_port = shost_priv(shost);
> -	struct fc_lport *vn_port;
> -	int rc = 0;
> -	char buf[32];
> -
> -	mutex_lock(&n_port->lp_mutex);
> -
> -	wwn_to_str(vport->port_name, buf, sizeof(buf));
> -	/* Check if the wwpn is not same as that of the lport */
> -	if (!memcmp(&n_port->wwpn, &vport->port_name, sizeof(u64))) {
> -		FCOE_DBG("vport WWPN 0x%s is same as that of the "
> -			"base port WWPN\n", buf);
> -		rc = -EINVAL;
> -		goto out;
> -	}
> -
> -	/* Check if there is any existing vport with same wwpn */
> -	list_for_each_entry(vn_port, &n_port->vports, list) {
> -		if (!memcmp(&vn_port->wwpn, &vport->port_name, sizeof(u64)))
> {
> -			FCOE_DBG("vport with given WWPN 0x%s already "
> -			"exists\n", buf);
> -			rc = -EINVAL;
> -			break;
> -		}
> -	}
> -
> -out:
> -	mutex_unlock(&n_port->lp_mutex);
> -
> -	return rc;
> -}
> diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
> index c4a9399..408a6fd 100644
> --- a/drivers/scsi/fcoe/fcoe.h
> +++ b/drivers/scsi/fcoe/fcoe.h
> @@ -99,14 +99,4 @@ static inline struct net_device *fcoe_netdev(const
> struct fc_lport *lport)
>  			((struct fcoe_port *)lport_priv(lport))->priv)->netdev;
>  }
> 
> -static inline void wwn_to_str(u64 wwn, char *buf, int len)
> -{
> -	u8 wwpn[8];
> -
> -	u64_to_wwn(wwn, wwpn);
> -	snprintf(buf, len, "%02x%02x%02x%02x%02x%02x%02x%02x",
> -		wwpn[0], wwpn[1], wwpn[2], wwpn[3],
> -		wwpn[4], wwpn[5], wwpn[6], wwpn[7]);
> -}
> -
>  #endif /* _FCOE_H_ */
> diff --git a/drivers/scsi/fcoe/fcoe_transport.c
> b/drivers/scsi/fcoe/fcoe_transport.c
> index 41068e8..50c8c4a 100644
> --- a/drivers/scsi/fcoe/fcoe_transport.c
> +++ b/drivers/scsi/fcoe/fcoe_transport.c
> @@ -83,6 +83,78 @@ static struct notifier_block libfcoe_notifier = {
>  	.notifier_call = libfcoe_device_notification,
>  };
> 
> +void fcoe_wwn_to_str(u64 wwn, char *buf, int len)
> +{
> +	u8 wwpn[8];
> +
> +	u64_to_wwn(wwn, wwpn);
> +	snprintf(buf, len, "%02x%02x%02x%02x%02x%02x%02x%02x",
> +		 wwpn[0], wwpn[1], wwpn[2], wwpn[3],
> +		 wwpn[4], wwpn[5], wwpn[6], wwpn[7]);
> +}
> +EXPORT_SYMBOL_GPL(fcoe_wwn_to_str);
> +
> +/**
> + * fcoe_validate_vport_create() - Validate a vport before creating it
> + * @vport: NPIV port to be created
> + *
> + * This routine is meant to add validation for a vport before creating
> it
> + * via fcoe_vport_create().
> + * Current validations are:
> + *      - WWPN supplied is unique for given lport
> + */
> +int fcoe_validate_vport_create(struct fc_vport *vport)
> +{
> +	struct Scsi_Host *shost = vport_to_shost(vport);
> +	struct fc_lport *n_port = shost_priv(shost);
> +	struct fc_lport *vn_port;
> +	int rc = 0;
> +	char buf[32];
> +
> +	mutex_lock(&n_port->lp_mutex);
> +
> +	fcoe_wwn_to_str(vport->port_name, buf, sizeof(buf));
> +	/* Check if the wwpn is not same as that of the lport */
> +	if (!memcmp(&n_port->wwpn, &vport->port_name, sizeof(u64))) {
> +		LIBFCOE_TRANSPORT_DBG("vport WWPN 0x%s is same as that of the
> "
> +				      "base port WWPN\n", buf);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* Check if there is any existing vport with same wwpn */
> +	list_for_each_entry(vn_port, &n_port->vports, list) {
> +		if (!memcmp(&vn_port->wwpn, &vport->port_name, sizeof(u64)))
> {
> +			LIBFCOE_TRANSPORT_DBG("vport with given WWPN 0x%s "
> +					      "already exists\n", buf);
> +			rc = -EINVAL;
> +			break;
> +		}
> +	}
> +out:
> +	mutex_unlock(&n_port->lp_mutex);
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(fcoe_validate_vport_create);
> +
> +/**
> + * fcoe_get_wwn() - Get the world wide name from LLD if it supports it
> + * @netdev: the associated net device
> + * @wwn: the output WWN
> + * @type: the type of WWN (WWPN or WWNN)
> + *
> + * Returns: 0 for success
> + */
> +int fcoe_get_wwn(struct net_device *netdev, u64 *wwn, int type)
> +{
> +	const struct net_device_ops *ops = netdev->netdev_ops;
> +
> +	if (ops->ndo_fcoe_get_wwn)
> +		return ops->ndo_fcoe_get_wwn(netdev, wwn, type);
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(fcoe_get_wwn);
> +
>  /**
>   * fcoe_fc_crc() - Calculates the CRC for a given frame
>   * @fp: The frame to be checksumed
> diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
> index 8c1638b..0b2f843 100644
> --- a/include/scsi/libfcoe.h
> +++ b/include/scsi/libfcoe.h
> @@ -229,6 +229,9 @@ int fcoe_libfc_config(struct fc_lport *, struct
> fcoe_ctlr *,
>  		      const struct libfc_function_template *, int init_fcp);
>  u32 fcoe_fc_crc(struct fc_frame *fp);
>  int fcoe_start_io(struct sk_buff *skb);
> +int fcoe_get_wwn(struct net_device *netdev, u64 *wwn, int type);
> +void fcoe_wwn_to_str(u64 wwn, char *buf, int len);
> +int fcoe_validate_vport_create(struct fc_vport *vport);
> 
>  /**
>   * is_fip_mode() - returns true if FIP mode selected.
> --
> 1.7.0.6
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
