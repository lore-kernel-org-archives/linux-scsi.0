From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/25] scsi: hisi_sas: add slot init code
Date: Mon, 12 Oct 2015 23:20:18 +0800
Message-ID: <1444663237-238302-7-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
Cc: linux-kernel-u79uwXL29TZ19SzzRMN9sA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Add functionality to init slot indexing.

Slot indexing is for the host to track which slots
(or tags) are free and which are used.

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/Makefile        |  2 +-
 drivers/scsi/hisi_sas/hisi_sas.h      |  2 ++
 drivers/scsi/hisi_sas/hisi_sas_init.c |  2 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 28 ++++++++++++++++++++++++++++
 4 files changed, 33 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_main.c

diff --git a/drivers/scsi/hisi_sas/Makefile b/drivers/scsi/hisi_sas/Makefile
index 63c3c4d..33f30e8 100644
--- a/drivers/scsi/hisi_sas/Makefile
+++ b/drivers/scsi/hisi_sas/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_SCSI_HISI_SAS) += hisi_sas.o
-hisi_sas-y+= hisi_sas_init.o
+hisi_sas-y+= hisi_sas_init.o hisi_sas_main.o
diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 2c15036..929c513 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -257,4 +257,6 @@ union hisi_sas_command_table {
 	struct hisi_sas_command_table_smp smp;
 	struct hisi_sas_command_table_stp stp;
 };
+
+void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/hisi_sas/hisi_sas_init.c
index 0116782..38b9ed2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_init.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
@@ -131,6 +131,8 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 		goto err_out;
 	memset(hisi_hba->sata_breakpoint, 0, s);
 
+	hisi_sas_slot_index_init(hisi_hba);
+
 	return 0;
 err_out:
 	return -ENOMEM;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
new file mode 100644
index 0000000..721412e
--- /dev/null
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -0,0 +1,28 @@
+/*
+ * Copyright (c) 2015 Linaro Ltd.
+ * Copyright (c) 2015 Hisilicon Limited.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include "hisi_sas.h"
+
+
+static void hisi_sas_slot_index_clear(struct hisi_hba *hisi_hba, int slot_idx)
+{
+	void *bitmap = hisi_hba->slot_index_tags;
+
+	clear_bit(slot_idx, bitmap);
+}
+
+void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
+{
+	int i;
+
+	for (i = 0; i < hisi_hba->slot_index_count; ++i)
+		hisi_sas_slot_index_clear(hisi_hba, i);
+}
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
