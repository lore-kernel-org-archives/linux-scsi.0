From: <kgudipat@brocade.com>
Subject: [PATCH 06/32] bfa: Changes to support FDMI Driver Parameter
Date: Wed, 3 Mar 2010 17:43:19 -0800
Message-ID: <1267666999-21030-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:47648 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab0CDBna (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 20:43:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- Added a FCS function to be called during driver init, to set the FDMI Driver parameter.

	- fdmi.c: Created a disabled state when fdmi is disabled.

	- bfad.c:

		* Added fdmi_enable driver parameter.
		* Added support to call bfa_fcs_set_fdmi_param() to initialize fcs fdmi setting.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs.c             |   17 +++++++++++++++++
 drivers/scsi/bfa/bfad.c                |    3 +++
 drivers/scsi/bfa/fdmi.c                |   22 +++++++++++++++++++++-
 drivers/scsi/bfa/include/fcs/bfa_fcs.h |    2 ++
 4 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 7cb39a3..50120c2 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -127,6 +127,23 @@ bfa_fcs_driver_info_init(struct bfa_fcs_s *fcs,
 }
 
 /**
+ *      @brief
+ *              FCS FDMI Driver Parameter Initialization
+ *
+ *      @param[in]              fcs             FCS instance
+ *      @param[in]              fdmi_enable     TRUE/FALSE
+ *
+ *      @return None
+ */
+void
+bfa_fcs_set_fdmi_param(struct bfa_fcs_s *fcs, bfa_boolean_t fdmi_enable)
+{
+
+	fcs->fdmi_enabled = fdmi_enable;
+
+}
+
+/**
  * 		FCS instance cleanup and exit.
  *
  * 	param[in]		fcs			FCS instance
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index b52b773..8e2b2a2 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -53,6 +53,7 @@ static int      log_level = BFA_LOG_WARNING;
 static int      ioc_auto_recover = BFA_TRUE;
 static int      ipfc_enable = BFA_FALSE;
 static int      ipfc_mtu = -1;
+static int	fdmi_enable = BFA_TRUE;
 int 		bfa_lun_queue_depth = BFAD_LUN_QUEUE_DEPTH;
 int      	bfa_linkup_delay = -1;
 
@@ -74,6 +75,7 @@ module_param(log_level, int, S_IRUGO | S_IWUSR);
 module_param(ioc_auto_recover, int, S_IRUGO | S_IWUSR);
 module_param(ipfc_enable, int, S_IRUGO | S_IWUSR);
 module_param(ipfc_mtu, int, S_IRUGO | S_IWUSR);
+module_param(fdmi_enable, int, S_IRUGO | S_IWUSR);
 module_param(bfa_linkup_delay, int, S_IRUGO | S_IWUSR);
 
 /*
@@ -748,6 +750,7 @@ bfad_drv_init(struct bfad_s *bfad)
 	bfa_fcs_aen_init(&bfad->bfa_fcs, bfad->aen);
 	bfa_fcs_init(&bfad->bfa_fcs, &bfad->bfa, bfad, BFA_FALSE);
 	bfa_fcs_driver_info_init(&bfad->bfa_fcs, &driver_info);
+	bfa_fcs_set_fdmi_param(&bfad->bfa_fcs, fdmi_enable);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
 	bfad->bfad_flags |= BFAD_DRV_INIT_DONE;
diff --git a/drivers/scsi/bfa/fdmi.c b/drivers/scsi/bfa/fdmi.c
index df2a1e5..d76d922 100644
--- a/drivers/scsi/bfa/fdmi.c
+++ b/drivers/scsi/bfa/fdmi.c
@@ -116,6 +116,9 @@ static void     bfa_fcs_port_fdmi_sm_rpa_retry(struct bfa_fcs_port_fdmi_s *fdmi,
 			enum port_fdmi_event event);
 static void     bfa_fcs_port_fdmi_sm_online(struct bfa_fcs_port_fdmi_s *fdmi,
 			enum port_fdmi_event event);
+static void	bfa_fcs_port_fdmi_sm_disabled(struct bfa_fcs_port_fdmi_s *fdmi,
+			enum port_fdmi_event event);
+
 /**
  * 		Start in offline state - awaiting MS to send start.
  */
@@ -479,6 +482,20 @@ bfa_fcs_port_fdmi_sm_online(struct bfa_fcs_port_fdmi_s *fdmi,
 	}
 }
 
+/**
+ *  FDMI is disabled state.
+ */
+static void
+bfa_fcs_port_fdmi_sm_disabled(struct bfa_fcs_port_fdmi_s *fdmi,
+				enum port_fdmi_event event)
+{
+	struct bfa_fcs_port_s *port = fdmi->ms->port;
+
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+	bfa_trc(port->fcs, event);
+
+	/* No op State. It can only be enabled at Driver Init. */
+}
 
 /**
 *   RHBA : Register HBA Attributes.
@@ -1201,7 +1218,10 @@ bfa_fcs_port_fdmi_init(struct bfa_fcs_port_ms_s *ms)
 	struct bfa_fcs_port_fdmi_s *fdmi = &ms->fdmi;
 
 	fdmi->ms = ms;
-	bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+	if (ms->port->fcs->fdmi_enabled)
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_offline);
+	else
+		bfa_sm_set_state(fdmi, bfa_fcs_port_fdmi_sm_disabled);
 }
 
 void
diff --git a/drivers/scsi/bfa/include/fcs/bfa_fcs.h b/drivers/scsi/bfa/include/fcs/bfa_fcs.h
index 627669c..0396ec4 100644
--- a/drivers/scsi/bfa/include/fcs/bfa_fcs.h
+++ b/drivers/scsi/bfa/include/fcs/bfa_fcs.h
@@ -49,6 +49,7 @@ struct bfa_fcs_s {
 	struct bfa_trc_mod_s  *trcmod;	/*  tracing module */
 	struct bfa_aen_s      *aen;	/*  aen component */
 	bfa_boolean_t   vf_enabled;	/*  VF mode is enabled */
+	bfa_boolean_t   fdmi_enabled;   /*!< FDMI is enabled */
 	bfa_boolean_t min_cfg;		/* min cfg enabled/disabled */
 	u16        port_vfid;	/*  port default VF ID */
 	struct bfa_fcs_driver_info_s driver_info;
@@ -64,6 +65,7 @@ void bfa_fcs_init(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
 			bfa_boolean_t min_cfg);
 void bfa_fcs_driver_info_init(struct bfa_fcs_s *fcs,
 			struct bfa_fcs_driver_info_s *driver_info);
+void bfa_fcs_set_fdmi_param(struct bfa_fcs_s *fcs, bfa_boolean_t fdmi_enable);
 void bfa_fcs_exit(struct bfa_fcs_s *fcs);
 void bfa_fcs_trc_init(struct bfa_fcs_s *fcs, struct bfa_trc_mod_s *trcmod);
 void bfa_fcs_log_init(struct bfa_fcs_s *fcs, struct bfa_log_mod_s *logmod);
-- 
1.6.5.3

