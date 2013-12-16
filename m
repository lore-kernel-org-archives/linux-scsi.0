From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 11/24] qla4xxx: Fix failure of IDC Time Extend mailbox command
Date: Mon, 16 Dec 2013 06:49:41 -0500
Message-ID: <1387194594-29817-12-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51775 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754326Ab3LPMXj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:39 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Issue:
Mailbox command 0x102 (IDC Time Extend) failure seen while applying
changes to iface using iscsiadm

Fix:
Added fix to extend IDC timeout only for ISP84xx when IDC ACK
needs to be posted and disable ACB mailbox command completion
is in intermediate state.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 023f2dd..1d8f485 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1922,6 +1922,7 @@ int qla4xxx_disable_acb(struct scsi_qla_host *ha)
 				  mbox_sts[0], mbox_sts[1], mbox_sts[2]));
 	} else {
 		if (is_qla8042(ha) &&
+		    test_bit(DPC_POST_IDC_ACK, &ha->dpc_flags) &&
 		    (mbox_sts[0] != MBOX_STS_COMMAND_COMPLETE)) {
 			/*
 			 * Disable ACB mailbox command takes time to complete
-- 
1.8.2.GIT

