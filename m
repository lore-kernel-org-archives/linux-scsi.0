From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH 21/24][RFC] scsi_tgt: use of sense accessors
Date: Tue, 5 Feb 2008 11:21:33 -0500
Message-ID: <20080205162133.GC1931@osc.edu>
References: <1202147595-5400-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:54462 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbYBEQVf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Feb 2008 11:21:35 -0500
Content-Disposition: inline
In-Reply-To: <1202147595-5400-1-git-send-email-bharrosh@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

bharrosh@panasas.com wrote on Mon, 04 Feb 2008 19:53 +0200:
>   FIXME: I need help with this driver (Pete?)
>     I used scsi_sense() in a none const way. But since
>     scsi_tgt is the ULD here, it can just access it's own sense
>     buffer directly. I did not use scsi_eh_cpy_sense() because
>     I did not want the extra copy. Pete will want to use a 260
>     bytes buffer here.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> Need-help-from: Pete Wyckoff <pw@osc.edu>

FYI, I never use scsi_tgt.  Only just pure userspace on the target,
and a dumb ethernet NIC that does not know it is speaking any form
of SCSI.

People who need scsi_tgt have real target-enabled NICs like the
fancy qla4xxx.  Those act as SCSI targets across FC or IP or
whatever and bring commands into the kernel, which then relays them
to a userspace tgtd process, which does the read/write as necessary,
and returns a result code to the NIC to ship back across FC.

So sorry, I won't take a guess at what has to happen here.  But
yeah, you are right that an OSD target implementation would at times
need a sense buffer bigger than 96.  Protocol maximum length for all
sense data is 264.

		-- Pete
