From: mike.miller@hp.com
Subject: [PATCH 2.6] cciss: cciss_ioctl return code fix
Date: Mon, 6 Dec 2004 11:43:54 -0600
Message-ID: <20041206174354.GA7017@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ztxmail05.ztx.compaq.com ([161.114.1.209]:34058 "EHLO
	ztxmail05.ztx.compaq.com") by vger.kernel.org with ESMTP
	id S261601AbULFRoK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Dec 2004 12:44:10 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, axboe@suse.de
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, brian.b@hp.com

This patches fixes the return code from cciss_ioctl. Without this some 
block layer (BLK*) ioctls do not work. Please consider this for inclusion.

Thanks to Jens Axboe for pointing this out.

Signed-off-by: Mike Miller <mike.miller@hp.com>

 cciss.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--------------------------------------------------------------------------------
diff -urNp lx2610-rc3.orig/drivers/block/cciss.c lx2610-rc3/drivers/block/cciss.c
--- lx2610-rc3.orig/drivers/block/cciss.c	2004-12-06 09:36:04.844780000 -0600
+++ lx2610-rc3/drivers/block/cciss.c	2004-12-06 09:39:18.104400072 -0600
@@ -1100,7 +1100,7 @@ cleanup1:
 		return(status);
 	}
 	default:
-		return -EBADRQC;
+		return -ENOTTY;
 	}
 	
 }
