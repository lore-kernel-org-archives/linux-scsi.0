From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] scsi: Remove null check before kfree
Date: Mon,  6 Nov 2017 19:57:23 +0530
Message-ID: <1509978443-9853-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.com
Cc: jejb@linux.vnet.ibm.com, james.smart@broadcom.com, dick.kennedy@broadcom.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, QLogic-Storage-Upstream@cavium.com, qla2xxx-upstream@qlogic.com, jthumshirn@suse.de, bart.vanassche@wdc.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, megaraidlinux.pdl@broadcom.com, Himanshu Jha <himanshujha199640@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Kfree on NULL pointer is a no-op and therefore checking is redundant.

Done using Coccinelle.
Semantic patch used :

@@ expression E; @@
- if (E != NULL) { kfree(E); }
+ kfree(E);
@@ expression E; @@
- if (E != NULL) { kfree(E); E = NULL; }
+ kfree(E);
+ E = NULL;


Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c         | 15 +++++----------
 drivers/scsi/aic7xxx/aic7xxx_core.c         | 15 +++++----------
 drivers/scsi/aic94xx/aic94xx_init.c         |  9 +++------
 drivers/scsi/lpfc/lpfc_bsg.c                |  3 +--
 drivers/scsi/lpfc/lpfc_init.c               |  6 ++----
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  3 +--
 drivers/scsi/qedf/qedf_main.c               |  3 +--
 drivers/scsi/qla2xxx/qla_os.c               | 12 ++++--------
 8 files changed, 22 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index b560f39..7ad1df5 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -3681,8 +3681,7 @@ ahd_free_tstate(struct ahd_softc *ahd, u_int scsi_id, char channel, int force)
 		return;
 
 	tstate = ahd->enabled_targets[scsi_id];
-	if (tstate != NULL)
-		kfree(tstate);
+	kfree(tstate);
 	ahd->enabled_targets[scsi_id] = NULL;
 }
 #endif
@@ -6144,8 +6143,7 @@ ahd_set_unit(struct ahd_softc *ahd, int unit)
 void
 ahd_set_name(struct ahd_softc *ahd, char *name)
 {
-	if (ahd->name != NULL)
-		kfree(ahd->name);
+	kfree(ahd->name);
 	ahd->name = name;
 }
 
@@ -6212,12 +6210,9 @@ ahd_free(struct ahd_softc *ahd)
 		kfree(ahd->black_hole);
 	}
 #endif
-	if (ahd->name != NULL)
-		kfree(ahd->name);
-	if (ahd->seep_config != NULL)
-		kfree(ahd->seep_config);
-	if (ahd->saved_stack != NULL)
-		kfree(ahd->saved_stack);
+	kfree(ahd->name);
+	kfree(ahd->seep_config);
+	kfree(ahd->saved_stack);
 #ifndef __FreeBSD__
 	kfree(ahd);
 #endif
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 6612ff3..9c46c6d 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -2200,8 +2200,7 @@ ahc_free_tstate(struct ahc_softc *ahc, u_int scsi_id, char channel, int force)
 	if (channel == 'B')
 		scsi_id += 8;
 	tstate = ahc->enabled_targets[scsi_id];
-	if (tstate != NULL)
-		kfree(tstate);
+	kfree(tstate);
 	ahc->enabled_targets[scsi_id] = NULL;
 }
 #endif
@@ -4481,8 +4480,7 @@ ahc_set_unit(struct ahc_softc *ahc, int unit)
 void
 ahc_set_name(struct ahc_softc *ahc, char *name)
 {
-	if (ahc->name != NULL)
-		kfree(ahc->name);
+	kfree(ahc->name);
 	ahc->name = name;
 }
 
@@ -4549,10 +4547,8 @@ ahc_free(struct ahc_softc *ahc)
 		kfree(ahc->black_hole);
 	}
 #endif
-	if (ahc->name != NULL)
-		kfree(ahc->name);
-	if (ahc->seep_config != NULL)
-		kfree(ahc->seep_config);
+	kfree(ahc->name);
+	kfree(ahc->seep_config);
 #ifndef __FreeBSD__
 	kfree(ahc);
 #endif
