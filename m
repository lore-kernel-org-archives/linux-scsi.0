From: chenxiang <chenxiang66@hisilicon.com>
Subject: [PATCH] scsi: ata: don't reset three times if device is offline for SAS host
Date: Wed, 24 Jan 2018 21:20:25 +0800
Message-ID: <1516800025-193614-1-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4692 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933397AbeAXM2K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Jan 2018 07:28:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linuxarm@huawei.com, chenxiang <chenxiang66@hisilicon.com>

In ata_eh_reset, it will reset three times at most for sata disk. For
some drivers through libsas, it calls sas_ata_hard_reset at last. When
device is gone, function sas_ata_hard_reset will return -ENODEV. But
it will still try to reset three times for offline device. This process
lasts a long time:

[11248.344323] ata13.00: status: { ERR }
[11248.344324] ata13.00: error: { ABRT }
[11248.344327] ata13: hard resetting link
[11248.503557] sas: ata: ex 500e004aaaaaaa1f phy02:U:A attached:0000000000000000 (no device)
[11249.359524] sas: ata13: end_device-1:0:2: reset failed (errno=-19)[eta03d:19h:35m:17s]
[11249.365692] ata13: reset failed (errno=-19), retrying in 9 secs
[11258.451402] ata13: hard resetting linkKB/0KB/0KB /s] [0/0/0 iops][eta 03d:22h:10m:48s]
[11259.411508] sas: ata13: end_device-1:0:2: reset failed (errno=-19)[eta 03d:22h:28m:05s]
[11259.417683] ata13: reset failed (errno=-19), retrying in 10 secs
[11268.695401] ata13: hard resetting linkKB/0KB/0KB /s] [0/0/0 iops] [eta 04d:01h:03m:37s]
[11269.699513] sas: ata13: end_device-1:0:2: reset failed (errno=-19)[eta 04d:01h:20m:54s]
[11269.705689] ata13: reset failed (errno=-19), retrying in 34 secs
[11304.275393] ata13: hard resetting linkKB/0KB/0KB /s] [0/0/0 iops] [eta 04d:11h:25m:43s]
[11305.283516] sas: ata13: end_device-1:0:2: reset failed (errno=-19)[eta 04d:11h:43m:00s]
[11305.289692] ata13: reset failed, giving up
[11305.293785] ata13.00: disabled

Actually it is no need to reset three times for this scenario. So add
a check to avoid it.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/ata/libata-eh.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 11c3137..23a8946 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3032,6 +3032,15 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		goto out;
 	}
 
+	if (rc == -ENODEV && ap->flags & ATA_FLAG_SAS_HOST) {
+		ata_link_warn(failed_link,
+			"reset failed (errno=%d, device is offline for SAS host\n)",
+			rc);
+		if (ata_is_host_link(link))
+			ata_eh_thaw_port(ap);
+		goto out;
+	}
+
 	now = jiffies;
 	if (time_before(now, deadline)) {
 		unsigned long delta = deadline - now;
-- 
1.9.1
