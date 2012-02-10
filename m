From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v9 0/3] libsas error handling + discovery v9
Date: Fri, 10 Feb 2012 13:52:56 -0800
Message-ID: <20120210215220.17007.80540.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Changes since v8: http://marc.info/?l=linux-scsi&m=132886259501191&w=2

Noticed that the rebased version of "libsas: close scsi_remove_target()
vs libata-eh race" mistakenly dropped a necessary call to
sas_put_device().

...reflowed the other two patches as a result, and added Jeff Garzik's
acked-by:

[PATCH 1/3] libsas: close scsi_remove_target() vs libata-eh race
[PATCH 2/3] libsas: improve debug statements
[PATCH 3/3] libsas: async ata scanning

Incremental diff from v8:

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 1b1d4b7..bc0cecc 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -715,6 +715,7 @@ static void async_sas_ata_eh(void *data, async_cookie_t cookie)
 	kref_get(&dev->kref);
 	sas_ata_printk(KERN_DEBUG, dev, "dev error handler\n");
 	ata_scsi_port_error_handler(ha->core.shost, ap);
+	sas_put_device(dev);
 }
 
 static bool sas_ata_dev_eh_valid(struct domain_device *dev)
