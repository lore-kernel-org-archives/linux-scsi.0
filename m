From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] introduce scsi_host_alloc
Date: Fri, 6 Jun 2003 22:42:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606204241.GA28264@lst.de>
References: <20030606080103.GC18838@lst.de> <3EE0F86B.4060908@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:24281 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262278AbTFFU3R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 16:29:17 -0400
Content-Disposition: inline
In-Reply-To: <3EE0F86B.4060908@rogers.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Fri, Jun 06, 2003 at 04:24:11PM -0400, Luben Tuikov wrote:
> Christoph Hellwig wrote:
> >Rediffed version, with Mike's isp fix and taking the new
> >scsi_add_host users in usb in account.
> >
> >Currently this is juist a new name for scsi_register, but we make
> >sure new-style drivers never call scsi_register/scsi_unregister
> >but always scsi_host_alloc/scsi_host_put in this patch so the
> 
> Why don't you call this scsi_host_free() to complement scsi_host_alloc()?
> Why do you need to reveal implementation by naming it scsi_host_put()?
> As far as the caller of scsi_host_put() is concerned they MUST NOT
> dereference the host thereafter, so you can safely call it scsi_host_free().
> (_When_ it is actually it is freed is what is being hidded as 
> implementation.)


scsi_host_get/scsi_host_put are the refcounting primites for
struct Scsi_Host and there are more users then just the host drivers.
(and there will be more soon).  It's an idiom in linux to use get/put
for those and make put free it when the refcount reaches zero.
