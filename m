From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: [PATCH] fix read capacity for large disks when CONFIG_LBD=n
Date: Tue, 4 Jan 2005 11:05:41 -0500
Message-ID: <05Jan4.110542est.332652@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:8211 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S261707AbVADQKi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2005 11:10:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

If CONFIG_LBD=n, then sd_read_capacity computes the capacity of a large
disk on a 32-bit platform as 1 + 0xffffffff = 0.  Make it 0xffffffff
instead.

Anthony J. Battersby
Cybernetics

--- linux-2.6.10/drivers/scsi/sd.c.orig	Fri Dec 24 16:35:23 2004
+++ linux-2.6.10/drivers/scsi/sd.c	Tue Jan  4 10:45:25 2005
@@ -1082,14 +1082,18 @@ repeat:
 				       " READ CAPACITY(16).\n", diskname);
 				longrc = 1;
 				goto repeat;
-			} else {
-				printk(KERN_ERR "%s: too big for kernel.  Assuming maximum 2Tb\n", diskname);
 			}
+			printk(KERN_ERR "%s: too big for kernel.  Assuming "
+			                "maximum 2TB\n", diskname);
+			/* Don't add 1 as is normally done to avoid
+			 * overflow. */
+			sdkp->capacity = 0xffffffff;
+		} else {
+			sdkp->capacity = 1 + (((sector_t)buffer[0] << 24) |
+				(buffer[1] << 16) |
+				(buffer[2] << 8) |
+				buffer[3]);
 		}
-		sdkp->capacity = 1 + (((sector_t)buffer[0] << 24) |
-			(buffer[1] << 16) |
-			(buffer[2] << 8) |
-			buffer[3]);			
 	} else {
 		sdkp->capacity = 1 + (((u64)buffer[0] << 56) |
 			((u64)buffer[1] << 48) |

