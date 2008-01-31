From: michaelc@cs.wisc.edu
Subject: [PATCH 07/12] qla4xxx: add qla4xxx async scan support
Date: Thu, 31 Jan 2008 13:36:49 -0600
Message-ID: <12018082174157-git-send-email-michaelc@cs.wisc.edu>
References: <12018082143359-git-send-email-michaelc@cs.wisc.edu>
 <12018082142447-git-send-email-michaelc@cs.wisc.edu>
 <1201808215968-git-send-email-michaelc@cs.wisc.edu>
 <1201808215955-git-send-email-michaelc@cs.wisc.edu>
 <12018082162624-git-send-email-michaelc@cs.wisc.edu>
 <12018082161847-git-send-email-michaelc@cs.wisc.edu>
 <1201808216137-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756856AbYAaThA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 14:37:00 -0500
In-Reply-To: <1201808216137-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

qla4xxx has the old school startup/probe where it finds presetup sessions
in its flash and then attempts to log into them before returning from the
probe. This however, makes it very simple to add a iscsi class scan finished
helper which the driver can use.

In future patches Dave or I will rip apart the driver to make it more
like qla2xxx, but for now this is a very simple two line patch which
fixes the problem of trying to figure out when the initial sessions
are done being scanned.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_os.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d4dd149..c3c59d7 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -89,6 +89,8 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.slave_alloc		= qla4xxx_slave_alloc,
 	.slave_destroy		= qla4xxx_slave_destroy,
 
+	.scan_finished		= iscsi_scan_finished,
+
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
@@ -1306,7 +1308,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	       qla4xxx_version_str, ha->pdev->device, pci_name(ha->pdev),
 	       ha->host_no, ha->firmware_version[0], ha->firmware_version[1],
 	       ha->patch_number, ha->build_number);
-
+	scsi_scan_host(host);
 	return 0;
 
 remove_host:
-- 
1.5.2.1

