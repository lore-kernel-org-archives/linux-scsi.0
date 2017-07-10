From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] scsi: qla2xxx: Off by one in qlt_ctio_to_cmd()
Date: Mon, 10 Jul 2017 11:47:40 +0300
Message-ID: <20170710084739.tjj7juaex7cb7xs5@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50398 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753374AbdGJIr4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2017 04:47:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

There are "req->num_outstanding_cmds" elements in the
req->outstanding_cmds[] array so the > here should be >=.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 6e4794367e0b..ecd1a95511f9 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3728,7 +3728,7 @@ static struct qla_tgt_cmd *qlt_ctio_to_cmd(struct scsi_qla_host *vha,
 	h &= QLA_CMD_HANDLE_MASK;
 
 	if (h != QLA_TGT_NULL_HANDLE) {
-		if (unlikely(h > req->num_outstanding_cmds)) {
+		if (unlikely(h >= req->num_outstanding_cmds)) {
 			ql_dbg(ql_dbg_tgt, vha, 0xe052,
 			    "qla_target(%d): Wrong handle %x received\n",
 			    vha->vp_idx, handle);
