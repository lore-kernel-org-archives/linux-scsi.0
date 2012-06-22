From: Dan Williams <dan.j.williams@intel.com>
Subject: [set2 PATCH 4/4] isci: use sas eh strategy handlers
Date: Thu, 21 Jun 2012 23:31:04 -0700
Message-ID: <20120622063104.21248.33183.stgit@dwillia2-linux.jf.intel.com>
References: <20120622063043.21248.12701.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23317 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761324Ab2FVGOZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jun 2012 02:14:25 -0400
In-Reply-To: <20120622063043.21248.12701.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

...now that the strategy handlers guarantee eh context and notify
the driver of bus reset.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/init.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 47e28b5..92c1d86 100644
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

