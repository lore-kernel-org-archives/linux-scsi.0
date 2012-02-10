From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v8 12/13] isci: use sas eh strategy handlers
Date: Fri, 10 Feb 2012 00:45:40 -0800
Message-ID: <20120210084540.25701.38927.stgit@dwillia2-linux.jf.intel.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

...now that the strategy handlers guarantee eh context and and notify
the driver of bus reset.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/init.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 9a28270..87ac0f6 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -157,6 +157,9 @@ static struct scsi_host_template isci_sht = {
 	.sg_tablesize			= SG_ALL,
 	.max_sectors			= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering			= ENABLE_CLUSTERING,
+	.eh_abort_handler		= sas_eh_abort_handler,
+	.eh_device_reset_handler        = sas_eh_device_reset_handler,
+	.eh_bus_reset_handler           = sas_eh_bus_reset_handler,
 	.target_destroy			= sas_target_destroy,
 	.ioctl				= sas_ioctl,
 	.shost_attrs			= isci_host_attrs,

