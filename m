From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH]: TASK ABORTED status handling improvement
Date: Thu, 06 Nov 2008 13:57:52 +0300
Message-ID: <4912CDB0.6010101@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:34290 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753452AbYKFK55 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 05:57:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

This patch improves handling of TASK ABORTED status by Linux SCSI mid-layer. Currently,
command returned with this status considered failed and returned to upper layers. It
leads to additional error recovery load on file systems and block layer, which sometimes
can cause undesired side effects, like I/O errors and file systems corruptions. See
http://lkml.org/lkml/2008/11/1/38, for instance.

>From other side, TASK ABORTED status is returned by SCSI target if the corresponding
command was aborted by another initiator and the target has TAS bit set in the control
mode page. So, in the majority of cases commands with TASK ABORTED status should be
simply retried. In other cases, maybe_retry path will not retry if no retries are allowed.

This patch implement suggestion by James Bottomley from http://marc.info/?l=linux-scsi&m=121932916906009&w=2.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>

 scsi_error.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -upr linux-2.6.27.2/drivers/scsi/scsi_error.c linux-2.6.27.2/drivers/scsi/scsi_error.c
--- linux-2.6.27.2/drivers/scsi/scsi_error.c	2008-10-10 02:13:53.000000000 +0400
+++ linux-2.6.27.2/drivers/scsi/scsi_error.c	2008-11-01 21:50:56.000000000 +0300
@@ -1408,8 +1408,9 @@ int scsi_decide_disposition(struct scsi_
 		return ADD_TO_MLQUEUE;
 	case GOOD:
 	case COMMAND_TERMINATED:
-	case TASK_ABORTED:
 		return SUCCESS;
+	case TASK_ABORTED:
+		goto maybe_retry;
 	case CHECK_CONDITION:
 		rtn = scsi_check_sense(scmd);
 		if (rtn == NEEDS_RETRY)

