From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix a bdi reregistration race, v2
Date: Wed, 25 Nov 2015 00:47:44 -0800
Message-ID: <20151125084744.GA16429@infradead.org>
References: <564F9AFF.3050605@sandisk.com>
 <20151124231331.GA25591@infradead.org>
 <5654F169.6070000@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44059 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbbKYIrw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2015 03:47:52 -0500
Content-Disposition: inline
In-Reply-To: <5654F169.6070000@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>, Aaro Koskinen <aaro.koskinen@iki.fi>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-mm@kvack.org

Hi Bart,

On Tue, Nov 24, 2015 at 03:23:21PM -0800, Bart Van Assche wrote:
> So if a driver stops using a (major, minor) number pair and the same device
> number is reused before the bdi device has been released the warning
> mentioned in the patch description at the start of this thread is triggered.
> This patch fixes that race by removing the bdi device from sysfs during the
> __scsi_remove_device() call instead of when the bdi device is released.

that's why I suggested only releasing the minor number (or rather dev_t)
once we release the BDI, similar to what MD and DM do.

But what I really wanted to ask for is what your reproducer looks like.
