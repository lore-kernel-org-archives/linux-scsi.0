From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 2/3] scsi_forget_host - scsi_debug usage
Date: Mon, 14 Jun 2004 15:26:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040614132609.GI1970@suse.de>
References: <20040612041930.GA21105@us.ibm.com> <20040612042106.GB21105@us.ibm.com> <20040612042232.GC21105@us.ibm.com> <20040614080632.GA7114@infradead.org> <20040614130619.GH1970@suse.de> <20040614132300.GA18926@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:49804 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262932AbUFNN0L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2004 09:26:11 -0400
Content-Disposition: inline
In-Reply-To: <20040614132300.GA18926@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Jun 14 2004, Christoph Hellwig wrote:
> On Mon, Jun 14, 2004 at 03:06:19PM +0200, Jens Axboe wrote:
> > > refcounting in place I wonder whether moving scsi_forget_host first in
> > > scsi_remove_host wouldn't simply work.
> > 
> > It doesn't, device has already been deleted there. So either that needs
> > to be reworked if we want to allow devices to talk to themselves from
> > ->remove(), or we just move the sync cache call to sd_release() instead.
> 
> Doing sync cache in sd_release sounds good anyway.  But for the rootfs

Yep

> case we need to do it in shutdown aswell.

But the device is already SDEV_DEL there, so it can't be done without
fixing that. What makes the rootfs case special, btw?

-- 
Jens Axboe

