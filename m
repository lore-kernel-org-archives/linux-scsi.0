From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix a memory leak in scsi_host_dev_release()
Date: Fri, 20 Nov 2015 03:52:12 -0800
Message-ID: <20151120115212.GA23875@infradead.org>
References: <564D0224.9040001@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52696 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbbKTLwU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2015 06:52:20 -0500
Content-Disposition: inline
In-Reply-To: <564D0224.9040001@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Hi Bart,

the memory leak looks real, and your fix looks corret, but I still
don't like it.

I think it's reasonable for SCSI to assume that the final put_device
fully frees the struct device including the name pointer that is
assigned entirely behind the back of the caller.

So I think the fix for this probably should be in the driver core.
