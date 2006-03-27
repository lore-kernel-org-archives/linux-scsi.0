From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 5/11] aacraid: Fix error in max_channel field
Date: Mon, 27 Mar 2006 09:44:15 -0800
Message-ID: <1143481455.21975.40.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:36031 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751117AbWC0RoS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 12:44:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn

The max_channel field is set one too large.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-03-22 11:17:46.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-03-22 11:17:48.000000000 -0800
@@ -906,9 +906,9 @@
 	 * physical channels are address by their actual physical number+1
 	 */
 	if (aac->nondasd_support == 1)
-		shost->max_channel = aac->maximum_num_channels + 1;
+		shost->max_channel = aac->maximum_num_channels;
 	else
-		shost->max_channel = 1;
+		shost->max_channel = 0;
 
 	aac_get_config_status(aac);
 	aac_get_containers(aac);

-- 
Mark Haverkamp <markh@osdl.org>

