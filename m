From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: [PATCH] fix read capacity for large disks when CONFIG_LBD=n (updated)
Date: Tue, 4 Jan 2005 11:59:55 -0500
Message-ID: <05Jan4.115956est.332208@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:59653 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S261808AbVADRYa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2005 12:24:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

(updated - this patch is correct for the case that sdkp->fix_capacity is set)

If CONFIG_LBD=n, then sd_read_capacity computes the capacity of a large
disk on a 32-bit platform as 1 + 0xffffffff = 0.  Make it 0xffffffff
instead.

Anthony J. Battersby
Cybernetics

--- linux-2.6.10/drivers/scsi/sd.c.orig	Fri Dec 24 16:35:23 2004
+++ linux-2.6.10/drivers/scsi/sd.c	Tue Jan  4 11:52:01 2005
@@ -1082,9 +1082,13 @@ repeat:
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
+			goto got_data;
 		}
 		sdkp->capacity = 1 + (((sector_t)buffer[0] << 24) |
 			(buffer[1] << 16) |

