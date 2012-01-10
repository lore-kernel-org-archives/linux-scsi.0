From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v4 2/2] libsas: feed the scsi_block_when_processing_errors()
 meter
Date: Mon, 09 Jan 2012 23:38:36 -0800
Message-ID: <20120110073836.4563.85860.stgit@localhost6.localdomain6>
References: <20120110073647.4563.7504.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64286 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab2AJHih (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2012 02:38:37 -0500
In-Reply-To: <20120110073647.4563.7504.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Abraham Carranza <abrahamx.c.carranza@intel.com>, jack_wang@usish.com

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

