From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix a memory leak in scsi_host_dev_release()
Date: Sun, 22 Nov 2015 07:08:43 -0800
Message-ID: <20151122150843.GA22822@infradead.org>
References: <564D0224.9040001@sandisk.com>
 <20151120115212.GA23875@infradead.org>
 <564F5D36.8010402@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbbKVPIp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2015 10:08:45 -0500
Content-Disposition: inline
In-Reply-To: <564F5D36.8010402@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Fri, Nov 20, 2015 at 09:49:42AM -0800, Bart Van Assche wrote:
> On 11/20/2015 03:52 AM, Christoph Hellwig wrote:
> >the memory leak looks real, and your fix looks corret, but I still
> >don't like it.
> >
> >I think it's reasonable for SCSI to assume that the final put_device
> >fully frees the struct device including the name pointer that is
> >assigned entirely behind the back of the caller.
> >
> >So I think the fix for this probably should be in the driver core.
> 
> Hello Christoph,
> 
> Thanks for the feedback. However, I'm not sure this can be fixed by
> modifying the driver core. If scsi_host_remove() is not called the SCSI core
> doesn't call put_device(&shost->shost_dev). I will post a second version of
> this patch that ensures that the SCSI core always calls
> put_device(&shost->shost_dev).


Oh, I see.  The release method is called on shost_gendev, but the
name that needs to be freed is in shost_dev.  I take my comment on the
core back.

Let's get this patch in for now and see if we can do something about the
creative driver model (ab-)use for struct Scsi_Host in the long run.

Reviewed-by: Christoph Hellwig <hch@lst.de>
