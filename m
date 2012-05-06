From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 15/18] libsas: drop sata port multiplier infrastructure
Date: Sun, 06 May 2012 11:19:13 -0700
Message-ID: <20120506181913.17912.85698.stgit@dwillia2-linux.jf.intel.com>
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

On the way to add a new sata_device field, noticed that libsas is
carrying port multiplier infrastructure that is explicitly disabled by
sas_discover_sata().  The aic94xx touches the unused port_no, so leave
that field in case there was some use for it.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_discover.c |    6 ------
 include/scsi/libsas.h              |    1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index b031d23..3e9dc1a 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -46,12 +46,6 @@ void sas_init_dev(struct domain_device *dev)
 		INIT_LIST_HEAD(&dev->ex_dev.children);
 		mutex_init(&dev->ex_dev.cmd_mutex);
 		break;
-	case SATA_DEV:
-	case SATA_PM:
-	case SATA_PM_PORT:
-	case SATA_PENDING:
-		INIT_LIST_HEAD(&dev->sata_dev.children);
-		break;
 	default:
 		break;
 	}
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 996ee7c..066c0ff 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -167,7 +167,6 @@ struct sata_device {
         enum   ata_command_set command_set;
         struct smp_resp        rps_resp; /* report_phy_sata_resp */
         u8     port_no;        /* port number, if this is a PM (Port) */
-        struct list_head children; /* PM Ports if this is a PM */
 
 	struct ata_port *ap;
 	struct ata_host ata_host;

