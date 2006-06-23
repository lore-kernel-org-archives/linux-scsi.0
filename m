From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/13] qla2xxx: Honour 'skip process-login' option during fabric-login IOCB.
Date: Fri, 23 Jun 2006 16:10:44 -0700
Message-ID: <11511042393999-git-send-email-andrew.vasquez@qlogic.com>
References: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:6064 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1752157AbWFWXKp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 19:10:45 -0400
In-Reply-To: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 39ddd38..3b16d6f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1458,6 +1458,8 @@ qla24xx_login_fabric(scsi_qla_host_t *ha
 	lg->control_flags = __constant_cpu_to_le16(LCF_COMMAND_PLOGI);
 	if (opt & BIT_0)
 		lg->control_flags |= __constant_cpu_to_le16(LCF_COND_PLOGI);
+	if (opt & BIT_1)
+		lg->control_flags |= __constant_cpu_to_le16(LCF_SKIP_PRLI);
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
-- 
1.4.1.rc1.gf603


