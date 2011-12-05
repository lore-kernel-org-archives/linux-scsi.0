From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v5 1/6] ata: make ata port as parent device of scsi host
Date: Mon,  5 Dec 2011 09:20:23 +0800
Message-ID: <1323048028-10421-2-git-send-email-ming.m.lin@intel.com>
References: <1323048028-10421-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1323048028-10421-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

Currently, the device tree of ata port and scsi host looks as below,

        /sys/devices/pci0000:00/0000:00:1f.2    (ahci controller)
        |-- ata1                                (ata port)
        |-- host0                               (scsi host)
           |-- target0:0:0                      (scsi target)
               |-- 0:0:0:0                      (disk)

This patch makes ata port as parent device of scsi host, then it becomes

        /sys/devices/pci0000:00/0000:00:1f.2    (ahci controller)
        |-- ata1                                (ata port)
            |-- host0                           (scsi host)
                |-- target0:0:0                 (scsi target)
                    |-- 0:0:0:0                 (disk)

With this change, the ata port runtime PM is easier.
For example, the ata port runtime suspend will happen as,

disk suspend --> scsi target suspend --> scsi host suspend --> ata port
suspend.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2a5412e..7ae1e77 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3398,7 +3398,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		 */
 		shost->max_host_blocked = 1;
 
-		rc = scsi_add_host(ap->scsi_host, ap->host->dev);
+		rc = scsi_add_host(ap->scsi_host, &ap->tdev);
 		if (rc)
 			goto err_add;
 	}
-- 
1.7.2.5
