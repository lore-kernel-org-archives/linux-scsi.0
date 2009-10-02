From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 3/6] lpfc 8.3.5: MIsc patch set part 3
Date: Fri, 2 Oct 2009 15:16:51 -0400
Message-ID: <1254511011.32739.21.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63995 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123AbZJBT7A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2009 15:59:00 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n92Jx4N6026954
	for <linux-scsi@vger.kernel.org>; Fri, 2 Oct 2009 12:59:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


This patch include the following fixes and changes:
- Fix crash when "error" is echoed to board_mode sysfs parameter
- Fix FCoE Parameter parsing in regions 23
- Fix driver crash when creating vport with large number of targets on SLI4
- Fix bug with npiv message being logged when it is not supported by the adapter
- Fix a potential dereferencing mailbox structure after free bug
- Fix firmware crash after vport create with high target count
- Error out requests to set board_mode to warm restart via sysfs on SLI4 HBAs
- Fix Block guard logging
- Fix a memory corruption issue during GID_FT IO prep
- Fix crash while processing unsolicited FC frames
- Fix failed to allocate XRI message is not a critical failure
- Update and fix formatting in some log messages
- Fix missing new line characters in log messages
- Removed the use of the locally defined FC transport layer related macros
- Check the rsplen in lpfc_handle_fcp_err function before using rsplen


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c    |   15 +++-
 lpfc_bsg.c     |    5 -
 lpfc_ct.c      |   19 ++++--
 lpfc_debugfs.c |   10 +--
 lpfc_disc.h    |    2 
 lpfc_hbadisc.c |   13 ++--
 lpfc_hw.h      |   15 ----
 lpfc_init.c    |   54 +++++++++--------
 lpfc_mbox.c    |   11 ++-
 lpfc_scsi.c    |  180 +++++++++++++++++++++++++++++++++------------------------
 lpfc_sli.c     |   85 +++++++++-----------------
 lpfc_sli4.h    |    2 
 12 files changed, 214 insertions(+), 197 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2009-10-01 17:20:05.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2009-10-01 17:21:21.000000000 -0400
@@ -29,6 +29,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/fc/fc_fs.h>
 
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
@@ -762,9 +763,15 @@ lpfc_board_mode_store(struct device *dev
 	} else if (strncmp(buf, "offline", sizeof("offline") - 1) == 0)
 		status = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
 	else if (strncmp(buf, "warm", sizeof("warm") - 1) == 0)
-		status = lpfc_do_offline(phba, LPFC_EVT_WARM_START);
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			return -EINVAL;
+		else
+			status = lpfc_do_offline(phba, LPFC_EVT_WARM_START);
 	else if (strncmp(buf, "error", sizeof("error") - 1) == 0)
-		status = lpfc_do_offline(phba, LPFC_EVT_KILL);
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			return -EINVAL;
+		else
+			status = lpfc_do_offline(phba, LPFC_EVT_KILL);
 	else
 		return -EINVAL;
 
