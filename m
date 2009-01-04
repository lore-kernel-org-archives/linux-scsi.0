From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [RFC] IDEMA capacity adjustment
Date: Sun, 04 Jan 2009 03:12:29 -0500
Message-ID: <yq1mye74hhu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet14.oracle.com ([141.146.126.236]:63113 "EHLO
	acsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbZADINs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2009 03:13:48 -0500
Received: from acsinet11.oracle.com (acsinet11.oracle.com [141.146.126.233])
	by acsinet14.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n048GHtA013952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sun, 4 Jan 2009 08:17:26 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org


IDEMA, the International Disk Drive Equipment and Materials Association,
publishes a specification that defines how to translate from LBA count
to "marketing" gigabytes used to label drives.

This patch updates the size calculations in sd.c so that the base 10
size is adjusted according to the IDEMA spec.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1416,6 +1416,34 @@ static int read_capacity_10(struct scsi_
 	return sector_size;
 }
 
+u64 sd_idema_capacity(u64 lba_count, unsigned int sector_size)
+{
+	/* This looks like black magic but these numbers are mandated in
+	 * the IDEMA LBA specification that drive manufacturers use to
+	 * indicate drive capacity.  As of revision 1.3 these sizes are
+	 * also mandatory for SCSI-class drives.
+	 */
+	u64 capacity;
+	unsigned int idema_sub = 97696368;
+	unsigned int idema_div = 1953504;
+	unsigned int scale = sector_size;
+
+	do_div(scale, 512);
+	do_div(idema_sub, scale);
+	do_div(idema_div, scale);
+
+	/* The adjustments only work for drives > 50GB */
+	if (lba_count <= idema_sub)
+		return lba_count << ilog2(sector_size);
+
+	capacity = lba_count - idema_sub;
+	do_div(capacity, idema_div);
+	capacity += 50;
+	capacity *= 1000*1000*1000;
+
+	return capacity;
+}
+
 /*
  * read disk capacity
  */
@@ -1505,10 +1533,12 @@ got_data:
 	{
 		char cap_str_2[10], cap_str_10[10];
 		u64 sz = (u64)sdkp->capacity << ilog2(sector_size);
+		u64 idema_sz = sd_idema_capacity((u64)sdkp->capacity,
+						 sector_size);
 
 		string_get_size(sz, STRING_UNITS_2, cap_str_2,
 				sizeof(cap_str_2));
-		string_get_size(sz, STRING_UNITS_10, cap_str_10,
+		string_get_size(idema_sz, STRING_UNITS_10, cap_str_10,
 				sizeof(cap_str_10));
 
 		sd_printk(KERN_NOTICE, sdkp,

