From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 1/2] qla2xxx: Add fix to read correct register value for ISP82xx.
Date: Fri, 31 Mar 2017 14:37:03 -0700
Message-ID: <20170331213704.5577-2-himanshu.madhani@cavium.com>
References: <20170331213704.5577-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0083.outbound.protection.outlook.com ([104.47.40.83]:54461
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755199AbdCaVh2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 31 Mar 2017 17:37:28 -0400
In-Reply-To: <20170331213704.5577-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@cavium.com>

Add fix to read correct register value for ISP82xx, during
check for register disconnect.ISP82xx has different base register.

Fixes: a465537ad1a4 ("qla2xxx: Disable the adapter and skip error recovery in case of register disconnect")
Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3e7011757c82..83d61d2142e9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1160,8 +1160,13 @@ static inline
 uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 {
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	struct device_reg_82xx __iomem *reg82 = &ha->iobase->isp82;
 
-	return ((RD_REG_DWORD(&reg->host_status)) == ISP_REG_DISCONNECT);
+	if (IS_P3P_TYPE(ha))
+		return ((RD_REG_DWORD(&reg82->host_int)) == ISP_REG_DISCONNECT);
+	else
+		return ((RD_REG_DWORD(&reg->host_status)) ==
+			ISP_REG_DISCONNECT);
 }
 
 /**************************************************************************
-- 
2.12.0
