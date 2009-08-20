From: michaelc@cs.wisc.edu
Subject: [PATCH 2/7] libiscsi: don't increment cmdsn if cmd is not sent
Date: Thu, 20 Aug 2009 15:10:58 -0500
Message-ID: <1250799063-1843-3-git-send-email-michaelc@cs.wisc.edu>
References: <1250799063-1843-1-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbZHTULH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 16:11:07 -0400
In-Reply-To: <1250799063-1843-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We increment session->cmdsn at the top of iscsi_prep_scsi_cmd_pdu, but
if the prep  ecb or prep bidi or init_task calls fails then we leave the
session->cmdsn incremented. This moves the cmdsn manipulation to the end
of the function when we know it has succeeded.

It also adds a session->cmdsn--; in queuecommand for if a driver like
bnx2i tries to send a a task from that context but it fails. We do not
have to do this in the xmit thread context because that code will retry
the same task if the initial call fails.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 716cc34..3cef35b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -301,8 +301,6 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	hdr->flags = ISCSI_ATTR_SIMPLE;
 	int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
 	memcpy(task->lun, hdr->lun, sizeof(task->lun));
-	hdr->cmdsn = task->cmdsn = cpu_to_be32(session->cmdsn);
-	session->cmdsn++;
 	hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
 	cmd_len = sc->cmd_len;
 	if (cmd_len < ISCSI_CDB_SIZE)
@@ -388,6 +386,8 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 		return -EIO;
 
 	task->state = ISCSI_TASK_RUNNING;
+	hdr->cmdsn = task->cmdsn = cpu_to_be32(session->cmdsn);
+	session->cmdsn++;
 
 	conn->scsicmd_pdus_cnt++;
 	ISCSI_DBG_SESSION(session, "iscsi prep [%s cid %d sc %p cdb 0x%x "
@@ -1497,6 +1497,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 			}
 		}
 		if (session->tt->xmit_task(task)) {
+			session->cmdsn--;
 			reason = FAILURE_SESSION_NOT_READY;
 			goto prepd_reject;
 		}
-- 
1.6.2.2

