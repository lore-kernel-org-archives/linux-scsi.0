From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 36/36] aha1542: remove loop from aha1542_outb
Date: Fri,  6 Feb 2015 23:11:57 +0100
Message-ID: <1423260717-15944-37-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56960 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037AbbBFWPv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:15:51 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8J-0006fF-7n
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:15 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The loop in aha1542_outb with double-check is no longer needed, remove it.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index af821f3..ec43276 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -91,14 +91,11 @@ static inline bool wait_mask(u16 port, u8 mask, u8 allof, u8 noneof, int timeout
 
 static int aha1542_outb(unsigned int base, u8 val)
 {
-	while (1) {
-		if (!wait_mask(STATUS(base), CDF, 0, CDF, 0))
-			return 1;
-		if (inb(STATUS(base)) & CDF)
-			continue;
-		outb(val, DATA(base));
-		return 0;
-	}
+	if (!wait_mask(STATUS(base), CDF, 0, CDF, 0))
+		return 1;
+	outb(val, DATA(base));
+
+	return 0;
 }
 
 static int aha1542_out(unsigned int base, u8 *buf, int len)
-- 
Ondrej Zary

