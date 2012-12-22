From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 2/8] bnx2fc: Remove potential NULL dereference
Date: Fri, 21 Dec 2012 19:40:28 -0800
Message-ID: <1356147634-17252-3-git-send-email-bprakash@broadcom.com>
References: <1356147634-17252-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2967 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab2LVDkn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2012 22:40:43 -0500
In-Reply-To: <1356147634-17252-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, Julia Lawall <Julia.Lawall@lip6.fr>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Julia Lawall <Julia.Lawall@lip6.fr>

If the NULL test is necessary, the initialization involving a dereference of
the tested value should be moved after the NULL test.

The sematic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 8d4626c..c661ccd 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -685,8 +685,8 @@ int bnx2fc_init_mp_req(struct bnx2fc_cmd *io_req)
 static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 {
 	struct fc_lport *lport;
-	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
-	struct fc_rport_libfc_priv *rp = rport->dd_data;
+	struct fc_rport *rport;
+	struct fc_rport_libfc_priv *rp;
 	struct fcoe_port *port;
 	struct bnx2fc_interface *interface;
 	struct bnx2fc_rport *tgt;
@@ -704,6 +704,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 	unsigned long start = jiffies;
 
 	lport = shost_priv(host);
+	rport = starget_to_rport(scsi_target(sc_cmd->device));
 	port = lport_priv(lport);
 	interface = port->priv;
 
@@ -712,6 +713,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 		rc = FAILED;
 		goto tmf_err;
 	}
+	rp = rport->dd_data;
 
 	rc = fc_block_scsi_eh(sc_cmd);
 	if (rc)
-- 
1.7.0.6


