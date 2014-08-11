From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V4 2/4] Introduce xen-scsifront module
Date: Mon, 11 Aug 2014 02:54:24 -0700
Message-ID: <20140811095424.GB5952@infradead.org>
References: <1407484194-31876-1-git-send-email-jgross@suse.com>
 <1407484194-31876-3-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1407484194-31876-3-git-send-email-jgross@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: jgross@suse.com
Cc: xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, JBottomley@parallels.com, konrad.wilk@oracle.com, hch@infradead.org, david.vrabel@citrix.com, JBeulich@suse.com
List-Id: linux-scsi@vger.kernel.org

> +	BUG_ON(sc->cmd_len > VSCSIIF_MAX_COMMAND_SIZE);
> +
> +	if (sc->cmd_len)

I can't see how you can get a zero cmd_len here.

> +static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)

Please add a comment explaining your unusual EH strategy here.

> +static void scsifront_free(struct vscsifrnt_info *info)
> +{
> +	if (info->host && info->host_active) {
> +		/* Scsi_host not yet removed */
> +		scsi_remove_host(info->host);
> +		info->host_active = 0;
> +	}
> +
> +	if (info->ring_ref != GRANT_INVALID_REF) {
> +		gnttab_end_foreign_access(info->ring_ref, 0,
> +					  (unsigned long)info->ring.sring);
> +		info->ring_ref = GRANT_INVALID_REF;
> +		info->ring.sring = NULL;
> +	}
> +
> +	if (info->irq)
> +		unbind_from_irqhandler(info->irq, info);
> +	info->irq = 0;
> +	info->evtchn = 0;
> +
> +	if (info->host)
> +		scsi_host_put(info->host);
> +}

I don't think most of the ifs should be here, just use proper symmetric
goto unwinding in the initialization error path instead.

The way this function can be called from different levels of the
callstack on init failure is very confusing.

> +		switch (op) {
> +		case VSCSIFRONT_OP_ADD_LUN:
> +			if (device_state == XenbusStateInitialised) {
> +				sdev = __scsi_add_device(info->host, chn, tgt,
> +							lun, NULL);
> +				err = (IS_ERR(sdev) || !sdev->hostdata);
> +				if (!IS_ERR(sdev)) {
> +					sdev->hostdata = NULL;
> +					scsi_device_put(sdev);
> +				}

Given that you put the device immediatly you should be using
scsi_add_device instead of __scsi_add_device.  Also all the messing
with ->hostdata from ->slave_alloc looks wrong.  For one thing every
setup done ->slave_alloc should be paired with teardown in
->slave_destroy.  Second I don't see any need for that.

> +				} else {
> +					xenbus_printf(XBT_NIL, dev->nodename,
> +						      state_str, "%d",
> +						      XenbusStateConnected);
> +				}

Just print this message in ->slave_configure. 
