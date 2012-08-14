From: James Smart <james.smart@emulex.com>
Subject: [PATCH 03/12] lpfc 8.3.34: Fix number of IO channels to match CPUs
Date: Tue, 14 Aug 2012 14:25:36 -0400
Message-ID: <1344968736.4432.18.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24929 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2HNS0A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2012 14:26:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix number of IO channels to match CPUs


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-08-11 12:24:51.636924276 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-08-11 12:24:51.775924271 -0400
@@ -6542,6 +6542,9 @@ static int
 lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 {
 	int cfg_fcp_io_channel;
+	uint32_t cpu;
+	uint32_t i = 0;
+
 
 	/*
 	 * Sanity check for configured queue parameters against the run-time
@@ -6551,6 +6554,17 @@ lpfc_sli4_queue_verify(struct lpfc_hba *
 	/* Sanity check on HBA EQ parameters */
 	cfg_fcp_io_channel = phba->cfg_fcp_io_channel;
 
+	/* It doesn't make sense to have more io channels then CPUs */
+	for_each_online_cpu(cpu) {
+		i++;
+	}
+	if (i < cfg_fcp_io_channel) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"3188 Reducing IO channels to match number of "
+				"CPUs: from %d to %d\n", cfg_fcp_io_channel, i);
+		cfg_fcp_io_channel = i;
+	}
+
 	if (cfg_fcp_io_channel >
 	    phba->sli4_hba.max_cfg_param.max_eq) {
 		cfg_fcp_io_channel = phba->sli4_hba.max_cfg_param.max_eq;