@@ -2846,7 +2853,7 @@ LPFC_ATTR_R(multi_ring_support, 1, 1, 2,
 # identifies what rctl value to configure the additional ring for.
 # Value range is [1,0xff]. Default value is 4 (Unsolicated Data).
 */
-LPFC_ATTR_R(multi_ring_rctl, FC_UNSOL_DATA, 1,
+LPFC_ATTR_R(multi_ring_rctl, FC_RCTL_DD_UNSOL_DATA, 1,
 	     255, "Identifies RCTL for additional ring configuration");
 
 /*
@@ -2854,7 +2861,7 @@ LPFC_ATTR_R(multi_ring_rctl, FC_UNSOL_DA
 # identifies what type value to configure the additional ring for.
 # Value range is [1,0xff]. Default value is 5 (LLC/SNAP).
 */
-LPFC_ATTR_R(multi_ring_type, FC_LLC_SNAP, 1,
+LPFC_ATTR_R(multi_ring_type, FC_TYPE_IP, 1,
 	     255, "Identifies TYPE for additional ring configuration");
 
 /*
diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2009-08-03 11:05:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2009-10-01 17:21:21.000000000 -0400
@@ -26,6 +26,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi_bsg_fc.h>
+#include <scsi/fc/fc_fs.h>
 
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
@@ -148,8 +149,8 @@ lpfc_bsg_rport_ct(struct fc_bsg_job *job
 	cmd->ulpCommand = CMD_GEN_REQUEST64_CR;
 	cmd->un.genreq64.w5.hcsw.Fctl = (SI | LA);
 	cmd->un.genreq64.w5.hcsw.Dfctl = 0;
-	cmd->un.genreq64.w5.hcsw.Rctl = FC_UNSOL_CTL;
-	cmd->un.genreq64.w5.hcsw.Type = FC_COMMON_TRANSPORT_ULP;
+	cmd->un.genreq64.w5.hcsw.Rctl = FC_RCTL_DD_UNSOL_CTL;
+	cmd->un.genreq64.w5.hcsw.Type = FC_TYPE_CT;
 	cmd->ulpBdeCount = 1;
 	cmd->ulpLe = 1;
 	cmd->ulpClass = CLASS3;
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2009-10-01 17:20:57.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2009-10-01 17:21:21.000000000 -0400
@@ -31,6 +31,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/fc/fc_fs.h>
 
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
@@ -336,8 +337,8 @@ lpfc_gen_req(struct lpfc_vport *vport, s
 	/* Fill in rest of iocb */
 	icmd->un.genreq64.w5.hcsw.Fctl = (SI | LA);
 	icmd->un.genreq64.w5.hcsw.Dfctl = 0;
-	icmd->un.genreq64.w5.hcsw.Rctl = FC_UNSOL_CTL;
-	icmd->un.genreq64.w5.hcsw.Type = FC_COMMON_TRANSPORT_ULP;
+	icmd->un.genreq64.w5.hcsw.Rctl = FC_RCTL_DD_UNSOL_CTL;
+	icmd->un.genreq64.w5.hcsw.Type = FC_TYPE_CT;
 
 	if (!tmo) {
 		 /* FC spec states we need 3 * ratov for CT requests */
@@ -395,9 +396,14 @@ lpfc_ct_cmd(struct lpfc_vport *vport, st
 	outmp = lpfc_alloc_ct_rsp(phba, cmdcode, bpl, rsp_size, &cnt);
 	if (!outmp)
 		return -ENOMEM;
-
+	/*
+	 * Form the CT IOCB.  The total number of BDEs in this IOCB
+	 * is the single command plus response count from
+	 * lpfc_alloc_ct_rsp.
+	 */
+	cnt += 1;
 	status = lpfc_gen_req(vport, bmp, inmp, outmp, cmpl, ndlp, 0,
-			      cnt+1, 0, retry);
+			      cnt, 0, retry);
 	if (status) {
 		lpfc_free_ct_rsp(phba, outmp);
 		return -ENOMEM;
@@ -533,6 +539,9 @@ lpfc_ns_rsp(struct lpfc_vport *vport, st
 							SLI_CTNS_GFF_ID,
 							0, Did) == 0)
 							vport->num_disc_nodes++;
+						else
+							lpfc_setup_disc_node
+								(vport, Did);
 					}
 					else {
 						lpfc_debugfs_disc_trc(vport,
@@ -1241,7 +1250,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 		    be16_to_cpu(SLI_CTNS_RFF_ID);
 		CtReq->un.rff.PortId = cpu_to_be32(vport->fc_myDID);;
 		CtReq->un.rff.fbits = FC4_FEATURE_INIT;
-		CtReq->un.rff.type_code = FC_FCP_DATA;
+		CtReq->un.rff.type_code = FC_TYPE_FCP;
 		cmpl = lpfc_cmpl_ct_cmd_rff_id;
 		break;
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2009-06-29 10:31:11.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2009-10-01 17:21:21.000000000 -0400
@@ -926,7 +926,7 @@ lpfc_debugfs_dumpData_open(struct inode 
 		goto out;
 
 	/* Round to page boundry */
-	printk(KERN_ERR "BLKGRD %s: _dump_buf_data=0x%p\n",
+	printk(KERN_ERR "9059 BLKGRD:  %s: _dump_buf_data=0x%p\n",
 			__func__, _dump_buf_data);
 	debug->buffer = _dump_buf_data;
 	if (!debug->buffer) {
@@ -956,8 +956,8 @@ lpfc_debugfs_dumpDif_open(struct inode *
 		goto out;
 
 	/* Round to page boundry */
-	printk(KERN_ERR "BLKGRD %s: _dump_buf_dif=0x%p file=%s\n", __func__,
-	       _dump_buf_dif, file->f_dentry->d_name.name);
+	printk(KERN_ERR	"9060 BLKGRD: %s: _dump_buf_dif=0x%p file=%s\n",
+		__func__, _dump_buf_dif, file->f_dentry->d_name.name);
 	debug->buffer = _dump_buf_dif;
 	if (!debug->buffer) {
 		kfree(debug);
@@ -1377,7 +1377,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 			debugfs_create_dir(name, phba->hba_debugfs_root);
 		if (!vport->vport_debugfs_root) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-					 "0417 Cant create debugfs");
+					 "0417 Cant create debugfs\n");
 			goto debug_failed;
 		}
 		atomic_inc(&phba->debugfs_vport_count);
@@ -1430,7 +1430,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 				 vport, &lpfc_debugfs_op_nodelist);
 	if (!vport->debug_nodelist) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-				 "0409 Cant create debugfs nodelist");
+				 "0409 Cant create debugfs nodelist\n");
 		goto debug_failed;
 	}
 debug_failed:
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2009-06-09 09:52:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2009-10-01 17:21:21.000000000 -0400
@@ -19,7 +19,7 @@
  *******************************************************************/
 
 #define FC_MAX_HOLD_RSCN     32	      /* max number of deferred RSCNs */
-#define FC_MAX_NS_RSP        65536    /* max size NameServer rsp */
+#define FC_MAX_NS_RSP        64512    /* max size NameServer rsp */
 #define FC_MAXLOOP           126      /* max devices supported on a fc loop */
 #define LPFC_DISC_FLOGI_TMO  10	      /* Discovery FLOGI ratov */
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-10-01 17:20:57.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-10-01 17:21:21.000000000 -0400
@@ -1699,9 +1699,8 @@ lpfc_init_vpi_cmpl(struct lpfc_hba *phba
 		lpfc_initial_fdisc(vport);
 	else {
 		lpfc_vport_set_state(vport, FC_VPORT_NO_FABRIC_SUPP);
-		lpfc_printf_vlog(vport, KERN_ERR,
-			LOG_ELS,
-			"2606 No NPIV Fabric support\n");
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				 "2606 No NPIV Fabric support\n");
 	}
 	return;
 }
@@ -1901,7 +1900,10 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 	if (phba->fc_topology == TOPOLOGY_LOOP) {
 		phba->sli3_options &= ~LPFC_SLI3_NPIV_ENABLED;
 
-		if (phba->cfg_enable_npiv)
+		/* if npiv is enabled and this adapter supports npiv log
+		 * a message that npiv is not supported in this topology
+		 */
+		if (phba->cfg_enable_npiv && phba->max_vpi)
 			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
 				"1309 Link Up Event npiv not supported in loop "
 				"topology\n");
@@ -3118,7 +3120,7 @@ lpfc_no_rpi(struct lpfc_hba *phba, struc
 	struct lpfc_sli *psli;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *iocb, *next_iocb;
-	uint32_t rpi, i;
+	uint32_t i;
 
 	lpfc_fabric_abort_nport(ndlp);
 
@@ -3127,7 +3129,6 @@ lpfc_no_rpi(struct lpfc_hba *phba, struc
 	 * by firmware with a no rpi error.
 	 */
 	psli = &phba->sli;
-	rpi = ndlp->nlp_rpi;
 	if (ndlp->nlp_flag & NLP_RPI_VALID) {
 		/* Now process each ring */
 		for (i = 0; i < psli->num_rings; i++) {
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2009-10-01 17:20:57.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2009-10-01 17:21:21.000000000 -0400
@@ -1124,21 +1124,6 @@ typedef struct {
 /* Number of 4-byte words in an IOCB. */
 #define IOCB_WORD_SZ    8
 
-/* defines for type field in fc header */
-#define FC_ELS_DATA     0x1
-#define FC_LLC_SNAP     0x5
-#define FC_FCP_DATA     0x8
-#define FC_COMMON_TRANSPORT_ULP 0x20
-
-/* defines for rctl field in fc header */
-#define FC_DEV_DATA     0x0
-#define FC_UNSOL_CTL    0x2
-#define FC_SOL_CTL      0x3
-#define FC_UNSOL_DATA   0x4
-#define FC_FCP_CMND     0x6
-#define FC_ELS_REQ      0x22
-#define FC_ELS_RSP      0x23
-
 /* network headers for Dfctl field */
 #define FC_NET_HDR      0x20
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2009-10-01 17:20:57.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2009-10-01 17:21:21.000000000 -0400
@@ -3004,12 +3004,11 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 		spin_unlock_irq(&phba->hbalock);
 
 		/* Read the FCF table and re-discover SAN. */
-		rc = lpfc_sli4_read_fcf_record(phba,
-			LPFC_FCOE_FCF_GET_FIRST);
+		rc = lpfc_sli4_read_fcf_record(phba, LPFC_FCOE_FCF_GET_FIRST);
 		if (rc)
 			lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
-				"2547 Read FCF record failed 0x%x\n",
-				rc);
+					"2547 Read FCF record failed 0x%x\n",
+					rc);
 		break;
 
 	case LPFC_FCOE_EVENT_TYPE_FCF_TABLE_FULL:
@@ -3021,7 +3020,7 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 
 	case LPFC_FCOE_EVENT_TYPE_FCF_DEAD:
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
-			"2549 FCF disconnected fron network index 0x%x"
+			"2549 FCF disconnected from network index 0x%x"
 			" tag 0x%x\n", acqe_fcoe->index,
 			acqe_fcoe->event_tag);
 		/* If the event is not for currently used fcf do nothing */
@@ -3917,7 +3916,7 @@ lpfc_free_sgl_list(struct lpfc_hba *phba
 	rc = lpfc_sli4_remove_all_sgl_pages(phba);
 	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-			"2005 Unable to deregister pages from HBA: %x", rc);
+			"2005 Unable to deregister pages from HBA: %x\n", rc);
 	}
 	kfree(phba->sli4_hba.lpfc_els_sgl_array);
 }
@@ -4366,7 +4365,8 @@ lpfc_setup_bg(struct lpfc_hba *phba, str
 			_dump_buf_data =
 				(char *) __get_free_pages(GFP_KERNEL, pagecnt);
 			if (_dump_buf_data) {
-				printk(KERN_ERR "BLKGRD allocated %d pages for "
+				lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+					"9043 BLKGRD: allocated %d pages for "
 				       "_dump_buf_data at 0x%p\n",
 				       (1 << pagecnt), _dump_buf_data);
 				_dump_buf_data_order = pagecnt;
@@ -4377,17 +4377,20 @@ lpfc_setup_bg(struct lpfc_hba *phba, str
 				--pagecnt;
 		}
 		if (!_dump_buf_data_order)
-			printk(KERN_ERR "BLKGRD ERROR unable to allocate "
+			lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+				"9044 BLKGRD: ERROR unable to allocate "
 			       "memory for hexdump\n");
 	} else
-		printk(KERN_ERR "BLKGRD already allocated _dump_buf_data=0x%p"
+		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+			"9045 BLKGRD: already allocated _dump_buf_data=0x%p"
 		       "\n", _dump_buf_data);
 	if (!_dump_buf_dif) {
 		while (pagecnt) {
 			_dump_buf_dif =
 				(char *) __get_free_pages(GFP_KERNEL, pagecnt);
 			if (_dump_buf_dif) {
-				printk(KERN_ERR "BLKGRD allocated %d pages for "
+				lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+					"9046 BLKGRD: allocated %d pages for "
 				       "_dump_buf_dif at 0x%p\n",
 				       (1 << pagecnt), _dump_buf_dif);
 				_dump_buf_dif_order = pagecnt;
@@ -4398,10 +4401,12 @@ lpfc_setup_bg(struct lpfc_hba *phba, str
 				--pagecnt;
 		}
 		if (!_dump_buf_dif_order)
-			printk(KERN_ERR "BLKGRD ERROR unable to allocate "
+			lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+			"9047 BLKGRD: ERROR unable to allocate "
 			       "memory for hexdump\n");
 	} else
-		printk(KERN_ERR "BLKGRD already allocated _dump_buf_dif=0x%p\n",
+		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+			"9048 BLKGRD: already allocated _dump_buf_dif=0x%p\n",
 		       _dump_buf_dif);
 }
 
@@ -5072,10 +5077,9 @@ lpfc_sli4_queue_create(struct lpfc_hba *
 	/* It does not make sense to have more EQs than WQs */
 	if (cfg_fcp_eq_count > phba->cfg_fcp_wq_count) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
-				"2593 The number of FCP EQs (%d) is more "
-				"than the number of FCP WQs (%d), take "
-				"the number of FCP EQs same as than of "
-				"WQs (%d)\n", cfg_fcp_eq_count,
+				"2593 The FCP EQ count(%d) cannot be greater "
+				"than the FCP WQ count(%d), limiting the "
+				"FCP EQ count to %d\n", cfg_fcp_eq_count,
 				phba->cfg_fcp_wq_count,
 				phba->cfg_fcp_wq_count);
 		cfg_fcp_eq_count = phba->cfg_fcp_wq_count;
@@ -7271,15 +7275,15 @@ lpfc_sli4_get_els_iocb_cnt(struct lpfc_h
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		if (max_xri <= 100)
-			return 4;
+			return 10;
 		else if (max_xri <= 256)
-			return 8;
+			return 25;
 		else if (max_xri <= 512)
-			return 16;
+			return 50;
 		else if (max_xri <= 1024)
-			return 32;
+			return 100;
 		else
-			return 48;
+			return 150;
 	} else
 		return 0;
 }
@@ -8117,15 +8121,15 @@ lpfc_exit(void)
 	if (lpfc_enable_npiv)
 		fc_release_transport(lpfc_vport_transport_template);
 	if (_dump_buf_data) {
-		printk(KERN_ERR "BLKGRD freeing %lu pages for _dump_buf_data "
-				"at 0x%p\n",
+		printk(KERN_ERR	"9062 BLKGRD: freeing %lu pages for "
+				"_dump_buf_data at 0x%p\n",
 				(1L << _dump_buf_data_order), _dump_buf_data);
 		free_pages((unsigned long)_dump_buf_data, _dump_buf_data_order);
 	}
 
 	if (_dump_buf_dif) {
-		printk(KERN_ERR "BLKGRD freeing %lu pages for _dump_buf_dif "
-				"at 0x%p\n",
+		printk(KERN_ERR	"9049 BLKGRD: freeing %lu pages for "
+				"_dump_buf_dif at 0x%p\n",
 				(1L << _dump_buf_dif_order), _dump_buf_dif);
 		free_pages((unsigned long)_dump_buf_dif, _dump_buf_dif_order);
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2009-10-01 17:20:57.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2009-10-01 17:21:21.000000000 -0400
@@ -25,8 +25,8 @@
 
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_transport_fc.h>
-
 #include <scsi/scsi.h>
+#include <scsi/fc/fc_fs.h>
 
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
@@ -1135,7 +1135,7 @@ lpfc_config_ring(struct lpfc_hba * phba,
 	/* Otherwise we setup specific rctl / type masks for this ring */
 	for (i = 0; i < pring->num_mask; i++) {
 		mb->un.varCfgRing.rrRegs[i].rval = pring->prt[i].rctl;
-		if (mb->un.varCfgRing.rrRegs[i].rval != FC_ELS_REQ)
+		if (mb->un.varCfgRing.rrRegs[i].rval != FC_RCTL_ELS_REQ)
 			mb->un.varCfgRing.rrRegs[i].rmask = 0xff;
 		else
 			mb->un.varCfgRing.rrRegs[i].rmask = 0xfe;
@@ -1657,9 +1657,12 @@ lpfc_sli4_config(struct lpfc_hba *phba, 
 	/* Allocate record for keeping SGE virtual addresses */
 	mbox->sge_array = kmalloc(sizeof(struct lpfc_mbx_nembed_sge_virt),
 				  GFP_KERNEL);
-	if (!mbox->sge_array)
+	if (!mbox->sge_array) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
+				"2527 Failed to allocate non-embedded SGE "
+				"array.\n");
 		return 0;
-
+	}
 	for (pagen = 0, alloc_len = 0; pagen < pcount; pagen++) {
 		/* The DMA memory is always allocated in the length of a
 		 * page even though the last SGE might not fill up to a
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2009-10-01 12:48:24.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2009-10-01 17:21:21.000000000 -0400
@@ -61,20 +61,22 @@ static void
 lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb);
 
 static void
-lpfc_debug_save_data(struct scsi_cmnd *cmnd)
+lpfc_debug_save_data(struct lpfc_hba *phba, struct scsi_cmnd *cmnd)
 {
 	void *src, *dst;
 	struct scatterlist *sgde = scsi_sglist(cmnd);
 
 	if (!_dump_buf_data) {
-		printk(KERN_ERR "BLKGRD ERROR %s _dump_buf_data is NULL\n",
+		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+			"9050 BLKGRD: ERROR %s _dump_buf_data is NULL\n",
 				__func__);
 		return;
 	}
 

 	if (!sgde) {
-		printk(KERN_ERR "BLKGRD ERROR: data scatterlist is null\n");
+		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+			"9051 BLKGRD: ERROR: data scatterlist is null\n");
 		return;
 	}
 
@@ -88,19 +90,21 @@ lpfc_debug_save_data(struct scsi_cmnd *c
 }
 
 static void
-lpfc_debug_save_dif(struct scsi_cmnd *cmnd)
+lpfc_debug_save_dif(struct lpfc_hba *phba, struct scsi_cmnd *cmnd)
 {
 	void *src, *dst;
 	struct scatterlist *sgde = scsi_prot_sglist(cmnd);
 
 	if (!_dump_buf_dif) {
-		printk(KERN_ERR "BLKGRD ERROR %s _dump_buf_data is NULL\n",
+		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+			"9052 BLKGRD: ERROR %s _dump_buf_data is NULL\n",
 				__func__);
 		return;
 	}
 
 	if (!sgde) {
-		printk(KERN_ERR "BLKGRD ERROR: prot scatterlist is null\n");
+		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+			"9053 BLKGRD: ERROR: prot scatterlist is null\n");
 		return;
 	}
 
@@ -1024,7 +1028,8 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hb
 
 		lpfc_cmd->seg_cnt = nseg;
 		if (lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt) {
-			printk(KERN_ERR "%s: Too many sg segments from "
+			lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+				"9064 BLKGRD: %s: Too many sg segments from "
 			       "dma_map_sg.  Config %d, seg_cnt %d\n",
 			       __func__, phba->cfg_sg_seg_cnt,
 			       lpfc_cmd->seg_cnt);
@@ -1112,7 +1117,7 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hb
  * with the cmd
  */
 static int
-lpfc_sc_to_sli_prof(struct scsi_cmnd *sc)
+lpfc_sc_to_sli_prof(struct lpfc_hba *phba, struct scsi_cmnd *sc)
 {
 	uint8_t guard_type = scsi_host_get_guard(sc->device->host);
 	uint8_t ret_prof = LPFC_PROF_INVALID;
@@ -1136,7 +1141,8 @@ lpfc_sc_to_sli_prof(struct scsi_cmnd *sc
 
 		case SCSI_PROT_NORMAL:
 		default:
-			printk(KERN_ERR "Bad op/guard:%d/%d combination\n",
+			lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+				"9063 BLKGRD:Bad op/guard:%d/%d combination\n",
 					scsi_get_prot_op(sc), guard_type);
 			break;
 
@@ -1157,7 +1163,8 @@ lpfc_sc_to_sli_prof(struct scsi_cmnd *sc
 		case SCSI_PROT_WRITE_STRIP:
 		case SCSI_PROT_NORMAL:
 		default:
-			printk(KERN_ERR "Bad op/guard:%d/%d combination\n",
+			lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+				"9075 BLKGRD: Bad op/guard:%d/%d combination\n",
 					scsi_get_prot_op(sc), guard_type);
 			break;
 		}
@@ -1259,7 +1266,7 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba,
 	uint16_t apptagmask, apptagval;
 
 	pde1 = (struct lpfc_pde *) bpl;
-	prof = lpfc_sc_to_sli_prof(sc);
+	prof = lpfc_sc_to_sli_prof(phba, sc);
 
 	if (prof == LPFC_PROF_INVALID)
 		goto out;
@@ -1359,7 +1366,7 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 		return 0;
 	}
 
-	prof = lpfc_sc_to_sli_prof(sc);
+	prof = lpfc_sc_to_sli_prof(phba, sc);
 	if (prof == LPFC_PROF_INVALID)
 		goto out;
 
@@ -1408,7 +1415,8 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 		subtotal = 0; /* total bytes processed for current prot grp */
 		while (!pgdone) {
 			if (!sgde) {
-				printk(KERN_ERR "%s Invalid data segment\n",
+				lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+					"9065 BLKGRD:%s Invalid data segment\n",
 						__func__);
 				return 0;
 			}
@@ -1462,7 +1470,8 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 			reftag += protgrp_blks;
 		} else {
 			/* if we're here, we have a bug */
-			printk(KERN_ERR "BLKGRD: bug in %s\n", __func__);
+			lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+				"9054 BLKGRD: bug in %s\n", __func__);
 		}
 
 	} while (!alldone);
@@ -1544,8 +1553,10 @@ lpfc_bg_scsi_prep_dma_buf(struct lpfc_hb
 
 		lpfc_cmd->seg_cnt = datasegcnt;
 		if (lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt) {
-			printk(KERN_ERR "%s: Too many sg segments from "
-					"dma_map_sg.  Config %d, seg_cnt %d\n",
+			lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+					"9067 BLKGRD: %s: Too many sg segments"
+					" from dma_map_sg.  Config %d, seg_cnt"
+					" %d\n",
 					__func__, phba->cfg_sg_seg_cnt,
 					lpfc_cmd->seg_cnt);
 			scsi_dma_unmap(scsi_cmnd);
@@ -1579,8 +1590,9 @@ lpfc_bg_scsi_prep_dma_buf(struct lpfc_hb
 			lpfc_cmd->prot_seg_cnt = protsegcnt;
 			if (lpfc_cmd->prot_seg_cnt
 			    > phba->cfg_prot_sg_seg_cnt) {
-				printk(KERN_ERR "%s: Too many prot sg segments "
-						"from dma_map_sg.  Config %d,"
+				lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+					"9068 BLKGRD: %s: Too many prot sg "
+					"segments from dma_map_sg.  Config %d,"
 						"prot_seg_cnt %d\n", __func__,
 						phba->cfg_prot_sg_seg_cnt,
 						lpfc_cmd->prot_seg_cnt);
@@ -1671,23 +1683,26 @@ lpfc_parse_bg_err(struct lpfc_hba *phba,
 	uint32_t bgstat = bgf->bgstat;
 	uint64_t failing_sector = 0;
 
-	printk(KERN_ERR "BG ERROR in cmd 0x%x lba 0x%llx blk cnt 0x%x "
+	lpfc_printf_log(phba, KERN_ERR, LOG_BG, "9069 BLKGRD: BG ERROR in cmd"
+			" 0x%x lba 0x%llx blk cnt 0x%x "
 			"bgstat=0x%x bghm=0x%x\n",
 			cmd->cmnd[0], (unsigned long long)scsi_get_lba(cmd),
 			blk_rq_sectors(cmd->request), bgstat, bghm);
 
 	spin_lock(&_dump_buf_lock);
 	if (!_dump_buf_done) {
-		printk(KERN_ERR "Saving Data for %u blocks to debugfs\n",
+		lpfc_printf_log(phba, KERN_ERR, LOG_BG,  "9070 BLKGRD: Saving"
+			" Data for %u blocks to debugfs\n",
 				(cmd->cmnd[7] << 8 | cmd->cmnd[8]));
-		lpfc_debug_save_data(cmd);
+		lpfc_debug_save_data(phba, cmd);
 
 		/* If we have a prot sgl, save the DIF buffer */
 		if (lpfc_prot_group_type(phba, cmd) ==
 				LPFC_PG_TYPE_DIF_BUF) {
-			printk(KERN_ERR "Saving DIF for %u blocks to debugfs\n",
-					(cmd->cmnd[7] << 8 | cmd->cmnd[8]));
-			lpfc_debug_save_dif(cmd);
+			lpfc_printf_log(phba, KERN_ERR, LOG_BG, "9071 BLKGRD: "
+				"Saving DIF for %u blocks to debugfs\n",
+				(cmd->cmnd[7] << 8 | cmd->cmnd[8]));
+			lpfc_debug_save_dif(phba, cmd);
 		}
 
 		_dump_buf_done = 1;
@@ -1696,15 +1711,17 @@ lpfc_parse_bg_err(struct lpfc_hba *phba,
 
 	if (lpfc_bgs_get_invalid_prof(bgstat)) {
 		cmd->result = ScsiResult(DID_ERROR, 0);
-		printk(KERN_ERR "Invalid BlockGuard profile. bgstat:0x%x\n",
-				bgstat);
+		lpfc_printf_log(phba, KERN_ERR, LOG_BG, "9072 BLKGRD: Invalid"
+			" BlockGuard profile. bgstat:0x%x\n",
+			bgstat);
 		ret = (-1);
 		goto out;
 	}
 
 	if (lpfc_bgs_get_uninit_dif_block(bgstat)) {
 		cmd->result = ScsiResult(DID_ERROR, 0);
-		printk(KERN_ERR "Invalid BlockGuard DIF Block. bgstat:0x%x\n",
+		lpfc_printf_log(phba, KERN_ERR, LOG_BG, "9073 BLKGRD: "
+				"Invalid BlockGuard DIF Block. bgstat:0x%x\n",
 				bgstat);
 		ret = (-1);
 		goto out;
@@ -1718,7 +1735,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba,
 		cmd->result = DRIVER_SENSE << 24
 			| ScsiResult(DID_ABORT, SAM_STAT_CHECK_CONDITION);
 		phba->bg_guard_err_cnt++;
-		printk(KERN_ERR "BLKGRD: guard_tag error\n");
+		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+			"9055 BLKGRD: guard_tag error\n");
 	}
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
@@ -1730,7 +1748,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba,
 			| ScsiResult(DID_ABORT, SAM_STAT_CHECK_CONDITION);
 
 		phba->bg_reftag_err_cnt++;
-		printk(KERN_ERR "BLKGRD: ref_tag error\n");
+		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+			"9056 BLKGRD: ref_tag error\n");
 	}
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
@@ -1742,7 +1761,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba,
 			| ScsiResult(DID_ABORT, SAM_STAT_CHECK_CONDITION);
 
 		phba->bg_apptag_err_cnt++;
-		printk(KERN_ERR "BLKGRD: app_tag error\n");
+		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+			"9061 BLKGRD: app_tag error\n");
 	}
 
 	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
@@ -1763,7 +1783,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba,
 	if (!ret) {
 		/* No error was reported - problem in FW? */
 		cmd->result = ScsiResult(DID_ERROR, 0);
-		printk(KERN_ERR "BLKGRD: no errors reported!\n");
+		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+			"9057 BLKGRD: no errors reported!\n");
 	}
 
 out:
@@ -1822,9 +1843,10 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hb
 
 		lpfc_cmd->seg_cnt = nseg;
 		if (lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt) {
-			printk(KERN_ERR "%s: Too many sg segments from "
-			       "dma_map_sg.  Config %d, seg_cnt %d\n",
-			       __func__, phba->cfg_sg_seg_cnt,
+			lpfc_printf_log(phba, KERN_ERR, LOG_BG, "9074 BLKGRD:"
+				" %s: Too many sg segments from "
+				"dma_map_sg.  Config %d, seg_cnt %d\n",
+				__func__, phba->cfg_sg_seg_cnt,
 			       lpfc_cmd->seg_cnt);
 			scsi_dma_unmap(scsi_cmnd);
 			return 1;
@@ -2050,6 +2072,21 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
 		goto out;
 	}
 
+	if (resp_info & RSP_LEN_VALID) {
+		rsplen = be32_to_cpu(fcprsp->rspRspLen);
+		if ((rsplen != 0 && rsplen != 4 && rsplen != 8) ||
+		    (fcprsp->rspInfo3 != RSP_NO_FAILURE)) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+				 "2719 Invalid response length: "
+				 "tgt x%x lun x%x cmnd x%x rsplen x%x\n",
+				 cmnd->device->id,
+				 cmnd->device->lun, cmnd->cmnd[0],
+				 rsplen);
+			host_status = DID_ERROR;
+			goto out;
+		}
+	}
+
 	if ((resp_info & SNS_LEN_VALID) && fcprsp->rspSnsLen) {
 		uint32_t snslen = be32_to_cpu(fcprsp->rspSnsLen);
 		if (snslen > SCSI_SENSE_BUFFERSIZE)
@@ -2074,15 +2111,6 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
 			 be32_to_cpu(fcprsp->rspRspLen),
 			 fcprsp->rspInfo3);
 
-	if (resp_info & RSP_LEN_VALID) {
-		rsplen = be32_to_cpu(fcprsp->rspRspLen);
-		if ((rsplen != 0 && rsplen != 4 && rsplen != 8) ||
-		    (fcprsp->rspInfo3 != RSP_NO_FAILURE)) {
-			host_status = DID_ERROR;
-			goto out;
-		}
-	}
-
 	scsi_set_resid(cmnd, 0);
 	if (resp_info & RESID_UNDER) {
 		scsi_set_resid(cmnd, be32_to_cpu(fcprsp->rspResId));
@@ -2264,7 +2292,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 					lpfc_printf_vlog(vport, KERN_WARNING,
 							LOG_BG,
 							"9031 non-zero BGSTAT "
-							"on unprotected cmd");
+							"on unprotected cmd\n");
 				}
 			}
 
@@ -2785,9 +2813,10 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	if (!(phba->sli3_options & LPFC_SLI3_BG_ENABLED) &&
 		scsi_get_prot_op(cmnd) != SCSI_PROT_NORMAL) {
 
-		printk(KERN_ERR "BLKGRD ERROR: rcvd protected cmd:%02x op:%02x "
-				"str=%s without registering for BlockGuard - "
-				"Rejecting command\n",
+		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
+				"9058 BLKGRD: ERROR: rcvd protected cmd:%02x"
+				" op:%02x str=%s without registering for"
+				" BlockGuard - Rejecting command\n",
 				cmnd->cmnd[0], scsi_get_prot_op(cmnd),
 				dif_op_str[scsi_get_prot_op(cmnd)]);
 		goto out_fail_command;
@@ -2827,61 +2856,66 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	cmnd->scsi_done = done;
 
 	if (scsi_get_prot_op(cmnd) != SCSI_PROT_NORMAL) {
-		lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+		if (vport->phba->cfg_enable_bg) {
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 				"9033 BLKGRD: rcvd protected cmd:%02x op:%02x "
 				"str=%s\n",
 				cmnd->cmnd[0], scsi_get_prot_op(cmnd),
 				dif_op_str[scsi_get_prot_op(cmnd)]);
-		lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 				"9034 BLKGRD: CDB: %02x %02x %02x %02x %02x "
 				"%02x %02x %02x %02x %02x\n",
 				cmnd->cmnd[0], cmnd->cmnd[1], cmnd->cmnd[2],
 				cmnd->cmnd[3], cmnd->cmnd[4], cmnd->cmnd[5],
 				cmnd->cmnd[6], cmnd->cmnd[7], cmnd->cmnd[8],
 				cmnd->cmnd[9]);
-		if (cmnd->cmnd[0] == READ_10)
-			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+			if (cmnd->cmnd[0] == READ_10)
+				lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 					"9035 BLKGRD: READ @ sector %llu, "
 					"count %u\n",
 					(unsigned long long)scsi_get_lba(cmnd),
 					blk_rq_sectors(cmnd->request));
-		else if (cmnd->cmnd[0] == WRITE_10)
-			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+			else if (cmnd->cmnd[0] == WRITE_10)
+				lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 					"9036 BLKGRD: WRITE @ sector %llu, "
 					"count %u cmd=%p\n",
 					(unsigned long long)scsi_get_lba(cmnd),
 					blk_rq_sectors(cmnd->request),
 					cmnd);
+		}
 
 		err = lpfc_bg_scsi_prep_dma_buf(phba, lpfc_cmd);
 	} else {
-		lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
-				"9038 BLKGRD: rcvd unprotected cmd:%02x op:%02x"
-				" str=%s\n",
-				cmnd->cmnd[0], scsi_get_prot_op(cmnd),
-				dif_op_str[scsi_get_prot_op(cmnd)]);
-		lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
-				 "9039 BLKGRD: CDB: %02x %02x %02x %02x %02x "
-				 "%02x %02x %02x %02x %02x\n",
-				 cmnd->cmnd[0], cmnd->cmnd[1], cmnd->cmnd[2],
-				 cmnd->cmnd[3], cmnd->cmnd[4], cmnd->cmnd[5],
-				 cmnd->cmnd[6], cmnd->cmnd[7], cmnd->cmnd[8],
-				 cmnd->cmnd[9]);
-		if (cmnd->cmnd[0] == READ_10)
+		if (vport->phba->cfg_enable_bg) {
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
-					 "9040 dbg: READ @ sector %llu, "
-					 "count %u\n",
-					 (unsigned long long)scsi_get_lba(cmnd),
+					"9038 BLKGRD: rcvd unprotected cmd:"
+					"%02x op:%02x str=%s\n",
+					cmnd->cmnd[0], scsi_get_prot_op(cmnd),
+					dif_op_str[scsi_get_prot_op(cmnd)]);
+				lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+					"9039 BLKGRD: CDB: %02x %02x %02x "
+					"%02x %02x %02x %02x %02x %02x %02x\n",
+					cmnd->cmnd[0], cmnd->cmnd[1],
+					cmnd->cmnd[2], cmnd->cmnd[3],
+					cmnd->cmnd[4], cmnd->cmnd[5],
+					cmnd->cmnd[6], cmnd->cmnd[7],
+					cmnd->cmnd[8], cmnd->cmnd[9]);
+			if (cmnd->cmnd[0] == READ_10)
+				lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+					"9040 dbg: READ @ sector %llu, "
+					"count %u\n",
+					(unsigned long long)scsi_get_lba(cmnd),
 					 blk_rq_sectors(cmnd->request));
-		else if (cmnd->cmnd[0] == WRITE_10)
-			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+			else if (cmnd->cmnd[0] == WRITE_10)
+				lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 					 "9041 dbg: WRITE @ sector %llu, "
 					 "count %u cmd=%p\n",
 					 (unsigned long long)scsi_get_lba(cmnd),
 					 blk_rq_sectors(cmnd->request), cmnd);
