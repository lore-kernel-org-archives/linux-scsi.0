From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] mptsas: add parent port backlink
Date: Wed, 12 Jul 2006 09:51:04 -0400
Message-ID: <1152712265.3728.4.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:11419 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751369AbWGLNvN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 09:51:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This takes advantage of the sas class backlink function to show which
port on an expander is used to communicate with the parent.

James

Index: BUILD-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- BUILD-2.6.orig/drivers/message/fusion/mptsas.c	2006-07-09 12:05:55.000000000 -0500
+++ BUILD-2.6/drivers/message/fusion/mptsas.c	2006-07-09 12:12:28.000000000 -0500
@@ -1652,14 +1652,18 @@
 
 			for (i = 0; i < port_info->num_phys; i++)
 				if (port_info->phy_info[i].identify.sas_address ==
-				    identify.sas_address)
+				    identify.sas_address) {
+					sas_port_mark_backlink(port);
 					goto out;
+				}
 
 		} else if (scsi_is_sas_rphy(parent)) {
 			struct sas_rphy *parent_rphy = dev_to_rphy(parent);
 			if (identify.sas_address ==
-			    parent_rphy->identify.sas_address)
+			    parent_rphy->identify.sas_address) {
+				sas_port_mark_backlink(port);
 				goto out;
+			}
 		}
 
 		switch (identify.device_type) {


