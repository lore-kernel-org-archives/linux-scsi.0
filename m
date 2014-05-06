From: Jay Kallickal <jayamohank@gmail.com>
Subject: [PATCH 7/8] be2iscsi: Fix processing cqe for cxn whose endpoint is freed
Date: Mon,  5 May 2014 21:41:30 -0400
Message-ID: <1399340492-2136-7-git-send-email-jkallickal@emulex.com>
References: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57505 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933469AbaEFBl4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2014 21:41:56 -0400
Received: by mail-pa0-f46.google.com with SMTP id kx10so7700190pab.19
        for <linux-scsi@vger.kernel.org>; Mon, 05 May 2014 18:41:56 -0700 (PDT)
In-Reply-To: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Minh Tran <minhduc.tran@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 During heavy IO in multipath environment with many active sessions
 and port-bouncing happening, there is a race condition because of
 which beiscsi_prcess_cqe() gets called for a connection whose
 endpoint is freed.

 Checking endpoint reference for a connection before processing in
 beiscsi_process_cq().

Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index dccda6c..5a7022f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2110,6 +2110,16 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 
 		cri_index = BE_GET_CRI_FROM_CID(cid);
 		ep = phba->ep_array[cri_index];
+		if (unlikely(ep == NULL)) {
+			/* connection has already been freed
+			 * just move on to next one
+			 */
+			beiscsi_log(phba, KERN_WARNING,
+				    BEISCSI_LOG_INIT,
+				    "BM_%d : proc cqe of disconn ep: cid %d\n",
+				    cid);
+			goto proc_next_cqe;
+		}
 		beiscsi_ep = ep->dd_data;
 		beiscsi_conn = beiscsi_ep->conn;
 
@@ -2219,6 +2229,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 			break;
 		}
 
+proc_next_cqe:
 		AMAP_SET_BITS(struct amap_sol_cqe, valid, sol, 0);
 		queue_tail_inc(cq);
 		sol = queue_tail_node(cq);
-- 
1.8.5.3