-		else
-			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+			else
+				lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 					 "9042 dbg: parser not implemented\n");
+		}
 		err = lpfc_scsi_prep_dma_buf(phba, lpfc_cmd);
 	}
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2009-10-01 17:20:57.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2009-10-01 17:21:21.000000000 -0400
@@ -159,7 +159,7 @@ struct lpfc_fip_param_hdr {
 #define	lpfc_fip_param_hdr_fipp_mode_SHIFT	6
 #define	lpfc_fip_param_hdr_fipp_mode_MASK	0x3
 #define lpfc_fip_param_hdr_fipp_mode_WORD	parm_flags
-#define	FIPP_MODE_ON				0x2
+#define	FIPP_MODE_ON				0x1
 #define	FIPP_MODE_OFF				0x0
 #define FIPP_VLAN_VALID				0x1
 };
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2009-10-01 17:20:57.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2009-10-01 17:21:21.000000000 -0400
@@ -516,6 +516,8 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phb
 	struct lpfc_sglq *sglq = NULL;
 	uint16_t adj_xri;
 	list_remove_head(lpfc_sgl_list, sglq, struct lpfc_sglq, list);
+	if (!sglq)
+		return NULL;
 	adj_xri = sglq->sli4_xritag - phba->sli4_hba.max_cfg_param.xri_base;
 	phba->sli4_hba.lpfc_sglq_active_list[adj_xri] = sglq;
 	return sglq;
