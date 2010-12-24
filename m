From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] SCSI fixes for 2.6.37-rc7
Date: Fri, 24 Dec 2010 09:59:41 -0600
Message-ID: <1293206382.2987.41.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is just a couple of minor fixes:  One is to fix the documentation
(after changing to lockless queuecommand, we shouldn't say in the docs
that the host lock is held) and the other renames a badly named global
variable in bfa which generated a linux-next clash with staging.

The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

James Bottomley (1):
      fix up documentation for change in ->queuecommand to lockless calling

Jing Huang (1):
      bfa: rename log_level to bfa_log_level

and the diffstat:

 Documentation/scsi/scsi_mid_low_api.txt |   59 ++++++++++++++++----------------
 drivers/scsi/bfa/bfa_fcs.c              |    4 +-
 drivers/scsi/bfa/bfa_fcs_fcpim.c        |    6 +--
 drivers/scsi/bfa/bfa_fcs_lport.c        |   10 ++---
 drivers/scsi/bfa/bfa_fcs_rport.c        |    6 +--
 drivers/scsi/bfa/bfa_ioc.c              |    8 ++--
 drivers/scsi/bfa/bfa_svc.c              |   28 +++++++--------
 drivers/scsi/bfa/bfad.c                 |    8 ++--
 drivers/scsi/bfa/bfad_drv.h             |    2 -
 drivers/scsi/bfa/bfad_im.c              |   21 +++++------
 10 files changed, 78 insertions(+), 74 deletions(-)

With full diffs below.

James

---

diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index 570ef2b..df322c1 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -1044,9 +1044,9 @@ Details:
 
 
 /**
- *      queuecommand - queue scsi command, invoke 'done' on completion
+ *      queuecommand - queue scsi command, invoke scp->scsi_done on completion
+ *      @shost: pointer to the scsi host object
  *      @scp: pointer to scsi command object
- *      @done: function pointer to be invoked on completion
  *
  *      Returns 0 on success.
  *
@@ -1074,42 +1074,45 @@ Details:
  *
  *      Other types of errors that are detected immediately may be
  *      flagged by setting scp->result to an appropriate value,
- *      invoking the 'done' callback, and then returning 0 from this
- *      function. If the command is not performed immediately (and the
- *      LLD is starting (or will start) the given command) then this
- *      function should place 0 in scp->result and return 0.
+ *      invoking the scp->scsi_done callback, and then returning 0
+ *      from this function. If the command is not performed
+ *      immediately (and the LLD is starting (or will start) the given
+ *      command) then this function should place 0 in scp->result and
+ *      return 0.
  *
  *      Command ownership.  If the driver returns zero, it owns the
- *      command and must take responsibility for ensuring the 'done'
- *      callback is executed.  Note: the driver may call done before
- *      returning zero, but after it has called done, it may not
- *      return any value other than zero.  If the driver makes a
- *      non-zero return, it must not execute the command's done
- *      callback at any time.
- *
- *      Locks: struct Scsi_Host::host_lock held on entry (with "irqsave")
- *             and is expected to be held on return.
+ *      command and must take responsibility for ensuring the
+ *      scp->scsi_done callback is executed.  Note: the driver may
+ *      call scp->scsi_done before returning zero, but after it has
+ *      called scp->scsi_done, it may not return any value other than
+ *      zero.  If the driver makes a non-zero return, it must not
+ *      execute the command's scsi_done callback at any time.
+ *
+ *      Locks: up to and including 2.6.36, struct Scsi_Host::host_lock
+ *             held on entry (with "irqsave") and is expected to be
+ *             held on return. From 2.6.37 onwards, queuecommand is
+ *             called without any locks held.
  *
  *      Calling context: in interrupt (soft irq) or process context
  *
- *      Notes: This function should be relatively fast. Normally it will
- *      not wait for IO to complete. Hence the 'done' callback is invoked 
- *      (often directly from an interrupt service routine) some time after
- *      this function has returned. In some cases (e.g. pseudo adapter 
- *      drivers that manufacture the response to a SCSI INQUIRY)
- *      the 'done' callback may be invoked before this function returns.
- *      If the 'done' callback is not invoked within a certain period
- *      the SCSI mid level will commence error processing.
- *      If a status of CHECK CONDITION is placed in "result" when the
- *      'done' callback is invoked, then the LLD driver should 
- *      perform autosense and fill in the struct scsi_cmnd::sense_buffer
+ *      Notes: This function should be relatively fast. Normally it
+ *      will not wait for IO to complete. Hence the scp->scsi_done
+ *      callback is invoked (often directly from an interrupt service
+ *      routine) some time after this function has returned. In some
+ *      cases (e.g. pseudo adapter drivers that manufacture the
+ *      response to a SCSI INQUIRY) the scp->scsi_done callback may be
+ *      invoked before this function returns.  If the scp->scsi_done
+ *      callback is not invoked within a certain period the SCSI mid
+ *      level will commence error processing.  If a status of CHECK
+ *      CONDITION is placed in "result" when the scp->scsi_done
+ *      callback is invoked, then the LLD driver should perform
+ *      autosense and fill in the struct scsi_cmnd::sense_buffer
  *      array. The scsi_cmnd::sense_buffer array is zeroed prior to
  *      the mid level queuing a command to an LLD.
  *
  *      Defined in: LLD
  **/
