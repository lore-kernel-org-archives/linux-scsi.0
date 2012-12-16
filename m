From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH 05/16] libfcoe, fcoe, bnx2fc: Add new fcoe control
 interface
Date: Sun, 16 Dec 2012 11:50:28 -0800
Message-ID: <50CE2604.4050106@broadcom.com>
References: <20121212232203.13084.3630.stgit@fritz>
 <20121212232230.13084.56240.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3335 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab2LPTxH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Dec 2012 14:53:07 -0500
In-Reply-To: <20121212232230.13084.56240.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>

On 12/12/2012 03:22 PM, Robert Love wrote:
> +ssize_t fcoe_ctlr_create_store(struct bus_type *bus,
> +			       const char *buf, size_t count)
> +{
> +	struct net_device *netdev = NULL;
> +	struct fcoe_transport *ft = NULL;
> +	struct fcoe_ctlr_device *ctlr_dev = NULL;
> +	int rc = 0;
> +	int err;
> +
> +	mutex_lock(&ft_mutex);
> +
> +	netdev = fcoe_if_to_netdev(buf);
> +	if (!netdev) {
> +		LIBFCOE_TRANSPORT_DBG("Invalid device %s.\n", buf);
> +		rc = -ENODEV;
> +		goto out_nodev;
> +	}
> +
> +	ft = fcoe_netdev_map_lookup(netdev);
> +	if (ft) {
> +		LIBFCOE_TRANSPORT_DBG("transport %s already has existing "
> +				      "FCoE instance on %s.\n",
> +				      ft->name, netdev->name);
> +		rc = -EEXIST;
> +		goto out_putdev;
> +	}
> +
> +	ft = fcoe_transport_lookup(netdev);
> +	if (!ft) {
> +		LIBFCOE_TRANSPORT_DBG("no FCoE transport found for %s.\n",
> +				      netdev->name);
> +		rc = -ENODEV;
> +		goto out_putdev;
> +	}
> +
> +	/* pass to transport create */
> +	err = ft->alloc ? ft->alloc(netdev) : -ENODEV;
> +	if (err) {
> +		fcoe_del_netdev_mapping(netdev);
> +		rc = -ENOMEM;
> +		goto out_putdev;
> +	}
> +
> +	err = fcoe_add_netdev_mapping(netdev, ft);
> +	if (err) {
> +		LIBFCOE_TRANSPORT_DBG("failed to add new netdev mapping "
> +				      "for FCoE transport %s for %s.\n",
> +				      ft->name, netdev->name);
> +		rc = -ENODEV;
> +		goto out_putdev;
> +	}
> +
> +	LIBFCOE_TRANSPORT_DBG("transport %s %s to create fcoe on %s.\n",
> +			      ft->name, (ctlr_dev) ? "succeeded" : "failed",
> +			      netdev->name);

ctlr_dev is initialized to NULL and not updated anywhere in this 
function, and hence the above debug statement will always say that 
'create' failed.

> +
> +out_putdev:
> +	dev_put(netdev);
> +out_nodev:
> +	mutex_unlock(&ft_mutex);
> +	if (rc)
> +		return rc;
> +	return count;
> +}
>


