From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [SCSI] scsi.h: add macro for enclosure bit of inquiry data
Date: Sun, 20 Jan 2008 09:09:40 -0600
Message-ID: <1200841780.3105.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35325 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753662AbYATPJq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jan 2008 10:09:46 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 7B5788464
	for <linux-scsi@vger.kernel.org>; Sun, 20 Jan 2008 09:09:42 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cujs-+0GKeeT for <linux-scsi@vger.kernel.org>;
	Sun, 20 Jan 2008 09:09:41 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id E12C88088
	for <linux-scsi@vger.kernel.org>; Sun, 20 Jan 2008 09:09:40 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The macro tells us whether the device is (or contains) an enclosure device.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 include/scsi/scsi_device.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e0c645a..a262d11 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -386,6 +386,10 @@ static inline int scsi_device_qas(struct scsi_device *sdev)
 		return 0;
 	return sdev->inquiry[56] & 0x02;
 }
+static inline int scsi_device_enclosure(struct scsi_device *sdev)
+{
+	return sdev->inquiry[6] & (1<<6);
+}
 
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
-- 
1.5.3.8



