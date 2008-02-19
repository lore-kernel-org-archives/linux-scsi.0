From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 1/2] libsas: Provide a transport-level facility to request
	SAS addrs
Date: Tue, 19 Feb 2008 10:49:40 -0800
Message-ID: <20080219184939.GB5414@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50136 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460AbYBSSto (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 13:49:44 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1JInfrX028079
	for <linux-scsi@vger.kernel.org>; Tue, 19 Feb 2008 13:49:41 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1JInfUW240094
	for <linux-scsi@vger.kernel.org>; Tue, 19 Feb 2008 13:49:41 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1JIneei020445
	for <linux-scsi@vger.kernel.org>; Tue, 19 Feb 2008 13:49:41 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

Provide a facility to use the request_firmware() interface to get a SAS
address from userspace.  This can be used by SAS LLDDs that cannot
obtain the address from the host adapter.

Resend of 8 Oct. 2007 patch, now based off 2.6.25-rc2 + scsi_misc.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_scsi_host.c |   41 +++++++++++++++++++++++++++++++++++
 include/scsi/libsas.h               |    2 ++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index f869fba..583d249 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -24,6 +24,8 @@
  */
 
 #include <linux/kthread.h>
+#include <linux/firmware.h>
+#include <linux/ctype.h>
 
 #include "sas_internal.h"
 
@@ -1050,6 +1052,45 @@ void sas_target_destroy(struct scsi_target *starget)
 	return;
 }
 
+static void sas_parse_addr(u8 *sas_addr, const char *p)
+{
+	int i;
+	for (i = 0; i < SAS_ADDR_SIZE; i++) {
+		u8 h, l;
+		if (!*p)
+			break;
+		h = isdigit(*p) ? *p-'0' : toupper(*p)-'A'+10;
+		p++;
+		l = isdigit(*p) ? *p-'0' : toupper(*p)-'A'+10;
+		p++;
+		sas_addr[i] = (h<<4) | l;
+	}
+}
+
+#define SAS_STRING_ADDR_SIZE	16
+
+int sas_request_addr(struct Scsi_Host *shost, u8 *addr)
+{
+	int res;
+	const struct firmware *fw;
+
+	res = request_firmware(&fw, "sas_addr", &shost->shost_gendev);
+	if (res)
+		return res;
+
+	if (fw->size < SAS_STRING_ADDR_SIZE) {
+		res = -ENODEV;
+		goto out;
+	}
+
+	sas_parse_addr(addr, fw->data);
+
+out:
+	release_firmware(fw);
+	return res;
+}
+EXPORT_SYMBOL_GPL(sas_request_addr);
+
 EXPORT_SYMBOL_GPL(sas_queuecommand);
 EXPORT_SYMBOL_GPL(sas_target_alloc);
 EXPORT_SYMBOL_GPL(sas_slave_configure);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 3ffd6b5..5f183de 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -676,4 +676,6 @@ extern int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 extern void sas_ssp_task_response(struct device *dev, struct sas_task *task,
 				  struct ssp_response_iu *iu);
 
+int sas_request_addr(struct Scsi_Host *shost, u8 *addr);
+
 #endif /* _SASLIB_H_ */
