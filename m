From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] scsi: libfc: fix incorrect variable assingment
Date: Thu, 11 May 2017 17:24:44 -0500
Message-ID: <20170511222444.GA6604@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

Previous assignment was causing the use of the uninitialized variable
_explan_ inside fc_seq_ls_rjt() function, which in this particular
case is being called by fc_seq_els_rsp_send().

Addresses-Coverity-ID: 1398125
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/scsi/libfc/fc_rport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index b44c313..5203258 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1422,7 +1422,7 @@ static void fc_rport_recv_rtv_req(struct fc_rport_priv *rdata,
 	fp = fc_frame_alloc(lport, sizeof(*rtv));
 	if (!fp) {
 		rjt_data.reason = ELS_RJT_UNAB;
-		rjt_data.reason = ELS_EXPL_INSUF_RES;
+		rjt_data.explan = ELS_EXPL_INSUF_RES;
 		fc_seq_els_rsp_send(in_fp, ELS_LS_RJT, &rjt_data);
 		goto drop;
 	}
-- 
2.5.0
