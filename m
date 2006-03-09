From: andrew.vasquez@qlogic.com
Subject: [PATCH 05/10] qla2xxx: Correct swing/emphasis settings on ISP24xx.
Date: Thu, 9 Mar 2006 14:27:29 -0800
Message-ID: <11419432442369-git-send-email-andrew.vasquez@qlogic.com>
References: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:26437 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751958AbWCIW13 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2006 17:27:29 -0500
In-Reply-To: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Reserved-bit 15 must set when updating the swing/emphasis values.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_mbx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

de7f144d663eec9871f2bbde046acb6808cf2768
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 267435f..85c83e0 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2406,9 +2406,9 @@ qla2x00_set_serdes_params(scsi_qla_host_
 
 	mcp->mb[0] = MBC_SERDES_PARAMS;
 	mcp->mb[1] = BIT_0;
-	mcp->mb[2] = sw_em_1g;
-	mcp->mb[3] = sw_em_2g;
-	mcp->mb[4] = sw_em_4g;
+	mcp->mb[2] = sw_em_1g | BIT_15;
+	mcp->mb[3] = sw_em_2g | BIT_15;
+	mcp->mb[4] = sw_em_4g | BIT_15;
 	mcp->out_mb = MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
 	mcp->tov = 30;
-- 
1.2.4.gf067


