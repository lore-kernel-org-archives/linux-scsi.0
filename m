From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 08/10] qla4xxx: wait for device_ready before device
	discovery
Date: Sat, 10 Jul 2010 14:51:17 +0530
Message-ID: <20100710092117.GA11533@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:53296
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751827Ab0GJJY4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jul 2010 05:24:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

From: Karen Higgins <karen.higgins@qlogic.com>

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 0ffafe4..cdaf4bf 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -990,6 +990,9 @@ static int qla4xxx_initialize_ddb_list(struct scsi_qla_host *ha)
 
 	qla4xxx_flush_AENS(ha);
 
+	/* Wait for an AEN */
+	qla4xxx_devices_ready(ha);
+
 	/*
 	 * First perform device discovery for active
 	 * fw ddb indexes and build
@@ -998,9 +1001,6 @@ static int qla4xxx_initialize_ddb_list(struct scsi_qla_host *ha)
 	if ((status = qla4xxx_build_ddb_list(ha)) == QLA_ERROR)
 		return status;
 
-	/* Wait for an AEN */
-	qla4xxx_devices_ready(ha);
-
 	/*
 	 * Targets can come online after the inital discovery, so processing
 	 * the aens here will catch them.
-- 
1.7.0.5

