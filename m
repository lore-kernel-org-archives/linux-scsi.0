From: Jens Axboe <axboe@suse.de>
Subject: Re: [BK PATCH] SCSI -rc fixes for 2.6.10-rc3
Date: Fri, 10 Dec 2004 21:11:16 +0100
Message-ID: <20041210201115.GD12581@suse.de>
References: <1102650988.3814.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:2260 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261224AbULJUMQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Dec 2004 15:12:16 -0500
Content-Disposition: inline
In-Reply-To: <1102650988.3814.13.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Thu, Dec 09 2004, James Bottomley wrote:
> This one is another set of small driver fixes
> 
> It is available from:

Here is one more. Currently imm uses page_address() which can crash on
highmem. It's not directly doable to map the pages properly, at least
not without changing some code. In lack of a ->bounce_highio member in
the scsi host template, just set ->unchecked_isa_dma which will just
bounce everything for us. imm isn't performance critical by any stretch
of the imagination, so...

Usually I'd not encourage such a silly hack, but in lack of hardware for
testing (who has it??), this should suffice as it is obviously correct.

Signed-off-by: Jens Axboe <axboe@suse.de>

===== drivers/scsi/imm.c 1.39 vs edited =====
--- 1.39/drivers/scsi/imm.c	2004-08-25 01:09:03 +02:00
+++ edited/drivers/scsi/imm.c	2004-12-10 21:07:29 +01:00
@@ -1140,6 +1140,10 @@
 	.use_clustering		= ENABLE_CLUSTERING,
 	.can_queue		= 1,
 	.slave_alloc		= imm_adjust_queue,
+	.unchecked_isa_dma	= 1, /* imm cannot deal with highmem, so
+				      * this is an easy trick to ensure
+				      * all io pages for this host reside
+				      * in low memory */
 };
 
 /***************************************************************************


-- 
Jens Axboe

