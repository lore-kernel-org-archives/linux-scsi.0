From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] SG_SET_RESERVED_SIZE negative oops
Date: 20 Oct 2003 16:32:25 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066689145.2814.8.camel@patehci2>
References: <1066688955.2814.3.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:29674 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262598AbTJTWcc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2003 18:32:32 -0400
In-Reply-To: <1066688955.2814.3.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

[ BC axboe@suse.de ]

Here now also is the two-line drivers/block/scsi_ioctl.c patch
corresponding to the drivers/scsi/sg.c patch I proposed to begin this
thread.

I'm guessing we do Not want to bother with scsi_ioctl.c ... right?  I
guess this because:

http://lxr.linux.no/search?v=2.6.0-test7&string=sg_reserved_size
persuades me that SG_SET_RESERVED_SIZE does little more than pass an int
over to SG_GET_RESERVED_SIZE ... true?

We have no need to range check that.  Therefore we should not bother? 
Or are we instead indeed trying to keep drivers/scsi/sg.c in sync with
drivers/block/scsi_ioctl.c?

Pat LaVarre

diff -Nur linux-2.6.0-test8/drivers/block/scsi_ioctl.c linux/drivers/block/scsi_ioctl.c
--- linux-2.6.0-test8/drivers/block/scsi_ioctl.c	2003-10-17 15:43:36.000000000 -0600
+++ linux/drivers/block/scsi_ioctl.c	2003-10-20 16:15:03.898573192 -0600
@@ -124,6 +124,8 @@
 	if (err)
 		return err;
 
+	if (size < 0)
+		return -EINVAL;
 	if (size > (q->max_sectors << 9))
 		return -EINVAL;


