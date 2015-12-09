From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 3/3] ses: fix discovery of SATA devices in SAS enclosures
Date: Wed, 09 Dec 2015 11:14:55 -0800
Message-ID: <1449688495.2226.36.camel@HansenPartnership.com>
References: <1449688206.2226.30.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55130 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464AbbLITO4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2015 14:14:56 -0500
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 9859C8EE0CC
	for <linux-scsi@vger.kernel.org>; Wed,  9 Dec 2015 11:14:56 -0800 (PST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
	by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FdkOBnOqU5aR for <linux-scsi@vger.kernel.org>;
	Wed,  9 Dec 2015 11:14:56 -0800 (PST)
Received: from [153.66.254.242] (unknown [184.11.141.41])
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 474888EE04D
	for <linux-scsi@vger.kernel.org>; Wed,  9 Dec 2015 11:14:56 -0800 (PST)
In-Reply-To: <1449688206.2226.30.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The current discovery routines use the VPD 0x83 inquiry page to find
the device SAS address and match it to the end point in the enclosure.
This doesn't work for SATA devices because expanders (or hosts) simply
make up an endpoint address for STP and thus the address returned by
the VPD page never matches.  Instead of doing this, for SAS attached
devices, match by the direct endpoint address instead.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/ses.c |   22 ++++------------------
 1 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 7d9cec5..1736935 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -34,6 +34,8 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_host.h>
 
+#include <scsi/scsi_transport_sas.h>
+
 struct ses_device {
 	unsigned char *page1;
 	unsigned char *page1_types;
@@ -571,31 +573,15 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 static void ses_match_to_enclosure(struct enclosure_device *edev,
 				   struct scsi_device *sdev)
 {
-	unsigned char *desc;
 	struct efd efd = {
 		.addr = 0,
 	};
 
 	ses_enclosure_data_process(edev, to_scsi_device(edev->edev.parent), 0);
 
-	if (!sdev->vpd_pg83_len)
-		return;
-
-	desc = sdev->vpd_pg83 + 4;
-	while (desc < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
-		enum scsi_protocol proto = desc[0] >> 4;
-		u8 code_set = desc[0] & 0x0f;
-		u8 piv = desc[1] & 0x80;
-		u8 assoc = (desc[1] & 0x30) >> 4;
-		u8 type = desc[1] & 0x0f;
-		u8 len = desc[3];
-
-		if (piv && code_set == 1 && assoc == 1
-		    && proto == SCSI_PROTOCOL_SAS && type == 3 && len == 8)
-			efd.addr = get_unaligned_be64(&desc[4]);
+	if (is_sas_attached(sdev))
+		efd.addr = sas_get_address(sdev);
 
-		desc += len + 4;
-	}
 	if (efd.addr) {
 		efd.dev = &sdev->sdev_gendev;
 
-- 
1.7.4.1



