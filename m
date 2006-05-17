From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 01/15] qla2xxx: Don't wait for loop transition to complete if LOOP_DEAD state is attained.
Date: Wed, 17 May 2006 15:08:44 -0700
Message-ID: <11479037244159-git-send-email-andrew.vasquez@qlogic.com>
References: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:59574 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1751212AbWEQWIp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:08:45 -0400
In-Reply-To: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Ravi Anand <ravi.anand@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

05918cebc51f79dc3d34fc2cca2faa7671012c6e
 drivers/scsi/qla2xxx/qla_os.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

05918cebc51f79dc3d34fc2cca2faa7671012c6e
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 584fe5d..2c608b3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -577,6 +577,10 @@ qla2x00_wait_for_loop_ready(scsi_qla_hos
 	while ((!atomic_read(&ha->loop_down_timer) &&
 	    atomic_read(&ha->loop_state) == LOOP_DOWN) ||
 	    atomic_read(&ha->loop_state) != LOOP_READY) {
+		if (atomic_read(&ha->loop_state) == LOOP_DEAD) {
+			return_status = QLA_FUNCTION_FAILED;
+			break;
+		}
 		msleep(1000);
 		if (time_after_eq(jiffies, loop_timeout)) {
 			return_status = QLA_FUNCTION_FAILED;
-- 
1.3.3.g63df


