From: Reinhard Nissl <rnissl@gmx.de>
Subject: PATCH: mvsas: increase port type detection delay to suit Seagate's
 10k6 drive ST3450856SS 0003
Date: Thu, 11 Dec 2008 00:31:03 +0100
Message-ID: <49405137.9000902@gmx.de>
References: <493BC76F.3060105@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070103090607080006000202"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51349 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752994AbYLJXbL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2008 18:31:11 -0500
In-Reply-To: <493BC76F.3060105@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070103090607080006000202
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

I increased the delay step by step until loading of mvsas
reliably detected the drive 200 times in sequence. A much better
approach would be to monitor the hardware for some flag which
indicates that port detection has finished, but I do not have any
hardware documentation.

BTW: patch is against
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git

Signed-off-by: Reinhard Nissl <rnissl@gmx.de>


--------------070103090607080006000202
Content-Type: text/x-patch;
 name="mvsas.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mvsas.diff"

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index 1dd70d7..23e5a87 100644
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -2959,7 +2959,7 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
 
 	/* enable auto port detection */
 	mw32(GBL_PORT_TYPE, MODE_AUTO_DET_EN);
-	msleep(100);
+	msleep(1100);
 	/* init and reset phys */
 	for (i = 0; i < mvi->chip->n_phy; i++) {
 		u32 lo = be32_to_cpu(*(u32 *)&mvi->sas_addr[4]);

--------------070103090607080006000202--
