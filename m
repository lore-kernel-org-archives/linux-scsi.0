From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 01/13] qla4xxx: cleanup qla4xxx_initialize_ddb_list()
Date: Sun, 13 Mar 2011 22:23:56 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872263B1507@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db3.bigfish.com ([94.245.120.74]:57206 "EHLO
	DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753138Ab1CNFjJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 01:39:09 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

Remove process all aen code from qla4xxx_initialize_ddb_list()
as DPC activities should be done in DPC only.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 1629c48..22fc57e 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1013,13 +1013,6 @@ static int qla4xxx_initialize_ddb_list(struct scsi_qla_host *ha)
        if ((status = qla4xxx_build_ddb_list(ha)) == QLA_ERROR)
                return status;

-       /*
-        * Targets can come online after the inital discovery, so processing
-        * the aens here will catch them.
-        */
-       if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags))
-               qla4xxx_process_aen(ha, PROCESS_ALL_AENS);
-
        return status;
 }

--
1.7.3.2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

