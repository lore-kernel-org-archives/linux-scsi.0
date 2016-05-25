From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 2/2] mpt3sas - avoid mpt3sas_transport_port_add NULL parent_dev
Date: Wed, 25 May 2016 15:14:29 -0400
Message-ID: <1464203669-31974-3-git-send-email-joe.lawrence@stratus.com>
References: <1464203669-31974-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0130.outbound.protection.outlook.com ([207.46.100.130]:28352
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751675AbcEYTOp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2016 15:14:45 -0400
In-Reply-To: <1464203669-31974-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, Joe Lawrence <joe.lawrence@stratus.com>

If _scsih_sas_host_add's call to mpt3sas_config_get_sas_iounit_pg0
fails, ioc->sas_hba.parent_dev may be left uninitialized.  A later
device probe could invoke mpt3sas_transport_port_add which will call
sas_port_alloc_num [scsi_transport_sas] with a NULL parent_dev pointer.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 6a84b82d71bb..ff93286bc32f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -705,6 +705,11 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		goto out_fail;
 	}
 
+	if (!sas_node->parent_dev) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out_fail;
+	}
 	port = sas_port_alloc_num(sas_node->parent_dev);
 	if ((sas_port_add(port))) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
-- 
1.8.3.1

