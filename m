From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] [SCSI] bnx2fc: move the dereference below the NULL test
Date: Fri, 7 Sep 2012 14:59:47 +0800
Message-ID: <CAPgLHd-N6Sx-d2_28+FFkWaXCB0gQQJBBZWouPwzFeOm6wkRxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33690 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab2IGG7r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Sep 2012 02:59:47 -0400
Received: by qcro28 with SMTP id o28so1233388qcr.19
        for <linux-scsi@vger.kernel.org>; Thu, 06 Sep 2012 23:59:47 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bprakash@broadcom.com, JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 73f231c..298a0fe 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -686,7 +686,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 {
 	struct fc_lport *lport;
 	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
-	struct fc_rport_libfc_priv *rp = rport->dd_data;
+	struct fc_rport_libfc_priv *rp;
 	struct fcoe_port *port;
 	struct bnx2fc_interface *interface;
 	struct bnx2fc_rport *tgt;
@@ -722,6 +722,8 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 		rc = FAILED;
 		goto tmf_err;
 	}
+
+	rp = rport->dd_data;
 	/* rport and tgt are allocated together, so tgt should be non-NULL */
 	tgt = (struct bnx2fc_rport *)&rp[1];
 

