From: David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH V3 2/4] Introduce xen-scsifront module
Date: Mon, 4 Aug 2014 13:16:09 +0100
Message-ID: <53DF7989.8040603@citrix.com>
References: <1407140870-542-1-git-send-email-jgross@suse.com> <1407140870-542-3-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1407140870-542-3-git-send-email-jgross@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: jgross@suse.com, xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, JBottomley@parallels.com, konrad.wilk@oracle.com, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On 04/08/14 09:27, jgross@suse.com wrote:
> 
> +
> +static void scsifront_backend_changed(struct xenbus_device *dev,
> +				      enum xenbus_state backend_state)
> +{
> +	struct vscsifrnt_info *info = dev_get_drvdata(&dev->dev);
> +
> +	DPRINTK("%p %u %u\n", dev, dev->state, backend_state);
> +
> +	switch (backend_state) {
> +	case XenbusStateUnknown:
> +	case XenbusStateInitialising:
> +	case XenbusStateInitWait:
> +	case XenbusStateInitialised:
> +		break;
> +
> +	case XenbusStateConnected:
> +		scsifront_read_backend_params(dev, info);
> +		if (xenbus_read_driver_state(dev->nodename) ==
> +			XenbusStateInitialised) {
> +			scsifront_do_lun_hotplug(info, VSCSIFRONT_OP_ADD_LUN);
> +		}
> +
> +		if (dev->state != XenbusStateConnected)
> +			xenbus_switch_state(dev, XenbusStateConnected);
> +		break;
> +
> +	case XenbusStateClosed:
> +		if (dev->state == XenbusStateClosed)
> +			break;
> +		/* Missed the backend's Closing state -- fallthrough */
> +	case XenbusStateClosing:
> +		scsifront_disconnect(info);
> +		break;
> +
> +	case XenbusStateReconfiguring:
> +		scsifront_do_lun_hotplug(info, VSCSIFRONT_OP_DEL_LUN);
> +		xenbus_switch_state(dev, XenbusStateReconfiguring);
> +		break;
> +
> +	case XenbusStateReconfigured:
> +		scsifront_do_lun_hotplug(info, VSCSIFRONT_OP_ADD_LUN);
> +		xenbus_switch_state(dev, XenbusStateConnected);
> +		break;
> +	}
> +}

I would like to see this state machine in common code but I'm not going
to insist on it since this is a existing driver.

Xen related parts:

Acked-by: David Vrabel <david.vrabel@citrix.com>

David
