From: madhu.iyengar@qlogic.com
Subject: [PATCH 3/7] qla2xxx: Reset seconds_since_last_heartbeat correctly.
Date: Fri,  3 Sep 2010 14:57:02 -0700
Message-ID: <1283551026-3886-4-git-send-email-madhu.iyengar@qlogic.com>
References: <1283551026-3886-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:42964 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1757594Ab0ICWDH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:03:07 -0400
In-Reply-To: <1283551026-3886-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nkmi@yahoo.com

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

The seconds_since_last_heartbeat should be checked for consecutive
heartbeat checks. Currently it could happen that seconds_since_last_heartbeat
gets set to max (2 seconds) for non-consecutive heartbeat checks.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 915b77a..e54d2fa 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3316,7 +3316,8 @@ qla82xx_check_fw_alive(scsi_qla_host_t *vha)
 				complete(&ha->mbx_intr_comp);
 			}
 		}
-	}
+	} else
+		vha->seconds_since_last_heartbeat = 0;
 	vha->fw_heartbeat_counter = fw_heartbeat_counter;
 }
 
-- 
1.6.0.2

