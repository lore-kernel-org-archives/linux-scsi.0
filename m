From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 10/13] qla2xxx: Correct 'loop-down' determination logic in qla2x00_fw_ready().
Date: Fri, 23 Jun 2006 16:11:17 -0700
Message-ID: <1151104272209-git-send-email-andrew.vasquez@qlogic.com>
References: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:23473 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1752164AbWFWXLR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 19:11:17 -0400
In-Reply-To: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

As there is no point in failing the initialization process when
firmware informs the host software that it could not transition
beyond a CONFIG_WAIT nor WAIT_FOR_LOGIN state.  Previous logic
would mark such conditions as a general *failure* and subsequently
tear-down the scsi-host during initialization.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 761dd1f..c7ab668 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1273,8 +1273,7 @@ qla2x00_fw_ready(scsi_qla_host_t *ha)
 			rval = QLA_FUNCTION_FAILED;
 
 			if (atomic_read(&ha->loop_down_timer) &&
-			    (fw_state >= FSTATE_LOSS_OF_SYNC ||
-				fw_state == FSTATE_WAIT_AL_PA)) {
+			    fw_state != FSTATE_READY) {
 				/* Loop down. Timeout on min_wait for states
 				 * other than Wait for Login.
 				 */
-- 
1.4.1.rc1.gf603


