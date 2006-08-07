From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH -mm] libsas: externs not needed
Date: Mon, 7 Aug 2006 11:38:25 -0700
Message-ID: <20060807113825.518488f6.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:26550 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S932302AbWHGSfr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2006 14:35:47 -0400
Received: from midway.site ([71.117.253.75]) by xenotime.net for <linux-scsi@vger.kernel.org>; Mon, 7 Aug 2006 11:35:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>

From: Randy Dunlap <rdunlap@xenotime.net>

These functions shouldn't be 'extern'.  That's not needed for
exports in Linux.  Also, sparse complains, so fix them.

drivers/scsi/libsas/sas_init.c:138:39: warning: function 'sas_domain_attach_transport' with external linkage has definition
drivers/scsi/libsas/sas_init.c:158:13: warning: function 'sas_domain_release_transport' with external linkage has definitio

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/libsas/sas_init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2618-rc3mm2.orig/drivers/scsi/libsas/sas_init.c
+++ linux-2618-rc3mm2/drivers/scsi/libsas/sas_init.c
@@ -135,7 +135,7 @@ int sas_unregister_ha(struct sas_ha_stru
 static struct sas_function_template sft = {
 };
 
-extern struct scsi_transport_template *
+struct scsi_transport_template *
 sas_domain_attach_transport(struct sas_domain_function_template *dft)
 {
 	struct scsi_transport_template *stt = sas_attach_transport(&sft);
@@ -155,7 +155,7 @@ sas_domain_attach_transport(struct sas_d
 EXPORT_SYMBOL_GPL(sas_domain_attach_transport);
 
 
-extern void sas_domain_release_transport(struct scsi_transport_template *stt)
+void sas_domain_release_transport(struct scsi_transport_template *stt)
 {
 	sas_release_transport(stt);
 }


---
