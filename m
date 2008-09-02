From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/8] sg: remove SG_ALLOW_DIO_CODE define
Date: Tue,  2 Sep 2008 22:50:02 +0900
Message-ID: <1220363408-7134-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220363408-7134-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50908 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbYIBNwt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 09:52:49 -0400
In-Reply-To: <1220363408-7134-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp

sg had lots of the own functions for the direct IO but now sg uses the
block layer functions for it. There are only five lines for the direct
IO. SG_ALLOW_DIO_CODE define was used to compile out the direct IO
code but we don't need the define. If someone wants to remove the
direct IO code, he can do easily without the define.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index d18f90d..2c30331 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -68,7 +68,6 @@ static void sg_proc_cleanup(void);
 #endif
 
 #define SG_ALLOW_DIO_DEF 0
-#define SG_ALLOW_DIO_CODE /* compile out by commenting this define */
 
 #define SG_MAX_DEVS 32768
 
@@ -1674,13 +1673,12 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
 		return 0;
 
-#ifdef SG_ALLOW_DIO_CODE
 	if (sg_allow_dio && (hp->flags & SG_FLAG_DIRECT_IO) &&
 	    (dxfer_dir != SG_DXFER_UNKNOWN) && (0 == hp->iovec_count) &&
 	    (!sfp->parentdp->device->host->unchecked_isa_dma) &&
 	    blk_rq_aligned(q, hp->dxferp, dxfer_len))
 		return sg_build_direct(srp, sfp, dxfer_len);
-#endif
+
 	if ((!sg_res_in_use(sfp)) && (dxfer_len <= rsv_schp->bufflen))
 		sg_link_reserve(sfp, srp, dxfer_len);
 	else
-- 
1.5.4.2

