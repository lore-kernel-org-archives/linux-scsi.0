From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 08/18] isci: use sas eh strategy handlers
Date: Sun, 06 May 2012 11:18:38 -0700
Message-ID: <20120506181838.17912.44708.stgit@dwillia2-linux.jf.intel.com>
References: <20120506181611.17912.3798.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120506181611.17912.3798.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

...now that the strategy handlers guarantee eh context and notify
the driver of bus reset.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/init.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 5137db5..a98280d 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -166,6 +166,9 @@ static struct scsi_host_template isci_sht = {
 	.sg_tablesize			= SG_ALL,
 	.max_sectors			= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering			= ENABLE_CLUSTERING,
+	.eh_abort_handler		= sas_eh_abort_handler,
+	.eh_device_reset_handler        = sas_eh_device_reset_handler,
+	.eh_bus_reset_handler           = sas_eh_bus_reset_handler,
 	.target_destroy			= sas_target_destroy,
 	.ioctl				= sas_ioctl,
 	.shost_attrs			= isci_host_attrs,