@@ -2070,8 +2072,8 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 	if ((irsp->ulpCommand == CMD_RCV_ELS_REQ64_CX) ||
 	    (irsp->ulpCommand == CMD_RCV_ELS_REQ_CX) ||
 	    (irsp->ulpCommand == CMD_IOCB_RCV_ELS64_CX)) {
-		Rctl = FC_ELS_REQ;
-		Type = FC_ELS_DATA;
+		Rctl = FC_RCTL_ELS_REQ;
+		Type = FC_TYPE_ELS;
 	} else {
 		w5p = (WORD5 *)&(saveq->iocb.un.ulpWord[5]);
 		Rctl = w5p->hcsw.Rctl;
@@ -2081,8 +2083,8 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 		if ((Rctl == 0) && (pring->ringno == LPFC_ELS_RING) &&
 			(irsp->ulpCommand == CMD_RCV_SEQUENCE64_CX ||
 			 irsp->ulpCommand == CMD_IOCB_RCV_SEQ64_CX)) {
-			Rctl = FC_ELS_REQ;
-			Type = FC_ELS_DATA;
+			Rctl = FC_RCTL_ELS_REQ;
+			Type = FC_TYPE_ELS;
 			w5p->hcsw.Rctl = Rctl;
 			w5p->hcsw.Type = Type;
 		}
@@ -4485,7 +4487,8 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	rc = lpfc_sli4_post_sgl_list(phba);
 	if (unlikely(rc)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
-				"0582 Error %d during sgl post operation", rc);
+				"0582 Error %d during sgl post operation\n",
+					rc);
 		rc = -ENODEV;
 		goto out_free_vpd;
 	}
