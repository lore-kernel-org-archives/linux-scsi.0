From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] introduce scsi_host_alloc
Date: Sat, 7 Jun 2003 08:44:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030607064456.GA1668@lst.de>
References: <20030606080103.GC18838@lst.de> <3EE0F86B.4060908@rogers.com> <20030606204241.GA28264@lst.de> <3EE121A7.8010806@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:2782 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261936AbTFGGb0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Jun 2003 02:31:26 -0400
Content-Disposition: inline
In-Reply-To: <3EE121A7.8010806@rogers.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Fri, Jun 06, 2003 at 07:20:07PM -0400, Luben Tuikov wrote:
> Christoph Hellwig wrote:
> >
> >scsi_host_get/scsi_host_put are the refcounting primites for
> >struct Scsi_Host and there are more users then just the host drivers.
> >(and there will be more soon).  It's an idiom in linux to use get/put
> >for those and make put free it when the refcount reaches zero.
> 
> I know about the get/put idiom, refcounting, etc.
> 
> *But* your use is alloc <--> put.  This is what throws me off.

It's not.  It's alloc[, get, put, get, put], put.  alloc is
get a new dynamic allocate structure with refcount one, after
that we can get another reference with get, or a reference from hostno
with lookup and then put it again - when the refcount reches zero
it's freed.

