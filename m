From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 3/11] aacraid: Add timeout for events
Date: Mon, 27 Mar 2006 09:43:55 -0800
Message-ID: <1143481435.21975.38.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:27327 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751106AbWC0Rn6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 12:43:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn

Plug and play actions resulting from event sequences shall time out if
they take longer than 30 seconds to complete.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2006-03-22 11:17:41.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2006-03-22 11:17:44.000000000 -0800
@@ -788,6 +788,7 @@
 	u64		size;
 	u32		type;
 	u32		config_waiting_on;
+	unsigned long	config_waiting_stamp;
 	u16		queue_depth;
 	u8		config_needed;
 	u8		valid;
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commsup.c	2006-03-22 11:12:24.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/commsup.c	2006-03-22 11:17:44.000000000 -0800
@@ -784,6 +784,7 @@
  *	dispatches it to the appropriate routine for handling.
  */
 
+#define AIF_SNIFF_TIMEOUT	(30*HZ)
 static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 {
 	struct hw_fib * hw_fib = fibptr->hw_fib;
@@ -837,6 +838,7 @@
 				if (device) {
 					dev->fsa_dev[container].config_needed = CHANGE;
 					dev->fsa_dev[container].config_waiting_on = AifEnConfigChange;
+					dev->fsa_dev[container].config_waiting_stamp = jiffies;
 					scsi_device_put(device);
 				}
 			}
@@ -849,13 +851,15 @@
 		if (container != (u32)-1) {
 			if (container >= dev->maximum_num_containers)
 				break;
-			if (dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(u32 *)aifcmd->data))
+			if ((dev->fsa_dev[container].config_waiting_on ==
+			    le32_to_cpu(*(u32 *)aifcmd->data)) &&
+			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		} else for (container = 0;
 		    container < dev->maximum_num_containers; ++container) {
-			if (dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(u32 *)aifcmd->data))
+			if ((dev->fsa_dev[container].config_waiting_on ==
+			    le32_to_cpu(*(u32 *)aifcmd->data)) &&
+			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		}
 		break;
@@ -872,6 +876,7 @@
 			dev->fsa_dev[container].config_needed = ADD;
 			dev->fsa_dev[container].config_waiting_on =
 				AifEnConfigChange;
+			dev->fsa_dev[container].config_waiting_stamp = jiffies;
 			break;
 
 		/*
@@ -884,6 +889,7 @@
 			dev->fsa_dev[container].config_needed = DELETE;
 			dev->fsa_dev[container].config_waiting_on =
 				AifEnConfigChange;
+			dev->fsa_dev[container].config_waiting_stamp = jiffies;
 			break;
 
 		/*
@@ -894,11 +900,13 @@
 			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
 			if (container >= dev->maximum_num_containers)
 				break;
-			if (dev->fsa_dev[container].config_waiting_on)
+			if (dev->fsa_dev[container].config_waiting_on &&
+			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				break;
 			dev->fsa_dev[container].config_needed = CHANGE;
 			dev->fsa_dev[container].config_waiting_on =
 				AifEnConfigChange;
+			dev->fsa_dev[container].config_waiting_stamp = jiffies;
 			break;
 
 		case AifEnConfigChange:
@@ -913,13 +921,15 @@
 		if (container != (u32)-1) {
 			if (container >= dev->maximum_num_containers)
 				break;
-			if (dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(u32 *)aifcmd->data))
+			if ((dev->fsa_dev[container].config_waiting_on ==
+			    le32_to_cpu(*(u32 *)aifcmd->data)) &&
+			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		} else for (container = 0;
 		    container < dev->maximum_num_containers; ++container) {
-			if (dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(u32 *)aifcmd->data))
+			if ((dev->fsa_dev[container].config_waiting_on ==
+			    le32_to_cpu(*(u32 *)aifcmd->data)) &&
+			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		}
 		break;
@@ -946,6 +956,8 @@
 				dev->fsa_dev[container].config_waiting_on =
 					AifEnContainerChange;
 				dev->fsa_dev[container].config_needed = ADD;
+				dev->fsa_dev[container].config_waiting_stamp =
+					jiffies;
 			}
 		}
 		if ((((u32 *)aifcmd->data)[1] == cpu_to_le32(AifJobCtrZero))
@@ -961,6 +973,8 @@
 				dev->fsa_dev[container].config_waiting_on =
 					AifEnContainerChange;
 				dev->fsa_dev[container].config_needed = DELETE;
+				dev->fsa_dev[container].config_waiting_stamp =
+					jiffies;
 			}
 		}
 		break;
@@ -969,8 +983,9 @@
 	device_config_needed = NOTHING;
 	for (container = 0; container < dev->maximum_num_containers;
 	    ++container) {
-		if ((dev->fsa_dev[container].config_waiting_on == 0)
-		 && (dev->fsa_dev[container].config_needed != NOTHING)) {
+		if ((dev->fsa_dev[container].config_waiting_on == 0) &&
+			(dev->fsa_dev[container].config_needed != NOTHING) &&
+			time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT)) {
 			device_config_needed =
 				dev->fsa_dev[container].config_needed;
 			dev->fsa_dev[container].config_needed = NOTHING;

-- 
Mark Haverkamp <markh@osdl.org>