@@ -4494,8 +4497,8 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	rc = lpfc_sli4_repost_scsi_sgl_list(phba);
 	if (unlikely(rc)) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
-				"0383 Error %d during scsi sgl post opeation",
-				rc);
+				"0383 Error %d during scsi sgl post "
+				"operation\n", rc);
 		/* Some Scsi buffers were moved to the abort scsi list */
 		/* A pci function reset will repost them */
 		rc = -ENODEV;
@@ -5686,7 +5689,7 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba
 		case CMD_GEN_REQUEST64_CX:
 			if (!(phba->sli.sli_flag & LPFC_MENLO_MAINT) ||
 				(piocb->iocb.un.genreq64.w5.hcsw.Rctl !=
-					FC_FCP_CMND) ||
+					FC_RCTL_DD_UNSOL_CMD) ||
 				(piocb->iocb.un.genreq64.w5.hcsw.Type !=
 					MENLO_TRANSPORT_TYPE))
 
@@ -6485,27 +6488,27 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 				lpfc_sli_async_event_handler;
 			pring->num_mask = LPFC_MAX_RING_MASK;
 			pring->prt[0].profile = 0;	/* Mask 0 */
-			pring->prt[0].rctl = FC_ELS_REQ;
-			pring->prt[0].type = FC_ELS_DATA;
+			pring->prt[0].rctl = FC_RCTL_ELS_REQ;
+			pring->prt[0].type = FC_TYPE_ELS;
 			pring->prt[0].lpfc_sli_rcv_unsol_event =
 			    lpfc_els_unsol_event;
 			pring->prt[1].profile = 0;	/* Mask 1 */
