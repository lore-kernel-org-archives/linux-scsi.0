From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/17] lpfc 8.3.40: Fix lpfc_used_cpu to be more dynamic
Date: Fri, 31 May 2013 17:03:07 -0400
Message-ID: <1370034187.17258.23.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5769 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab3EaVJn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 17:09:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix lpfc_used_cpu to be more dynamic


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   30 +++++++++++++++++++++++-------
 lpfc_sli4.h |    1 -
 2 files changed, 23 insertions(+), 8 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-05-20 09:31:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-05-31 10:58:00.278057229 -0400
@@ -60,7 +60,8 @@ unsigned long _dump_buf_dif_order;
 spinlock_t _dump_buf_lock;
 
 /* Used when mapping IRQ vectors in a driver centric manner */
-uint16_t lpfc_used_cpu[LPFC_MAX_CPU];
+uint16_t *lpfc_used_cpu;
+uint32_t lpfc_present_cpu;
 
 static void lpfc_get_hba_model_desc(struct lpfc_hba *, uint8_t *, uint8_t *);
 static int lpfc_post_rcv_buf(struct lpfc_hba *);
@@ -5213,6 +5214,21 @@ lpfc_sli4_driver_resource_setup(struct l
 		rc = -ENOMEM;
 		goto out_free_msix;
 	}
+	if (lpfc_used_cpu == NULL) {
+		lpfc_used_cpu = kzalloc((sizeof(uint16_t) * lpfc_present_cpu),
+					 GFP_KERNEL);
+		if (!lpfc_used_cpu) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"3335 Failed allocate memory for msi-x "
+					"interrupt vector mapping\n");
+			kfree(phba->sli4_hba.cpu_map);
+			rc = -ENOMEM;
+			goto out_free_msix;
+		}
+		for (i = 0; i < lpfc_present_cpu; i++)
+			lpfc_used_cpu[i] = LPFC_VECTOR_MAP_EMPTY;
+	}
+
 	/* Initialize io channels for round robin */
 	cpup = phba->sli4_hba.cpu_map;
 	rc = 0;
@@ -6824,8 +6840,6 @@ lpfc_sli4_queue_verify(struct lpfc_hba *
 	int cfg_fcp_io_channel;
 	uint32_t cpu;
 	uint32_t i = 0;
-	uint32_t j = 0;
-
 
 	/*
 	 * Sanity check for configured queue parameters against the run-time
@@ -6839,10 +6853,9 @@ lpfc_sli4_queue_verify(struct lpfc_hba *
 	for_each_present_cpu(cpu) {
 		if (cpu_online(cpu))
 			i++;
-		j++;
 	}
 	phba->sli4_hba.num_online_cpu = i;
-	phba->sli4_hba.num_present_cpu = j;
+	phba->sli4_hba.num_present_cpu = lpfc_present_cpu;
 
 	if (i < cfg_fcp_io_channel) {
 		lpfc_printf_log(phba,
@@ -10967,8 +10980,10 @@ lpfc_init(void)
 	}
 
 	/* Initialize in case vector mapping is needed */
-	for (cpu = 0; cpu < LPFC_MAX_CPU; cpu++)
-		lpfc_used_cpu[cpu] = LPFC_VECTOR_MAP_EMPTY;
+	lpfc_used_cpu = NULL;
+	lpfc_present_cpu = 0;
+	for_each_present_cpu(cpu)
+		lpfc_present_cpu++;
 
 	error = pci_register_driver(&lpfc_driver);
 	if (error) {
@@ -11008,6 +11023,7 @@ lpfc_exit(void)
 				(1L << _dump_buf_dif_order), _dump_buf_dif);
 		free_pages((unsigned long)_dump_buf_dif, _dump_buf_dif_order);
 	}
+	kfree(lpfc_used_cpu);
 }
 
 module_init(lpfc_init);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2013-05-03 09:24:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2013-05-31 10:58:00.283057229 -0400
@@ -444,7 +444,6 @@ struct lpfc_vector_map_info {
 	struct cpumask	maskbits;
 };
 #define LPFC_VECTOR_MAP_EMPTY	0xffff
-#define LPFC_MAX_CPU		256
 
 /* SLI4 HBA data structure entries */
 struct lpfc_sli4_hba {



