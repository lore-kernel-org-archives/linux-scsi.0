From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] SCSI-wd33c93: Deletion of a check before the function call
 "wd33c93_setup"
Date: Wed, 24 Jun 2015 17:33:50 +0200
Message-ID: <558ACDDE.5090403@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:64776 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbbFXPd4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Jun 2015 11:33:56 -0400
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E. J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 24 Jun 2015 17:15:17 +0200

The wd33c93_setup() function performs also input parameter validation.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/wd33c93.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index 9e09da4..e5ed956 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -1939,7 +1939,7 @@ wd33c93_init(struct Scsi_Host *instance, const wd33c93_regs regs,
 	int val;
 	char buf[32];
 
-	if (!done_setup && setup_strings)
+	if (!done_setup)
 		wd33c93_setup(setup_strings);
 
 	hostdata = (struct WD33C93_hostdata *) instance->hostdata;
-- 
2.4.4

