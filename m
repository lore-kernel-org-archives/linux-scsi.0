From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] add protocol definitions
Date: Sun, 03 Feb 2008 15:32:59 -0600
Message-ID: <1202074379.3318.108.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33554 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746AbYBCVdE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Feb 2008 16:33:04 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 70E6B8196
	for <linux-scsi@vger.kernel.org>; Sun,  3 Feb 2008 15:33:00 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eArUxZHgvNj7 for <linux-scsi@vger.kernel.org>;
	Sun,  3 Feb 2008 15:32:59 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id A971F7ED3
	for <linux-scsi@vger.kernel.org>; Sun,  3 Feb 2008 15:32:59 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

A lot of SCSI command replies have a protocol ID field.  Add
definitions for the interpretation of that from SPC-3.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 include/scsi/scsi.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 702fcfe..6e4561f 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -215,6 +215,20 @@ static inline int scsi_status_is_good(int status)
 #define TYPE_RBC	    0x0e
 #define TYPE_NO_LUN         0x7f
 
+/* SCSI protocols; these are taken from SPC-3 section 7.5 */
+enum scsi_protocol {
+	SCSI_PROTOCOL_FCP = 0,	/* Fibre Channel */
+	SCSI_PROTOCOL_SPI = 1,	/* parallel SCSI */
+	SCSI_PROTOCOL_SSA = 2,	/* Serial Storage Architecture - Obsolete */
+	SCSI_PROTOCOL_SBP = 3,	/* firewire */
+	SCSI_PROTOCOL_SRP = 4,	/* Infiniband RDMA */
+	SCSI_PROTOCOL_ISCSI = 5,
+	SCSI_PROTOCOL_SAS = 6,
+	SCSI_PROTOCOL_ADT = 7,	/* Media Changers */
+	SCSI_PROTOCOL_ATA = 8,
+	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
+};
+
 /* Returns a human-readable name for the device */
 extern const char * scsi_device_type(unsigned type);
 
-- 
1.5.3.8


