From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 03/11] qla4xxx: correct return status in function
	qla4xxx_fw_ready
Date: Thu, 17 Jun 2010 02:20:48 +0530
Message-ID: <20100616205048.GA8139@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:21365
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753571Ab0FPUwT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2010 16:52:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

Handle fw_state "auto discovery in progress" correctly
to avoid marking adapter as offline.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 1656522..d525405 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -399,6 +399,7 @@ static int qla4xxx_fw_ready(struct scsi_qla_host *ha)
 		DEBUG2(printk("scsi%ld: %s: FW initialized, but "
 			      "auto-discovery still in process\n",
 			       ha->host_no, __func__));
+		ready = 1;
 	}
 
 	return ready;
-- 
1.7.0.5

