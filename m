From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC PATCH v2 3/5] libfcoe, fcoe, bnx2fc: Add new fcoe control
 interface
Date: Sun, 30 Sep 2012 18:42:42 +0200
Message-ID: <50687682.1000101@acm.org>
References: <20120927020142.20592.56661.stgit@fritz> <20120927020158.20592.4844.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:48021 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2I3Qmq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2012 12:42:46 -0400
In-Reply-To: <20120927020158.20592.4844.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: cleech@redhat.com, bprakash@broadcom.com, devel@open-fcoe.org, linux-scsi@vger.kernel.org

On 09/27/12 04:01, Robert Love wrote:
> +static ssize_t store_ctlr_enabled(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t count)
> +{
> +	struct fcoe_ctlr_device *ctlr = dev_to_ctlr(dev);
> +	int val;
> +	int rc;
> +
> +	rc = sscanf(buf, "%d", &val);
> +	if (!rc)
> +		return -EINVAL;

sscanf() expects a '\0'-terminated buffer which is not guaranteed by the 
caller of this function (sysfs), isn't it ?

> @@ -830,6 +983,18 @@ int __init fcoe_sysfs_setup(void)
>   	if (error)
>   		return error;
>
> +	error = bus_create_file(&fcoe_bus_type, &bus_attr_ctlr_create);
> +	if (error) {
> +		bus_unregister(&fcoe_bus_type);
> +		return error;
> +	}
> +
> +	error = bus_create_file(&fcoe_bus_type, &bus_attr_ctlr_destroy);
> +	if (error) {
> +		bus_unregister(&fcoe_bus_type);
> +		return error;
> +	}
> +
>   	return 0;
>   }

It might be a good idea to use fcoe_bus_type.bus_attrs instead of 
bus_create_file(). If someone ever would want to trigger these 
attributes from udev immediately after an fcoe bus instance has been 
created then that approach will avoid a race where udev gets notified 
before these attributes got created.

>   static int fcoe_add_netdev_mapping(struct net_device *netdev,
> -					struct fcoe_transport *ft)
> +				   struct fcoe_transport *ft)

Is the above whitespace change necessary ?

Bart.

