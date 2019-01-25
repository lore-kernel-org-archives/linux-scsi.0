From: John Garry <john.garry@huawei.com>
Subject: [PATCH 13/13] scsi: hisi_sas: Add missing seq_printf() call in hisi_sas_show_row_32()
Date: Fri, 25 Jan 2019 22:22:39 +0800
Message-ID: <1548426159-225679-14-git-send-email-john.garry@huawei.com>
References: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This call must have been missed when I reworked the debugfs feature
for upstreaming, so add it back.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index e48b627..13ab0ad 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2692,6 +2692,7 @@ static int hisi_sas_show_row_32(struct seq_file *s, int index,
 	/* completion header size not fixed per HW version */
 	seq_printf(s, "index %04d:\n\t", index);
 	for (i = 1; i <= sz / 4; i++, ptr++) {
+		seq_printf(s, " 0x%08x", le32_to_cpu(*ptr));
 		if (!(i % 4))
 			seq_puts(s, "\n\t");
 	}
-- 
1.9.1
