From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH][RESEND] scsi_sysfs: add 'is_bin_visible' callback
Date: Tue, 1 Mar 2016 14:04:48 +0100
Message-ID: <20160301130448.GB7616@lst.de>
References: <1456807945-88857-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40391 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbcCANEu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2016 08:04:50 -0500
Content-Disposition: inline
In-Reply-To: <1456807945-88857-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, Mar 01, 2016 at 05:52:25AM +0100, Hannes Reinecke wrote:
> +	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +
> +
> +	rcu_read_lock();
> +	if (attr == &dev_attr_vpd_pg80 &&
> +	    !rcu_dereference(sdev->vpd_pg80)) {
> +		rcu_read_unlock();
> +		return 0;
> +	}
> +	if (attr == &dev_attr_vpd_pg83 &&
> +	    !rcu_dereference(sdev->vpd_pg83)) {
> +		rcu_read_unlock();
> +		return 0;
> +	}
> +	rcu_read_unlock();

We are only checking the pointers for being non-zero.  No need for the
rcu_read_lock() or rcu_dereference() here.

Otherwise this looks fine to me.
