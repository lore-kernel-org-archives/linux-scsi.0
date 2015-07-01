From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: [PATCH 2/3] hpsa: Remove unneccessary variable from raid_level_show
Date: Wed, 1 Jul 2015 03:46:29 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB4442E192@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:36856 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbGADsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2015 23:48:39 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James Bottomley (JBottomley@Odin.com)" <JBottomley@Odin.com>, ISS StorageDev <iss_storagedev@hp.com>
Cc: "Greg KH <greg@kroah.com> (greg@kroah.com)" <greg@kroah.com>


Remove unneccessary variable from raid_level_show

Signed-off-by: Shane Seymour <shane.seymour@hp.com>
---
Was not in previous patch.
--- a/drivers/scsi/hpsa.c	2015-06-30 16:15:42.631979483 -0500
+++ b/drivers/scsi/hpsa.c	2015-06-30 16:16:45.737975186 -0500
@@ -612,7 +612,6 @@ static const char * const raid_label[] =
 static ssize_t raid_level_show(struct device *dev,
 	     struct device_attribute *attr, char *buf)
 {
-	ssize_t l = 0;
 	unsigned char rlevel;
 	struct ctlr_info *h;
 	struct scsi_device *sdev;
@@ -631,16 +630,14 @@ static ssize_t raid_level_show(struct de
 	/* Is this even a logical drive? */
 	if (!is_logical_dev_addr_mode(hdev->scsi3addr)) {
 		spin_unlock_irqrestore(&h->lock, flags);
-		l = scnprintf(buf, PAGE_SIZE, "N/A\n");
-		return l;
+		return scnprintf(buf, PAGE_SIZE, "N/A\n");
 	}
 
 	rlevel = hdev->raid_level;
 	spin_unlock_irqrestore(&h->lock, flags);
 	if (rlevel > RAID_UNKNOWN)
 		rlevel = RAID_UNKNOWN;
-	l = scnprintf(buf, PAGE_SIZE, "RAID %s\n", raid_label[rlevel]);
-	return l;
+	return scnprintf(buf, PAGE_SIZE, "RAID %s\n", raid_label[rlevel]);
 }
 
 static ssize_t lunid_show(struct device *dev,