-    int queuecommand(struct scsi_cmnd * scp, 
-                     void (*done)(struct scsi_cmnd *))
+    int queuecommand(struct Scsi_Host *shost, struct scsi_cmnd * scp)
 
 
 /**
diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index c94502d..045d7e8 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -677,7 +677,7 @@ bfa_fcs_fabric_sm_isolated(struct bfa_fcs_fabric_s *fabric,
 	bfa_trc(fabric->fcs, event);
 	wwn2str(pwwn_ptr, fabric->bport.port_cfg.pwwn);
 
-	BFA_LOG(KERN_INFO, bfad, log_level,
+	BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 		"Port is isolated due to VF_ID mismatch. "
 		"PWWN: %s Port VF_ID: %04x switch port VF_ID: %04x.",
 		pwwn_ptr, fabric->fcs->port_vfid,
@@ -1411,7 +1411,7 @@ bfa_fcs_fabric_set_fabric_name(struct bfa_fcs_fabric_s *fabric,
 		wwn2str(pwwn_ptr, bfa_fcs_lport_get_pwwn(&fabric->bport));
 		wwn2str(fwwn_ptr,
 			bfa_fcs_lport_get_fabric_name(&fabric->bport));
-		BFA_LOG(KERN_WARNING, bfad, log_level,
+		BFA_LOG(KERN_WARNING, bfad, bfa_log_level,
 			"Base port WWN = %s Fabric WWN = %s\n",
 			pwwn_ptr, fwwn_ptr);
 	}
diff --git a/drivers/scsi/bfa/bfa_fcs_fcpim.c b/drivers/scsi/bfa/bfa_fcs_fcpim.c
index 9662bcd..413b58e 100644
--- a/drivers/scsi/bfa/bfa_fcs_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcs_fcpim.c
@@ -261,7 +261,7 @@ bfa_fcs_itnim_sm_hcb_online(struct bfa_fcs_itnim_s *itnim,
 		bfa_fcb_itnim_online(itnim->itnim_drv);
 		wwn2str(lpwwn_buf, bfa_fcs_lport_get_pwwn(itnim->rport->port));
 		wwn2str(rpwwn_buf, itnim->rport->pwwn);
-		BFA_LOG(KERN_INFO, bfad, log_level,
+		BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 		"Target (WWN = %s) is online for initiator (WWN = %s)\n",
 		rpwwn_buf, lpwwn_buf);
 		break;
@@ -301,11 +301,11 @@ bfa_fcs_itnim_sm_online(struct bfa_fcs_itnim_s *itnim,
 		wwn2str(lpwwn_buf, bfa_fcs_lport_get_pwwn(itnim->rport->port));
 		wwn2str(rpwwn_buf, itnim->rport->pwwn);
 		if (bfa_fcs_lport_is_online(itnim->rport->port) == BFA_TRUE)
-			BFA_LOG(KERN_ERR, bfad, log_level,
+			BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 			"Target (WWN = %s) connectivity lost for "
 			"initiator (WWN = %s)\n", rpwwn_buf, lpwwn_buf);
 		else
-			BFA_LOG(KERN_INFO, bfad, log_level,
+			BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 			"Target (WWN = %s) offlined by initiator (WWN = %s)\n",
 			rpwwn_buf, lpwwn_buf);
 		break;
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 377cbff..8d65130 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -491,7 +491,7 @@ bfa_fcs_lport_online_actions(struct bfa_fcs_lport_s *port)
 	__port_action[port->fabric->fab_type].online(port);
 
 	wwn2str(lpwwn_buf, bfa_fcs_lport_get_pwwn(port));
-	BFA_LOG(KERN_INFO, bfad, log_level,
+	BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 		"Logical port online: WWN = %s Role = %s\n",
 		lpwwn_buf, "Initiator");
 
@@ -512,11 +512,11 @@ bfa_fcs_lport_offline_actions(struct bfa_fcs_lport_s *port)
 
 	wwn2str(lpwwn_buf, bfa_fcs_lport_get_pwwn(port));
 	if (bfa_fcs_fabric_is_online(port->fabric) == BFA_TRUE)
-		BFA_LOG(KERN_ERR, bfad, log_level,
+		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 		"Logical port lost fabric connectivity: WWN = %s Role = %s\n",
 		lpwwn_buf, "Initiator");
 	else
-		BFA_LOG(KERN_INFO, bfad, log_level,
+		BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 		"Logical port taken offline: WWN = %s Role = %s\n",
 		lpwwn_buf, "Initiator");
 
@@ -573,7 +573,7 @@ bfa_fcs_lport_deleted(struct bfa_fcs_lport_s *port)
 	char    lpwwn_buf[BFA_STRING_32];
 
 	wwn2str(lpwwn_buf, bfa_fcs_lport_get_pwwn(port));
-	BFA_LOG(KERN_INFO, bfad, log_level,
+	BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 		"Logical port deleted: WWN = %s Role = %s\n",
 		lpwwn_buf, "Initiator");
 
@@ -878,7 +878,7 @@ bfa_fcs_lport_init(struct bfa_fcs_lport_s *lport,
 					vport ? vport->vport_drv : NULL);
 
 	wwn2str(lpwwn_buf, bfa_fcs_lport_get_pwwn(lport));
-	BFA_LOG(KERN_INFO, bfad, log_level,
+	BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 		"New logical port created: WWN = %s Role = %s\n",
 		lpwwn_buf, "Initiator");
 
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 47f35c0..cf4a6e7 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -2056,7 +2056,7 @@ bfa_fcs_rport_online_action(struct bfa_fcs_rport_s *rport)
 	wwn2str(lpwwn_buf, bfa_fcs_lport_get_pwwn(port));
 	wwn2str(rpwwn_buf, rport->pwwn);
 	if (!BFA_FCS_PID_IS_WKA(rport->pid))
-		BFA_LOG(KERN_INFO, bfad, log_level,
+		BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 		"Remote port (WWN = %s) online for logical port (WWN = %s)\n",
 		rpwwn_buf, lpwwn_buf);
 }
@@ -2075,12 +2075,12 @@ bfa_fcs_rport_offline_action(struct bfa_fcs_rport_s *rport)
 	wwn2str(rpwwn_buf, rport->pwwn);
 	if (!BFA_FCS_PID_IS_WKA(rport->pid)) {
 		if (bfa_fcs_lport_is_online(rport->port) == BFA_TRUE)
-			BFA_LOG(KERN_ERR, bfad, log_level,
+			BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 				"Remote port (WWN = %s) connectivity lost for "
 				"logical port (WWN = %s)\n",
 				rpwwn_buf, lpwwn_buf);
 		else
-			BFA_LOG(KERN_INFO, bfad, log_level,
+			BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 				"Remote port (WWN = %s) offlined by "
 				"logical port (WWN = %s)\n",
 				rpwwn_buf, lpwwn_buf);
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 54475b5..9f4aa39 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -402,7 +402,7 @@ bfa_ioc_sm_op_entry(struct bfa_ioc_s *ioc)
 
 	ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_OK);
 	bfa_ioc_hb_monitor(ioc);
-	BFA_LOG(KERN_INFO, bfad, log_level, "IOC enabled\n");
+	BFA_LOG(KERN_INFO, bfad, bfa_log_level, "IOC enabled\n");
 }
 
 static void
@@ -444,7 +444,7 @@ bfa_ioc_sm_disabling_entry(struct bfa_ioc_s *ioc)
 {
 	struct bfad_s *bfad = (struct bfad_s *)ioc->bfa->bfad;
 	bfa_iocpf_disable(ioc);
-	BFA_LOG(KERN_INFO, bfad, log_level, "IOC disabled\n");
+	BFA_LOG(KERN_INFO, bfad, bfa_log_level, "IOC disabled\n");
 }
 
 /*
@@ -565,7 +565,7 @@ bfa_ioc_sm_fail_entry(struct bfa_ioc_s *ioc)
 		notify->cbfn(notify->cbarg);
 	}
 
-	BFA_LOG(KERN_CRIT, bfad, log_level,
+	BFA_LOG(KERN_CRIT, bfad, bfa_log_level,
 		"Heart Beat of IOC has failed\n");
 }
 
@@ -1812,7 +1812,7 @@ bfa_ioc_pf_fwmismatch(struct bfa_ioc_s *ioc)
 	 * Provide enable completion callback.
 	 */
 	ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
