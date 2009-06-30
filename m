From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] ieee1394: sbp2: add support for disks >2 TB (and 16
 bytes long CDBs)
Date: Tue, 30 Jun 2009 20:28:31 +0200 (CEST)
Message-ID: <tkrat.fe83450160362e84@s5r6.in-berlin.de>
References: <85681F9DCBFF144DA59C70D83EBC1DA2E1EDE7@EIOISER.ioi.com.tw>
 <49FEFF7A.3090603@s5r6.in-berlin.de>
 <1241448686.3315.27.camel@mulgrave.int.hansenpartnership.com>
 <4A4908C4.1070705@s5r6.in-berlin.de>
 <tkrat.a60470e5bddd2db4@s5r6.in-berlin.de>
 <tkrat.518b97167f27772a@s5r6.in-berlin.de>
 <tkrat.90ae964a94712510@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:39053 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZF3S2h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2009 14:28:37 -0400
In-Reply-To: <tkrat.90ae964a94712510@s5r6.in-berlin.de>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org, Ronald <Ronald@ioi.com.tw>

Increase the command ORB data structure to transport up to 16 bytes long
CDBs (instead of 12 bytes), and tell the SCSI mid layer about it.  This
is notably necessary for READ CAPACITY(16) and friends, i.e. support of
large disks.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |    1 +
 drivers/ieee1394/sbp2.h |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

Index: b/drivers/ieee1394/sbp2.c
===================================================================
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -880,6 +880,7 @@ static struct sbp2_lu *sbp2_alloc_device
 	}
 
 	shost->hostdata[0] = (unsigned long)lu;
+	shost->max_cmd_len = SBP2_MAX_CDB_SIZE;
 
 	if (!scsi_add_host(shost, &ud->device)) {
 		lu->shost = shost;
Index: b/drivers/ieee1394/sbp2.h
===================================================================
--- a/drivers/ieee1394/sbp2.h
+++ b/drivers/ieee1394/sbp2.h
@@ -25,6 +25,12 @@
 #define SBP2_DEVICE_NAME		"sbp2"
 
 /*
+ * There is no transport protocol limit to the CDB length,  but we implement
+ * a fixed length only.  16 bytes is enough for disks larger than 2 TB.
+ */
+#define SBP2_MAX_CDB_SIZE		16
+
+/*
  * SBP-2 specific definitions
  */
 
@@ -51,7 +57,7 @@ struct sbp2_command_orb {
 	u32 data_descriptor_hi;
 	u32 data_descriptor_lo;
 	u32 misc;
-	u8 cdb[12];
+	u8 cdb[SBP2_MAX_CDB_SIZE];
 } __attribute__((packed));
 
 #define SBP2_LOGIN_REQUEST		0x0

-- 
Stefan Richter
-=====-==--= -==- ====-
http://arcgraph.de/sr/

