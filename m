From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sg driver, fix incorrect last scatg length, lk 2.6.19-rc3
Date: Fri, 27 Oct 2006 17:47:49 -0400
Message-ID: <45427E85.804@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010301040008080905090403"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:30100 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750698AbWJ0VqT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Oct 2006 17:46:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.
--------------010301040008080905090403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

For certain LLDs the sg driver can cause on oops
when the transfer length is large and not a
multiple of PAGE_SIZE.

For consideration in lk 2.6.19 (oops fix).

  ChangeLog:
    - correct the length of the last scatter gather
      list element.
    - fix some printk()s that have the wrong function
      name.

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert

--------------010301040008080905090403
Content-Type: text/x-patch;
 name="sg_2619rc3sca1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_2619rc3sca1.diff"

--- linux/drivers/scsi/sg.c	2006-10-07 10:26:01.000000000 -0400
+++ linux/drivers/scsi/sg.c2619rc3sca1	2006-10-27 11:26:34.000000000 -0400
@@ -60,7 +60,7 @@
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_date = "20060920";
+static char *sg_version_date = "20061027";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -710,12 +710,12 @@
 			  (int) cmnd[0], (int) hp->cmd_len));
 
 	if ((k = sg_start_req(srp))) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_write: start_req err=%d\n", k));
+		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: start_req err=%d\n", k));
 		sg_finish_rem_req(srp);
 		return k;	/* probably out of space --> ENOMEM */
 	}
 	if ((k = sg_write_xfer(srp))) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_write: write_xfer, bad address\n"));
+		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: write_xfer, bad address\n"));
 		sg_finish_rem_req(srp);
 		return k;
 	}
@@ -746,7 +746,7 @@
 				hp->dxfer_len, srp->data.k_use_sg, timeout,
 				SG_DEFAULT_RETRIES, srp, sg_cmd_done,
 				GFP_ATOMIC)) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_write: scsi_execute_async failed\n"));
+		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: scsi_execute_async failed\n"));
 		/*
 		 * most likely out of mem, but could also be a bad map
 		 */
@@ -1283,7 +1283,7 @@
 		sg_finish_rem_req(srp);
 		srp = NULL;
 		if (NULL == sfp->headrp) {
-			SCSI_LOG_TIMEOUT(1, printk("sg...bh: already closed, final cleanup\n"));
+			SCSI_LOG_TIMEOUT(1, printk("sg_cmd_done: already closed, final cleanup\n"));
 			if (0 == sg_remove_sfp(sdp, sfp)) {	/* device still present */
 				scsi_device_put(sdp->device);
 			}
@@ -1512,12 +1512,12 @@
 						    POLL_HUP);
 				}
 			}
-			SCSI_LOG_TIMEOUT(3, printk("sg_detach: dev=%d, dirty\n", k));
+			SCSI_LOG_TIMEOUT(3, printk("sg_remove: dev=%d, dirty\n", k));
 			if (NULL == sdp->headfp) {
 				sg_dev_arr[k] = NULL;
 			}
 		} else {	/* nothing active, simple case */
-			SCSI_LOG_TIMEOUT(3, printk("sg_detach: dev=%d\n", k));
+			SCSI_LOG_TIMEOUT(3, printk("sg_remove: dev=%d\n", k));
 			sg_dev_arr[k] = NULL;
 		}
 		sg_nr_dev--;
@@ -1876,14 +1876,15 @@
 			}
 		}
 		sg->page = p;
-		sg->length = ret_sz;
+		sg->length = (ret_sz > num) ? num : ret_sz;
 
-		SCSI_LOG_TIMEOUT(5, printk("sg_build_build: k=%d, a=0x%p, len=%d\n",
-				  k, p, ret_sz));
+		SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k=%d, num=%d, "
+				 "ret_sz=%d\n", k, num, ret_sz));
 	}		/* end of for loop */
 
 	schp->k_use_sg = k;
-	SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k_use_sg=%d, rem_sz=%d\n", k, rem_sz));
+	SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k_use_sg=%d, "
+			 "rem_sz=%d\n", k, rem_sz));
 
 	schp->bufflen = blk_size;
 	if (rem_sz > 0)	/* must have failed */
@@ -2014,7 +2015,7 @@
 			for (k = 0; (k < schp->k_use_sg) && sg->page;
 			     ++k, ++sg) {
 				SCSI_LOG_TIMEOUT(5, printk(
-				    "sg_remove_scat: k=%d, a=0x%p, len=%d\n",
+				    "sg_remove_scat: k=%d, pg=0x%p, len=%d\n",
 				    k, sg->page, sg->length));
 				sg_page_free(sg->page, sg->length);
 			}

--------------010301040008080905090403--
