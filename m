From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: [PATCH RESEND] scsi: megaraid_sas: fix panic on loading firmware crashdump
Date: Mon, 22 Jul 2019 09:15:24 -0700
Message-ID: <20190722161524.23192-1-junxiao.bi@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, martin.petersen@oracle.com, junxiao.bi@oracle.com
List-Id: linux-scsi@vger.kernel.org

While loading fw crashdump in function fw_crash_buffer_show(),
left bytes in one dma chunk was not checked, if copying size
over it, overflow access will cause kernel panic.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 80ab9700f1de..3eef0858fa8e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3153,6 +3153,7 @@ fw_crash_buffer_show(struct device *cdev,
 		(struct megasas_instance *) shost->hostdata;
 	u32 size;
 	unsigned long dmachunk = CRASH_DMA_BUF_SIZE;
+	unsigned long chunk_left_bytes;
 	unsigned long src_addr;
 	unsigned long flags;
 	u32 buff_offset;
@@ -3176,6 +3177,8 @@ fw_crash_buffer_show(struct device *cdev,
 	}
 
 	size = (instance->fw_crash_buffer_size * dmachunk) - buff_offset;
+	chunk_left_bytes = dmachunk - (buff_offset % dmachunk);
+	size = (size > chunk_left_bytes) ? chunk_left_bytes : size;
 	size = (size >= PAGE_SIZE) ? (PAGE_SIZE - 1) : size;
 
 	src_addr = (unsigned long)instance->crash_buf[buff_offset / dmachunk] +
-- 
2.17.1
