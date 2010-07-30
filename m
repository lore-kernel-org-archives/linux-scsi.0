From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 3/8] qla4xxx: Stop firmware before doing init firmware.
Date: Fri, 30 Jul 2010 14:26:31 +0530
Message-ID: <20100730085631.GA12292@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:11103
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754775Ab0G3I7y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 04:59:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vikas.chaudhary@qlogic.com, ravi.anand@qlogic.com, michaelc@cs.wisc.edu, lalit.chandivade@qlogic.com

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

If BIOS is enabled then drivers init firmware fails since
BIOS has done the init once.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index de9f790..8841941 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -445,6 +445,12 @@ static int qla4xxx_init_firmware(struct scsi_qla_host *ha)
 {
 	int status = QLA_ERROR;
 
+	/* For 82xx, stop firmware before initializing because if BIOS
+	 * has previously initialized firmware, then driver's initialize
+	 * firmware will fail. */
+	if (is_qla8022(ha))
+		qla4_8xxx_stop_firmware(ha);
+
 	ql4_printk(KERN_INFO, ha, "Initializing firmware..\n");
 	if (qla4xxx_initialize_fw_cb(ha) == QLA_ERROR) {
 		DEBUG2(printk("scsi%ld: %s: Failed to initialize firmware "
-- 
1.6.6

