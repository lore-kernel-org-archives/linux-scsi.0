From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 12/13] qla2xxx: Correctly set the firmware NOS/OLS timeout during initialization.
Date: Fri, 23 Jun 2006 16:11:27 -0700
Message-ID: <11511042821184-git-send-email-andrew.vasquez@qlogic.com>
References: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:14770 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1752166AbWFWXL1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 19:11:27 -0400
In-Reply-To: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Original code incorrectly assigned it to the driver's
link-down-timeout value (a value in seconds).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_fw.h   |    2 +-
 drivers/scsi/qla2xxx/qla_init.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index af023f5..a0a722c 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -278,7 +278,7 @@ struct init_cb_24xx {
 	uint16_t response_q_length;
 	uint16_t request_q_length;
 
-	uint16_t link_down_timeout;		/* Milliseconds. */
+	uint16_t link_down_on_nos;		/* Milliseconds. */
 
 	uint16_t prio_request_q_length;
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c7ab668..ce32322 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3379,7 +3379,6 @@ qla24xx_nvram_config(scsi_qla_host_t *ha
 		nv->node_name[6] = 0x55;
 		nv->node_name[7] = 0x86;
 		nv->login_retry_count = __constant_cpu_to_le16(8);
-		nv->link_down_timeout = __constant_cpu_to_le16(200);
 		nv->interrupt_delay_timer = __constant_cpu_to_le16(0);
 		nv->login_timeout = __constant_cpu_to_le16(0);
 		nv->firmware_options_1 =
@@ -3408,7 +3407,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha
 		*dptr1++ = *dptr2++;
 
 	icb->login_retry_count = nv->login_retry_count;
-	icb->link_down_timeout = nv->link_down_timeout;
+	icb->link_down_on_nos = nv->link_down_on_nos;
 
 	/* Copy 2nd segment. */
 	dptr1 = (uint8_t *)&icb->interrupt_delay_timer;
-- 
1.4.1.rc1.gf603


