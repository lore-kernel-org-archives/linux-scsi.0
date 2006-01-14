From: andrew.vasquez@qlogic.com
Subject: [PATCH 12/15] qla2xxx: Correct setting of FDMI supported/current port speed.
Date: Fri, 13 Jan 2006 17:05:48 -0800
Message-ID: <11372007432052-git-send-email-andrew.vasquez@qlogic.com>
References: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:41509 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1945937AbWANBFs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 20:05:48 -0500
In-Reply-To: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_gs.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

898e417ede8209f7f041ffb318d4e4762f153c07
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 0e8ada0..d620a8e 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1530,9 +1530,9 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	eiter->type = __constant_cpu_to_be16(FDMI_PORT_SUPPORT_SPEED);
 	eiter->len = __constant_cpu_to_be16(4 + 4);
 	if (IS_QLA25XX(ha))
-		eiter->a.sup_speed = __constant_cpu_to_be32(4);
-	else if (IS_QLA24XX(ha))
 		eiter->a.sup_speed = __constant_cpu_to_be32(8);
+	else if (IS_QLA24XX(ha))
+		eiter->a.sup_speed = __constant_cpu_to_be32(4);
 	else if (IS_QLA23XX(ha))
 		eiter->a.sup_speed = __constant_cpu_to_be32(2);
 	else
@@ -1554,9 +1554,6 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 		eiter->a.cur_speed = __constant_cpu_to_be32(2);
 		break;
 	case 3:
-		eiter->a.cur_speed = __constant_cpu_to_be32(8);
-		break;
-	case 4:
 		eiter->a.cur_speed = __constant_cpu_to_be32(4);
 		break;
 	}
-- 
1.1.1-g4c34