-			pring->prt[1].rctl = FC_ELS_RSP;
-			pring->prt[1].type = FC_ELS_DATA;
+			pring->prt[1].rctl = FC_RCTL_ELS_REP;
+			pring->prt[1].type = FC_TYPE_ELS;
 			pring->prt[1].lpfc_sli_rcv_unsol_event =
 			    lpfc_els_unsol_event;
 			pring->prt[2].profile = 0;	/* Mask 2 */
 			/* NameServer Inquiry */
-			pring->prt[2].rctl = FC_UNSOL_CTL;
+			pring->prt[2].rctl = FC_RCTL_DD_UNSOL_CTL;
 			/* NameServer */
-			pring->prt[2].type = FC_COMMON_TRANSPORT_ULP;
+			pring->prt[2].type = FC_TYPE_CT;
 			pring->prt[2].lpfc_sli_rcv_unsol_event =
 			    lpfc_ct_unsol_event;
 			pring->prt[3].profile = 0;	/* Mask 3 */
 			/* NameServer response */
-			pring->prt[3].rctl = FC_SOL_CTL;
+			pring->prt[3].rctl = FC_RCTL_DD_SOL_CTL;
 			/* NameServer */
-			pring->prt[3].type = FC_COMMON_TRANSPORT_ULP;
+			pring->prt[3].type = FC_TYPE_CT;
 			pring->prt[3].lpfc_sli_rcv_unsol_event =
 			    lpfc_ct_unsol_event;
 			/* abort unsolicited sequence */
