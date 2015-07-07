From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] [SCSI] FlashPoint: optimize string comparison
Date: Tue,  7 Jul 2015 07:39:03 +0200
Message-ID: <1436247543-7326-1-git-send-email-christophe.jaillet@wanadoo.fr>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:35483 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbbGGFqn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2015 01:46:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: khalid@gonehiking.org, JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Stop comparing the strings as soon as we know that they don't match.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/FlashPoint.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index 5c74e4c..24a4d1a 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -6280,8 +6280,10 @@ static unsigned char FPT_scmachid(unsigned char p_card,
 		match = 1;
 
 		for (k = 0; k < ID_STRING_LENGTH; k++) {
-			if (p_id_string[k] != FPT_scamInfo[i].id_string[k])
+			if (p_id_string[k] != FPT_scamInfo[i].id_string[k]) {
 				match = 0;
+				break;
+			}
 		}
 
 		if (match) {
-- 
2.1.4

