From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 010/103] target: Remove pscsi_get_sh() in _pscsi.c
Date: Thu, 21 Jul 2011 00:04:46 -0700
Message-ID: <1311231979-6631-11-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm4-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.129]:24475 "HELO
	nm4-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751865Ab1GUHAP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:00:15 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Andy Grover <agrover@redhat.com>

It only wrapped scsi_host_lookup, which can just be used directly
without too much trouble.

(nab: Fix pdv_host_id usage)

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c |   30 ++++++------------------------
 1 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index fb2e8cb..d39226f 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -55,24 +55,6 @@ static struct se_subsystem_api pscsi_template;
 
 static void pscsi_req_done(struct request *, int);
 
-/*	pscsi_get_sh():
- *
- *
- */
-static struct Scsi_Host *pscsi_get_sh(u32 host_no)
-{
-	struct Scsi_Host *sh = NULL;
-
-	sh = scsi_host_lookup(host_no);
-	if (IS_ERR(sh)) {
-		printk(KERN_ERR "Unable to locate SCSI HBA with Host ID:"
-				" %u\n", host_no);
-		return NULL;
-	}
-
-	return sh;
-}
-
 /*	pscsi_attach_hba():
  *
  * 	pscsi_get_sh() used scsi_host_lookup() to locate struct Scsi_Host.
@@ -154,11 +136,11 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 	 * Otherwise, locate struct Scsi_Host from the original passed
 	 * pSCSI Host ID and enable for phba mode
 	 */
-	sh = pscsi_get_sh(phv->phv_host_id);
-	if (!(sh)) {
+	sh = scsi_host_lookup(phv->phv_host_id);
+	if (IS_ERR(sh)) {
 		printk(KERN_ERR "pSCSI: Unable to locate SCSI Host for"
 			" phv_host_id: %d\n", phv->phv_host_id);
-		return -1;
+		return PTR_ERR(sh);
 	}
 	/*
 	 * Usually the SCSI LLD will use the hostt->can_queue value to define
@@ -601,11 +583,11 @@ static struct se_device *pscsi_create_virtdevice(
 			hba->hba_flags |= HBA_FLAGS_PSCSI_MODE;
 			sh = phv->phv_lld_host;
 		} else {
-			sh = pscsi_get_sh(pdv->pdv_host_id);
-			if (!(sh)) {
+			sh = scsi_host_lookup(pdv->pdv_host_id);
+			if (IS_ERR(sh)) {
 				printk(KERN_ERR "pSCSI: Unable to locate"
 					" pdv_host_id: %d\n", pdv->pdv_host_id);
-				return ERR_PTR(-ENODEV);
+				return (struct se_device *) sh;
 			}
 		}
 	} else {
-- 
1.7.6

