From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] scsi: switch to scsi-mq by default
Date: Wed,  4 Jul 2018 10:53:56 +0200
Message-ID: <20180704085356.10888-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Ming Lei <tom.leiming@gmail.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

It has been more than one year since we tried to change the default
from legacy to multi queue in SCSI with commit c279bd9e406 ("scsi:
default to scsi-mq"). But due to issues with suspend/resume and
performance problems it had been reverted again with commit
cbe7dfa26eee ("Revert "scsi: default to scsi-mq"").

In the meantime there have been a substantial amount of performance
improvements and suspend/resume got fixed as well, thus we can
re-enable scsi-mq without a significant performance penalty.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Acked-by: John Garry <john.garry@huawei.com>

---
Changes since RFC:
- Improve Changelog as Bart suggested
- Collect Acks and Reviews
---
 drivers/scsi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 35c909bbf8ba..bd115bab162e 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -49,6 +49,7 @@ config SCSI_NETLINK
 
 config SCSI_MQ_DEFAULT
 	bool "SCSI: use blk-mq I/O path by default"
+	default y
 	depends on SCSI
 	---help---
 	  This option enables the new blk-mq based I/O path for SCSI
-- 
2.16.4
