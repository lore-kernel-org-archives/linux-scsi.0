From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dpt_i2o changes for 2.6.2 kernel in support of 64 bit and bitrot (part 1)
Date: Mon, 5 Apr 2004 21:47:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040405214703.A9782@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F64F204@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:10768 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263191AbUDEUrF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 16:47:05 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F64F204@otce2k03.adaptec.com>; from mark_salyzyn@adaptec.com on Mon, Apr 05, 2004 at 01:56:12PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Mon, Apr 05, 2004 at 01:56:12PM -0400, Salyzyn, Mark wrote:
> We need a means for an application to tell if a scsi device is currently
> in use; one of in-error or with any I/O still pending or opened or
> mounted. This is necessary to inform users of the RAID management
> applications that the device is not to be adjusted.

We had this a few times already.  If your applications wants to remove
a volume it'll do exactly that, and that's expected behaviour in unix
land where you have enough rope to shoot yourself in the foot.

> Unfortunately new members like struct scsi_disk::openers are
> inaccessible to the scsi driver to indicate whether there are any
> applications that have the scsi device open.

Which is intentional as the opencount of one particular upperlevel driver
has absolutely no meaning for a LLDD.

> Are there any suggestions, either for the application, or for the scsi
> driver to meter disk in-use?

The simple answer is:  don't do it.

> Without this, it is *impossible* for us to
> support reliable native RAID management applications; a user application
> should *never* be a source of an OS panic (whether it be someone
> destroying the boot array, or simply a file system driver panicking when
> a device no longer exists)

A filesystem should not panic when the underlying device is offlines or
removed.  At least XFS doesn't and if some other fs does file a bug
against it.

As for userland tools making the system unsuable, try a simple

	cat /dev/zero > /dev/kmem

