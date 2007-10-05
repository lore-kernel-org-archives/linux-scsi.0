From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] advansys: Fix bug in AdvLoadMicrocode
Date: Fri,  5 Oct 2007 15:57:06 -0400
Message-ID: <1191614226-24814-1-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:56993 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbXJET5H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:57:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

buf[i] can be up to 0xfd, so doubling it and assigning the result to an
unsigned char truncates the value.  Just use an unsigned int instead;
it's only a temporary.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/advansys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 9dd3952..bb3422b 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -6439,7 +6439,7 @@ static int AdvLoadMicrocode(AdvPortAddr iop_base, unsigned char *buf, int size,
 			i += 2;
 			len += 2;
 		} else {
-			unsigned char off = buf[i] * 2;
+			unsigned int off = buf[i] * 2;
 			unsigned short word = (buf[off + 1] << 8) | buf[off];
 			AdvWriteWordAutoIncLram(iop_base, word);
 			len += 2;
-- 
1.5.3.2

