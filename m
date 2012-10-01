From: Gwendal Grignou <gwendal@google.com>
Subject: [PATCH 1/3] Revert "ata: make ata port as parent device of scsi host"
Date: Mon,  1 Oct 2012 11:22:54 -0700
Message-ID: <1349115776-17569-2-git-send-email-gwendal@google.com>
References: <20120928062709.GA2091@mint-spring.sh.intel.com>
 <1349115776-17569-1-git-send-email-gwendal@google.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1349115776-17569-1-git-send-email-gwendal@google.com>
In-Reply-To: <50672B03.8000101@mvista.com>
Sender: linux-ide-owner@vger.kernel.org
To: aaron.lu@intel.com, minggr@gmail.com, tj@kernel.org, jgarzik@pobox.com, james.bottomley@hansenpartnership.com
Cc: Gwendal Grignou <gwendal@google.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This reverts commit 9a6d6a2ddabbd32c07f6a38b659e5f3db319fa5a.

Instead, melt libata transport sysfs object in scsi objects.

Signed-off-by: Gwendal Grignou <gwendal@google.com>
---
 drivers/ata/libata-scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e3bda07..be38930 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3609,7 +3609,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		shost->max_host_blocked = 1;
 
 		rc = scsi_add_host_with_dma(ap->scsi_host,
-						&ap->tdev, ap->host->dev);
+					    host->dev, host->dev);
 		if (rc)
 			goto err_add;
 	}
-- 
1.7.7.3

