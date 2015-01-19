From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 05/13] aha1542: Convert aha1542_intr_reset to function
Date: Mon, 19 Jan 2015 23:37:49 +0100
Message-ID: <1421707077-25291-6-git-send-email-linux@rainbow-software.org>
References: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:44252 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbbASWiL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2015 17:38:11 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YDKxV-0006A4-2q
	for linux-scsi@vger.kernel.org; Mon, 19 Jan 2015 23:38:09 +0100
In-Reply-To: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Convert aha1542_intr_reset macro to inline function

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index ebf54b5..2a6308f 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -128,7 +128,10 @@ static void setup_mailboxes(int base_io, struct Scsi_Host *shpnt);
 static int aha1542_restart(struct Scsi_Host *shost);
 static void aha1542_intr_handle(struct Scsi_Host *shost);
 
-#define aha1542_intr_reset(base)  outb(IRST, CONTROL(base))
+static inline void aha1542_intr_reset(u16 base)
+{
+	outb(IRST, CONTROL(base));
+}
 
 #define WAIT(port, mask, allof, noneof)					\
  { register int WAITbits;						\
-- 
Ondrej Zary

