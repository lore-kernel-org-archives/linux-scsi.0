From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH][RESEND] scsi_sysfs: add 'is_bin_visible' callback
Date: Wed, 2 Mar 2016 10:19:16 +0100
Message-ID: <20160302091916.GE1308@lst.de>
References: <1456807945-88857-1-git-send-email-hare@suse.de> <20160301130448.GB7616@lst.de> <56D6973A.4070901@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45065 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbcCBJTS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2016 04:19:18 -0500
Content-Disposition: inline
In-Reply-To: <56D6973A.4070901@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, Mar 02, 2016 at 03:33:14PM +0800, Hannes Reinecke wrote:
> >> +	rcu_read_lock();
> >> +	if (attr == &dev_attr_vpd_pg80 &&
> >> +	    !rcu_dereference(sdev->vpd_pg80)) {
> >> +		rcu_read_unlock();
> >> +		return 0;
> >> +	}
> >> +	if (attr == &dev_attr_vpd_pg83 &&
> >> +	    !rcu_dereference(sdev->vpd_pg83)) {
> >> +		rcu_read_unlock();
> >> +		return 0;
> >> +	}
> >> +	rcu_read_unlock();
> > 
> > We are only checking the pointers for being non-zero.  No need for the
> > rcu_read_lock() or rcu_dereference() here.
> > 
> Better to be same than sorry; some overly clever code analysis tool
> might trip over it otherwise.

It shouldn't.  There is no dereference going on here.

> 
> > Otherwise this looks fine to me.
> 
> Reviewed-by: ?

Only without the cargo culted rcu magic.
