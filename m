From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: qla2xxxx: avoid type mismatch in comparison
Date: Wed, 20 Jan 2016 11:47:14 +0100
Message-ID: <1603472.f34vvTrhuN@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:53086 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934859AbcATKsI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2016 05:48:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Alexei Potashnik <alexei@purestorage.com>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Hannes Reinecke <hare@suse.com>

A recent bug fix added code that does

        bool logged_out = (status & 0xFFFF);
        if (logged_out == CTIO_PORT_LOGGED_OUT)
		...

This looks wrong because we are comparing a boolean with an
integer constant, ang gcc warns about it accordingly:

drivers/scsi/qla2xxx/qla_target.c: In function 'qlt_do_ctio_completion':
drivers/scsi/qla2xxx/qla_target.c:3587:20: warning: comparison of constant '41' with boolean expression is always false [-Wbool-compare]
        (logged_out == CTIO_PORT_LOGGED_OUT) ?

The correct fix is presumably to make that variable an 'int'.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 71cdc0796465 ("qla2xxx: Delete session if initiator is gone from FW")
---
The patch introducing this is currenly in linux-next through the target-updates/for-next
branch.

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index c7ab9e69c881..8075a4cdb45c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3580,7 +3580,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 		case CTIO_PORT_LOGGED_OUT:
 		case CTIO_PORT_UNAVAILABLE:
 		{
-			bool logged_out = (status & 0xFFFF);
+			int logged_out = (status & 0xFFFF);
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf059,
 			    "qla_target(%d): CTIO with %s status %x "
 			    "received (state %x, se_cmd %p)\n", vha->vp_idx,

