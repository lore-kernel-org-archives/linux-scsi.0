From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] scsi_forget_host - scsi_debug usage
Date: Mon, 14 Jun 2004 14:23:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040614132300.GA18926@infradead.org>
References: <20040612041930.GA21105@us.ibm.com> <20040612042106.GB21105@us.ibm.com> <20040612042232.GC21105@us.ibm.com> <20040614080632.GA7114@infradead.org> <20040614130619.GH1970@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:25047 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262951AbUFNNXB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2004 09:23:01 -0400
Content-Disposition: inline
In-Reply-To: <20040614130619.GH1970@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

On Mon, Jun 14, 2004 at 03:06:19PM +0200, Jens Axboe wrote:
> > refcounting in place I wonder whether moving scsi_forget_host first in
> > scsi_remove_host wouldn't simply work.
> 
> It doesn't, device has already been deleted there. So either that needs
> to be reworked if we want to allow devices to talk to themselves from
> ->remove(), or we just move the sync cache call to sd_release() instead.

Doing sync cache in sd_release sounds good anyway.  But for the rootfs
case we need to do it in shutdown aswell.

