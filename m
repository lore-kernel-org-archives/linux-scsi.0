From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_debug: fix sleep in invalid context
Date: Mon, 30 May 2016 12:09:16 -0700
Message-ID: <20160530190916.GA366@infradead.org>
References: <1464632347-8621-1-git-send-email-dgilbert@interlog.com>
 <1464634965.2287.73.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40814 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161631AbcE3TJR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2016 15:09:17 -0400
Content-Disposition: inline
In-Reply-To: <1464634965.2287.73.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bart.vanassche@sandisk.com

On Mon, May 30, 2016 at 12:02:45PM -0700, James Bottomley wrote:
> This might fix the immediate warning, but won't it demand huge
> contiguous memory chunks in high lun configurations and thus fail
> randomly?  Report luns is important to us because if that fails the
> target won't attach.
> 
> What about vmalloc'ing enough space at configuration time, when you do
> have process context, and simply reusing the already allocated buffer
> in this routine?  If you want to be clever, you could do a single
> vmalloc for the biggest LUN size you have and reuse that buffer for
> every report lun command with suitable locking ... we tend to fire off
> report luns sequentially at start of day, so it's not like they have
> huge performance or concurrency requirements.

There is no need for the allocation at all.  Instead of the big
array and a single call to fill_from_dev_buffer we can simply
have a single scsi_lun structure on stack that gets reused for
every lun and individual calls to sg_copy_from_buffer for each
one instead of a single big one.