@@ -8089,7 +8092,7 @@ lpfc_sli_sp_intr_handler(int irq, void *
 							KERN_ERR,
 							LOG_MBOX | LOG_SLI,
 							"0350 rc should have"
-							"been MBX_BUSY");
+							"been MBX_BUSY\n");
 						if (rc != MBX_NOT_FINISHED)
 							goto send_current_mbox;
 					}
@@ -8118,7 +8121,7 @@ send_current_mbox:
 			if (rc != MBX_SUCCESS)
 				lpfc_printf_log(phba, KERN_ERR, LOG_MBOX |
 						LOG_SLI, "0349 rc should be "
-						"MBX_SUCCESS");
+						"MBX_SUCCESS\n");
 		}
 
 		spin_lock_irqsave(&phba->hbalock, iflag);
@@ -10454,8 +10457,7 @@ lpfc_sli4_next_xritag(struct lpfc_hba *p
 		return xritag;
 	}
 	spin_unlock_irq(&phba->hbalock);
-
-	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+	lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 			"2004 Failed to allocate XRI.last XRITAG is %d"
 			" Max XRI is %d, Used XRI is %d\n",
 			phba->sli4_hba.next_xri,
@@ -10519,15 +10521,7 @@ lpfc_sli4_post_sgl_list(struct lpfc_hba 
 		lpfc_sli4_mbox_cmd_free(phba, mbox);
 		return -ENOMEM;
 	}
