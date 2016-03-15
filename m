From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] qla2xxx: avoid maybe_uninitialized warning
Date: Tue, 15 Mar 2016 22:40:31 +0100
Message-ID: <1458078051-529344-1-git-send-email-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:54557 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427AbcCOVlI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2016 17:41:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Nicholas Bellinger <nab@linux-iscsi.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Alexei Potashnik <alexei@purestorage.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Swapnil Nagle <swapnil.nagle@purestorage.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The qlt_check_reserve_free_req() function produces an incorrect warning
when CONFIG_PROFILE_ANNOTATED_BRANCHES is set:

drivers/scsi/qla2xxx/qla_target.c: In function 'qlt_check_reserve_free_req':
drivers/scsi/qla2xxx/qla_target.c:1887:3: error: 'cnt_in' may be used uninitialized in this function [-Werror=maybe-uninitialized]
   ql_dbg(ql_dbg_io, vha, 0x305a,
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       "qla_target(%d): There is no room in the request ring: vha->req->ring_index=%d, vha->req->cnt=%d, req_cnt=%d Req-out=%d Req-in=%d Req-Length=%d\n",
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       vha->vp_idx, vha->req->ring_index,
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       vha->req->cnt, req_cnt, cnt, cnt_in, vha->req->length);
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/qla2xxx/qla_target.c:1887:3: error: 'cnt' may be used uninitialized in this function [-Werror=maybe-uninitialized]

The problem is that gcc fails to track the state of the condition across
an annotated branch.

This slightly rearranges the code to move the second if() block
into the first one, to avoid the warning while retaining the
behavior of the code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/qla2xxx/qla_target.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 985231900aca..8a44d1541eb4 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1881,15 +1881,17 @@ static int qlt_check_reserve_free_req(struct scsi_qla_host *vha,
 		else
 			vha->req->cnt = vha->req->length -
 			    (vha->req->ring_index - cnt);
-	}
 
-	if (unlikely(vha->req->cnt < (req_cnt + 2))) {
-		ql_dbg(ql_dbg_io, vha, 0x305a,
-		    "qla_target(%d): There is no room in the request ring: vha->req->ring_index=%d, vha->req->cnt=%d, req_cnt=%d Req-out=%d Req-in=%d Req-Length=%d\n",
-		    vha->vp_idx, vha->req->ring_index,
-		    vha->req->cnt, req_cnt, cnt, cnt_in, vha->req->length);
-		return -EAGAIN;
+		if (unlikely(vha->req->cnt < (req_cnt + 2))) {
+			ql_dbg(ql_dbg_io, vha, 0x305a,
+			    "qla_target(%d): There is no room in the request ring: vha->req->ring_index=%d, vha->req->cnt=%d, req_cnt=%d Req-out=%d Req-in=%d Req-Length=%d\n",
+			    vha->vp_idx, vha->req->ring_index,
+			    vha->req->cnt, req_cnt, cnt, cnt_in,
+			    vha->req->length);
+			return -EAGAIN;
+		}
 	}
+
 	vha->req->cnt -= req_cnt;
 
 	return 0;
-- 
2.7.0

