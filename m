From: andrew.vasquez@qlogic.com
Subject: [PATCH 5/6] qla2xxx: Return correct data-len during NVRAM retrieval.
Date: Tue, 31 Jan 2006 16:05:12 -0800
Message-ID: <11387523071881-git-send-email-andrew.vasquez@qlogic.com>
References: <20060201000146.GA4456@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:43203 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751137AbWBAAFM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 19:05:12 -0500
In-Reply-To: <20060201000146.GA4456@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.vasquez@qlogic.com

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_attr.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

672783056a0d38d7336a22a9833875d2f02fd1dc
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 049e5cf..73d10b3 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -113,7 +113,7 @@ qla2x00_sysfs_read_nvram(struct kobject 
 	    struct device, kobj)));
 	unsigned long	flags;
 
-	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->nvram_size)
+	if (!capable(CAP_SYS_ADMIN) || off != 0)
 		return 0;
 
 	/* Read NVRAM. */
@@ -122,7 +122,7 @@ qla2x00_sysfs_read_nvram(struct kobject 
 	    ha->nvram_size);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	return (count);
+	return ha->nvram_size;
 }
 
 static ssize_t
@@ -174,7 +174,7 @@ static struct bin_attribute sysfs_nvram_
 		.mode = S_IRUSR | S_IWUSR,
 		.owner = THIS_MODULE,
 	},
-	.size = 0,
+	.size = 512,
 	.read = qla2x00_sysfs_read_nvram,
 	.write = qla2x00_sysfs_write_nvram,
 };
@@ -185,7 +185,6 @@ qla2x00_alloc_sysfs_attr(scsi_qla_host_t
 	struct Scsi_Host *host = ha->host;
 
 	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_fw_dump_attr);
-	sysfs_nvram_attr.size = ha->nvram_size;
 	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_nvram_attr);
 }
 
-- 
1.1.6.g1506


