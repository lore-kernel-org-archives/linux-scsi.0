From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 07/15] qla2xxx: Add support for alternate WWN NVRAM setting.
Date: Wed, 17 May 2006 15:09:16 -0700
Message-ID: <11479037511236-git-send-email-andrew.vasquez@qlogic.com>
References: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:51385 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1751219AbWEQWJS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:09:18 -0400
In-Reply-To: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

4a276fe3b1319b89cf996d998def174288ddfb60
 drivers/scsi/qla2xxx/qla_init.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

4a276fe3b1319b89cf996d998def174288ddfb60
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7a5d52f..b1b20f4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1532,6 +1532,12 @@ #endif
 	while (cnt--)
 		*dptr1++ = *dptr2++;
 
+	/* Use alternate WWN? */
+	if (nv->host_p[1] & BIT_7) {
+		memcpy(icb->node_name, nv->alternate_node_name, WWN_SIZE);
+		memcpy(icb->port_name, nv->alternate_port_name, WWN_SIZE);
+	}
+
 	/* Prepare nodename */
 	if ((icb->firmware_options[1] & BIT_6) == 0) {
 		/*
@@ -3370,6 +3376,12 @@ qla24xx_nvram_config(scsi_qla_host_t *ha
 	} else
 		strcpy(ha->model_number, "QLA2462");
 
+	/* Use alternate WWN? */
+	if (nv->host_p & __constant_cpu_to_le32(BIT_15)) {
+		memcpy(icb->node_name, nv->alternate_node_name, WWN_SIZE);
+		memcpy(icb->port_name, nv->alternate_port_name, WWN_SIZE);
+	}
+
 	/* Prepare nodename */
 	if ((icb->firmware_options_1 & __constant_cpu_to_le32(BIT_14)) == 0) {
 		/*
-- 
1.3.3.g63df


