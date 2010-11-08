From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFCv3 00/21] TCM Core and TCM_Loop patches for v2.6.37
Date: Mon, 8 Nov 2010 09:33:07 -0500
Message-ID: <20101108143307.GA22121@infradead.org>
References: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57546 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab0KHOdN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 09:33:13 -0500
Content-Disposition: inline
In-Reply-To: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>

Hi Nick,

I promised you and James to get back to a throughout review for more
than just the backends.  It's still in progress, but here is what I
think is most important:

 - Sort of the the namepspace for both the file names and function
   names.  I think you reluctantly agreed to do that a while ago anyway,
   but I think it's time to bite the bullet now.  Please agree on a
   common prefix for both function names and modules.  I think the
   target name in the directory structure is the best one, but I really
   don't care too much.  The transport_ prefix used in some code is
   really misleading, and the se_ in other isn't too helpful either.
 - make sure backends, frontends and core/ code under drivers/target/
   are properly separated
 - clean up the exported - both as in EXPORT_SYMBOL and simply global
   functions.  There's a lot of things that should be static or not
   exported to modules but is right now.  The scripts/namespace.pl
   script in the kernel tree is a great helper for that.
 - Similarly the headers could use some re-arrangement.  I've been
   trying to make sense of what each header does but couldn't find it.
   In the optimal world you'd have one header for the front-end API,
   one of the back-end API and one or more for common structures
   and defintions.  All with a comment explaining what they are there
   for.