@@ -4957,8 +4953,7 @@ ahc_fini_scbdata(struct ahc_softc *ahc)
 	case 0:
 		break;
 	}
-	if (scb_data->scbarray != NULL)
-		kfree(scb_data->scbarray);
+	kfree(scb_data->scbarray);
 }
 
 static void
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 6c83886..778df1a 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -584,8 +584,7 @@ static void asd_destroy_ha_caches(struct asd_ha_struct *asd_ha)
 	if (asd_ha->hw_prof.scb_ext)
 		asd_free_coherent(asd_ha, asd_ha->hw_prof.scb_ext);
 
-	if (asd_ha->hw_prof.ddb_bitmap)
-		kfree(asd_ha->hw_prof.ddb_bitmap);
+	kfree(asd_ha->hw_prof.ddb_bitmap);
 	asd_ha->hw_prof.ddb_bitmap = NULL;
 
 	for (i = 0; i < ASD_MAX_PHYS; i++) {
@@ -597,10 +596,8 @@ static void asd_destroy_ha_caches(struct asd_ha_struct *asd_ha)
 		asd_free_escbs(asd_ha);
 	if (asd_ha->seq.edb_arr)
 		asd_free_edbs(asd_ha);
-	if (asd_ha->hw_prof.ue.area) {
-		kfree(asd_ha->hw_prof.ue.area);
-		asd_ha->hw_prof.ue.area = NULL;
-	}
+	kfree(asd_ha->hw_prof.ue.area);
+	asd_ha->hw_prof.ue.area = NULL;
 	if (asd_ha->seq.tc_index_array) {
 		kfree(asd_ha->seq.tc_index_array);
 		kfree(asd_ha->seq.tc_index_bitmap);
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index d898162..3860df0 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1275,8 +1275,7 @@ lpfc_bsg_hba_set_event(struct bsg_job *job)
 	return 0; /* call job done later */
 
 job_error:
-	if (dd_data != NULL)
-		kfree(dd_data);
+	kfree(dd_data);
 
 	job->dd_data = NULL;
 	return rc;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 2b7ea7e..1bb9dbc 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8388,10 +8388,8 @@ lpfc_sli4_release_queues(struct lpfc_queue ***qs, int max)
 static inline void
 lpfc_sli4_release_queue_map(uint16_t **qmap)
 {
-	if (*qmap != NULL) {
-		kfree(*qmap);
-		*qmap = NULL;
-	}
+	kfree(*qmap);
+	*qmap = NULL;
 }
 
 /**
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 65dc4fe..ec50986 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1642,8 +1642,7 @@ static inline void megasas_free_ioc_init_cmd(struct megasas_instance *instance)
 				  fusion->ioc_init_cmd->frame,
 				  fusion->ioc_init_cmd->frame_phys_addr);
 
-	if (fusion->ioc_init_cmd)
-		kfree(fusion->ioc_init_cmd);
+	kfree(fusion->ioc_init_cmd);
 }
 
 /**
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 7c00645..5316cba 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2884,8 +2884,7 @@ static void qedf_free_fcoe_pf_param(struct qedf_ctx *qedf)
 
 	qedf_free_global_queues(qedf);
 
-	if (qedf->global_queues)
-		kfree(qedf->global_queues);
+	kfree(qedf->global_queues);
 }
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1865743..2b5b0fc 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -506,14 +506,10 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	int cnt;
 	unsigned long flags;
 
-	if (ha->queue_pair_map) {
-		kfree(ha->queue_pair_map);
-		ha->queue_pair_map = NULL;
-	}
-	if (ha->base_qpair) {
-		kfree(ha->base_qpair);
-		ha->base_qpair = NULL;
-	}
+	kfree(ha->queue_pair_map);
+	ha->queue_pair_map = NULL;
+	kfree(ha->base_qpair);
+	ha->base_qpair = NULL;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (cnt = 0; cnt < ha->max_req_queues; cnt++) {
-- 
2.7.4
