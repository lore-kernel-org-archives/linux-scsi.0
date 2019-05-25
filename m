From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: megaraid_sas: remove set but not used variable 'sge_sz'
Date: Sat, 25 May 2019 20:37:05 +0800
Message-ID: <20190525123705.8588-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/megaraid/megaraid_sas_base.c: In function megasas_create_frame_pool:
drivers/scsi/megaraid/megaraid_sas_base.c:4124:6: warning: variable sge_sz set but not used [-Wunused-but-set-variable]

It's not used any more since
commit 200aed582d61 ("megaraid_sas: endianness related bug fixes and code optimization")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b26991dcf137..25281a2eb424 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4121,22 +4121,11 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 {
 	int i;
 	u16 max_cmd;
-	u32 sge_sz;
 	u32 frame_count;
 	struct megasas_cmd *cmd;
 
 	max_cmd = instance->max_mfi_cmds;
 
-	/*
-	 * Size of our frame is 64 bytes for MFI frame, followed by max SG
-	 * elements and finally SCSI_SENSE_BUFFERSIZE bytes for sense buffer
-	 */
-	sge_sz = (IS_DMA64) ? sizeof(struct megasas_sge64) :
-	    sizeof(struct megasas_sge32);
-
-	if (instance->flag_ieee)
-		sge_sz = sizeof(struct megasas_sge_skinny);
-
 	/*
 	 * For MFI controllers.
 	 * max_num_sge = 60
-- 
2.17.1
