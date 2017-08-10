From: Helge Deller <deller@gmx.de>
Subject: [PATCH] sym53c8xx: Avoid undefined behaviour in
 drivers/scsi/sym53c8xx_2/sym_hipd.c:762
Date: Thu, 10 Aug 2017 21:08:49 +0200
Message-ID: <20170810190849.GA12659@p100.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53110 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752889AbdHJTI4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 15:08:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org
Cc: linux-parisc@vger.kernel.org

On parisc I see this UBSAN warning with a sym53c896:

 UBSAN: Undefined behaviour in ./drivers/scsi/sym53c8xx_2/sym_hipd.c:762:24
 index -1903078336 is out of range for type 'u32 [7]'

Avoid this warning by switching to dev64_ul().

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 6b349e3..15ff285a9 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -759,7 +759,7 @@ static int sym_prepare_setting(struct Scsi_Host *shost, struct sym_hcb *np, stru
 	/*
 	 * Maximum synchronous period factor supported by the chip.
 	 */
-	period = (11 * div_10M[np->clock_divn - 1]) / (4 * np->clock_khz);
+	period = div64_ul(11 * div_10M[np->clock_divn - 1], 4 * np->clock_khz);
 	np->maxsync = period > 2540 ? 254 : period / 10;
 
 	/*
