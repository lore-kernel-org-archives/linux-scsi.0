From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] aacraid: handle AIF hotplug events
Date: Sat, 10 Sep 2005 17:50:28 +0100
Message-ID: <20050910165028.GA3662@infradead.org>
References: <1126212613.7479.20.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50612 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932087AbVIJQuf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2005 12:50:35 -0400
Content-Disposition: inline
In-Reply-To: <1126212613.7479.20.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

> +			if ((dev != (struct aac_dev *)NULL)
> +			 && (dev->scsi_host_ptr != (struct Scsi_Host *)NULL)) {

no need for the casts.

> +	shost_for_each_device(device, dev->scsi_host_ptr)
> +	{
> +		if ((device->channel == CONTAINER_TO_CHANNEL(container))
> +		 && (device->id == CONTAINER_TO_ID(container))
> +		 && (device->lun == CONTAINER_TO_LUN(container))) {
> +			busy |= device->device_busy ||
> +				test_bit(SHOST_RECOVERY,
> +				(const unsigned long*)&dev->scsi_host_ptr->shost_state);

this is broken.  You must not look at the device_busy field from a driver,
and it means something different than what seems intended here.  Also
the direct messing with the host state is wrong.

> +			if (busy == 0) {
> +				device->removable = 1;

devce->removeable means the device has a removable medium, not that
it can go away.

---end quoted text---
