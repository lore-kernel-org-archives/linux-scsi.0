From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi.mq:Added enable_cmd_list flags in hostt to reduce
 lock contention
Date: Wed, 20 Aug 2014 05:41:15 -0700
Message-ID: <20140820124115.GA15231@infradead.org>
References: <201408191819.s7JIIx12019025@palmhbs0.lsi.com>
 <53F47CF8.3080708@acm.org>
 <7932bf422121b7f7d23545abdc0065c8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53861 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbaHTMlR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Aug 2014 08:41:17 -0400
Content-Disposition: inline
In-Reply-To: <7932bf422121b7f7d23545abdc0065c8@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, aacraid@adaptec.com, Elliott@hp.com, jbottomley@parallels.com, hch@infradead.org

On Wed, Aug 20, 2014 at 06:08:37PM +0530, Kashyap Desai wrote:
> > This code is in the hot path which means that caching "enable_cmd_list"
> > in struct Scsi_Host (as is done for many other SCSI host parameters)
> > probably
> > will (slightly) improve performance further. Otherwise this patch looks
> > fine to
> > me.
> I will send updated patch which will cache host template field
> "enable_cmd_list" for faster access in Scsi Host.

Thanks.  It might be worth to only set in in the host in fact.

Also please just remove the code about lock contention in
scsi_mq_prep_fn - the XXX really doesn't apply anymore and I think the
code should be self-explaining enough to not need a comment.

Otherwise the patch looks good to me.