-	BFA_LOG(KERN_WARNING, bfad, log_level,
+	BFA_LOG(KERN_WARNING, bfad, bfa_log_level,
 		"Running firmware version is incompatible "
 		"with the driver version\n");
 }
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index c768143..37e16ac 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -2138,7 +2138,7 @@ bfa_fcport_sm_enabling_qwait(struct bfa_fcport_s *fcport,
 		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 				BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
 		wwn2str(pwwn_buf, fcport->pwwn);
-		BFA_LOG(KERN_INFO, bfad, log_level,
+		BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 			"Base port disabled: WWN = %s\n", pwwn_buf);
 		break;
 
@@ -2198,7 +2198,7 @@ bfa_fcport_sm_enabling(struct bfa_fcport_s *fcport,
 		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 				BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
 		wwn2str(pwwn_buf, fcport->pwwn);
-		BFA_LOG(KERN_INFO, bfad, log_level,
+		BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 			"Base port disabled: WWN = %s\n", pwwn_buf);
 		break;
 
@@ -2251,7 +2251,7 @@ bfa_fcport_sm_linkdown(struct bfa_fcport_s *fcport,
 
 		bfa_fcport_scn(fcport, BFA_PORT_LINKUP, BFA_FALSE);
 		wwn2str(pwwn_buf, fcport->pwwn);
-		BFA_LOG(KERN_INFO, bfad, log_level,
+		BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 			"Base port online: WWN = %s\n", pwwn_buf);
 		break;
 
@@ -2277,7 +2277,7 @@ bfa_fcport_sm_linkdown(struct bfa_fcport_s *fcport,
 		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 				BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
 		wwn2str(pwwn_buf, fcport->pwwn);
-		BFA_LOG(KERN_INFO, bfad, log_level,
+		BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 			"Base port disabled: WWN = %s\n", pwwn_buf);
 		break;
 
@@ -2322,9 +2322,9 @@ bfa_fcport_sm_linkup(struct bfa_fcport_s *fcport,
 		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 				BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
 		wwn2str(pwwn_buf, fcport->pwwn);
-		BFA_LOG(KERN_INFO, bfad, log_level,
+		BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 			"Base port offline: WWN = %s\n", pwwn_buf);
-		BFA_LOG(KERN_INFO, bfad, log_level,
+		BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 			"Base port disabled: WWN = %s\n", pwwn_buf);
 		break;
 
@@ -2336,10 +2336,10 @@ bfa_fcport_sm_linkup(struct bfa_fcport_s *fcport,
 				BFA_PL_EID_PORT_ST_CHANGE, 0, "Port Linkdown");
 		wwn2str(pwwn_buf, fcport->pwwn);
 		if (BFA_PORT_IS_DISABLED(fcport->bfa))
-			BFA_LOG(KERN_INFO, bfad, log_level,
+			BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 				"Base port offline: WWN = %s\n", pwwn_buf);
 		else
-			BFA_LOG(KERN_ERR, bfad, log_level,
+			BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 				"Base port (WWN = %s) "
 				"lost fabric connectivity\n", pwwn_buf);
 		break;
@@ -2349,10 +2349,10 @@ bfa_fcport_sm_linkup(struct bfa_fcport_s *fcport,
 		bfa_fcport_reset_linkinfo(fcport);
 		wwn2str(pwwn_buf, fcport->pwwn);
 		if (BFA_PORT_IS_DISABLED(fcport->bfa))
-			BFA_LOG(KERN_INFO, bfad, log_level,
+			BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 				"Base port offline: WWN = %s\n", pwwn_buf);
 		else
-			BFA_LOG(KERN_ERR, bfad, log_level,
+			BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 				"Base port (WWN = %s) "
 				"lost fabric connectivity\n", pwwn_buf);
 		break;
@@ -2363,10 +2363,10 @@ bfa_fcport_sm_linkup(struct bfa_fcport_s *fcport,
 		bfa_fcport_scn(fcport, BFA_PORT_LINKDOWN, BFA_FALSE);
 		wwn2str(pwwn_buf, fcport->pwwn);
 		if (BFA_PORT_IS_DISABLED(fcport->bfa))
-			BFA_LOG(KERN_INFO, bfad, log_level,
+			BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 				"Base port offline: WWN = %s\n", pwwn_buf);
 		else
-			BFA_LOG(KERN_ERR, bfad, log_level,
+			BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 				"Base port (WWN = %s) "
 				"lost fabric connectivity\n", pwwn_buf);
 		break;
@@ -2497,7 +2497,7 @@ bfa_fcport_sm_disabling(struct bfa_fcport_s *fcport,
 		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 				BFA_PL_EID_PORT_ENABLE, 0, "Port Enable");
 		wwn2str(pwwn_buf, fcport->pwwn);
-		BFA_LOG(KERN_INFO, bfad, log_level,
+		BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 			"Base port enabled: WWN = %s\n", pwwn_buf);
 		break;
 
@@ -2551,7 +2551,7 @@ bfa_fcport_sm_disabled(struct bfa_fcport_s *fcport,
 		bfa_plog_str(fcport->bfa->plog, BFA_PL_MID_HAL,
 				BFA_PL_EID_PORT_ENABLE, 0, "Port Enable");
 		wwn2str(pwwn_buf, fcport->pwwn);
-		BFA_LOG(KERN_INFO, bfad, log_level,
+		BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 			"Base port enabled: WWN = %s\n", pwwn_buf);
 		break;
 
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 1f93897..6797720 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -50,7 +50,7 @@ int		reqq_size, rspq_size, num_sgpgs;
 int		rport_del_timeout = BFA_FCS_RPORT_DEF_DEL_TIMEOUT;
 int		bfa_lun_queue_depth = BFAD_LUN_QUEUE_DEPTH;
 int		bfa_io_max_sge = BFAD_IO_MAX_SGE;
-int		log_level = 3; /* WARNING log level */
+int		bfa_log_level = 3; /* WARNING log level */
 int		ioc_auto_recover = BFA_TRUE;
 int		bfa_linkup_delay = -1;
 int		fdmi_enable = BFA_TRUE;
@@ -108,8 +108,8 @@ module_param(bfa_lun_queue_depth, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(bfa_lun_queue_depth, "Lun queue depth, default=32, Range[>0]");
 module_param(bfa_io_max_sge, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(bfa_io_max_sge, "Max io scatter/gather elements, default=255");
-module_param(log_level, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(log_level, "Driver log level, default=3, "
+module_param(bfa_log_level, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(bfa_log_level, "Driver log level, default=3, "
 				"Range[Critical:1|Error:2|Warning:3|Info:4]");
 module_param(ioc_auto_recover, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ioc_auto_recover, "IOC auto recovery, default=1, "
@@ -1112,7 +1112,7 @@ bfad_start_ops(struct bfad_s *bfad) {
 	} else
 		bfad_os_rport_online_wait(bfad);
 
-	BFA_LOG(KERN_INFO, bfad, log_level, "bfa device claimed\n");
+	BFA_LOG(KERN_INFO, bfad, bfa_log_level, "bfa device claimed\n");
 
 	return BFA_STATUS_OK;
 }
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 97f9b6c..d5ce234 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -337,7 +337,7 @@ extern int	num_sgpgs;
 extern int      rport_del_timeout;
 extern int      bfa_lun_queue_depth;
 extern int      bfa_io_max_sge;
-extern int      log_level;
+extern int      bfa_log_level;
 extern int      ioc_auto_recover;
 extern int      bfa_linkup_delay;
 extern int      msix_disable_cb;
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 8ca967d..fbad5e9 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -225,7 +225,8 @@ bfad_im_abort_handler(struct scsi_cmnd *cmnd)
 	}
 
 	bfa_trc(bfad, hal_io->iotag);
-	BFA_LOG(KERN_INFO, bfad, log_level, "scsi%d: abort cmnd %p iotag %x\n",
+	BFA_LOG(KERN_INFO, bfad, bfa_log_level,
+		"scsi%d: abort cmnd %p iotag %x\n",
 		im_port->shost->host_no, cmnd, hal_io->iotag);
 	(void) bfa_ioim_abort(hal_io);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
@@ -241,7 +242,7 @@ bfad_im_abort_handler(struct scsi_cmnd *cmnd)
 
 	cmnd->scsi_done(cmnd);
 	bfa_trc(bfad, hal_io->iotag);
-	BFA_LOG(KERN_INFO, bfad, log_level,
+	BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 		"scsi%d: complete abort 0x%p iotag 0x%x\n",
 		im_port->shost->host_no, cmnd, hal_io->iotag);
 	return SUCCESS;
@@ -260,7 +261,7 @@ bfad_im_target_reset_send(struct bfad_s *bfad, struct scsi_cmnd *cmnd,
 
 	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *) cmnd);
 	if (!tskim) {
-		BFA_LOG(KERN_ERR, bfad, log_level,
+		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 			"target reset, fail to allocate tskim\n");
 		rc = BFA_STATUS_FAILED;
 		goto out;
@@ -311,7 +312,7 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 
 	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *) cmnd);
 	if (!tskim) {
-		BFA_LOG(KERN_ERR, bfad, log_level,
+		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 				"LUN reset, fail to allocate tskim");
 		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 		rc = FAILED;
@@ -336,7 +337,7 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 
 	task_status = cmnd->SCp.Status >> 1;
 	if (task_status != BFI_TSKIM_STS_OK) {
-		BFA_LOG(KERN_ERR, bfad, log_level,
+		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 			"LUN reset failure, status: %d\n", task_status);
 		rc = FAILED;
 	}
@@ -380,7 +381,7 @@ bfad_im_reset_bus_handler(struct scsi_cmnd *cmnd)
 
 			task_status = cmnd->SCp.Status >> 1;
 			if (task_status != BFI_TSKIM_STS_OK) {
-				BFA_LOG(KERN_ERR, bfad, log_level,
+				BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 					"target reset failure,"
 					" status: %d\n", task_status);
 				err_cnt++;
@@ -460,7 +461,7 @@ bfa_fcb_itnim_free(struct bfad_s *bfad, struct bfad_itnim_s *itnim_drv)
 	fcid = bfa_fcs_itnim_get_fcid(&itnim_drv->fcs_itnim);
 	wwn2str(wwpn_str, wwpn);
 	fcid2str(fcid_str, fcid);
-	BFA_LOG(KERN_INFO, bfad, log_level,
+	BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 		"ITNIM FREE scsi%d: FCID: %s WWPN: %s\n",
 		port->im_port->shost->host_no,
 		fcid_str, wwpn_str);
@@ -589,7 +590,7 @@ void
 bfad_im_scsi_host_free(struct bfad_s *bfad, struct bfad_im_port_s *im_port)
 {
 	bfa_trc(bfad, bfad->inst_no);
-	BFA_LOG(KERN_INFO, bfad, log_level, "Free scsi%d\n",
+	BFA_LOG(KERN_INFO, bfad, bfa_log_level, "Free scsi%d\n",
 			im_port->shost->host_no);
 
 	fc_remove_host(im_port->shost);
@@ -1048,7 +1049,7 @@ bfad_im_itnim_work_handler(struct work_struct *work)
 			fcid2str(fcid_str, fcid);
 			list_add_tail(&itnim->list_entry,
 				&im_port->itnim_mapped_list);
-			BFA_LOG(KERN_INFO, bfad, log_level,
+			BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 				"ITNIM ONLINE Target: %d:0:%d "
 				"FCID: %s WWPN: %s\n",
 				im_port->shost->host_no,
@@ -1081,7 +1082,7 @@ bfad_im_itnim_work_handler(struct work_struct *work)
 			wwn2str(wwpn_str, wwpn);
 			fcid2str(fcid_str, fcid);
 			list_del(&itnim->list_entry);
-			BFA_LOG(KERN_INFO, bfad, log_level,
+			BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 				"ITNIM OFFLINE Target: %d:0:%d "
 				"FCID: %s WWPN: %s\n",
 				im_port->shost->host_no,
