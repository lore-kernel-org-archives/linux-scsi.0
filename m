From: vikas.chaudhary@qlogic.com
Subject: [PATCH 2/3] qla4xxx: Correct the validation to check in get_sys_info mailbox
Date: Sat, 29 Dec 2012 02:24:53 -0500
Message-ID: <1356765894-14001-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1356765894-14001-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:30714 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752034Ab2L2Hob (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Dec 2012 02:44:31 -0500
In-Reply-To: <1356765894-14001-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

Check mbox_sts[3] instead of mbox_sts[4] for ISP83xx to validate size
of data returned

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 491668d..b3d6dab 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -3427,11 +3427,11 @@ int qla4_8xxx_get_sys_info(struct scsi_qla_host *ha)
 	}
 
 	/* Make sure we receive the minimum required data to cache internally */
-	if (mbox_sts[4] < offsetof(struct mbx_sys_info, reserved)) {
+	if ((is_qla8032(ha) ? mbox_sts[3] : mbox_sts[4]) <
+	    offsetof(struct mbx_sys_info, reserved)) {
 		DEBUG2(printk("scsi%ld: %s: GET_SYS_INFO data receive"
 		    " error (%x)\n", ha->host_no, __func__, mbox_sts[4]));
 		goto exit_validate_mac82;
-
 	}
 
 	/* Save M.A.C. address & serial_number */
-- 
1.7.8.GIT

