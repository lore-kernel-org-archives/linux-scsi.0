From: andrew.vasquez@qlogic.com
Subject: [PATCH 3/4] qla2xxx: Pass input-buffer length to Get-ID-List mailbox command.
Date: Tue, 7 Feb 2006 08:45:40 -0800
Message-ID: <1139330735541-git-send-email-andrew.vasquez@qlogic.com>
References: <20060207163937.GC1405@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:5515 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1750855AbWBGQpk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 11:45:40 -0500
In-Reply-To: <20060207163937.GC1405@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Recent ISP24xx firmwares require that mailbox register 8 be
set to the maximum number of bytes to transfer during DMA
copying of the list.  We safely set this value to zero
(infinite), since the call is *only* made in FCAL
topologies.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_mbx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

ed7038ddd32a9d5a77076df32cce4e407ceba4d0
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 49ce197..363dfdd 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1873,7 +1873,8 @@ qla2x00_get_id_list(scsi_qla_host_t *ha,
 		mcp->mb[3] = LSW(id_list_dma);
 		mcp->mb[6] = MSW(MSD(id_list_dma));
 		mcp->mb[7] = LSW(MSD(id_list_dma));
-		mcp->out_mb |= MBX_7|MBX_6|MBX_3|MBX_2;
+		mcp->mb[8] = 0;
+		mcp->out_mb |= MBX_8|MBX_7|MBX_6|MBX_3|MBX_2;
 	} else {
 		mcp->mb[1] = MSW(id_list_dma);
 		mcp->mb[2] = LSW(id_list_dma);
-- 
1.1.6.ga2c6


