From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: [PATCH] fix read capacity for large disks when CONFIG_LBD=n(updated)
Date: Tue, 4 Jan 2005 13:11:29 -0500
Message-ID: <05Jan4.131130est.332436@cyborg.cybernetics.com>
References: <1104860756.5327.50.camel@mulgrave>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:21774 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S261751AbVADSPb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2005 13:15:31 -0500
In-Reply-To: <1104860756.5327.50.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

Here's an alternate patch that corrects the kernel message and sets the
capacity to 0 explicitly.

Anthony J. Battersby
Cybernetics

--- linux-2.6.10/drivers/scsi/sd.c.orig	Fri Dec 24 16:35:23 2004
+++ linux-2.6.10/drivers/scsi/sd.c	Tue Jan  4 13:03:59 2005
@@ -1082,9 +1082,12 @@ repeat:
 				       " READ CAPACITY(16).\n", diskname);
 				longrc = 1;
 				goto repeat;
-			} else {
-				printk(KERN_ERR "%s: too big for kernel.  Assuming maximum 2Tb\n", diskname);
 			}
+			printk(KERN_ERR "%s: too big for this kernel.  Use a "
+			       "kernel compiled with support for large block "
+			       "devices.\n", diskname);
+			sdkp->capacity = 0;
+			goto got_data;
 		}
 		sdkp->capacity = 1 + (((sector_t)buffer[0] << 24) |
 			(buffer[1] << 16) |


