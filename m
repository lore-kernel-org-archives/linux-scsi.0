From: John Stoffel <john@stoffel.org>
Subject: [PATCH] ratelimit parity errors for Symbios
Date: Fri, 19 Jun 2009 16:08:58 -0400
Message-ID: <1245442138-3928-1-git-send-email-john@stoffel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mycroft.westnet.com ([216.187.52.7]:36043 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZFSUJ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2009 16:09:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: John Stoffel <john@stoffel.org>, linux-scsi@vger.kernel.org, stable@kernel.org

ratelimit parity error for Symbios

This makes a huge difference when you have a serial console on bootup to limit
these messages to a sane number. 

Signed-off-by: John Stoffel <john@stoffel.org>
---
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 69ad494..297deb8 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -2321,8 +2321,9 @@ static void sym_int_par (struct sym_hcb *np, u_short sist)
 	int phase	= cmd & 7;
 	struct sym_ccb *cp	= sym_ccb_from_dsa(np, dsa);
 
-	printf("%s: SCSI parity error detected: SCR1=%d DBC=%x SBCL=%x\n",
-		sym_name(np), hsts, dbc, sbcl);
+	if (printk_ratelimit())
+		printf("%s: SCSI parity error detected: SCR1=%d DBC=%x SBCL=%x\n",
+			sym_name(np), hsts, dbc, sbcl);
 
 	/*
 	 *  Check that the chip is connected to the SCSI BUS.
-- 
1.6.3.1