-
 	/* Get the first SGE entry from the non-embedded DMA memory */
-	if (unlikely(!mbox->sge_array)) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
-				"2525 Failed to get the non-embedded SGE "
-				"virtual address\n");
-		lpfc_sli4_mbox_cmd_free(phba, mbox);
-		return -ENOMEM;
-	}
 	viraddr = mbox->sge_array->addr[0];
 
 	/* Set up the SGL pages in the non-embedded DMA pages */
@@ -10551,8 +10545,7 @@ lpfc_sli4_post_sgl_list(struct lpfc_hba 
 		sgl_pg_pairs++;
 	}
 	bf_set(lpfc_post_sgl_pages_xri, sgl, xritag_start);
-	pg_pairs = (pg_pairs > 0) ? (pg_pairs - 1) : pg_pairs;
-	bf_set(lpfc_post_sgl_pages_xricnt, sgl, pg_pairs);
+	bf_set(lpfc_post_sgl_pages_xricnt, sgl, els_xri_cnt);
 	/* Perform endian conversion if necessary */
 	sgl->word0 = cpu_to_le32(sgl->word0);
 
@@ -10634,15 +10627,7 @@ lpfc_sli4_post_scsi_sgl_block(struct lpf
 		lpfc_sli4_mbox_cmd_free(phba, mbox);
 		return -ENOMEM;
 	}
-
 	/* Get the first SGE entry from the non-embedded DMA memory */
-	if (unlikely(!mbox->sge_array)) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
-				"2565 Failed to get the non-embedded SGE "
-				"virtual address\n");
-		lpfc_sli4_mbox_cmd_free(phba, mbox);
-		return -ENOMEM;
-	}
 	viraddr = mbox->sge_array->addr[0];
 
 	/* Set up the SGL pages in the non-embedded DMA pages */
@@ -11565,6 +11550,7 @@ lpfc_sli4_init_vpi(struct lpfc_hba *phba
 {
 	LPFC_MBOXQ_t *mboxq;
 	int rc = 0;
+	int retval = MBX_SUCCESS;
 	uint32_t mbox_tmo;
 
 	if (vpi == 0)
@@ -11575,16 +11561,17 @@ lpfc_sli4_init_vpi(struct lpfc_hba *phba
 	lpfc_init_vpi(phba, mboxq, vpi);
 	mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_INIT_VPI);
 	rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mboxq, phba->mbox_mem_pool);
 	if (rc != MBX_SUCCESS) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"2022 INIT VPI Mailbox failed "
 				"status %d, mbxStatus x%x\n", rc,
 				bf_get(lpfc_mqe_status, &mboxq->u.mqe));
-		rc = -EIO;
+		retval = -EIO;
 	}
-	return rc;
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mboxq, phba->mbox_mem_pool);
+
+	return retval;
 }
 
 /**
@@ -11669,13 +11656,6 @@ lpfc_sli4_add_fcf_record(struct lpfc_hba
 	 */
 	lpfc_sli4_mbx_sge_get(mboxq, 0, &sge);
 	phys_addr = getPaddr(sge.pa_hi, sge.pa_lo);
-	if (unlikely(!mboxq->sge_array)) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
-				"2526 Failed to get the non-embedded SGE "
-				"virtual address\n");
-		lpfc_sli4_mbox_cmd_free(phba, mboxq);
-		return -ENOMEM;
-	}
 	virt_addr = mboxq->sge_array->addr[0];
 	/*
 	 * Configure the FCF record for FCFI 0.  This is the driver's
@@ -11799,13 +11779,6 @@ lpfc_sli4_read_fcf_record(struct lpfc_hb
 	 */
 	lpfc_sli4_mbx_sge_get(mboxq, 0, &sge);
 	phys_addr = getPaddr(sge.pa_hi, sge.pa_lo);
-	if (unlikely(!mboxq->sge_array)) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
-				"2527 Failed to get the non-embedded SGE "
-				"virtual address\n");
-		error = -ENOMEM;
-		goto fail_fcfscan;
-	}
 	virt_addr = mboxq->sge_array->addr[0];
 	read_fcf = (struct lpfc_mbx_read_fcf_tbl *)virt_addr;
 


