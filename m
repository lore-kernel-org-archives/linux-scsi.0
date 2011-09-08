From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2 15/18] fcoe: Move common functions to fcoe_transport
 library
Date: Thu, 08 Sep 2011 06:11:09 -0500
Message-ID: <4E68A2CD.5020804@cs.wisc.edu>
References: <1312504732-4572-1-git-send-email-bprakash@broadcom.com> <1312504732-4572-16-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39597 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758206Ab1IHLGm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2011 07:06:42 -0400
In-Reply-To: <1312504732-4572-16-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org

On 08/04/2011 07:38 PM, Bhanu Prakash Gollapudi wrote:
>  /**
> - * fcoe_get_wwn() - Get the world wide name from LLD if it supports =
it
> - * @netdev: the associated net device
> - * @wwn: the output WWN
> - * @type: the type of WWN (WWPN or WWNN)
> - *
> - * Returns: 0 for success
> - */
> -static int fcoe_get_wwn(struct net_device *netdev, u64 *wwn, int typ=
e)
> -{
> -	const struct net_device_ops *ops =3D netdev->netdev_ops;
> -
> -	if (ops->ndo_fcoe_get_wwn)
> -		return ops->ndo_fcoe_get_wwn(netdev, wwn, type);
> -	return -EINVAL;
> -}
> -
> -/**



> +/**
> + * fcoe_get_wwn() - Get the world wide name from LLD if it supports =
it
> + * @netdev: the associated net device
> + * @wwn: the output WWN
> + * @type: the type of WWN (WWPN or WWNN)
> + *
> + * Returns: 0 for success
> + */
> +int fcoe_get_wwn(struct net_device *netdev, u64 *wwn, int type)
> +{
> +	const struct net_device_ops *ops =3D netdev->netdev_ops;
> +
> +	if (ops->ndo_fcoe_get_wwn)
> +		return ops->ndo_fcoe_get_wwn(netdev, wwn, type);
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(fcoe_get_wwn);
> +
>

I got a report that this is going to be a problem because the fcoe ops
like ndo_fcoe_get_wwn are defined when CONFIG_FCOE is set. That is set
for fcoe.ko. If you move functions calling those callouts to libfcoe
then it is possible CONFIG_FCOE is not set (if you were just using
bnx2fc.ko and not using fcoe.ko for example), and the build fails like =
this:


drivers/scsi/fcoe/fcoe_transport.c: In function =91fcoe_get_wwn=92:
drivers/scsi/fcoe/fcoe_transport.c:152: error: =91const struct
net_device_ops=92 has no member named =91ndo_fcoe_get_wwn=92
drivers/scsi/fcoe/fcoe_transport.c:153: error: =91const struct
net_device_ops=92 has no member named =91ndo_fcoe_get_wwn=92
make[3]: *** [drivers/scsi/fcoe/fcoe_transport.o] Error 1


Do we need some ifdefs in libfcoe around the ops use or should there be
some sort of lower level transport module callouts (or whatever modules
like bnxfc and fcoe are called) that libfcoe calls into so those driver=
s
can call into something like the netdev callouts if they use them?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
