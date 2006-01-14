From: andrew.vasquez@qlogic.com
Subject: [PATCH 08/15] qla2xxx: Correct issue where portstate does not transition during loop-resync.
Date: Fri, 13 Jan 2006 17:05:26 -0800
Message-ID: <11372007213517-git-send-email-andrew.vasquez@qlogic.com>
References: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:53028 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1945932AbWANBF1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 20:05:27 -0500
In-Reply-To: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

If the Get Port Database call fails during local-loop
update, then schedule the DPC routine to perform a rescan as
the firmware would have updated the Get ID List port-entries
of their new state.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_init.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

0d66c170cc9ef36804e0496c27e7c9194e335809
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7d973bd..e21316a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1939,6 +1939,9 @@ qla2x00_configure_local_loop(scsi_qla_ho
 			    "information -- get_port_database=%x, "
 			    "loop_id=0x%04x\n",
 			    ha->host_no, rval2, new_fcport->loop_id));
+			DEBUG2(printk("scsi(%ld): Scheduling resync...\n",
+			    ha->host_no));
+			set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
 			continue;
 		}
 
-- 
1.1.1-g4c34


