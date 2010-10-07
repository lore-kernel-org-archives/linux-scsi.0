From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 07/15] qla4xxx: Reset seconds_since_last_heartbeat correctly.
Date: Wed, 6 Oct 2010 22:49:32 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8712940678A@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:37545 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab0JGFtf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 01:49:35 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Lalit Chandivade <lalit.chandivade@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

The seconds_since_last_heartbeat should be checked for consecutive
heartbeat checks. Currently it could happen that it gets set to
max (2 seconds) for non-consecutive heartbeat checks.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a6455fb..57890b6 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -690,7 +690,9 @@ static void qla4_8xxx_check_fw_alive(struct scsi_qla_host *ha)
 			qla4xxx_wake_dpc(ha);
 			qla4xxx_mailbox_premature_completion(ha);
 		}
-	}
+	} else
+		ha->seconds_since_last_heartbeat = 0;
+
 	ha->fw_heartbeat_counter = fw_heartbeat_counter;
 }
 
-- 
1.6.6

