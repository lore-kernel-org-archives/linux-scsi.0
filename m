From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH 20/30] scsi: In the Advansys driver, do not cast allocation function return values
Date: Fri, 24 Aug 2007 02:16:12 +0200
Message-ID: <82de4728edd63551c2c8a2fff0350f0917ed73a5.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.190]:63545 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965000AbXHXATH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Aug 2007 20:19:07 -0400
Received: by mu-out-0910.google.com with SMTP id i10so903537mue
        for <linux-scsi@vger.kernel.org>; Thu, 23 Aug 2007 17:19:06 -0700 (PDT)
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, linux@connectcom.net, Jesper Juhl <jesper.juhl@gmail.com>

There's no reason to cast void pointers returned by the generic
memory allocation functions.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/scsi/advansys.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 79c0b6e..b28729c 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -18513,7 +18513,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		 * Allocate buffer carrier structures. The total size
 		 * is about 4 KB, so allocate all at once.
 		 */
-		carrp = (ADV_CARR_T *) kmalloc(ADV_CARRIER_BUFSIZE, GFP_ATOMIC);
+		carrp = kmalloc(ADV_CARRIER_BUFSIZE, GFP_ATOMIC);
 		ASC_DBG1(1, "advansys_board_found: carrp 0x%lx\n", (ulong)carrp);
 
 		if (carrp == NULL) {
@@ -18529,8 +18529,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		for (req_cnt = adv_dvc_varp->max_host_qng;
 		     req_cnt > 0; req_cnt--) {
 
-			reqp = (adv_req_t *)
-			    kmalloc(sizeof(adv_req_t) * req_cnt, GFP_ATOMIC);
+			reqp = kmalloc(sizeof(adv_req_t) * req_cnt, GFP_ATOMIC);
 
 			ASC_DBG3(1,
 				 "advansys_board_found: reqp 0x%lx, req_cnt %d, bytes %lu\n",
@@ -18552,9 +18551,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		boardp->adv_sgblkp = NULL;
 		for (sg_cnt = 0; sg_cnt < ADV_TOT_SG_BLOCK; sg_cnt++) {
 
-			sgp = (adv_sgblk_t *)
-			    kmalloc(sizeof(adv_sgblk_t), GFP_ATOMIC);
-
+			sgp = kmalloc(sizeof(adv_sgblk_t), GFP_ATOMIC);
 			if (sgp == NULL) {
 				break;
 			}
-- 
1.5.2.2

