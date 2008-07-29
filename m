From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: ses: fix VPD inquiry overrun
Date: Tue, 29 Jul 2008 11:38:25 -0500
Message-ID: <1217349505.6103.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38792 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbYG2Qiz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2008 12:38:55 -0400
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id D131C83D3
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2008 11:38:53 -0500 (CDT)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qCNrLu54i9At for <linux-scsi@vger.kernel.org>;
	Tue, 29 Jul 2008 11:38:52 -0500 (CDT)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id C3D6B7FA5
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2008 11:38:52 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

There are a few kerneloops.org reports like this one:

http://www.kerneloops.org/search.php?search=ses_match_to_enclosure

That seem to imply we're running off the end of the VPD inquiry data
(although at 512 bytes, it should be long enough for just about
anything).  we should be using correctly sized buffers anyway, so put
those in and hope this oops goes away.

James

---

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0fe031f..f2d89be 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -345,14 +345,14 @@ static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
 	return 0;
 }
 
-#define VPD_INQUIRY_SIZE 512
+#define VPD_INQUIRY_SIZE 36
 
 static void ses_match_to_enclosure(struct enclosure_device *edev,
 				   struct scsi_device *sdev)
 {
 	unsigned char *buf = kmalloc(VPD_INQUIRY_SIZE, GFP_KERNEL);
 	unsigned char *desc;
-	int len;
+	u16 vpd_len;
 	struct efd efd = {
 		.addr = 0,
 	};
@@ -372,9 +372,19 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 			     VPD_INQUIRY_SIZE, NULL, SES_TIMEOUT, SES_RETRIES))
 		goto free;
 
-	len = (buf[2] << 8) + buf[3];
+	vpd_len = (buf[2] << 8) + buf[3];
+	kfree(buf);
+	buf = kmalloc(vpd_len, GFP_KERNEL);
+	if (!buf)
+		return;
+	cmd[3] = vpd_len >> 8;
+	cmd[4] = vpd_len & 0xff;
+	if (scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf,
+			     vpd_len, NULL, SES_TIMEOUT, SES_RETRIES))
+		goto free;
+	
 	desc = buf + 4;
-	while (desc < buf + len) {
+	while (desc < buf + vpd_len) {
 		enum scsi_protocol proto = desc[0] >> 4;
 		u8 code_set = desc[0] & 0x0f;
 		u8 piv = desc[1] & 0x80;



