From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 13/16] qla2xxx: Remove bad call to fc_remove_host() during probe failure.
Date: Fri, 26 Aug 2005 19:10:00 -0700 (PDT)
Message-ID: <20050827021000.27275.98025.sendpatchset@plap.qlogic.com>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:32616 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751623AbVH0CKB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:10:01 -0400
In-Reply-To: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Remove bad call to fc_remove_host() during probe failure.

fc_remove_host() should only be called after a scsi_host has
been successfully added via scsi_add_host() -- any failures
while qla2xxx probing would result in an incorrect call to
fc_remove_host() during cleanup.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_os.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

a4fe148ca8c724f44cab281c162043d3ca81c60c
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1586,8 +1586,6 @@ int qla2x00_probe_one(struct pci_dev *pd
 	return 0;
 
 probe_failed:
-	fc_remove_host(ha->host);
-
 	qla2x00_free_device(ha);
 
 	scsi_host_put(host);

-- 
Andrew Vasquez
