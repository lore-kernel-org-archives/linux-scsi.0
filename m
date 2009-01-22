From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 08/12] qla2xxx: Correct regression in EH abort handling.
Date: Thu, 22 Jan 2009 09:45:35 -0800
Message-ID: <1232646339-32503-9-git-send-email-andrew.vasquez@qlogic.com>
References: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46489 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758474AbZAVRpq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 12:45:46 -0500
In-Reply-To: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Commit 73208dfd7ab19f379d73e8a0fbf30f92c203e5e8 (qla2xxx: add
support for multi-queue adapter) inadvertently backed-out the fix
in 5bff55db3dc4d659f46b4d2fce2f61c1964c2762 (qla2xxx: Return a
FAILED status when abort mailbox-command fails.).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index cbf377f..f344b68 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -800,6 +800,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		if (ha->isp_ops->abort_command(vha, sp, req)) {
 			DEBUG2(printk("%s(%ld): abort_command "
 			"mbx failed.\n", __func__, vha->host_no));
+			ret = FAILED;
 		} else {
 			DEBUG3(printk("%s(%ld): abort_command "
 			"mbx success.\n", __func__, vha->host_no));
-- 
1.6.1.48.ge9b8

