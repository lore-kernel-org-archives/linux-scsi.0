From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 4/8] qla4xxx: clear AF_DPC_SCHEDULED flage when exit from
	do_dpc
Date: Fri, 30 Jul 2010 14:27:19 +0530
Message-ID: <20100730085719.GA12302@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:16282
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754432Ab0G3JAm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 05:00:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vikas.chaudhary@qlogic.com, ravi.anand@qlogic.com, michaelc@cs.wisc.edu

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index fd1af23..e575d76 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1208,7 +1208,7 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 
 	/* Initialization not yet finished. Don't do anything yet. */
 	if (!test_bit(AF_INIT_DONE, &ha->flags))
-		return;
+		goto do_dpc_exit;
 
 	/* HBA is in the process of being permanently disabled.
 	 * Don't process anything */
@@ -1347,6 +1347,8 @@ dpc_post_reset_ha:
 			}
 		}
 	}
+
+do_dpc_exit:
 	clear_bit(AF_DPC_SCHEDULED, &ha->flags);
 }
 
-- 
1.6.6

