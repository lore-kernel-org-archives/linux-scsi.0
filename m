From: Christoph Hellwig <hch@sgi.com>
Subject: [PATCH] fix memory leak in sd.c
Date: Fri, 29 Nov 2002 18:54:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021129185412.A13031@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: marcelo@conectiva.com.br
Cc: linux-scsi@vger.kernel.org

I wonder why Pete didn't just fix it in the very beginning.. :)


diff -urN 2.4.19pre7/drivers/scsi/sd.c sd_cleanup/drivers/scsi/sd.c
--- 2.4.19pre7/drivers/scsi/sd.c	Tue Apr 16 08:11:49 2002
+++ sd_cleanup/drivers/scsi/sd.c	Wed Apr 17 19:53:56 2002
@@ -1439,10 +1439,8 @@
 		kfree(sd_blocksizes);
 		kfree(sd_hardsizes);
 		for (i = 0; i < N_USED_SD_MAJORS; i++) {
-#if 0 /* XXX aren't we forgetting to deallocate something? */
 			kfree(sd_gendisks[i].de_arr);
 			kfree(sd_gendisks[i].flags);
-#endif
 			kfree(sd_gendisks[i].part);
 		}
 	}
