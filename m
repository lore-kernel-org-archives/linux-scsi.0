From: andrew.vasquez@qlogic.com
Subject: [PATCH 11/15] qla2xxx: Correct execution-throttle setting for ISP24xx.
Date: Fri, 13 Jan 2006 17:05:42 -0800
Message-ID: <11372007372134-git-send-email-andrew.vasquez@qlogic.com>
References: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:29989 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1945935AbWANBFn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 20:05:43 -0500
In-Reply-To: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Similarly to other ISPs, set execution throttle to maximum
allowed value since 'throttling' is done on a per-lun basis
via queue-depth.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

eb3db2c21b87bc7ed3964392542a3857f9b38576
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b4fbef5..8635bd1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3407,6 +3407,8 @@ qla24xx_nvram_config(scsi_qla_host_t *ha
 	ha->node_name = icb->node_name;
 	ha->port_name = icb->port_name;
 
+	icb->execution_throttle = __constant_cpu_to_le16(0xFFFF);
+
 	ha->retry_count = le16_to_cpu(nv->login_retry_count);
 
 	/* Set minimum login_timeout to 4 seconds. */
-- 
1.1.1-g4c34


