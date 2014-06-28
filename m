From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] drivers/message/fusion/mptfc.c: remove unnecessary null test before kfree
Date: Sat, 28 Jun 2014 14:58:01 +0200
Message-ID: <1403960281-6324-1-git-send-email-fabf@skynet.be>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:50388 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbaF1M7X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Jun 2014 08:59:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: linux-scsi@vger.kernel.org
Cc: DL-MPTFusionLinux@lsi.com
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/message/fusion/mptfc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 02a3eef..21ac845 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -525,8 +525,7 @@ mptfc_target_destroy(struct scsi_target *starget)
 		if (ri)	/* better be! */
 			ri->starget = NULL;
 	}
-	if (starget->hostdata)
-		kfree(starget->hostdata);
+	kfree(starget->hostdata);
 	starget->hostdata = NULL;
 }
 
-- 
1.8.4.5

