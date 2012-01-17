From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v4 10/10] libsas: feed the scsi_block_when_processing_errors()
 meter
Date: Mon, 16 Jan 2012 21:11:53 -0800
Message-ID: <20120117051153.22344.92696.stgit@localhost6.localdomain6>
References: <20120117050847.22344.4961.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31535 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab2AQFMD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2012 00:12:03 -0500
In-Reply-To: <20120117050847.22344.4961.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Abraham Carranza <abrahamx.c.carranza@intel.com>

This is called per-sdev but in the sas-transport case this waits for the
entire domain to recover which is never guaranteed to be less than 120
seconds with libata taking nearly a minute per-device to recover.  Ping
the waitqueue so that the hung task timer knows we're still making
progress.

Reported-by: Abraham Carranza <abrahamx.c.carranza@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_ata.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 37a9e73..a062adc 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -663,6 +663,11 @@ static void async_sas_ata_eh(void *data, async_cookie_t cookie)
 
 	ata_port_printk(ap, KERN_DEBUG, "sas eh calling libata port error handler");
 	ata_scsi_port_error_handler(ha->core.shost, ap);
+
+	/* tell scsi_block_when_processing_errors() waiters that we are
+	 * still making forward progress
+	 */
+	wake_up(&ha->core.shost->host_wait);
 }
 
 void sas_ata_strategy_handler(struct Scsi_Host *shost)

