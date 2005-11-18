From: mikem <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 2/3] cciss: bug fix for BIG_PASS_THRU
Date: Fri, 18 Nov 2005 10:41:12 -0600
Message-ID: <20051118164112.GA14937@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel9.hp.com ([156.153.255.214]:20373 "EHLO atlrel9.hp.com")
	by vger.kernel.org with ESMTP id S964790AbVKRQlT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 11:41:19 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, axboe@suse.de
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Patch 2 of 3

Applications using CCISS_BIG_PASSTHRU complained that the data written
was zeros.  The code looked alright, but it seems that copy_from_user 
already does a memset on the buffer. Removing it from the pass-through
fixes the apps.

Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
--------------------------------------------------------------------------------

 drivers/block/cciss.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/block/cciss.c~cciss_memset drivers/block/cciss.c
--- linux-2.6.14.2/drivers/block/cciss.c~cciss_memset	2005-11-15 15:41:23.289070160 -0600
+++ linux-2.6.14.2-mikem/drivers/block/cciss.c	2005-11-15 15:42:28.264192440 -0600
@@ -1020,8 +1020,6 @@ static int cciss_ioctl(struct inode *ino
 				copy_from_user(buff[sg_used], data_ptr, sz)) {
 					status = -ENOMEM;
 					goto cleanup1;			
-			} else {
-				memset(buff[sg_used], 0, sz);
 			}
 			left -= sz;
 			data_ptr += sz;
_
