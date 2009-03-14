From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 2/5] bfa: Brocade BFA FC SCSI driver (bfa)
Date: Sat, 14 Mar 2009 13:03:50 -0700
Message-ID: <200903142003.n2EK3o68031762@blc-10-6.brocade.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758109AbZCNUFK@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com
List-Id: linux-scsi@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

This patch contains code that interfaces to Brocade Fibre channel HBA
firmware/hardware. It is created using 2.6.29-rc8 kernel.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 bfa_auth.c           |  556 +++++++++++++++
 bfa_auth.h           |   95 ++
 bfa_callback_priv.h  |   57 +
 bfa_cb_ioim_macros.h |  213 +++++
 bfa_core.c           |  412 +++++++++++
 bfa_csdebug.c        |   55 +
 bfa_diag.c           |  898 ++++++++++++++++++++++++
 bfa_diag_priv.h      |   26 
 bfa_drv.c            |   57 +
 bfa_fabric.c         |  530 ++++++++++++++
 bfa_fabric.h         |  167 ++++
 bfa_fcdiag.c         |  419 +++++++++++
 bfa_fcpim.c          |  187 +++++
 bfa_fcpim.h          |  409 +++++++++++
 bfa_fcxp.c           |  713 +++++++++++++++++++
 bfa_fcxp_priv.h      |  135 +++
 bfa_fwimg_priv.h     |   31 
 bfa_hw_cb.c          |   60 +
 bfa_hw_ct.c          |   66 +
 bfa_intr.c           |  283 +++++++
 bfa_intr_priv.h      |  120 +++
 bfa_ioc.c            | 1844 +++++++++++++++++++++++++++++++++++++++++++++++++++
 bfa_ioc.h            |  250 ++++++
 bfa_iocfc.c          |  831 ++++++++++++++++++++++
 bfa_iocfc.h          |  117 +++
 bfa_ioim.c           | 1291 +++++++++++++++++++++++++++++++++++
 bfa_itnim.c          | 1145 +++++++++++++++++++++++++++++++
 bfa_log.c            |  344 +++++++++
 bfa_log_module.c     |  443 ++++++++++++
 bfa_lport.c          |  573 +++++++++++++++
 bfa_lport.h          |  180 ++++
 bfa_lps.c            |  722 +++++++++++++++++++
 bfa_lps_priv.h       |   38 +
 bfa_module.c         |   92 ++
 bfa_modules_priv.h   |   42 +
 bfa_os_inc.h         |  197 +++++
 bfa_port.c           | 1661 +++++++++++++++++++++++++++++++++++++++++++++
 bfa_port_priv.h      |   89 ++
 bfa_priv.h           |  120 +++
 bfa_rport.c          | 1113 ++++++++++++++++++++++++++++++
 bfa_rport.h          |  207 +++++
 bfa_sgpg.c           |  231 ++++++
 bfa_sgpg_priv.h      |   79 ++
 bfa_sm.c             |   38 +
 bfa_timer.c          |   90 ++
 bfa_trcmod_priv.h    |   63 +
 bfa_tskim.c          |  689 +++++++++++++++++++
 bfa_uf.c             |  339 +++++++++
 bfa_uf_priv.h        |   47 +
 bfa_vfapi.c          |  319 ++++++++
 bfa_vport.c          |  305 ++++++++
 bfa_vport.h          |   88 ++
 plog.c               |  183 +++++
 53 files changed, 19259 insertions(+)

diff -urpN orig/drivers/scsi/bfa/bfa_auth.c patch/drivers/scsi/bfa/bfa_auth.c
--- orig/drivers/scsi/bfa/bfa_auth.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_auth.c	2009-03-14 11:44:56.902704000 -0700
@@ -0,0 +1,556 @@
+/* 
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ * 
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <bfa_fabric.h>
+#include <bfa_lport.h>
+#include <bfa_vport.h>
+#include <bfa_auth.h>
+#include <bfa_priv.h>
+#include <aen/bfa_aen_audit.h>
+#include <aen/bfa_aen_port.h>
+
+#define BFA_AUTH_RETRY_DELAY		(2000)	/* milliseconds */
+
+#define TEST_PASSWORD "swnewsecret" /* HACK Alert !! HACK for testing */
+
+static u32 bfad_auth_power (u32 x, u32 n, u32 len);
+static void bfad_auth_decrypt_string (char *str, u32 in[], u32 len);
+static void bfa_auth_aen_audit_post(struct bfa_auth_s *auth,
+		 enum bfa_audit_aen_event event);
+
+#define GET_AUTH(_bfa) (&_bfa->fabric.auth)
+
+/**
+ *  bfa_auth_sm auth state machine functions
+ */
+
+/**
+ * Auth state machine events
+ */
+enum bfa_auth_event{
+	BFA_AUTH_SM_START 	= 1, /*  auth start from driver*/
+	BFA_AUTH_SM_STOP 	= 2, /*  auth stop  from driver*/
+	BFA_AUTH_SM_SUCCESS = 3, /*  auth sucess from FW*/
+	BFA_AUTH_SM_FAIL 	= 4, /*  auth failure from FW*/
+};
+
+bfa_fsm_state_decl(bfa_auth, uninit, struct bfa_auth_s, enum bfa_auth_event)
+bfa_fsm_state_decl(bfa_auth, success, struct bfa_auth_s, enum bfa_auth_event)
+bfa_fsm_state_decl(bfa_auth, fail, struct bfa_auth_s, enum bfa_auth_event)
+bfa_fsm_state_decl(bfa_auth, status_wait, struct bfa_auth_s, enum bfa_auth_event)
+
+static void
+bfa_auth_sm_uninit(struct bfa_auth_s * auth, enum bfa_auth_event evt)
+{
+  //bfa_trc(auth->fabric->bfa, evt);
+
+	switch (evt) {
+		case BFA_AUTH_SM_START:
+			bfa_fsm_set_state(auth, bfa_auth_sm_status_wait);
+			break;
+		default:
+			bfa_assert(0);
+	}
+
+	
+}
+static void
+bfa_auth_sm_uninit_entry(struct bfa_auth_s * auth)
+{
+}
+static void
+bfa_auth_sm_success(struct bfa_auth_s * auth, enum bfa_auth_event evt)
+{
+	switch (evt) {
+		case BFA_AUTH_SM_START:
+			bfa_fsm_set_state(auth, bfa_auth_sm_status_wait);
+			break;
+		case BFA_AUTH_SM_STOP:
+			bfa_fsm_set_state(auth, bfa_auth_sm_uninit);
+			break;
+		default:
+			bfa_assert(0);
+	}
+
+
+}
+static void
+bfa_auth_sm_success_entry(struct bfa_auth_s * auth)
+{
+}
+static void
+bfa_auth_sm_fail(struct bfa_auth_s * auth, enum bfa_auth_event evt)
+{
+	switch (evt) {
+		case BFA_AUTH_SM_START:
+			bfa_fsm_set_state(auth, bfa_auth_sm_status_wait);
+			break;
+		case BFA_AUTH_SM_STOP:
+			bfa_fsm_set_state(auth, bfa_auth_sm_uninit);
+			break;
+		default:
+			bfa_assert(0);
+	}
+
+
+}
+static void
+bfa_auth_sm_fail_entry(struct bfa_auth_s * auth)
+{
+}
+static void
+bfa_auth_sm_status_wait(struct bfa_auth_s * auth, enum bfa_auth_event evt)
+{
+	switch (evt) {
+		case BFA_AUTH_SM_START:
+			bfa_fsm_set_state(auth, bfa_auth_sm_status_wait);
+			break;
+		case BFA_AUTH_SM_STOP:
+			bfa_fsm_set_state(auth, bfa_auth_sm_uninit);
+			break;
+		case BFA_AUTH_SM_SUCCESS:
+			bfa_fsm_set_state(auth, bfa_auth_sm_success);
+			break;
+		case BFA_AUTH_SM_FAIL:
+			bfa_fsm_set_state(auth, bfa_auth_sm_fail);
+			break;
+		default:
+			bfa_assert(0);
+	}
+
+
+}
+static void
+bfa_auth_sm_status_wait_entry(struct bfa_auth_s * auth)
+{
+}
+
+
+/**
+ *  auth internal functions.
+ */
+
+
+/**
+ * @param [in] x   - value to be encrypted/decrypted
+ * @param [in] n   - pubic[encryption]/private[decryption] key
+ * @param [in] len - key length
+ * @retval output
+ */
+static u32 
+bfad_auth_power (u32 x, u32 n, u32 len)
+{
+        long result = 1;
+        while ( n) {
+                if ( n & 1) {
+                        result = (result * x) % len;
+                        n = n-1;
+                }
+                x = (x*x) % len;
+                n = n/2;
+        }
+        return result;
+}
+
+/**
+ * @param [out] str - decrypted string
+ * @param [in]  in  - arry of values encrypted
+ * @param [in]  len - length of the array in
+ * @retval none
+ */
+static void
+bfad_auth_decrypt_string (char *str, u32 in[], u32 len)
+{
+        u32 result;
+        size_t   i=0;
+
+        while ( i < len) {
+                result = bfad_auth_power (in[i], PRIVATE_KEY, KEY_LEN);
+                str[i++] = result & 0xff;
+        }
+
+}
+
+
+/*
+ * @param[in] auth  - auth
+ * @param[in] event - BFA_AUDIT_AEN_AUTH_DISABLE/BFA_AUDIT_AEN_AUTH_ENABLE
+ * @return none
+ */
+static void
+bfa_auth_aen_audit_post(struct bfa_auth_s *auth, enum bfa_audit_aen_event event)
+{
+	union bfa_aen_data_u  aen_data;
+
+	struct bfa_log_mod_s *logmod = auth->fabric->bfa->logm;
+	wwn_t		pwwn = auth->fabric->bport.port_cfg.pwwn;
+	char		*pwwn_ptr = NULL;
+
+
+	switch (event) {
+	case BFA_AUDIT_AEN_AUTH_ENABLE:
+		bfa_log(logmod, BFA_AEN_AUDIT_AUTH_ENABLE, pwwn_ptr);
+		break;
+	case BFA_AUDIT_AEN_AUTH_DISABLE:
+		bfa_log(logmod, BFA_AEN_AUDIT_AUTH_DISABLE, pwwn_ptr);
+		break;
+	default: 
+		break;
+	}
+
+	aen_data.audit.pwwn = pwwn;
+}
+
+/*
+ * @param[in] auth  - auth
+ * @param[in] event - BFA_PORT_AEN_AUTH_OFF/BFA_PORT_AEN_AUTH_ON
+ * @return none
+ */
+static void
+bfa_auth_aen_post(struct bfa_auth_s *auth, enum bfa_port_aen_event event)
+{
+	union bfa_aen_data_u  aen_data;
+	struct bfa_log_mod_s *logmod = auth->fabric->bfa->logm;
+	wwn_t		pwwn = auth->fabric->bport.port_cfg.pwwn;
+	char		*pwwn_ptr = NULL;
+
+
+	switch (event) {
+	case BFA_PORT_AEN_AUTH_ON:
+		bfa_log(logmod, BFA_AEN_PORT_AUTH_ON, pwwn_ptr);
+		break;
+	case BFA_PORT_AEN_AUTH_OFF:
+		bfa_log(logmod, BFA_AEN_PORT_AUTH_OFF, pwwn_ptr);
+		break;
+	default: 
+		break;
+	}
+
+	aen_data.port.pwwn = pwwn;
+}
+
+
+/**
+ *  auth public functions
+ */
+/**
+ * @param[in] bfa   - bfa
+ * @param[in] policy - enable/disable
+ *
+ * @return : BFA_STATUS_OK if successful, else BFA_STATUS_FAILED for failure
+ */
+bfa_status_t
+bfa_auth_get_attr(struct bfa_s *bfa, struct bfa_auth_attr_s *attr)
+{
+	struct bfa_auth_s *auth = GET_AUTH(bfa);
+	bfa_os_memset(attr, 0, sizeof(struct bfa_auth_attr_s));
+
+	if (auth->algo >= BFA_AUTH_ALGO_MD5 &&
+	    auth->algo <= BFA_AUTH_ALGO_SM)
+		attr->algo = auth->algo;
+	else
+		attr->algo = auth->algo = BFA_AUTH_ALGO_MD5;
+
+	if (auth->group == FC_AUTH_DH_GID_0_DHG_NULL) {
+		attr->dh_grp = BFA_AUTH_GROUP_DHNULL;
+	}
+	else if (auth->group == FC_AUTH_DH_GID_1_DHG_1024) {
+		attr->dh_grp = BFA_AUTH_GROUP_DH1024;
+	}
+	else if (auth->group == FC_AUTH_DH_GID_2_DHG_1280) {
+		attr->dh_grp = BFA_AUTH_GROUP_DH1280;
+	}
+	else if (auth->group == FC_AUTH_DH_GID_3_DHG_1536) {
+		attr->dh_grp = BFA_AUTH_GROUP_DH1536;
+	}
+	else { /* Use the default value as we support only the DHNULL group */
+		attr->dh_grp = BFA_AUTH_GROUP_DHNULL;
+	}
+
+	if (auth->policy == BFA_FALSE)
+		attr->status = BFA_AUTH_STATUS_NONE;
+	else
+		attr->status = auth->status;
+	if (auth->secret_len > 0)
+		attr->secret_set = BFA_TRUE;
+	else 
+		attr->secret_set = BFA_FALSE;
+	attr->rjt_code = auth->rjt_code;
+	attr->rjt_code_exp = auth->rjt_code_exp;
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * @param[in] bfa 	 - bfa
+ * @param[in] policy - enable/disable
+ *
+ * @return : BFA_STATUS_OK
+ */
+bfa_status_t
+bfa_auth_set_policy(struct bfa_s *bfa, bfa_boolean_t policy)
+{
+	struct bfa_auth_s *auth = GET_AUTH(bfa);
+	struct bfa_pport_attr_s 	attr;
+	int			status;
+
+	auth->fabric = &bfa->fabric;
+
+	if (auth->algo < BFA_AUTH_ALGO_MD5 || auth->algo > BFA_AUTH_ALGO_SM)
+		auth->algo = BFA_AUTH_ALGO_MD5; 
+
+	status =  auth->status;
+	if ((status < BFA_AUTH_UNINIT || status > BFA_AUTH_FAILED)) {
+		//bfa_sm_set_state(auth, bfa_auth_sm_uninit);
+	}
+
+	/* 
+	 * If the link is already up and authentication is enabled now,
+	 * and authentication is not already successful,
+	 * then restart authentication process
+	 */
+	if (auth->policy == BFA_FALSE && policy == BFA_TRUE &&
+			(auth->status != FC_AUTH_STATE_SUCCESS) &&
+			auth->fabric->is_auth) {
+		bfa_pport_get_attr(bfa, &attr);
+		if ( attr.port_state == BFA_PPORT_ST_LINKUP)
+			bfa_auth_reinit(bfa);
+	}
+
+	auth->policy = policy;
+	bfa->fabric.auth_reqd = policy;
+	bfa_vf_auth_update(&bfa->fabric);
+	bfa_auth_aen_audit_post(auth, (policy == BFA_TRUE) ? BFA_AUDIT_AEN_AUTH_ENABLE : BFA_AUDIT_AEN_AUTH_DISABLE);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * @param[in] bfa 	 - bfa
+ * @param[in] policy - enable/disable
+ *
+ * @return : enum bfa_auth_status
+ */
+enum bfa_auth_status
+bfa_auth_get_status(struct bfa_s *bfa)
+{
+	if (bfa->fabric.auth.policy == BFA_FALSE)
+		return BFA_AUTH_STATUS_NONE;
+	else
+		return GET_AUTH(bfa)->status;
+
+}
+
+/**
+ * @param[in] bfa - bfa
+ * @param[in] algo - authentication algorithm
+ *
+ * @return : BFA_STATUS_OK if successful, else BFA_STATUS_FAILED
+ */
+bfa_status_t
+bfa_auth_set_algo(struct bfa_s *bfa, enum bfa_auth_algo algo)
+{
+	struct bfa_auth_s *auth = GET_AUTH(bfa);
+
+	auth->algo = algo;
+	bfa_vf_auth_update(&bfa->fabric);
+
+	return BFA_STATUS_OK;
+	
+}
+
+/**
+ * @param[in] 	bfa  - bfa
+ * @param[out] 	stats - pointer to the authentication statistics of the bfa
+ *
+ * @return : BFA_STATUS_OK
+ */
+bfa_status_t
+bfa_auth_get_stats(struct bfa_s *bfa, struct bfa_auth_stats_s *stats)
+{
+	struct bfa_auth_s *auth = GET_AUTH(bfa);
+
+	memcpy(stats, &auth->stats, sizeof (struct bfa_auth_stats_s));
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * @param[in] bfa  - bfa
+ * @param[in] group - DH Group
+ *
+ * @return : BFA_TRUE if successful else BFA_FALSE
+ */
+bfa_status_t
+bfa_auth_set_dh_group(struct bfa_s *bfa, int group)
+{
+	if (group == FC_AUTH_DH_GID_0_DHG_NULL) {
+		bfa->fabric.auth.group = group;
+		return BFA_STATUS_OK;
+	}
+	bfa_vf_auth_update(&bfa->fabric);
+
+	return BFA_STATUS_FAILED;
+}
+
+/**
+ * @param[in] bfa  - bfa
+ * @param[in] secret- secret string
+ *
+* @return : BFA_TRUE
+ */
+bfa_status_t
+bfa_auth_set_secretstring(struct bfa_s *bfa, char *secret)
+{
+	u32 len;
+
+	len = strlen(secret);
+	strncpy(bfa->fabric.auth.secret, secret, len);
+	bfa->fabric.auth.secret[len] = '\0';
+	bfa->fabric.auth.secret_len = len & 0xff;
+	bfa_vf_auth_update(&bfa->fabric);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * @param[in] bfa  - bfa
+ * @param[in] secret- secret string
+ *
+* @return : BFA_TRUE
+ */
+bfa_status_t
+bfa_auth_set_secretstring_encrypt(struct bfa_s *bfa, u32 secret[],
+	u32 len)
+{
+	bfad_auth_decrypt_string (bfa->fabric.auth.secret, secret, len);
+	bfa->fabric.auth.secret[len] = '\0';
+	bfa->fabric.auth.secret_len = len & 0xff;
+	bfa_vf_auth_update(&bfa->fabric);
+	return BFA_STATUS_OK;
+}
+
+/**
+ * @param[in] bfa  - bfa
+ * @param[in] src   - secret source
+ *
+ * @return : BFA_STATUS_OK if successful, otherwise BFA_STATUS_FAILED
+ */
+bfa_status_t
+bfa_auth_set_secretsource(struct bfa_s *bfa, enum bfa_auth_secretsource src)
+{
+    struct bfa_auth_s  *auth = GET_AUTH(bfa);
+
+	if (src == BFA_AUTH_SECSRC_LOCAL) {
+		auth->source = src;
+		return BFA_STATUS_OK;
+	}
+	bfa_vf_auth_update(&bfa->fabric);
+	return BFA_STATUS_FAILED;
+}
+
+/**
+ * @param[in] bfa  - bfa
+ *
+ * @return : BFA_STATUS_OK
+ */
+bfa_status_t
+bfa_auth_reset_stats(struct bfa_s *bfa)
+{
+	struct bfa_auth_s *auth = GET_AUTH(bfa);
+
+	memset(&auth->stats, 0x00, sizeof (struct bfa_auth_stats_s));
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * @param[in] bfa  - bfa
+ *
+ * @return : BFA_STATUS_FAILED
+ */
+bfa_status_t
+bfa_auth_reinit(struct bfa_s *bfa)
+{
+	bfa_auth_start(&bfa->fabric);
+	return BFA_STATUS_OK;
+}
+
+
+/*
+ * @param[in] fabric - fabric
+ * @return - none
+ */
+void
+bfa_auth_start(struct bfa_fabric_s *fabric)
+{
+    struct bfi_fabric_setauth_req_s req;
+
+    req.mh.msg_id = BFI_FABRIC_H2I_SETAUTH;
+    req.fw_handle = fabric->vf_id;
+    req.algo = fabric->auth.algo;
+    req.group = fabric->auth.group;
+    req.policy = fabric->auth.policy;
+    memcpy(req.secret, fabric->auth.secret, fabric->auth.secret_len);
+	req.secret_len = fabric->auth.secret_len;
+
+	bfi_h2i_set(req.mh, BFI_MC_FABRIC, BFI_FABRIC_H2I_AUTH_START,
+			bfa_lpuid(fabric->bfa));
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(fabric->bfa, fabric->reqq);
+
+	bfa_fsm_send_event(&fabric->auth, BFA_AUTH_SM_START);
+
+}
+void
+bfa_auth_start_rsp(struct bfa_fabric_s *fabric)
+{
+	enum bfa_port_aen_event evt = BFA_PORT_AEN_ONLINE;//TODO
+	bfa_auth_aen_post(&fabric->auth, evt);
+	if(fabric->auth.status)
+	{
+		bfa_fsm_send_event(&fabric->auth, BFA_AUTH_SM_SUCCESS);
+	}else
+	{
+		bfa_fsm_send_event(&fabric->auth, BFA_AUTH_SM_FAIL);
+	}
+}
+void
+bfa_auth_stop(struct bfa_fabric_s *fabric)
+{
+	struct bfa_auth_s *auth = &fabric->auth;
+
+	//bfa_trc(fabric->bfa, BFA_AUTH_STOP);
+
+	if (auth->status >= BFA_AUTH_UNINIT && auth->status <= BFA_AUTH_FAILED) {
+		//bfa_fabric_sm_send_event(fabric, BFA_AUTH_STOP);
+	}
+	bfa_fsm_send_event(&fabric->auth, BFA_AUTH_SM_STOP);
+}
+
+
+/* vim:set ts=4 sw=4 noet ff=unix ft=c tw=78 ai: */
+
+/*
+ * emacs.Local Variables:
+ * emacs.mode:C
+ * emacs.c-basic-offset:4
+ * emacs.indent-tabs-mode:t
+ * emacs.tab-width:4
+ * emacs.End:
+ */
diff -urpN orig/drivers/scsi/bfa/bfa_auth.h patch/drivers/scsi/bfa/bfa_auth.h
--- orig/drivers/scsi/bfa/bfa_auth.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_auth.h	2009-03-14 11:44:56.910837000 -0700
@@ -0,0 +1,95 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  BFA Fabric interfaces
+ */
+
+#ifndef __BFA_AUTH_H__
+#define __BFA_AUTH_H__
+
+#include <defs/bfa_defs_vf.h>
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_auth.h>
+#include <protocol/fc_sp.h>
+
+
+/**
+ * P R I V A T E   D E F I N I T I O N S
+ * - Used & visible to BFA AUTH module alone (private)
+ */
+struct bfa_fabric_s;
+
+
+
+struct bfa_auth_s {
+	bfa_boolean_t   policy;	/*  authentication enabled/disabled */
+	bfa_fsm_t       fsm;    /*  BFA auth state machine */
+	enum bfa_auth_status status;	/*  authentication status */
+	auth_rjt_codes_t  rjt_code;	/*  auth reject status */
+	auth_rjt_code_exps_t  rjt_code_exp;	/*  auth reject reason */
+	enum bfa_auth_algo algo;	/*  Authentication algorithm */
+	struct bfa_auth_stats_s stats;	/*  Statistics */
+	auth_dh_gid_t   group;	/*  DH(diffie-hellman) Group */
+	enum bfa_auth_secretsource source;	/*  Secret source */
+	char            secret[BFA_AUTH_SECRET_STRING_LEN];
+				/*  secret string */
+	u8         secret_len;
+				/*  secret string length */
+	u8         nretries;
+				/*  number of retries */
+	struct bfa_fabric_s *fabric;/*  pointer to fabric */
+	u8         sentcode;	/*  pointer to response data */
+	u8        *response;	/*  pointer to response data */
+};
+typedef struct bfa_auth_s bfa_auth_t;
+/**
+ *  P R O T E C T E D    D E F I N I T I O N S
+ * - Used & visible to BFA peer modules alone (private)
+ */
+/**
+ *  P U B L I C    D E F I N I T I O N S
+ * - Used & visible to driver
+ */
+
+/**
+ * bfa fcs authentication public functions
+ */
+bfa_status_t    bfa_auth_get_attr(struct bfa_s *port,
+				      struct bfa_auth_attr_s *attr);
+bfa_status_t    bfa_auth_set_policy(struct bfa_s *port,
+					bfa_boolean_t policy);
+enum bfa_auth_status bfa_auth_get_status(struct bfa_s *port);
+bfa_status_t    bfa_auth_set_algo(struct bfa_s *port,
+				      enum bfa_auth_algo algo);
+bfa_status_t    bfa_auth_get_stats(struct bfa_s *port,
+				       struct bfa_auth_stats_s *stats);
+bfa_status_t    bfa_auth_set_dh_group(struct bfa_s *port, int group);
+bfa_status_t    bfa_auth_set_secretstring(struct bfa_s *port,
+					      char *secret);
+bfa_status_t    bfa_auth_set_secretstring_encrypt(struct bfa_s *port,
+					      u32 secret[], u32 len);
+bfa_status_t    bfa_auth_set_secretsource(struct bfa_s *port,
+					      enum bfa_auth_secretsource src);
+bfa_status_t    bfa_auth_reset_stats(struct bfa_s *port);
+bfa_status_t    bfa_auth_reinit(struct bfa_s *port);
+void bfa_auth_stop(struct bfa_fabric_s *fabric);
+void bfa_auth_start(struct bfa_fabric_s *fabric);
+void bfa_auth_start_rsp(struct bfa_fabric_s *fabric);
+#endif //__BFA_AUTH_H__
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_callback_priv.h patch/drivers/scsi/bfa/bfa_callback_priv.h
--- orig/drivers/scsi/bfa/bfa_callback_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_callback_priv.h	2009-03-14 11:44:56.918452000 -0700
@@ -0,0 +1,57 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_CALLBACK_PRIV_H__
+#define __BFA_CALLBACK_PRIV_H__
+
+#include <cs/bfa_q.h>
+
+typedef void    (*bfa_cb_cbfn_t) (void *cbarg, bfa_boolean_t complete);
+
+/**
+ * Generic BFA callback element.
+ */
+struct bfa_cb_qe_s {
+	struct list_head         qe;
+	bfa_cb_cbfn_t  cbfn;
+	bfa_boolean_t   once;
+	u32		rsvd;
+	void           *cbarg;
+};
+
+#define bfa_cb_queue(__bfa, __hcb_qe, __cbfn, __cbarg) do {		\
+	(__hcb_qe)->cbfn  = (__cbfn );      \
+	(__hcb_qe)->cbarg = (__cbarg );      \
+	list_add_tail(&(__hcb_qe)->qe, &(__bfa)->comp_q);      \
+} while (0)
+
+#define bfa_cb_dequeue(__hcb_qe)	list_del(&(__hcb_qe)->qe)
+
+#define bfa_cb_queue_once(__bfa, __hcb_qe, __cbfn, __cbarg) do {	\
+	(__hcb_qe)->cbfn  = (__cbfn );      \
+	(__hcb_qe)->cbarg = (__cbarg );      \
+	if (!(__hcb_qe)->once) {      \
+		list_add_tail((__hcb_qe), &(__bfa)->comp_q);      \
+		(__hcb_qe)->once = BFA_TRUE;				\
+	}								\
+} while (0)
+
+#define bfa_cb_queue_done(__hcb_qe) do {				\
+	(__hcb_qe)->once = BFA_FALSE;					\
+} while (0)
+
+#endif /* __BFA_CALLBACK_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_cb_ioim_macros.h patch/drivers/scsi/bfa/bfa_cb_ioim_macros.h
--- orig/drivers/scsi/bfa/bfa_cb_ioim_macros.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_cb_ioim_macros.h	2009-03-14 11:44:56.926413000 -0700
@@ -0,0 +1,213 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_cb_ioim_macros.h BFA IOIM driver interface macros.
+ */
+
+#ifndef __BFA_HCB_IOIM_MACROS_H__
+#define __BFA_HCB_IOIM_MACROS_H__
+
+#include <bfa_os_inc.h>
+/*
+ * #include <linux/dma-mapping.h>
+ *
+ * #include <scsi/scsi.h> #include <scsi/scsi_cmnd.h> #include
+ * <scsi/scsi_device.h> #include <scsi/scsi_host.h>
+ */
+#include "bfad_im_compat.h"
+
+/*
+ * task attribute values in FCP-2 FCP_CMND IU
+ */
+#define SIMPLE_Q    0
+#define HEAD_OF_Q   1
+#define ORDERED_Q   2
+#define ACA_Q       4
+#define UNTAGGED    5
+
+static inline lun_t
+bfad_int_to_lun(u32 luno)
+{
+	union {
+		u16        scsi_lun[4];
+		lun_t           bfa_lun;
+	} lun;
+
+	lun.bfa_lun     = 0;
+	lun.scsi_lun[0] = bfa_os_htons(luno);
+
+	return (lun.bfa_lun);
+}
+
+/**
+ * Get LUN for the I/O request
+ */
+#define bfa_cb_ioim_get_lun(__dio)	\
+	bfad_int_to_lun(((struct scsi_cmnd *)__dio)->device->lun)
+
+/**
+ * Get CDB for the I/O request
+ */
+static inline u8 *
+bfa_cb_ioim_get_cdb(struct bfad_ioim_s *dio)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+
+	return ((u8 *) cmnd->cmnd);
+}
+
+/**
+ * Get I/O direction (read/write) for the I/O request
+ */
+static inline fcp_iodir_t
+bfa_cb_ioim_get_iodir(struct bfad_ioim_s *dio)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+	enum dma_data_direction dmadir;
+
+	dmadir = cmnd->sc_data_direction;
+	if (dmadir == DMA_TO_DEVICE)
+		return FCP_IODIR_WRITE;
+	else if (dmadir == DMA_FROM_DEVICE)
+		return FCP_IODIR_READ;
+	else
+		return FCP_IODIR_NONE;
+}
+
+/**
+ * Get IO size in bytes for the I/O request
+ */
+static inline u32
+bfa_cb_ioim_get_size(struct bfad_ioim_s *dio)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+
+	return (scsi_bufflen(cmnd));
+}
+
+/**
+ * Get timeout for the I/O request
+ */
+static inline u8
+bfa_cb_ioim_get_timeout(struct bfad_ioim_s *dio)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+	/*
+	 * TBD: need a timeout for scsi passthru
+	 */
+	if (cmnd->device->host == NULL)
+		return 4;
+
+	return 0;
+}
+
+/**
+ * Get SG element for the I/O request given the SG element index
+ */
+static inline union bfi_addr_u
+bfa_cb_ioim_get_sgaddr(struct bfad_ioim_s *dio, int sgeid)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+	struct scatterlist *sge;
+	u64        addr;
+
+	if (scsi_sg_count(cmnd)) {
+		sge = (struct scatterlist *)scsi_sglist(cmnd) + sgeid;
+		addr = (u64) sg_dma_address(sge);
+	} else {
+		addr = (u64) cmnd->SCp.dma_handle;
+	}
+
+	return (*(union bfi_addr_u *) &addr);
+}
+
+static inline u32
+bfa_cb_ioim_get_sglen(struct bfad_ioim_s *dio, int sgeid)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+	struct scatterlist *sge;
+	u32        len;
+
+	if (scsi_sg_count(cmnd)) {
+		sge = (struct scatterlist *)scsi_sglist(cmnd) + sgeid;
+		len = sg_dma_len(sge);
+	} else {
+		len = scsi_bufflen(cmnd);
+	}
+
+	return len;
+}
+
+/**
+ * Get Command Reference Number for the I/O request. 0 if none.
+ */
+static inline u8
+bfa_cb_ioim_get_crn(struct bfad_ioim_s *dio)
+{
+	return 0;
+}
+
+/**
+ * Get SAM-3 priority for the I/O request. 0 is default.
+ */
+static inline u8
+bfa_cb_ioim_get_priority(struct bfad_ioim_s *dio)
+{
+	return 0;
+}
+
+/**
+ * Get task attributes for the I/O request. Default is FCP_TASK_ATTR_SIMPLE(0).
+ */
+static inline u8
+bfa_cb_ioim_get_taskattr(struct bfad_ioim_s *dio)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+	u8         task_attr = UNTAGGED;
+
+	if (cmnd->device->tagged_supported) {
+		switch (cmnd->tag) {
+		case HEAD_OF_QUEUE_TAG:
+			task_attr = HEAD_OF_Q;
+			break;
+		case ORDERED_QUEUE_TAG:
+			task_attr = ORDERED_Q;
+			break;
+		default:
+			task_attr = SIMPLE_Q;
+			break;
+		}
+	}
+
+	return task_attr;
+}
+
+/**
+ * Get CDB length in bytes for the I/O request. Default is FCP_CMND_CDB_LEN(16).
+ */
+static inline u8
+bfa_cb_ioim_get_cdblen(struct bfad_ioim_s *dio)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+
+	return (cmnd->cmd_len);
+}
+
+
+
+#endif /* __BFA_HCB_IOIM_MACROS_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_core.c patch/drivers/scsi/bfa/bfa_core.c
--- orig/drivers/scsi/bfa/bfa_core.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_core.c	2009-03-14 11:44:56.934591000 -0700
@@ -0,0 +1,412 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <defs/bfa_defs_pci.h>
+#include <cs/bfa_debug.h>
+#include <bfa_iocfc.h>
+#include <bfa_fabric.h>
+
+#define DEF_CFG_NUM_FABRICS         1
+#define DEF_CFG_NUM_LPORTS          256
+#define DEF_CFG_NUM_CQS             4
+#define DEF_CFG_NUM_IOIM_REQS       (512)
+#define DEF_CFG_NUM_TSKIM_REQS      128
+#define DEF_CFG_NUM_FCXP_REQS       64
+#define DEF_CFG_NUM_UF_BUFS         64
+#define DEF_CFG_NUM_RPORTS          1024
+#define DEF_CFG_NUM_ITNIMS          (DEF_CFG_NUM_RPORTS)
+#define DEF_CFG_NUM_ITNTMS            256
+
+#define DEF_CFG_NUM_SGPGS           512
+#define DEF_CFG_NUM_REQQ_ELEMS      256
+#define DEF_CFG_NUM_RSPQ_ELEMS      64
+#define DEF_CFG_NUM_SBOOT_TGTS      16
+#define DEF_CFG_NUM_SBOOT_LUNS      16
+
+/**
+ *  hal_api
+ */
+
+/**
+ * Use this function query the memory requirement of the BFA library.
+ * This function needs to be called before bfa_attach() to get the
+ * memory required of the BFA layer for a given driver configuration.
+ *
+ * This call will fail, if the cap is out of range compared to pre-defined
+ * values within the BFA library
+ *
+ * @param[in] cfg - 	pointer to bfa_ioc_cfg_t. Driver layer should indicate
+ * 			its configuration in this structure.
+ *			The default values for struct bfa_iocfc_cfg_s can be
+ *			fetched using bfa_cfg_get_default() API.
+ *
+ * 			If cap's boundary check fails, the library will use
+ *			the default bfa_cap_t values (and log a warning msg).
+ *
+ * @param[out] meminfo - pointer to bfa_meminfo_t. This content
+ * 			indicates the memory type (see bfa_mem_type_t) and
+ *			amount of memory required.
+ *
+ *			Driver should allocate the memory, populate the
+ *			starting address for each block and provide the same
+ *			structure as input parameter to bfa_attach() call.
+ *
+ * @return void
+ *
+ * Special Considerations: @note
+ */
+void
+bfa_cfg_get_meminfo(struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo)
+{
+	int             i;
+	u32        km_len = 0, dm_len = 0;
+
+	bfa_assert((cfg != NULL) && (meminfo != NULL));
+
+	bfa_os_memset((void *)meminfo, 0, sizeof(struct bfa_meminfo_s));
+	meminfo->meminfo[BFA_MEM_TYPE_KVA - 1].mem_type =
+		BFA_MEM_TYPE_KVA;
+	meminfo->meminfo[BFA_MEM_TYPE_DMA - 1].mem_type =
+		BFA_MEM_TYPE_DMA;
+
+	bfa_iocfc_meminfo(cfg, &km_len, &dm_len);
+
+	for (i = 0; hal_mods[i]; i++)
+		hal_mods[i]->meminfo(cfg, &km_len, &dm_len);
+
+	bfa_com_meminfo(cfg->drvcfg.min_cfg, &dm_len);
+
+	meminfo->meminfo[BFA_MEM_TYPE_KVA - 1].mem_len = km_len;
+	meminfo->meminfo[BFA_MEM_TYPE_DMA - 1].mem_len = dm_len;
+}
+
+/**
+ * Use this function to do attach the driver instance with the BFA
+ * library. This function will not trigger any HW initialization
+ * process (which will be done in bfa_init() call)
+ *
+ * This call will fail, if the cap is out of range compared to
+ * pre-defined values within the BFA library
+ *
+ * @param[out]	bfa	Pointer to bfa_t.
+ * @param[in]	bfad 	Opaque handle back to the driver's IOC structure
+ * @param[in]	cfg	Pointer to bfa_ioc_cfg_t. Should be same structure
+ * 			that was used in bfa_cfg_get_meminfo().
+ * @param[in] 	meminfo Pointer to bfa_meminfo_t. The driver should
+ * 			use the bfa_cfg_get_meminfo() call to
+ * 			find the memory blocks required, allocate the
+ * 			required memory and provide the starting addresses.
+ * @param[in] 	pcidev	pointer to struct bfa_pcidev_s
+ *
+ * @return
+ * void
+ *
+ * Special Considerations:
+ *
+ * @note
+ *
+ */
+void
+bfa_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+	       struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	int             i;
+	struct bfa_mem_elem_s *melem;
+
+	bfa_assert((cfg != NULL) && (meminfo != NULL));
+
+	/**
+	 * initialize all memory pointers for iterative allocation
+	 */
+	for (i = 0; i < BFA_MEM_TYPE_MAX; i++) {
+		melem = meminfo->meminfo + i;
+		melem->kva_curp = melem->kva;
+		melem->dma_curp = melem->dma;
+	}
+
+	bfa_iocfc_attach(bfa, bfad, cfg, meminfo, pcidev);
+
+	for (i = 0; hal_mods[i]; i++)
+		hal_mods[i]->attach(bfa, bfad, cfg, meminfo, pcidev);
+
+	bfa_com_attach(bfa, meminfo, cfg->drvcfg.min_cfg);
+}
+
+/**
+ * Use this function to delete a BFA IOC. IOC should be stopped (by
+ * calling bfa_stop()) before this function call.
+ *
+ * @param[in] bfa - pointer to bfa_t.
+ *
+ * @return
+ * void
+ *
+ * Special Considerations:
+ *
+ * @note
+ */
+void
+bfa_detach(struct bfa_s *bfa)
+{
+	int	i;
+
+	for (i = 0; hal_mods[i]; i++)
+		hal_mods[i]->detach(bfa);
+
+	bfa_iocfc_detach(bfa);
+}
+
+
+void
+bfa_init_trc(struct bfa_s *bfa, struct bfa_trc_mod_s *trcmod)
+{
+	bfa->trcmod = trcmod;
+}
+
+
+void
+bfa_init_log(struct bfa_s *bfa, struct bfa_log_mod_s *logmod)
+{
+	bfa->logm = logmod;
+}
+
+
+void
+bfa_init_aen(struct bfa_s *bfa, struct bfa_aen_s *aen)
+{
+	bfa->aen = aen;
+}
+
+void
+bfa_init_plog(struct bfa_s *bfa, struct bfa_plog_s *plog)
+{
+	bfa->plog = plog;
+}
+
+/**
+ * Initialize IOC.
+ *
+ * This function will return immediately, when the IOC initialization is
+ * completed, the bfa_cb_init() will be called.
+ *
+ * @param[in]	bfa	instance
+ *
+ * @return void
+ *
+ * Special Considerations:
+ *
+ * @note
+ * When this function returns, the driver should register the interrupt service
+ * routine(s) and enable the device interrupts. If this is not done,
+ * bfa_cb_init() will never get called
+ */
+void
+bfa_init(struct bfa_s *bfa)
+{
+	bfa_iocfc_init(bfa);
+}
+
+/**
+ * Use this function initiate the IOC configuration setup. This function
+ * will return immediately.
+ *
+ * @param[in]	bfa	instance
+ *
+ * @return None
+ */
+void
+bfa_start(struct bfa_s *bfa)
+{
+	bfa_iocfc_start(bfa);
+}
+void
+bfa_driver_info_init(struct bfa_s *bfa, struct bfa_driver_info_s *driver_info)
+{
+    memcpy(&bfa->driver_info, driver_info, sizeof(struct bfa_driver_info_s));
+	bfa->fabric.bfa = bfa;
+    bfa_fabric_psymb_init(&bfa->fabric);
+}
+/**
+ * Use this function quiese the IOC. This function will return immediately,
+ * when the IOC is actually stopped, the bfa_cb_stop() will be called.
+ *
+ * @param[in] 	bfa - pointer to bfa_t.
+ *
+ * @return None
+ *
+ * Special Considerations:
+ * bfa_cb_stop() could be called before or after bfa_stop() returns.
+ *
+ * @note
+ * In case of any failure, we could handle it automatically by doing a
+ * reset and then succeed the bfa_stop() call.
+ */
+void
+bfa_stop(struct bfa_s *bfa)
+{
+	bfa_iocfc_stop(bfa);
+}
+
+void
+bfa_comp_deq(struct bfa_s *bfa, struct list_head *comp_q)
+{
+	INIT_LIST_HEAD(comp_q);
+	list_splice_tail_init(&bfa->comp_q, comp_q);
+}
+
+void
+bfa_comp_process(struct bfa_s *bfa, struct list_head *comp_q)
+{
+	struct list_head        *qe;
+	struct list_head        *qen;
+	struct bfa_cb_qe_s   *hcb_qe;
+
+	list_for_each_safe(qe, qen, comp_q) {
+		hcb_qe = (struct bfa_cb_qe_s *) qe;
+		hcb_qe->cbfn(hcb_qe->cbarg, BFA_TRUE);
+	}
+}
+
+void
+bfa_comp_free(struct bfa_s *bfa, struct list_head *comp_q)
+{
+	struct list_head        *qe;
+	struct bfa_cb_qe_s   *hcb_qe;
+
+	while (!list_empty(comp_q)) {
+		bfa_q_deq(comp_q, &qe);
+		hcb_qe = (struct bfa_cb_qe_s *) qe;
+		hcb_qe->cbfn(hcb_qe->cbarg, BFA_FALSE);
+	}
+}
+/**
+ * Periodic timer heart beat from driver
+ */
+void
+bfa_timer_tick(struct bfa_s *bfa)
+{
+	bfa_timer_beat(&bfa->timer_mod);
+}
+
+#ifndef BFA_BIOS_BUILD
+/**
+ * Return the list of PCI vendor/device id lists supported by this
+ * BFA instance.
+ */
+void
+bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids)
+{
+	static struct bfa_pciid_s __pciids[] = {
+		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_FC_8G2P},
+		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_FC_8G1P},
+		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_CT},
+	};
+
+	*npciids = sizeof(__pciids) / sizeof(__pciids[0]);
+	*pciids = __pciids;
+}
+
+/**
+ * Use this function query the default struct bfa_iocfc_cfg_s value (compiled
+ * into BFA layer). The OS driver can then turn back and overwrite entries that
+ * have been configured by the user.
+ *
+ * @param[in] cfg - pointer to bfa_ioc_cfg_t
+ *
+ * @return
+ *	void
+ *
+ * Special Considerations:
+ * 	note
+ */
+void
+bfa_cfg_get_default(struct bfa_iocfc_cfg_s *cfg)
+{
+	cfg->fwcfg.num_fabrics = DEF_CFG_NUM_FABRICS;
+	cfg->fwcfg.num_lports = DEF_CFG_NUM_LPORTS;
+	cfg->fwcfg.num_rports = DEF_CFG_NUM_RPORTS;
+	cfg->fwcfg.num_ioim_reqs = DEF_CFG_NUM_IOIM_REQS;
+	cfg->fwcfg.num_tskim_reqs = DEF_CFG_NUM_TSKIM_REQS;
+	cfg->fwcfg.num_fcxp_reqs = DEF_CFG_NUM_FCXP_REQS;
+	cfg->fwcfg.num_uf_bufs = DEF_CFG_NUM_UF_BUFS;
+	cfg->fwcfg.num_cqs = DEF_CFG_NUM_CQS;
+
+	cfg->drvcfg.num_reqq_elems = DEF_CFG_NUM_REQQ_ELEMS;
+	cfg->drvcfg.num_rspq_elems = DEF_CFG_NUM_RSPQ_ELEMS;
+	cfg->drvcfg.num_sgpgs = DEF_CFG_NUM_SGPGS;
+	cfg->drvcfg.num_sboot_tgts = DEF_CFG_NUM_SBOOT_TGTS;
+	cfg->drvcfg.num_sboot_luns = DEF_CFG_NUM_SBOOT_LUNS;
+	cfg->drvcfg.path_tov = BFA_FCPIM_PATHTOV_DEF;
+	cfg->drvcfg.ioc_recover = BFA_FALSE;
+	cfg->drvcfg.delay_comp = BFA_FALSE;
+	cfg->drvcfg.fw_disc_enabled = BFA_TRUE;
+
+}
+
+void
+bfa_cfg_get_min(struct bfa_iocfc_cfg_s *cfg)
+{
+	bfa_cfg_get_default(cfg);
+	cfg->fwcfg.num_ioim_reqs   = BFA_IOIM_MIN;
+	cfg->fwcfg.num_tskim_reqs  = BFA_TSKIM_MIN;
+	cfg->fwcfg.num_fcxp_reqs   = BFA_FCXP_MIN;
+	cfg->fwcfg.num_uf_bufs     = BFA_UF_MIN;
+	cfg->fwcfg.num_rports      = BFA_RPORT_MIN;
+
+	cfg->drvcfg.num_sgpgs      = BFA_SGPG_MIN;
+	cfg->drvcfg.num_reqq_elems = BFA_REQQ_NELEMS_MIN;
+	cfg->drvcfg.num_rspq_elems = BFA_RSPQ_NELEMS_MIN;
+	cfg->drvcfg.min_cfg        = BFA_TRUE;
+}
+
+void
+bfa_get_attr(struct bfa_s *bfa, struct bfa_ioc_attr_s *ioc_attr)
+{
+	bfa_ioc_get_attr(&bfa->ioc, ioc_attr);
+	if (bfa_ioc_get_fcmode(&bfa->ioc))
+		ioc_attr->ioc_type = BFA_IOC_TYPE_FC;
+	else
+		ioc_attr->ioc_type = BFA_IOC_TYPE_FCoE;
+}
+
+/**
+ * Retrieve firmware trace information on IOC failure.
+ */
+bfa_status_t
+bfa_debug_fwsave(struct bfa_s *bfa, void *trcdata, int *trclen)
+{
+	return bfa_ioc_debug_fwsave(&bfa->ioc, trcdata, trclen);
+}
+
+/**
+ * 		Fetch firmware trace data.
+ *
+ * @param[in]		bfa			BFA instance
+ * @param[out]		trcdata		Firmware trace buffer
+ * @param[in,out]	trclen		Firmware trace buffer len
+ *
+ * @retval BFA_STATUS_OK			Firmware trace is fetched.
+ * @retval BFA_STATUS_INPROGRESS	Firmware trace fetch is in progress.
+ */
+bfa_status_t
+bfa_debug_fwtrc(struct bfa_s *bfa, void *trcdata, int *trclen)
+{
+	return bfa_ioc_debug_fwtrc(&bfa->ioc, trcdata, trclen);
+}
+#endif
+
diff -urpN orig/drivers/scsi/bfa/bfa_csdebug.c patch/drivers/scsi/bfa/bfa_csdebug.c
--- orig/drivers/scsi/bfa/bfa_csdebug.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_csdebug.c	2009-03-14 11:44:56.941954000 -0700
@@ -0,0 +1,55 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  pbind.c BFA FC Persistent target binding
+ */
+
+#include <cs/bfa_debug.h>
+#include <bfa_os_inc.h>
+#include <cs/bfa_q.h>
+#include <log/bfa_log_hal.h>
+
+/**
+ *  cs_debug_api
+ */
+
+
+void
+bfa_panic(int line, char *file, char *panicstr)
+{
+	bfa_log(NULL, BFA_LOG_HAL_ASSERT, file, line, panicstr);
+	bfa_os_panic();
+}
+
+int
+bfa_q_is_on_q_func(struct list_head *q, struct list_head *qe)
+{
+	struct list_head        *tqe;
+
+	tqe = bfa_q_next(q);
+	while (tqe != q) {
+		if (tqe == qe)
+			return (1);
+		tqe = bfa_q_next(tqe);
+		if (tqe == NULL)
+			break;
+	}
+	return (0);
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_diag.c patch/drivers/scsi/bfa/bfa_diag.c
--- orig/drivers/scsi/bfa/bfa_diag.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_diag.c	2009-03-14 11:44:56.950691000 -0700
@@ -0,0 +1,898 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <defs/bfa_defs_diag.h>
+#include <defs/bfa_defs_pci.h>
+#include <cs/bfa_debug.h>
+#include <bfi/bfi_boot.h>
+#include <bfi/bfi_diag.h>
+#include <aen/bfa_aen.h>
+#include <aen/bfa_aen_port.h>
+
+BFA_TRC_FILE(HAL, DIAG);
+
+#define	BFA_DIAG_MEMTEST_TOV	50000	/*  memtest timeout in msec */
+#define BFA_DIAG_FWPING_TOV       	1000	/* msec */
+
+/**
+ *  hal_diag_pvt BFA DIAG private functions
+ */
+
+static void
+bfa_cb_diag(struct bfa_diag_s *diag)
+{
+	diag->cbfn(diag->cbarg, diag->status);
+	diag->block = 0;
+	bfa_diag_set_busy_status(diag);
+}
+
+static void
+bfa_cb_diag_fwping(struct bfa_diag_s *diag)
+{
+	diag->fwping.cbfn(diag->fwping.cbarg, diag->fwping.status);
+	diag->fwping.lock = 0;
+}
+
+static void
+bfa_cb_diag_tsensor(struct bfa_diag_s *diag)
+{
+	diag->tsensor.cbfn(diag->tsensor.cbarg, diag->tsensor.status);
+	diag->tsensor.lock = 0;
+}
+
+static void
+bfa_cb_diag_sfpshow(struct bfa_diag_s *diag)
+{
+	diag->sfpshow.cbfn(diag->sfpshow.cbarg, diag->sfpshow.status);
+	diag->sfpshow.lock = 0;
+}
+
+/**
+ * Heartbeat failure handler.
+ */
+void
+bfa_diag_hbfail(void *diag_arg)
+{
+	struct bfa_diag_s *diag = diag_arg;
+
+	bfa_trc(diag, diag->block);
+	bfa_trc(diag, diag->fwping.lock);
+	bfa_trc(diag, diag->sfpshow.lock);
+	if (!diag->fwping.lock && !diag->sfpshow.lock &&
+		!diag->tsensor.lock && !diag->block)
+		return;
+
+	if (diag->fwping.lock) {
+		diag->fwping.status = BFA_STATUS_IOC_FAILURE;
+		bfa_cb_diag_fwping(diag);
+	} else if (diag->sfpshow.lock) {
+		diag->sfpshow.status = BFA_STATUS_IOC_FAILURE;
+		bfa_cb_diag_sfpshow(diag);
+	} else if (diag->tsensor.lock) {
+		diag->tsensor.status = BFA_STATUS_IOC_FAILURE;
+		bfa_cb_diag_tsensor(diag);
+	} else if (diag->block) {
+		if (diag->timer_active) {
+			bfa_timer_stop(&diag->timer);
+			diag->timer_active = 0;
+		}
+
+		diag->status = BFA_STATUS_IOC_FAILURE;
+		bfa_cb_diag(diag);
+	}
+}
+
+/**
+ * @param[in] mod - bfa diag module
+ * @param[in] sge - scatter gather element
+ * @param[in] len - scatter gather len
+ */
+static void
+bfa_diag_sge(struct bfa_diag_s *mod, struct bfi_sge_s *sge, u32 len)
+{
+	sge->sg_len = len;
+	sge->flags = BFI_SGE_DATA_LAST;
+	bfa_dma_addr_set(sge->sga, mod->dbuf_pa);
+	bfa_sge_to_be(sge);
+}
+
+/*
+ * Register access
+ */
+#define BFA_REG_CT_ADDRSZ	(0x40000)
+#define BFA_REG_CB_ADDRSZ	(0x20000)
+#define BFA_REG_ADDRSZ(__bfa)	\
+	((bfa_ioc_devid(&(__bfa)->ioc) == BFA_PCI_DEVICE_ID_CT) ?	\
+				 BFA_REG_CT_ADDRSZ : BFA_REG_CB_ADDRSZ)
+#define BFA_REG_ADDRMSK(__bfa)	((u32)(BFA_REG_ADDRSZ(__bfa) - 1))
+
+static bfa_status_t
+diag_reg_offset_check(struct bfa_s *bfa, u32 offset, u32 len)
+{
+	u8         area;
+
+	/*
+	 * check [16:15]
+	 */
+	area = (offset >> 15) & 0x7;
+	if (area == 0) {
+		/*
+		 * PCIe core register
+		 */
+		if ((offset + len) > 0x7ffc)	/* 8k dwords or 32KB */
+			return BFA_STATUS_EINVAL;
+	} else if (area == 0x1) {
+		/*
+		 * CB 32 KB memory page
+		 */
+		if ((offset + len) > 0xfffc)	/* 8k dwords or 32KB */
+			return BFA_STATUS_EINVAL;
+	} else {
+		/*
+		 * CB register space 64KB
+		 */
+		if ((offset + len) > BFA_REG_ADDRMSK(bfa))
+			return BFA_STATUS_EINVAL;
+	}
+	return BFA_STATUS_OK;
+}
+
+static void
+bfa_diag_memtest_done(void *cbarg)
+{
+	struct bfa_diag_s *diag = cbarg;
+	struct bfa_ioc_s  *ioc = diag->ioc;
+	struct bfa_diag_memtest_result_s *res = diag->result;
+	u32        loff = BFI_BOOT_MEMTEST_RES_ADDR;
+	u32        pgnum, pgoff, i;
+
+	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
+	pgoff = bfa_ioc_smem_pgoff(ioc, loff);
+
+	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+
+	for (i = 0; i < (sizeof(struct bfa_diag_memtest_result_s) / sizeof(u32));
+	     i++) {
+		/*
+		 * read test result from smem
+		 */
+		*((u32 *) res + i) =
+			bfa_mem_read(ioc->ioc_regs.smem_page_start, loff);
+		loff += sizeof(u32);
+	}
+
+	res->status = bfa_os_swap32(res->status);
+	bfa_trc(diag, res->status);
+
+	if (res->status == BFI_BOOT_MEMTEST_RES_SIG) {
+		diag->status = BFA_STATUS_OK;
+	} else {
+		diag->status = BFA_STATUS_MEMTEST_FAILED;
+
+		res->addr = bfa_os_swap32(res->addr);
+		res->exp = bfa_os_swap32(res->exp);
+		res->act = bfa_os_swap32(res->act);
+		res->err_status = bfa_os_swap32(res->err_status);
+		res->err_status1 = bfa_os_swap32(res->err_status1);
+		res->err_addr = bfa_os_swap32(res->err_addr);
+
+		bfa_trc(diag, res->addr);
+		bfa_trc(diag, res->exp);
+		bfa_trc(diag, res->act);
+		bfa_trc(diag, res->err_status);
+		bfa_trc(diag, res->err_status1);
+		bfa_trc(diag, res->err_addr);
+	}
+
+	diag->timer_active = 0;
+	bfa_cb_diag(diag);
+}
+
+/*
+ * Firmware ping
+ */
+
+/**
+ * Perform DMA test directly
+ */
+static void
+diag_fwping_send(struct bfa_diag_s *diag)
+{
+	struct bfi_diag_fwping_req_s *fwping_req;
+	u32	i;
+
+	bfa_trc(diag, diag->dbuf_pa);
+		
+	/* fill DMA area with pattern */
+	for (i=0; i<(BFI_DIAG_DMA_BUF_SZ >> 2); i++) {
+		*((u32 *)diag->dbuf_kva + i) = diag->fwping.data;
+	}
+	
+	/* Fill mbox msg */
+	fwping_req = (struct bfi_diag_fwping_req_s *)diag->fwping.mbcmd.msg;
+
+	/* Setup SG list */
+	bfa_diag_sge(diag, &fwping_req->sge, BFI_DIAG_DMA_BUF_SZ);
+	/* Set up dma count */
+	fwping_req->count = bfa_os_htonl(diag->fwping.count);
+	/* Set up data pattern */
+	fwping_req->data = diag->fwping.data;
+	
+	/* build host command */
+	bfi_h2i_set(fwping_req->mh, BFI_MC_DIAG, BFI_DIAG_H2I_FWPING, bfa_lpuid(diag->bfa));
+
+	/* send mbox cmd */
+	bfa_ioc_mbox_queue(diag->ioc, &diag->fwping.mbcmd);
+}
+
+static void
+diag_fwping_comp(struct bfa_diag_s *diag, struct bfi_diag_fwping_rsp_s *diag_rsp)
+{
+	u32        rsp_data = diag_rsp->data;
+	u8         rsp_dma_status = diag_rsp->dma_status;
+
+	bfa_trc(diag, rsp_data);
+	bfa_trc(diag, rsp_dma_status);
+
+	if (rsp_dma_status == BFA_STATUS_OK) {
+		u32 i, pat;
+		pat = (diag->fwping.count & 0x1) ? ~(diag->fwping.data) : diag->fwping.data;
+		/* Check mbox data
+		 */
+		if (diag->fwping.data != rsp_data) {
+			bfa_trc(diag, rsp_data);
+			diag->fwping.result->dmastatus = BFA_STATUS_DATACORRUPTED;
+			diag->fwping.status = BFA_STATUS_DATACORRUPTED;
+			bfa_cb_diag_fwping(diag);
+			return;
+		}
+		/* Check dma pattern
+		 */
+		for (i=0; i<(BFI_DIAG_DMA_BUF_SZ >> 2); i++) {
+			if (*((u32 *)diag->dbuf_kva + i) != pat) {
+				bfa_trc(diag, i);
+				bfa_trc(diag, *((u32 *)diag->dbuf_kva + i));
+				diag->fwping.result->dmastatus = BFA_STATUS_DATACORRUPTED;
+				diag->fwping.status = BFA_STATUS_DATACORRUPTED;
+				bfa_cb_diag_fwping(diag);
+				return;
+			}
+		}
+		diag->fwping.result->dmastatus = BFA_STATUS_OK;
+		diag->fwping.status = BFA_STATUS_OK;
+		bfa_cb_diag_fwping(diag);
+	} else {
+		diag->fwping.status = BFA_STATUS_HDMA_FAILED;
+		bfa_cb_diag_fwping(diag);
+	}
+}
+
+/*
+ * Temperature Sensor
+ */
+
+static void
+diag_tempsensor_send(struct bfa_diag_s *diag)
+{
+	bfi_diag_ts_req_t *msg;
+
+	msg = (bfi_diag_ts_req_t *)diag->tsensor.mbcmd.msg;
+	bfa_trc(diag, 0);
+	/* build host command */
+	bfi_h2i_set(msg->mh, BFI_MC_DIAG, BFI_DIAG_H2I_TEMPSENSOR, bfa_lpuid(diag->bfa));
+	/* send mbox cmd */
+	bfa_ioc_mbox_queue(diag->ioc, &diag->tsensor.mbcmd);
+}
+
+static void
+diag_tempsensor_comp(struct bfa_diag_s *diag, bfi_diag_ts_rsp_t *rsp)
+{
+	u16        ts_value = bfa_os_ntohs(rsp->temp);
+
+	*(diag->tsensor.temp) = ts_value;
+
+	bfa_trc(diag, rsp->temp);
+	bfa_trc(diag, ts_value);
+	bfa_trc(diag, *(diag->tsensor.temp));
+
+	diag->tsensor.status = BFA_STATUS_OK;
+	bfa_cb_diag_tsensor(diag);
+}
+
+static void
+diag_sfpshow_send(struct bfa_diag_s *diag)
+{
+	struct bfi_diag_sfp_req_s *sfp_req;
+
+	/* Fill mbox msg */
+	sfp_req = (struct bfi_diag_sfp_req_s *)diag->sfpshow.mbcmd.msg;
+	/* build host command */
+	bfi_h2i_set(sfp_req->mh, BFI_MC_DIAG, BFI_DIAG_H2I_SFPSHOW, bfa_lpuid(diag->bfa));
+	sfp_req->memtype = BFI_DIAG_SFP_MEM_ALL;
+	sfp_req->static_data = diag->sfpshow.static_data;
+	bfa_trc(diag, sfp_req->static_data); 
+	/* Setup SG list */
+	bfa_diag_sge(diag, &sfp_req->req_sge, sizeof(sfp_mem_t));
+
+	/* send mbox cmd */
+	bfa_ioc_mbox_queue(diag->ioc, &diag->sfpshow.mbcmd);
+}
+
+static void
+diag_sfpshow_comp(struct bfa_diag_s *diag, struct bfi_diag_sfp_rsp_s *rsp)
+{
+	if (!diag->sfpshow.lock) {
+		/*
+	 	 * receiving response after ioc failure
+	 	 */
+		bfa_trc(diag, diag->sfpshow.lock);
+		return;
+	}
+
+	if (rsp->status == BFA_STATUS_OK) {
+		u32        size;
+		u8        *des;
+
+		if (rsp->memtype == BFI_DIAG_SFP_MEM_ALL) {
+			size = sizeof(sfp_mem_t);
+			des = (u8 *) &(diag->sfpshow.sfpmem->srlid_base);
+		} else {
+			size = 0;
+			des = NULL;
+		}
+		memcpy(des, diag->dbuf_kva, size);
+	}
+
+	/**
+	 * Queue completion callback.
+	 */
+	diag->sfpshow.status = rsp->status;
+	bfa_trc(diag, rsp->status);
+	bfa_cb_diag_sfpshow(diag);
+}
+
+/*
+ *      LED Test command
+ */
+static void
+diag_ledtest_send(struct bfa_diag_s *diag, struct bfa_diag_ledtest_s *ledtest)
+{
+	struct bfi_diag_ledtest_req_s	*msg;
+
+	msg = (struct bfi_diag_ledtest_req_s *)diag->ledtest.mbcmd.msg;
+	/* build host command */
+	bfi_h2i_set(msg->mh, BFI_MC_DIAG, BFI_DIAG_H2I_LEDTEST,	bfa_lpuid(diag->bfa));
+
+	/*
+	 * convert the freq from N blinks per 10 sec to
+	 * crossbow ontime value. We do it here because division is need
+	 */
+	if (ledtest->freq)
+		ledtest->freq = 500 / ledtest->freq;
+
+	if (ledtest->freq == 0)
+		ledtest->freq = 1;
+
+	bfa_trc(diag, ledtest->freq);
+	/* mcpy(&ledtest_req->req, ledtest, sizeof(bfa_diag_ledtest_t)); */
+	msg->cmd = (u8) ledtest->cmd;
+	msg->color = (u8) ledtest->color;
+	msg->portid = bfa_lpuid(diag->bfa);
+	msg->led = ledtest->led;
+	msg->freq = bfa_os_htons(ledtest->freq);
+
+	/* send mbox cmd */
+	bfa_ioc_mbox_queue(diag->ioc, &diag->ledtest.mbcmd);
+}
+
+static void
+diag_ledtest_comp(struct bfa_diag_s *diag, struct bfi_diag_ledtest_rsp_s * msg)
+{
+	bfa_trc(diag, diag->ledtest.lock);
+	diag->ledtest.lock = BFA_FALSE;
+	/* no bfa_cb_queue is needed because driver is not waiting */
+}
+
+/*
+ * Port beaconing
+ */
+static void
+diag_port_beacon_send(struct bfa_diag_s *diag, bfa_boolean_t beacon, u32 sec)
+{
+	struct bfi_diag_portbeacon_req_s *msg;
+
+	msg = (struct bfi_diag_portbeacon_req_s *)diag->beacon.mbcmd.msg;
+	/* build host command */
+	bfi_h2i_set(msg->mh, BFI_MC_DIAG, BFI_DIAG_H2I_PORTBEACON, bfa_lpuid(diag->bfa));
+
+	msg->beacon = bfa_os_htonl(beacon);
+	msg->period = bfa_os_htonl(sec);
+	/* send mbox cmd */
+	bfa_ioc_mbox_queue(diag->ioc, &diag->beacon.mbcmd);
+}
+
+static void
+diag_portbeacon_comp(struct bfa_diag_s *diag, struct bfi_diag_portbeacon_rsp_s * msg)
+{
+	bfa_trc(diag, diag->beacon.state);
+	diag->beacon.state = BFA_FALSE;
+	/* no bfa_cb_queue is needed because driver is not waiting */
+
+	/* set port attributes */
+	bfa_pport_beacon(diag->bfa, diag->beacon.state, diag->beacon.link_e2e);
+}
+
+/*
+ * SFP's State Change Notification post to AEN 
+ */
+static void
+diag_sfp_scn_aen_post(struct bfa_diag_s *diag, struct bfi_diag_sfp_event_s *rsp)
+{
+	union bfa_aen_data_u aen_data;
+	struct bfa_log_mod_s *logmod = diag->bfa->logm;
+	wwn_t			pwwn;
+	char			*pwwn_ptr = NULL;
+        char            	*pomlvl_str[BFA_PORT_AEN_SFP_POM_MAX] = 
+					{"Green", "Amber", "Red"};
+	char			*pomlvl_ptr;
+
+	bfa_trc(diag, (((u64)rsp->pomlvl) << 16) | (((u64)rsp->sfpid) << 8) | ((u64)rsp->event));
+
+	pwwn = bfa_pport_get_wwn(diag->bfa, BFA_FALSE);
+	bfa_trc(diag, pwwn);
+
+	aen_data.port.phy_port_num = rsp->sfpid;
+	aen_data.port.pwwn = pwwn;
+	if (rsp->event == BFA_DIAG_SFP_EVENT_INSERTED) {
+		// Insertion event
+		bfa_log(logmod, BFA_AEN_PORT_SFP_INSERT, rsp->sfpid, pwwn_ptr);
+	} else if (rsp->event == BFA_DIAG_SFP_EVENT_REMOVED) {
+		bfa_log(logmod, BFA_AEN_PORT_SFP_REMOVE, rsp->sfpid, pwwn_ptr);
+	} else if (rsp->event == BFA_DIAG_SFP_EVENT_POM) {
+		 bfa_assert((rsp->pomlvl >= BFA_PORT_AEN_SFP_POM_GREEN) && 
+			    (rsp->pomlvl <= BFA_PORT_AEN_SFP_POM_RED));
+		aen_data.port.level = rsp->pomlvl;
+		pomlvl_ptr = pomlvl_str[rsp->pomlvl - 1];
+		bfa_log(logmod, BFA_AEN_PORT_SFP_POM, 
+			pomlvl_ptr, rsp->sfpid, pwwn_ptr);
+	}
+}
+
+
+
+
+/**
+ *  hal_diag_public
+ */
+/**
+ * @ Diag hmbox handler 
+ */
+void
+bfa_diag_intr(void *diagarg, struct bfi_mbmsg_s *msg)
+{
+	struct bfa_diag_s *diag = diagarg;
+
+	switch (msg->mh.msg_id) {
+	case BFI_DIAG_I2H_PORTBEACON:
+		diag_portbeacon_comp(diag, (struct bfi_diag_portbeacon_rsp_s *) msg);
+		break;
+
+	case BFI_DIAG_I2H_FWPING:
+		diag_fwping_comp(diag, (struct bfi_diag_fwping_rsp_s *) msg);
+		break;
+
+	case BFI_DIAG_I2H_TEMPSENSOR:
+		diag_tempsensor_comp(diag, (bfi_diag_ts_rsp_t *) msg);
+		break;
+
+	case BFI_DIAG_I2H_SFPSHOW:
+		diag_sfpshow_comp(diag, (struct bfi_diag_sfp_rsp_s *) msg);
+		break;
+
+	case BFI_DIAG_I2H_SFP_SCN:
+		diag_sfp_scn_aen_post(diag, (struct bfi_diag_sfp_event_s *) msg);
+		break;
+
+	case BFI_DIAG_I2H_LEDTEST:
+		diag_ledtest_comp(diag, (struct bfi_diag_ledtest_rsp_s *) msg);
+		break;
+
+	default:
+		bfa_trc(diag, msg->mh.msg_id);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Set port status to busy
+ */
+void
+bfa_diag_set_busy_status(struct bfa_diag_s *diag)
+{
+	if (diag->block || diag->lb.lock)
+		bfa_pport_busy(diag->bfa, BFA_TRUE);
+	else
+		bfa_pport_busy(diag->bfa, BFA_FALSE);
+}
+
+
+
+/**
+ *  hal_diag_api
+ */
+
+/*
+ * Register access
+ */
+
+/**
+ *   DIAG register read
+ */
+bfa_status_t
+bfa_diag_reg_read(struct bfa_s *bfa, u32 offset, u32 len,
+		      u32 *buf)
+{
+	bfa_status_t    status;
+	struct bfa_ioc_s  *ioc = &bfa->ioc;
+	bfa_os_addr_t   rb;
+	bfa_os_addr_t   addr;
+	u32        i;
+
+	rb = bfa_ioc_bar0(ioc);
+
+	offset &= BFA_REG_ADDRMSK(bfa);	/* offset only 17 bit and word align */
+
+	/*
+	 * offset and len sanity check
+	 */
+	status = diag_reg_offset_check(bfa, offset, len);
+	if (status)
+		return status;
+
+	addr = rb + offset;
+	for (i = 0; i < len; i++) {
+		*buf = bfa_reg_read(addr);
+		buf++;
+		addr += sizeof(u32);
+	}
+	return BFA_STATUS_OK;
+}
+
+/**
+ *   DIAG register write
+ */
+bfa_status_t
+bfa_diag_reg_write(struct bfa_s *bfa, u32 offset, u32 len,
+		       u32 value)
+{
+	bfa_status_t    status;
+	struct bfa_ioc_s  *ioc = &bfa->ioc;
+	u32       *addr;
+	u32        i;
+
+	offset &= BFA_REG_ADDRMSK(bfa);	/* offset only 17 bit and word align */
+
+	/*
+	 * offset and len sanity check
+	 */
+	status = diag_reg_offset_check(bfa, offset, len);
+	if (status)
+		return status;
+
+	addr = (u32 *) ((u8 *) bfa_ioc_bar0(ioc) + offset);
+	for (i = 0; i < len; i++) {
+		bfa_reg_write(addr, value);
+		addr++;
+	}
+	return BFA_STATUS_OK;
+}
+
+/**
+ * Gen RAM Test
+ *
+ *   @param[in] *diag		- diag data struct
+ *   @param[in] *memtest	- mem test params input from upper layer,
+ *   @param[in] pattern		- mem test pattern
+ *   @param[in] *result		- mem test result
+ *   @param[in] cbfn		- mem test callback functioin
+ *   @param[in] cbarg		- callback functioin arg
+ *
+ *   @param[out]
+ */
+bfa_status_t
+bfa_diag_memtest(struct bfa_diag_s *diag, struct bfa_diag_memtest_s *memtest,
+		     u32 pattern, struct bfa_diag_memtest_result_s *result,
+		     bfa_cb_diag_t cbfn, void *cbarg)
+{
+	bfa_trc(diag, pattern);
+	
+	if (!bfa_ioc_adapter_is_disabled(diag->ioc))
+		return BFA_STATUS_ADAPTER_ENABLED;
+
+	/*
+	 * check to see if there is another destructive diag cmd running
+	 */
+	if (diag->block) {
+		bfa_trc(diag, diag->block);
+		return (BFA_STATUS_DEVBUSY);
+	} else {
+		diag->block = 1;
+		bfa_diag_set_busy_status(diag);
+	}
+
+	diag->result = result;
+	diag->cbfn = cbfn;
+	diag->cbarg = cbarg;
+
+	/*
+	 * download memtest code and take LPU0 out of reset
+	 */
+	bfa_ioc_boot(diag->ioc, BFI_BOOT_TYPE_MEMTEST,  
+				 diag->ioc->pcidev.device_id);
+
+	bfa_timer_begin(diag->ioc->timer_mod, &diag->timer, bfa_diag_memtest_done,
+					diag, BFA_DIAG_MEMTEST_TOV);
+	diag->timer_active = 1;
+	return (BFA_STATUS_OK);
+}
+
+/**
+ * DIAG firmware ping command
+ *
+ *   @param[in] *diag		- diag data struct
+ *   @param[in] cnt		- dma loop count for testing PCIE
+ *   @param[in] data		- data pattern to pass in fw
+ *   @param[in] *result		- pt to bfa_diag_fwping_result_t data struct
+ *   @param[in] cbfn		- callback function
+ *   @param[in] *cbarg		- callback functioin arg
+ *
+ *   @param[out]
+ */
+bfa_status_t
+bfa_diag_fwping(struct bfa_diag_s *diag, u32 cnt, u32 data,
+		    struct bfa_diag_fwping_result_s *result, bfa_cb_diag_t cbfn,
+		    void *cbarg)
+{
+	u32        i;
+
+	bfa_trc(diag, cnt);
+	bfa_trc(diag, data);
+
+	if (!bfa_ioc_is_operational(diag->ioc))
+		return BFA_STATUS_IOC_NON_OP;
+
+	/*
+	 * check to see if there is another destructive diag cmd running
+	 * fwping and sfpshow share the same dma area
+	 */
+	if (diag->block || diag->fwping.lock || diag->sfpshow.lock) {
+		bfa_trc(diag, diag->block);
+		bfa_trc(diag, diag->fwping.lock);
+		bfa_trc(diag, diag->sfpshow.lock);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	/* Initialization */
+	diag->fwping.lock = 1;
+	diag->fwping.cbfn = cbfn;
+	diag->fwping.cbarg = cbarg;
+	diag->fwping.result = result;
+	diag->fwping.data = data;
+	diag->fwping.count = cnt;
+
+	/* Init test results */
+	for (i = 0; i < BFI_IOC_MAX_CQS; i++) {
+		diag->fwping.result->data[i] = 0;
+		diag->fwping.result->status[i] = BFA_STATUS_OK;
+	}
+
+	/* kick off the first ping */
+	diag_fwping_send(diag);
+	return (BFA_STATUS_OK);
+}
+
+/**
+ * Read Temperature Sensor
+ *
+ *   @param[in] *diag		- diag data struct
+ *   @param[in] *temp		- pt to temperature
+ *   @param[in] cbfn		- callback function
+ *   @param[in] *cbarg		- callback functioin arg
+ *
+ *   @param[out]
+ */
+bfa_status_t
+bfa_diag_tsensor_query(struct bfa_diag_s *diag, u16 *temp,
+			   bfa_cb_diag_t cbfn, void *cbarg)
+{
+	/*
+	 * check to see if there is a destructive diag cmd running
+	 */
+	if (diag->block || diag->tsensor.lock) {
+		bfa_trc(diag, diag->block);
+		bfa_trc(diag, diag->tsensor.lock);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	if (!bfa_ioc_is_operational(diag->ioc))
+		return BFA_STATUS_IOC_NON_OP;
+
+	/* Init diag mod params */
+	diag->tsensor.lock = 1;
+	diag->tsensor.temp = temp;
+	diag->tsensor.cbfn = cbfn;
+	diag->tsensor.cbarg = cbarg;
+
+	/* Send msg to fw */
+	diag_tempsensor_send(diag);
+
+	return (BFA_STATUS_OK);
+}
+
+/**
+ * SFP Show command
+ *
+ *   @param[in] *diag		- diag data struct
+ *   @param[in] sfpmem		- sfp data
+ *   @param[in] static_data	- sfp static data flag
+ *   @param[in] cbfn 		- callback functioin
+ *   @param[in] *cbarg		- callback functioin arg
+ *
+ */
+bfa_status_t
+bfa_diag_sfpshow(struct bfa_diag_s *diag, sfp_mem_t *sfpmem, u8 static_data,
+		     bfa_cb_diag_t cbfn, void *cbarg)
+{
+	bfa_trc(diag, diag->block);
+
+	/*
+	 * check to see if there is another destructive diag cmd running
+	 */
+	if (diag->block || diag->sfpshow.lock || diag->fwping.lock) {
+		bfa_trc(diag, diag->sfpshow.lock);
+		bfa_trc(diag, diag->fwping.lock);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	if (!bfa_ioc_is_operational(diag->ioc))
+		return BFA_STATUS_IOC_NON_OP;
+
+	/* Init diag mod params */
+	diag->sfpshow.lock = 1;
+	diag->sfpshow.sfpmem = sfpmem;
+	diag->sfpshow.static_data = static_data;
+	diag->sfpshow.cbfn = cbfn;
+	diag->sfpshow.cbarg = cbarg;
+
+	/* Send msg to fw */
+	diag_sfpshow_send(diag);
+
+	return (BFA_STATUS_OK);
+}
+
+/**
+ * LED Test command
+ *
+ *   @param[in] *diag		- diag data struct
+ *   @param[in] *ledtest	- pt to ledtest data structure
+ *
+ *   @param[out]
+ */
+bfa_status_t
+bfa_diag_ledtest(struct bfa_diag_s *diag, struct bfa_diag_ledtest_s *ledtest)
+{
+	bfa_trc(diag, ledtest->cmd);
+
+	if (!bfa_ioc_is_operational(diag->ioc))
+		return BFA_STATUS_IOC_NON_OP;
+
+	if (diag->beacon.state)
+		return BFA_STATUS_BEACON_ON;
+
+	if (diag->ledtest.lock)
+		return BFA_STATUS_LEDTEST_OP;
+
+	/* Send msg to fw */
+	diag->ledtest.lock = BFA_TRUE;
+	diag_ledtest_send(diag, ledtest);
+
+	return (BFA_STATUS_OK);
+}
+
+/**
+ * Port beaconing command
+ *
+ *   @param[in] *diag		- diag data struct
+ *   @param[in] beacon		- port beaconing 1:ON	0:OFF
+ *   @param[in] link_e2e_beacon	- link beaconing 1:ON	0:OFF
+ *   @param[in] sec		- beaconing duration in seconds
+ *
+ *   @param[out]
+ */
+bfa_status_t
+bfa_diag_beacon_port(struct bfa_diag_s *diag, 
+				bfa_boolean_t beacon, 
+				bfa_boolean_t link_e2e_beacon, 
+				u32 sec)
+{
+	bfa_trc(diag, beacon);
+	bfa_trc(diag, link_e2e_beacon);
+	bfa_trc(diag, sec);
+
+	if (!bfa_ioc_is_operational(diag->ioc))
+		return BFA_STATUS_IOC_NON_OP;
+
+	if (diag->ledtest.lock)
+		return BFA_STATUS_LEDTEST_OP;
+
+	if (diag->beacon.state && beacon)	/* beacon alread on */
+		return BFA_STATUS_BEACON_ON;
+
+	diag->beacon.state 		= beacon;
+	diag->beacon.link_e2e 	= link_e2e_beacon;
+
+	/* set port attributes */
+	/* should this pport_beacon be common to both bfa and bna ? */
+	bfa_pport_beacon(diag->bfa, beacon, link_e2e_beacon);
+
+	/* Send msg to fw */
+	diag_port_beacon_send(diag, beacon, sec);
+
+	return (BFA_STATUS_OK);
+}
+
+
+/**
+ * Return DMA memory needed by diag module.
+ */
+u32
+__bfa_diag_meminfo(void)
+{
+	return BFI_DIAG_DMA_BUF_SZ;
+}
+
+/**
+ * Attach virtual and physical memory for Diag.
+ */
+void
+__bfa_diag_attach(struct bfa_diag_s *diag, struct bfa_ioc_s *ioc, void *bfa,
+                struct bfa_trc_mod_s *trcmod)
+{
+	diag->bfa = bfa;
+	diag->ioc = ioc;
+	diag->trcmod = trcmod;
+
+	diag->block = 0;
+	diag->cbfn = NULL;
+	diag->cbarg = NULL;
+	diag->result = NULL;
+
+	bfa_ioc_mbox_regisr(diag->ioc, BFI_MC_DIAG, bfa_diag_intr, diag);
+	bfa_ioc_hbfail_init(&diag->hbfail_reg, bfa_diag_hbfail, diag);
+	bfa_ioc_hbfail_register(diag->ioc, &diag->hbfail_reg);
+}
+
+void
+bfa_diag_memclaim(struct bfa_diag_s *diag, u8 *dm_kva, u64 dm_pa)
+{
+	diag->dbuf_kva = dm_kva;
+	diag->dbuf_pa = dm_pa;
+	bfa_os_memset(diag->dbuf_kva, 0, BFI_DIAG_DMA_BUF_SZ);
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_diag_priv.h patch/drivers/scsi/bfa/bfa_diag_priv.h
--- orig/drivers/scsi/bfa/bfa_diag_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_diag_priv.h	2009-03-14 11:44:56.958992000 -0700
@@ -0,0 +1,26 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_DIAG_PRIV_H__
+#define __BFA_DIAG_PRIV_H__
+
+#include <bfa_diag.h>
+
+void	bfa_fcdiag_intr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+void	bfa_diag_set_busy_status(struct bfa_diag_s *diag);
+void	bfa_diag_hbfail(void *diagarg);
+#endif /* __BFA_DIAG_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_drv.c patch/drivers/scsi/bfa/bfa_drv.c
--- orig/drivers/scsi/bfa/bfa_drv.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_drv.c	2009-03-14 11:44:56.967332000 -0700
@@ -0,0 +1,57 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <bfa.h>
+#include <bfa_diag.h>
+
+
+static void
+bfa_com_diag_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi)
+{
+	struct bfa_diag_s	*diag = BFA_DIAG_MOD(bfa);
+	u32	dm_len;
+	u8		*dm_kva;
+	u64	dm_pa;
+
+	/**
+	 * Diag module attach.
+	 */
+	dm_len = __bfa_diag_meminfo();
+	dm_kva = bfa_meminfo_dma_virt(mi);
+	dm_pa  = bfa_meminfo_dma_phys(mi);
+
+	__bfa_diag_attach(diag, &bfa->ioc, bfa, bfa->trcmod);
+	bfa_diag_memclaim(diag, dm_kva, dm_pa);
+
+	bfa_meminfo_dma_virt(mi) = dm_kva + dm_len;
+	bfa_meminfo_dma_phys(mi) = dm_pa + dm_len;
+}
+
+/**
+ * Common modules DMA memory requirement.
+ */
+void
+bfa_com_meminfo(bfa_boolean_t mincfg, u32 *dm_len)
+{
+	*dm_len += __bfa_diag_meminfo();
+}
+
+void
+bfa_com_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi,
+		bfa_boolean_t mincfg)
+{
+	bfa_com_diag_attach(bfa, mi);
+}
diff -urpN orig/drivers/scsi/bfa/bfa_fabric.c patch/drivers/scsi/bfa/bfa_fabric.c
--- orig/drivers/scsi/bfa/bfa_fabric.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fabric.c	2009-03-14 11:44:56.977508000 -0700
@@ -0,0 +1,530 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  fabric.c Fabric module implementation.
+ */
+
+#include <bfa.h>
+#include <bfa_lport.h>
+#include <bfa_vport.h>
+#include <bfa_fabric.h>
+#include <log/bfa_log_hal.h>
+#include <bfa_auth.h>
+#include <bfi/bfi_fabric.h>
+
+BFA_TRC_FILE(HAL, FABRIC);
+BFA_MODULE(fabric);
+
+#define BFA_FABRIC_RETRY_DELAY		(2000)	/* Milliseconds */
+#define BFA_FABRIC_CLEANUP_DELAY	(10000)	/* Milliseconds */
+
+#define bfa_fabric_set_opertype(__fabric) do {          \
+    if (bfa_pport_get_topology((__fabric)->bfa)    \
+				== BFA_PPORT_TOPOLOGY_P2P)   \
+	    (__fabric)->oper_type = BFA_PPORT_TYPE_NPORT;       \
+    else                                                    \
+	    (__fabric)->oper_type = BFA_PPORT_TYPE_NLPORT;      \
+} while (0)
+
+
+/*
+ * forward declarations
+ */
+static void     bfa_fabric_init(struct bfa_fabric_s *fabric);
+static void     bfa_fabric_delete(struct bfa_fabric_s *fabric);
+/**
+ *  bfa_fabric_sm fabric state machine functions
+ */
+
+/**
+ * Fabric state machine events
+ */
+enum bfa_fabric_event {
+	BFA_FABRIC_SM_ONLINE 		= 1, /*   linkup from FW*/
+	BFA_FABRIC_SM_OFFLINE 		= 2, /*  link down from FW*/
+	BFA_FABRIC_SM_IOC_DISABLE 	= 3, /*  ioc diasble from BFA IOC*/
+	BFA_FABRIC_SM_DELETE 		= 4, /*  delete*/
+};
+bfa_fsm_state_decl(bfa_fabric, uninit, struct bfa_fabric_s, enum bfa_fabric_event)
+bfa_fsm_state_decl(bfa_fabric, offline, struct bfa_fabric_s, enum bfa_fabric_event)
+bfa_fsm_state_decl(bfa_fabric, online, struct bfa_fabric_s, enum bfa_fabric_event)
+bfa_fsm_state_decl(bfa_fabric, ioc_down, struct bfa_fabric_s, enum bfa_fabric_event)
+
+static void
+bfa_fabric_sm_uninit_entry(struct bfa_fabric_s *fabric)
+{
+}
+
+static void
+bfa_fabric_sm_uninit(struct bfa_fabric_s *fabric, enum bfa_fabric_event evt)
+{
+	bfa_trc(fabric->bfa, evt);
+
+	switch (evt) {
+		case BFA_FABRIC_SM_ONLINE:
+			bfa_trc(fabric->bfa, fabric->bport.port_cfg.pwwn);
+			bfa_fabric_set_opertype(fabric);
+			bfa_trc(fabric->bfa, fabric->fab_type);
+			bfa_fsm_set_state(fabric, bfa_fabric_sm_online);
+			break;
+		case BFA_FABRIC_SM_IOC_DISABLE:
+			bfa_fsm_set_state(fabric, bfa_fabric_sm_ioc_down);
+			break;
+		case BFA_FABRIC_SM_DELETE:
+			break;
+		default:
+			bfa_assert(0);
+			break;
+	}
+
+}
+static void
+bfa_fabric_sm_offline_entry(struct bfa_fabric_s *fabric)
+{
+}
+static void
+bfa_fabric_sm_offline(struct bfa_fabric_s *fabric, enum bfa_fabric_event evt)
+{
+	bfa_trc(fabric->bfa, evt);
+
+	switch (evt) {
+		case BFA_FABRIC_SM_ONLINE:
+			bfa_trc(fabric->bfa, fabric->bport.port_cfg.pwwn);
+			bfa_fabric_set_opertype(fabric);
+			bfa_trc(fabric->bfa, fabric->fab_type);
+			bfa_fsm_set_state(fabric, bfa_fabric_sm_online);
+			break;
+		case BFA_FABRIC_SM_IOC_DISABLE:
+			bfa_fsm_set_state(fabric, bfa_fabric_sm_ioc_down);
+			break;
+		case BFA_FABRIC_SM_DELETE:
+			bfa_fsm_set_state(fabric, bfa_fabric_sm_uninit);
+			break;
+		default:
+			bfa_assert(0);
+	}
+}
+static void
+bfa_fabric_sm_online_entry(struct bfa_fabric_s *fabric)
+{
+}
+static void
+bfa_fabric_sm_online(struct bfa_fabric_s *fabric, enum bfa_fabric_event evt)
+{
+	bfa_trc(fabric->bfa, evt);
+
+	switch (evt) {
+		case BFA_FABRIC_SM_OFFLINE:
+			if(fabric->auth_reqd)
+				bfa_auth_stop(fabric);
+			bfa_cb_vf_stop(bfa_vf_get_drv_vf(fabric));
+			bfa_fsm_set_state(fabric, bfa_fabric_sm_offline);
+			break;
+		case BFA_FABRIC_SM_IOC_DISABLE:
+			bfa_fsm_set_state(fabric, bfa_fabric_sm_ioc_down);
+			break;
+		case BFA_FABRIC_SM_DELETE:
+			bfa_fsm_set_state(fabric, bfa_fabric_sm_uninit);
+			break;
+		case BFA_FABRIC_SM_ONLINE:
+			bfa_trc(fabric->bfa, evt);
+			bfa_trc(fabric->bfa, fabric->fab_type);
+			break;
+		default:
+			bfa_assert(0);
+	}
+}
+
+static void
+bfa_fabric_sm_ioc_down_entry(struct bfa_fabric_s *fabric)
+{
+}
+
+static void
+bfa_fabric_sm_ioc_down(struct bfa_fabric_s *fabric, enum bfa_fabric_event evt)
+{
+	bfa_trc(fabric->bfa, evt);
+
+	switch (evt) {
+		case BFA_FABRIC_SM_ONLINE:
+			bfa_trc(fabric->bfa, fabric->bport.port_cfg.pwwn);
+			bfa_fabric_set_opertype(fabric);
+			bfa_trc(fabric->bfa, fabric->fab_type);
+			bfa_fsm_set_state(fabric, bfa_fabric_sm_online);
+			/* lport will take care of vport create.
+			   TODO Run through vf queue and create VF in FW */
+			break;
+		case BFA_FABRIC_SM_DELETE:
+			bfa_fsm_set_state(fabric, bfa_fabric_sm_uninit);
+			break;
+		default:
+			bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  bfa_fabric_private fabric private functions
+ */
+
+static void
+bfa_fabric_start(struct bfa_s *bfa)
+{
+}
+static void
+bfa_fabric_stop(struct bfa_s *bfa)
+{
+	bfa_vf_stop(&bfa->fabric);
+	//bfa_cb_vf_stop(vf_drv);
+}
+static void
+bfa_fabric_init(struct bfa_fabric_s *fabric)
+{
+	struct bfa_port_cfg_s *port_cfg = &fabric->bport.port_cfg;
+
+	port_cfg->roles = bfa_bport_role(fabric->bfa);
+	/* FCS_BRINGUP*/	
+	port_cfg->roles = BFA_PORT_ROLE_FCP_IM;
+	port_cfg->nwwn = bfa_ioc_get_nwwn(&fabric->bfa->ioc);
+	port_cfg->pwwn = bfa_ioc_get_pwwn(&fabric->bfa->ioc);
+
+}
+
+/**
+ * Delete all vports and wait for vport delete completions.
+ */
+static void
+bfa_fabric_delete(struct bfa_fabric_s *fabric)
+{
+	/* there is no need to inform FW as fabric_modexit will be issues by IOC*/
+	bfa_fsm_send_event(fabric, BFA_FABRIC_SM_DELETE);
+}
+
+
+/**
+ *      Compute and return memory needed by FCP(tm) module.
+ */
+static void
+bfa_fabric_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+        u32 *dm_len)
+{
+	/* TODO memory for VF*/
+	*km_len += sizeof(struct bfa_fabric_s);
+}
+
+static void
+bfa_fabric_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+             struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_fabric_s *fabric = &bfa->fabric;
+	bfa_os_memset(fabric, 0, sizeof(struct bfa_fabric_s));
+	
+	fabric->bfa = bfa;
+	/**
+	 * Initialize base fabric.
+	 */
+	INIT_LIST_HEAD(&fabric->vport_q);
+	INIT_LIST_HEAD(&fabric->vf_q);
+	bfa_fabric_init(fabric);
+	bfa_lport_init(&fabric->bport, fabric->bfa, 0,
+			NULL, &fabric->bport.port_cfg, NULL);
+	bfa_fsm_set_state(fabric, bfa_fabric_sm_uninit);
+}
+
+static void
+bfa_fabric_initdone(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fabric_detach(struct bfa_s *bfa)
+{
+	bfa_trc(bfa, 0);
+	/**
+	 * Cleanup base fabric.
+	 */
+	bfa_fabric_delete(&bfa->fabric);
+}
+
+static void
+bfa_fabric_iocdisable(struct bfa_s *bfa)
+{
+	bfa_fsm_send_event(&bfa->fabric, BFA_FABRIC_SM_IOC_DISABLE);
+	/* if vf queue has vfs send iocdisable to them TODO*/
+}
+
+void
+bfa_fabric_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
+{
+	union bfi_fabric_i2h_msg_u req;
+	struct bfa_fabric_s *vf;
+	u16 fabric_tag = 0;
+
+	req.msg = m;
+	switch (m->mhdr.msg_id)
+	{
+		case BFI_FABRIC_I2H_AUTH_START_RSP:
+			fabric_tag = bfa_os_ntohs(req.auth_rsp->fw_handle);
+			vf = bfa_vf_lookup(bfa, fabric_tag);
+			if(vf->auth_reqd)
+			{
+				vf->auth.status = req.auth_rsp->status;
+				vf->auth.algo = req.auth_rsp->algo;
+				vf->auth.group = req.auth_rsp->group;
+				bfa_auth_start_rsp(vf);
+			}
+			break;
+		case BFI_FABRIC_I2H_ONLINE:
+			fabric_tag = bfa_os_ntohs(req.status_rsp->fw_handle);
+			vf = bfa_vf_lookup(bfa, fabric_tag);
+			vf->fab_type = req.status_rsp->status;
+			vf->fabric_name = req.status_rsp->fabric_name;
+			bfa_fsm_send_event(vf, BFA_FABRIC_SM_ONLINE);
+			break;
+		case BFI_FABRIC_I2H_OFFLINE:
+			fabric_tag = bfa_os_ntohs(req.status_rsp->fw_handle);
+			vf = bfa_vf_lookup(bfa, fabric_tag);
+			vf->fab_type = req.status_rsp->status;
+			bfa_fsm_send_event(vf, BFA_FABRIC_SM_OFFLINE);
+			break;
+		default:
+			bfa_assert(0);
+			break;
+	}
+}
+
+
+/**
+ *  bfa_fabric_public fabric public functions
+ */
+
+/**
+ * Port Symbolic Name Creation for base port.
+ */
+void
+bfa_fabric_psymb_init(struct bfa_fabric_s *fabric)
+{
+	struct bfa_port_cfg_s *port_cfg = &fabric->bport.port_cfg;
+	struct bfa_adapter_attr_s adapter_attr;
+	struct bfa_driver_info_s  *driver_info = &fabric->bfa->driver_info;
+
+
+	bfa_os_memset((void *)&adapter_attr, 0, sizeof(struct bfa_adapter_attr_s));
+	bfa_ioc_get_adapter_attr(&fabric->bfa->ioc, &adapter_attr);
+
+	/* Model name/number */
+	strncpy((char *)&port_cfg->sym_name, adapter_attr.model, 
+			BFA_PORT_SYMBNAME_MODEL_SZ);
+	strncat((char *)&port_cfg->sym_name, BFA_PORT_SYMBNAME_SEPARATOR, 
+			sizeof(BFA_PORT_SYMBNAME_SEPARATOR));
+
+	/* Driver Version */
+	strncat((char *)&port_cfg->sym_name, (char *)driver_info->version,
+			BFA_PORT_SYMBNAME_VERSION_SZ);
+	strncat((char *)&port_cfg->sym_name, BFA_PORT_SYMBNAME_SEPARATOR, 
+			sizeof(BFA_PORT_SYMBNAME_SEPARATOR));
+
+	/* Host machine name */
+	strncat((char *)&port_cfg->sym_name, (char *)driver_info->host_machine_name,
+			BFA_PORT_SYMBNAME_MACHINENAME_SZ);
+	strncat((char *)&port_cfg->sym_name, BFA_PORT_SYMBNAME_SEPARATOR, 
+			sizeof(BFA_PORT_SYMBNAME_SEPARATOR));
+
+	/*
+	 * Host OS Info :
+	 * If OS Patch Info is not there, do not truncate any bytes from the 
+     * OS name string and instead copy the entire OS info string ( 64 bytes).
+     */
+	if (driver_info->host_os_patch[0] == '\0') {
+		strncat((char *)&port_cfg->sym_name, (char *)driver_info->host_os_name,
+				BFA_OS_STR_LEN);
+		strncat((char *)&port_cfg->sym_name, BFA_PORT_SYMBNAME_SEPARATOR, 
+			sizeof(BFA_PORT_SYMBNAME_SEPARATOR));
+	} 
+	else {
+		strncat((char *)&port_cfg->sym_name, (char *)driver_info->host_os_name,
+				BFA_PORT_SYMBNAME_OSINFO_SZ);
+		strncat((char *)&port_cfg->sym_name, BFA_PORT_SYMBNAME_SEPARATOR, 
+			sizeof(BFA_PORT_SYMBNAME_SEPARATOR));
+
+		/* Append host OS Patch Info */
+		strncat((char *)&port_cfg->sym_name, (char *)driver_info->host_os_patch,
+				BFA_PORT_SYMBNAME_OSPATCH_SZ);
+	}
+
+	/* null terminate */
+	port_cfg->sym_name.symname[BFA_SYMNAME_MAXLEN -1] = 0;
+}
+
+
+
+/**
+ *    Return true if fabric in loopback mode.
+ */
+bfa_boolean_t
+bfa_fabric_is_loopback(struct bfa_fabric_s *fabric)
+{
+	bfa_trc(fabric->bfa, fabric->fab_type);
+	if(fabric->fab_type == FABRIC_LOOPBACK)
+	{
+		return BFA_TRUE;
+	}
+	return BFA_FALSE;
+}
+
+/**
+ *    Given a fabric, return oper_type.
+ */
+enum bfa_pport_type
+bfa_fabric_port_type(struct bfa_fabric_s *fabric)
+{
+	bfa_trc(fabric->bfa, fabric->oper_type);
+	return fabric->oper_type;
+}
+
+
+/**
+ *   A child vport is being created in the fabric.
+ *
+ *   Call from vport module at vport creation. A list of base port and vports
+ *   belonging to a fabric is maintained to propagate link events.
+ *
+ *   param[in] fabric - Fabric instance. This can be a base fabric or vf.
+ *   param[in] vport  - Vport being created.
+ *
+ *   @return None (always succeeds)
+ */
+void
+bfa_fabric_add_vport(struct bfa_fabric_s *fabric, struct bfa_vport_s *vport)
+{
+	/**
+	 * - add vport to fabric's vport_q
+	 */
+	bfa_trc(fabric->bfa, fabric->vf_id);
+
+	list_add_tail(&vport->qe, &fabric->vport_q);
+	fabric->num_vports++;
+}
+
+/**
+ *   A child vport is being deleted from fabric.
+ *
+ *   Vport is being deleted.
+ */
+void
+bfa_fabric_del_vport(struct bfa_fabric_s *fabric, struct bfa_vport_s *vport)
+{
+	list_del(&vport->qe);
+	fabric->num_vports--;
+}
+
+/**
+ *    Check if fabric is online.
+ *
+ *   param[in] fabric - Fabric instance. This can be a base fabric or vf.
+ *
+ *   @return  TRUE/FALSE
+ */
+bfa_boolean_t
+bfa_fabric_is_online(struct bfa_fabric_s *fabric)
+{
+	bfa_trc(fabric->bfa, fabric->oper_type);
+	bfa_trc(fabric->bfa, fabric->fab_type);
+	if((fabric->fab_type == FABRIC_SWITCHED) && 
+		(bfa_fsm_cmp_state(fabric, bfa_fabric_sm_online)))
+	{
+		return BFA_TRUE;
+	}
+	return BFA_FALSE;
+}
+
+
+bfa_status_t
+bfa_fabric_addvf(struct bfa_fabric_s *vf, struct bfa_s *bfa,
+		     struct bfa_port_cfg_s *port_cfg, struct bfad_vf_s *vf_drv)
+{
+	/* TODO add VF to vf-queue and send to FW*/
+	bfa_fsm_set_state(vf, bfa_fabric_sm_uninit);
+	return BFA_STATUS_OK;
+}
+
+/**
+ * Lookup for a vport withing a fabric given its pwwn
+ */
+struct bfa_vport_s *
+bfa_fabric_vport_lookup(struct bfa_fabric_s *fabric, wwn_t pwwn)
+{
+	struct bfa_vport_s *vport;
+	struct list_head        *qe;
+
+	list_for_each(qe, &fabric->vport_q) {
+		vport = (struct bfa_vport_s *) qe;
+		if (bfa_lport_get_pwwn(&vport->lport) == pwwn)
+			return vport;
+	}
+
+	return NULL;
+}
+
+/**
+ *    In a given fabric, return the number of vports.
+ *
+ *   param[in] fabric - Fabric instance. This can be a base fabric or vf.
+ *
+*   @return : 1 or more.
+ */
+u16
+bfa_fabric_vport_count(struct bfa_fabric_s *fabric)
+{
+	return (fabric->num_vports);
+}
+/**
+ *    update auth parameter. 
+ */
+
+void 
+bfa_vf_auth_update(struct bfa_fabric_s *fabric)
+{
+	struct bfi_fabric_setauth_req_s req;
+
+	req.mh.msg_id = BFI_FABRIC_H2I_SETAUTH;
+	req.fw_handle = fabric->vf_id;  
+	req.algo = fabric->auth.algo;
+	req.group = fabric->auth.group;
+	req.policy = fabric->auth.policy;
+	memcpy(req.secret, fabric->auth.secret, fabric->auth.secret_len);
+	req.secret_len = fabric->auth.secret_len;
+
+	bfi_h2i_set(req.mh, BFI_MC_FABRIC, BFI_FABRIC_H2I_SETAUTH, 
+			bfa_lpuid(fabric->bfa));
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(fabric->bfa, fabric->reqq);
+
+}
+/**
+ *    In a given fabric, return the base port handle.
+ */
+struct bfa_lport_s * 
+bfa_fabric_get_bport(struct bfa_fabric_s *fabric)
+{
+	return &fabric->bport;
+}
+
diff -urpN orig/drivers/scsi/bfa/bfa_fabric.h patch/drivers/scsi/bfa/bfa_fabric.h
--- orig/drivers/scsi/bfa/bfa_fabric.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fabric.h	2009-03-14 11:44:56.986776000 -0700
@@ -0,0 +1,167 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  BFA Fabric interfaces
+ */
+
+#ifndef __BFA_FABRIC_H__
+#define __BFA_FABRIC_H__
+
+#include <bfa_vport.h>
+#include <bfa_lport.h>
+#include <bfa_auth.h>
+#include <bfi/bfi_fabric.h>
+#include <cs/bfa_q.h>
+#include <defs/bfa_defs_vf.h>
+
+/**
+ * P R I V A T E   D E F I N I T I O N S   
+ * - Used & visible to BFA FABRIC module alone (private)
+ */
+
+/*
+ * forward declaration
+ */
+struct bfad_vf_s;
+enum bfa_fabric_state{
+    BFA_FABRIC_UNINIT = 0,
+    BFA_FABRIC_OFFLINE = 1,
+    BFA_FABRIC_ONLINE = 2,
+};
+typedef enum bfa_fabric_state bfa_fabric_state_t;
+/**
+ * Symbolic Name related defines
+ *  Total bytes 255.
+ *  Physical Port's symbolic name 128 bytes.
+ *  For Vports, Vport's symbolic name is appended to the Physical port's
+ *  Symbolic Name.
+ *
+ *  Physical Port's symbolic name Format : (Total 128 bytes)
+ *  Adapter Model number/name : 12 bytes
+ *  Driver Version     : 10 bytes
+ *  Host Machine Name  : 30 bytes
+ *  Host OS Info       : 48 bytes
+ *  Host OS PATCH Info : 16 bytes
+ *  ( remaining 12 bytes reserved to be used for separator)
+ */
+#define BFA_PORT_SYMBNAME_SEPARATOR         " | "
+
+#define BFA_PORT_SYMBNAME_MODEL_SZ          12
+#define BFA_PORT_SYMBNAME_VERSION_SZ        10
+#define BFA_PORT_SYMBNAME_MACHINENAME_SZ    30
+#define BFA_PORT_SYMBNAME_OSINFO_SZ         48
+#define BFA_PORT_SYMBNAME_OSPATCH_SZ        16
+
+
+#define BFA_FABRIC_IPADDR_SZ 256
+
+struct bfa_fabric_s {
+	struct bfa_s *bfa;				/*  bfa instance */
+	bfa_fsm_t       fsm;    /*  BFA fabric state machine */
+	struct bfa_lport_s  bport;		/*  base logical port */
+	enum bfa_fabric_type fab_type;  /*  fabric type loopback, no fabric */
+	enum bfa_pport_type oper_type;	/*  current link topology */
+	u8         is_vf;			/*  is virtual fabric? */
+	u8         is_npiv;		/*  is NPIV supported ? */
+	u8         is_auth;		/*  is Security/Auth supported ? */
+	u16        bb_credit;		/*  BB credit from fabric */
+	u16        vf_id;			/*  virtual fabric ID */
+	u16        num_vports;		/*  num vports */
+	u16        rsvd;
+	struct list_head         vport_q;	/*  queue of virtual ports */
+	struct list_head         vf_q;	/*  queue of virtual fabrics */
+	struct bfad_vf_s      *vf_drv;	/*  driver vf structure */
+	wwn_t           fabric_name;	/*  attached fabric name */
+	u8			fabric_ip_addr[BFA_FABRIC_IPADDR_SZ];  /*  attached fabric's ip addr  */
+	bfa_boolean_t   auth_reqd;		/*  authentication required */
+	union {
+		u16        swp_vfid;	/*  switch port VF id */
+	} event_arg;
+	struct bfa_auth_s  auth;		/*  authentication config */
+	struct bfa_vf_stats_s  stats; 	/*  fabric/vf stats */
+	u8         reqq;       /*  CQ for requests             */
+};
+typedef struct bfa_fabric_s bfa_fabric_t;
+
+#define bfa_fabric_npiv_capable(__f)    (__f)->is_npiv
+#define bfa_fabric_is_switched(__f)     \
+			((__f)->fab_type == FABRIC_SWITCHED)
+
+/**
+ *   The design calls for a single implementation of base fabric and vf.
+ */
+typedef struct bfa_fabric_s bfa_vf_t;
+
+struct bfa_vf_event_s {
+	u32        undefined;
+};
+typedef struct bfa_vf_event_s bfa_vf_event_t;
+
+
+/*
+ * P R O T E C T E D   D E F I N I T I O N S  
+ * - Shared between modules within BFA layer (protected)
+ */
+void            bfa_fabric_add_vport(struct bfa_fabric_s *fabric,
+					struct bfa_vport_s *vport);
+void            bfa_fabric_del_vport(struct bfa_fabric_s *fabric,
+					struct bfa_vport_s *vport);
+struct bfa_vport_s *bfa_fabric_vport_lookup(struct bfa_fabric_s *fabric,
+					     wwn_t pwwn);
+u16        bfa_fabric_vport_count(struct bfa_fabric_s *fabric);
+bfa_boolean_t   bfa_fabric_is_loopback(struct bfa_fabric_s *fabric);
+bfa_boolean_t   bfa_fabric_is_online(struct bfa_fabric_s *fabric);
+enum bfa_pport_type bfa_fabric_port_type(struct bfa_fabric_s *fabric);
+void     		bfa_fabric_psymb_init(struct bfa_fabric_s *fabric);
+bfa_status_t	bfa_fabric_addvf(struct bfa_fabric_s *vf, struct bfa_s *bfa,
+		     struct bfa_port_cfg_s *port_cfg, struct bfad_vf_s *vf_drv);
+struct bfa_lport_s * bfa_fabric_get_bport(struct bfa_fabric_s *fabric);
+void bfa_fabric_isr(struct bfa_s *bfa, struct bfi_msg_s *m);
+
+/**
+ * P U B L I C   D E F I N I T I O N S   
+ * - Shared between BFA layer & Host Drivers (public)
+ */
+bfa_status_t bfa_vf_mode_enable(struct bfa_s *bfa, u16 vf_id);
+bfa_status_t bfa_vf_mode_disable(struct bfa_s *bfa);
+bfa_status_t bfa_vf_create(bfa_vf_t *vf, struct bfa_s *bfa,
+			u16 vf_id, struct bfa_port_cfg_s *port_cfg,
+			struct bfad_vf_s *vf_drv);
+bfa_status_t bfa_vf_delete(bfa_vf_t *vf);
+void bfa_vf_start(bfa_vf_t *vf);
+bfa_status_t bfa_vf_stop(bfa_vf_t *vf);
+void bfa_vf_list(struct bfa_s *bfa, u16 *vf_ids, int *nvfs);
+void bfa_vf_list_all(struct bfa_s *bfa, u16 *vf_ids, int *nvfs);
+void bfa_vf_get_attr(bfa_vf_t *vf, struct bfa_vf_attr_s *vf_attr);
+void bfa_vf_get_stats(bfa_vf_t *vf,
+			struct bfa_vf_stats_s *vf_stats);
+void bfa_vf_clear_stats(bfa_vf_t *vf);
+void bfa_vf_get_ports(bfa_vf_t *vf, wwn_t vpwwn[], int *nports);
+bfa_vf_t *bfa_vf_lookup(struct bfa_s *bfa, u16 vf_id);
+struct bfad_vf_s *bfa_vf_get_drv_vf(bfa_vf_t *vf);
+/**
+ *  Completion callback for bfa_fcs_vf_stop().
+ *
+ * @param[in] vf_drv - driver instance of vf
+ *
+ * @return None
+ */
+void            bfa_cb_vf_stop(struct bfad_vf_s *vf_drv);
+void bfa_vf_auth_update(struct bfa_fabric_s *fabric);
+
+#endif /* __BFA_FABRIC_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_fcdiag.c patch/drivers/scsi/bfa/bfa_fcdiag.c
--- orig/drivers/scsi/bfa/bfa_fcdiag.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fcdiag.c	2009-03-14 11:44:56.996814000 -0700
@@ -0,0 +1,419 @@
+/*
+ * Copyright (c) 2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <defs/bfa_defs_diag.h>
+#include <defs/bfa_defs_pci.h>
+#include <cs/bfa_debug.h>
+#include <bfi/bfi_boot.h>
+#include <bfi/bfi_diag.h>
+
+BFA_TRC_FILE(HAL, FCDIAG);
+BFA_MODULE(fcdiag);
+
+#define BFA_DIAG_QTEST_TOV       	1000	/* msec */
+
+static void bfa_cb_fcdiag_lb(struct bfa_diag_s *diag);
+
+/**
+ *  hal_fcdiag_pvt BFA FCDIAG private functions
+ */
+
+
+static void
+bfa_fcdiag_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,
+		u32 *dm_len)
+{
+}
+
+/**
+ * @param[in] bfa - bfa structure
+ * @param[in] bfad - driver structure
+ * @param[in] cfg - ioc config
+ * @param[in] meminfo - bfa memory info
+ * @param[in] pcidev - pci device
+ */
+static void
+bfa_fcdiag_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		    struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	/* The common DIAG attach bfa_diag_attach() will do all memory claim */
+}
+
+static void
+bfa_fcdiag_iocdisable(struct bfa_s *bfa)
+{
+	struct bfa_diag_s *diag = BFA_DIAG_MOD(bfa);
+
+	bfa_diag_hbfail(diag);
+	if (!diag->lb.lock)
+		return;
+
+	if (diag->lb.lock) {
+		diag->lb.status = BFA_STATUS_IOC_FAILURE;
+		bfa_cb_fcdiag_lb(diag);
+	}
+}
+
+static void
+bfa_fcdiag_initdone(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcdiag_detach(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcdiag_start(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcdiag_stop(struct bfa_s *bfa)
+{
+}
+
+/**
+ * Queue Test
+ */
+static void
+bfa_fcdiag_queuetest_complete(struct bfa_diag_s *diag, bfa_status_t status)
+{
+	bfa_trc(diag, status);
+	diag->qtest.status = status;
+	diag->qtest.cbfn(diag->qtest.cbarg, diag->qtest.status);
+	diag->qtest.lock = 0;
+}
+
+static void
+bfa_fcdiag_queuetest_timeout(void *cbarg)
+{
+	struct bfa_diag_s       *diag = cbarg;
+	struct bfa_diag_qtest_result_s *res = diag->qtest.result;
+
+	bfa_trc(diag, diag->qtest.all);
+	bfa_trc(diag, diag->qtest.count);
+
+	diag->qtest.timer_active = 0;
+
+	res->status = BFA_STATUS_ETIMER;
+	res->count  = QTEST_CNT_DEFAULT - diag->qtest.count;
+	if (diag->qtest.all)
+		res->queue  = diag->qtest.all;
+
+	bfa_fcdiag_queuetest_complete(diag, BFA_STATUS_ETIMER);
+}
+
+static void
+bfa_fcdiag_queuetest_send(struct bfa_diag_s *diag)
+{
+	u32 i;
+
+	/* build message */
+	bfi_diag_qtest_req_t *req;
+
+	req = bfa_reqq_next(diag->bfa, diag->qtest.queue);
+
+	/* build host command */
+	bfi_h2i_set(req->mh, BFI_MC_DIAG, BFI_DIAG_H2I_QTEST, bfa_lpuid(diag->bfa));
+
+	for (i=0; i<BFI_LMSG_PL_WSZ; i++)
+		req->data[i] = QTEST_PAT_DEFAULT;
+
+	bfa_trc(diag, diag->qtest.queue);
+	/* ring door bell */
+	bfa_reqq_produce(diag->bfa, diag->qtest.queue);
+}
+
+static void
+bfa_fcdiag_queuetest_comp(struct bfa_diag_s *diag, bfi_diag_qtest_rsp_t *rsp)
+{
+	struct bfa_diag_qtest_result_s *res = diag->qtest.result;
+	int i;
+
+	/* Check timer, should still be active	 */
+	if (!diag->qtest.timer_active) {
+		bfa_trc(diag, diag->qtest.timer_active);
+		return;
+	}
+
+	/* update count */
+	diag->qtest.count--;
+
+	/* Check result */
+	for (i=0; i<BFI_LMSG_PL_WSZ; i++) {
+		if (rsp->data[i] != ~(QTEST_PAT_DEFAULT)) {
+			res->status = BFA_STATUS_DATACORRUPTED;
+			break;
+		}
+	}
+
+	if (res->status == BFA_STATUS_OK) {
+		if (diag->qtest.count > 0) {
+			bfa_fcdiag_queuetest_send(diag);
+			return;
+		} else if (diag->qtest.all > 0 &&
+				   diag->qtest.queue < (BFI_IOC_MAX_CQS - 1)) {
+			diag->qtest.count = QTEST_CNT_DEFAULT;
+			diag->qtest.queue ++;
+			bfa_fcdiag_queuetest_send(diag);
+			return;
+		}
+	}
+
+	/* Complete */
+	/* 
+	 * Stop timer when we comp all queue
+	 */
+	if (diag->qtest.timer_active) {
+		bfa_timer_stop(&diag->qtest.timer);
+		diag->qtest.timer_active = 0;
+	}
+	res->queue = diag->qtest.queue;
+	res->count = QTEST_CNT_DEFAULT - diag->qtest.count;
+	bfa_trc(diag, res->count);
+	bfa_fcdiag_queuetest_complete(diag, res->status);
+}
+
+/**
+ * Loopback
+ */
+static void
+bfa_cb_fcdiag_lb(struct bfa_diag_s *diag)
+{
+	diag->lb.cbfn(diag->lb.cbarg, diag->lb.status);
+	diag->lb.lock = 0;
+	bfa_diag_set_busy_status(diag);
+}
+
+static void
+bfa_fcdiag_loopback_comp(struct bfa_diag_s *diag, struct bfi_diag_lb_rsp_s *rsp)
+{
+	struct bfa_diag_loopback_result_s *res = diag->lb.result;
+
+	res->numtxmfrm	= bfa_os_ntohl(rsp->res.numtxmfrm);
+	res->numosffrm	= bfa_os_ntohl(rsp->res.numosffrm);
+	res->numrcvfrm	= bfa_os_ntohl(rsp->res.numrcvfrm);
+	res->badfrminf	= bfa_os_ntohl(rsp->res.badfrminf);
+	res->badfrmnum	= bfa_os_ntohl(rsp->res.badfrmnum);
+	res->status	= rsp->res.status;
+	diag->lb.status = rsp->res.status;
+	bfa_trc(diag, diag->lb.status);
+	bfa_cb_fcdiag_lb(diag);
+}
+
+static void
+bfa_fcdiag_loopback_send(struct bfa_diag_s *diag, struct bfa_diag_loopback_s *loopback)
+{
+	/* build message */
+	struct bfi_diag_lb_req_s *lb_req;
+
+	lb_req = bfa_reqq_next(diag->bfa, BFA_REQQ_DIAG);
+
+	/* build host command */
+	bfi_h2i_set(lb_req->mh, BFI_MC_DIAG, BFI_DIAG_H2I_LOOPBACK,
+			bfa_lpuid(diag->bfa));
+
+	lb_req->lb_mode = loopback->lb_mode;
+	lb_req->speed = loopback->speed;
+	lb_req->loopcnt = loopback->loopcnt;
+	lb_req->pattern = loopback->pattern;
+
+	/* ring door bell */
+	bfa_reqq_produce(diag->bfa, BFA_REQQ_DIAG);
+
+	bfa_trc(diag, loopback->lb_mode);
+	bfa_trc(diag, loopback->speed);
+	bfa_trc(diag, loopback->loopcnt);
+	bfa_trc(diag, loopback->pattern);
+}
+
+
+
+/**
+ *  hal_fcdiag_public
+ */
+
+/**
+ * @ Diag cpe/rme intr handler 
+ */
+void
+bfa_fcdiag_intr(struct bfa_s *bfa, struct bfi_msg_s *msg)
+{
+	struct bfa_diag_s *diag = BFA_DIAG_MOD(bfa);
+
+	switch (msg->mhdr.msg_id) {
+	case BFI_DIAG_I2H_LOOPBACK:
+		bfa_fcdiag_loopback_comp(diag, (struct bfi_diag_lb_rsp_s *) msg);
+		break;
+
+	case BFI_DIAG_I2H_QTEST:
+		bfa_fcdiag_queuetest_comp(diag, (bfi_diag_qtest_rsp_t *) msg);
+		break;
+
+
+	default:
+		bfa_trc(diag, msg->mhdr.msg_id);
+		bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  hal_fcdiag_api
+ */
+/**
+ * Loopback test
+ *
+ *   @param[in] *diag		- diag data struct
+ *   @param[in] opmode		- port operation mode
+ *   @param[in] speed		- port speed
+ *   @param[in] lpcnt		- loop count
+ *   @param[in] pat			- pattern to build packet
+ *   @param[in] *result		- pt to bfa_diag_loopback_result_t data struct
+ *   @param[in] cbfn		- callback function
+ *   @param[in] cbarg		- callback functioin arg
+ *
+ *   @param[out]
+ */
+bfa_status_t
+bfa_diag_loopback(struct bfa_diag_s *diag, enum bfa_pport_opmode opmode,
+		      enum bfa_pport_speed speed, u32 lpcnt, u32 pat,
+		      struct bfa_diag_loopback_result_s *result, bfa_cb_diag_t cbfn,
+		      void *cbarg)
+{
+	struct bfa_diag_loopback_s loopback;
+	struct bfa_pport_attr_s attr;
+
+	/*
+	 * Check to see if IOC is down
+	 */
+	if (!bfa_iocfc_is_operational(diag->bfa))
+		return BFA_STATUS_IOC_NON_OP;
+
+	/*
+	 * Check to see if port is disable
+	 */
+	if (bfa_pport_is_disabled(diag->bfa) == BFA_FALSE) {
+		bfa_trc(diag, opmode);
+		return (BFA_STATUS_PORT_NOT_DISABLED);
+	}
+
+	/*
+	 * Check if the speed is supported
+	 */
+	bfa_pport_get_attr(diag->bfa, &attr);
+	bfa_trc(diag, attr.speed_supported);
+	if (speed > attr.speed_supported) 
+		return BFA_STATUS_UNSUPP_SPEED;
+
+	/*
+	 * check to see if there is another destructive diag cmd running
+	 */
+	if (diag->block || diag->lb.lock) {
+		bfa_trc(diag, diag->block);
+		bfa_trc(diag, diag->lb.lock);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	diag->lb.lock = 1;
+	loopback.lb_mode = opmode;
+	loopback.speed = speed;
+	loopback.loopcnt = lpcnt;
+	loopback.pattern = pat;
+	diag->lb.result = result;
+	diag->lb.cbfn = cbfn;
+	diag->lb.cbarg = cbarg;
+	bfa_os_memset(result, 0, sizeof(struct bfa_diag_loopback_result_s));
+	bfa_diag_set_busy_status(diag);
+
+	/* Send msg to fw */
+	bfa_fcdiag_loopback_send(diag, &loopback);
+
+	return (BFA_STATUS_OK);
+}
+
+/**
+ * DIAG queue test command
+ *
+ *   @param[in] *diag		- diag data struct
+ *   @param[in] force		- 1: don't do ioc op checking
+ *   @param[in] queue		- queue no. to test
+ *   @param[in] *result		- pt to bfa_diag_qtest_result_t data struct
+ *   @param[in] cbfn		- callback function
+ *   @param[in] *cbarg		- callback functioin arg
+ *
+ *   @param[out]
+ */
+bfa_status_t
+bfa_diag_queuetest(struct bfa_diag_s *diag, u32 force, u32 queue, 
+				   struct bfa_diag_qtest_result_s *result, bfa_cb_diag_t cbfn, 
+				   void *cbarg)
+{
+	bfa_trc(diag, force);
+	bfa_trc(diag, queue);
+
+	/* 
+	 * Check IOC state if not force
+	 */
+	if (!force && !bfa_iocfc_is_operational(diag->bfa))
+		return BFA_STATUS_IOC_NON_OP;
+
+	/*
+	 * check to see if there is another destructive diag cmd running
+	 */
+	if (diag->block || diag->qtest.lock) {
+		bfa_trc(diag, diag->block);
+		bfa_trc(diag, diag->qtest.lock);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	/* Initialization */
+	diag->qtest.lock = 1;
+	diag->qtest.cbfn = cbfn;
+	diag->qtest.cbarg = cbarg;
+	diag->qtest.result = result;
+	diag->qtest.count = QTEST_CNT_DEFAULT;
+		
+	/* Init test results */
+	diag->qtest.result->status = BFA_STATUS_OK;
+	diag->qtest.result->count  = 0;
+
+	/* send */
+	if (queue < BFI_IOC_MAX_CQS) {
+		diag->qtest.result->queue  = (u8)queue;
+		diag->qtest.queue = (u8)queue;
+		diag->qtest.all   = 0;
+	} else {
+		diag->qtest.result->queue  = 0;
+		diag->qtest.queue = 0;
+		diag->qtest.all   = 1;
+	}
+	bfa_fcdiag_queuetest_send(diag);
+
+	/*
+	 * Start a timer
+	 */
+	bfa_timer_begin(diag->ioc->timer_mod, &diag->qtest.timer, 
+					bfa_fcdiag_queuetest_timeout, diag, BFA_DIAG_QTEST_TOV);
+	diag->qtest.timer_active = 1;
+	return (BFA_STATUS_OK);
+}
+
diff -urpN orig/drivers/scsi/bfa/bfa_fcpim.c patch/drivers/scsi/bfa/bfa_fcpim.c
--- orig/drivers/scsi/bfa/bfa_fcpim.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fcpim.c	2009-03-14 11:44:57.006790000 -0700
@@ -0,0 +1,187 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <log/bfa_log_hal.h>
+
+BFA_TRC_FILE(HAL, FCPIM);
+BFA_MODULE(fcpim);
+
+/**
+ *  hal_fcpim_mod BFA FCP Initiator Mode module
+ */
+
+/**
+ * 		Compute and return memory needed by FCP(im) module.
+ */
+static void
+bfa_fcpim_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+		u32 *dm_len)
+{
+	bfa_itnim_meminfo(cfg, km_len, dm_len);
+
+	/**
+	 * IO memory
+	 */
+	if (cfg->fwcfg.num_ioim_reqs < BFA_IOIM_MIN)
+		cfg->fwcfg.num_ioim_reqs = BFA_IOIM_MIN;
+	*km_len += cfg->fwcfg.num_ioim_reqs *
+	  (sizeof(struct bfa_ioim_s) + sizeof(struct bfa_ioim_sp_s));
+
+	*dm_len += cfg->fwcfg.num_ioim_reqs * BFI_IOIM_SNSLEN;
+
+	/**
+	 * task management command memory
+	 */
+	if (cfg->fwcfg.num_tskim_reqs < BFA_TSKIM_MIN)
+		cfg->fwcfg.num_tskim_reqs = BFA_TSKIM_MIN;
+	*km_len += cfg->fwcfg.num_tskim_reqs * sizeof(struct bfa_tskim_s);
+}
+
+
+static void
+bfa_fcpim_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		     struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+
+	bfa_trc(bfa, cfg->drvcfg.path_tov);
+	bfa_trc(bfa, cfg->fwcfg.num_rports);
+	bfa_trc(bfa, cfg->fwcfg.num_ioim_reqs);
+	bfa_trc(bfa, cfg->fwcfg.num_tskim_reqs);
+
+	fcpim->bfa            = bfa;
+	fcpim->num_itnims     = cfg->fwcfg.num_rports;
+	fcpim->num_ioim_reqs  = cfg->fwcfg.num_ioim_reqs;
+	fcpim->num_tskim_reqs = cfg->fwcfg.num_tskim_reqs;
+	fcpim->path_tov       = cfg->drvcfg.path_tov;
+	fcpim->delay_comp	  = cfg->drvcfg.delay_comp;
+
+	bfa_itnim_attach(fcpim, meminfo);
+	bfa_tskim_attach(fcpim, meminfo);
+	bfa_ioim_attach(fcpim, meminfo);
+}
+
+static void
+bfa_fcpim_initdone(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcpim_detach(struct bfa_s *bfa)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+
+	bfa_ioim_detach(fcpim);
+	bfa_tskim_detach(fcpim);
+}
+
+static void
+bfa_fcpim_start(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcpim_stop(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcpim_iocdisable(struct bfa_s *bfa)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	struct bfa_itnim_s *itnim;
+	struct list_head        *qe, *qen;
+
+	list_for_each_safe(qe, qen, &fcpim->itnim_q) {
+		itnim = (struct bfa_itnim_s *) qe;
+		bfa_itnim_iocdisable(itnim);
+	}
+}
+
+void
+bfa_fcpim_path_tov_set(struct bfa_s *bfa, u16 path_tov)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+
+	fcpim->path_tov = path_tov * 1000;
+	if (fcpim->path_tov > BFA_FCPIM_PATHTOV_MAX)
+		fcpim->path_tov = BFA_FCPIM_PATHTOV_MAX;
+}
+
+u16
+bfa_fcpim_path_tov_get(struct bfa_s *bfa)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+
+	return (fcpim->path_tov / 1000);
+}
+
+void
+bfa_fcpim_qdepth_set(struct bfa_s *bfa, u16 q_depth)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+
+	bfa_assert(q_depth <= BFA_IOCFC_QDEPTH_MAX);
+
+	fcpim->q_depth = q_depth;
+}
+
+u16
+bfa_fcpim_qdepth_get(struct bfa_s *bfa)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+
+	return (fcpim->q_depth);
+}
+bfa_status_t 
+bfa_itnim_stats_get(struct bfa_lport_s *port, wwn_t rpwwn,
+            struct bfa_itnim_stats_s *stats)
+{
+	return 0;
+}
+bfa_status_t 
+bfa_itnim_stats_clear(struct bfa_lport_s *port,
+            wwn_t rpwwn)
+{
+	return 0;
+}
+struct bfa_itnim_s *
+bfa_itnim_lookup(struct bfa_lport_s *port,
+            wwn_t rpwwn)
+{
+	return NULL;
+}
+bfa_status_t 
+bfa_itnim_attr_get(struct bfa_lport_s *port, wwn_t rpwwn,
+            struct bfa_itnim_attr_s *attr)
+{
+	return 0;
+}
+int
+bfa_itnim_get_maxfrsize(struct bfa_itnim_s *itnim)
+{
+	return 0;
+}
+/* supported classes*/
+int 
+bfa_itnim_get_cos(struct bfa_itnim_s *itnim)
+{
+	return 0;
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_fcpim.h patch/drivers/scsi/bfa/bfa_fcpim.h
--- orig/drivers/scsi/bfa/bfa_fcpim.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fcpim.h	2009-03-14 11:44:57.019386000 -0700
@@ -0,0 +1,409 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_FCPIM_H__
+#define __BFA_FCPIM_H__
+
+#include <protocol/fcp.h>
+#include <cs/bfa_wc.h>
+#include <bfa_lport.h>
+#include <bfi/bfi_fcpim.h>
+#include "bfa_sgpg_priv.h"
+
+#define BFA_ITNIM_MIN   32
+#define BFA_ITNIM_MAX   1024
+
+#define BFA_IOIM_MIN    8
+#define BFA_IOIM_MAX    2000
+
+#define BFA_TSKIM_MIN   4
+#define BFA_TSKIM_MAX   512
+#define BFA_FCPIM_PATHTOV_DEF	(30 * 1000)	/* in millisecs */
+#define BFA_FCPIM_PATHTOV_MAX	(90 * 1000)	/* in millisecs */
+
+struct bfa_fcpim_stats_s {
+	u32        total_ios;	/*  Total IO count */
+	u32        qresumes;	/*  IO waiting for CQ space */
+	u32        no_iotags;	/*  NO IO contexts */
+	u32        io_aborts;	/*  IO abort requests */
+	u32        no_tskims;	/*  NO task management contexts */
+	u32        iocomp_ok;	/*  IO completions with OK status */
+	u32        iocomp_underrun;	/*  IO underrun (good) */
+	u32        iocomp_overrun;	/*  IO overrun (good) */
+	u32        iocomp_aborted;	/*  Aborted IO requests */
+	u32        iocomp_timedout;	/*  IO timeouts */
+	u32        iocom_nexus_abort;	/*  IO selection timeouts */
+	u32        iocom_proto_err;	/*  IO protocol errors */
+	u32        iocom_dif_err;	/*  IO SBC-3 protection errors */
+	u32        iocom_tm_abort;	/*  IO aborted by TM requests */
+	u32        iocom_sqer_needed;	/*  IO retry for SQ error
+						 *recovery */
+	u32        iocom_res_free;	/*  Delayed freeing of IO resources */
+	u32        iocomp_scsierr;	/*  IO with non-good SCSI status */
+	u32        iocom_hostabrts;	/*  Host IO abort requests */
+	u32        iocom_utags;	/*  IO comp with unknown tags */
+	u32        io_cleanups;	/*  IO implicitly aborted */
+	u32        io_tmaborts;	/*  IO aborted due to TM commands */
+	u32        rsvd;
+};
+#define bfa_fcpim_stats(__fcpim, __stats)   \
+    (__fcpim)->stats.__stats ++
+
+#define BFA_ITNIM_FROM_TAG(_fcpim, _tag)                \
+    ((_fcpim)->itnim_arr + ((_tag) & ((_fcpim)->num_itnims - 1)))
+
+struct bfa_fcpim_mod_s {
+	struct bfa_s 	*bfa;
+	struct bfa_itnim_s 	*itnim_arr;
+	struct bfa_ioim_s 	*ioim_arr;
+	struct bfa_ioim_sp_s *ioim_sp_arr;
+	struct bfa_tskim_s 	*tskim_arr;
+	struct bfa_dma_s	snsbase;
+	int			num_itnims;
+	int			num_ioim_reqs;
+	int			num_tskim_reqs;
+	u32		path_tov;
+	u16		q_depth;
+	u16		rsvd;
+	struct list_head 		itnim_q;        /*  queue of active itnim    */
+	struct list_head 		ioim_free_q;    /*  free IO resources        */
+	struct list_head 		ioim_resfree_q; /*  IOs waiting for f/w      */
+	struct list_head 		ioim_comp_q;    /*  IO global comp Q         */
+	struct list_head 		tskim_free_q;
+	u32		ios_active;	/*  current active IOs	      */
+	u32		delay_comp;
+	struct bfa_fcpim_stats_s stats;
+};
+
+struct bfa_ioim_s;
+struct bfa_tskim_s;
+
+/**
+ * BFA IO (initiator mode)
+ */
+struct bfa_ioim_s {
+	struct list_head 		qe;		/*  queue elememt            */
+	bfa_sm_t		sm; 		/*  BFA ioim state machine   */
+	struct bfa_s 	        *bfa;		/*  BFA module               */
+	struct bfa_fcpim_mod_s	*fcpim;		/*  parent fcpim module      */
+	struct bfa_itnim_s 	*itnim;		/*  i-t-n nexus for this IO  */
+	struct bfad_ioim_s 	*dio;		/*  driver IO handle         */
+	u16		iotag;		/*  FWI IO tag               */
+	u16		abort_tag;	/*  unqiue abort request tag */
+	u16		nsges;		/*  number of SG elements    */
+	u16		nsgpgs;		/*  number of SG pages       */
+	struct bfa_sgpg_s	*sgpg;		/*  first SG page            */
+	struct list_head 		sgpg_q;		/*  allocated SG pages       */
+	struct bfa_cb_qe_s	hcb_qe;		/*  bfa callback qelem       */
+	bfa_cb_cbfn_t		io_cbfn;	/*  IO completion handler    */
+	struct bfa_ioim_sp_s *iosp;		/*  slow-path IO handling    */
+};
+
+struct bfa_ioim_sp_s {
+	struct bfi_msg_s 	comp_rspmsg;	/*  IO comp f/w response     */
+	u8			*snsinfo;	/*  sense info for this IO   */
+	struct bfa_sgpg_wqe_s sgpg_wqe;	/*  waitq elem for sgpg      */
+	struct bfa_reqq_wait_s reqq_wait;	/*  to wait for room in reqq */
+	bfa_boolean_t		abort_explicit;	/*  aborted by OS            */
+	struct bfa_tskim_s	*tskim;		/*  Relevant TM cmd          */
+};
+
+/**
+ * BFA Task management command (initiator mode)
+ */
+struct bfa_tskim_s {
+	struct list_head          qe;
+	bfa_sm_t		sm;
+	struct bfa_s            *bfa;        /*  BFA module  */
+	struct bfa_fcpim_mod_s  *fcpim;      /*  parent fcpim module      */
+	struct bfa_itnim_s      *itnim;      /*  i-t-n nexus for this IO  */
+	struct bfad_tskim_s         *dtsk;   /*  driver task mgmt cmnd    */
+	bfa_boolean_t        notify;         /*  notify itnim on TM comp  */
+	lun_t                lun;            /*  lun if applicable        */
+	fcp_tm_cmnd_t        tm_cmnd;        /*  task management command  */
+	u16             tsk_tag;        /*  FWI IO tag               */
+	u8              tsecs;          /*  timeout in seconds       */
+	struct bfa_reqq_wait_s  reqq_wait;   /*  to wait for room in reqq */
+	struct list_head              io_q;    /*  queue of affected IOs    */
+	struct bfa_wc_s             wc;      /*  waiting counter          */
+	struct bfa_cb_qe_s	hcb_qe;      /*  bfa callback qelem       */
+	enum bfi_tskim_status   tsk_status;  /*  TM status                */
+};
+
+/**
+ * BFA i-t-n (initiator mode)
+ */
+struct bfa_itnim_s {
+	struct list_head    qe;		/*  queue element               */
+	bfa_sm_t	  sm;		/*  i-t-n im BFA state machine  */
+	struct bfa_s      *bfa;		/*  bfa instance                */
+	struct bfa_rport_s *rport;	/*  bfa rport                   */
+	void           *ditn;		/*  driver i-t-n structure      */
+	struct bfi_mhdr_s      mhdr;	/*  pre-built mhdr              */
+	u8         msg_no;		/*  itnim/rport firmware handle */
+	u8         reqq;		/*  CQ for requests             */
+	struct bfa_cb_qe_s    hcb_qe;	/*  bfa callback qelem          */
+	struct list_head pending_q;	/*  queue of pending IO requests*/
+	struct list_head io_q;		/*  queue of active IO requests */
+	struct list_head io_cleanup_q;	/*  IO being cleaned up         */
+	struct list_head tsk_q;		/*  queue of active TM commands */
+	struct list_head         delay_comp_q;/*  queue of failed inflight cmds */
+	bfa_boolean_t   seq_rec;	/*  SQER supported              */
+	bfa_boolean_t   rec_support;	/*  REC supported              */
+	bfa_boolean_t   conf_comp;	/*  FCP_CONF supported         */
+	bfa_boolean_t   task_retry_id;	/*  task retry id supprted     */
+	bfa_boolean_t   is_online;	/*  itnim is ONLINE for IO      */
+	bfa_boolean_t   iotov_active;	/*  IO TOV timer is active	 */
+	struct bfa_wc_s        wc;	/*  waiting counter             */
+	struct bfa_timer_s timer;	/*  pending IO TOV		 */
+	struct bfa_reqq_wait_s reqq_wait; /*  to wait for room in reqq */
+	struct bfa_fcpim_mod_s *fcpim;	/*  fcpim module                */
+	struct bfa_itnim_stats_s	itnim_stats;
+	struct bfa_itnim_hal_stats_s	stats;
+};
+
+#define bfa_itnim_is_online(_itnim) (_itnim)->is_online
+#define BFA_FCPIM_MOD(_hal) (&(_hal)->modules.fcpim_mod)
+#define BFA_IOIM_FROM_TAG(_fcpim, _iotag)	\
+	(&fcpim->ioim_arr[_iotag])
+#define BFA_TSKIM_FROM_TAG(_fcpim, _tmtag)                  \
+    (&fcpim->tskim_arr[_tmtag & (fcpim->num_tskim_reqs - 1)])
+
+/*
+ * function prototypes
+ */
+void            bfa_ioim_attach(struct bfa_fcpim_mod_s *fcpim,
+				    struct bfa_meminfo_s *minfo);
+void            bfa_ioim_detach(struct bfa_fcpim_mod_s *fcpim);
+void            bfa_ioim_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+void            bfa_ioim_good_comp_isr(struct bfa_s *bfa,
+					struct bfi_msg_s *msg);
+void            bfa_ioim_cleanup(struct bfa_ioim_s *ioim);
+void            bfa_ioim_cleanup_tm(struct bfa_ioim_s *ioim,
+					struct bfa_tskim_s *tskim);
+void            bfa_ioim_iocdisable(struct bfa_ioim_s *ioim);
+void            bfa_ioim_tov(struct bfa_ioim_s *ioim);
+
+void            bfa_tskim_attach(struct bfa_fcpim_mod_s *fcpim,
+				     struct bfa_meminfo_s *minfo);
+void            bfa_tskim_detach(struct bfa_fcpim_mod_s *fcpim);
+void            bfa_tskim_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+void            bfa_tskim_iodone(struct bfa_tskim_s *tskim);
+void            bfa_tskim_iocdisable(struct bfa_tskim_s *tskim);
+void            bfa_tskim_cleanup(struct bfa_tskim_s *tskim);
+
+void            bfa_itnim_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+				      u32 *dm_len);
+void            bfa_itnim_attach(struct bfa_fcpim_mod_s *fcpim,
+				     struct bfa_meminfo_s *minfo);
+void            bfa_itnim_detach(struct bfa_fcpim_mod_s *fcpim);
+void            bfa_itnim_iocdisable(struct bfa_itnim_s *itnim);
+void            bfa_itnim_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+void            bfa_itnim_iodone(struct bfa_itnim_s *itnim);
+void            bfa_itnim_tskdone(struct bfa_itnim_s *itnim);
+void		bfa_itnim_qresume(void *cbarg);
+bfa_boolean_t   bfa_itnim_hold_io(struct bfa_itnim_s *itnim);
+
+
+/**
+ * P U B L I C   D E F I N I T I O N S   - Shared between BFA layer & Host Drivers (public)
+ */
+struct bfad_s;
+struct bfad_itnim_s;
+
+struct bfa_itnim_s;
+typedef struct bfa_itnim_s bfa_itnim_t;
+struct bfa_ioim_s;
+typedef struct bfa_ioim_s bfa_ioim_t;
+struct bfa_tskim_s;
+typedef struct bfa_tskim_s bfa_tskim_t;
+struct bfad_ioim_s;
+typedef struct bfad_ioim_s bfad_ioim_t;
+struct bfad_tskim_s;
+typedef struct bfad_tskim_s bfad_tskim_t;
+
+/*
+ * bfa fcpim module API functions
+ */
+void            bfa_fcpim_path_tov_set(struct bfa_s *bfa, u16 path_tov);
+u16        bfa_fcpim_path_tov_get(struct bfa_s *bfa);
+void            bfa_fcpim_qdepth_set(struct bfa_s *bfa, u16 q_depth);
+u16        bfa_fcpim_qdepth_get(struct bfa_s *bfa);
+
+/*
+ * bfa itnim API function for allocation
+ */
+void	bfa_cb_itnim_alloc(struct bfad_s *bfad, struct bfa_itnim_s **itnim,
+                    struct bfad_itnim_s **itnim_drv);
+/*
+ * bfa itnim API functions
+ */
+struct bfa_itnim_s *bfa_itnim_create(struct bfa_s *bfa,
+                                        struct bfa_rport_s *rport, void *itnim);
+void            bfa_itnim_delete(struct bfa_itnim_s *itnim);
+void            bfa_itnim_online(struct bfa_itnim_s *itnim,
+                                 bfa_boolean_t seq_rec);
+void            bfa_itnim_offline(struct bfa_itnim_s *itnim);
+void            bfa_itnim_clear_stats(struct bfa_itnim_s *itnim);
+
+/** 
+ *              HAL completion callback for bfa_itnim_online().
+ *
+ * @param[in]           itnim            driver itnim instance
+ *  
+ * return None 
+ */ 
+void            bfa_cb_itnim_online(void *itnim);
+
+/**
+ *              HAL completion callback for bfa_itnim_offline().
+ *
+ * @param[in]           itnim            driver itnim instance
+ *
+ * return None
+ */
+void            bfa_cb_itnim_offline(void *itnim);
+void            bfa_cb_itnim_tov_begin(void *itnim);
+void            bfa_cb_itnim_tov(void *itnim);
+
+/**
+ *              HAL notification to driver for second level error recovery.
+ *
+ * Atleast one I/O request has timedout and target is unresponsive to
+ * repeated abort requests. Second level error recovery should be initiated
+ * by starting implicit logout and recovery procedures.
+ *
+ * @param[in]           itnim            driver itnim instance
+ *
+ * return None
+ */
+void            bfa_cb_itnim_sler(void *itnim);
+
+
+/*
+ * bfa ioim API functions
+ */
+struct bfa_ioim_s       *bfa_ioim_alloc(struct bfa_s *bfa,
+                                        struct bfad_ioim_s *dio,
+                                        struct bfa_itnim_s *itnim,
+                                        u16 nsgles);
+
+void            bfa_ioim_free(struct bfa_ioim_s *ioim);
+void            bfa_ioim_start(struct bfa_ioim_s *ioim);
+void            bfa_ioim_abort(struct bfa_ioim_s *ioim);
+void            bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim,
+                                      bfa_boolean_t iotov);
+
+
+/**
+ *              I/O completion notification.
+ *
+ * @param[in]           dio                     driver IO structure
+ * @param[in]           io_status               IO completion status
+ * @param[in]           scsi_status             SCSI status returned by target
+ * @param[in]           sns_len                 SCSI sense length, 0 if none
+ * @param[in]           sns_info                SCSI sense data, if any
+ * @param[in]           residue                 Residual length
+ *
+ * @return None
+ */
+void            bfa_cb_ioim_done(void *bfad, struct bfad_ioim_s *dio,
+                                  enum bfi_ioim_status io_status,
+                                  u8 scsi_status, int sns_len,
+                                  u8 *sns_info, s32 residue);
+
+/**
+ *              I/O good completion notification.
+ *
+ * @param[in]           dio                     driver IO structure
+ *
+ * @return None
+ */
+void            bfa_cb_ioim_good_comp(void *bfad, struct bfad_ioim_s *dio);
+
+/**
+ *              I/O abort completion notification
+ *
+ * @param[in]           dio                     driver IO that was aborted
+ *
+ * @return None
+ */
+void            bfa_cb_ioim_abort(void *bfad, struct bfad_ioim_s *dio);
+void            bfa_cb_ioim_resfree(void *hcb_bfad);
+
+void                    bfa_cb_ioim_resfree(void *hcb_bfad);
+
+/*
+ * bfa tskim API functions
+ */
+struct bfa_tskim_s      *bfa_tskim_alloc(struct bfa_s *bfa,
+                                        struct bfad_tskim_s *dtsk);
+void            bfa_tskim_free(struct bfa_tskim_s *tskim);
+void            bfa_tskim_start(struct bfa_tskim_s *tskim,
+                                struct bfa_itnim_s *itnim, lun_t lun,
+                                fcp_tm_cmnd_t tm, u8 t_secs);
+void            bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *dtsk,
+                                  enum bfi_tskim_status tsk_status);
+/**
+ * bfa FCP Initiator mode API functions
+ */
+void bfa_itnim_get_attr(struct bfa_itnim_s *itnim,
+            struct bfa_itnim_attr_s *attr);
+void bfa_itnim_get_stats(struct bfa_itnim_s *itnim,
+            struct bfa_itnim_stats_s *stats);
+struct bfa_itnim_s *bfa_itnim_lookup(struct bfa_lport_s *port,
+            wwn_t rpwwn);
+bfa_status_t bfa_itnim_attr_get(struct bfa_lport_s *port, wwn_t rpwwn,
+            struct bfa_itnim_attr_s *attr);
+bfa_status_t bfa_itnim_stats_get(struct bfa_lport_s *port, wwn_t rpwwn,
+            struct bfa_itnim_stats_s *stats);
+bfa_status_t bfa_itnim_stats_clear(struct bfa_lport_s *port,
+            wwn_t rpwwn);
+
+static inline struct bfad_port_s *
+bfa_itnim_get_drvport(struct bfa_itnim_s *itnim)
+{
+ //   return itnim->rport->port->bfad_port; TODO
+    return NULL;
+}
+
+static inline wwn_t
+bfa_itnim_get_nwwn(struct bfa_itnim_s *itnim)
+{
+    return itnim->rport->rport_info.nwwn;
+}
+
+
+static inline wwn_t
+bfa_itnim_get_pwwn(struct bfa_itnim_s *itnim)
+{
+    return itnim->rport->rport_info.pwwn;
+}
+
+
+static inline u32
+bfa_itnim_get_fcid(struct bfa_itnim_s *itnim)
+{
+    return itnim->rport->rport_info.pid;
+}
+int bfa_itnim_get_maxfrsize(struct bfa_itnim_s *itnim);
+int bfa_itnim_get_cos(struct bfa_itnim_s *itnim);
+
+
+
+#endif /* __BFA_FCPIM_H__ */
+
diff -urpN orig/drivers/scsi/bfa/bfa_fcxp.c patch/drivers/scsi/bfa/bfa_fcxp.c
--- orig/drivers/scsi/bfa/bfa_fcxp.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fcxp.c	2009-03-14 11:44:57.037181000 -0700
@@ -0,0 +1,713 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <bfi/bfi_uf.h>
+#include <cs/bfa_debug.h>
+
+BFA_TRC_FILE(HAL, FCXP);
+BFA_MODULE(fcxp);
+
+/**
+ * forward declarations
+ */
+static void     __bfa_fcxp_send_cbfn(void *cbarg, bfa_boolean_t complete);
+static void     hal_fcxp_rx_plog(struct bfa_s *bfa, struct bfa_fcxp_s *fcxp,
+				 struct bfi_fcxp_send_rsp_s *fcxp_rsp);
+static void     hal_fcxp_tx_plog(struct bfa_s *bfa, u32 reqlen,
+				 struct bfa_fcxp_s *fcxp, fchs_t *fchs);
+
+/**
+ *  fcxp_pvt BFA FCXP private functions
+ */
+
+static void
+claim_fcxp_req_rsp_mem(struct bfa_fcxp_mod_s *mod, struct bfa_meminfo_s *mi)
+{
+	u8        *dm_kva = NULL;
+	u64        dm_pa;
+	u32        buf_pool_sz;
+
+	dm_kva = bfa_meminfo_dma_virt(mi);
+	dm_pa = bfa_meminfo_dma_phys(mi);
+
+	buf_pool_sz = mod->req_pld_sz * mod->num_fcxps;
+
+	/*
+	 * Initialize the fcxp req payload list
+	 */
+	mod->req_pld_list_kva = dm_kva;
+	mod->req_pld_list_pa = dm_pa;
+	dm_kva += buf_pool_sz;
+	dm_pa += buf_pool_sz;
+	bfa_os_memset(mod->req_pld_list_kva, 0, buf_pool_sz);
+
+	/*
+	 * Initialize the fcxp rsp payload list
+	 */
+	buf_pool_sz = mod->rsp_pld_sz * mod->num_fcxps;
+	mod->rsp_pld_list_kva = dm_kva;
+	mod->rsp_pld_list_pa = dm_pa;
+	dm_kva += buf_pool_sz;
+	dm_pa += buf_pool_sz;
+	bfa_os_memset(mod->rsp_pld_list_kva, 0, buf_pool_sz);
+
+	bfa_meminfo_dma_virt(mi) = dm_kva;
+	bfa_meminfo_dma_phys(mi) = dm_pa;
+}
+
+static void
+claim_fcxps_mem(struct bfa_fcxp_mod_s *mod, struct bfa_meminfo_s *mi)
+{
+	u16        i;
+	struct bfa_fcxp_s *fcxp;
+
+	fcxp = (struct bfa_fcxp_s *) bfa_meminfo_kva(mi);
+	bfa_os_memset(fcxp, 0, sizeof(struct bfa_fcxp_s) * mod->num_fcxps);
+
+	INIT_LIST_HEAD(&mod->fcxp_free_q);
+	INIT_LIST_HEAD(&mod->fcxp_active_q);
+
+	mod->fcxp_list = fcxp;
+
+	for (i = 0; i < mod->num_fcxps; i++) {
+		fcxp->fcxp_mod = mod;
+		fcxp->fcxp_tag = i;
+
+		list_add_tail(&fcxp->qe, &mod->fcxp_free_q);
+		fcxp = fcxp + 1;
+	}
+
+	bfa_meminfo_kva(mi) = (void *)fcxp;
+}
+
+static void
+bfa_fcxp_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,
+		u32 *dm_len)
+{
+	u16        num_fcxp_reqs = cfg->fwcfg.num_fcxp_reqs;
+
+	if (num_fcxp_reqs == 0)
+		return;
+
+	/*
+	 * Account for req/rsp payload
+	 */
+	*dm_len += BFA_FCXP_MAX_IBUF_SZ * num_fcxp_reqs;
+	if (cfg->drvcfg.min_cfg)
+		*dm_len += BFA_FCXP_MAX_IBUF_SZ * num_fcxp_reqs;
+	else
+		*dm_len += BFA_FCXP_MAX_LBUF_SZ * num_fcxp_reqs;
+
+	/*
+	 * Account for fcxp structs
+	 */
+	*ndm_len += sizeof(struct bfa_fcxp_s) * num_fcxp_reqs;
+}
+
+static void
+bfa_fcxp_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		    struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_fcxp_mod_s *mod = BFA_FCXP_MOD(bfa);
+
+	bfa_os_memset(mod, 0, sizeof(struct bfa_fcxp_mod_s));
+	mod->bfa = bfa;
+	mod->num_fcxps = cfg->fwcfg.num_fcxp_reqs;
+
+	/**
+	 * Initialize FCXP request and response payload sizes.
+	 */
+	mod->req_pld_sz = mod->rsp_pld_sz = BFA_FCXP_MAX_IBUF_SZ;
+	if (!cfg->drvcfg.min_cfg)
+		mod->rsp_pld_sz = BFA_FCXP_MAX_LBUF_SZ;
+
+	INIT_LIST_HEAD(&mod->wait_q);
+
+	claim_fcxp_req_rsp_mem(mod, meminfo);
+	claim_fcxps_mem(mod, meminfo);
+}
+
+static void
+bfa_fcxp_initdone(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcxp_detach(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcxp_start(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcxp_stop(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_fcxp_iocdisable(struct bfa_s *bfa)
+{
+	struct bfa_fcxp_mod_s *mod = BFA_FCXP_MOD(bfa);
+	struct bfa_fcxp_s *fcxp;
+	struct list_head        *qe, *qen;
+
+	list_for_each_safe(qe, qen, &mod->fcxp_active_q) {
+		fcxp = (struct bfa_fcxp_s *) qe;
+		if (fcxp->caller == NULL)
+			fcxp->send_cbfn(fcxp->caller, fcxp, fcxp->send_cbarg,
+					BFA_STATUS_IOC_FAILURE, 0, 0, NULL);
+		else {
+			fcxp->rsp_status = BFA_STATUS_IOC_FAILURE;
+			bfa_cb_queue(bfa, &fcxp->hcb_qe,
+				      __bfa_fcxp_send_cbfn, fcxp);
+		}
+	}
+}
+
+static struct bfa_fcxp_s *
+bfa_fcxp_get(struct bfa_fcxp_mod_s *fm)
+{
+	struct bfa_fcxp_s *fcxp;
+
+	bfa_q_deq(&fm->fcxp_free_q, &fcxp);
+
+	if (fcxp)
+		list_add_tail(&fcxp->qe, &fm->fcxp_active_q);
+
+	return (fcxp);
+}
+
+static void
+bfa_fcxp_put(struct bfa_fcxp_s *fcxp)
+{
+	struct bfa_fcxp_mod_s *mod = fcxp->fcxp_mod;
+	struct bfa_fcxp_wqe_s *wqe;
+
+	bfa_q_deq(&mod->wait_q, &wqe);
+	if (wqe) {
+		bfa_trc(mod->bfa, fcxp->fcxp_tag);
+		wqe->alloc_cbfn(wqe->alloc_cbarg, fcxp);
+		return;
+	}
+
+	bfa_assert(bfa_q_is_on_q(&mod->fcxp_active_q, fcxp));
+	list_del(&fcxp->qe);
+	list_add_tail(&fcxp->qe, &mod->fcxp_free_q);
+}
+
+static void
+bfa_fcxp_null_comp(void *bfad_fcxp, struct bfa_fcxp_s *fcxp, void *cbarg,
+		       bfa_status_t req_status, u32 rsp_len,
+		       u32 resid_len, fchs_t *rsp_fchs)
+{
+	/**discarded fcxp completion */
+}
+
+static void
+__bfa_fcxp_send_cbfn(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_fcxp_s *fcxp = cbarg;
+
+	if (complete) {
+		fcxp->send_cbfn(fcxp->caller, fcxp, fcxp->send_cbarg,
+				fcxp->rsp_status, fcxp->rsp_len,
+				fcxp->residue_len, &fcxp->rsp_fchs);
+	} else {
+		bfa_fcxp_free(fcxp);
+	}
+}
+
+static void
+hal_fcxp_send_comp(struct bfa_s *bfa, struct bfi_fcxp_send_rsp_s *fcxp_rsp)
+{
+	struct bfa_fcxp_mod_s	*mod = BFA_FCXP_MOD(bfa);
+	struct bfa_fcxp_s 	*fcxp;
+	u16		fcxp_tag = bfa_os_ntohs(fcxp_rsp->fcxp_tag);
+
+	bfa_trc(bfa, fcxp_tag);
+
+	fcxp_rsp->rsp_len = bfa_os_ntohl(fcxp_rsp->rsp_len);
+
+	/**
+	 * @todo f/w should not set residue to non-0 when everything
+	 *       is received.
+	 */
+	if (fcxp_rsp->req_status == BFA_STATUS_OK)
+		fcxp_rsp->residue_len = 0;
+	else
+		fcxp_rsp->residue_len = bfa_os_ntohl(fcxp_rsp->residue_len);
+
+	fcxp = BFA_FCXP_FROM_TAG(mod, fcxp_tag);
+
+	bfa_assert(fcxp->send_cbfn != NULL);
+
+	hal_fcxp_rx_plog(mod->bfa, fcxp, fcxp_rsp);
+
+	if (fcxp->send_cbfn != NULL) {
+		if (fcxp->caller == NULL) {
+			bfa_trc(mod->bfa, fcxp->fcxp_tag);
+
+			fcxp->send_cbfn(fcxp->caller, fcxp, fcxp->send_cbarg,
+					fcxp_rsp->req_status, fcxp_rsp->rsp_len,
+					fcxp_rsp->residue_len, &fcxp_rsp->fchs);
+			/*
+			 * fcxp automatically freed on return from the callback
+			 */
+			bfa_fcxp_free(fcxp);
+		} else {
+			bfa_trc(mod->bfa, fcxp->fcxp_tag);
+			fcxp->rsp_status = fcxp_rsp->req_status;
+			fcxp->rsp_len = fcxp_rsp->rsp_len;
+			fcxp->residue_len = fcxp_rsp->residue_len;
+			fcxp->rsp_fchs = fcxp_rsp->fchs;
+
+			bfa_cb_queue(bfa, &fcxp->hcb_qe,
+				      __bfa_fcxp_send_cbfn, fcxp);
+		}
+	} else {
+		bfa_trc(bfa, fcxp_tag);
+	}
+}
+
+static void
+hal_fcxp_set_local_sges(struct bfi_sge_s *sge, u32 reqlen, u64 req_pa)
+{
+	union bfi_addr_u      sga_zero = { {0} };
+
+	sge->sg_len = reqlen;
+	sge->flags = BFI_SGE_DATA_LAST;
+	bfa_dma_addr_set(sge[0].sga, req_pa);
+	bfa_sge_to_be(sge);
+	sge++;
+
+	sge->sga = sga_zero;
+	sge->sg_len = reqlen;
+	sge->flags = BFI_SGE_PGDLEN;
+	bfa_sge_to_be(sge);
+}
+
+static void
+hal_fcxp_tx_plog(struct bfa_s *bfa, u32 reqlen, struct bfa_fcxp_s *fcxp,
+		 fchs_t *fchs)
+{
+	/*
+	 * TODO: TX ox_id
+	 */
+	if (reqlen > 0) {
+		if (fcxp->use_ireqbuf) {
+			u32        pld_w0 =
+				*((u32 *) BFA_FCXP_REQ_PLD(fcxp));
+
+			bfa_plog_fchdr_and_pl(bfa->plog, BFA_PL_MID_HAL_FCXP,
+					      BFA_PL_EID_TX,
+					      reqlen + sizeof(fchs_t), fchs,
+					      pld_w0);
+		} else {
+			bfa_plog_fchdr(bfa->plog, BFA_PL_MID_HAL_FCXP,
+				       BFA_PL_EID_TX, reqlen + sizeof(fchs_t),
+				       fchs);
+		}
+	} else {
+		bfa_plog_fchdr(bfa->plog, BFA_PL_MID_HAL_FCXP, BFA_PL_EID_TX,
+			       reqlen + sizeof(fchs_t), fchs);
+	}
+}
+
+static void
+hal_fcxp_rx_plog(struct bfa_s *bfa, struct bfa_fcxp_s *fcxp,
+		 struct bfi_fcxp_send_rsp_s *fcxp_rsp)
+{
+	if (fcxp_rsp->rsp_len > 0) {
+		if (fcxp->use_irspbuf) {
+			u32        pld_w0 =
+				*((u32 *) BFA_FCXP_RSP_PLD(fcxp));
+
+			bfa_plog_fchdr_and_pl(bfa->plog, BFA_PL_MID_HAL_FCXP,
+					      BFA_PL_EID_RX,
+					      (u16) fcxp_rsp->rsp_len,
+					      &fcxp_rsp->fchs, pld_w0);
+		} else {
+			bfa_plog_fchdr(bfa->plog, BFA_PL_MID_HAL_FCXP,
+				       BFA_PL_EID_RX,
+				       (u16) fcxp_rsp->rsp_len,
+				       &fcxp_rsp->fchs);
+		}
+	} else {
+		bfa_plog_fchdr(bfa->plog, BFA_PL_MID_HAL_FCXP, BFA_PL_EID_RX,
+			       (u16) fcxp_rsp->rsp_len, &fcxp_rsp->fchs);
+	}
+}
+
+/**
+ *  hal_fcxp_api BFA FCXP API
+ */
+
+/**
+ * Allocate an FCXP instance to send a response or to send a request
+ * that has a response. Request/response buffers are allocated by caller.
+ *
+ * @param[in]	bfa		BFA bfa instance
+ * @param[in]	nreq_sgles	Number of SG elements required for request
+ * 				buffer. 0, if fcxp internal buffers are	used.
+ * 				Use bfa_fcxp_get_reqbuf() to get the
+ * 				internal req buffer.
+ * @param[in]	req_sgles	SG elements describing request buffer. Will be
+ * 				copied in by BFA and hence can be freed on
+ * 				return from this function.
+ * @param[in]	get_req_sga	function ptr to be called to get a request SG
+ * 				Address (given the sge index).
+ * @param[in]	get_req_sglen	function ptr to be called to get a request SG
+ * 				len (given the sge index).
+ * @param[in]	get_rsp_sga	function ptr to be called to get a response SG
+ * 				Address (given the sge index).
+ * @param[in]	get_rsp_sglen	function ptr to be called to get a response SG
+ * 				len (given the sge index).
+ *
+ * @return FCXP instance. NULL on failure.
+ */
+struct bfa_fcxp_s *
+bfa_fcxp_alloc(void *caller, struct bfa_s *bfa, int nreq_sgles,
+			int nrsp_sgles, bfa_fcxp_get_sgaddr_t req_sga_cbfn,
+			bfa_fcxp_get_sglen_t req_sglen_cbfn,
+			bfa_fcxp_get_sgaddr_t rsp_sga_cbfn,
+			bfa_fcxp_get_sglen_t rsp_sglen_cbfn)
+{
+	struct bfa_fcxp_s *fcxp = NULL;
+	u32        nreq_sgpg, nrsp_sgpg;
+
+	bfa_assert(bfa != NULL);
+
+	fcxp = bfa_fcxp_get(BFA_FCXP_MOD(bfa));
+	if (fcxp == NULL)
+		return (NULL);
+
+	bfa_trc(bfa, fcxp->fcxp_tag);
+
+	fcxp->caller = caller;
+
+	if (nreq_sgles == 0) {
+		fcxp->use_ireqbuf = 1;
+	} else {
+		bfa_assert(req_sga_cbfn != NULL);
+		bfa_assert(req_sglen_cbfn != NULL);
+
+		fcxp->use_ireqbuf = 0;
+		fcxp->req_sga_cbfn = req_sga_cbfn;
+		fcxp->req_sglen_cbfn = req_sglen_cbfn;
+
+		fcxp->nreq_sgles = nreq_sgles;
+
+		/*
+		 * alloc required sgpgs
+		 */
+		if (nreq_sgles > BFI_SGE_INLINE) {
+			nreq_sgpg = BFA_SGPG_NPAGE(nreq_sgles);
+
+			if (bfa_sgpg_malloc
+			    (bfa, &fcxp->req_sgpg_q, nreq_sgpg)
+			    != BFA_STATUS_OK) {
+				/* bfa_sgpg_wait(bfa, &fcxp->req_sgpg_wqe,
+				nreq_sgpg); */
+				/*
+				 * TODO
+				 */
+			}
+		}
+	}
+
+	if (nrsp_sgles == 0) {
+		fcxp->use_irspbuf = 1;
+	} else {
+		bfa_assert(rsp_sga_cbfn != NULL);
+		bfa_assert(rsp_sglen_cbfn != NULL);
+
+		fcxp->use_irspbuf = 0;
+		fcxp->rsp_sga_cbfn = rsp_sga_cbfn;
+		fcxp->rsp_sglen_cbfn = rsp_sglen_cbfn;
+
+		fcxp->nrsp_sgles = nrsp_sgles;
+		/*
+		 * alloc required sgpgs
+		 */
+		if (nrsp_sgles > BFI_SGE_INLINE) {
+			nrsp_sgpg = BFA_SGPG_NPAGE(nreq_sgles);
+
+			if (bfa_sgpg_malloc
+			    (bfa, &fcxp->rsp_sgpg_q, nrsp_sgpg)
+			    != BFA_STATUS_OK) {
+				/* bfa_sgpg_wait(bfa, &fcxp->rsp_sgpg_wqe,
+				nrsp_sgpg); */
+				/*
+				 * TODO
+				 */
+			}
+		}
+	}
+
+	return (fcxp);
+}
+
+/**
+ * Get the internal request buffer pointer
+ *
+ * @param[in]	fcxp	BFA fcxp pointer
+ *
+ * @return 		pointer to the internal request buffer
+ */
+void *
+bfa_fcxp_get_reqbuf(struct bfa_fcxp_s *fcxp)
+{
+	struct bfa_fcxp_mod_s *mod = fcxp->fcxp_mod;
+	void	*reqbuf;
+
+	bfa_assert(fcxp->use_ireqbuf == 1);
+	reqbuf = ((u8 *)mod->req_pld_list_kva) +
+			fcxp->fcxp_tag * mod->req_pld_sz;
+	return reqbuf;
+}
+
+u32
+bfa_fcxp_get_reqbufsz(struct bfa_fcxp_s *fcxp)
+{
+	struct bfa_fcxp_mod_s *mod = fcxp->fcxp_mod;
+
+	return mod->req_pld_sz;
+}
+
+/**
+ * Get the internal response buffer pointer
+ *
+ * @param[in]	fcxp	BFA fcxp pointer
+ *
+ * @return		pointer to the internal request buffer
+ */
+void *
+bfa_fcxp_get_rspbuf(struct bfa_fcxp_s *fcxp)
+{
+	struct bfa_fcxp_mod_s *mod = fcxp->fcxp_mod;
+	void	*rspbuf;
+
+	bfa_assert(fcxp->use_irspbuf == 1);
+
+	rspbuf = ((u8 *)mod->rsp_pld_list_kva) +
+			fcxp->fcxp_tag * mod->rsp_pld_sz;
+	return rspbuf;
+}
+
+/**
+ * 		Free the BFA FCXP
+ *
+ * @param[in]	fcxp			BFA fcxp pointer
+ *
+ * @return 		void
+ */
+void
+bfa_fcxp_free(struct bfa_fcxp_s *fcxp)
+{
+	struct bfa_fcxp_mod_s *mod = fcxp->fcxp_mod;
+
+	bfa_assert(fcxp != NULL);
+	bfa_trc(mod->bfa, fcxp->fcxp_tag);
+	bfa_fcxp_put(fcxp);
+}
+
+/**
+ * Send a FCXP request
+ *
+ * @param[in]	fcxp	BFA fcxp pointer
+ * @param[in]	rport	BFA rport pointer. Could be left NULL for WKA rports
+ * @param[in]	vf_id	virtual Fabric ID
+ * @param[in]	cts	use Continous sequence
+ * @param[in]	cos	fc Class of Service
+ * @param[in]	reqlen	request length, does not include FCHS length
+ * @param[in]	fchs	fc Header Pointer. The header content will be copied
+ *			in by BFA.
+ *
+ * @param[in]	cbfn	call back function to be called on receiving
+ * 								the response
+ * @param[in]	cbarg	arg for cbfn
+ * @param[in]	rsp_timeout
+ *			response timeout
+ *
+ * @return		bfa_status_t
+ */
+void
+bfa_fcxp_send(struct bfa_fcxp_s *fcxp, struct bfa_rport_s *rport,
+		u16 vf_id, bfa_boolean_t cts, fc_cos_t cos,
+		u32 reqlen, fchs_t *fchs, bfa_cb_fcxp_send_t cbfn,
+		void *cbarg, u32 rsp_maxlen, u8 rsp_timeout)
+{
+	struct bfi_fcxp_send_req_s *send_req;
+	struct bfa_s      *bfa = fcxp->fcxp_mod->bfa;
+
+	send_req = bfa_reqq_next(bfa, BFA_REQQ_FCXP);
+
+	bfi_h2i_set(send_req->mh, BFI_MC_FCXP, BFI_FCXP_H2I_SEND_REQ,
+			bfa_lpuid(bfa));
+
+	bfa_trc(bfa, fcxp->fcxp_tag);
+
+	send_req->fcxp_tag = bfa_os_htons(fcxp->fcxp_tag);
+
+	if (rport != NULL) {
+		if (rport->rport_info.maxfrsize == 0) {
+			bfa_assert(0);
+			send_req->max_frmsz = bfa_os_htons(FC_MAX_PDUSZ);
+		} else
+			send_req->max_frmsz =
+				bfa_os_htons(rport->rport_info.maxfrsize);
+		send_req->rport_fw_hndl = rport->rport_tag;
+	} else {
+		send_req->max_frmsz = bfa_os_htons(FC_MAX_PDUSZ);
+		send_req->rport_fw_hndl = 0;
+	}
+
+	send_req->vf_id = bfa_os_htons(vf_id);
+	send_req->class = cos;
+	send_req->rsp_timeout = rsp_timeout;
+	send_req->cts = cts;
+
+	bfa_os_memcpy((void *)&send_req->fchs, (void *)fchs, sizeof(fchs_t));
+
+	send_req->req_len = bfa_os_htonl(reqlen);
+	send_req->rsp_maxlen = bfa_os_htonl(rsp_maxlen);
+
+	/*
+	 * setup req sgles
+	 */
+	if (fcxp->use_ireqbuf == 1) {
+		hal_fcxp_set_local_sges(send_req->req_sge, reqlen,
+					BFA_FCXP_REQ_PLD_PA(fcxp));
+	} else {
+		if (fcxp->nreq_sgles > 0) {
+			bfa_assert(fcxp->nreq_sgles == 1);
+			hal_fcxp_set_local_sges(send_req->req_sge, reqlen,
+						fcxp->req_sga_cbfn(fcxp->caller,
+								   0));
+		} else {
+			bfa_assert(reqlen == 0);
+			hal_fcxp_set_local_sges(send_req->rsp_sge, 0, 0);
+		}
+	}
+
+	/*
+	 * setup rsp sgles
+	 */
+	if (fcxp->use_irspbuf == 1) {
+		bfa_assert(rsp_maxlen <= BFA_FCXP_MAX_LBUF_SZ);
+
+		hal_fcxp_set_local_sges(send_req->rsp_sge, rsp_maxlen,
+					BFA_FCXP_RSP_PLD_PA(fcxp));
+
+	} else {
+		if (fcxp->nrsp_sgles > 0) {
+			bfa_assert(fcxp->nrsp_sgles == 1);
+			hal_fcxp_set_local_sges(send_req->rsp_sge, rsp_maxlen,
+						fcxp->rsp_sga_cbfn(fcxp->caller,
+								   0));
+		} else {
+			bfa_assert(rsp_maxlen == 0);
+			hal_fcxp_set_local_sges(send_req->rsp_sge, 0, 0);
+		}
+	}
+
+	hal_fcxp_tx_plog(bfa, reqlen, fcxp, fchs);
+
+	fcxp->send_cbfn = cbfn ? cbfn : bfa_fcxp_null_comp;
+	fcxp->send_cbarg = cbarg;
+
+	bfa_reqq_produce(bfa, BFA_REQQ_FCXP);
+
+	bfa_trc(bfa, bfa_reqq_pi(bfa, BFA_REQQ_FCXP));
+	bfa_trc(bfa, bfa_reqq_ci(bfa, BFA_REQQ_FCXP));
+}
+
+/**
+ * Abort a BFA FCXP
+ *
+ * @param[in]	fcxp	BFA fcxp pointer
+ *
+ * @return 		void
+ */
+bfa_status_t
+bfa_fcxp_abort(struct bfa_fcxp_s *fcxp)
+{
+	bfa_assert(0);
+	return (BFA_STATUS_OK);
+}
+
+void
+bfa_fcxp_alloc_wait(struct bfa_s *bfa, struct bfa_fcxp_wqe_s *wqe,
+			bfa_fcxp_alloc_cbfn_t alloc_cbfn, void *alloc_cbarg)
+{
+	struct bfa_fcxp_mod_s *mod = BFA_FCXP_MOD(bfa);
+
+	bfa_assert(list_empty(&mod->fcxp_free_q));
+
+	wqe->alloc_cbfn = alloc_cbfn;
+	wqe->alloc_cbarg = alloc_cbarg;
+	list_add_tail(&wqe->qe, &mod->wait_q);
+}
+
+void
+bfa_fcxp_walloc_cancel(struct bfa_s *bfa, struct bfa_fcxp_wqe_s *wqe)
+{
+	struct bfa_fcxp_mod_s *mod = BFA_FCXP_MOD(bfa);
+
+	bfa_assert(bfa_q_is_on_q(&mod->wait_q, wqe));
+	list_del(&wqe->qe);
+}
+
+void
+bfa_fcxp_discard(struct bfa_fcxp_s *fcxp)
+{
+	fcxp->send_cbfn = bfa_fcxp_null_comp;
+}
+
+
+
+/**
+ *  hal_fcxp_public BFA FCXP public functions
+ */
+
+void
+bfa_fcxp_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
+{
+	switch (msg->mhdr.msg_id) {
+	case BFI_FCXP_I2H_SEND_RSP:
+		hal_fcxp_send_comp(bfa, (struct bfi_fcxp_send_rsp_s *) msg);
+		break;
+
+	default:
+		bfa_trc(bfa, msg->mhdr.msg_id);
+		bfa_assert(0);
+	}
+}
+
+u32
+bfa_fcxp_get_maxrsp(struct bfa_s *bfa)
+{
+	struct bfa_fcxp_mod_s *mod = BFA_FCXP_MOD(bfa);
+
+	return mod->rsp_pld_sz;
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_fcxp_priv.h patch/drivers/scsi/bfa/bfa_fcxp_priv.h
--- orig/drivers/scsi/bfa/bfa_fcxp_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fcxp_priv.h	2009-03-14 11:44:57.050070000 -0700
@@ -0,0 +1,135 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_FCXP_PRIV_H__
+#define __BFA_FCXP_PRIV_H__
+
+#include <cs/bfa_sm.h>
+#include <protocol/fc.h>
+#include <bfa_svc.h>
+#include <bfi/bfi_fcxp.h>
+
+#define BFA_FCXP_MIN     	(1)
+#define BFA_FCXP_MAX_IBUF_SZ	(2 * 1024 + 256)
+#define BFA_FCXP_MAX_LBUF_SZ	(4 * 1024 + 256)
+
+struct bfa_fcxp_mod_s {
+	struct bfa_s      *bfa;		/*  backpointer to BFA */
+	struct bfa_fcxp_s	*fcxp_list;	/*  array of FCXPs */
+	u16        num_fcxps;	/*  max num FCXP requests */
+	struct list_head         fcxp_free_q;	/*  free FCXPs */
+	struct list_head         fcxp_active_q;	/*  active FCXPs */
+	void		*req_pld_list_kva; /*  list of FCXP req pld */
+	u64        req_pld_list_pa;	/*  list of FCXP req pld */
+	void		*rsp_pld_list_kva; /*  list of FCXP resp pld */
+	u64        rsp_pld_list_pa;	/*  list of FCXP resp pld */
+	struct list_head         wait_q;		/*  wait queue for free fcxp */
+	u32	req_pld_sz;
+	u32	rsp_pld_sz;
+};
+
+#define BFA_FCXP_MOD(__bfa)		(&(__bfa)->modules.fcxp_mod)
+#define BFA_FCXP_FROM_TAG(__mod, __tag)	(&(__mod)->fcxp_list[__tag])
+
+typedef void    (*fcxp_send_cb_t) (struct bfa_s *ioc, struct bfa_fcxp_s *fcxp,
+				   void *cb_arg, bfa_status_t req_status,
+				   u32 rsp_len, u32 resid_len,
+				   fchs_t *rsp_fchs);
+
+/**
+ * Information needed for a FCXP request
+ */
+struct bfa_fcxp_req_info_s {
+	struct bfa_rport_s *bfa_rport;	/*  Pointer to the bfa rport that was
+					 *returned from bfa_rport_create().
+					 *This could be left NULL for WKA or for
+					 *FCXP interactions before the rport
+					 *nexus is established
+					 */
+	u8         cts;	/*  continous sequence */
+	u8         class;	/*  FC class for the request/response */
+	u16        max_frmsz;	/*  max send frame size */
+	u16        vf_id;	/*  vsan tag if applicable */
+	fchs_t          fchs;	/*  request FC header structure */
+	u32        req_tot_len;	/*  request payload total length */
+};
+
+struct bfa_fcxp_rsp_info_s {
+	fchs_t          rsp_fchs;	/*  Response frame's FC header will
+					 *be *sent back in this field */
+	u8         rsp_timeout;	/*  timeout in seconds, 0-no response
+					 */
+	u8         rsvd2[3];
+	u32        rsp_maxlen;	/*  max response length expected */
+};
+
+struct bfa_fcxp_s {
+	struct list_head 	qe;		/*  fcxp queue element */
+	bfa_sm_t        sm;             /*  state machine */
+	void           	*caller;	/*  driver or fcs */
+	struct bfa_fcxp_mod_s *fcxp_mod;
+					/*  back pointer to fcxp mod */
+	u16        fcxp_tag;	/*  internal tag */
+	struct bfa_fcxp_req_info_s req_info;
+					/*  request info */
+	struct bfa_fcxp_rsp_info_s rsp_info;
+					/*  response info */
+	u8 	use_ireqbuf;	/*  use internal req buf */
+	u8         use_irspbuf;	/*  use internal rsp buf */
+	u32        nreq_sgles;	/*  num request SGLEs */
+	u32        nrsp_sgles;	/*  num response SGLEs */
+	struct list_head req_sgpg_q;	/*  SG pages for request buf */
+	struct list_head req_sgpg_wqe;	/*  wait queue for req SG page */
+	struct list_head rsp_sgpg_q;	/*  SG pages for response buf */
+	struct list_head rsp_sgpg_wqe;	/*  wait queue for rsp SG page */
+
+	bfa_fcxp_get_sgaddr_t req_sga_cbfn;
+					/*  SG elem addr user function */
+	bfa_fcxp_get_sglen_t req_sglen_cbfn;
+					/*  SG elem len user function */
+	bfa_fcxp_get_sgaddr_t rsp_sga_cbfn;
+					/*  SG elem addr user function */
+	bfa_fcxp_get_sglen_t rsp_sglen_cbfn;
+					/*  SG elem len user function */
+	bfa_cb_fcxp_send_t send_cbfn;   /*  send completion callback */
+	void		*send_cbarg;	/*  callback arg */
+	struct bfa_sge_s   req_sge[BFA_FCXP_MAX_SGES];
+					/*  req SG elems */
+	struct bfa_sge_s   rsp_sge[BFA_FCXP_MAX_SGES];
+					/*  rsp SG elems */
+	u8         rsp_status;	/*  comp: rsp status */
+	u32        rsp_len;	/*  comp: actual response len */
+	u32        residue_len;	/*  comp: residual rsp length */
+	fchs_t          rsp_fchs;	/*  comp: response fchs */
+	struct bfa_cb_qe_s    hcb_qe;	/*  comp: callback qelem */
+};
+
+#define BFA_FCXP_REQ_PLD(_fcxp) 	(bfa_fcxp_get_reqbuf(_fcxp))
+
+#define BFA_FCXP_RSP_FCHS(_fcxp) 	(&((_fcxp)->rsp_info.fchs))
+#define BFA_FCXP_RSP_PLD(_fcxp) 	(bfa_fcxp_get_rspbuf(_fcxp))
+
+#define BFA_FCXP_REQ_PLD_PA(_fcxp)					\
+	((_fcxp)->fcxp_mod->req_pld_list_pa +				\
+		((_fcxp)->fcxp_mod->req_pld_sz  * (_fcxp)->fcxp_tag))
+
+#define BFA_FCXP_RSP_PLD_PA(_fcxp) 					\
+	((_fcxp)->fcxp_mod->rsp_pld_list_pa +				\
+		((_fcxp)->fcxp_mod->rsp_pld_sz * (_fcxp)->fcxp_tag))
+
+void	bfa_fcxp_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+#endif /* __BFA_FCXP_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_fwimg_priv.h patch/drivers/scsi/bfa/bfa_fwimg_priv.h
--- orig/drivers/scsi/bfa/bfa_fwimg_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_fwimg_priv.h	2009-03-14 11:44:57.062372000 -0700
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_FWIMG_PRIV_TOB_H__
+#define __BFA_FWIMG_PRIV_TOB_H__
+
+extern u32 *bfi_image;
+extern u32 bfi_image_size;
+extern u32 *bfad_fwimg_buf;
+extern char __bfa_ident[];
+
+#define BFI_FLASH_CHUNK_SZ                      256                     /*  Flash chunk size */
+#define BFI_FLASH_CHUNK_SZ_WORDS        (BFI_FLASH_CHUNK_SZ/sizeof(u32))
+
+extern u32 *bfi_image_get_chunk(u32 off);
+
+#endif /* __BFA_FWIMG_PRIV_TOB_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_hw_cb.c patch/drivers/scsi/bfa/bfa_hw_cb.c
--- orig/drivers/scsi/bfa/bfa_hw_cb.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_hw_cb.c	2009-03-14 11:44:57.072596000 -0700
@@ -0,0 +1,60 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa_priv.h>
+#include <bfi/bfi_cbreg.h>
+
+void
+bfa_hwcb_reginit(struct bfa_s *bfa)
+{
+	struct bfa_iocfc_regs_s	*bfa_regs = &bfa->iocfc.bfa_regs;
+	bfa_os_addr_t		kva = bfa_ioc_bar0(&bfa->ioc);
+	int             	i, q, fn = bfa_ioc_pcifn(&bfa->ioc);
+
+	if (fn == 0) {
+		bfa_regs->intr_status = (kva + HOSTFN0_INT_STATUS);
+		bfa_regs->intr_mask   = (kva + HOSTFN0_INT_MSK);
+	} else {
+		bfa_regs->intr_status = (kva + HOSTFN1_INT_STATUS);
+		bfa_regs->intr_mask   = (kva + HOSTFN1_INT_MSK);
+	}
+
+	for (i = 0; i < BFI_IOC_MAX_CQS; i++) {
+		/*
+		 * CPE registers
+		 */
+		q = CPE_Q_NUM(fn, i);
+		bfa_regs->cpe_q_pi[i] = (kva + CPE_Q_PI(q));
+		bfa_regs->cpe_q_ci[i] = (kva + CPE_Q_CI(q));
+		bfa_regs->cpe_q_depth[i] = (kva + CPE_Q_DEPTH(q));
+
+		/*
+		 * RME registers
+		 */
+		q = CPE_Q_NUM(fn, i);
+		bfa_regs->rme_q_pi[i] = (kva + RME_Q_PI(q));
+		bfa_regs->rme_q_ci[i] = (kva + RME_Q_CI(q));
+		bfa_regs->rme_q_depth[i] = (kva + RME_Q_DEPTH(q));
+	}
+}
+
+void
+bfa_hwcb_rspq_ack(struct bfa_s *bfa, int rspq)
+{
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_hw_ct.c patch/drivers/scsi/bfa/bfa_hw_ct.c
--- orig/drivers/scsi/bfa/bfa_hw_ct.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_hw_ct.c	2009-03-14 11:44:57.084196000 -0700
@@ -0,0 +1,66 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa_priv.h>
+#include <bfi/bfi_ctreg.h>
+
+void
+bfa_hwct_reginit(struct bfa_s *bfa)
+{
+	struct bfa_iocfc_regs_s	*bfa_regs = &bfa->iocfc.bfa_regs;
+	bfa_os_addr_t		kva = bfa_ioc_bar0(&bfa->ioc);
+	int             	i, q, fn = bfa_ioc_pcifn(&bfa->ioc);
+
+	if (fn == 0) {
+		bfa_regs->intr_status = (kva + HOSTFN0_INT_STATUS);
+		bfa_regs->intr_mask   = (kva + HOSTFN0_INT_MSK);
+	} else {
+		bfa_regs->intr_status = (kva + HOSTFN1_INT_STATUS);
+		bfa_regs->intr_mask   = (kva + HOSTFN1_INT_MSK);
+	}
+
+	for (i = 0; i < BFI_IOC_MAX_CQS; i++) {
+		/*
+		 * CPE registers
+		 */
+		q = CPE_Q_NUM(fn, i);
+		bfa_regs->cpe_q_pi[i] = (kva + CPE_PI_PTR_Q(q << 5));
+		bfa_regs->cpe_q_ci[i] = (kva + CPE_CI_PTR_Q(q << 5));
+		bfa_regs->cpe_q_depth[i] = (kva + CPE_DEPTH_Q(q << 5));
+		bfa_regs->cpe_q_ctrl[i] = (kva + CPE_QCTRL_Q(q << 5));
+
+		/*
+		 * RME registers
+		 */
+		q = CPE_Q_NUM(fn, i);
+		bfa_regs->rme_q_pi[i] = (kva + RME_PI_PTR_Q(q << 5));
+		bfa_regs->rme_q_ci[i] = (kva + RME_CI_PTR_Q(q << 5));
+		bfa_regs->rme_q_depth[i] = (kva + RME_DEPTH_Q(q << 5));
+		bfa_regs->rme_q_ctrl[i] = (kva + RME_QCTRL_Q(q << 5));
+	}
+}
+
+void
+bfa_hwct_rspq_ack(struct bfa_s *bfa, int rspq)
+{
+	u32	r32;
+
+	r32 = bfa_reg_read(bfa->iocfc.bfa_regs.rme_q_ctrl[rspq]);
+	bfa_reg_write(bfa->iocfc.bfa_regs.rme_q_ctrl[rspq], r32);
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_intr.c patch/drivers/scsi/bfa/bfa_intr.c
--- orig/drivers/scsi/bfa/bfa_intr.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_intr.c	2009-03-14 11:44:57.096223000 -0700
@@ -0,0 +1,283 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <bfa.h>
+#include <bfi/bfi_cbreg.h>
+#include <bfa_port_priv.h>
+#include <bfa_intr_priv.h>
+#include <cs/bfa_debug.h>
+
+BFA_TRC_FILE(HAL, INTR);
+
+/**
+ * Resume request queue once it was full and now non-full
+ */
+static void
+bfa_reqq_resume(struct bfa_s *bfa, int qid)
+{
+	struct list_head 		*waitq, *qe, *qen;
+	struct bfa_reqq_wait_s	*wqe;
+
+	waitq = bfa_reqq(bfa, qid);
+	list_for_each_safe(qe, qen, waitq) {
+		/**
+		 * Callback only as long as there is room in request queue
+		 */
+		if (bfa_reqq_full(bfa, qid))
+			break;
+
+		list_del(qe);
+		wqe = (struct bfa_reqq_wait_s *) qe;
+		wqe->qresume(wqe->cbarg);
+	}
+}
+
+/**
+ *  hal_intr_api
+ */
+enum bfa_isr_status
+bfa_intx(struct bfa_s *bfa)
+{
+	u32        intr;
+	int             vec;
+
+	/* FCS_BRINGUP*/
+	printk(" function: %s, Line %d \n",__FUNCTION__, __LINE__);
+	intr = bfa_reg_read(bfa->iocfc.bfa_regs.intr_status);
+	if (!intr)
+		return BFA_ISR_NOTCLAIMED;
+
+	/* FCS_BRINGUP*/
+	printk(" bfa_reg_read function: %s, Line %d status %d \n",__FUNCTION__, __LINE__, intr);
+	/**
+	 * mailbox interrupt
+	 */
+	if (bfa_ioc_pcifn(&bfa->ioc) == 0) {
+		if (intr & __HFN_INT_MBOX_LPU0)
+		{
+			printk(" bfa_reg_read function: %s, Line %d status %d \n",__FUNCTION__, __LINE__, intr & __HFN_INT_MBOX_LPU0);
+			bfa_msix_lpu(bfa);
+		}
+	} else {
+		if (intr & __HFN_INT_MBOX_LPU1)
+		{
+			printk(" bfa_reg_read function: %s, Line %d status %d \n",__FUNCTION__, __LINE__, intr & __HFN_INT_MBOX_LPU1);
+			bfa_msix_lpu(bfa);
+		}
+	}
+	/* FCS_BRINGUP*/
+	printk(" function: %s, Line %d \n",__FUNCTION__, __LINE__);
+	/**
+	 * RME completion queue interrupt
+	 */
+	for (vec = HFN_MSIX_RME_Q0; vec <= HFN_MSIX_RME_Q7; vec++)
+		if (intr & (__HFN_INT_RME_Q0 << (vec - HFN_MSIX_RME_Q0)))
+			bfa_msix_rspq(bfa, vec);
+
+	/**
+	 * CPE completion queue interrupt
+	 */
+	for (vec = HFN_MSIX_CPE_Q0; vec <= HFN_MSIX_CPE_Q7; vec++)
+		if (intr & (__HFN_INT_CPE_Q0 << (vec - HFN_MSIX_CPE_Q0)))
+			bfa_msix_reqq(bfa, vec);
+
+	if (intr & (__HFN_INT_ERR_EMC | __HFN_INT_ERR_LPU0 |
+				__HFN_INT_ERR_LPU1 | __HFN_INT_ERR_PSS))
+		bfa_msix_errint(bfa);
+
+	/* FCS_BRINGUP*/
+	printk(" returning function: %s, Line %d \n",__FUNCTION__, __LINE__);
+	return (BFA_ISR_CLAIMED_COMP);
+}
+
+void
+bfa_isr_enable(struct bfa_s *bfa)
+{
+	u32        intr_unmask;
+	int             pci_func = bfa_ioc_pcifn(&bfa->ioc);
+
+	bfa_trc(bfa, pci_func);
+
+	intr_unmask = (__HFN_INT_ERR_EMC | __HFN_INT_ERR_LPU0 |
+				__HFN_INT_ERR_LPU1 | __HFN_INT_ERR_PSS);
+
+	if (pci_func == 0)
+		intr_unmask |= (__HFN_INT_CPE_Q0 | __HFN_INT_CPE_Q1 |
+				__HFN_INT_CPE_Q2 | __HFN_INT_CPE_Q3 |
+				__HFN_INT_RME_Q0 | __HFN_INT_RME_Q1 |
+				__HFN_INT_RME_Q2 | __HFN_INT_RME_Q3 |
+				__HFN_INT_MBOX_LPU0);
+	else
+		intr_unmask |= (__HFN_INT_CPE_Q4 | __HFN_INT_CPE_Q5 |
+				__HFN_INT_CPE_Q6 | __HFN_INT_CPE_Q7 |
+				__HFN_INT_RME_Q4 | __HFN_INT_RME_Q5 |
+				__HFN_INT_RME_Q6 | __HFN_INT_RME_Q7 |
+				__HFN_INT_MBOX_LPU1);
+
+	bfa_reg_write(bfa->iocfc.bfa_regs.intr_mask, ~intr_unmask);
+}
+
+void
+bfa_isr_disable(struct bfa_s *bfa)
+{
+	bfa_reg_write(bfa->iocfc.bfa_regs.intr_mask, -1L);
+}
+
+void
+bfa_msix_getvecs(struct bfa_s *bfa, u32 *msix_vecs_bmap,
+		     u32 *num_vecs, u32 *max_vec_bit)
+{
+#define __HFN_NUMINTS	13
+	if (bfa_ioc_pcifn(&bfa->ioc) == 0) {
+		*msix_vecs_bmap = (__HFN_INT_CPE_Q0 | __HFN_INT_CPE_Q1 |
+					__HFN_INT_CPE_Q2 | __HFN_INT_CPE_Q3 |
+					__HFN_INT_RME_Q0 | __HFN_INT_RME_Q1 |
+					__HFN_INT_RME_Q2 | __HFN_INT_RME_Q3 |
+					__HFN_INT_MBOX_LPU0);
+		*max_vec_bit = __HFN_INT_MBOX_LPU0;
+	} else {
+		*msix_vecs_bmap = (__HFN_INT_CPE_Q4 | __HFN_INT_CPE_Q5 |
+					__HFN_INT_CPE_Q6 | __HFN_INT_CPE_Q7 |
+					__HFN_INT_RME_Q4 | __HFN_INT_RME_Q5 |
+					__HFN_INT_RME_Q6 | __HFN_INT_RME_Q7 |
+					__HFN_INT_MBOX_LPU1);
+		*max_vec_bit = __HFN_INT_MBOX_LPU1;
+	}
+
+	*msix_vecs_bmap |= (__HFN_INT_ERR_EMC | __HFN_INT_ERR_LPU0 |
+				__HFN_INT_ERR_LPU1 | __HFN_INT_ERR_PSS);
+	*num_vecs = __HFN_NUMINTS;
+}
+
+enum bfa_isr_status
+bfa_msix_reqq(struct bfa_s *bfa, int qid)
+{
+	/**
+	 * ack the interrupt first
+	 */
+	bfa_reg_write(bfa->iocfc.bfa_regs.intr_status, (1 << (qid)));
+
+	qid &= (BFI_IOC_MAX_CQS - 1);
+	bfa_reqq_resume(bfa, qid);
+	return (BFA_ISR_CLAIMED_COMP);
+}
+
+void
+bfa_isr_unhandled(struct bfa_s *bfa, struct bfi_msg_s *m)
+{
+	bfa_trc(bfa, m->mhdr.msg_class);
+	bfa_trc(bfa, m->mhdr.msg_id);
+	bfa_trc(bfa, m->mhdr.mtag.i2htok);
+	bfa_assert(0);
+	bfa_trc_stop(bfa->trcmod);
+}
+
+enum bfa_isr_status
+bfa_msix_rspq(struct bfa_s *bfa, int rsp_qid)
+{
+	struct bfi_msg_s      *m;
+	u32        pi, ci;
+
+	bfa_trc_fp(bfa, rsp_qid);
+
+	/**
+	 * ack the interrupt first
+	 */
+	bfa_reg_write(bfa->iocfc.bfa_regs.intr_status,
+					  (1 << (rsp_qid)));
+
+	rsp_qid &= (BFI_IOC_MAX_CQS - 1);
+
+	ci = bfa_rspq_ci(bfa, rsp_qid);
+	pi = bfa_rspq_pi(bfa, rsp_qid);
+
+	bfa_trc_fp(bfa, ci);
+	bfa_trc_fp(bfa, pi);
+
+	while (ci != pi) {
+		m = bfa_rspq_elem(bfa, rsp_qid, ci);
+		bfa_assert_fp(m->mhdr.msg_class < BFI_MC_MAX);
+	/* FCS_BRINGUP*/
+		printk(" function: %s, Line %d msg_class %d\n",__FUNCTION__, __LINE__, m->mhdr.msg_class);		
+		bfa_isrs[m->mhdr.msg_class] (bfa, m);
+
+		CQ_INCR(ci, bfa->iocfc.cfg.drvcfg.num_rspq_elems);
+	}
+
+	/**
+	 * update CI
+	 */
+	bfa_rspq_ci(bfa, rsp_qid) = ci;
+	bfa_reg_write(bfa->iocfc.bfa_regs.rme_q_ci[rsp_qid],
+				bfa->iocfc.rsp_cq_ci[rsp_qid]);
+	bfa->iocfc.hwif.hw_rspq_ack(bfa, rsp_qid);
+	bfa_os_mmiowb();
+
+	/**
+	 * Resume corresponding request queue.
+	 */
+	bfa_reqq_resume(bfa, rsp_qid);
+
+	/* FCS_BRINGUP*/
+	printk("returning function: %s, Line %d \n",__FUNCTION__, __LINE__);		
+	return (BFA_ISR_CLAIMED_COMP);
+}
+
+enum bfa_isr_status
+bfa_msix_lpu(struct bfa_s *bfa)
+{
+	bfa_ioc_mbox_isr(&bfa->ioc);
+
+	/**
+	 * ack the mailbox interrupt
+	 */
+	if (bfa_ioc_pcifn(&bfa->ioc) == 0)
+	{
+		/* FCS_BRINGUP*/
+		printk("port 0 returning function: %s, Line %d \n",__FUNCTION__, __LINE__);
+		bfa_reg_write(bfa->iocfc.bfa_regs.intr_status,
+						 __HFN_INT_MBOX_LPU0);
+	}
+	else
+		bfa_reg_write(bfa->iocfc.bfa_regs.intr_status,
+						__HFN_INT_MBOX_LPU1);
+
+	/* FCS_BRINGUP*/
+	printk("returning function: %s, Line %d \n",__FUNCTION__, __LINE__);		
+	return (BFA_ISR_CLAIMED_COMP);
+}
+
+enum bfa_isr_status
+bfa_msix_errint(struct bfa_s *bfa)
+{
+	u32        intr;
+
+	intr = bfa_reg_read(bfa->iocfc.bfa_regs.intr_status);
+	bfa_trc(bfa, intr);
+	bfa_reg_write(bfa->iocfc.bfa_regs.intr_status, intr);
+	bfa_isr_disable(bfa);
+	bfa_assert(0);
+
+	return (BFA_ISR_CLAIMED_COMP);
+}
+
+void
+bfa_isr_bind(enum bfi_mclass mc, bfa_isr_func_t isr_func)
+{
+	bfa_isrs[mc] = isr_func;
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_intr_priv.h patch/drivers/scsi/bfa/bfa_intr_priv.h
--- orig/drivers/scsi/bfa/bfa_intr_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_intr_priv.h	2009-03-14 11:44:57.107612000 -0700
@@ -0,0 +1,120 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_INTR_PRIV_H__
+#define __BFA_INTR_PRIV_H__
+
+/**
+ * Message handler
+ */
+typedef void (*bfa_isr_func_t) (struct bfa_s *bfa, struct bfi_msg_s *m);
+void bfa_isr_unhandled(struct bfa_s *bfa, struct bfi_msg_s *m);
+void bfa_isr_bind(enum bfi_mclass mc, bfa_isr_func_t isr_func);
+
+
+#define bfa_reqq_pi(__bfa, __reqq)	(__bfa)->iocfc.req_cq_pi[__reqq]
+#define bfa_reqq_ci(__bfa, __reqq)					\
+	*(u32 *)((__bfa)->iocfc.req_cq_shadow_ci[__reqq].kva)
+
+#define bfa_reqq_full(__bfa, __reqq)				\
+	(((bfa_reqq_pi(__bfa, __reqq) + 1) &			\
+	  ((__bfa)->iocfc.cfg.drvcfg.num_reqq_elems - 1)) ==	\
+	 bfa_reqq_ci(__bfa, __reqq))
+
+#define bfa_reqq_next(__bfa, __reqq)				\
+	((void *)((struct bfi_msg_s *)((__bfa)->iocfc.req_cq_ba[__reqq].kva) \
+			  + bfa_reqq_pi((__bfa), (__reqq))))
+
+#define bfa_reqq_ionext(__bfa, __reqq)				\
+	(bfa_reqq_full(__bfa, __reqq) ? NULL :			\
+	 ((void *)((struct bfi_msg_s *)((__bfa)->iocfc.req_cq_ba[__reqq].kva) \
+			  + bfa_reqq_pi((__bfa), (__reqq)))))
+
+#define bfa_reqq_produce(__bfa, __reqq)	do {				\
+	(__bfa)->iocfc.req_cq_pi[__reqq]++;				\
+	(__bfa)->iocfc.req_cq_pi[__reqq] &=				\
+		((__bfa)->iocfc.cfg.drvcfg.num_reqq_elems - 1 );      \
+	bfa_reg_write((__bfa)->iocfc.bfa_regs.cpe_q_pi[__reqq],		\
+				(__bfa)->iocfc.req_cq_pi[__reqq] );      \
+	bfa_os_mmiowb( );      \
+} while (0)
+
+#define bfa_rspq_pi(__bfa, __rspq)					\
+	*(u32 *)((__bfa)->iocfc.rsp_cq_shadow_pi[__rspq].kva)
+
+#define bfa_rspq_ci(__bfa, __rspq)	(__bfa)->iocfc.rsp_cq_ci[__rspq]
+#define bfa_rspq_elem(__bfa, __rspq, __ci)				\
+	&((struct bfi_msg_s *)((__bfa)->iocfc.rsp_cq_ba[__rspq].kva))[__ci]
+
+#define CQ_INCR(__index, __size)					\
+			(__index)++; (__index) &= ((__size) - 1)
+
+/**
+ * Queue element to wait for room in request queue. FIFO order is
+ * maintained when fullfilling requests.
+ */
+struct bfa_reqq_wait_s {
+	struct list_head 	qe;
+	void		(*qresume) (void *cbarg);
+	void		*cbarg;
+};
+
+/**
+ * Circular queue usage assignments
+ */
+enum {
+	BFA_REQQ_IOC	= 0,	/*  all low-priority IOC msgs	*/
+	BFA_REQQ_FCXP	= 0,	/*  all FCXP messages		*/
+	BFA_REQQ_LPS	= 0,	/*  all lport service msgs	*/
+	BFA_REQQ_PORT	= 0,	/*  all port messages		*/
+	BFA_REQQ_FLASH	= 0,	/*  for flash module		*/
+	BFA_REQQ_DIAG	= 0,	/*  for diag module		*/
+	BFA_REQQ_RPORT	= 0,	/*  all port messages		*/
+	BFA_REQQ_SBOOT	= 0,	/*  all san boot messages	*/
+	BFA_REQQ_VPORT	= 0,	/*  all san boot messages	*/
+	BFA_REQQ_QOS_LO	= 1,	/*  all low priority IO	*/
+	BFA_REQQ_QOS_MD	= 2,	/*  all medium priority IO	*/
+	BFA_REQQ_QOS_HI	= 3,	/*  all high priority IO	*/
+};
+
+static inline void
+bfa_reqq_winit(struct bfa_reqq_wait_s *wqe, void (*qresume) (void *cbarg),
+			void *cbarg)
+{
+	wqe->qresume = qresume;
+	wqe->cbarg = cbarg;
+}
+
+#define bfa_reqq(__bfa, __reqq)	&(__bfa)->reqq_waitq[__reqq]
+
+/**
+ * static inline void
+ * bfa_reqq_wait(struct bfa_s *bfa, int reqq, struct bfa_reqq_wait_s *wqe)
+ */
+#define bfa_reqq_wait(__bfa, __reqq, __wqe) do {			\
+									\
+		struct list_head *waitq = bfa_reqq(__bfa, __reqq );      \
+									\
+		bfa_assert(((__reqq) < BFI_IOC_MAX_CQS) );      \
+		bfa_assert((__wqe)->qresume && (__wqe)->cbarg );      \
+									\
+		list_add_tail(&(__wqe)->qe, waitq);      \
+} while (0)
+
+#define bfa_reqq_wcancel(__wqe)	list_del(&(__wqe)->qe)
+
+#endif /* __BFA_INTR_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_ioc.c patch/drivers/scsi/bfa/bfa_ioc.c
--- orig/drivers/scsi/bfa/bfa_ioc.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_ioc.c	2009-03-14 11:44:57.127116000 -0700
@@ -0,0 +1,1844 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <bfa_ioc.h>
+#include <bfa_fwimg_priv.h>
+#include <bfa_trcmod_priv.h>
+#include <cs/bfa_debug.h>
+#include <bfi/bfi_ioc.h>
+#include <bfi/bfi_ctreg.h>
+#include <aen/bfa_aen_ioc.h>
+#include <aen/bfa_aen.h>
+#include <log/bfa_log_hal.h>
+#include <defs/bfa_defs_pci.h>
+
+BFA_TRC_FILE(HAL, IOC);
+
+/**
+ * IOC local definitions
+ */
+#define BFA_IOC_TOV		10000	/* msecs */
+#define BFA_IOC_HB_TOV		2000	/* msecs */
+#define BFA_IOC_HB_FAIL_MAX	10
+#define BFA_IOC_HWINIT_MAX	2
+#define BFA_IOC_FWIMG_MINSZ     (16 * 1024)
+
+#define bfa_ioc_timer_start(__ioc)					\
+	bfa_timer_begin((__ioc)->timer_mod, &(__ioc)->ioc_timer,	\
+			bfa_ioc_timeout, (__ioc), BFA_IOC_TOV)
+#define bfa_ioc_timer_stop(__ioc)   bfa_timer_stop(&(__ioc)->ioc_timer)
+
+#define BFA_DBG_FWTRC_ENTS	(BFI_IOC_TRC_ENTS)
+#define BFA_DBG_FWTRC_LEN					\
+	(BFA_DBG_FWTRC_ENTS * sizeof(struct bfa_trc_s) +	\
+	 (sizeof(struct bfa_trc_mod_s) -			\
+	  BFA_TRC_MAX * sizeof(struct bfa_trc_s)))
+#define BFA_DBG_FWTRC_OFF(_fn)	(BFI_IOC_TRC_OFF + BFA_DBG_FWTRC_LEN * (_fn))
+#define bfa_ioc_stats(_ioc, _stats)	(_ioc)->stats._stats ++
+
+#define BFA_FLASH_CHUNK_NO(off)         (off / BFI_FLASH_CHUNK_SZ_WORDS)
+#define BFA_FLASH_OFFSET_IN_CHUNK(off)  (off % BFI_FLASH_CHUNK_SZ_WORDS)
+#define BFA_FLASH_CHUNK_ADDR(chunkno)   (chunkno * BFI_FLASH_CHUNK_SZ_WORDS)
+bfa_boolean_t bfa_auto_recover = BFA_FALSE;
+
+/*
+ * forward declarations
+ */
+static void bfa_ioc_aen_post(struct bfa_ioc_s *bfa,
+			     enum bfa_ioc_aen_event event);
+static void bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc);
+static void bfa_ioc_hw_sem_release(struct bfa_ioc_s *ioc);
+static void bfa_ioc_hw_sem_get_cancel(struct bfa_ioc_s *ioc);
+static void bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force);
+static void bfa_ioc_timeout(void *ioc);
+static void bfa_ioc_send_enable(struct bfa_ioc_s *ioc);
+static void bfa_ioc_send_disable(struct bfa_ioc_s *ioc);
+static void bfa_ioc_send_getattr(struct bfa_ioc_s *ioc);
+static void bfa_ioc_hb_monitor(struct bfa_ioc_s *ioc);
+static void bfa_ioc_hb_stop(struct bfa_ioc_s *ioc);
+static void bfa_ioc_reset(struct bfa_ioc_s *ioc, bfa_boolean_t force);
+static void bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc);
+static void bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc);
+static void bfa_ioc_recover(struct bfa_ioc_s *ioc);
+
+/**
+ *  hal_ioc_sm
+ */
+
+/**
+ * IOC state machine events
+ */
+enum ioc_event {
+	IOC_E_ENABLE		= 1,
+	IOC_E_DISABLE		= 2,
+	IOC_E_TIMEOUT		= 3,
+	IOC_E_FWREADY		= 4,
+	IOC_E_FWRSP_GETATTR	= 5,
+	IOC_E_FWRSP_ENABLE	= 6,
+	IOC_E_FWRSP_DISABLE	= 7,
+	IOC_E_HBFAIL		= 8,	/*  heartbeat failure */
+	IOC_E_SEMLOCKED		= 9,	/*  h/w semaphore is locked */
+};
+
+
+bfa_fsm_state_decl(bfa_ioc, reset, struct bfa_ioc_s, enum ioc_event)
+	bfa_fsm_state_decl(bfa_ioc, semwait, struct bfa_ioc_s, enum ioc_event)
+	bfa_fsm_state_decl(bfa_ioc, hwinit, struct bfa_ioc_s, enum ioc_event)
+	bfa_fsm_state_decl(bfa_ioc, enabling, struct bfa_ioc_s, enum ioc_event)
+	bfa_fsm_state_decl(bfa_ioc, getattr, struct bfa_ioc_s, enum ioc_event)
+	bfa_fsm_state_decl(bfa_ioc, op, struct bfa_ioc_s, enum ioc_event)
+	bfa_fsm_state_decl(bfa_ioc, initfail, struct bfa_ioc_s, enum ioc_event)
+	bfa_fsm_state_decl(bfa_ioc, hbfail, struct bfa_ioc_s, enum ioc_event)
+	bfa_fsm_state_decl(bfa_ioc, disabling, struct bfa_ioc_s, enum ioc_event)
+	bfa_fsm_state_decl(bfa_ioc, disabled, struct bfa_ioc_s, enum ioc_event)
+
+	static struct bfa_sm_table_s ioc_sm_table[] = {
+	{BFA_SM(bfa_ioc_sm_reset), BFA_IOC_RESET},
+	{BFA_SM(bfa_ioc_sm_semwait), BFA_IOC_SEMWAIT},
+	{BFA_SM(bfa_ioc_sm_hwinit), BFA_IOC_HWINIT},
+	{BFA_SM(bfa_ioc_sm_getattr), BFA_IOC_GETATTR},
+	{BFA_SM(bfa_ioc_sm_op), BFA_IOC_OPERATIONAL},
+	{BFA_SM(bfa_ioc_sm_initfail), BFA_IOC_INITFAIL},
+	{BFA_SM(bfa_ioc_sm_hbfail), BFA_IOC_HBFAIL},
+	{BFA_SM(bfa_ioc_sm_disabling), BFA_IOC_DISABLING},
+	{BFA_SM(bfa_ioc_sm_disabled), BFA_IOC_DISABLED},
+};
+
+
+static void
+bfa_ioc_sm_reset_entry(struct bfa_ioc_s *ioc)
+{
+	ioc->hwinit_count = 0;
+	ioc->auto_recover = bfa_auto_recover;
+}
+
+/**
+ * Beginning state. IOC is in reset state.
+ */
+static void
+bfa_ioc_sm_reset(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_ENABLE:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_semwait);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+static void
+bfa_ioc_sm_semwait_entry(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_hw_sem_get(ioc);
+}
+
+/**
+ * Awaiting release of h/w semaphore.
+ */
+static void
+bfa_ioc_sm_semwait(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_SEMLOCKED:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_hwinit);
+		break;
+
+	case IOC_E_DISABLE:
+		bfa_ioc_hw_sem_get_cancel(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	case IOC_E_FWREADY:
+		bfa_ioc_hw_sem_get_cancel(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_enabling);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+static void
+bfa_ioc_sm_hwinit_entry(struct bfa_ioc_s *ioc)
+{
+	ioc->hwinit_count = 0;
+	bfa_ioc_timer_start(ioc);
+	bfa_ioc_reset(ioc, BFA_FALSE);
+}
+
+/**
+ * Hardware is being initialized. Interrupts are enabled.
+ * Holding hardware semaphore lock.
+ */
+static void
+bfa_ioc_sm_hwinit(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_FWREADY:
+		bfa_ioc_timer_stop(ioc);
+		bfa_ioc_hw_sem_release(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_enabling);
+		break;
+
+	case IOC_E_TIMEOUT:
+		ioc->hwinit_count++;
+		if (ioc->hwinit_count < BFA_IOC_HWINIT_MAX) {
+			bfa_ioc_timer_start(ioc);
+			bfa_ioc_reset(ioc, BFA_TRUE);
+			break;
+		}
+
+		bfa_ioc_hw_sem_release(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
+		break;
+
+	case IOC_E_DISABLE:
+		bfa_ioc_hw_sem_release(ioc);
+		bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+static void
+bfa_ioc_sm_enabling_entry(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_timer_start(ioc);
+	bfa_ioc_send_enable(ioc);
+}
+
+/**
+ * Host IOC function is being enabled, awaiting response from firmware.
+ * Host semaphore is released.
+ */
+static void
+bfa_ioc_sm_enabling(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_FWRSP_ENABLE:
+		bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_getattr);
+		break;
+
+	case IOC_E_TIMEOUT:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
+		break;
+
+	case IOC_E_DISABLE:
+		bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	case IOC_E_FWREADY:
+		bfa_ioc_send_enable(ioc);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+static void
+bfa_ioc_sm_getattr_entry(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_timer_start(ioc);
+	bfa_ioc_send_getattr(ioc);
+}
+
+/**
+ * IOC configuration in progress. Timer is active.
+ */
+static void
+bfa_ioc_sm_getattr(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_FWRSP_GETATTR:
+		bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_op);
+		break;
+
+	case IOC_E_TIMEOUT:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_initfail);
+		break;
+
+	case IOC_E_DISABLE:
+		bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+static void
+bfa_ioc_sm_op_entry(struct bfa_ioc_s *ioc)
+{
+	ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_OK);
+	bfa_ioc_hb_monitor(ioc);
+	bfa_ioc_aen_post(ioc, BFA_IOC_AEN_ENABLE);
+}
+
+static void
+bfa_ioc_sm_op(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_DISABLE:
+		bfa_ioc_hb_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabling);
+		break;
+
+	case IOC_E_FWREADY:
+		/**
+		 * IOC recovery by other function. Treat it same as heartbeat failure.
+		 */
+		bfa_ioc_hb_stop(ioc);
+		/* !!! fall through !!! */
+
+	case IOC_E_HBFAIL:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_hbfail);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+static void
+bfa_ioc_sm_disabling_entry(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_aen_post(ioc, BFA_IOC_AEN_DISABLE);
+	bfa_ioc_timer_start(ioc);
+	bfa_ioc_send_disable(ioc);
+}
+
+/**
+ * IOC is being disabled
+ */
+static void
+bfa_ioc_sm_disabling(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_FWRSP_DISABLE:
+		bfa_ioc_timer_stop(ioc);
+		/*
+		 * !!! fall through !!!
+		 */
+
+	case IOC_E_TIMEOUT:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+static void
+bfa_ioc_sm_disabled_entry(struct bfa_ioc_s *ioc)
+{
+	ioc->cbfn->disable_cbfn(ioc->bfa);
+}
+
+static void
+bfa_ioc_sm_disabled(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_ENABLE:
+		bfa_ioc_aen_post(ioc, BFA_IOC_AEN_ENABLE);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_semwait);
+		break;
+
+	case IOC_E_DISABLE:
+		ioc->cbfn->disable_cbfn(ioc->bfa);
+		break;
+
+	case IOC_E_FWREADY:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+static void
+bfa_ioc_sm_initfail_entry(struct bfa_ioc_s *ioc)
+{
+	ioc->cbfn->enable_cbfn(ioc->bfa, BFA_STATUS_IOC_FAILURE);
+}
+
+/**
+ * Hardware initialization failed.
+ */
+static void
+bfa_ioc_sm_initfail(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_DISABLE:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+static void
+bfa_ioc_sm_hbfail_entry(struct bfa_ioc_s *ioc)
+{
+	struct list_head			*qe;
+	struct bfa_ioc_hbfail_notify_s	*notify;
+
+	/**
+	 * Mark IOC as failed in hardware.
+	 */
+	bfa_reg_write(ioc->ioc_regs.ioc_fwstate, BFI_IOC_HBFAIL);
+
+	/**
+	 * Notify driver and common modules registered for notification.
+	 */
+	ioc->cbfn->hbfail_cbfn(ioc->bfa);
+	list_for_each(qe, &ioc->hb_notify_q) {
+		notify = (struct bfa_ioc_hbfail_notify_s *) qe;
+		notify->cbfn(notify->cbarg);
+	}
+
+	/**
+	 * Flush any queued up mailbox requests.
+	 */
+	bfa_ioc_mbox_hbfail(ioc);
+	bfa_ioc_aen_post(ioc, BFA_IOC_AEN_HBFAIL);
+
+	/**
+	 * Trigger auto-recovery after a delay.
+	 */
+	if (ioc->auto_recover)
+		bfa_ioc_timer_start(ioc);
+}
+
+/**
+ * IOC heartbeat failure.
+ */
+static void
+bfa_ioc_sm_hbfail(struct bfa_ioc_s *ioc, enum ioc_event event)
+{
+	bfa_trc(ioc, event);
+
+	switch (event) {
+	case IOC_E_DISABLE:
+		if (ioc->auto_recover)
+			bfa_ioc_timer_stop(ioc);
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_disabled);
+		break;
+
+	case IOC_E_TIMEOUT:
+		bfa_fsm_set_state(ioc, bfa_ioc_sm_semwait);
+		break;
+
+	case IOC_E_FWREADY:
+		/**
+		 * Recovery is already initiated by other function.
+		 */
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  hal_ioc_pvt BFA IOC private functions
+ */
+
+static void
+bfa_ioc_sem_timeout(void *ioc_arg)
+{
+	struct bfa_ioc_s  *ioc = (struct bfa_ioc_s *) ioc_arg;
+
+	bfa_ioc_hw_sem_get(ioc);
+}
+
+static void
+bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc)
+{
+	u32        r32;
+
+	/**
+	 * First read to the semaphore register will return 0, subsequent reads
+	 * will return 1. Semaphore is released by writing 0 to the register
+	 */
+	r32 = bfa_reg_read(ioc->ioc_regs.host_sem0_reg);
+	if (r32 == 0) {
+		bfa_fsm_send_event(ioc, IOC_E_SEMLOCKED);
+		return;
+	}
+
+	bfa_timer_begin(ioc->timer_mod, &ioc->sem_timer, bfa_ioc_sem_timeout,
+			ioc, BFA_IOC_TOV);
+}
+
+static void
+bfa_ioc_hw_sem_release(struct bfa_ioc_s *ioc)
+{
+	bfa_reg_write(ioc->ioc_regs.host_sem0_reg, 1);
+}
+
+static void
+bfa_ioc_hw_sem_get_cancel(struct bfa_ioc_s *ioc)
+{
+	bfa_timer_stop(&ioc->sem_timer);
+}
+
+/**
+ * Initialize LPU local memory (aka secondary memory / SRAM)
+ */
+static void
+bfa_ioc_lmem_init(struct bfa_ioc_s *ioc)
+{
+	u32        pss_ctl;
+	int             i;
+#define PSS_LMEM_INIT_TIME  10000
+
+	pss_ctl = bfa_reg_read(ioc->ioc_regs.pss_ctl_reg);
+	pss_ctl &= ~__PSS_LMEM_RESET;
+	pss_ctl |= __PSS_LMEM_INIT_EN;
+	pss_ctl |= __PSS_I2C_CLK_DIV(3UL);	/* i2c workaround 12.5khz clock
+						 */
+	bfa_reg_write(ioc->ioc_regs.pss_ctl_reg, pss_ctl);
+
+	/**
+	 * wait for memory initialization to be complete
+	 */
+	i = 0;
+	do {
+		pss_ctl = bfa_reg_read(ioc->ioc_regs.pss_ctl_reg);
+		i++;
+	} while (!(pss_ctl & __PSS_LMEM_INIT_DONE) && (i < PSS_LMEM_INIT_TIME));
+
+	/**
+	 * If memory initialization is not successful, IOC timeout will catch
+	 * such failures.
+	 */
+	bfa_assert(pss_ctl & __PSS_LMEM_INIT_DONE);
+	bfa_trc(ioc, pss_ctl);
+
+	pss_ctl &= ~(__PSS_LMEM_INIT_DONE | __PSS_LMEM_INIT_EN);
+	bfa_reg_write(ioc->ioc_regs.pss_ctl_reg, pss_ctl);
+}
+
+static void
+bfa_ioc_lpu_start(struct bfa_ioc_s *ioc)
+{
+	u32        pss_ctl;
+
+	/**
+	 * Take processor out of reset.
+	 */
+	pss_ctl = bfa_reg_read(ioc->ioc_regs.pss_ctl_reg);
+	pss_ctl &= ~__PSS_LPU0_RESET;
+
+	bfa_reg_write(ioc->ioc_regs.pss_ctl_reg, pss_ctl);
+}
+
+/**
+ * Return true if current running version is same as driver version.
+ */
+static bfa_boolean_t
+bfa_ioc_fwver_check(struct bfa_ioc_s *ioc)
+{
+	u32        pgnum, pgoff;
+	u32        loff = 0;
+	int             i;
+	struct bfi_ioc_image_hdr_s fwhdr, *drv_fwhdr;
+	u32	*fwsig = (u32 *) &fwhdr;
+
+	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
+	pgoff = bfa_ioc_smem_pgoff(ioc, loff);
+	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+
+	for (i = 0; i < (sizeof(struct bfi_ioc_image_hdr_s) / sizeof(u32));
+	     i++) {
+		fwsig[i] =
+			bfa_mem_read(ioc->ioc_regs.smem_page_start, loff);
+		loff += sizeof(u32);
+	}
+
+	bfa_trc(ioc, fwhdr.signature);
+	bfa_trc(ioc, fwhdr.cksum);
+	bfa_trc(ioc, fwhdr.exec);
+	bfa_trc(ioc, fwhdr.param);
+
+	drv_fwhdr = (struct bfi_ioc_image_hdr_s *) bfi_image_get_chunk(0);
+
+	bfa_trc(ioc, drv_fwhdr->signature);
+	bfa_trc(ioc, drv_fwhdr->cksum);
+	bfa_trc(ioc, drv_fwhdr->exec);
+	bfa_trc(ioc, drv_fwhdr->param);
+
+	return (((fwhdr.signature == drv_fwhdr->signature))
+		&& (fwhdr.cksum == drv_fwhdr->cksum)
+		&& (fwhdr.exec == drv_fwhdr->exec)
+);
+}
+
+/**
+ * Conditionally flush any pending message from firmware at start.
+ */
+static void
+bfa_ioc_msgflush(struct bfa_ioc_s *ioc)
+{
+	u32        r32;
+
+	r32 = bfa_reg_read(ioc->ioc_regs.lpu_mbox_cmd);
+	if (r32)
+		bfa_reg_write(ioc->ioc_regs.lpu_mbox_cmd, 1);
+}
+
+
+static void
+bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force)
+{
+	enum bfi_ioc_state ioc_fwstate;
+
+	ioc_fwstate = bfa_reg_read(ioc->ioc_regs.ioc_fwstate);
+
+	if (force)
+		ioc_fwstate = BFI_IOC_UNINIT;
+
+	bfa_trc(ioc, ioc_fwstate);
+
+	/**
+	 * If hardware initialization is in progress (initialized by other IOC),
+	 * just wait for an initialization completion interrupt.
+	 */
+	if ((ioc_fwstate == BFI_IOC_INITING) && bfa_ioc_fwver_check(ioc)) {
+		bfa_trc(ioc, ioc_fwstate);
+		return;
+	}
+
+	/**
+	 * If IOC function is disabled and firmware version is same,
+	 * just re-enable IOC.
+	 */
+	if ((ioc_fwstate == BFI_IOC_DISABLED || ioc_fwstate == BFI_IOC_OP)
+	    && bfa_ioc_fwver_check(ioc)) {
+		bfa_trc(ioc, ioc_fwstate);
+		/**
+		 * When using MSI-X any pending firmware ready event should
+		 * be flushed. Otherwise MSI-X interrupts are not delivered.
+		 */
+		bfa_ioc_msgflush(ioc);
+		bfa_fsm_send_event(ioc, IOC_E_FWREADY);
+		return;
+	}
+
+	/**
+	 * Initialize the h/w for any other states.
+	 */
+	bfa_ioc_boot(ioc, BFI_BOOT_TYPE_NORMAL, ioc->pcidev.device_id);
+}
+
+static void
+bfa_ioc_timeout(void *ioc_arg)
+{
+	struct bfa_ioc_s  *ioc = (struct bfa_ioc_s *) ioc_arg;
+
+	bfa_trc(ioc, 0);
+	bfa_fsm_send_event(ioc, IOC_E_TIMEOUT);
+}
+
+void
+bfa_ioc_mbox_send(struct bfa_ioc_s *ioc, void *ioc_msg, int len)
+{
+	u32       *msgp = (u32 *) ioc_msg;
+	u32        i;
+
+	bfa_trc(ioc, msgp[0]);
+	bfa_trc(ioc, len);
+
+	bfa_assert(len <= BFI_IOC_MSGLEN_MAX);
+
+	/*
+	 * first write msg to mailbox registers
+	 */
+	for (i = 0; i < len / sizeof(u32); i++)
+		bfa_reg_write(ioc->ioc_regs.hfn_mbox + i * sizeof(u32),
+			      bfa_os_wtole(msgp[i]));
+
+	for (; i < BFI_IOC_MSGLEN_MAX / sizeof(u32); i++)
+		bfa_reg_write(ioc->ioc_regs.hfn_mbox + i * sizeof(u32), 0);
+
+	/*
+	 * write 1 to mailbox CMD to trigger LPU event
+	 */
+	bfa_reg_write(ioc->ioc_regs.hfn_mbox_cmd, 1);
+	(void)bfa_reg_read(ioc->ioc_regs.hfn_mbox_cmd);
+}
+
+static void
+bfa_ioc_send_enable(struct bfa_ioc_s *ioc)
+{
+	struct bfi_ioc_ctrl_req_s enable_req;
+
+	bfi_h2i_set(enable_req.mh, BFI_MC_IOC, BFI_IOC_H2I_ENABLE_REQ,
+		    bfa_ioc_portid(ioc));
+	enable_req.ioc_class = ioc->ioc_mc;
+	bfa_ioc_mbox_send(ioc, &enable_req, sizeof(struct bfi_ioc_ctrl_req_s));
+}
+
+static void
+bfa_ioc_send_disable(struct bfa_ioc_s *ioc)
+{
+	struct bfi_ioc_ctrl_req_s disable_req;
+
+	bfi_h2i_set(disable_req.mh, BFI_MC_IOC, BFI_IOC_H2I_DISABLE_REQ,
+		    bfa_ioc_portid(ioc));
+	bfa_ioc_mbox_send(ioc, &disable_req, sizeof(struct bfi_ioc_ctrl_req_s));
+}
+
+static void
+bfa_ioc_send_getattr(struct bfa_ioc_s *ioc)
+{
+	struct bfi_ioc_getattr_req_s	attr_req;
+
+	bfi_h2i_set(attr_req.mh, BFI_MC_IOC, BFI_IOC_H2I_GETATTR_REQ,
+		    bfa_ioc_portid(ioc));
+	bfa_dma_be_addr_set(attr_req.attr_addr, ioc->attr_dma.pa);
+	bfa_ioc_mbox_send(ioc, &attr_req, sizeof(attr_req));
+}
+
+static void
+bfa_ioc_hb_check(void *cbarg)
+{
+	struct bfa_ioc_s  *ioc = cbarg;
+	u32        hb_count;
+
+	hb_count = bfa_reg_read(ioc->ioc_regs.heartbeat);
+	if (ioc->hb_count == hb_count) {
+		ioc->hb_fail++;
+	} else {
+		ioc->hb_count = hb_count;
+		ioc->hb_fail = 0;
+	}
+
+	if (ioc->hb_fail >= BFA_IOC_HB_FAIL_MAX) {
+		bfa_log(ioc->logm, BFA_LOG_HAL_HEARTBEAT_FAILURE,
+			hb_count);
+		ioc->hb_fail = 0;
+		bfa_ioc_recover(ioc);
+		return;
+	}
+
+	bfa_ioc_mbox_poll(ioc);
+	bfa_timer_begin(ioc->timer_mod, &ioc->ioc_timer, bfa_ioc_hb_check,
+			ioc, BFA_IOC_HB_TOV);
+}
+
+static void
+bfa_ioc_hb_monitor(struct bfa_ioc_s *ioc)
+{
+	ioc->hb_fail = 0;
+	ioc->hb_count = bfa_reg_read(ioc->ioc_regs.heartbeat);
+	bfa_timer_begin(ioc->timer_mod, &ioc->ioc_timer, bfa_ioc_hb_check,
+			ioc, BFA_IOC_HB_TOV);
+}
+
+static void
+bfa_ioc_hb_stop(struct bfa_ioc_s *ioc)
+{
+	bfa_timer_stop(&ioc->ioc_timer);
+}
+
+/**
+ * Host to LPU mailbox message addresses
+ */
+static struct { u32 hfn_mbox, lpu_mbox, hfn_pgn; } iocreg_fnreg[] = {
+	{ HOSTFN0_LPU_MBOX0_0, LPU_HOSTFN0_MBOX0_0, HOST_PAGE_NUM_FN0 },
+	{ HOSTFN1_LPU_MBOX0_8, LPU_HOSTFN1_MBOX0_8, HOST_PAGE_NUM_FN1 },
+	{ HOSTFN2_LPU_MBOX0_0, LPU_HOSTFN2_MBOX0_0, HOST_PAGE_NUM_FN2 },
+	{ HOSTFN3_LPU_MBOX0_8, LPU_HOSTFN3_MBOX0_8, HOST_PAGE_NUM_FN3 }
+};
+
+/**
+ * Host <-> LPU mailbox command/status registers - port 0
+ */
+static struct { u32 hfn, lpu; } iocreg_mbcmd_p0[] = {
+	{ HOSTFN0_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN0_MBOX0_CMD_STAT },
+	{ HOSTFN1_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN1_MBOX0_CMD_STAT },
+	{ HOSTFN2_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN2_MBOX0_CMD_STAT },
+	{ HOSTFN3_LPU0_MBOX0_CMD_STAT, LPU0_HOSTFN3_MBOX0_CMD_STAT }
+};
+
+/**
+ * Host <-> LPU mailbox command/status registers - port 1
+ */
+static struct { u32 hfn, lpu; } iocreg_mbcmd_p1[] = {
+	{ HOSTFN0_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN0_MBOX0_CMD_STAT },
+	{ HOSTFN1_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN1_MBOX0_CMD_STAT },
+	{ HOSTFN2_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN2_MBOX0_CMD_STAT },
+	{ HOSTFN3_LPU1_MBOX0_CMD_STAT, LPU1_HOSTFN3_MBOX0_CMD_STAT }
+};
+
+static void
+bfa_ioc_reg_init(struct bfa_ioc_s *ioc)
+{
+	bfa_os_addr_t   rb;
+	int		pcifn = bfa_ioc_pcifn(ioc);
+
+	rb = bfa_ioc_bar0(ioc);
+
+	ioc->ioc_regs.hfn_mbox = rb + iocreg_fnreg[pcifn].hfn_mbox;
+	ioc->ioc_regs.lpu_mbox = rb + iocreg_fnreg[pcifn].lpu_mbox;
+	ioc->ioc_regs.host_page_num_fn = rb + iocreg_fnreg[pcifn].hfn_pgn;
+
+	if (ioc->port_id == 0) {
+		ioc->ioc_regs.heartbeat = rb + BFA_IOC0_HBEAT_REG;
+		ioc->ioc_regs.ioc_fwstate = rb + BFA_IOC0_STATE_REG;
+		ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd_p0[pcifn].hfn;
+		ioc->ioc_regs.lpu_mbox_cmd = rb + iocreg_mbcmd_p0[pcifn].lpu;
+	} else {
+		ioc->ioc_regs.heartbeat = (rb + BFA_IOC1_HBEAT_REG);
+		ioc->ioc_regs.ioc_fwstate = (rb + BFA_IOC1_STATE_REG);
+		ioc->ioc_regs.hfn_mbox_cmd = rb + iocreg_mbcmd_p1[pcifn].hfn;
+		ioc->ioc_regs.lpu_mbox_cmd = rb + iocreg_mbcmd_p1[pcifn].lpu;
+	}
+
+	/*
+	 * PSS control registers
+	 */
+	ioc->ioc_regs.pss_ctl_reg = (rb + PSS_CTL_REG);
+	ioc->ioc_regs.app_pll_fast_ctl_reg = (rb + APP_PLL_425_CTL_REG);
+	ioc->ioc_regs.app_pll_slow_ctl_reg = (rb + APP_PLL_312_CTL_REG);
+
+	/*
+	 * host semaphore registers
+	 */
+	ioc->ioc_regs.host_sem0_reg = (rb + HOST_SEM0_REG);
+	ioc->ioc_regs.host_sem1_reg = (rb + HOST_SEM1_REG);
+	ioc->ioc_regs.host_sem2_reg = (rb + HOST_SEM2_REG);
+	ioc->ioc_regs.host_sem3_reg = (rb + HOST_SEM3_REG);
+
+	/**
+	 * sram memory access
+	 */
+	ioc->ioc_regs.smem_page_start = (rb + PSS_SMEM_PAGE_START);
+	ioc->ioc_regs.smem_pg0 = BFI_IOC_SMEM_PG0_CB;
+	if (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT)
+		ioc->ioc_regs.smem_pg0 = BFI_IOC_SMEM_PG0_CT;
+}
+
+/**
+ *      Initiate a full firmware download.
+ */
+static void
+bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
+		    u32 boot_param)
+{
+	u32       *fwimg;
+	u32        pgnum, pgoff;
+	u32        loff = 0;
+	u32        chunkno = 0;
+	u32        i;
+
+	/**
+	 * Initialize LMEM first before code download
+	 */
+	bfa_ioc_lmem_init(ioc);
+
+	/**
+	 * Flash based firmware boot
+	 */
+	bfa_trc(ioc, bfi_image_size);
+	if (bfi_image_size < BFA_IOC_FWIMG_MINSZ)
+		boot_type = BFI_BOOT_TYPE_FLASH;
+	fwimg = bfi_image_get_chunk(chunkno);
+	fwimg[BFI_BOOT_TYPE_OFF / sizeof(u32)] =
+		bfa_os_swap32(boot_type);
+	fwimg[BFI_BOOT_PARAM_OFF / sizeof(u32)] =
+		bfa_os_swap32(boot_param);
+
+	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
+	pgoff = bfa_ioc_smem_pgoff(ioc, loff);
+
+	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+
+	for (i = 0; i < bfi_image_size; i++) {
+
+		if (BFA_FLASH_CHUNK_NO(i) != chunkno) {
+			chunkno = BFA_FLASH_CHUNK_NO(i);
+			fwimg = bfi_image_get_chunk(BFA_FLASH_CHUNK_ADDR(chunkno));
+		}
+
+		/**
+		 * write smem
+		 */
+		bfa_mem_write(ioc->ioc_regs.smem_page_start, loff,
+			      fwimg[BFA_FLASH_OFFSET_IN_CHUNK(i)]);
+
+		loff += sizeof(u32);
+
+		/**
+		 * handle page offset wrap around
+		 */
+		loff = PSS_SMEM_PGOFF(loff);
+		if (loff == 0) {
+			pgnum++;
+			bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
+				      pgnum);
+		}
+	}
+
+	bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
+		      bfa_ioc_smem_pgnum(ioc, 0));
+}
+
+static void
+bfa_ioc_reset(struct bfa_ioc_s *ioc, bfa_boolean_t force)
+{
+	bfa_ioc_hwinit(ioc, force);
+	ioc->cbfn->reset_cbfn(ioc->bfa);
+}
+
+/**
+ * Update BFA configuration from firmware configuration.
+ */
+static void
+bfa_ioc_getattr_reply(struct bfa_ioc_s *ioc)
+{
+	struct bfi_ioc_attr_s	*attr = ioc->attr;
+
+	attr->adapter_prop  = bfa_os_ntohl(attr->adapter_prop);
+	attr->maxfrsize     = bfa_os_ntohs(attr->maxfrsize);
+
+	bfa_fsm_send_event(ioc, IOC_E_FWRSP_GETATTR);
+}
+
+/**
+ * Attach time initialization of mbox logic.
+ */
+static void
+bfa_ioc_mbox_attach(struct bfa_ioc_s *ioc)
+{
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	int	mc;
+
+	INIT_LIST_HEAD(&mod->cmd_q);
+	for (mc = 0; mc < BFI_MC_MAX; mc++) {
+		mod->mbhdlr[ mc ].cbfn = NULL;
+		mod->mbhdlr[ mc ].cbarg = ioc->bfa;
+	}
+}
+
+/**
+ * Mbox poll timer -- restarts any pending mailbox requests.
+ */
+static void
+bfa_ioc_mbox_poll(struct bfa_ioc_s *ioc)
+{
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	struct bfa_mbox_cmd_s		*cmd;
+	u32			stat;
+
+	/**
+	 * If no command pending, do nothing
+	 */
+	if (list_empty(&mod->cmd_q))
+		return;
+
+	/**
+	 * If previous command is not yet fetched by firmware, do nothing
+	 */
+	stat = bfa_reg_read(ioc->ioc_regs.hfn_mbox_cmd);
+	if (stat)
+		return;
+
+	/**
+	 * Enqueue command to firmware.
+	 */
+	bfa_q_deq(&mod->cmd_q, &cmd);
+	bfa_ioc_mbox_send(ioc, cmd->msg, sizeof(cmd->msg));
+}
+
+/**
+ * Cleanup any pending requests.
+ */
+static void
+bfa_ioc_mbox_hbfail(struct bfa_ioc_s *ioc)
+{
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	struct bfa_mbox_cmd_s		*cmd;
+
+	while (!list_empty(&mod->cmd_q)) {
+		bfa_q_deq(&mod->cmd_q, &cmd);
+	}
+}
+
+/**
+ * Initialize IOC to port mapping.
+ */
+static void
+bfa_ioc_map_port(struct bfa_ioc_s *ioc)
+{
+	bfa_os_addr_t   rb = ioc->pcidev.pci_bar_kva;
+	u32	r32;
+
+	/**
+	 * For crossbow, port id is same as pci function.
+	 */
+	if (ioc->pcidev.device_id != BFA_PCI_DEVICE_ID_CT) {
+		ioc->port_id = bfa_ioc_pcifn(ioc);
+		return;
+	}
+
+	/**
+	 * For catapult, base port id on personality register and IOC type
+	 */
+	r32 = bfa_reg_read(rb + FNC_PERS_REG);
+	r32 >>= (bfa_ioc_pcifn(ioc)) * 8;
+	ioc->port_id = (r32 & __F0_PORT_MAP_MK) >> __F0_PORT_MAP_SH;
+
+	bfa_trc(ioc, bfa_ioc_pcifn(ioc));
+	bfa_trc(ioc, ioc->port_id);
+}
+
+
+
+/**
+ *  hal_ioc_public
+ */
+
+bfa_status_t
+bfa_ioc_pll_init(struct bfa_ioc_s *ioc)
+{
+	bfa_os_addr_t   rb = ioc->pcidev.pci_bar_kva;
+	u32	pll_sclk, pll_fclk, r32;
+
+	if (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT) {
+		pll_sclk = __APP_PLL_312_ENABLE | __APP_PLL_312_LRESETN |
+			__APP_PLL_312_RSEL200500 | __APP_PLL_312_P0_1(0U) |
+			__APP_PLL_312_JITLMT0_1(3U) |
+			__APP_PLL_312_CNTLMT0_1(1U);
+		pll_fclk = __APP_PLL_425_ENABLE | __APP_PLL_425_LRESETN |
+			__APP_PLL_425_RSEL200500 | __APP_PLL_425_P0_1(0U) |
+			__APP_PLL_425_JITLMT0_1(3U) |
+			__APP_PLL_425_CNTLMT0_1(1U);
+
+		/**
+		 *	For catapult, choose operational mode FC/FCoE
+		 */
+		if (ioc->fcmode) {
+			bfa_reg_write((rb + OP_MODE), 0);
+			bfa_reg_write((rb + ETH_MAC_SER_REG),
+				      __APP_EMS_CMLCKSEL |
+				      __APP_EMS_REFCKBUFEN2 |
+				      __APP_EMS_CHANNEL_SEL);
+		} else {
+			ioc->pllinit = BFA_TRUE;
+			bfa_reg_write((rb + OP_MODE), __GLOBAL_FCOE_MODE);
+			bfa_reg_write((rb + ETH_MAC_SER_REG),
+				      __APP_EMS_REFCKBUFEN1);
+		}
+	} else {
+		pll_sclk = __APP_PLL_312_ENABLE | __APP_PLL_312_LRESETN |
+			__APP_PLL_312_P0_1(3U) |
+			__APP_PLL_312_JITLMT0_1(3U) |
+			__APP_PLL_312_CNTLMT0_1(3U);
+		pll_fclk = __APP_PLL_425_ENABLE | __APP_PLL_425_LRESETN |
+			__APP_PLL_425_RSEL200500 | __APP_PLL_425_P0_1(3U) |
+			__APP_PLL_425_JITLMT0_1(3U) |
+			__APP_PLL_425_CNTLMT0_1(3U);
+	}
+
+	bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_UNINIT);
+	bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_UNINIT);
+
+	bfa_reg_write((rb + HOSTFN0_INT_MSK), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_MSK), 0xffffffffU);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+		      __APP_PLL_312_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+		      __APP_PLL_312_BYPASS |
+		      __APP_PLL_312_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+		      __APP_PLL_425_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+		      __APP_PLL_425_BYPASS |
+		      __APP_PLL_425_LOGIC_SOFT_RESET);
+	bfa_os_udelay(2);
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+		      __APP_PLL_312_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+		      __APP_PLL_425_LOGIC_SOFT_RESET);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg,
+		      pll_sclk | __APP_PLL_312_LOGIC_SOFT_RESET);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg,
+		      pll_fclk | __APP_PLL_425_LOGIC_SOFT_RESET);
+
+	/**
+	 * Wait for PLLs to lock.
+	 */
+	bfa_os_udelay(2000);
+	bfa_reg_write((rb + HOSTFN0_INT_STATUS), 0xffffffffU);
+	bfa_reg_write((rb + HOSTFN1_INT_STATUS), 0xffffffffU);
+
+	bfa_reg_write(ioc->ioc_regs.app_pll_slow_ctl_reg, pll_sclk);
+	bfa_reg_write(ioc->ioc_regs.app_pll_fast_ctl_reg, pll_fclk);
+
+	if (ioc->pcidev.device_id == BFA_PCI_DEVICE_ID_CT) {
+		bfa_reg_write((rb + MBIST_CTL_REG), __EDRAM_BISTR_START);
+		bfa_os_udelay(1000);
+		r32 = bfa_reg_read((rb + MBIST_STAT_REG));
+		bfa_trc(ioc, r32);
+	}
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * Interface used by diag module to do firmware boot with memory test
+ * as the entry vector.
+ */
+void
+bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_param)
+{
+	bfa_os_addr_t   rb;
+
+	bfa_ioc_stats(ioc, ioc_boots);
+
+	if (bfa_ioc_pll_init(ioc) != BFA_STATUS_OK)
+		return;
+
+	/**
+	 * Initialize IOC state of all functions on a chip reset.
+	 */
+	rb = ioc->pcidev.pci_bar_kva;
+	if (boot_param == BFI_BOOT_TYPE_MEMTEST) {
+		bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_MEMTEST);
+		bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_MEMTEST);
+	} else {
+		bfa_reg_write((rb + BFA_IOC0_STATE_REG), BFI_IOC_INITING);
+		bfa_reg_write((rb + BFA_IOC1_STATE_REG), BFI_IOC_INITING);
+	}
+
+	bfa_ioc_download_fw(ioc, boot_type, boot_param);
+
+	/**
+	 * Enable interrupts just before starting LPU
+	 */
+	bfa_ioc_lpu_start(ioc);
+}
+
+/**
+ * Enable/disable IOC failure auto recovery.
+ */
+void
+bfa_ioc_auto_recover(bfa_boolean_t auto_recover)
+{
+	bfa_auto_recover = BFA_FALSE;
+}
+
+
+bfa_boolean_t
+bfa_ioc_is_operational(struct bfa_ioc_s *ioc)
+{
+	return bfa_fsm_cmp_state(ioc, bfa_ioc_sm_op);
+}
+
+
+bfa_boolean_t
+bfa_ioc_is_disabled(struct bfa_ioc_s *ioc)
+{
+	return (bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabling) ||
+		bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabled));
+}
+
+#define bfa_ioc_state_disabled(__sm)		\
+	(((__sm) == BFI_IOC_UNINIT) ||		\
+	 ((__sm) == BFI_IOC_INITING) ||		\
+	 ((__sm) == BFI_IOC_HWINIT) ||		\
+	 ((__sm) == BFI_IOC_DISABLED) ||	\
+	 ((__sm) == BFI_IOC_HBFAIL) ||		\
+	 ((__sm) == BFI_IOC_CFG_DISABLED))
+
+/**
+ * Check if adapter is disabled -- both IOCs should be in a disabled
+ * state.
+ */
+bfa_boolean_t
+bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc)
+{
+	u32        ioc_state;
+	bfa_os_addr_t   rb = ioc->pcidev.pci_bar_kva;
+
+	if (!bfa_fsm_cmp_state(ioc, bfa_ioc_sm_disabled))
+		return BFA_FALSE;
+
+	ioc_state = bfa_reg_read(rb + BFA_IOC0_STATE_REG);
+	if (!bfa_ioc_state_disabled(ioc_state))
+		return BFA_FALSE;
+
+	ioc_state = bfa_reg_read(rb + BFA_IOC1_STATE_REG);
+	if (!bfa_ioc_state_disabled(ioc_state))
+		return BFA_FALSE;
+
+	return BFA_TRUE;
+}
+
+void
+bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg)
+{
+	u32	*msgp = mbmsg;
+	u32	r32;
+	int		i;
+
+	/* FCS_BRINGUP*/
+	printk("function: %s, Line %d \n",__FUNCTION__, __LINE__);
+	/**
+	 * read the MBOX msg
+	 */
+	for (i = 0; i < (sizeof(union bfi_ioc_i2h_msg_u) / sizeof(u32));
+	     i++) {
+		r32 = bfa_reg_read(ioc->ioc_regs.lpu_mbox +
+				   i * sizeof(u32));
+		msgp[i] = bfa_os_htonl(r32);
+	}
+
+	/**
+	 * turn off mailbox interrupt by clearing mailbox status
+	 */
+	bfa_reg_write(ioc->ioc_regs.lpu_mbox_cmd, 1);
+	bfa_reg_read(ioc->ioc_regs.lpu_mbox_cmd);
+	/* FCS_BRINGUP*/
+	printk("function: %s, Line %d \n",__FUNCTION__, __LINE__);
+}
+
+void
+bfa_ioc_isr(struct bfa_ioc_s *ioc, struct bfi_mbmsg_s *m)
+{
+	union bfi_ioc_i2h_msg_u	*msg;
+
+	/* FCS_BRINGUP*/
+	printk("function: %s, Line %d \n",__FUNCTION__, __LINE__);
+	msg = (union bfi_ioc_i2h_msg_u *) m;
+
+	bfa_ioc_stats(ioc, ioc_isrs);
+	bfa_trc(ioc, msg->mh.msg_id);
+
+	/* FCS_BRINGUP*/
+	printk("function: %s, Line %d msg->mh.msg_id %d\n",__FUNCTION__, __LINE__, msg->mh.msg_id);
+	switch (msg->mh.msg_id) {
+	case BFI_IOC_I2H_READY_EVENT:
+		bfa_fsm_send_event(ioc, IOC_E_FWREADY);
+		break;
+
+	case BFI_IOC_I2H_ENABLE_REPLY:
+		bfa_fsm_send_event(ioc, IOC_E_FWRSP_ENABLE);
+		break;
+
+	case BFI_IOC_I2H_DISABLE_REPLY:
+		bfa_fsm_send_event(ioc, IOC_E_FWRSP_DISABLE);
+		break;
+
+	case BFI_IOC_I2H_GETATTR_REPLY:
+		bfa_ioc_getattr_reply(ioc);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+	/* FCS_BRINGUP*/
+	printk("returning function: %s, Line %d \n",__FUNCTION__, __LINE__);
+}
+
+/**
+ * IOC attach time initialization and setup.
+ *
+ * @param[in]	ioc	memory for IOC
+ * @param[in]	bfa	driver instance structure
+ * @param[in]	trcmod	kernel trace module
+ * @param[in]	aen	kernel aen event module
+ * @param[in]	logm	kernel logging module
+ */
+void
+bfa_ioc_attach(struct bfa_ioc_s *ioc, void *bfa, struct bfa_ioc_cbfn_s *cbfn,
+	       struct bfa_timer_mod_s *timer_mod, struct bfa_trc_mod_s *trcmod,
+	       struct bfa_aen_s *aen, struct bfa_log_mod_s *logm)
+{
+	ioc->bfa	= bfa;
+	ioc->cbfn	= cbfn;
+	ioc->timer_mod	= timer_mod;
+	ioc->trcmod	= trcmod;
+	ioc->aen	= aen;
+	ioc->logm	= logm;
+	ioc->fcmode	= BFA_FALSE;
+	ioc->pllinit	= BFA_FALSE;
+
+	bfa_ioc_mbox_attach(ioc);
+	INIT_LIST_HEAD(&ioc->hb_notify_q);
+
+	bfa_fsm_set_state(ioc, bfa_ioc_sm_reset);
+}
+
+/**
+ * Setup IOC PCI properties.
+ *
+ * @param[in]	pcidev	PCI device information for this IOC
+ */
+void
+bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev, enum bfi_mclass mc)
+{
+	ioc->ioc_mc	= mc;
+	ioc->pcidev	= *pcidev;
+
+	bfa_ioc_map_port(ioc);
+	bfa_ioc_reg_init(ioc);
+}
+
+/**
+ * Initialize IOC dma memory
+ *
+ * @param[in]	dm_kva	kernel virtual address of IOC dma memory
+ * @param[in]	dm_pa	physical address of IOC dma memory
+ */
+void
+bfa_ioc_mem_claim(struct bfa_ioc_s *ioc,  u8 *dm_kva, u64 dm_pa)
+{
+	/**
+	 * dma memory for firmware attribute
+	 */
+	ioc->attr_dma.kva = dm_kva;
+	ioc->attr_dma.pa = dm_pa;
+	ioc->attr = (struct bfi_ioc_attr_s *) dm_kva;
+}
+
+/**
+ * Return size of dma memory required.
+ */
+u32
+bfa_ioc_meminfo(void)
+{
+	return BFA_ROUNDUP(sizeof(struct bfi_ioc_attr_s), BFA_DMA_ALIGN_SZ);
+}
+
+bfa_status_t
+bfa_ioc_enable(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_stats(ioc, ioc_enables);
+	bfa_fsm_send_event(ioc, IOC_E_ENABLE);
+
+	return BFA_STATUS_OK;
+}
+
+void
+bfa_ioc_disable(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_stats(ioc, ioc_disables);
+	bfa_fsm_send_event(ioc, IOC_E_DISABLE);
+}
+
+/**
+ * Returns memory required for saving firmware trace in case of crash.
+ * Driver must call this interface to allocate memory required for
+ * automatic saving of firmware trace. Driver should call
+ * bfa_ioc_debug_memclaim() right after bfa_ioc_attach() to setup this
+ * trace memory.
+ */
+int
+bfa_ioc_debug_trcsz(bfa_boolean_t auto_recover)
+{
+	return (auto_recover) ? BFA_DBG_FWTRC_LEN : 0;
+}
+
+/**
+ * Initialize memory for saving firmware trace. Driver must initialize
+ * trace memory before call bfa_ioc_enable().
+ */
+void
+bfa_ioc_debug_memclaim(struct bfa_ioc_s *ioc, void *dbg_fwsave)
+{
+	bfa_assert(ioc->auto_recover);
+	ioc->dbg_fwsave     = dbg_fwsave;
+	ioc->dbg_fwsave_len = bfa_ioc_debug_trcsz(ioc->auto_recover);
+}
+
+u32
+bfa_ioc_smem_pgnum(struct bfa_ioc_s *ioc, u32 fmaddr)
+{
+	return PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, fmaddr);
+}
+
+u32
+bfa_ioc_smem_pgoff(struct bfa_ioc_s *ioc, u32 fmaddr)
+{
+	return PSS_SMEM_PGOFF(fmaddr);
+}
+
+/**
+ * Register mailbox message handler functions
+ *
+ * @param[in]	ioc		IOC instance
+ * @param[in]	mcfuncs		message class handler functions
+ */
+void
+bfa_ioc_mbox_register(struct bfa_ioc_s *ioc, bfa_ioc_mbox_mcfunc_t *mcfuncs)
+{
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	int				mc;
+
+	for (mc = 0; mc < BFI_MC_MAX; mc++)
+		mod->mbhdlr[ mc ].cbfn = mcfuncs[mc];
+}
+
+/**
+ * Register mailbox message handler function, to be called by common modules
+ */
+void
+bfa_ioc_mbox_regisr(struct bfa_ioc_s *ioc, enum bfi_mclass mc,
+		    bfa_ioc_mbox_mcfunc_t cbfn, void *cbarg)
+{
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+
+	mod->mbhdlr[ mc ].cbfn  = cbfn;
+	mod->mbhdlr[ mc ].cbarg = cbarg;
+}
+
+/**
+ * Queue a mailbox command request to firmware. Waits if mailbox is busy.
+ * Responsibility of caller to serialize 
+ *
+ * @param[in]	ioc	IOC instance
+ * @param[i]	cmd	Mailbox command
+ */
+void
+bfa_ioc_mbox_queue(struct bfa_ioc_s *ioc, struct bfa_mbox_cmd_s *cmd)
+{
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	u32			stat;
+
+	/**
+	 * If a previous command is pending, queue new command
+	 */
+	if (!list_empty(&mod->cmd_q)) {
+		list_add_tail(&cmd->qe, &mod->cmd_q);
+		return;
+	}
+
+	/**
+	 * If mailbox is busy, queue command for poll timer
+	 */
+	stat = bfa_reg_read(ioc->ioc_regs.hfn_mbox_cmd);
+	if (stat) {
+		list_add_tail(&cmd->qe, &mod->cmd_q);
+		return;
+	}
+
+	/**
+	 * mailbox is free -- queue command to firmware
+	 */
+	bfa_ioc_mbox_send(ioc, cmd->msg, sizeof(cmd->msg));
+}
+
+/**
+ * Handle mailbox interrupts
+ */
+void
+bfa_ioc_mbox_isr(struct bfa_ioc_s *ioc)
+{
+	struct bfa_ioc_mbox_mod_s	*mod = &ioc->mbox_mod;
+	struct bfi_mbmsg_s		m;
+	int				mc;
+
+	/* FCS_BRINGUP*/
+	printk("function: %s, Line %d \n",__FUNCTION__, __LINE__);
+	bfa_ioc_msgget(ioc, &m);
+	bfa_trc(ioc->bfa, ((u32 *)&m)[0]);
+
+	/**
+	 * Treat IOC message class as special.
+	 */
+	mc = m.mh.msg_class;
+	if (mc == BFI_MC_IOC) {
+		/* FCS_BRINGUP*/
+		printk("function: %s, Line %d mc %d \n",__FUNCTION__, __LINE__, mc);
+		bfa_ioc_isr(ioc, &m);
+		return;
+	}
+
+	if ((mc > BFI_MC_MAX) || (mod->mbhdlr[ mc ].cbfn == NULL)) {
+		bfa_assert(0);
+		bfa_trc_stop(ioc->trcmod);
+		return;
+	}
+
+	mod->mbhdlr[mc].cbfn(mod->mbhdlr[mc].cbarg, &m);
+	/* FCS_BRINGUP*/
+	printk("returning function: %s, Line %d \n",__FUNCTION__, __LINE__);
+}
+
+#ifndef BFA_BIOS_BUILD
+
+/**
+ * Add to IOC heartbeat failure notification queue. To be used by common
+ * modules such as 
+ */
+void
+bfa_ioc_hbfail_register(struct bfa_ioc_s *ioc,
+		struct bfa_ioc_hbfail_notify_s *notify)
+{
+	list_add_tail(&notify->qe, &ioc->hb_notify_q);
+}
+
+#define BFA_MFG_NAME "Brocade"
+void
+bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
+			 struct bfa_adapter_attr_s *ad_attr)
+{
+	struct bfi_ioc_attr_s	*ioc_attr;
+	char			model[BFA_ADAPTER_MODEL_NAME_LEN];
+
+	ioc_attr = ioc->attr;
+	bfa_os_memcpy((void *)&ad_attr->serial_num,
+		      (void *)ioc_attr->brcd_serialnum,
+		      BFA_ADAPTER_SERIAL_NUM_LEN);
+
+	bfa_os_memcpy(&ad_attr->fw_ver, ioc_attr->fw_version, BFA_VERSION_LEN);
+	bfa_os_memcpy(&ad_attr->optrom_ver, ioc_attr->optrom_version,
+		      BFA_VERSION_LEN);
+	bfa_os_memcpy(&ad_attr->manufacturer, BFA_MFG_NAME,
+		      BFA_ADAPTER_MFG_NAME_LEN);
+	bfa_os_memcpy(&ad_attr->vpd, &ioc_attr->vpd,
+		      sizeof(struct bfa_mfg_vpd_s));
+
+	ad_attr->nports = BFI_ADAPTER_GETP(NPORTS, ioc_attr->adapter_prop);
+	ad_attr->max_speed = BFI_ADAPTER_GETP(SPEED, ioc_attr->adapter_prop);
+
+	/**
+	 * model name
+	 */
+	if (BFI_ADAPTER_GETP(SPEED, ioc_attr->adapter_prop) == 10) {
+		strcpy(model, "BR-10?0");
+		model[5] = '0' + ad_attr->nports;
+	} else {
+		strcpy(model, "Brocade-??5");
+		model[8] = '0' +
+			BFI_ADAPTER_GETP(SPEED,
+					 ioc_attr->adapter_prop);
+		model[9] = '0' + ad_attr->nports;
+	}
+
+	if (BFI_ADAPTER_IS_SPECIAL(ioc_attr->adapter_prop))
+		ad_attr->prototype = 1;
+	else
+		ad_attr->prototype = 0;
+
+	bfa_os_memcpy(&ad_attr->model, model, BFA_ADAPTER_MODEL_NAME_LEN);
+	bfa_os_memcpy(&ad_attr->model_descr, &ad_attr->model,
+		      BFA_ADAPTER_MODEL_NAME_LEN);
+
+	ad_attr->pwwn = bfa_ioc_get_pwwn(ioc);
+	ad_attr->mac  = bfa_ioc_get_mac(ioc);
+
+	ad_attr->pcie_gen = ioc_attr->pcie_gen;
+	ad_attr->pcie_lanes = ioc_attr->pcie_lanes;
+	ad_attr->pcie_lanes_orig = ioc_attr->pcie_lanes_orig;
+	ad_attr->asic_rev = ioc_attr->asic_rev;
+	ad_attr->hw_ver[0] = 'R';
+	ad_attr->hw_ver[1] = 'e';
+	ad_attr->hw_ver[2] = 'v';
+	ad_attr->hw_ver[3] = '-';
+	ad_attr->hw_ver[4] = ioc_attr->asic_rev;
+	ad_attr->hw_ver[5] = '\0';
+
+}
+
+void
+bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr)
+{
+	bfa_os_memset((void *)ioc_attr, 0, sizeof(struct bfa_ioc_attr_s));
+
+	ioc_attr->state = bfa_sm_to_state(ioc_sm_table, ioc->fsm);
+	ioc_attr->port_id = ioc->port_id;
+
+	bfa_ioc_get_adapter_attr(ioc, &ioc_attr->adapter_attr);
+
+	ioc_attr->pci_attr.chip_rev[0] = 'R';
+	ioc_attr->pci_attr.chip_rev[1] = 'e';
+	ioc_attr->pci_attr.chip_rev[2] = 'v';
+	ioc_attr->pci_attr.chip_rev[3] = '-';
+	ioc_attr->pci_attr.chip_rev[4] = ioc_attr->adapter_attr.asic_rev;
+	ioc_attr->pci_attr.chip_rev[5] = '\0';
+}
+
+/**
+ *  hal_wwn_public
+ */
+wwn_t
+bfa_ioc_get_pwwn(struct bfa_ioc_s *ioc)
+{
+	union {
+		wwn_t	wwn;
+		u8	byte[sizeof(wwn_t)];
+	} w;
+
+	w.wwn = ioc->attr->mfg_wwn;
+
+	if (bfa_ioc_portid(ioc) == 1)
+		w.byte[7]++;
+
+	return w.wwn;
+}
+
+wwn_t
+bfa_ioc_get_nwwn(struct bfa_ioc_s *ioc)
+{
+	union {
+		wwn_t	wwn;
+		u8	byte[sizeof(wwn_t)];
+	} w;
+
+	w.wwn = ioc->attr->mfg_wwn;
+
+	if (bfa_ioc_portid(ioc) == 1)
+		w.byte[7]++;
+
+	w.byte[0] = 0x20;
+
+	return w.wwn;
+}
+
+wwn_t
+bfa_ioc_get_wwn_naa5(struct bfa_ioc_s *ioc, u16 inst)
+{
+	union {
+		wwn_t           wwn;
+		u8         byte[sizeof(wwn_t)];
+	} w, w5;
+
+	bfa_trc(ioc, inst);
+
+	w.wwn = ioc->attr->mfg_wwn;
+	w5.byte[0] = 0x50 | w.byte[2] >> 4;
+	w5.byte[1] = w.byte[2] << 4 | w.byte[3] >> 4;
+	w5.byte[2] = w.byte[3] << 4 | w.byte[4] >> 4;
+	w5.byte[3] = w.byte[4] << 4 | w.byte[5] >> 4;
+	w5.byte[4] = w.byte[5] << 4 | w.byte[6] >> 4;
+	w5.byte[5] = w.byte[6] << 4 | w.byte[7] >> 4;
+	w5.byte[6] = w.byte[7] << 4 | (inst & 0x0f00) >> 8;
+	w5.byte[7] = (inst & 0xff);
+
+	return w5.wwn;
+}
+
+u64
+bfa_ioc_get_adid(struct bfa_ioc_s *ioc)
+{
+	return ioc->attr->mfg_wwn;
+}
+
+mac_t
+bfa_ioc_get_mac(struct bfa_ioc_s *ioc)
+{
+	mac_t	mac;
+
+	mac = ioc->attr->mfg_mac;
+	mac.mac[MAC_ADDRLEN - 1] += bfa_ioc_pcifn(ioc);
+
+	return mac;
+}
+
+void
+bfa_ioc_set_fcmode(struct bfa_ioc_s *ioc)
+{
+	ioc->fcmode  = BFA_TRUE;
+	ioc->port_id = bfa_ioc_pcifn(ioc);
+}
+
+bfa_boolean_t
+bfa_ioc_get_fcmode(struct bfa_ioc_s *ioc)
+{
+	return ioc->fcmode || (ioc->pcidev.device_id != BFA_PCI_DEVICE_ID_CT);
+}
+
+/**
+ * Send AEN notification
+ */
+static void
+bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
+{
+	union bfa_aen_data_u  aen_data;
+	struct bfa_log_mod_s *logmod = ioc->logm;
+	s32	inst_num = 0;
+
+	switch (event) {
+	case BFA_IOC_AEN_HBGOOD:
+		bfa_log(logmod, BFA_AEN_IOC_HBGOOD, inst_num);
+		break;
+	case BFA_IOC_AEN_HBFAIL:
+		bfa_log(logmod, BFA_AEN_IOC_HBFAIL, inst_num);
+		break;
+	case BFA_IOC_AEN_ENABLE:
+		bfa_log(logmod, BFA_AEN_IOC_ENABLE, inst_num);
+		break;
+	case BFA_IOC_AEN_DISABLE:
+		bfa_log(logmod, BFA_AEN_IOC_DISABLE, inst_num);
+		break;
+	default:
+		break;
+	}
+
+	aen_data.ioc.pwwn = bfa_ioc_get_pwwn(ioc);
+	aen_data.ioc.mac = bfa_ioc_get_mac(ioc);
+}
+
+/**
+ * Retrieve saved firmware trace from a prior IOC failure.
+ */
+bfa_status_t
+bfa_ioc_debug_fwsave(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
+{
+	int	tlen;
+
+	if (ioc->dbg_fwsave_len == 0)
+		return BFA_STATUS_ENOFSAVE;
+
+	tlen = *trclen;
+	if (tlen > ioc->dbg_fwsave_len)
+		tlen = ioc->dbg_fwsave_len;
+
+	bfa_os_memcpy(trcdata, ioc->dbg_fwsave, tlen);
+	*trclen = tlen;
+	return BFA_STATUS_OK;
+}
+
+/**
+ * Retrieve saved firmware trace from a prior IOC failure.
+ */
+bfa_status_t
+bfa_ioc_debug_fwtrc(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
+{
+	u32        pgnum;
+	u32        loff = BFA_DBG_FWTRC_OFF(bfa_ioc_portid(ioc));
+	int             i, tlen;
+	u32       *tbuf = trcdata, r32;
+
+	bfa_trc(ioc, *trclen);
+
+	pgnum = bfa_ioc_smem_pgnum(ioc, loff);
+	loff = bfa_ioc_smem_pgoff(ioc, loff);
+	bfa_reg_write(ioc->ioc_regs.host_page_num_fn, pgnum);
+
+	tlen = *trclen;
+	if (tlen > BFA_DBG_FWTRC_LEN)
+		tlen = BFA_DBG_FWTRC_LEN;
+	tlen /= sizeof(u32);
+
+	bfa_trc(ioc, tlen);
+
+	for (i = 0; i < tlen; i++) {
+		r32 = bfa_mem_read(ioc->ioc_regs.smem_page_start, loff);
+		tbuf[i] = bfa_os_ntohl(r32);
+		loff += sizeof(u32);
+
+		/**
+		 * handle page offset wrap around
+		 */
+		loff = PSS_SMEM_PGOFF(loff);
+		if (loff == 0) {
+			pgnum++;
+			bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
+				      pgnum);
+		}
+	}
+	bfa_reg_write(ioc->ioc_regs.host_page_num_fn,
+		      bfa_ioc_smem_pgnum(ioc, 0));
+	bfa_trc(ioc, pgnum);
+
+	*trclen = tlen * sizeof(u32);
+	return BFA_STATUS_OK;
+}
+
+/**
+ * Save firmware trace if configured.
+ */
+static void
+bfa_ioc_debug_save(struct bfa_ioc_s *ioc)
+{
+	int		tlen;
+
+	if (ioc->dbg_fwsave_len) {
+		tlen = ioc->dbg_fwsave_len;
+		bfa_ioc_debug_fwtrc(ioc, ioc->dbg_fwsave, &tlen);
+	}
+}
+
+/**
+ * Firmware failure detected. Start recovery actions.
+ */
+static void
+bfa_ioc_recover(struct bfa_ioc_s *ioc)
+{
+	bfa_ioc_stats(ioc, ioc_hbfails);
+	bfa_ioc_debug_save(ioc);
+	bfa_fsm_send_event(ioc, IOC_E_HBFAIL);
+}
+#else
+static void
+bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
+{ }
+
+static void
+bfa_ioc_recover(struct bfa_ioc_s *ioc)
+{ }
+#endif
+
diff -urpN orig/drivers/scsi/bfa/bfa_iocfc.c patch/drivers/scsi/bfa/bfa_iocfc.c
--- orig/drivers/scsi/bfa/bfa_iocfc.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_iocfc.c	2009-03-14 11:44:57.140708000 -0700
@@ -0,0 +1,831 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <cs/bfa_debug.h>
+#include <bfa_priv.h>
+#include <log/bfa_log_hal.h>
+#include <bfi/bfi_boot.h>
+#include <bfi/bfi_cbreg.h>
+#include <aen/bfa_aen_ioc.h>
+#include <defs/bfa_defs_iocfc.h>
+#include <defs/bfa_defs_pci.h>
+#include "bfa_callback_priv.h"
+
+BFA_TRC_FILE(HAL, IOCFC);
+
+/**
+ * IOC local definitions
+ */
+#define BFA_IOCFC_TOV		5000	/* msecs */
+
+enum {
+	BFA_IOCFC_ACT_NONE	= 0,
+	BFA_IOCFC_ACT_INIT	= 1,
+	BFA_IOCFC_ACT_STOP	= 2,
+	BFA_IOCFC_ACT_DISABLE	= 3,
+};
+
+/*
+ * forward declarations
+ */
+static void bfa_iocfc_enable_cbfn(void *bfa_arg, enum bfa_status status);
+static void bfa_iocfc_disable_cbfn(void *bfa_arg);
+static void bfa_iocfc_hbfail_cbfn(void *bfa_arg);
+static void bfa_iocfc_reset_cbfn(void *bfa_arg);
+static void bfa_iocfc_stats_clear(void *bfa_arg);
+static void bfa_iocfc_stats_swap(struct bfa_fw_stats_s *d,
+			struct bfa_fw_stats_s *s);
+static void bfa_iocfc_stats_clr_cb(void *bfa_arg, bfa_boolean_t complete);
+static void bfa_iocfc_stats_clr_timeout(void *bfa_arg);
+static void bfa_iocfc_stats_cb(void *bfa_arg, bfa_boolean_t complete);
+static void bfa_iocfc_stats_timeout(void *bfa_arg);
+
+static struct bfa_ioc_cbfn_s bfa_iocfc_cbfn;
+
+/**
+ *  hal_ioc_pvt BFA IOC private functions
+ */
+
+static void
+bfa_iocfc_cqs_sz(struct bfa_iocfc_cfg_s *cfg, u32 *dm_len)
+{
+	int             i, per_reqq_sz, per_rspq_sz;
+
+	per_reqq_sz = BFA_ROUNDUP((cfg->drvcfg.num_reqq_elems * BFI_LMSG_SZ),
+							BFA_DMA_ALIGN_SZ);
+	per_rspq_sz = BFA_ROUNDUP((cfg->drvcfg.num_rspq_elems * BFI_LMSG_SZ),
+							BFA_DMA_ALIGN_SZ);
+
+	/*
+	 * Calculate CQ size
+	 */
+	for (i = 0; i < cfg->fwcfg.num_cqs; i++) {
+		*dm_len = *dm_len + per_reqq_sz;
+		*dm_len = *dm_len + per_rspq_sz;
+	}
+
+	/*
+	 * Calculate Shadow CI/PI size
+	 */
+	for (i = 0; i < cfg->fwcfg.num_cqs; i++)
+		*dm_len += (2 * BFA_CACHELINE_SZ);
+}
+
+static void
+bfa_iocfc_fw_cfg_sz(struct bfa_iocfc_cfg_s *cfg, u32 *dm_len)
+{
+	*dm_len +=
+		BFA_ROUNDUP(sizeof(struct bfi_iocfc_cfg_s), BFA_CACHELINE_SZ);
+	*dm_len +=
+		BFA_ROUNDUP(sizeof(struct bfi_iocfc_cfgrsp_s),
+			    BFA_CACHELINE_SZ);
+	*dm_len += BFA_ROUNDUP(sizeof(struct bfa_fw_stats_s), BFA_CACHELINE_SZ);
+}
+
+/**
+ * Use the Mailbox interface to send BFI_IOCFC_H2I_CFG_REQ
+ */
+static void
+bfa_iocfc_send_cfg(void *bfa_arg)
+{
+	struct bfa_s *bfa = bfa_arg;
+	struct bfa_iocfc_s *iocfc = &bfa->iocfc;
+	struct bfi_iocfc_cfg_req_s cfg_req;
+	struct bfi_iocfc_cfg_s *cfg_info = iocfc->cfginfo;
+	struct bfa_iocfc_cfg_s  *cfg = &iocfc->cfg;
+	int             i;
+
+	bfa_assert(cfg->fwcfg.num_cqs <= BFI_IOC_MAX_CQS);
+	bfa_trc(bfa, cfg->fwcfg.num_cqs);
+
+	iocfc->cfgdone = BFA_FALSE;
+
+	/**
+	 * initialize IOC configuration info
+	 */
+	cfg_info->endian_sig = BFI_IOC_ENDIAN_SIG;
+	cfg_info->num_cqs = cfg->fwcfg.num_cqs;
+
+	cfg_info->rport_del_tov = cfg->drvcfg.rport_del_tov;
+	cfg_info->fw_disc_enabled = cfg->drvcfg.fw_disc_enabled;
+	cfg_info->bport_role = cfg->drvcfg.bport_role;
+	strncpy(cfg_info->bport_sym_name, bfa_sym_name(bfa), BFA_SYMNAME_MAXLEN);
+
+	bfa_dma_be_addr_set(cfg_info->cfgrsp_addr, iocfc->cfgrsp_dma.pa);
+	bfa_dma_be_addr_set(cfg_info->stats_addr, iocfc->stats_pa);
+
+	/**
+	 * dma map REQ and RSP circular queues and shadow pointers
+	 */
+	for (i = 0; i < cfg->fwcfg.num_cqs; i++) {
+		bfa_dma_be_addr_set(cfg_info->req_cq_ba[i],
+				       iocfc->req_cq_ba[i].pa);
+		bfa_dma_be_addr_set(cfg_info->req_shadow_ci[i],
+				       iocfc->req_cq_shadow_ci[i].pa);
+		cfg_info->req_cq_elems[i] =
+			bfa_os_htons(cfg->drvcfg.num_reqq_elems);
+
+		bfa_dma_be_addr_set(cfg_info->rsp_cq_ba[i],
+				       iocfc->rsp_cq_ba[i].pa);
+		bfa_dma_be_addr_set(cfg_info->rsp_shadow_pi[i],
+				       iocfc->rsp_cq_shadow_pi[i].pa);
+		cfg_info->rsp_cq_elems[i] =
+			bfa_os_htons(cfg->drvcfg.num_rspq_elems);
+	}
+
+	/**
+	 * dma map IOC configuration itself
+	 */
+	bfi_h2i_set(cfg_req.mh, BFI_MC_IOCFC, BFI_IOCFC_H2I_CFG_REQ,
+			bfa_lpuid(bfa));
+	bfa_dma_be_addr_set(cfg_req.ioc_cfg_dma_addr, iocfc->cfg_info.pa);
+
+	bfa_ioc_mbox_send(&bfa->ioc, &cfg_req,
+			sizeof(struct bfi_iocfc_cfg_req_s));
+}
+
+static void
+bfa_iocfc_init_mem(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		    struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+
+	bfa->bfad = bfad;
+	iocfc->bfa = bfa;
+	iocfc->action = BFA_IOCFC_ACT_NONE;
+
+	iocfc->cfg = *cfg;
+
+	/**
+	 * Initialize chip specific handlers.
+	 */
+	if (bfa_ioc_devid(&bfa->ioc) == BFA_PCI_DEVICE_ID_CT) {
+		iocfc->hwif.hw_reginit = bfa_hwct_reginit;
+		iocfc->hwif.hw_rspq_ack = bfa_hwct_rspq_ack;
+	} else {
+		iocfc->hwif.hw_reginit = bfa_hwcb_reginit;
+		iocfc->hwif.hw_rspq_ack = bfa_hwcb_rspq_ack;
+	}
+
+	iocfc->hwif.hw_reginit(bfa);
+}
+
+static void
+bfa_iocfc_mem_claim(struct bfa_s *bfa, struct bfa_iocfc_cfg_s *cfg,
+		      struct bfa_meminfo_s *meminfo)
+{
+	u8        *dm_kva;
+	u64        dm_pa;
+	int             i, per_reqq_sz, per_rspq_sz;
+	struct bfa_iocfc_s  *iocfc = &bfa->iocfc;
+	int		dbgsz;
+
+	dm_kva = bfa_meminfo_dma_virt(meminfo);
+	dm_pa = bfa_meminfo_dma_phys(meminfo);
+
+	/*
+	 * First allocate dma memory for IOC.
+	 */
+	bfa_ioc_mem_claim(&bfa->ioc, dm_kva, dm_pa);
+	dm_kva += bfa_ioc_meminfo();
+	dm_pa  += bfa_ioc_meminfo();
+
+	/*
+	 * Claim DMA-able memory for the request/response queues and for shadow
+	 * ci/pi registers
+	 */
+	per_reqq_sz = BFA_ROUNDUP((cfg->drvcfg.num_reqq_elems * BFI_LMSG_SZ),
+							BFA_DMA_ALIGN_SZ);
+	per_rspq_sz = BFA_ROUNDUP((cfg->drvcfg.num_rspq_elems * BFI_LMSG_SZ),
+							BFA_DMA_ALIGN_SZ);
+
+	for (i = 0; i < cfg->fwcfg.num_cqs; i++) {
+		iocfc->req_cq_ba[i].kva = dm_kva;
+		iocfc->req_cq_ba[i].pa = dm_pa;
+		bfa_os_memset(dm_kva, 0, per_reqq_sz);
+		dm_kva += per_reqq_sz;
+		dm_pa += per_reqq_sz;
+
+		iocfc->rsp_cq_ba[i].kva = dm_kva;
+		iocfc->rsp_cq_ba[i].pa = dm_pa;
+		bfa_os_memset(dm_kva, 0, per_rspq_sz);
+		dm_kva += per_rspq_sz;
+		dm_pa += per_rspq_sz;
+	}
+
+	for (i = 0; i < cfg->fwcfg.num_cqs; i++) {
+		iocfc->req_cq_shadow_ci[i].kva = dm_kva;
+		iocfc->req_cq_shadow_ci[i].pa = dm_pa;
+		dm_kva += BFA_CACHELINE_SZ;
+		dm_pa += BFA_CACHELINE_SZ;
+
+		iocfc->rsp_cq_shadow_pi[i].kva = dm_kva;
+		iocfc->rsp_cq_shadow_pi[i].pa = dm_pa;
+		dm_kva += BFA_CACHELINE_SZ;
+		dm_pa += BFA_CACHELINE_SZ;
+	}
+
+	/*
+	 * Claim DMA-able memory for the config info page
+	 */
+	bfa->iocfc.cfg_info.kva = dm_kva;
+	bfa->iocfc.cfg_info.pa = dm_pa;
+	bfa->iocfc.cfginfo = (struct bfi_iocfc_cfg_s *) dm_kva;
+	dm_kva += BFA_ROUNDUP(sizeof(struct bfi_iocfc_cfg_s), BFA_CACHELINE_SZ);
+	dm_pa += BFA_ROUNDUP(sizeof(struct bfi_iocfc_cfg_s), BFA_CACHELINE_SZ);
+
+	/*
+	 * Claim DMA-able memory for the config response
+	 */
+	bfa->iocfc.cfgrsp_dma.kva = dm_kva;
+	bfa->iocfc.cfgrsp_dma.pa = dm_pa;
+	bfa->iocfc.cfgrsp = (struct bfi_iocfc_cfgrsp_s *) dm_kva;
+
+	dm_kva +=
+		BFA_ROUNDUP(sizeof(struct bfi_iocfc_cfgrsp_s),
+			    BFA_CACHELINE_SZ);
+	dm_pa += BFA_ROUNDUP(sizeof(struct bfi_iocfc_cfgrsp_s),
+			     BFA_CACHELINE_SZ);
+
+	/*
+	 * Claim DMA-able memory for iocfc stats
+	 */
+	bfa->iocfc.stats_kva = dm_kva;
+	bfa->iocfc.stats_pa = dm_pa;
+	bfa->iocfc.fw_stats = (struct bfa_fw_stats_s *) dm_kva;
+	dm_kva += BFA_ROUNDUP(sizeof(struct bfa_fw_stats_s), BFA_CACHELINE_SZ);
+	dm_pa += BFA_ROUNDUP(sizeof(struct bfa_fw_stats_s), BFA_CACHELINE_SZ);
+
+	bfa_meminfo_dma_virt(meminfo) = dm_kva;
+	bfa_meminfo_dma_phys(meminfo) = dm_pa;
+
+	dbgsz = bfa_ioc_debug_trcsz(bfa_auto_recover);
+	if (dbgsz > 0) {
+		bfa_ioc_debug_memclaim(&bfa->ioc, bfa_meminfo_kva(meminfo));
+		bfa_meminfo_kva(meminfo) += dbgsz;
+	}
+}
+
+/**
+ * BFA submodules initialization completion notification.
+ */
+static void
+bfa_iocfc_initdone_submod(struct bfa_s *bfa)
+{
+	int             i;
+
+	for (i = 0; hal_mods[i]; i++)
+		hal_mods[i]->initdone(bfa);
+}
+
+/**
+ * Start BFA submodules.
+ */
+static void
+bfa_iocfc_start_submod(struct bfa_s *bfa)
+{
+	int             i;
+
+	for (i = 0; hal_mods[i]; i++)
+		hal_mods[i]->start(bfa);
+}
+
+/**
+ * Disable BFA submodules.
+ */
+static void
+bfa_iocfc_disable_submod(struct bfa_s *bfa)
+{
+	int             i;
+
+	for (i = 0; hal_mods[i]; i++)
+		hal_mods[i]->iocdisable(bfa);
+}
+
+static void
+bfa_iocfc_init_cb(void *bfa_arg, bfa_boolean_t complete)
+{
+	struct bfa_s	*bfa = bfa_arg;
+
+	if (complete) {
+		if (bfa->iocfc.cfgdone)
+			bfa_cb_init(bfa->bfad, BFA_STATUS_OK);
+		else
+			bfa_cb_init(bfa->bfad, BFA_STATUS_FAILED);
+	} else
+		bfa->iocfc.action = BFA_IOCFC_ACT_NONE;
+}
+
+static void
+bfa_iocfc_stop_cb(void *bfa_arg, bfa_boolean_t complete)
+{
+	struct bfa_s  *bfa = bfa_arg;
+
+	if (complete)
+		bfa_cb_stop(bfa->bfad, BFA_STATUS_OK);
+	else
+		bfa->iocfc.action = BFA_IOCFC_ACT_NONE;
+}
+
+static void
+bfa_iocfc_disable_cb(void *bfa_arg, bfa_boolean_t complete)
+{
+	struct bfa_s  *bfa = bfa_arg;
+
+	if (complete)
+		bfa_cb_ioc_disable(bfa->bfad);
+}
+
+/**
+ * Update BFA configuration from firmware configuration.
+ */
+static void
+bfa_iocfc_cfgrsp(struct bfa_s *bfa)
+{
+	struct bfa_iocfc_s		*iocfc	 = &bfa->iocfc;
+	struct bfi_iocfc_cfgrsp_s	*cfgrsp  = iocfc->cfgrsp;
+	struct bfa_iocfc_fwcfg_s	*fwcfg   = &cfgrsp->fwcfg;
+	struct bfi_iocfc_cfg_s 		*cfginfo = iocfc->cfginfo;
+
+	fwcfg->num_cqs        = fwcfg->num_cqs;
+	fwcfg->num_ioim_reqs  = bfa_os_ntohs(fwcfg->num_ioim_reqs);
+	fwcfg->num_tskim_reqs = bfa_os_ntohs(fwcfg->num_tskim_reqs);
+	fwcfg->num_fcxp_reqs  = bfa_os_ntohs(fwcfg->num_fcxp_reqs);
+	fwcfg->num_uf_bufs    = bfa_os_ntohs(fwcfg->num_uf_bufs);
+	fwcfg->num_rports     = bfa_os_ntohs(fwcfg->num_rports);
+
+	cfginfo->intr_attr.coalesce = cfgrsp->intr_attr.coalesce;
+	cfginfo->intr_attr.delay    = bfa_os_ntohs(cfgrsp->intr_attr.delay);
+	cfginfo->intr_attr.latency  = bfa_os_ntohs(cfgrsp->intr_attr.latency);
+
+	iocfc->cfgdone = BFA_TRUE;
+
+	/**
+	 * Configuration is complete - initialize/start submodules
+	 */
+	if (iocfc->action == BFA_IOCFC_ACT_INIT)
+		bfa_cb_queue(bfa, &iocfc->init_hcb_qe, bfa_iocfc_init_cb, bfa);
+	else
+		bfa_iocfc_start_submod(bfa);
+}
+
+static void
+bfa_iocfc_stats_clear(void *bfa_arg)
+{
+	struct bfa_s		*bfa = bfa_arg;
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+	struct bfi_iocfc_stats_req_s stats_req;
+
+	bfa_timer_start(bfa, &iocfc->stats_timer,
+			    bfa_iocfc_stats_clr_timeout, bfa,
+			    BFA_IOCFC_TOV);
+
+	bfi_h2i_set(stats_req.mh, BFI_MC_IOCFC, BFI_IOCFC_H2I_CLEAR_STATS_REQ,
+		bfa_lpuid(bfa));
+	bfa_ioc_mbox_send(&bfa->ioc, &stats_req,
+		sizeof(struct bfi_iocfc_stats_req_s));
+}
+
+static void
+bfa_iocfc_stats_swap(struct bfa_fw_stats_s *d, struct bfa_fw_stats_s *s)
+{
+	u32       *dip = (u32 *) d;
+	u32       *sip = (u32 *) s;
+	int             i;
+
+	for (i = 0; i < (sizeof(struct bfa_fw_stats_s) / sizeof(u32)); i++)
+		dip[i] = bfa_os_ntohl(sip[i]);
+}
+
+static void
+bfa_iocfc_stats_clr_cb(void *bfa_arg, bfa_boolean_t complete)
+{
+	struct bfa_s *bfa = bfa_arg;
+	struct bfa_iocfc_s *iocfc = &bfa->iocfc;
+
+	if (complete) {
+		bfa_ioc_clr_stats(&bfa->ioc);
+		iocfc->stats_cbfn(iocfc->stats_cbarg, iocfc->stats_status);
+	} else {
+		iocfc->stats_busy = BFA_FALSE;
+		iocfc->stats_status = BFA_STATUS_OK;
+	}
+}
+
+static void
+bfa_iocfc_stats_clr_timeout(void *bfa_arg)
+{
+	struct bfa_s		*bfa = bfa_arg;
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+
+	bfa_trc(bfa, 0);
+
+	iocfc->stats_status = BFA_STATUS_ETIMER;
+	bfa_cb_queue(bfa, &iocfc->stats_hcb_qe, bfa_iocfc_stats_clr_cb, bfa);
+}
+
+static void
+bfa_iocfc_stats_cb(void *bfa_arg, bfa_boolean_t complete)
+{
+	struct bfa_s		*bfa = bfa_arg;
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+
+	if (complete) {
+		if (iocfc->stats_status == BFA_STATUS_OK) {
+			bfa_os_memset(iocfc->stats_ret, 0,
+				sizeof(*iocfc->stats_ret));
+			bfa_iocfc_stats_swap(&iocfc->stats_ret->fw_stats,
+				iocfc->fw_stats);
+		}
+		iocfc->stats_cbfn(iocfc->stats_cbarg, iocfc->stats_status);
+	} else {
+		iocfc->stats_busy = BFA_FALSE;
+		iocfc->stats_status = BFA_STATUS_OK;
+	}
+}
+
+static void
+bfa_iocfc_stats_timeout(void *bfa_arg)
+{
+	struct bfa_s		*bfa = bfa_arg;
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+
+	bfa_trc(bfa, 0);
+
+	iocfc->stats_status = BFA_STATUS_ETIMER;
+	bfa_cb_queue(bfa, &iocfc->stats_hcb_qe, bfa_iocfc_stats_cb, bfa);
+}
+
+static void
+bfa_iocfc_stats_query(struct bfa_s *bfa)
+{
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+	struct bfi_iocfc_stats_req_s stats_req;
+
+	bfa_timer_start(bfa, &iocfc->stats_timer,
+			    bfa_iocfc_stats_timeout, bfa, BFA_IOCFC_TOV);
+
+	bfi_h2i_set(stats_req.mh, BFI_MC_IOCFC, BFI_IOCFC_H2I_GET_STATS_REQ,
+			bfa_lpuid(bfa));
+	bfa_ioc_mbox_send(&bfa->ioc, &stats_req,
+		sizeof(struct bfi_iocfc_stats_req_s));
+}
+
+static void
+bfa_iocfc_reset_queues(struct bfa_s *bfa)
+{
+	int	q;
+
+	for (q = 0; q < BFI_IOC_MAX_CQS; q++) {
+		bfa_rspq_ci(bfa, q) = 0;
+		bfa_reqq_pi(bfa, q) = 0;
+	}
+}
+
+/**
+ * IOC enable request is complete
+ */
+static void
+bfa_iocfc_enable_cbfn(void *bfa_arg, enum bfa_status status)
+{
+	struct bfa_s	*bfa = bfa_arg;
+
+	if ((status != BFA_STATUS_OK) &&
+	    (bfa->iocfc.action == BFA_IOCFC_ACT_INIT)) {
+		bfa_cb_queue(bfa, &bfa->iocfc.init_hcb_qe, bfa_iocfc_init_cb,
+			     bfa);
+		return;
+	}
+
+	bfa_iocfc_initdone_submod(bfa);
+	bfa_iocfc_send_cfg(bfa);
+}
+
+/**
+ * IOC disable request is complete
+ */
+static void
+bfa_iocfc_disable_cbfn(void *bfa_arg)
+{
+	struct bfa_s	*bfa = bfa_arg;
+
+	bfa_isr_disable(bfa);
+	bfa_iocfc_disable_submod(bfa);
+
+	if (bfa->iocfc.action == BFA_IOCFC_ACT_STOP)
+		bfa_cb_queue(bfa, &bfa->iocfc.stop_hcb_qe, bfa_iocfc_stop_cb,
+			     bfa);
+	else {
+		bfa_assert(bfa->iocfc.action == BFA_IOCFC_ACT_DISABLE);
+		bfa_cb_queue(bfa, &bfa->iocfc.dis_hcb_qe, bfa_iocfc_disable_cb,
+			     bfa);
+	}
+}
+
+/**
+ * Notify sub-modules of hardware failure.
+ */
+static void
+bfa_iocfc_hbfail_cbfn(void *bfa_arg)
+{
+	struct bfa_s	*bfa = bfa_arg;
+
+	bfa_iocfc_disable_submod(bfa);
+
+	if (bfa->iocfc.action == BFA_IOCFC_ACT_INIT)
+		bfa_cb_queue(bfa, &bfa->iocfc.init_hcb_qe, bfa_iocfc_init_cb,
+			     bfa);
+}
+
+/**
+ * Actions on chip-reset completion.
+ */
+static void
+bfa_iocfc_reset_cbfn(void *bfa_arg)
+{
+	struct bfa_s	*bfa = bfa_arg;
+
+	bfa_iocfc_reset_queues(bfa);
+	bfa_isr_enable(bfa);
+}
+
+
+
+/**
+ *  hal_ioc_public
+ */
+
+void
+bfa_iocfc_set_snsbase(struct bfa_s *bfa, u64 snsbase_pa)
+{
+	struct bfa_iocfc_s      *iocfc = &bfa->iocfc;
+
+	iocfc->cfginfo->sense_buf_len = (BFI_IOIM_SNSLEN - 1);
+	bfa_dma_be_addr_set(iocfc->cfginfo->ioim_snsbase, snsbase_pa);
+}
+
+bfa_status_t
+bfa_iocfc_get_stats(struct bfa_s *bfa, struct bfa_iocfc_stats_s *stats,
+		      bfa_cb_ioc_t cbfn, void *cbarg)
+{
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+
+	if (iocfc->stats_busy) {
+		bfa_trc(bfa, iocfc->stats_busy);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	iocfc->stats_busy = BFA_TRUE;
+	iocfc->stats_ret = stats;
+	iocfc->stats_cbfn = cbfn;
+	iocfc->stats_cbarg = cbarg;
+
+	bfa_iocfc_stats_query(bfa);
+
+	return (BFA_STATUS_OK);
+}
+
+bfa_status_t
+bfa_iocfc_clear_stats(struct bfa_s *bfa, bfa_cb_ioc_t cbfn, void *cbarg)
+{
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+
+	if (iocfc->stats_busy) {
+		bfa_trc(bfa, iocfc->stats_busy);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	iocfc->stats_busy = BFA_TRUE;
+	iocfc->stats_cbfn = cbfn;
+	iocfc->stats_cbarg = cbarg;
+
+	bfa_iocfc_stats_clear(bfa);
+	return (BFA_STATUS_OK);
+}
+
+/**
+ * Query IOC memory requirement information.
+ */
+void
+bfa_iocfc_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+		u32 *dm_len)
+{
+	bfa_iocfc_fw_cfg_sz(cfg, dm_len);
+	bfa_iocfc_cqs_sz(cfg, dm_len);
+	*km_len += bfa_ioc_debug_trcsz(bfa_auto_recover);
+}
+
+/**
+ * Query IOC memory requirement information.
+ */
+void
+bfa_iocfc_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		   struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	int             i;
+
+	bfa_iocfc_cbfn.enable_cbfn = bfa_iocfc_enable_cbfn;
+	bfa_iocfc_cbfn.disable_cbfn = bfa_iocfc_disable_cbfn;
+	bfa_iocfc_cbfn.hbfail_cbfn = bfa_iocfc_hbfail_cbfn;
+	bfa_iocfc_cbfn.reset_cbfn = bfa_iocfc_reset_cbfn;
+
+	bfa_ioc_attach(&bfa->ioc, bfa, &bfa_iocfc_cbfn, &bfa->timer_mod,
+		bfa->trcmod, bfa->aen, bfa->logm);
+	bfa_ioc_pci_init(&bfa->ioc, pcidev, BFI_MC_IOCFC);
+	bfa_ioc_mbox_register(&bfa->ioc, bfa_mbox_isrs);
+
+	/**
+	 * Choose FC (ssid: 0x1C) v/s FCoE (ssid: 0x14) mode.
+	 */
+	if (0)
+		bfa_ioc_set_fcmode(&bfa->ioc);
+
+	bfa_iocfc_init_mem(bfa, bfad, cfg, pcidev);
+	bfa_iocfc_mem_claim(bfa, cfg, meminfo);
+	bfa_timer_init(&bfa->timer_mod);
+
+	INIT_LIST_HEAD(&bfa->comp_q);
+	for (i = 0; i < BFI_IOC_MAX_CQS; i++)
+		INIT_LIST_HEAD(&bfa->reqq_waitq[i]);
+}
+
+/**
+ * Query IOC memory requirement information.
+ */
+void
+bfa_iocfc_detach(struct bfa_s *bfa)
+{
+	/*
+	 * no-op
+	 */
+}
+
+/**
+ * Query IOC memory requirement information.
+ */
+void
+bfa_iocfc_init(struct bfa_s *bfa)
+{
+	bfa->iocfc.action = BFA_IOCFC_ACT_INIT;
+	bfa_ioc_enable(&bfa->ioc);
+}
+
+/**
+ * IOC start called from bfa_start(). Called to start IOC operations
+ * at driver instantiation for this instance.
+ */
+void
+bfa_iocfc_start(struct bfa_s *bfa)
+{
+	if (bfa->iocfc.cfgdone)
+		bfa_iocfc_start_submod(bfa);
+}
+
+/**
+ * IOC stop called from bfa_stop(). Called only when driver is unloaded
+ * for this instance.
+ */
+void
+bfa_iocfc_stop(struct bfa_s *bfa)
+{
+	bfa->iocfc.action = BFA_IOCFC_ACT_STOP;
+	bfa_ioc_disable(&bfa->ioc);
+}
+
+/**
+ * Enable IOC after it is disabled.
+ */
+bfa_status_t
+bfa_iocfc_enable(struct bfa_s *bfa)
+{
+	bfa_plog_str(bfa->plog, BFA_PL_MID_HAL, BFA_PL_EID_MISC, 0,
+		     "IOC Enable");
+	return bfa_ioc_enable(&bfa->ioc);
+}
+
+void
+bfa_iocfc_disable(struct bfa_s *bfa)
+{
+	bfa_plog_str(bfa->plog, BFA_PL_MID_HAL, BFA_PL_EID_MISC, 0,
+		     "IOC Disable");
+	bfa->iocfc.action = BFA_IOCFC_ACT_DISABLE;
+	bfa_ioc_disable(&bfa->ioc);
+}
+
+
+bfa_boolean_t
+bfa_iocfc_is_operational(struct bfa_s *bfa)
+{
+	return bfa_ioc_is_operational(&bfa->ioc) && bfa->iocfc.cfgdone;
+}
+
+void
+bfa_iocfc_isr(void *bfaarg, struct bfi_mbmsg_s *m)
+{
+	struct bfa_s		*bfa = bfaarg;
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+	union bfi_iocfc_i2h_msg_u	*msg;
+
+	msg = (union bfi_iocfc_i2h_msg_u *) m;
+	bfa_trc(bfa, msg->mh.msg_id);
+
+	switch (msg->mh.msg_id) {
+	case BFI_IOCFC_I2H_CFG_REPLY:
+		iocfc->cfg_reply = &msg->cfg_reply;
+		bfa_iocfc_cfgrsp(bfa);
+		break;
+
+	case BFI_IOCFC_I2H_GET_STATS_RSP:
+		if (iocfc->stats_busy == BFA_FALSE
+		    || iocfc->stats_status == BFA_STATUS_ETIMER)
+			break;
+
+		bfa_timer_stop(&iocfc->stats_timer);
+		iocfc->stats_status = BFA_STATUS_OK;
+		bfa_cb_queue(bfa, &iocfc->stats_hcb_qe, bfa_iocfc_stats_cb,
+			      bfa);
+		break;
+	case BFI_IOCFC_I2H_CLEAR_STATS_RSP:
+		/*
+		 * check for timer pop before processing the rsp
+		 */
+		if (iocfc->stats_busy == BFA_FALSE
+		    || iocfc->stats_status == BFA_STATUS_ETIMER)
+			break;
+
+		bfa_timer_stop(&iocfc->stats_timer);
+		iocfc->stats_status = BFA_STATUS_OK;
+		bfa_cb_queue(bfa, &iocfc->stats_hcb_qe,
+			      bfa_iocfc_stats_clr_cb, bfa);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+#ifndef BFA_BIOS_BUILD
+void
+bfa_adapter_get_attr(struct bfa_s *bfa, struct bfa_adapter_attr_s *ad_attr)
+{
+	bfa_ioc_get_adapter_attr(&bfa->ioc, ad_attr);
+}
+
+u64
+bfa_adapter_get_id(struct bfa_s *bfa)
+{
+	return bfa_ioc_get_adid(&bfa->ioc);
+}
+
+void
+bfa_iocfc_get_attr(struct bfa_s *bfa, struct bfa_iocfc_attr_s *attr)
+{
+	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+
+	attr->intr_attr = iocfc->cfginfo->intr_attr;
+	attr->config	= iocfc->cfg;
+}
+
+bfa_status_t
+bfa_iocfc_israttr_set(struct bfa_s *bfa, struct bfa_iocfc_intr_attr_s *attr)
+{
+	struct bfa_iocfc_s		*iocfc = &bfa->iocfc;
+	struct bfi_iocfc_set_intr_req_s *m;
+
+	iocfc->cfginfo->intr_attr = *attr;
+	if (!bfa_iocfc_is_operational(bfa))
+		return BFA_STATUS_OK;
+
+	m = bfa_reqq_next(bfa, BFA_REQQ_IOC);
+	if (!m)
+		return BFA_STATUS_DEVBUSY;
+
+	bfi_h2i_set(m->mh, BFI_MC_IOCFC, BFI_IOCFC_H2I_SET_INTR_REQ,
+			bfa_lpuid(bfa));
+	m->coalesce = attr->coalesce;
+	m->delay    = bfa_os_htons(attr->delay);
+	m->latency  = bfa_os_htons(attr->latency);
+
+	bfa_trc(bfa, attr->delay);
+	bfa_trc(bfa, attr->latency);
+
+	bfa_reqq_produce(bfa, BFA_REQQ_IOC);
+	return BFA_STATUS_OK;
+}
+#endif
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_iocfc.h patch/drivers/scsi/bfa/bfa_iocfc.h
--- orig/drivers/scsi/bfa/bfa_iocfc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_iocfc.h	2009-03-14 11:44:57.153815000 -0700
@@ -0,0 +1,117 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_IOCFC_H__
+#define __BFA_IOCFC_H__
+
+#include <bfa_ioc.h>
+#include <bfa.h>
+#include <bfi/bfi_iocfc.h>
+#include <bfa_callback_priv.h>
+
+#define BFA_REQQ_NELEMS_MIN	(16)
+#define BFA_RSPQ_NELEMS_MIN	(16)
+
+struct bfa_iocfc_regs_s {
+	bfa_os_addr_t   intr_status;
+	bfa_os_addr_t   intr_mask;
+	bfa_os_addr_t   cpe_q_pi[BFI_IOC_MAX_CQS];
+	bfa_os_addr_t   cpe_q_ci[BFI_IOC_MAX_CQS];
+	bfa_os_addr_t   cpe_q_depth[BFI_IOC_MAX_CQS];
+	bfa_os_addr_t   cpe_q_ctrl[BFI_IOC_MAX_CQS];
+	bfa_os_addr_t   rme_q_ci[BFI_IOC_MAX_CQS];
+	bfa_os_addr_t   rme_q_pi[BFI_IOC_MAX_CQS];
+	bfa_os_addr_t   rme_q_depth[BFI_IOC_MAX_CQS];
+	bfa_os_addr_t   rme_q_ctrl[BFI_IOC_MAX_CQS];
+};
+
+/**
+ * Chip specific interfaces
+ */
+struct bfa_hwif_s {
+	void	(*hw_reginit)(struct bfa_s *bfa);
+	void	(*hw_rspq_ack)(struct bfa_s *bfa, int rspq);
+};
+
+struct bfa_iocfc_s {
+	struct bfa_s 		*bfa;
+	struct bfa_iocfc_cfg_s 	cfg;
+	int			action;
+
+	u32        	req_cq_pi[BFI_IOC_MAX_CQS];
+	u32        	rsp_cq_ci[BFI_IOC_MAX_CQS];
+
+	struct bfa_cb_qe_s	init_hcb_qe;
+	struct bfa_cb_qe_s	stop_hcb_qe;
+	struct bfa_cb_qe_s	dis_hcb_qe;
+	struct bfa_cb_qe_s	stats_hcb_qe;
+	bfa_boolean_t		cfgdone;
+
+	struct bfa_dma_s	cfg_info;
+	struct bfi_iocfc_cfg_s *cfginfo;
+	struct bfa_dma_s	cfgrsp_dma;
+	struct bfi_iocfc_cfgrsp_s *cfgrsp;
+	struct bfi_iocfc_cfg_reply_s *cfg_reply;
+
+	u8			*stats_kva;
+	u64		stats_pa;
+	struct bfa_fw_stats_s 	*fw_stats;
+	struct bfa_timer_s 	stats_timer;	/*  timer */
+	struct bfa_iocfc_stats_s *stats_ret;	/*  driver stats location */
+	bfa_status_t		stats_status;	/*  stats/statsclr status */
+	bfa_boolean_t   	stats_busy;	/*  outstanding stats */
+	bfa_cb_ioc_t		stats_cbfn;	/*  driver callback function */
+	void           		*stats_cbarg;	/*  user callback arg */
+
+	struct bfa_dma_s   	req_cq_ba[BFI_IOC_MAX_CQS];
+	struct bfa_dma_s   	req_cq_shadow_ci[BFI_IOC_MAX_CQS];
+	struct bfa_dma_s   	rsp_cq_ba[BFI_IOC_MAX_CQS];
+	struct bfa_dma_s   	rsp_cq_shadow_pi[BFI_IOC_MAX_CQS];
+	struct bfa_iocfc_regs_s	bfa_regs;	/*  BFA device registers */
+	struct bfa_hwif_s	hwif;
+};
+
+#define bfa_lpuid(__bfa)		bfa_ioc_portid(&(__bfa)->ioc)
+#define bfa_sym_name(__bfa)    __bfa->fabric.bport.port_cfg.sym_name.symname
+
+/*
+ * FC specific IOC functions.
+ */
+void bfa_iocfc_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+		u32 *dm_len);
+void bfa_iocfc_attach(struct bfa_s *bfa, void *bfad,
+		struct bfa_iocfc_cfg_s *cfg, struct bfa_meminfo_s *meminfo,
+		struct bfa_pcidev_s *pcidev);
+void bfa_iocfc_detach(struct bfa_s *bfa);
+void bfa_iocfc_init(struct bfa_s *bfa);
+void bfa_iocfc_start(struct bfa_s *bfa);
+void bfa_iocfc_stop(struct bfa_s *bfa);
+void bfa_iocfc_isr(void *bfa, struct bfi_mbmsg_s *msg);
+void bfa_iocfc_set_snsbase(struct bfa_s *bfa, u64 snsbase_pa);
+bfa_boolean_t bfa_iocfc_is_operational(struct bfa_s *bfa);
+
+void bfa_hwcb_reginit(struct bfa_s *bfa);
+void bfa_hwcb_rspq_ack(struct bfa_s *bfa, int rspq);
+void bfa_hwct_reginit(struct bfa_s *bfa);
+void bfa_hwct_rspq_ack(struct bfa_s *bfa, int rspq);
+
+void bfa_com_meminfo(bfa_boolean_t mincfg, u32 *dm_len);
+void bfa_com_attach(struct bfa_s *bfa, struct bfa_meminfo_s *mi,
+		bfa_boolean_t mincfg);
+
+#endif /* __BFA_IOCFC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/bfa_ioc.h patch/drivers/scsi/bfa/bfa_ioc.h
--- orig/drivers/scsi/bfa/bfa_ioc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_ioc.h	2009-03-14 11:44:57.163524000 -0700
@@ -0,0 +1,250 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_IOC_H__
+#define __BFA_IOC_H__
+
+#include <cs/bfa_sm.h>
+#include <bfi/bfi.h>
+#include <bfi/bfi_ioc.h>
+#include <bfi/bfi_boot.h>
+#include <bfa_timer.h>
+
+/**
+ * PCI device information required by IOC
+ */
+struct bfa_pcidev_s {
+	int             pci_slot;
+	u8         pci_func;
+	u16	device_id;
+	bfa_os_addr_t   pci_bar_kva;
+};
+
+/**
+ * Structure used to remember the DMA-able memory block's KVA and Physical
+ * Address
+ */
+struct bfa_dma_s {
+	void		*kva;	/*! Kernel virtual address	*/
+	u64	pa;	/*! Physical address		*/
+};
+
+#define BFA_DMA_ALIGN_SZ	256
+#define BFA_ROUNDUP(_l, _s)	(((_l) + ((_s) - 1)) & ~((_s) - 1))
+
+
+
+#define bfa_dma_addr_set(dma_addr, pa)	\
+		__bfa_dma_addr_set(&dma_addr, (u64)pa)
+
+static inline void
+__bfa_dma_addr_set(union bfi_addr_u *dma_addr, u64 pa)
+{
+	dma_addr->a32.addr_lo = (u32) pa;
+	dma_addr->a32.addr_hi = (u32) (bfa_os_u32(pa));
+}
+
+
+#define bfa_dma_be_addr_set(dma_addr, pa)	\
+		__bfa_dma_be_addr_set(&dma_addr, (u64)pa)
+static inline void
+__bfa_dma_be_addr_set(union bfi_addr_u *dma_addr, u64 pa)
+{
+	dma_addr->a32.addr_lo = (u32) bfa_os_htonl(pa);
+	dma_addr->a32.addr_hi = (u32) bfa_os_htonl(bfa_os_u32(pa));
+}
+
+struct bfa_ioc_regs_s {
+	bfa_os_addr_t   hfn_mbox_cmd;
+	bfa_os_addr_t   hfn_mbox;
+	bfa_os_addr_t   lpu_mbox_cmd;
+	bfa_os_addr_t   lpu_mbox;
+	bfa_os_addr_t   pss_ctl_reg;
+	bfa_os_addr_t   app_pll_fast_ctl_reg;
+	bfa_os_addr_t   app_pll_slow_ctl_reg;
+	bfa_os_addr_t   host_sem0_reg;
+	bfa_os_addr_t   host_sem1_reg;
+	bfa_os_addr_t   host_sem2_reg;
+	bfa_os_addr_t   host_sem3_reg;
+	bfa_os_addr_t   host_page_num_fn;
+	bfa_os_addr_t   heartbeat;
+	bfa_os_addr_t   ioc_fwstate;
+	bfa_os_addr_t   smem_page_start;
+	u32	smem_pg0;
+};
+
+#define bfa_reg_read(_raddr)	bfa_os_reg_read(_raddr)
+#define bfa_reg_write(_raddr, _val)	bfa_os_reg_write(_raddr, _val)
+#define bfa_mem_read(_raddr, _off)	bfa_os_mem_read(_raddr, _off)
+#define bfa_mem_write(_raddr, _off, _val)	\
+					bfa_os_mem_write(_raddr, _off, _val)
+/**
+ * IOC Mailbox structures
+ */
+struct bfa_mbox_cmd_s {
+	struct list_head		qe;
+	u32	msg[ BFI_IOC_MSGSZ ];
+};
+
+/**
+ * IOC mailbox module
+ */
+typedef void (*bfa_ioc_mbox_mcfunc_t)(void *cbarg, struct bfi_mbmsg_s *m);
+struct bfa_ioc_mbox_mod_s {
+	struct list_head		cmd_q;		/*  pending mbox queue	*/
+	int			nmclass;	/*  number of handlers */
+	struct {
+		bfa_ioc_mbox_mcfunc_t	cbfn;	/*  message handlers	*/
+		void			*cbarg;
+	} mbhdlr[ BFI_MC_MAX ];
+};
+
+/**
+ * IOC callback function interfaces
+ */
+typedef void (*bfa_ioc_enable_cbfn_t)(void *bfa, enum bfa_status status);
+typedef void (*bfa_ioc_disable_cbfn_t)(void *bfa);
+typedef void (*bfa_ioc_hbfail_cbfn_t)(void *bfa);
+typedef void (*bfa_ioc_reset_cbfn_t)(void *bfa);
+struct bfa_ioc_cbfn_s {
+	bfa_ioc_enable_cbfn_t	enable_cbfn;
+	bfa_ioc_disable_cbfn_t	disable_cbfn;
+	bfa_ioc_hbfail_cbfn_t	hbfail_cbfn;
+	bfa_ioc_reset_cbfn_t	reset_cbfn;
+};
+
+/**
+ * Heartbeat failure notification queue element.
+ */
+struct bfa_ioc_hbfail_notify_s {
+	struct list_head		qe;
+	bfa_ioc_hbfail_cbfn_t	cbfn;
+	void			*cbarg;
+};
+typedef struct bfa_ioc_hbfail_notify_s bfa_ioc_hbfail_notify_t;
+
+/**
+ * Initialize a heartbeat failure notification structure
+ */
+#define bfa_ioc_hbfail_init(__notify, __cbfn, __cbarg) do {	\
+	(__notify)->cbfn = (__cbfn );      \
+	(__notify)->cbarg = (__cbarg );      \
+} while (0)
+
+struct bfa_ioc_s {
+	bfa_fsm_t		fsm;
+	struct bfa_s		*bfa;
+	struct bfa_pcidev_s	pcidev;
+	struct bfa_timer_mod_s 	*timer_mod;
+	struct bfa_timer_s 	ioc_timer;
+	struct bfa_timer_s 	sem_timer;
+	u32		hb_count;
+	u32		hb_fail;
+	u32		hwinit_count;
+	struct list_head		hb_notify_q;
+	void			*dbg_fwsave;
+	int			dbg_fwsave_len;
+	enum bfi_mclass		ioc_mc;
+	struct bfa_ioc_regs_s 	ioc_regs;
+	struct bfa_trc_mod_s	*trcmod;
+	struct bfa_aen_s	*aen;
+	struct bfa_log_mod_s	*logm;
+	struct bfa_ioc_drv_stats_s	stats;
+	bfa_boolean_t		auto_recover;
+	bfa_boolean_t		fcmode;
+	bfa_boolean_t		pllinit;
+	u8			port_id;
+
+	struct bfa_dma_s	attr_dma;
+	struct bfi_ioc_attr_s	*attr;
+	struct bfa_ioc_cbfn_s	*cbfn;
+	struct bfa_ioc_mbox_mod_s mbox_mod;
+};
+
+#define bfa_ioc_pcifn(__ioc)		(__ioc)->pcidev.pci_func
+#define bfa_ioc_devid(__ioc)		(__ioc)->pcidev.device_id
+#define bfa_ioc_bar0(__ioc)		(__ioc)->pcidev.pci_bar_kva
+#define bfa_ioc_portid(__ioc)		((__ioc)->port_id)
+#define bfa_ioc_fetch_stats(__ioc, __stats) \
+		((__stats)->drv_stats) = (__ioc)->stats
+#define bfa_ioc_clr_stats(__ioc)	\
+		bfa_os_memset(&(__ioc)->stats, 0, sizeof((__ioc)->stats))
+#define bfa_ioc_maxfrsize(__ioc)	(__ioc)->attr->maxfrsize
+#define bfa_ioc_rx_bbcredit(__ioc)	(__ioc)->attr->rx_bbcredit
+#define bfa_ioc_speed_sup(__ioc)	\
+	BFI_ADAPTER_GETP(SPEED, (__ioc)->attr->adapter_prop)
+
+/**
+ * IOC mailbox interface
+ */
+void bfa_ioc_mbox_queue(struct bfa_ioc_s *ioc, struct bfa_mbox_cmd_s *cmd);
+void bfa_ioc_mbox_register(struct bfa_ioc_s *ioc,
+		bfa_ioc_mbox_mcfunc_t *mcfuncs);
+void bfa_ioc_mbox_isr(struct bfa_ioc_s *ioc);
+void bfa_ioc_mbox_send(struct bfa_ioc_s *ioc, void *ioc_msg, int len);
+void bfa_ioc_msgget(struct bfa_ioc_s *ioc, void *mbmsg);
+void bfa_ioc_mbox_regisr(struct bfa_ioc_s *ioc, enum bfi_mclass mc,
+		bfa_ioc_mbox_mcfunc_t cbfn, void *cbarg);
+
+/**
+ * IOC interfaces
+ */
+void bfa_ioc_attach(struct bfa_ioc_s *ioc, void *bfa,
+		struct bfa_ioc_cbfn_s *cbfn, struct bfa_timer_mod_s *timer_mod,
+		struct bfa_trc_mod_s *trcmod,
+		struct bfa_aen_s *aen, struct bfa_log_mod_s *logm);
+void bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
+		enum bfi_mclass mc);
+u32 bfa_ioc_meminfo(void);
+void bfa_ioc_mem_claim(struct bfa_ioc_s *ioc,  u8 *dm_kva, u64 dm_pa);
+bfa_status_t bfa_ioc_enable(struct bfa_ioc_s *ioc);
+void bfa_ioc_disable(struct bfa_ioc_s *ioc);
+
+void bfa_ioc_boot(struct bfa_ioc_s *ioc, u32 boot_type, u32 boot_param);
+void bfa_ioc_isr(struct bfa_ioc_s *ioc, struct bfi_mbmsg_s *msg);
+bfa_status_t bfa_ioc_pll_init(struct bfa_ioc_s *ioc);
+bfa_boolean_t bfa_ioc_is_operational(struct bfa_ioc_s *ioc);
+bfa_boolean_t bfa_ioc_is_disabled(struct bfa_ioc_s *ioc);
+bfa_boolean_t bfa_ioc_adapter_is_disabled(struct bfa_ioc_s *ioc);
+void bfa_ioc_cfg_complete(struct bfa_ioc_s *ioc);
+void bfa_ioc_get_attr(struct bfa_ioc_s *ioc, struct bfa_ioc_attr_s *ioc_attr);
+void bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
+		struct bfa_adapter_attr_s *ad_attr);
+int bfa_ioc_debug_trcsz(bfa_boolean_t auto_recover);
+void bfa_ioc_debug_memclaim(struct bfa_ioc_s *ioc, void *dbg_fwsave);
+bfa_status_t bfa_ioc_debug_fwsave(struct bfa_ioc_s *ioc, void *trcdata,
+		int *trclen);
+bfa_status_t bfa_ioc_debug_fwtrc(struct bfa_ioc_s *ioc, void *trcdata,
+				 int *trclen);
+u32 bfa_ioc_smem_pgnum(struct bfa_ioc_s *ioc, u32 fmaddr);
+u32 bfa_ioc_smem_pgoff(struct bfa_ioc_s *ioc, u32 fmaddr);
+void bfa_ioc_set_fcmode(struct bfa_ioc_s *ioc);
+bfa_boolean_t bfa_ioc_get_fcmode(struct bfa_ioc_s *ioc);
+void bfa_ioc_hbfail_register(struct bfa_ioc_s *ioc,
+	struct bfa_ioc_hbfail_notify_s *notify);
+
+/*
+ * bfa mfg wwn API functions
+ */
+wwn_t bfa_ioc_get_pwwn(struct bfa_ioc_s *ioc);
+wwn_t bfa_ioc_get_nwwn(struct bfa_ioc_s *ioc);
+wwn_t bfa_ioc_get_wwn_naa5(struct bfa_ioc_s *ioc, u16 inst);
+mac_t bfa_ioc_get_mac(struct bfa_ioc_s *ioc);
+u64 bfa_ioc_get_adid(struct bfa_ioc_s *ioc);
+
+#endif /* __BFA_IOC_H__ */
+
diff -urpN orig/drivers/scsi/bfa/bfa_ioim.c patch/drivers/scsi/bfa/bfa_ioim.c
--- orig/drivers/scsi/bfa/bfa_ioim.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_ioim.c	2009-03-14 11:44:57.174034000 -0700
@@ -0,0 +1,1291 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <cs/bfa_debug.h>
+#include <bfa_cb_ioim_macros.h>
+
+BFA_TRC_FILE(HAL, IOIM);
+
+/*
+ * forward declarations.
+ */
+static bfa_boolean_t	bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim);
+static bfa_boolean_t	bfa_ioim_sge_setup(struct bfa_ioim_s *ioim);
+static void		bfa_ioim_sgpg_setup(struct bfa_ioim_s *ioim);
+static bfa_boolean_t	bfa_ioim_send_abort(struct bfa_ioim_s *ioim);
+static void		bfa_ioim_notify_cleanup(struct bfa_ioim_s *ioim);
+static void __bfa_cb_ioim_good_comp(void *cbarg, bfa_boolean_t complete);
+static void __bfa_cb_ioim_comp(void *cbarg, bfa_boolean_t complete);
+static void __bfa_cb_ioim_abort(void *cbarg, bfa_boolean_t complete);
+static void __bfa_cb_ioim_failed(void *cbarg, bfa_boolean_t complete);
+static void __bfa_cb_ioim_pathtov(void *cbarg, bfa_boolean_t complete);
+
+/**
+ *  hal_ioim_sm
+ */
+
+/**
+ * IO state machine events
+ */
+enum bfa_ioim_event {
+	BFA_IOIM_SM_START	   = 1,	/*  io start request from host */
+	BFA_IOIM_SM_COMP_GOOD  = 2,	/*  io good comp, resource free */
+	BFA_IOIM_SM_COMP	   = 3,	/*  io comp, resource is free */
+	BFA_IOIM_SM_COMP_UTAG  = 4,	/*  io comp, resource is free */
+	BFA_IOIM_SM_DONE	   = 5,	/*  io comp, resource not free */
+	BFA_IOIM_SM_FREE	   = 6,	/*  io resource is freed */
+	BFA_IOIM_SM_ABORT	   = 7,	/*  abort request from scsi stack */
+	BFA_IOIM_SM_ABORT_COMP = 8,	/*  abort from f/w */
+	BFA_IOIM_SM_ABORT_DONE = 9,	/*  abort completion from f/w */
+	BFA_IOIM_SM_QRESUME	   = 10,/*  CQ space available to queue IO */
+	BFA_IOIM_SM_SGALLOCED  = 11,/*  SG page allocation successful */
+	BFA_IOIM_SM_SQRETRY	   = 12,/*  sequence recovery retry */
+	BFA_IOIM_SM_HCB	   = 13,/*  bfa callback complete */
+	BFA_IOIM_SM_CLEANUP	   = 14,/*  IO cleanup from itnim */
+	BFA_IOIM_SM_TMSTART	   = 15,/*  IO cleanup from tskim */
+	BFA_IOIM_SM_TMDONE	   = 16,/*  IO cleanup from tskim */
+	BFA_IOIM_SM_HWFAIL	   = 17,/*  IOC h/w failure event */
+	BFA_IOIM_SM_IOTOV	   = 18,/*  ITN offline TOV       */
+};
+
+/*
+ * forward declaration of IO state machine
+ */
+static void     bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim,
+				       enum bfa_ioim_event event);
+static void     bfa_ioim_sm_sgalloc(struct bfa_ioim_s *ioim,
+					enum bfa_ioim_event event);
+static void     bfa_ioim_sm_active(struct bfa_ioim_s *ioim,
+				       enum bfa_ioim_event event);
+static void     bfa_ioim_sm_abort(struct bfa_ioim_s *ioim,
+				      enum bfa_ioim_event event);
+static void     bfa_ioim_sm_cleanup(struct bfa_ioim_s *ioim,
+					enum bfa_ioim_event event);
+static void     bfa_ioim_sm_qfull(struct bfa_ioim_s *ioim,
+				      enum bfa_ioim_event event);
+static void     bfa_ioim_sm_abort_qfull(struct bfa_ioim_s *ioim,
+					    enum bfa_ioim_event event);
+static void     bfa_ioim_sm_cleanup_qfull(struct bfa_ioim_s *ioim,
+					      enum bfa_ioim_event event);
+static void     bfa_ioim_sm_hcb(struct bfa_ioim_s *ioim,
+				    enum bfa_ioim_event event);
+static void     bfa_ioim_sm_hcb_free(struct bfa_ioim_s *ioim,
+					 enum bfa_ioim_event event);
+static void     bfa_ioim_sm_resfree(struct bfa_ioim_s *ioim,
+					enum bfa_ioim_event event);
+
+/**
+ * 		IO is not started (unallocated).
+ */
+static void
+bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc_fp(ioim->bfa, ioim->iotag);
+	bfa_trc_fp(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_START:
+		if (!bfa_itnim_is_online(ioim->itnim)) {
+			if (!bfa_itnim_hold_io(ioim->itnim)) {
+				bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+				list_del(&ioim->qe);
+				list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
+				bfa_cb_queue(ioim->bfa, &ioim->hcb_qe,
+						__bfa_cb_ioim_pathtov, ioim);
+			} else {
+				list_del(&ioim->qe);
+				list_add_tail(&ioim->qe, &ioim->itnim->pending_q);
+			}
+			break;
+		}
+
+		if (ioim->nsges > BFI_SGE_INLINE) {
+			if (!bfa_ioim_sge_setup(ioim)) {
+				bfa_sm_set_state(ioim, bfa_ioim_sm_sgalloc);
+				return;
+			}
+		}
+
+		if (!bfa_ioim_send_ioreq(ioim)) {
+			bfa_sm_set_state(ioim, bfa_ioim_sm_qfull);
+			break;
+		}
+
+		bfa_sm_set_state(ioim, bfa_ioim_sm_active);
+		break;
+
+	case BFA_IOIM_SM_IOTOV:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe,
+			      __bfa_cb_ioim_pathtov, ioim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		IO is waiting for SG pages.
+ */
+static void
+bfa_ioim_sm_sgalloc(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_SGALLOCED:
+		if (!bfa_ioim_send_ioreq(ioim)) {
+			bfa_sm_set_state(ioim, bfa_ioim_sm_qfull);
+			break;
+		}
+		bfa_sm_set_state(ioim, bfa_ioim_sm_active);
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_sgpg_wcancel(ioim->bfa, &ioim->iosp->sgpg_wqe);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_ABORT:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_sgpg_wcancel(ioim->bfa, &ioim->iosp->sgpg_wqe);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_sgpg_wcancel(ioim->bfa, &ioim->iosp->sgpg_wqe);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		IO is active.
+ */
+static void
+bfa_ioim_sm_active(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc_fp(ioim->bfa, ioim->iotag);
+	bfa_trc_fp(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_COMP_GOOD:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe,
+			      __bfa_cb_ioim_good_comp, ioim);
+		break;
+
+	case BFA_IOIM_SM_COMP:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_comp,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_DONE:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb_free);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_comp,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_ABORT:
+		ioim->iosp->abort_explicit = BFA_TRUE;
+		ioim->io_cbfn = __bfa_cb_ioim_abort;
+
+		if (bfa_ioim_send_abort(ioim))
+			bfa_sm_set_state(ioim, bfa_ioim_sm_abort);
+		else {
+			bfa_sm_set_state(ioim, bfa_ioim_sm_abort_qfull);
+			bfa_reqq_wait(ioim->bfa, ioim->itnim->reqq,
+					  &ioim->iosp->reqq_wait);
+		}
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		ioim->iosp->abort_explicit = BFA_FALSE;
+		ioim->io_cbfn = __bfa_cb_ioim_failed;
+
+		if (bfa_ioim_send_abort(ioim))
+			bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup);
+		else {
+			bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup_qfull);
+			bfa_reqq_wait(ioim->bfa, ioim->itnim->reqq,
+					  &ioim->iosp->reqq_wait);
+		}
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		IO is being aborted, waiting for completion from firmware.
+ */
+static void
+bfa_ioim_sm_abort(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_COMP_GOOD:
+	case BFA_IOIM_SM_COMP:
+	case BFA_IOIM_SM_DONE:
+	case BFA_IOIM_SM_FREE:
+		break;
+
+	case BFA_IOIM_SM_ABORT_DONE:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb_free);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_ABORT_COMP:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_COMP_UTAG:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		bfa_assert(ioim->iosp->abort_explicit == BFA_TRUE);
+		ioim->iosp->abort_explicit = BFA_FALSE;
+
+		if (bfa_ioim_send_abort(ioim))
+			bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup);
+		else {
+			bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup_qfull);
+			bfa_reqq_wait(ioim->bfa, ioim->itnim->reqq,
+					  &ioim->iosp->reqq_wait);
+		}
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * IO is being cleaned up (implicit abort), waiting for completion from
+ * firmware.
+ */
+static void
+bfa_ioim_sm_cleanup(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_COMP_GOOD:
+	case BFA_IOIM_SM_COMP:
+	case BFA_IOIM_SM_DONE:
+	case BFA_IOIM_SM_FREE:
+		break;
+
+	case BFA_IOIM_SM_ABORT:
+		/**
+		 * IO is already being aborted implicitly
+		 */
+		ioim->io_cbfn = __bfa_cb_ioim_abort;
+		break;
+
+	case BFA_IOIM_SM_ABORT_DONE:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb_free);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, ioim->io_cbfn, ioim);
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_ABORT_COMP:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, ioim->io_cbfn, ioim);
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_COMP_UTAG:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, ioim->io_cbfn, ioim);
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		/**
+		 * IO can be in cleanup state already due to TM command. 2nd cleanup
+		 * request comes from ITN offline event.
+		 */
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		IO is waiting for room in request CQ
+ */
+static void
+bfa_ioim_sm_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_QRESUME:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_active);
+		bfa_ioim_send_ioreq(ioim);
+		break;
+
+	case BFA_IOIM_SM_ABORT:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Active IO is being aborted, waiting for room in request CQ.
+ */
+static void
+bfa_ioim_sm_abort_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_QRESUME:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_abort);
+		bfa_ioim_send_abort(ioim);
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		bfa_assert(ioim->iosp->abort_explicit == BFA_TRUE);
+		ioim->iosp->abort_explicit = BFA_FALSE;
+		bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup_qfull);
+		break;
+
+	case BFA_IOIM_SM_COMP_GOOD:
+	case BFA_IOIM_SM_COMP:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_DONE:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb_free);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_abort,
+			      ioim);
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Active IO is being cleaned up, waiting for room in request CQ.
+ */
+static void
+bfa_ioim_sm_cleanup_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_QRESUME:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_cleanup);
+		bfa_ioim_send_abort(ioim);
+		break;
+
+	case BFA_IOIM_SM_ABORT:
+		/**
+		 * IO is alraedy being cleaned up implicitly
+		 */
+		ioim->io_cbfn = __bfa_cb_ioim_abort;
+		break;
+
+	case BFA_IOIM_SM_COMP_GOOD:
+	case BFA_IOIM_SM_COMP:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, ioim->io_cbfn, ioim);
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_DONE:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb_free);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, ioim->io_cbfn, ioim);
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		bfa_reqq_wcancel(&ioim->iosp->reqq_wait);
+		bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, __bfa_cb_ioim_failed,
+			      ioim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * IO bfa callback is pending.
+ */
+static void
+bfa_ioim_sm_hcb(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc_fp(ioim->bfa, ioim->iotag);
+	bfa_trc_fp(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_HCB:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_uninit);
+		bfa_ioim_free(ioim);
+		bfa_cb_ioim_resfree(ioim->bfa->bfad);
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * IO bfa callback is pending. IO resource cannot be freed.
+ */
+static void
+bfa_ioim_sm_hcb_free(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_HCB:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_resfree);
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_resfree_q);
+		break;
+
+	case BFA_IOIM_SM_FREE:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * IO is completed, waiting resource free from firmware.
+ */
+static void
+bfa_ioim_sm_resfree(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, event);
+
+	switch (event) {
+	case BFA_IOIM_SM_FREE:
+		bfa_sm_set_state(ioim, bfa_ioim_sm_uninit);
+		bfa_ioim_free(ioim);
+		bfa_cb_ioim_resfree(ioim->bfa->bfad);
+		break;
+
+	case BFA_IOIM_SM_CLEANUP:
+		bfa_ioim_notify_cleanup(ioim);
+		break;
+
+	case BFA_IOIM_SM_HWFAIL:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  hal_ioim_private
+ */
+
+static void
+__bfa_cb_ioim_good_comp(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_ioim_s *ioim = cbarg;
+
+	if (!complete) {
+		bfa_sm_send_event(ioim, BFA_IOIM_SM_HCB);
+		return;
+	}
+
+	bfa_cb_ioim_good_comp(ioim->bfa->bfad, ioim->dio);
+}
+
+static void
+__bfa_cb_ioim_comp(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_ioim_s	*ioim = cbarg;
+	struct bfi_ioim_rsp_s *m;
+	u8		*snsinfo = NULL;
+	u8         sns_len = 0;
+	s32         residue = 0;
+
+	if (!complete) {
+		bfa_sm_send_event(ioim, BFA_IOIM_SM_HCB);
+		return;
+	}
+
+	m = (struct bfi_ioim_rsp_s *) &ioim->iosp->comp_rspmsg;
+	if (m->io_status == BFI_IOIM_STS_OK) {
+		/**
+		 * setup sense information, if present
+		 */
+		if (m->scsi_status == SCSI_STATUS_CHECK_CONDITION
+					&& m->sns_len) {
+			sns_len = m->sns_len;
+			snsinfo = ioim->iosp->snsinfo;
+		}
+
+		/**
+		 * setup residue value correctly for normal completions
+		 */
+		if (m->resid_flags == FCP_RESID_UNDER)
+			residue = bfa_os_ntohl(m->residue);
+		if (m->resid_flags == FCP_RESID_OVER) {
+			residue = bfa_os_ntohl(m->residue);
+			residue = -residue;
+		}
+	}
+
+	bfa_cb_ioim_done(ioim->bfa->bfad, ioim->dio, m->io_status,
+			  m->scsi_status, sns_len, snsinfo, residue);
+}
+
+static void
+__bfa_cb_ioim_failed(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_ioim_s *ioim = cbarg;
+
+	if (!complete) {
+		bfa_sm_send_event(ioim, BFA_IOIM_SM_HCB);
+		return;
+	}
+
+	bfa_cb_ioim_done(ioim->bfa->bfad, ioim->dio, BFI_IOIM_STS_ABORTED,
+			  0, 0, NULL, 0);
+}
+
+static void
+__bfa_cb_ioim_pathtov(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_ioim_s *ioim = cbarg;
+
+	if (!complete) {
+		bfa_sm_send_event(ioim, BFA_IOIM_SM_HCB);
+		return;
+	}
+
+	bfa_cb_ioim_done(ioim->bfa->bfad, ioim->dio, BFI_IOIM_STS_PATHTOV,
+			  0, 0, NULL, 0);
+}
+
+static void
+__bfa_cb_ioim_abort(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_ioim_s *ioim = cbarg;
+
+	if (!complete) {
+		bfa_sm_send_event(ioim, BFA_IOIM_SM_HCB);
+		return;
+	}
+
+	bfa_cb_ioim_abort(ioim->bfa->bfad, ioim->dio);
+}
+
+static void
+bfa_ioim_sgpg_alloced(void *cbarg)
+{
+	struct bfa_ioim_s *ioim = cbarg;
+
+	ioim->nsgpgs = BFA_SGPG_NPAGE(ioim->nsges);
+	list_splice_tail_init(&ioim->iosp->sgpg_wqe.sgpg_q, &ioim->sgpg_q);
+	bfa_ioim_sgpg_setup(ioim);
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_SGALLOCED);
+}
+
+/**
+ * Send I/O request to firmware.
+ */
+static          bfa_boolean_t
+bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
+{
+	struct bfa_itnim_s *itnim = ioim->itnim;
+	struct bfi_ioim_req_s *m;
+	static fcp_cmnd_t cmnd_z0 = { 0 };
+	struct bfi_sge_s      *sge;
+	u32        pgdlen = 0;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_ionext(ioim->bfa, itnim->reqq);
+	if (!m) {
+		bfa_reqq_wait(ioim->bfa, ioim->itnim->reqq,
+				  &ioim->iosp->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	/**
+	 * build i/o request message next
+	 */
+	m->io_tag = bfa_os_htons(ioim->iotag);
+	m->rport_hdl = ioim->itnim->rport->rport_tag;
+	m->io_timeout = bfa_cb_ioim_get_timeout(ioim->dio);
+
+	/**
+	 * build inline IO SG element here
+	 */
+	sge = &m->sges[0];
+	if (ioim->nsges) {
+		sge->sga = bfa_cb_ioim_get_sgaddr(ioim->dio, 0);
+		pgdlen = bfa_cb_ioim_get_sglen(ioim->dio, 0);
+		sge->sg_len = pgdlen;
+		sge->flags = (ioim->nsges > BFI_SGE_INLINE) ?
+					BFI_SGE_DATA_CPL : BFI_SGE_DATA_LAST;
+		bfa_sge_to_be(sge);
+		sge++;
+	}
+
+	if (ioim->nsges > BFI_SGE_INLINE) {
+		sge->sga = ioim->sgpg->sgpg_pa;
+	} else {
+		sge->sga.a32.addr_lo = 0;
+		sge->sga.a32.addr_hi = 0;
+	}
+	sge->sg_len = pgdlen;
+	sge->flags = BFI_SGE_PGDLEN;
+	bfa_sge_to_be(sge);
+
+	/**
+	 * set up I/O command parameters
+	 */
+	m->cmnd = cmnd_z0;
+	m->cmnd.lun = bfa_cb_ioim_get_lun(ioim->dio);
+	m->cmnd.iodir = bfa_cb_ioim_get_iodir(ioim->dio);
+	m->cmnd.cdb = *(scsi_cdb_t *) bfa_cb_ioim_get_cdb(ioim->dio);
+	m->cmnd.fcp_dl = bfa_os_htonl(bfa_cb_ioim_get_size(ioim->dio));
+
+	/**
+	 * set up I/O message header
+	 */
+	switch (m->cmnd.iodir) {
+	case FCP_IODIR_READ:
+		bfi_h2i_set(m->mh, BFI_MC_IOIM_READ, 0, bfa_lpuid(ioim->bfa));
+		break;
+	case FCP_IODIR_WRITE:
+		bfi_h2i_set(m->mh, BFI_MC_IOIM_WRITE, 0, bfa_lpuid(ioim->bfa));
+		break;
+	default:
+		bfi_h2i_set(m->mh, BFI_MC_IOIM_IO, 0, bfa_lpuid(ioim->bfa));
+	}
+	if (itnim->seq_rec ||
+	    (bfa_cb_ioim_get_size(ioim->dio) & (sizeof(u32) - 1)))
+		bfi_h2i_set(m->mh, BFI_MC_IOIM_IO, 0, bfa_lpuid(ioim->bfa));
+
+#ifdef IOIM_ADVANCED
+	m->cmnd.crn = bfa_cb_ioim_get_crn(ioim->dio);
+	m->cmnd.priority = bfa_cb_ioim_get_priority(ioim->dio);
+	m->cmnd.taskattr = bfa_cb_ioim_get_taskattr(ioim->dio);
+
+	/**
+	 * Handle large CDB (>16 bytes).
+	 */
+	m->cmnd.addl_cdb_len = (bfa_cb_ioim_get_cdblen(ioim->dio) -
+					FCP_CMND_CDB_LEN) / sizeof(u32);
+	if (m->cmnd.addl_cdb_len) {
+		memcpy(&m->cmnd.cdb + 1, (scsi_cdb_t *)
+				bfa_cb_ioim_get_cdb(ioim->dio) + 1,
+				m->cmnd.addl_cdb_len * sizeof(u32));
+		fcp_cmnd_fcpdl(&m->cmnd) =
+				bfa_os_htonl(bfa_cb_ioim_get_size(ioim->dio));
+	}
+#endif
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(ioim->bfa, itnim->reqq);
+	return BFA_TRUE;
+}
+
+/**
+ * Setup any additional SG pages needed.Inline SG element is setup
+ * at queuing time.
+ */
+static bfa_boolean_t
+bfa_ioim_sge_setup(struct bfa_ioim_s *ioim)
+{
+	u16        nsgpgs;
+
+	bfa_assert(ioim->nsges > BFI_SGE_INLINE);
+
+	/**
+	 * allocate SG pages needed
+	 */
+	nsgpgs = BFA_SGPG_NPAGE(ioim->nsges);
+	if (!nsgpgs)
+		return BFA_TRUE;
+
+	if (bfa_sgpg_malloc(ioim->bfa, &ioim->sgpg_q, nsgpgs)
+	    != BFA_STATUS_OK) {
+		bfa_sgpg_wait(ioim->bfa, &ioim->iosp->sgpg_wqe, nsgpgs);
+		return BFA_FALSE;
+	}
+
+	ioim->nsgpgs = nsgpgs;
+	bfa_ioim_sgpg_setup(ioim);
+
+	return BFA_TRUE;
+}
+
+static void
+bfa_ioim_sgpg_setup(struct bfa_ioim_s *ioim)
+{
+	int             sgeid, nsges, i;
+	struct bfi_sge_s      *sge;
+	struct bfa_sgpg_s *sgpg;
+	u32        pgcumsz;
+
+	sgeid = BFI_SGE_INLINE;
+	ioim->sgpg = sgpg = bfa_q_first(&ioim->sgpg_q);
+
+	do {
+		sge = sgpg->sgpg->sges;
+		nsges = ioim->nsges - sgeid;
+		if (nsges > BFI_SGPG_DATA_SGES)
+			nsges = BFI_SGPG_DATA_SGES;
+
+		pgcumsz = 0;
+		for (i = 0; i < nsges; i++, sge++, sgeid++) {
+			sge->sga = bfa_cb_ioim_get_sgaddr(ioim->dio, sgeid);
+			sge->sg_len = bfa_cb_ioim_get_sglen(ioim->dio, sgeid);
+			pgcumsz += sge->sg_len;
+
+			/**
+			 * set flags
+			 */
+			if (i < (nsges - 1))
+				sge->flags = BFI_SGE_DATA;
+			else if (sgeid < (ioim->nsges - 1))
+				sge->flags = BFI_SGE_DATA_CPL;
+			else
+				sge->flags = BFI_SGE_DATA_LAST;
+		}
+
+		sgpg = (struct bfa_sgpg_s *) bfa_q_next(sgpg);
+
+		/**
+		 * set the link element of each page
+		 */
+		if (sgeid == ioim->nsges) {
+			sge->flags = BFI_SGE_PGDLEN;
+			sge->sga.a32.addr_lo = 0;
+			sge->sga.a32.addr_hi = 0;
+		} else {
+			sge->flags = BFI_SGE_LINK;
+			sge->sga = sgpg->sgpg_pa;
+		}
+		sge->sg_len = pgcumsz;
+	} while (sgeid < ioim->nsges);
+}
+
+/**
+ * Send I/O abort request to firmware.
+ */
+static          bfa_boolean_t
+bfa_ioim_send_abort(struct bfa_ioim_s *ioim)
+{
+	struct bfa_itnim_s          *itnim = ioim->itnim;
+	struct bfi_ioim_abort_req_s *m;
+	enum bfi_ioim_h2i       msgop;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_ionext(ioim->bfa, itnim->reqq);
+	if (!m)
+		return BFA_FALSE;
+
+	/**
+	 * build i/o request message next
+	 */
+	if (ioim->iosp->abort_explicit)
+		msgop = BFI_IOIM_H2I_IOABORT_REQ;
+	else
+		msgop = BFI_IOIM_H2I_IOCLEANUP_REQ;
+
+	bfi_h2i_set(m->mh, BFI_MC_IOIM, msgop, bfa_lpuid(ioim->bfa));
+	m->io_tag    = bfa_os_htons(ioim->iotag);
+	m->abort_tag = ++ioim->abort_tag;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(ioim->bfa, itnim->reqq);
+	return BFA_TRUE;
+}
+
+/**
+ * Call to resume any I/O requests waiting for room in request queue.
+ */
+static void
+bfa_ioim_qresume(void *cbarg)
+{
+	struct bfa_ioim_s *ioim = cbarg;
+
+	bfa_fcpim_stats(ioim->fcpim, qresumes);
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_QRESUME);
+}
+
+
+static void
+bfa_ioim_notify_cleanup(struct bfa_ioim_s *ioim)
+{
+	/**
+	 * Move IO from itnim queue to fcpim global queue since itnim will be
+	 * freed.
+	 */
+	list_del(&ioim->qe);
+	list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
+
+	if (!ioim->iosp->tskim) {
+		if (ioim->fcpim->delay_comp && ioim->itnim->iotov_active) {
+			bfa_cb_dequeue(&ioim->hcb_qe);
+			list_del(&ioim->qe);
+			list_add_tail(&ioim->qe, &ioim->itnim->delay_comp_q);
+		}
+		bfa_itnim_iodone(ioim->itnim);
+	} else
+		bfa_tskim_iodone(ioim->iosp->tskim);
+}
+
+/**
+ * 		  or after the link comes back.
+ */
+void
+bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim, bfa_boolean_t iotov)
+{
+	/**
+	 * If path tov timer expired, failback with PATHTOV status - these
+	 * IO requests are not normally retried by IO stack.
+	 *
+	 * Otherwise device cameback online and fail it with normal failed
+	 * status so that IO stack retries these failed IO requests.
+	 */
+	if (iotov)
+		ioim->io_cbfn = __bfa_cb_ioim_pathtov;
+	else
+		ioim->io_cbfn = __bfa_cb_ioim_failed;
+
+	bfa_cb_queue(ioim->bfa, &ioim->hcb_qe, ioim->io_cbfn, ioim);
+
+    /**
+     * Move IO to fcpim global queue since itnim will be
+     * freed.
+     */
+    list_del(&ioim->qe);
+    list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
+}
+
+
+
+/**
+ *  hal_ioim_friend
+ */
+
+/**
+ * Memory allocation and initialization.
+ */
+void
+bfa_ioim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
+{
+	struct bfa_ioim_s		*ioim;
+	struct bfa_ioim_sp_s	*iosp;
+	u16		i;
+	u8			*snsinfo;
+	u32		snsbufsz;
+
+	/**
+	 * claim memory first
+	 */
+	ioim = (struct bfa_ioim_s *) bfa_meminfo_kva(minfo);
+	fcpim->ioim_arr = ioim;
+	bfa_meminfo_kva(minfo) = (u8 *) (ioim + fcpim->num_ioim_reqs);
+
+	iosp = (struct bfa_ioim_sp_s *) bfa_meminfo_kva(minfo);
+	fcpim->ioim_sp_arr = iosp;
+	bfa_meminfo_kva(minfo) = (u8 *) (iosp + fcpim->num_ioim_reqs);
+
+	/**
+	 * Claim DMA memory for per IO sense data.
+	 */
+	snsbufsz = fcpim->num_ioim_reqs * BFI_IOIM_SNSLEN;
+	fcpim->snsbase.pa  = bfa_meminfo_dma_phys(minfo);
+	bfa_meminfo_dma_phys(minfo) += snsbufsz;
+
+	fcpim->snsbase.kva = bfa_meminfo_dma_virt(minfo);
+	bfa_meminfo_dma_virt(minfo) += snsbufsz;
+	snsinfo = fcpim->snsbase.kva;
+	bfa_iocfc_set_snsbase(fcpim->bfa, fcpim->snsbase.pa);
+
+	/**
+	 * Initialize ioim free queues
+	 */
+	INIT_LIST_HEAD(&fcpim->ioim_free_q);
+	INIT_LIST_HEAD(&fcpim->ioim_resfree_q);
+	INIT_LIST_HEAD(&fcpim->ioim_comp_q);
+
+	for (i = 0; i < fcpim->num_ioim_reqs;
+	     i++, ioim++, iosp++, snsinfo += BFI_IOIM_SNSLEN) {
+		/*
+		 * initialize IOIM
+		 */
+		bfa_os_memset(ioim, 0, sizeof(struct bfa_ioim_s));
+		ioim->iotag   = i;
+		ioim->bfa     = fcpim->bfa;
+		ioim->fcpim   = fcpim;
+		ioim->iosp    = iosp;
+		iosp->snsinfo = snsinfo;
+		INIT_LIST_HEAD(&ioim->sgpg_q);
+		bfa_reqq_winit(&ioim->iosp->reqq_wait,
+				   bfa_ioim_qresume, ioim);
+		bfa_sgpg_winit(&ioim->iosp->sgpg_wqe,
+				   bfa_ioim_sgpg_alloced, ioim);
+		bfa_sm_set_state(ioim, bfa_ioim_sm_uninit);
+
+		list_add_tail(&ioim->qe, &fcpim->ioim_free_q);
+	}
+}
+
+/**
+ * Driver detach time call.
+ */
+void
+bfa_ioim_detach(struct bfa_fcpim_mod_s *fcpim)
+{
+}
+
+void
+bfa_ioim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	struct bfi_ioim_rsp_s *rsp = (struct bfi_ioim_rsp_s *) m;
+	struct bfa_ioim_s *ioim;
+	u16        iotag;
+	enum bfa_ioim_event evt = BFA_IOIM_SM_COMP;
+
+	iotag = bfa_os_ntohs(rsp->io_tag);
+
+	ioim = BFA_IOIM_FROM_TAG(fcpim, iotag);
+	bfa_assert(ioim->iotag == iotag);
+
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_trc(ioim->bfa, rsp->io_status);
+	bfa_trc(ioim->bfa, rsp->reuse_io_tag);
+
+	if (bfa_sm_cmp_state(ioim, bfa_ioim_sm_active))
+		ioim->iosp->comp_rspmsg = *m;
+
+	switch (rsp->io_status) {
+	case BFI_IOIM_STS_OK:
+		bfa_fcpim_stats(fcpim, iocomp_ok);
+		if (rsp->reuse_io_tag == 0)
+			evt = BFA_IOIM_SM_DONE;
+		else
+			evt = BFA_IOIM_SM_COMP;
+		break;
+
+	case BFI_IOIM_STS_TIMEDOUT:
+	case BFI_IOIM_STS_ABORTED:
+		rsp->io_status = BFI_IOIM_STS_ABORTED;
+		bfa_fcpim_stats(fcpim, iocomp_aborted);
+		if (rsp->reuse_io_tag == 0)
+			evt = BFA_IOIM_SM_DONE;
+		else
+			evt = BFA_IOIM_SM_COMP;
+		break;
+
+	case BFI_IOIM_STS_PROTO_ERR:
+		bfa_fcpim_stats(fcpim, iocom_proto_err);
+		bfa_assert(rsp->reuse_io_tag);
+		evt = BFA_IOIM_SM_COMP;
+		break;
+
+	case BFI_IOIM_STS_SQER_NEEDED:
+		bfa_fcpim_stats(fcpim, iocom_sqer_needed);
+		bfa_assert(rsp->reuse_io_tag == 0);
+		evt = BFA_IOIM_SM_SQRETRY;
+		break;
+
+	case BFI_IOIM_STS_RES_FREE:
+		bfa_fcpim_stats(fcpim, iocom_res_free);
+		evt = BFA_IOIM_SM_FREE;
+		break;
+
+	case BFI_IOIM_STS_HOST_ABORTED:
+		bfa_fcpim_stats(fcpim, iocom_hostabrts);
+		if (rsp->abort_tag != ioim->abort_tag) {
+			bfa_trc(ioim->bfa, rsp->abort_tag);
+			bfa_trc(ioim->bfa, ioim->abort_tag);
+			return;
+		}
+
+		if (rsp->reuse_io_tag)
+			evt = BFA_IOIM_SM_ABORT_COMP;
+		else
+			evt = BFA_IOIM_SM_ABORT_DONE;
+		break;
+
+	case BFI_IOIM_STS_UTAG:
+		bfa_fcpim_stats(fcpim, iocom_utags);
+		evt = BFA_IOIM_SM_COMP_UTAG;
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+
+	bfa_sm_send_event(ioim, evt);
+}
+
+void
+bfa_ioim_good_comp_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	struct bfi_ioim_rsp_s *rsp = (struct bfi_ioim_rsp_s *) m;
+	struct bfa_ioim_s *ioim;
+	u16        iotag;
+
+	iotag = bfa_os_ntohs(rsp->io_tag);
+
+	ioim = BFA_IOIM_FROM_TAG(fcpim, iotag);
+	bfa_assert(ioim->iotag == iotag);
+
+	bfa_trc_fp(ioim->bfa, ioim->iotag);
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_COMP_GOOD);
+}
+
+/**
+ * Called by itnim to clean up IO while going offline.
+ */
+void
+bfa_ioim_cleanup(struct bfa_ioim_s *ioim)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_fcpim_stats(ioim->fcpim, io_cleanups);
+
+	ioim->iosp->tskim = NULL;
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_CLEANUP);
+}
+
+void
+bfa_ioim_cleanup_tm(struct bfa_ioim_s *ioim, struct bfa_tskim_s *tskim)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_fcpim_stats(ioim->fcpim, io_tmaborts);
+
+	ioim->iosp->tskim = tskim;
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_CLEANUP);
+}
+
+/**
+ * IOC failure handling.
+ */
+void
+bfa_ioim_iocdisable(struct bfa_ioim_s *ioim)
+{
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_HWFAIL);
+}
+
+/**
+ * IO offline TOV popped. Fail the pending IO.
+ */
+void
+bfa_ioim_tov(struct bfa_ioim_s *ioim)
+{
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_IOTOV);
+}
+
+
+
+/**
+ *  hal_ioim_api
+ */
+
+/**
+ * Allocate IOIM resource for initiator mode I/O request.
+ */
+struct bfa_ioim_s *
+bfa_ioim_alloc(struct bfa_s *bfa, struct bfad_ioim_s *dio,
+		struct bfa_itnim_s *itnim, u16 nsges)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	struct bfa_ioim_s *ioim;
+
+	/**
+	 * alocate IOIM resource
+	 */
+	bfa_q_deq(&fcpim->ioim_free_q, &ioim);
+	if (!ioim) {
+		bfa_fcpim_stats(fcpim, no_iotags);
+		return NULL;
+	}
+
+	ioim->dio = dio;
+	ioim->itnim = itnim;
+	ioim->nsges = nsges;
+	ioim->nsgpgs = 0;
+
+	bfa_stats(fcpim, total_ios);
+	bfa_stats(itnim, ios);
+	fcpim->ios_active++;
+
+	list_add_tail(&ioim->qe, &itnim->io_q);
+	bfa_trc_fp(ioim->bfa, ioim->iotag);
+
+	return ioim;
+}
+
+void
+bfa_ioim_free(struct bfa_ioim_s *ioim)
+{
+	struct bfa_fcpim_mod_s *fcpim = ioim->fcpim;
+
+	bfa_trc_fp(ioim->bfa, ioim->iotag);
+	bfa_assert_fp(bfa_sm_cmp_state(ioim, bfa_ioim_sm_uninit));
+
+	bfa_assert_fp(list_empty(&ioim->sgpg_q)
+		   || (ioim->nsges > BFI_SGE_INLINE));
+
+	if (ioim->nsgpgs > 0)
+		bfa_sgpg_mfree(ioim->bfa, &ioim->sgpg_q, ioim->nsgpgs);
+
+	bfa_stats(ioim->itnim, io_comps); 
+	fcpim->ios_active--;
+
+	list_del(&ioim->qe);
+	list_add_tail(&ioim->qe, &fcpim->ioim_free_q);
+}
+
+void
+bfa_ioim_start(struct bfa_ioim_s *ioim)
+{
+	bfa_trc_fp(ioim->bfa, ioim->iotag);
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_START);
+}
+
+/**
+ * Driver I/O abort request.
+ */
+void
+bfa_ioim_abort(struct bfa_ioim_s *ioim)
+{
+	bfa_trc(ioim->bfa, ioim->iotag);
+	bfa_fcpim_stats(ioim->fcpim, io_aborts);
+	bfa_sm_send_event(ioim, BFA_IOIM_SM_ABORT);
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_itnim.c patch/drivers/scsi/bfa/bfa_itnim.c
--- orig/drivers/scsi/bfa/bfa_itnim.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_itnim.c	2009-03-14 11:44:57.184415000 -0700
@@ -0,0 +1,1145 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <bfa_fcpim.h>
+#include "bfa_fcpim.h"
+
+BFA_TRC_FILE(HAL, ITNIM);
+
+#define bfa_fcpim_additn(__itnim)					\
+	list_add_tail(&(__itnim)->qe, &(__itnim)->fcpim->itnim_q)
+#define bfa_fcpim_delitn(__itnim)	do {				\
+	bfa_assert(bfa_q_is_on_q(&(__itnim)->fcpim->itnim_q, __itnim) );      \
+	list_del(&(__itnim)->qe );      \
+	bfa_assert(list_empty(&(__itnim)->io_q) );      \
+	bfa_assert(list_empty(&(__itnim)->io_cleanup_q) );      \
+	bfa_assert(list_empty(&(__itnim)->pending_q) );      \
+} while (0)
+
+#define bfa_itnim_online_cb(__itnim) do {				\
+		bfa_cb_queue((__itnim)->bfa, &(__itnim)->hcb_qe,	\
+		__bfa_cb_itnim_online, (__itnim) );      \
+} while (0)
+
+#define bfa_itnim_offline_cb(__itnim) do {				\
+		bfa_cb_queue((__itnim)->bfa, &(__itnim)->hcb_qe,	\
+		__bfa_cb_itnim_offline, (__itnim) );      \
+} while (0)
+
+#define bfa_itnim_sler_cb(__itnim) do {					\
+	if (bfa_fw_disc_enabled((__itnim)->bfa)) 			\
+		bfa_rport_itnim_sler((__itnim)->ditn );      \
+	else {								\
+		bfa_cb_queue((__itnim)->bfa, &(__itnim)->hcb_qe,	\
+		__bfa_cb_itnim_sler, (__itnim) );      \
+	}								\
+} while (0)
+
+/*
+ * forward declarations
+ */
+static void     bfa_itnim_iocdisable_cleanup(struct bfa_itnim_s *itnim);
+static bfa_boolean_t bfa_itnim_send_fwcreate(struct bfa_itnim_s *itnim);
+static bfa_boolean_t bfa_itnim_send_fwdelete(struct bfa_itnim_s *itnim);
+static void     bfa_itnim_cleanp_comp(void *itnim_cbarg);
+static void     bfa_itnim_cleanup(struct bfa_itnim_s *itnim);
+static void     __bfa_cb_itnim_online(void *cbarg, bfa_boolean_t complete);
+static void     __bfa_cb_itnim_offline(void *cbarg, bfa_boolean_t complete);
+/*
+static void     __bfa_cb_itnim_sler(void *cbarg, bfa_boolean_t complete);
+*/
+static void     bfa_itnim_iotov_online(struct bfa_itnim_s *itnim);
+static void     bfa_itnim_iotov_cleanup(struct bfa_itnim_s *itnim);
+static void     bfa_itnim_iotov(void *itnim_arg);
+static void     bfa_itnim_iotov_start(struct bfa_itnim_s *itnim);
+static void     bfa_itnim_iotov_stop(struct bfa_itnim_s *itnim);
+static void     bfa_itnim_iotov_delete(struct bfa_itnim_s *itnim);
+
+static bfa_boolean_t bfa_itnim_send_prlo_rsp(struct bfa_itnim_s *itnim);
+
+/**
+ *  bfa_itnim_sm BFA itnim state machine
+ */
+
+
+enum bfa_itnim_event {
+	BFA_ITNIM_SM_CREATE = 1,	/*  itnim is created */
+	BFA_ITNIM_SM_ONLINE = 2,	/*  itnim is online */
+	BFA_ITNIM_SM_OFFLINE = 3,	/*  itnim is offline */
+	BFA_ITNIM_SM_FWRSP = 4,	/*  firmware response */
+	BFA_ITNIM_SM_DELETE = 5,	/*  deleting an existing itnim */
+	BFA_ITNIM_SM_CLEANUP = 6,	/*  IO cleanup completion */
+	BFA_ITNIM_SM_SLER = 7,	/*  second level error recovery */
+	BFA_ITNIM_SM_HWFAIL = 8,	/*  IOC h/w failure event */
+	
+	/*
+	 * These events are generated as part of
+	 * FCS functionality in fw
+	 */
+	BFA_ITNIM_SM_UP =  	9,	/*  fw created itnim instance */
+	BFA_ITNIM_SM_DOWN =	10,	/*  fw created itnim instance */
+	BFA_ITNIM_SM_PRLO =	11,	/*  prlo received */
+	
+};
+
+static void     bfa_itnim_sm_uninit(struct bfa_itnim_s *itnim,
+					enum bfa_itnim_event event);
+static void     bfa_itnim_sm_created(struct bfa_itnim_s *itnim,
+					 enum bfa_itnim_event event);
+static void     bfa_itnim_sm_fwcreate(struct bfa_itnim_s *itnim,
+					  enum bfa_itnim_event event);
+static void	bfa_itnim_sm_delete_pending(struct bfa_itnim_s *itnim,
+				enum bfa_itnim_event event);
+static void     bfa_itnim_sm_online(struct bfa_itnim_s *itnim,
+					enum bfa_itnim_event event);
+static void     bfa_itnim_sm_sler(struct bfa_itnim_s *itnim,
+				      enum bfa_itnim_event event);
+static void     bfa_itnim_sm_cleanup_offline(struct bfa_itnim_s *itnim,
+						 enum bfa_itnim_event event);
+static void     bfa_itnim_sm_cleanup_delete(struct bfa_itnim_s *itnim,
+						enum bfa_itnim_event event);
+static void     bfa_itnim_sm_fwdelete(struct bfa_itnim_s *itnim,
+					  enum bfa_itnim_event event);
+static void     bfa_itnim_sm_offline(struct bfa_itnim_s *itnim,
+					 enum bfa_itnim_event event);
+static void     bfa_itnim_sm_iocdisable(struct bfa_itnim_s *itnim,
+					    enum bfa_itnim_event event);
+static void     bfa_itnim_sm_deleting(struct bfa_itnim_s *itnim,
+					  enum bfa_itnim_event event);
+/**
+ * FW FCS related itnim states
+ */
+static void bfa_itnim_sm_up(struct bfa_itnim_s *itnim, enum bfa_itnim_event event);
+static void bfa_itnim_sm_cleanup_remove(struct bfa_itnim_s *itnim, enum bfa_itnim_event event);
+static void bfa_itnim_sm_cleanup_login(struct bfa_itnim_s *itnim, enum bfa_itnim_event event);
+
+/**
+ * 		Beginning/unallocated state - no events expected.
+ */
+static void
+bfa_itnim_sm_uninit(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_CREATE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_created);
+		itnim->is_online = BFA_FALSE;
+		bfa_fcpim_additn(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Beginning state, only online event expected.
+ */
+static void
+bfa_itnim_sm_created(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_ONLINE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_fwcreate);
+		bfa_itnim_send_fwcreate(itnim);
+		break;
+
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_uninit);
+		bfa_fcpim_delitn(itnim);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		break;
+
+	case BFA_ITNIM_SM_UP:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_up);
+		itnim->is_online = BFA_TRUE;
+		bfa_itnim_iotov_online(itnim);
+		bfa_cb_itnim_online(itnim->ditn);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Waiting for itnim create response from firmware.
+ */
+static void
+bfa_itnim_sm_fwcreate(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_FWRSP:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_online);
+		itnim->is_online = BFA_TRUE;
+		bfa_itnim_iotov_online(itnim);
+		bfa_itnim_online_cb(itnim);
+		break;
+
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_delete_pending);
+		break;
+
+	case BFA_ITNIM_SM_OFFLINE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_fwdelete);
+		bfa_itnim_send_fwdelete(itnim);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 	Waiting for itnim create response from firmware, a delete is pending.
+ */
+static void
+bfa_itnim_sm_delete_pending(struct bfa_itnim_s *itnim,
+				enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_FWRSP:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_deleting);
+		bfa_itnim_send_fwdelete(itnim);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_uninit);
+		bfa_fcpim_delitn(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Online state - normal parking state.
+ */
+static void
+bfa_itnim_sm_online(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_OFFLINE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_cleanup_offline);
+		itnim->is_online = BFA_FALSE;
+		bfa_itnim_iotov_start(itnim);
+		bfa_itnim_cleanup(itnim);
+		break;
+
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_cleanup_delete);
+		itnim->is_online = BFA_FALSE;
+		bfa_itnim_cleanup(itnim);
+		break;
+
+	case BFA_ITNIM_SM_SLER:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_sler);
+		itnim->is_online = BFA_FALSE;
+		bfa_itnim_iotov_start(itnim);
+		/* 
+		 * NOW SLER is routed thru' f/w 
+		 * so no SLER event is received in bfa
+		 * TODO: This code can be removed can be removed 
+		 * bfa_itnim_sler_cb(itnim);
+		 */
+		
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		itnim->is_online = BFA_FALSE;
+		bfa_itnim_iotov_start(itnim);
+		bfa_itnim_iocdisable_cleanup(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Second level error recovery need.
+ */
+static void
+bfa_itnim_sm_sler(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_OFFLINE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_cleanup_offline);
+		bfa_itnim_cleanup(itnim);
+		break;
+
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_cleanup_delete);
+		bfa_itnim_cleanup(itnim);
+		bfa_itnim_iotov_delete(itnim);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		bfa_itnim_iocdisable_cleanup(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Going offline. Waiting for active IO cleanup.
+ */
+static void
+bfa_itnim_sm_cleanup_offline(struct bfa_itnim_s *itnim,
+				 enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_CLEANUP:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_fwdelete);
+		bfa_itnim_send_fwdelete(itnim);
+		break;
+
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_cleanup_delete);
+		bfa_itnim_iotov_delete(itnim);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		bfa_itnim_iocdisable_cleanup(itnim);
+		bfa_itnim_offline_cb(itnim);
+		break;
+
+	case BFA_ITNIM_SM_SLER:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Deleting itnim. Waiting for active IO cleanup.
+ */
+static void
+bfa_itnim_sm_cleanup_delete(struct bfa_itnim_s *itnim,
+				enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_CLEANUP:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_deleting);
+		bfa_itnim_send_fwdelete(itnim);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		bfa_itnim_iocdisable_cleanup(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Rport offline. Fimrware itnim is being deleted - awaiting f/w response.
+ */
+static void
+bfa_itnim_sm_fwdelete(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_FWRSP:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_offline);
+		bfa_itnim_offline_cb(itnim);
+		break;
+
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_deleting);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		bfa_itnim_offline_cb(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Offline state.
+ */
+static void
+bfa_itnim_sm_offline(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_uninit);
+		bfa_itnim_iotov_delete(itnim);
+		bfa_fcpim_delitn(itnim);
+		break;
+
+	case BFA_ITNIM_SM_ONLINE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_fwcreate);
+		bfa_itnim_send_fwcreate(itnim);
+		break;
+
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		IOC h/w failed state.
+ */
+static void
+bfa_itnim_sm_iocdisable(struct bfa_itnim_s *itnim,
+			    enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_DELETE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_uninit);
+		bfa_itnim_iotov_delete(itnim);
+		bfa_fcpim_delitn(itnim);
+		break;
+
+	case BFA_ITNIM_SM_OFFLINE:
+		bfa_itnim_offline_cb(itnim);
+		break;
+
+	case BFA_ITNIM_SM_ONLINE:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_fwcreate);
+		bfa_itnim_send_fwcreate(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Itnim is deleted, waiting for firmware response to delete.
+ */
+static void
+bfa_itnim_sm_deleting(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case BFA_ITNIM_SM_FWRSP:
+	case BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_uninit);
+		bfa_fcpim_delitn(itnim);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Itnim is created in f/w and is current up & ready for IO.
+ */
+static void
+bfa_itnim_sm_up(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case	BFA_ITNIM_SM_OFFLINE:
+	case	BFA_ITNIM_SM_PRLO:
+		if (event == BFA_ITNIM_SM_OFFLINE) 
+			bfa_sm_set_state(itnim, bfa_itnim_sm_cleanup_remove);
+		else
+			bfa_sm_set_state(itnim, bfa_itnim_sm_cleanup_login);
+
+		itnim->is_online = BFA_FALSE;
+		bfa_itnim_iotov_start(itnim);
+		bfa_cb_itnim_offline(itnim->ditn);
+		bfa_itnim_cleanup(itnim);
+	break;
+
+	case	BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		itnim->is_online = BFA_FALSE;
+		bfa_itnim_iotov_start(itnim);
+		bfa_itnim_iocdisable_cleanup(itnim);
+	break;
+
+	default:
+		bfa_assert(0);
+	}
+} 
+
+/**
+ * 		Itnim io clean up in progress. Delete itnim after cleanup complete
+ */
+static void
+bfa_itnim_sm_cleanup_remove(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case	BFA_ITNIM_SM_CLEANUP:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_uninit);
+		bfa_fcpim_delitn(itnim);
+		bfa_rport_cleanup_cb(itnim->bfa, itnim->rport);
+	break;
+
+	case	BFA_ITNIM_SM_HWFAIL:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_iocdisable);
+		/*
+		 * TODO: io cleanup in progress what now ??
+		 */ 
+	break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * 		Itnim io clean up in progress. Relogin after cleanup complete
+ */
+static void
+bfa_itnim_sm_cleanup_login(struct bfa_itnim_s *itnim, enum bfa_itnim_event event)
+{
+	bfa_trc(itnim->bfa, itnim->rport->rport_tag);
+	bfa_trc(itnim->bfa, event);
+
+	switch (event) {
+	case	BFA_ITNIM_SM_CLEANUP:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_created);
+		itnim->is_online = BFA_FALSE;
+		bfa_itnim_send_prlo_rsp(itnim);
+	break;
+
+	case	BFA_ITNIM_SM_UP:
+		bfa_sm_set_state(itnim, bfa_itnim_sm_up);
+		itnim->is_online = BFA_TRUE;
+		bfa_itnim_iotov_online(itnim);
+		bfa_itnim_online_cb(itnim);
+
+	break;
+
+	case	BFA_ITNIM_SM_HWFAIL:
+		/*
+		 * TODO: io cleanup in progress what now ??
+		 */ 
+	break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  bfa_itnim_private
+ */
+
+/**
+ * 		Initiate cleanup of all IOs on an IOC failure.
+ */
+static void
+bfa_itnim_iocdisable_cleanup(struct bfa_itnim_s *itnim)
+{
+	struct bfa_tskim_s *tskim;
+	struct bfa_ioim_s *ioim;
+	struct list_head        *qe, *qen;
+
+	list_for_each_safe(qe, qen, &itnim->tsk_q) {
+		tskim = (struct bfa_tskim_s *) qe;
+		bfa_tskim_iocdisable(tskim);
+	}
+
+	list_for_each_safe(qe, qen, &itnim->io_q) {
+		ioim = (struct bfa_ioim_s *) qe;
+		bfa_ioim_iocdisable(ioim);
+	}
+
+	/**
+	 * For IO request in pending queue, we pretend an early timeout.
+	 */
+	list_for_each_safe(qe, qen, &itnim->pending_q) {
+		ioim = (struct bfa_ioim_s *) qe;
+		bfa_ioim_tov(ioim);
+	}
+
+	list_for_each_safe(qe, qen, &itnim->io_cleanup_q) {
+		ioim = (struct bfa_ioim_s *) qe;
+		bfa_ioim_iocdisable(ioim);
+	}
+}
+
+/**
+ * 		IO cleanup completion
+ */
+static void
+bfa_itnim_cleanp_comp(void *itnim_cbarg)
+{
+	struct bfa_itnim_s *itnim = itnim_cbarg;
+
+	bfa_sm_send_event(itnim, BFA_ITNIM_SM_CLEANUP);
+}
+
+/**
+ * 		Initiate cleanup of all IOs.
+ */
+static void
+bfa_itnim_cleanup(struct bfa_itnim_s *itnim)
+{
+	struct bfa_ioim_s  *ioim;
+	struct bfa_tskim_s *tskim;
+	struct list_head         *qe, *qen;
+
+	bfa_wc_init(&itnim->wc, bfa_itnim_cleanp_comp, itnim);
+
+	list_for_each_safe(qe, qen, &itnim->io_q) {
+		ioim = (struct bfa_ioim_s *) qe;
+
+		/**
+		 * Move IO to a cleanup queue from active queue so that a later
+		 * TM will not pickup this IO.
+		 */
+		list_del(&ioim->qe);
+		list_add_tail(&ioim->qe, &itnim->io_cleanup_q);
+
+		bfa_wc_up(&itnim->wc);
+		bfa_ioim_cleanup(ioim);
+	}
+
+	list_for_each_safe(qe, qen, &itnim->tsk_q) {
+		tskim = (struct bfa_tskim_s *) qe;
+		bfa_wc_up(&itnim->wc);
+		bfa_tskim_cleanup(tskim);
+	}
+
+	bfa_wc_wait(&itnim->wc);
+}
+
+static void
+__bfa_cb_itnim_online(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_itnim_s *itnim = cbarg;
+
+	if (complete)
+		bfa_cb_itnim_online(itnim->ditn);
+}
+
+static void
+__bfa_cb_itnim_offline(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_itnim_s *itnim = cbarg;
+
+	if (complete)
+		bfa_cb_itnim_offline(itnim->ditn);
+}
+
+#if 0
+static void
+__bfa_cb_itnim_sler(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_itnim_s *itnim = cbarg;
+
+	if (complete)
+		bfa_cb_itnim_sler(itnim->ditn);
+}
+#endif
+
+
+
+/**
+ *  bfa_itnim_public
+ */
+
+void
+bfa_itnim_iodone(struct bfa_itnim_s *itnim)
+{
+	bfa_wc_down(&itnim->wc);
+}
+
+void
+bfa_itnim_tskdone(struct bfa_itnim_s *itnim)
+{
+	bfa_wc_down(&itnim->wc);
+}
+
+void
+bfa_itnim_qresume(void *cbarg)
+{
+	bfa_assert(0);
+}
+
+void
+bfa_itnim_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+		u32 *dm_len)
+{
+	/**
+	 * ITN memory
+	 */
+	*km_len += cfg->fwcfg.num_rports * sizeof(struct bfa_itnim_s);
+}
+
+void
+bfa_itnim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
+{
+	struct bfa_s      *bfa = fcpim->bfa;
+	struct bfa_itnim_s *itnim;
+	int             i;
+
+	INIT_LIST_HEAD(&fcpim->itnim_q);
+
+	itnim = (struct bfa_itnim_s *) bfa_meminfo_kva(minfo);
+	fcpim->itnim_arr = itnim;
+
+	for (i = 0; i < fcpim->num_itnims; i++, itnim++) {
+		bfa_os_memset(itnim, 0, sizeof(struct bfa_itnim_s));
+		itnim->bfa = bfa;
+		itnim->fcpim = fcpim;
+		itnim->reqq = BFA_REQQ_QOS_LO;
+		itnim->rport = BFA_RPORT_FROM_TAG(bfa, i);
+		itnim->iotov_active = BFA_FALSE;
+		INIT_LIST_HEAD(&itnim->io_q);
+		INIT_LIST_HEAD(&itnim->io_cleanup_q);
+		INIT_LIST_HEAD(&itnim->pending_q);
+		INIT_LIST_HEAD(&itnim->tsk_q);
+		INIT_LIST_HEAD(&itnim->delay_comp_q);
+		bfa_sm_set_state(itnim, bfa_itnim_sm_uninit);
+	}
+
+	bfa_meminfo_kva(minfo) = (u8 *) itnim;
+}
+
+void
+bfa_itnim_iocdisable(struct bfa_itnim_s *itnim)
+{
+	bfa_sm_send_event(itnim, BFA_ITNIM_SM_HWFAIL);
+}
+
+static bfa_boolean_t
+bfa_itnim_send_fwcreate(struct bfa_itnim_s *itnim)
+{
+	struct bfi_itnim_create_req_s *m;
+
+	itnim->msg_no++;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(itnim->bfa, itnim->reqq);
+	if (!m) {
+		bfa_reqq_wait(itnim->bfa, itnim->reqq, &itnim->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_ITNIM, BFI_ITNIM_H2I_CREATE_REQ,
+			bfa_lpuid(itnim->bfa));
+	m->itnim_tag = itnim->rport->rport_tag;
+	m->class = FC_CLASS_3;
+	m->seq_rec = itnim->seq_rec;
+	m->msg_no = itnim->msg_no;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(itnim->bfa, itnim->reqq);
+	return BFA_TRUE;
+}
+
+static bfa_boolean_t
+bfa_itnim_send_fwdelete(struct bfa_itnim_s *itnim)
+{
+	struct bfi_itnim_delete_req_s *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(itnim->bfa, itnim->reqq);
+	if (!m) {
+		bfa_reqq_wait(itnim->bfa, itnim->reqq, &itnim->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_ITNIM, BFI_ITNIM_H2I_DELETE_REQ,
+			bfa_lpuid(itnim->bfa));
+	m->itnim_tag = itnim->rport->rport_tag;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(itnim->bfa, itnim->reqq);
+	return BFA_TRUE;
+}
+
+/**
+ * Cleanup all pending failed inflight requests.
+ */
+static void
+bfa_itnim_delayed_comp(struct bfa_itnim_s *itnim, bfa_boolean_t iotov)
+{
+	struct bfa_ioim_s *ioim;
+	struct list_head *qe, *qen;
+
+	list_for_each_safe(qe, qen, &itnim->delay_comp_q) {
+		ioim = (struct bfa_ioim_s *)qe;
+		bfa_ioim_delayed_comp(ioim, iotov);
+	}
+}
+
+static bfa_boolean_t
+bfa_itnim_send_prlo_rsp(struct bfa_itnim_s *itnim)
+{
+	struct bfi_itnim_delete_req_s *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(itnim->bfa, itnim->reqq);
+	if (!m) {
+		bfa_reqq_wait(itnim->bfa, itnim->reqq, &itnim->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_ITNIM, BFI_ITNIM_H2I_PRLO_RSP,
+			bfa_lpuid(itnim->bfa));
+	m->itnim_tag = itnim->rport->rport_tag;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(itnim->bfa, itnim->reqq);
+	return BFA_TRUE;
+}
+
+/**
+ * Start all pending IO requests.
+ */
+static void
+bfa_itnim_iotov_online(struct bfa_itnim_s *itnim)
+{
+	struct bfa_ioim_s *ioim;
+
+	bfa_itnim_iotov_stop(itnim);
+
+	/**
+	 * Abort all inflight IO requests in the queue
+	 */
+	bfa_itnim_delayed_comp(itnim, BFA_FALSE);
+
+	/**
+	 * Start all pending IO requests.
+	 */
+	while (!list_empty(&itnim->pending_q)) {
+		bfa_q_deq(&itnim->pending_q, &ioim);
+		list_add_tail(&ioim->qe, &itnim->io_q);
+		bfa_ioim_start(ioim);
+	}
+}
+
+/**
+ * Fail all pending IO requests
+ */
+static void
+bfa_itnim_iotov_cleanup(struct bfa_itnim_s *itnim)
+{
+	struct bfa_ioim_s *ioim;
+
+	/**
+	 * Fail all inflight IO requests in the queue
+	 */
+	bfa_itnim_delayed_comp(itnim, BFA_TRUE);
+
+	/**
+	 * Fail any pending IO requests.
+	 */
+	while (!list_empty(&itnim->pending_q)) {
+		bfa_q_deq(&itnim->pending_q, &ioim);
+		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
+		bfa_ioim_tov(ioim);
+	}
+}
+
+/**
+ * IO TOV timer callback. Fail any pending IO requests.
+ */
+static void
+bfa_itnim_iotov(void *itnim_arg)
+{
+	struct bfa_itnim_s *itnim = itnim_arg;
+
+	itnim->iotov_active = BFA_FALSE;
+
+	bfa_cb_itnim_tov_begin(itnim->ditn);
+	bfa_itnim_iotov_cleanup(itnim);
+	bfa_cb_itnim_tov(itnim->ditn);
+}
+
+/**
+ * Start IO TOV timer for failing back pending IO requests in offline state.
+ */
+static void
+bfa_itnim_iotov_start(struct bfa_itnim_s *itnim)
+{
+	if (itnim->fcpim->path_tov > 0) {
+
+		itnim->iotov_active = BFA_TRUE;
+		bfa_assert(bfa_itnim_hold_io(itnim));
+		bfa_timer_start(itnim->bfa, &itnim->timer,
+			bfa_itnim_iotov, itnim, itnim->fcpim->path_tov);
+	}
+}
+
+/**
+ * Stop IO TOV timer.
+ */
+static void
+bfa_itnim_iotov_stop(struct bfa_itnim_s *itnim)
+{
+	if (itnim->iotov_active) {
+		itnim->iotov_active = BFA_FALSE;
+		bfa_timer_stop(&itnim->timer);
+	}
+}
+
+/**
+ * Stop IO TOV timer.
+ */
+static void
+bfa_itnim_iotov_delete(struct bfa_itnim_s *itnim)
+{
+    bfa_boolean_t pathtov_active = BFA_FALSE;
+
+    if (itnim->iotov_active)
+		pathtov_active = BFA_TRUE;
+
+	bfa_itnim_iotov_stop(itnim);
+	if (pathtov_active)
+		bfa_cb_itnim_tov_begin(itnim->ditn);
+	bfa_itnim_iotov_cleanup(itnim);
+	if (pathtov_active)
+		bfa_cb_itnim_tov(itnim->ditn);
+}
+
+
+
+/**
+ *  bfa_itnim_public
+ */
+
+/**
+ * 		Itnim interrupt processing.
+ */
+void
+bfa_itnim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	union bfi_itnim_i2h_msg_u msg;
+	struct bfa_itnim_s *itnim;
+
+	bfa_trc(bfa, m->mhdr.msg_id);
+
+	msg.msg = m;
+
+	switch (m->mhdr.msg_id) {
+	case BFI_ITNIM_I2H_CREATE_RSP:
+		itnim = BFA_ITNIM_FROM_TAG(fcpim,
+					       msg.create_rsp->itnim_tag);
+		bfa_assert(msg.create_rsp->status == BFA_STATUS_OK);
+		bfa_stats(itnim, create_comps);
+		bfa_sm_send_event(itnim, BFA_ITNIM_SM_FWRSP);
+		break;
+
+	case BFI_ITNIM_I2H_DELETE_RSP:
+		itnim = BFA_ITNIM_FROM_TAG(fcpim,
+					       msg.delete_rsp->itnim_tag);
+		bfa_assert(msg.delete_rsp->status == BFA_STATUS_OK);
+		bfa_stats(itnim, delete_comps);
+		bfa_sm_send_event(itnim, BFA_ITNIM_SM_FWRSP);
+		break;
+
+	case BFI_ITNIM_I2H_SLER_EVENT:
+		itnim = BFA_ITNIM_FROM_TAG(fcpim,
+					       msg.sler_event->itnim_tag);
+		bfa_stats(itnim, sler_events);
+		bfa_sm_send_event(itnim, BFA_ITNIM_SM_SLER);
+		break;
+
+	case	BFI_ITNIM_I2H_UP:
+		itnim = BFA_ITNIM_FROM_TAG(fcpim,
+					       msg.add_event->itnim_tag);
+		/*
+		 * Note: ITNIM instance is already alloced & linked to active 
+		 * queue, but in online flag is false.
+		 */
+		/* Update all ITNIM fields */
+		itnim->seq_rec		= msg.add_event->seq_rec;
+		itnim->rec_support	= msg.add_event->rec_support;
+		itnim->task_retry_id	= msg.add_event->task_retry_id;
+		itnim->conf_comp	= msg.add_event->confirm;
+				
+		bfa_sm_send_event(itnim, BFA_ITNIM_SM_UP);
+
+		break;
+
+	case	BFI_ITNIM_I2H_DOWN:
+		itnim = BFA_ITNIM_FROM_TAG(fcpim,
+					       msg.add_event->itnim_tag);
+
+		bfa_sm_send_event(itnim, BFA_ITNIM_SM_DOWN);
+		break;
+
+	case	BFI_ITNIM_I2H_PRLO:
+		itnim = BFA_ITNIM_FROM_TAG(fcpim,
+					       msg.add_event->itnim_tag);
+		bfa_sm_send_event(itnim, BFA_ITNIM_SM_PRLO);
+		break;
+
+	default:
+		bfa_trc(bfa, m->mhdr.msg_id);
+		bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  bfa_itnim_api
+ */
+
+struct bfa_itnim_s *
+bfa_itnim_create(struct bfa_s *bfa, struct bfa_rport_s *rport, void *ditn)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	struct bfa_itnim_s *itnim;
+
+	itnim = BFA_ITNIM_FROM_TAG(fcpim, rport->rport_tag);
+	bfa_assert(itnim->rport == rport);
+
+	itnim->ditn = ditn;
+
+	bfa_stats(itnim, creates);
+	bfa_sm_send_event(itnim, BFA_ITNIM_SM_CREATE);
+
+	return (itnim);
+}
+
+void
+bfa_itnim_delete(struct bfa_itnim_s *itnim)
+{
+	bfa_stats(itnim, deletes);
+	bfa_sm_send_event(itnim, BFA_ITNIM_SM_DELETE);
+}
+
+void
+bfa_itnim_online(struct bfa_itnim_s *itnim, bfa_boolean_t seq_rec)
+{
+	itnim->seq_rec = seq_rec;
+	bfa_stats(itnim, onlines);
+	bfa_sm_send_event(itnim, BFA_ITNIM_SM_ONLINE);
+}
+
+void
+bfa_itnim_offline(struct bfa_itnim_s *itnim)
+{
+	bfa_stats(itnim, offlines);
+	bfa_sm_send_event(itnim, BFA_ITNIM_SM_OFFLINE);
+}
+
+/**
+ * Return true if itnim is considered offline for holding off IO request.
+ * IO is not held if itnim is being deleted.
+ */
+bfa_boolean_t
+bfa_itnim_hold_io(struct bfa_itnim_s *itnim)
+{
+	return (
+		itnim->fcpim->path_tov && itnim->iotov_active &&
+		(bfa_sm_cmp_state(itnim, bfa_itnim_sm_fwcreate) ||
+		 bfa_sm_cmp_state(itnim, bfa_itnim_sm_sler) ||
+		 bfa_sm_cmp_state(itnim, bfa_itnim_sm_cleanup_offline) ||
+		 bfa_sm_cmp_state(itnim, bfa_itnim_sm_fwdelete) ||
+		 bfa_sm_cmp_state(itnim, bfa_itnim_sm_offline) ||
+		 bfa_sm_cmp_state(itnim, bfa_itnim_sm_iocdisable))
+);
+}
+
+void
+bfa_itnim_get_stats(struct bfa_itnim_s *itnim,
+	struct bfa_itnim_stats_s *stats)
+{
+	memcpy(&itnim->itnim_stats.hal_stats, &itnim->stats, 
+		sizeof(struct bfa_itnim_hal_stats_s));
+	*stats = itnim->itnim_stats;
+}
+
+void
+bfa_itnim_clear_stats(struct bfa_itnim_s *itnim)
+{
+	bfa_os_memset(&itnim->stats, 0, sizeof(itnim->stats));
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_log.c patch/drivers/scsi/bfa/bfa_log.c
--- orig/drivers/scsi/bfa/bfa_log.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_log.c	2009-03-14 11:44:57.193547000 -0700
@@ -0,0 +1,344 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_log.c BFA log library
+ */
+
+#include <bfa_os_inc.h>
+#include <cs/bfa_log.h>
+
+/*
+ * global log info structure
+ */
+struct bfa_log_info_s {
+	u32        start_idx;	/*  start index for a module */
+	u32        total_count;	/*  total count for a module */
+	enum bfa_log_severity level;	/*  global log level */
+	bfa_log_cb_t	cbfn;		/*  callback function */
+};
+
+static struct bfa_log_info_s bfa_log_info[BFA_LOG_MODULE_ID_MAX + 1];
+static u32 bfa_log_msg_total_count;
+static int      bfa_log_initialized;
+
+static char    *bfa_log_severity[] =
+	{ "[none]", "[critical]", "[error]", "[warn]", "[info]" };
+
+/**
+ * BFA log library initialization
+ *
+ * The log library initialization includes the following,
+ *    - set log instance name and callback function
+ *    - read the message array generated from xml files
+ *    - calculate start index for each module
+ *    - calculate message count for each module
+ *    - perform error checking
+ *
+ * @param[in] log_mod - log module info
+ * @param[in] instance_name - instance name
+ * @param[in] cbfn - callback function
+ *
+ * It return 0 on success, or -1 on failure
+ */
+int
+bfa_log_init(struct bfa_log_mod_s *log_mod, char *instance_name,
+			bfa_log_cb_t cbfn)
+{
+	struct bfa_log_msgdef_s *msg;
+	u32        pre_mod_id = 0;
+	u32        cur_mod_id = 0;
+	u32        i, pre_idx, idx, msg_id;
+
+	/*
+	 * set instance name
+	 */
+	if (log_mod) {
+		strncpy(log_mod->instance_info, instance_name,
+			sizeof(log_mod->instance_info));
+		log_mod->cbfn = cbfn;
+		for (i = 0; i <= BFA_LOG_MODULE_ID_MAX; i++)
+			log_mod->log_level[i] = BFA_LOG_WARNING;
+	}
+
+	if (bfa_log_initialized)
+		return 0;
+
+	for (i = 0; i <= BFA_LOG_MODULE_ID_MAX; i++) {
+		bfa_log_info[i].start_idx = 0;
+		bfa_log_info[i].total_count = 0;
+		bfa_log_info[i].level = BFA_LOG_WARNING;
+		bfa_log_info[i].cbfn = cbfn;
+	}
+
+	pre_idx = 0;
+	idx = 0;
+	msg = bfa_log_msg_array;
+	msg_id = BFA_LOG_GET_MSG_ID(msg);
+	pre_mod_id = BFA_LOG_GET_MOD_ID(msg_id);
+	while (msg_id != 0) {
+		cur_mod_id = BFA_LOG_GET_MOD_ID(msg_id);
+
+		if (cur_mod_id > BFA_LOG_MODULE_ID_MAX) {
+			cbfn(log_mod, msg_id,
+				"%s%s log: module id %u out of range\n",
+				BFA_LOG_CAT_NAME,
+				bfa_log_severity[BFA_LOG_ERROR],
+				cur_mod_id);
+			return -1;
+		}
+
+		if (pre_mod_id > BFA_LOG_MODULE_ID_MAX) {
+			cbfn(log_mod, msg_id,
+				"%s%s log: module id %u out of range\n",
+				BFA_LOG_CAT_NAME,
+				bfa_log_severity[BFA_LOG_ERROR],
+				pre_mod_id);
+			return -1;
+		}
+
+		if (cur_mod_id != pre_mod_id) {
+			bfa_log_info[pre_mod_id].start_idx = pre_idx;
+			bfa_log_info[pre_mod_id].total_count = idx - pre_idx;
+			pre_mod_id = cur_mod_id;
+			pre_idx = idx;
+		}
+
+		idx++;
+		msg++;
+		msg_id = BFA_LOG_GET_MSG_ID(msg);
+	}
+
+	bfa_log_info[cur_mod_id].start_idx = pre_idx;
+	bfa_log_info[cur_mod_id].total_count = idx - pre_idx;
+	bfa_log_msg_total_count = idx;
+
+	cbfn(log_mod, msg_id, "%s%s log: init OK, msg total count %u\n",
+		BFA_LOG_CAT_NAME,
+		bfa_log_severity[BFA_LOG_INFO], bfa_log_msg_total_count);
+
+	bfa_log_initialized = 1;
+
+	return 0;
+}
+
+/**
+ * BFA log set log level for a module
+ *
+ * @param[in] log_mod - log module info
+ * @param[in] mod_id - module id
+ * @param[in] log_level - log severity level
+ *
+ * It return BFA_STATUS_OK on success, or > 0 on failure
+ */
+bfa_status_t
+bfa_log_set_level(struct bfa_log_mod_s *log_mod, int mod_id,
+		  enum bfa_log_severity log_level)
+{
+	if (mod_id <= BFA_LOG_UNUSED_ID || mod_id > BFA_LOG_MODULE_ID_MAX)
+		return BFA_STATUS_EINVAL;
+
+	if (log_level <= BFA_LOG_INVALID || log_level > BFA_LOG_LEVEL_MAX)
+		return BFA_STATUS_EINVAL;
+
+	if (log_mod)
+		log_mod->log_level[mod_id] = log_level;
+	else
+		bfa_log_info[mod_id].level = log_level;
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * BFA log set log level for all modules
+ *
+ * @param[in] log_mod - log module info
+ * @param[in] log_level - log severity level
+ *
+ * It return BFA_STATUS_OK on success, or > 0 on failure
+ */
+bfa_status_t
+bfa_log_set_level_all(struct bfa_log_mod_s *log_mod,
+		  enum bfa_log_severity log_level)
+{
+	int mod_id = BFA_LOG_UNUSED_ID + 1;
+
+	if (log_level <= BFA_LOG_INVALID || log_level > BFA_LOG_LEVEL_MAX)
+		return BFA_STATUS_EINVAL;
+
+	if (log_mod) {
+		for (; mod_id <= BFA_LOG_MODULE_ID_MAX; mod_id++)
+			log_mod->log_level[mod_id] = log_level;
+	} else {
+		for (; mod_id <= BFA_LOG_MODULE_ID_MAX; mod_id++)
+			bfa_log_info[mod_id].level = log_level;
+	}
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * BFA log set log level for all aen sub-modules
+ *
+ * @param[in] log_mod - log module info
+ * @param[in] log_level - log severity level
+ *
+ * It return BFA_STATUS_OK on success, or > 0 on failure
+ */
+bfa_status_t
+bfa_log_set_level_aen(struct bfa_log_mod_s *log_mod,
+		  enum bfa_log_severity log_level)
+{
+	int mod_id = BFA_LOG_AEN_MIN + 1;
+
+	if (log_mod) {
+		for (; mod_id <= BFA_LOG_AEN_MAX; mod_id++)
+			log_mod->log_level[mod_id] = log_level;
+	} else {
+		for (; mod_id <= BFA_LOG_AEN_MAX; mod_id++)
+			bfa_log_info[mod_id].level = log_level;
+	}
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ * BFA log get log level for a module
+ *
+ * @param[in] log_mod - log module info
+ * @param[in] mod_id - module id
+ *
+ * It returns log level or -1 on error
+ */
+enum bfa_log_severity
+bfa_log_get_level(struct bfa_log_mod_s *log_mod, int mod_id)
+{
+	if (mod_id <= BFA_LOG_UNUSED_ID || mod_id > BFA_LOG_MODULE_ID_MAX)
+		return BFA_LOG_INVALID;
+
+	if (log_mod)
+		return (log_mod->log_level[mod_id]);
+	else
+		return (bfa_log_info[mod_id].level);
+}
+
+enum bfa_log_severity
+bfa_log_get_msg_level(struct bfa_log_mod_s *log_mod, u32 msg_id)
+{
+	struct bfa_log_msgdef_s *msg;
+	u32        mod = BFA_LOG_GET_MOD_ID(msg_id);
+	u32        idx = BFA_LOG_GET_MSG_IDX(msg_id) - 1;
+
+	if (!bfa_log_initialized)
+		return BFA_LOG_INVALID;
+
+	if (mod > BFA_LOG_MODULE_ID_MAX)
+		return BFA_LOG_INVALID;
+
+	if (idx >= bfa_log_info[mod].total_count) {
+		bfa_log_info[mod].cbfn(log_mod, msg_id,
+			"%s%s log: inconsistent idx %u vs. total count %u\n",
+			BFA_LOG_CAT_NAME, bfa_log_severity[BFA_LOG_ERROR], idx,
+			bfa_log_info[mod].total_count);
+		return BFA_LOG_INVALID;
+	}
+
+	msg = bfa_log_msg_array + bfa_log_info[mod].start_idx + idx;
+	if (msg_id != BFA_LOG_GET_MSG_ID(msg)) {
+		bfa_log_info[mod].cbfn(log_mod, msg_id,
+			"%s%s log: inconsistent msg id %u array msg id %u\n",
+			BFA_LOG_CAT_NAME, bfa_log_severity[BFA_LOG_ERROR],
+			msg_id, BFA_LOG_GET_MSG_ID(msg));
+		return BFA_LOG_INVALID;
+	}
+
+	return BFA_LOG_GET_SEVERITY(msg);
+}
+
+/**
+ * BFA log message handling
+ *
+ * BFA log message handling finds the message based on message id and prints
+ * out the message based on its format and arguments. It also does prefix
+ * the severity etc.
+ *
+ * @param[in] log_mod - log module info
+ * @param[in] msg_id - message id
+ * @param[in] ... - message arguments
+ *
+ * It return 0 on success, or -1 on errors
+ */
+int
+bfa_log(struct bfa_log_mod_s *log_mod, u32 msg_id, ...)
+{
+	va_list         ap;
+	char            buf[256];
+	struct bfa_log_msgdef_s *msg;
+	int             log_level;
+	u32        mod = BFA_LOG_GET_MOD_ID(msg_id);
+	u32        idx = BFA_LOG_GET_MSG_IDX(msg_id) - 1;
+
+	if (!bfa_log_initialized)
+		return -1;
+
+	if (mod > BFA_LOG_MODULE_ID_MAX)
+		return -1;
+
+	if (idx >= bfa_log_info[mod].total_count) {
+		bfa_log_info[mod].
+			cbfn
+			(log_mod, msg_id,
+			"%s%s log: inconsistent idx %u vs. total count %u\n",
+			BFA_LOG_CAT_NAME, bfa_log_severity[BFA_LOG_ERROR], idx,
+			bfa_log_info[mod].total_count);
+		return -1;
+	}
+
+	msg = bfa_log_msg_array + bfa_log_info[mod].start_idx + idx;
+	if (msg_id != BFA_LOG_GET_MSG_ID(msg)) {
+		bfa_log_info[mod].
+			cbfn
+			(log_mod, msg_id,
+			"%s%s log: inconsistent msg id %u array msg id %u\n",
+			BFA_LOG_CAT_NAME, bfa_log_severity[BFA_LOG_ERROR],
+			msg_id, BFA_LOG_GET_MSG_ID(msg));
+		return -1;
+	}
+
+	log_level = log_mod ? log_mod->log_level[mod] : bfa_log_info[mod].level;
+	if (BFA_LOG_GET_SEVERITY(msg) > log_level)
+		return 0;
+
+	va_start(ap, msg_id);
+	bfa_os_vsprintf(buf, BFA_LOG_GET_MSG_FMT_STRING(msg), ap);
+	va_end(ap);
+
+	if (log_mod)
+		log_mod->cbfn(log_mod, msg_id, "%s[%s]%s%s %s: %s\n",
+				BFA_LOG_CAT_NAME, log_mod->instance_info,
+				bfa_log_severity[BFA_LOG_GET_SEVERITY(msg)],
+				(msg->attributes & BFA_LOG_ATTR_AUDIT)
+				? " (audit) " : "", msg->msg_value, buf);
+	else
+		bfa_log_info[mod].cbfn(log_mod, msg_id, "%s%s%s %s: %s\n",
+				BFA_LOG_CAT_NAME,
+				bfa_log_severity[BFA_LOG_GET_SEVERITY(msg)],
+				(msg->attributes & BFA_LOG_ATTR_AUDIT) ?
+				" (audit) " : "", msg->msg_value, buf);
+
+	return 0;
+}
diff -urpN orig/drivers/scsi/bfa/bfa_log_module.c patch/drivers/scsi/bfa/bfa_log_module.c
--- orig/drivers/scsi/bfa/bfa_log_module.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_log_module.c	2009-03-14 11:44:57.201560000 -0700
@@ -0,0 +1,443 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+/*
+ *  Copyright (c) 2008 by Brocade Communications Systems, Inc.
+ *  All rights reserved.
+ *
+ *  File Name:      bfa_log_module.c
+ *
+ *  PLEASE DO NOT EDIT THIS FILE. THIS FILE IS AUTO GENERATED!!
+ *
+ *  Description:
+ *
+ *  The log messages defined in each XML files will be converted to a C code
+ *  style message file. The message file will be named the same as XML file.
+ *
+ *  These coded instructions and statements contain unpublished trade
+ *  secrets and proprietary information.  They are protected by federal
+ *  copyright law and by trade secret law, and may not be disclosed to
+ *  third parties or used, copied, or duplicated in any form, in whole
+ *  or in part, without the prior written consent of Brocade Communications.
+ *
+ */
+#include <cs/bfa_log.h>
+#include <aen/bfa_aen_adapter.h>
+#include <aen/bfa_aen_audit.h>
+#include <aen/bfa_aen_ethport.h>
+#include <aen/bfa_aen_ioc.h>
+#include <aen/bfa_aen_itnim.h>
+#include <aen/bfa_aen_lport.h>
+#include <aen/bfa_aen_port.h>
+#include <aen/bfa_aen_rport.h>
+#include <log/bfa_log_fcs.h>
+#include <log/bfa_log_hal.h>
+#include <log/bfa_log_linux.h>
+#include <log/bfa_log_wdrv.h>
+
+struct bfa_log_msgdef_s bfa_log_msg_array[] = {
+
+
+/* messages define for BFA_AEN_CAT_ADAPTER Module */
+{BFA_AEN_ADAPTER_ADD, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_ADAPTER_ADD",
+ "New adapter found: SN = %s, base port WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_ADAPTER_REMOVE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_WARNING, "BFA_AEN_ADAPTER_REMOVE",
+ "Adapter removed: SN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+
+
+
+/* messages define for BFA_AEN_CAT_AUDIT Module */
+{BFA_AEN_AUDIT_AUTH_ENABLE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "BFA_AEN_AUDIT_AUTH_ENABLE",
+ "Authentication enabled for base port: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_AUDIT_AUTH_DISABLE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "BFA_AEN_AUDIT_AUTH_DISABLE",
+ "Authentication disabled for base port: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+
+
+
+/* messages define for BFA_AEN_CAT_ETHPORT Module */
+{BFA_AEN_ETHPORT_LINKUP, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_ETHPORT_LINKUP",
+ "Base port ethernet linkup: mac = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_ETHPORT_LINKDOWN, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_ETHPORT_LINKDOWN",
+ "Base port ethernet linkdown: mac = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_ETHPORT_ENABLE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_ETHPORT_ENABLE",
+ "Base port ethernet link enabled: mac = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_ETHPORT_DISABLE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_ETHPORT_DISABLE",
+ "Base port ethernet link disabled: mac = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+
+
+
+/* messages define for BFA_AEN_CAT_IOC Module */
+{BFA_AEN_IOC_HBGOOD, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_IOC_HBGOOD",
+ "Heart Beat of IOC %d is good.",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_IOC_HBFAIL, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_CRITICAL,
+ "BFA_AEN_IOC_HBFAIL",
+ "Heart Beat of IOC %d has failed.",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_IOC_ENABLE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_IOC_ENABLE",
+ "IOC %d is enabled.",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_IOC_DISABLE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_IOC_DISABLE",
+ "IOC %d is disabled.",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | 0), 1},
+
+
+
+
+/* messages define for BFA_AEN_CAT_ITNIM Module */
+{BFA_AEN_ITNIM_ONLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_ITNIM_ONLINE",
+ "Target (WWN = %s) is online for initiator (WWN = %s).",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_ITNIM_OFFLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_ITNIM_OFFLINE",
+ "Target (WWN = %s) offlined by initiator (WWN = %s).",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_ITNIM_DISCONNECT, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_ERROR, "BFA_AEN_ITNIM_DISCONNECT",
+ "Target (WWN = %s) connectivity lost for initiator (WWN = %s).",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+
+
+
+/* messages define for BFA_AEN_CAT_LPORT Module */
+{BFA_AEN_LPORT_NEW, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_LPORT_NEW",
+ "New logical port created: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_DELETE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_LPORT_DELETE",
+ "Logical port deleted: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_ONLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_LPORT_ONLINE",
+ "Logical port online: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_OFFLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_LPORT_OFFLINE",
+ "Logical port taken offline: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_DISCONNECT, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_ERROR, "BFA_AEN_LPORT_DISCONNECT",
+ "Logical port lost fabric connectivity: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_NEW_PROP, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_LPORT_NEW_PROP",
+ "New virtual port created using proprietary interface: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_DELETE_PROP, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "BFA_AEN_LPORT_DELETE_PROP",
+ "Virtual port deleted using proprietary interface: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_NEW_STANDARD, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "BFA_AEN_LPORT_NEW_STANDARD",
+ "New virtual port created using standard interface: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_DELETE_STANDARD, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "BFA_AEN_LPORT_DELETE_STANDARD",
+ "Virtual port deleted using standard interface: WWN = %s, Role = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_LPORT_NPIV_DUP_WWN, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_WARNING, "BFA_AEN_LPORT_NPIV_DUP_WWN",
+ "Virtual port login failed. Duplicate WWN = %s reported by fabric.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_LPORT_NPIV_FABRIC_MAX, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_WARNING, "BFA_AEN_LPORT_NPIV_FABRIC_MAX",
+ "Virtual port (WWN = %s) login failed. Max NPIV ports already exist in fabric/fport.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_LPORT_NPIV_UNKNOWN, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_WARNING, "BFA_AEN_LPORT_NPIV_UNKNOWN",
+ "Virtual port (WWN = %s) login failed.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+
+
+
+/* messages define for BFA_AEN_CAT_PORT Module */
+{BFA_AEN_PORT_ONLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_WARNING,
+ "BFA_AEN_PORT_ONLINE",
+ "Base port online: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_OFFLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_WARNING,
+ "BFA_AEN_PORT_OFFLINE",
+ "Base port offline: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_RLIR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_PORT_RLIR",
+ "RLIR event not supported.",
+ (0), 0},
+
+{BFA_AEN_PORT_SFP_INSERT, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_PORT_SFP_INSERT",
+ "New SFP found: port %d, WWN = %s.",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_PORT_SFP_REMOVE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_WARNING, "BFA_AEN_PORT_SFP_REMOVE",
+ "SFP removed: port %d, WWN = %s.",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_PORT_SFP_POM, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_WARNING,
+ "BFA_AEN_PORT_SFP_POM",
+ "SFP POM level to %s: port %d, WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_D << BFA_LOG_ARG1) |
+  (BFA_LOG_S << BFA_LOG_ARG2) | 0), 3},
+
+{BFA_AEN_PORT_ENABLE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_PORT_ENABLE",
+ "Base port enabled: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_DISABLE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_PORT_DISABLE",
+ "Base port disabled: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_AUTH_ON, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_PORT_AUTH_ON",
+ "Authentication successful for base port: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_AUTH_OFF, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_ERROR,
+ "BFA_AEN_PORT_AUTH_OFF",
+ "Authentication unsuccessful for base port: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_DISCONNECT, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_ERROR,
+ "BFA_AEN_PORT_DISCONNECT",
+ "Base port (WWN = %s) lost fabric connectivity.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_PORT_QOS_NEG, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_WARNING,
+ "BFA_AEN_PORT_QOS_NEG",
+ "QOS negotiation failed for base port: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+
+
+
+/* messages define for BFA_AEN_CAT_RPORT Module */
+{BFA_AEN_RPORT_ONLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_RPORT_ONLINE",
+ "Remote port (WWN = %s) online for logical port (WWN = %s).",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_RPORT_OFFLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_RPORT_OFFLINE",
+ "Remote port (WWN = %s) offlined by logical port (WWN = %s).",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_RPORT_DISCONNECT, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_ERROR, "BFA_AEN_RPORT_DISCONNECT",
+ "Remote port (WWN = %s) connectivity lost for logical port (WWN = %s).",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) | 0), 2},
+
+{BFA_AEN_RPORT_QOS_PRIO, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_RPORT_QOS_PRIO",
+ "QOS priority changed to %s: RPWWN = %s and LPWWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) |
+  (BFA_LOG_S << BFA_LOG_ARG2) | 0), 3},
+
+{BFA_AEN_RPORT_QOS_FLOWID, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "BFA_AEN_RPORT_QOS_FLOWID",
+ "QOS flow ID changed to %d: RPWWN = %s and LPWWN = %s.",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) |
+  (BFA_LOG_S << BFA_LOG_ARG2) | 0), 3},
+
+
+
+
+/* messages define for FCS Module */
+{BFA_LOG_FCS_FABRIC_NOSWITCH, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "FCS_FABRIC_NOSWITCH",
+ "No switched fabric presence is detected.",
+ (0), 0},
+
+{BFA_LOG_FCS_FABRIC_ISOLATED, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "FCS_FABRIC_ISOLATED",
+ "Port is isolated due to VF_ID mismatch. PWWN: %s, Port VF_ID: %04x and switch port VF_ID: %04x.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_X << BFA_LOG_ARG1) |
+  (BFA_LOG_X << BFA_LOG_ARG2) | 0), 3},
+
+
+
+
+/* messages define for HAL Module */
+{BFA_LOG_HAL_ASSERT, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_ERROR,
+ "HAL_ASSERT",
+ "Assertion failure: %s:%d: %s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_D << BFA_LOG_ARG1) |
+  (BFA_LOG_S << BFA_LOG_ARG2) | 0), 3},
+
+{BFA_LOG_HAL_HEARTBEAT_FAILURE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_CRITICAL, "HAL_HEARTBEAT_FAILURE",
+ "Firmware heartbeat failure at %d",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_HAL_FCPIM_PARM_INVALID, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "HAL_FCPIM_PARM_INVALID",
+ "Driver configuration %s value %d is invalid. Value should be within %d and %d.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_D << BFA_LOG_ARG1) |
+  (BFA_LOG_D << BFA_LOG_ARG2) | (BFA_LOG_D << BFA_LOG_ARG3) | 0), 4},
+
+
+
+
+/* messages define for LINUX Module */
+{BFA_LOG_LINUX_DEVICE_CLAIMED, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_DEVICE_CLAIMED",
+ "bfa device at %s claimed.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_HASH_INIT_FAILED, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_HASH_INIT_FAILED",
+ "Hash table initialization failure for the port %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_SYSFS_FAILED, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_SYSFS_FAILED",
+ "sysfs file creation failure for the port %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_MEM_ALLOC_FAILED, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_MEM_ALLOC_FAILED",
+ "Memory allocation failed: %s.  ",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_DRIVER_REGISTRATION_FAILED,
+ BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "LINUX_DRIVER_REGISTRATION_FAILED",
+ "%s.  ",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_ITNIM_FREE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "LINUX_ITNIM_FREE",
+ "scsi%d: FCID: %s WWPN: %s",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | (BFA_LOG_S << BFA_LOG_ARG1) |
+  (BFA_LOG_S << BFA_LOG_ARG2) | 0), 3},
+
+{BFA_LOG_LINUX_ITNIM_ONLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_ITNIM_ONLINE",
+ "Target: %d:0:%d FCID: %s WWPN: %s",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | (BFA_LOG_D << BFA_LOG_ARG1) |
+  (BFA_LOG_S << BFA_LOG_ARG2) | (BFA_LOG_S << BFA_LOG_ARG3) | 0), 4},
+
+{BFA_LOG_LINUX_ITNIM_OFFLINE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_ITNIM_OFFLINE",
+ "Target: %d:0:%d FCID: %s WWPN: %s",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | (BFA_LOG_D << BFA_LOG_ARG1) |
+  (BFA_LOG_S << BFA_LOG_ARG2) | (BFA_LOG_S << BFA_LOG_ARG3) | 0), 4},
+
+{BFA_LOG_LINUX_SCSI_HOST_FREE, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_SCSI_HOST_FREE",
+ "Free scsi%d",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_SCSI_ABORT, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "LINUX_SCSI_ABORT",
+ "scsi%d: abort cmnd %p, iotag %x",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | (BFA_LOG_P << BFA_LOG_ARG1) |
+  (BFA_LOG_X << BFA_LOG_ARG2) | 0), 3},
+
+{BFA_LOG_LINUX_SCSI_ABORT_COMP, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_SCSI_ABORT_COMP",
+ "scsi%d: complete abort 0x%p, iotag 0x%x",
+ ((BFA_LOG_D << BFA_LOG_ARG0) | (BFA_LOG_P << BFA_LOG_ARG1) |
+  (BFA_LOG_X << BFA_LOG_ARG2) | 0), 3},
+
+
+
+
+/* messages define for WDRV Module */
+{BFA_LOG_WDRV_IOC_INIT_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "WDRV_IOC_INIT_ERROR",
+ "IOC initialization has failed.",
+ (0), 0},
+
+{BFA_LOG_WDRV_IOC_INTERNAL_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "WDRV_IOC_INTERNAL_ERROR",
+ "IOC internal error.  ",
+ (0), 0},
+
+{BFA_LOG_WDRV_IOC_START_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "WDRV_IOC_START_ERROR",
+ "IOC could not be started.  ",
+ (0), 0},
+
+{BFA_LOG_WDRV_IOC_STOP_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "WDRV_IOC_STOP_ERROR",
+ "IOC could not be stopped.  ",
+ (0), 0},
+
+{BFA_LOG_WDRV_INSUFFICIENT_RESOURCES, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "WDRV_INSUFFICIENT_RESOURCES",
+ "Insufficient memory.  ",
+ (0), 0},
+
+{BFA_LOG_WDRV_BASE_ADDRESS_MAP_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "WDRV_BASE_ADDRESS_MAP_ERROR",
+ "Unable to map the IOC onto the system address space.  ",
+ (0), 0},
+
+
+{0, 0, 0, "", "", 0, 0},
+};
diff -urpN orig/drivers/scsi/bfa/bfa_lport.c patch/drivers/scsi/bfa/bfa_lport.c
--- orig/drivers/scsi/bfa/bfa_lport.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_lport.c	2009-03-14 11:44:57.209573000 -0700
@@ -0,0 +1,573 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  lport.c BFA LPORT 
+ */
+
+#include <bfa.h>
+#include <bfa_lport.h>
+#include <bfa_rport.h>
+#include <bfa_fabric.h>
+#include <bfi/bfi_lport.h>
+
+BFA_TRC_FILE(HAL, LPORT);
+BFA_MODULE(lport);
+
+/**
+ *  lport_priv BFA LPORT Private Functions 
+ */
+
+static void
+bfa_lport_event(struct bfa_lport_s *lport, enum bfi_lport_state_e state) 
+{
+	struct bfa_s *bfa = lport->bfa;
+
+	switch (state) {
+	case BFI_LPORT_ONLINE:
+		bfa_cb_lport_online(bfa->bfad, lport->port_cfg.roles,
+			bfa_vf_get_drv_vf(lport->fabric),
+			(lport->vport == NULL) ?  NULL :
+				bfa_vport_get_vpdrv(lport->vport));
+		break;
+
+	case BFI_LPORT_OFFLINE:
+		bfa_cb_lport_offline(bfa->bfad, lport->port_cfg.roles,
+			bfa_vf_get_drv_vf(lport->fabric),
+			(lport->vport == NULL) ?  NULL :
+				bfa_vport_get_vpdrv(lport->vport));
+		break;
+
+	case BFI_LPORT_DELETE:
+		bfa_cb_lport_delete(bfa->bfad, lport->port_cfg.roles,
+			bfa_vf_get_drv_vf(lport->fabric),
+			(lport->vport == NULL) ?  NULL :
+				bfa_vport_get_vpdrv(lport->vport));
+		break;
+	}
+}
+
+
+
+/**
+ *  lport_protected BFA LPORT Protected Functions
+ */
+
+/**
+ * Called by rport module when new rports are discovered.
+ */
+
+static void
+bfa_lport_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+		u32 *dm_len)
+{
+	if (cfg->fwcfg.num_lports < BFA_LPORT_MIN)
+		cfg->fwcfg.num_lports = BFA_LPORT_MIN;
+	if (cfg->fwcfg.num_lports > BFA_LPORT_MAX)
+		cfg->fwcfg.num_lports = BFA_LPORT_MAX;
+
+	*km_len += cfg->fwcfg.num_lports * sizeof(struct bfa_lptag_s);
+	*dm_len += cfg->fwcfg.num_lports * BFI_LPORT_PSNLEN;
+}
+
+static void
+bfa_lport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+	     struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_lport_mod_s *mod = BFA_LPORT_MOD(bfa);
+	struct bfa_lptag_s *lptag;
+	int i;
+        u32 psnbufsz;
+
+	INIT_LIST_HEAD(&mod->lptag_free_q);
+	INIT_LIST_HEAD(&mod->lptag_active_q);
+
+	lptag = (struct bfa_lptag_s *) bfa_meminfo_kva(meminfo);
+	mod->lptag_list = lptag;
+
+	mod->num_lptags = cfg->fwcfg.num_lports;
+
+	bfa_assert(mod->num_lptags
+		   && !(mod->num_lptags & (mod->num_lptags - 1)));
+
+	for (i = 0; i < mod->num_lptags; i++, lptag++) {
+		bfa_os_memset(lptag, 0, sizeof(struct bfa_lptag_s));
+		lptag->lport_tag = i;
+
+		/**
+		 *  0 is reserved for baseport 
+		 */
+		if (i)
+			list_add_tail(&lptag->qe, &mod->lptag_free_q);
+	}
+
+	/**
+	 * consume memory
+	 */
+	bfa_meminfo_kva(meminfo) = (u8 *) lptag;
+
+	psnbufsz = mod->num_lptags * BFI_LPORT_PSNLEN;
+	mod->psnbase.pa  = bfa_meminfo_dma_phys(meminfo);
+	bfa_meminfo_dma_phys(meminfo) += psnbufsz;
+
+	mod->psnbase.kva = bfa_meminfo_dma_virt(meminfo);
+	bfa_meminfo_dma_virt(meminfo) += psnbufsz;
+}
+
+static void
+bfa_lport_initdone(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_lport_detach(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_lport_start(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_lport_stop(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_lport_iocdisable(struct bfa_s *bfa)
+{
+}
+
+void
+bfa_lport_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
+{
+	union bfi_lport_i2h_msg_u msg;
+	struct bfa_lport_s *lport;
+
+	msg.msg = m;
+	switch (m->mhdr.msg_id) {
+	case BFI_LPORT_I2H_EVENT:
+		lport = BFA_LPORT_FROM_TAG(bfa, msg.event->lport_tag);
+		lport->pid = msg.event->pid;
+		bfa_lport_event(lport, msg.event->lport_state);
+		break;
+
+	default:
+		bfa_trc(bfa, m->mhdr.msg_id);
+		bfa_assert(0);
+	}
+}
+
+void 
+bfa_lport_init(struct bfa_lport_s *lport, struct bfa_s *bfa,
+        u16 fabric_tag, struct bfa_lptag_s *lport_tag,
+        struct bfa_port_cfg_s *port_cfg, struct bfa_vport_s *vport)
+{
+	struct bfa_lport_mod_s *mod = BFA_LPORT_MOD(bfa);
+	u8 *psn;
+
+	if (lport_tag) {
+		lport->lport_tag = lport_tag;
+		lport->lport_tag->lport = lport;
+		psn = (u8 *)mod->psnbase.kva +
+			(lport_tag->lport_tag * BFI_LPORT_PSNLEN);
+		memcpy((void *)psn, (void *)port_cfg->sym_name.symname,
+				BFI_LPORT_PSNLEN);
+	}else {
+		lport->lport_tag = BFA_LPTAG_FROM_TAG(bfa, 0);
+		lport->lport_tag->lport = lport;
+	}
+
+	lport->fabric_tag = fabric_tag;
+	lport->fabric = bfa_vf_lookup(bfa, fabric_tag);
+	lport->port_cfg.pwwn = port_cfg->pwwn;
+	lport->port_cfg.nwwn = port_cfg->nwwn;
+	lport->port_cfg.roles = port_cfg->roles;
+	memcpy(&lport->port_cfg.sym_name, &(port_cfg->sym_name), 
+		sizeof(struct bfa_port_symname_s));
+	lport->bfa = bfa;
+	lport->vport = vport;
+	/*TODO*/
+	bfa_cb_port_new(bfa->bfad, lport,
+			port_cfg->roles, NULL, NULL);
+}
+
+struct bfa_lptag_s *
+bfa_lport_tag_alloc(struct bfa_lport_mod_s *mod)
+{
+	struct bfa_lptag_s *lptag;
+
+	bfa_q_deq(&mod->lptag_free_q, &lptag);
+	if (lptag)
+		list_add_tail(&lptag->qe, &mod->lptag_active_q);
+
+	return (lptag);
+}
+
+void
+bfa_lport_tag_free(struct bfa_lptag_s *lptag)
+{
+        struct bfa_lport_mod_s *mod = BFA_LPORT_MOD(lptag->lport->bfa);
+
+        bfa_assert(bfa_q_is_on_q(&mod->lptag_active_q, lptag));
+	lptag->lport = NULL;
+        list_del(&lptag->qe);
+        list_add_tail(&lptag->qe, &mod->lptag_free_q);
+}
+
+void
+bfa_lport_msg_init(struct bfa_lport_s *lport, struct bfi_vport_create_req_s *m)
+{
+	struct bfa_lport_mod_s *mod = BFA_LPORT_MOD(lport->bfa);
+	u16 lport_tag = lport->lport_tag->lport_tag;
+
+	m->fabric_tag = lport->fabric_tag;
+	m->vport_tag = lport_tag;
+	m->lport_cfg.pwwn = lport->port_cfg.pwwn; 
+	m->lport_cfg.nwwn = lport->port_cfg.nwwn; 
+	m->lport_cfg.roles = lport->port_cfg.roles; 
+
+	bfa_dma_be_addr_set(m->psn_addr,
+		(mod->psnbase.pa + (lport_tag * BFI_LPORT_PSNLEN)));
+}
+
+bfa_boolean_t
+bfa_lport_is_initiator(struct bfa_s *bfa, u16 lport_tag)
+{
+	struct bfa_lport_s *lport;
+
+	lport = (struct bfa_lport_s *)BFA_LPORT_FROM_TAG(bfa, lport_tag);	
+	return(lport->port_cfg.roles & BFA_PORT_ROLE_FCP_IM);
+}
+
+bfa_boolean_t
+bfa_lport_is_target(struct bfa_s *bfa, u16 lport_tag)
+{
+	struct bfa_lport_s *lport;
+
+	lport = (struct bfa_lport_s *)BFA_LPORT_FROM_TAG(bfa, lport_tag);	
+	return(lport->port_cfg.roles & BFA_PORT_ROLE_FCP_TM);
+}
+
+
+
+/**
+ *  lport_api BFA LPORT API
+ */
+
+void
+bfa_cfg_base_port(struct bfa_s *bfa, struct bfa_port_cfg_s *port_cfg)
+{
+}
+
+/* This should be a Fabric function */
+struct bfa_lport_s *
+bfa_get_base_port(struct bfa_s *bfa)
+{
+	return (&bfa->fabric.bport);
+}
+
+#if 0
+wwn_t
+bfa_lport_get_rport(struct bfa_lport_s *port, wwn_t wwn, int index, int nrports,
+		bfa_boolean_t bwwn)
+{
+	struct list_head *qh, *qe;
+	struct bfa_rport_s *rport = NULL;
+	int i;
+	struct bfa_s *bfa;
+
+	if (port == NULL || nrports == 0)
+		return (wwn_t)0;
+
+	bfa = port->bfa;
+	bfa_trc(bfa, (u32) nrports);
+
+	i = 0;
+	qh = &port->rport_q;
+	qe = bfa_q_first(qh);
+
+	while ((qe != qh) && (i < nrports)) {
+		rport = (struct bfa_rport_s *)qe;
+		if (bfa_os_ntoh3b(rport->rport_info.pid) > 0xFFF000) {
+			qe = bfa_q_next(qe);
+			bfa_trc(bfa, (u32) rport->rport_info.pwwn);
+			bfa_trc(bfa, rport->rport_info.pid);
+			bfa_trc(bfa, i);
+			continue;
+		}
+
+		if(bwwn) {
+			if (!memcmp(&wwn, &rport->rport_info.pwwn, 8)) 
+				break;
+		}
+		else {
+			if (i == index)
+				break;
+		}
+
+		i++;
+		qe = bfa_q_next(qe);
+	}
+
+	bfa_trc(bfa, i);
+    if (rport) {
+	    return rport->rport_info.pwwn;
+    } else {
+        return (wwn_t) 0;
+    }
+}
+#endif
+
+void
+bfa_lport_get_rports(struct bfa_lport_s *port, wwn_t rport_wwns[], int *nrports)
+{
+}
+#if 0
+void
+bfa_lport_get_rports(struct bfa_lport_s *port, wwn_t rport_wwns[], int *nrports)
+{
+	struct list_head *qh, *qe;
+	struct bfa_rport_s *rport = NULL;
+	int i;
+	struct bfa_s *bfa;
+
+	if (port == NULL || rport_wwns == NULL || *nrports == 0)
+		return;
+
+	bfa = port->bfa;
+	bfa_trc(bfa, (u32) *nrports);
+
+	i = 0;
+	qh = &port->rport_q;
+	qe = bfa_q_first(qh);
+
+	while ((qe != qh) && (i < *nrports)) {
+		rport = (struct bfa_rport_s *) qe;
+		if (bfa_os_ntoh3b(rport->rport_info.pid) > 0xFFF000) {
+			qe = bfa_q_next(qe);
+			bfa_trc(bfa, (u32) rport->rport_info.pwwn);
+			bfa_trc(bfa, rport->rport_info.pid);
+			bfa_trc(bfa, i);
+			continue;
+		}
+
+		rport_wwns[i] = rport->rport_info.pwwn;
+
+		i++;
+		qe = bfa_q_next(qe);
+	}
+
+	bfa_trc(bfa, i);
+	*nrports = i;
+	return;
+}
+#endif
+
+/* This needs to be obtained from FW */
+/*
+ * Iterate's through all the rport's in the given port to
+ * determine the maximum operating speed.
+ */
+#if 0
+bfa_pport_speed_t
+bfa_lport_get_rport_max_speed(bfa_lport_t *port)
+{
+	bfa_q_t *qh, *qe;
+	bfa_rport_t *rport = NULL;
+	bfa_t *bfa;
+	bfa_pport_speed_t max_speed =0;
+	bfa_pport_attr_t  pport_attr;
+	bfa_pport_speed_t pport_speed;
+
+	if (port == NULL)
+		return 0;
+
+	bfa = port->bfa;
+
+	/* Get Physical port's current speed */
+	bfa_pport_get_attr(bfa, &pport_attr);
+	pport_speed = pport_attr.speed;
+	bfa_trc(bfa, pport_speed);
+
+	qh = &port->rport_q;
+	qe = bfa_q_first(qh);
+
+	while (qe != qh) {
+		rport = (bfa_rport_t *) qe;
+		if ((bfa_os_ntoh3b(rport->rport_info.pid) > 0xFFF000) ||
+			(bfa_rport_get_state(rport) ==  BFA_RPORT_OFFLINE)) {
+			qe = bfa_q_next(qe);
+			continue;
+		}
+
+		if ((rport->rport_info.rpsc_speed  == BFA_PPORT_SPEED_8GBPS) ||
+		    (rport->rport_info.rpsc_speed > pport_speed)) {
+			max_speed = rport->rport_info.rpsc_speed;
+			break;
+		}
+		else if (rport->rport_info.rpsc_speed > max_speed) {
+			max_speed = rport->rport_info.rpsc_speed;
+		}
+
+		qe = bfa_q_next(qe);
+	}
+
+	bfa_trc(bfa, max_speed);
+	return max_speed;
+}
+#endif
+
+struct bfa_lport_s *
+bfa_lport_lookup_port(struct bfa_s *bfa, u16 vf_id, wwn_t lpwwn)
+{
+	struct bfa_vport_s *vport;
+	bfa_vf_t *vf;
+
+	bfa_assert(bfa != NULL);
+
+	vf = bfa_vf_lookup(bfa, vf_id);
+	if (vf == NULL) {
+		bfa_trc(bfa, vf_id);
+		return (NULL);
+	}
+
+	if (!lpwwn || (vf->bport.port_cfg.pwwn == lpwwn))
+		return (&vf->bport);
+
+	vport = bfa_fabric_vport_lookup(vf, lpwwn);
+	if (vport)
+		return (&vport->lport);
+
+	return (NULL);
+}
+
+/*
+ *  API corresponding to VmWare's NPIV_VPORT_GETINFO.
+ */
+void
+bfa_lport_get_info(struct bfa_lport_s *port, struct bfa_port_info_s *port_info)
+{
+
+	bfa_trc(port->bfa, port->bfa->fabric.fabric_name);
+
+	if (port->vport == NULL) {
+		/*
+		 * This is a Physical port
+		 */
+		port_info->port_type = BFA_PORT_TYPE_PHYSICAL;
+
+		/*
+		 * @todo : need to fix the state & reason
+		 */
+		port_info->port_state = 0;
+		port_info->offline_reason = 0;
+
+		port_info->port_wwn = bfa_lport_get_pwwn(port);
+		port_info->node_wwn = bfa_lport_get_nwwn(port);
+
+		port_info->max_vports_supp = BFA_MAX_VPORTS_SUPP;
+		port_info->num_vports_inuse =
+			bfa_fabric_vport_count(&port->bfa->fabric);
+		port_info->max_rports_supp = BFA_MAX_RPORTS_SUPP;
+		//port_info->num_rports_inuse = port->num_rports;
+	} else {
+		/*
+		 * This is a virtual port
+		 */
+		port_info->port_type = BFA_PORT_TYPE_VIRTUAL;
+
+		/*
+		 * @todo : need to fix the state & reason
+		 */
+		port_info->port_state = 0;
+		port_info->offline_reason = 0;
+
+		port_info->port_wwn = bfa_lport_get_pwwn(port);
+		port_info->node_wwn = bfa_lport_get_nwwn(port);
+	}
+}
+
+void
+bfa_lport_get_stats(struct bfa_lport_s *lport,
+		struct bfa_port_stats_s *port_stats)
+{
+	/* Send message to FW */
+	return;
+}
+
+void
+bfa_lport_clear_stats(struct bfa_lport_s *lport)
+{
+	/* Send message to FW */
+	return;
+}
+
+void
+bfa_lport_enable_ipfc_roles(struct bfa_lport_s *lport)
+{
+	/* ??? */
+	lport->port_cfg.roles |= BFA_PORT_ROLE_FCP_IPFC;
+	return;
+}
+
+void
+bfa_lport_disable_ipfc_roles(struct bfa_lport_s *lport)
+{
+	/* ??? */
+	lport->port_cfg.roles &= ~BFA_PORT_ROLE_FCP_IPFC;
+	return;
+}
+
+void
+bfa_lport_get_attr(struct bfa_lport_s *port, struct bfa_port_attr_s *port_attr)
+{
+	struct bfa_fabric_s *fabric = bfa_vf_lookup(port->bfa, port->fabric_tag);
+
+	memset(port_attr,0,sizeof(struct bfa_port_attr_s));
+
+	port_attr->pid = port->pid; 
+	port_attr->port_type = bfa_fabric_port_type(fabric); 
+	port_attr->fabric_name = bfa_lport_get_fabric_name(port); 
+	port_attr->loopback = bfa_fabric_is_loopback(fabric);
+	port_attr->port_cfg.pwwn = port->port_cfg.pwwn; 
+	port_attr->port_cfg.nwwn = port->port_cfg.nwwn; 
+	port_attr->port_cfg.roles = port->port_cfg.roles; 
+	//port_attr->fabric_ip_addr
+	//port_attr->state = BFA_PORT_ONLINE; TODO
+	memcpy(&port_attr->port_cfg.sym_name, &port->port_cfg.sym_name, sizeof(struct bfa_port_symname_s)); 
+}
+
+wwn_t bfa_lport_get_nwwn(struct bfa_lport_s *lport)
+{
+	return lport->port_cfg.nwwn;
+}
+wwn_t bfa_lport_get_pwwn(struct bfa_lport_s *lport)
+{
+	return lport->port_cfg.pwwn;
+}
+
+
+wwn_t bfa_lport_get_fabric_name(struct bfa_lport_s *lport)
+{
+    struct bfa_fabric_s *fabric = bfa_vf_lookup(lport->bfa, lport->fabric_tag);
+
+    return fabric->fabric_name;
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_lport.h patch/drivers/scsi/bfa/bfa_lport.h
--- orig/drivers/scsi/bfa/bfa_lport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_lport.h	2009-03-14 11:44:57.217172000 -0700
@@ -0,0 +1,180 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_lport.h BFA port module public interface
+ */
+
+#ifndef __BFA_LPORT_H__
+#define __BFA_LPORT_H__
+
+#include <bfi/bfi_vport.h>
+#include <bfa_ioc.h>
+
+/**
+ * P R I V A T E   D E F I N I T I O N S   
+ * - Used & visible to BFA RPORT module alone (private)
+ */
+
+#define BFA_LPORT_MIN	1
+#define BFA_LPORT_MAX	256	
+#define BFA_MAX_RPORTS_SUPP 1024
+#define BFA_MAX_VPORTS_SUPP 255
+
+#define bfa_lport_get_fcid(_lport)   ((_lport)->pid)
+
+struct bfa_lport_s;
+struct bfa_lptag_s;
+struct bfad_s;
+struct bfad_vport_s;
+struct bfad_vf_s;
+
+struct bfa_lport_mod_s {
+        struct bfa_lptag_s	*lptag_list;	/*  list of lport tags list */
+        struct list_head		lptag_free_q;	/*  free lport tags */
+        struct list_head		lptag_active_q;	/*  active lport tags */
+        u16			num_lptags;	/*  number of lport tags */
+        struct bfa_dma_s        psnbase;
+};
+typedef struct bfa_lport_mod_s bfa_lport_mod_t;
+
+/**
+ * P R O T E C T E D   D E F I N I T I O N S
+ * - Shared between modules within BFA layer (protected)
+ */
+
+struct bfa_lptag_s {
+	struct list_head		qe;		/*  queue element */
+	u16		lport_tag;	/* lport tag */
+	struct bfa_lport_s	*lport;
+};
+typedef struct bfa_lptag_s bfa_lptag_t;
+
+
+struct bfa_lport_s {
+	u16		fabric_tag;
+	struct bfa_fabric_s	*fabric;
+	struct bfa_lptag_s	*lport_tag;
+	struct bfa_port_cfg_s	port_cfg;
+	u32		pid:24;
+	struct bfa_s		*bfa;
+	struct bfa_vport_s	*vport;  /*  NULL for base ports */
+};
+typedef struct bfa_lport_s bfa_lport_t;
+
+#define BFA_LPORT_MOD(__bfa)    (&(__bfa)->modules.lport_mod)
+/**
+ * Convert lport tag to LPORT
+ */
+#define BFA_LPORT_FROM_TAG(__bfa, _tag)					\
+	((struct bfa_lptag_s *)(BFA_LPORT_MOD(__bfa)->lptag_list +	\
+	((_tag) & (BFA_LPORT_MOD(__bfa)->num_lptags - 1))))->lport
+
+#define BFA_LPTAG_FROM_TAG(__bfa, _tag)			\
+	BFA_LPORT_MOD(__bfa)->lptag_list +			\
+	((_tag) & (BFA_LPORT_MOD(__bfa)->num_lptags - 1))
+
+#define BFA_LPTAG_FROM_LPORT(_lport)	_lport->lport_tag
+
+void bfa_lport_init(struct bfa_lport_s *lport, struct bfa_s *bfa,
+		u16 fabric_tag, struct bfa_lptag_s *lport_tag,
+		struct bfa_port_cfg_s *port_cfg, struct bfa_vport_s *vport); 
+void bfa_lport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+struct bfa_lptag_s *bfa_lport_tag_alloc(struct bfa_lport_mod_s *mod);
+void bfa_lport_tag_free(struct bfa_lptag_s *lptag);
+void bfa_lport_msg_init(struct bfa_lport_s *lport,
+			struct bfi_vport_create_req_s *m);
+bfa_boolean_t bfa_lport_is_initiator(struct bfa_s *bfa, u16 lport_tag);
+bfa_boolean_t bfa_lport_is_target(struct bfa_s *bfa, u16 lport_tag);
+
+/**
+ * P U B L I C   D E F I N I T I O N S
+ * - Shared between BFA layer & Host Drivers (public)
+ */
+
+void bfa_lport_get_rports(struct bfa_lport_s *lport,
+			wwn_t rport_wwns[], int *nrports);
+wwn_t bfa_lport_get_rport(struct bfa_lport_s *port, wwn_t wwn,
+			int index, int nrports, bfa_boolean_t bwwn);
+struct bfa_lport_s *bfa_lport_lookup_port(struct bfa_s *bfa,
+			u16 vf_id, wwn_t lpwwn);
+void bfa_lport_get_info(struct bfa_lport_s *lport,
+			struct bfa_port_info_s *port_info);
+void bfa_lport_get_attr(struct bfa_lport_s *port,
+			struct bfa_port_attr_s *port_attr);
+void bfa_lport_get_stats(struct bfa_lport_s *lport,
+			struct bfa_port_stats_s *port_stats);
+void bfa_lport_clear_stats(struct bfa_lport_s *lport);
+enum bfa_pport_speed bfa_lport_get_rport_max_speed(bfa_lport_t *port);
+void  bfa_lport_enable_ipfc_roles(struct bfa_lport_s  *lport);
+void  bfa_lport_disable_ipfc_roles(struct bfa_lport_s  *lport);
+wwn_t bfa_lport_get_nwwn(struct bfa_lport_s  *lport);
+wwn_t bfa_lport_get_pwwn(struct bfa_lport_s  *lport);
+
+wwn_t bfa_lport_get_fabric_name(struct bfa_lport_s *lport);
+
+/**
+ * 	Call from FCS to driver module when a port is deleted. The port
+ * 	can be a base port or a virtual port with in the base fabric or
+ * 	a virtual fabric.
+ *
+ * @param[in] bfad   - driver instance
+ * @param[in] roles  - port roles: IM, TM, IP
+ * @param[in] vf_drv - VF driver instance, NULL if base fabric (no VF)
+ * @param[in] vp_drv - vport driver instance, NULL if base port
+ *
+ * @return None
+ */
+void bfa_cb_lport_delete(struct bfad_s *bfad, enum bfa_port_role roles,
+			struct bfad_vf_s *vf_drv, struct bfad_vport_s *vp_drv);
+
+/**
+ * 	Notification when port transitions to ONLINE state.
+ *
+ * Online notification is a logical link up for the local port. This
+ * notification is sent after a successfull FLOGI, or a successful
+ * link initialization in proviate-loop or N2N topologies.
+ *
+ * @param[in] bfad   - driver instance
+ * @param[in] roles  - port roles: IM, TM, IP
+ * @param[in] vf_drv - VF driver instance, NULL if base fabric (no VF)
+ * @param[in] vp_drv - vport driver instance, NULL if base port
+ *
+ * @return None
+ */
+void bfa_cb_lport_online(struct bfad_s *bfad, enum bfa_port_role roles,
+			struct bfad_vf_s *vf_drv, struct bfad_vport_s *vp_drv);
+
+/**
+ * 	Notification when port transitions to OFFLINE state.
+ *
+ * Offline notification is a logical link down for the local port.
+ *
+ * @param[in] bfad   - driver instance
+ * @param[in] roles  - port roles: IM, TM, IP
+ * @param[in] vf_drv - VF driver instance, NULL if base fabric (no VF)
+ * @param[in] vp_drv - vport driver instance, NULL if base port
+ *
+ * @return None
+ */
+void bfa_cb_lport_offline(struct bfad_s *bfad, enum bfa_port_role roles,
+			struct bfad_vf_s *vf_drv, struct bfad_vport_s *vp_drv);
+struct bfad_port_s * bfa_cb_port_new(struct bfad_s *bfad, struct bfa_lport_s *port,
+            enum bfa_port_role roles, struct bfad_vf_s *vf_drv,
+            struct bfad_vport_s *vp_drv);
+
+#endif /* __BFA_LPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_lps.c patch/drivers/scsi/bfa/bfa_lps.c
--- orig/drivers/scsi/bfa/bfa_lps.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_lps.c	2009-03-14 11:44:57.225214000 -0700
@@ -0,0 +1,722 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <bfi/bfi_lps.h>
+#include <cs/bfa_debug.h>
+
+BFA_TRC_FILE(HAL, LPS);
+BFA_MODULE(lps);
+
+#define BFA_LPS_MIN_LPORTS	(1)
+#define BFA_LPS_MAX_LPORTS	(256)
+
+/**
+ * forward declarations
+ */
+static void bfa_lps_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,
+			    u32 *dm_len);
+static void bfa_lps_attach(struct bfa_s *bfa, void *bfad,
+			   struct bfa_iocfc_cfg_s *cfg,
+			   struct bfa_meminfo_s *meminfo,
+			   struct bfa_pcidev_s *pcidev);
+static void bfa_lps_initdone(struct bfa_s *bfa);
+static void bfa_lps_detach(struct bfa_s *bfa);
+static void bfa_lps_start(struct bfa_s *bfa);
+static void bfa_lps_stop(struct bfa_s *bfa);
+static void bfa_lps_iocdisable(struct bfa_s *bfa);
+static void bfa_lps_login_rsp(struct bfa_s *bfa,
+			      struct bfi_lps_login_rsp_s *rsp);
+static void bfa_lps_logout_rsp(struct bfa_s *bfa,
+			       struct bfi_lps_logout_rsp_s *rsp);
+static void bfa_lps_reqq_resume(void *lps_arg);
+static void bfa_lps_free(struct bfa_lps_s *lps);
+static void bfa_lps_send_login(struct bfa_lps_s *lps);
+static void bfa_lps_send_logout(struct bfa_lps_s *lps);
+static void bfa_lps_login_comp(struct bfa_lps_s *lps);
+static void bfa_lps_logout_comp(struct bfa_lps_s *lps);
+
+
+/**
+ *  lps_pvt BFA LPS private functions
+ */
+
+enum bfa_lps_event {
+	BFA_LPS_SM_LOGIN	= 1,	/* login request from user	*/
+	BFA_LPS_SM_LOGOUT	= 2,	/* logout request from user	*/
+	BFA_LPS_SM_FWRSP	= 3,	/* f/w response to login/logout	*/
+	BFA_LPS_SM_RESUME	= 4,	/* space present in reqq queue	*/
+	BFA_LPS_SM_DELETE	= 5,	/* lps delete from user		*/
+	BFA_LPS_SM_OFFLINE	= 6,	/* Link is offline		*/
+};
+
+static void bfa_lps_sm_init(struct bfa_lps_s *lps, enum bfa_lps_event event);
+static void bfa_lps_sm_login(struct bfa_lps_s *lps, enum bfa_lps_event event);
+static void bfa_lps_sm_loginwait(struct bfa_lps_s *lps, enum bfa_lps_event event);
+static void bfa_lps_sm_online(struct bfa_lps_s *lps, enum bfa_lps_event event);
+static void bfa_lps_sm_logout(struct bfa_lps_s *lps, enum bfa_lps_event event);
+static void bfa_lps_sm_logowait(struct bfa_lps_s *lps, enum bfa_lps_event event);
+
+/**
+ * Init state -- no login
+ */
+static void
+bfa_lps_sm_init(struct bfa_lps_s *lps, enum bfa_lps_event event)
+{
+	bfa_trc(lps->bfa, lps->lp_tag);
+	bfa_trc(lps->bfa, event);
+
+	switch (event) {
+	case BFA_LPS_SM_LOGIN:
+		if (bfa_reqq_full(lps->bfa, lps->reqq)) {
+			bfa_sm_set_state(lps, bfa_lps_sm_loginwait);
+			bfa_reqq_wait(lps->bfa, lps->reqq, &lps->wqe);
+		} else {
+			bfa_sm_set_state(lps, bfa_lps_sm_login);
+			bfa_lps_send_login(lps);
+		}
+		break;
+
+	case BFA_LPS_SM_LOGOUT:
+		bfa_lps_logout_comp(lps);
+		break;
+
+	case BFA_LPS_SM_DELETE:
+		bfa_lps_free(lps);
+		break;
+
+	case BFA_LPS_SM_OFFLINE:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+} 
+
+/**
+ * login is in progress -- awaiting response from firmware
+ */
+static void
+bfa_lps_sm_login(struct bfa_lps_s *lps, enum bfa_lps_event event)
+{
+	bfa_trc(lps->bfa, lps->lp_tag);
+	bfa_trc(lps->bfa, event);
+
+	switch (event) {
+	case BFA_LPS_SM_FWRSP:
+		if (lps->status == BFA_STATUS_OK)
+			bfa_sm_set_state(lps, bfa_lps_sm_online);
+		else
+			bfa_sm_set_state(lps, bfa_lps_sm_init);
+		bfa_lps_login_comp(lps);
+		break;
+
+	case BFA_LPS_SM_OFFLINE:
+		bfa_sm_set_state(lps, bfa_lps_sm_init);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+} 
+
+/**
+ * login pending - awaiting space in request queue
+ */
+static void
+bfa_lps_sm_loginwait(struct bfa_lps_s *lps, enum bfa_lps_event event)
+{
+	bfa_trc(lps->bfa, lps->lp_tag);
+	bfa_trc(lps->bfa, event);
+
+	switch (event) {
+	case BFA_LPS_SM_RESUME:
+		bfa_sm_set_state(lps, bfa_lps_sm_login);
+		break;
+
+	case BFA_LPS_SM_OFFLINE:
+		bfa_sm_set_state(lps, bfa_lps_sm_init);
+		bfa_reqq_wcancel(&lps->wqe);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+} 
+
+/**
+ * login complete
+ */
+static void
+bfa_lps_sm_online(struct bfa_lps_s *lps, enum bfa_lps_event event)
+{
+	bfa_trc(lps->bfa, lps->lp_tag);
+	bfa_trc(lps->bfa, event);
+
+	switch (event) {
+	case BFA_LPS_SM_LOGOUT:
+		if (bfa_reqq_full(lps->bfa, lps->reqq)) {
+			bfa_sm_set_state(lps, bfa_lps_sm_logowait);
+			bfa_reqq_wait(lps->bfa, lps->reqq, &lps->wqe);
+		} else {
+			bfa_sm_set_state(lps, bfa_lps_sm_logout);
+			bfa_lps_send_logout(lps);
+		}
+		break;
+
+	case BFA_LPS_SM_OFFLINE:
+	case BFA_LPS_SM_DELETE:
+		bfa_sm_set_state(lps, bfa_lps_sm_init);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+} 
+
+/**
+ * logout in progress - awaiting firmware response
+ */
+static void
+bfa_lps_sm_logout(struct bfa_lps_s *lps, enum bfa_lps_event event)
+{
+	bfa_trc(lps->bfa, lps->lp_tag);
+	bfa_trc(lps->bfa, event);
+
+	switch (event) {
+	case BFA_LPS_SM_FWRSP:
+		bfa_sm_set_state(lps, bfa_lps_sm_init);
+		bfa_lps_logout_comp(lps);
+		break;
+
+	case BFA_LPS_SM_OFFLINE:
+		bfa_sm_set_state(lps, bfa_lps_sm_init);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+} 
+
+/**
+ * logout pending -- awaiting space in request queue
+ */
+static void
+bfa_lps_sm_logowait(struct bfa_lps_s *lps, enum bfa_lps_event event)
+{
+	bfa_trc(lps->bfa, lps->lp_tag);
+	bfa_trc(lps->bfa, event);
+
+	switch (event) {
+	case BFA_LPS_SM_RESUME:
+		bfa_sm_set_state(lps, bfa_lps_sm_logout);
+		bfa_lps_send_logout(lps);
+		break;
+
+	case BFA_LPS_SM_OFFLINE:
+		bfa_sm_set_state(lps, bfa_lps_sm_init);
+		bfa_reqq_wcancel(&lps->wqe);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+} 
+
+
+
+/**
+ *  lps_pvt BFA LPS private functions
+ */
+
+/**
+ * return memory requirement
+ */
+static void
+bfa_lps_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len, u32 *dm_len)
+{
+	if (cfg->drvcfg.min_cfg)
+		*ndm_len += sizeof(struct bfa_lps_s) * BFA_LPS_MIN_LPORTS;
+	else
+		*ndm_len += sizeof(struct bfa_lps_s) * BFA_LPS_MAX_LPORTS;
+}
+
+/**
+ * bfa module attach at initialization time
+ */
+static void
+bfa_lps_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+                    struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
+	struct bfa_lps_s	*lps;
+	int			i;
+
+	bfa_os_memset(mod, 0, sizeof(struct bfa_lps_mod_s));
+	mod->num_lps = BFA_LPS_MAX_LPORTS;
+	if (cfg->drvcfg.min_cfg)
+		mod->num_lps = BFA_LPS_MIN_LPORTS;
+	else
+		mod->num_lps = BFA_LPS_MAX_LPORTS;
+	mod->lps_arr = lps = (struct bfa_lps_s *) bfa_meminfo_kva(meminfo);
+
+	bfa_meminfo_kva(meminfo) += mod->num_lps * sizeof(struct bfa_lps_s);
+
+	INIT_LIST_HEAD(&mod->lps_free_q);
+	INIT_LIST_HEAD(&mod->lps_active_q);
+
+	for (i = 0; i < mod->num_lps; i++, lps++) {
+		lps->bfa	= bfa;
+		lps->lp_tag	= (u8) i;
+		lps->reqq	= BFA_REQQ_LPS;
+		bfa_reqq_winit(&lps->wqe, bfa_lps_reqq_resume, lps);
+		list_add_tail(&lps->qe, &mod->lps_free_q);
+	}
+}
+
+static void
+bfa_lps_initdone(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_lps_detach(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_lps_start(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_lps_stop(struct bfa_s *bfa)
+{
+}
+
+/**
+ * IOC in disabled state -- consider all lps offline
+ */
+static void
+bfa_lps_iocdisable(struct bfa_s *bfa)
+{
+	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
+	struct bfa_lps_s	*lps;
+	struct list_head		*qe, *qen;
+
+	list_for_each_safe(qe, qen, &mod->lps_active_q) {
+		lps = (struct bfa_lps_s *) qe;
+		bfa_sm_send_event(lps, BFA_LPS_SM_OFFLINE);
+	}
+}
+
+/**
+ * Firmware login response
+ */
+static void
+bfa_lps_login_rsp(struct bfa_s *bfa, struct bfi_lps_login_rsp_s *rsp)
+{
+	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
+	struct bfa_lps_s	*lps;
+
+	bfa_assert(rsp->lp_tag < mod->num_lps);
+	lps = BFA_LPS_FROM_TAG(mod, rsp->lp_tag);
+
+	lps->status = rsp->status;
+	if (rsp->status == BFA_STATUS_OK) {
+		lps->fport	= rsp->f_port;
+		lps->npiv_en	= rsp->npiv_en;
+		lps->lp_pid	= rsp->lp_pid;
+		lps->pr_bbcred	= bfa_os_ntohs(rsp->bb_credit);
+		lps->pr_pwwn	= rsp->port_name;
+		lps->pr_nwwn	= rsp->node_name;
+		lps->auth_req	= rsp->auth_req;
+		lps->lp_mac	= rsp->lp_mac;
+		lps->fcf_mac	= rsp->fcf_mac;
+	}
+	if (rsp->status == BFA_STATUS_FABRIC_RJT) {
+		lps->lsrjt_rsn = rsp->lsrjt_rsn;
+		lps->lsrjt_expl = rsp->lsrjt_expl;
+	}
+
+	bfa_sm_send_event(lps, BFA_LPS_SM_FWRSP);
+}
+
+/**
+ * Firmware logout response
+ */
+static void
+bfa_lps_logout_rsp(struct bfa_s *bfa, struct bfi_lps_logout_rsp_s *rsp)
+{
+	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
+	struct bfa_lps_s	*lps;
+
+	bfa_assert(rsp->lp_tag < mod->num_lps);
+	lps = BFA_LPS_FROM_TAG(mod, rsp->lp_tag);
+
+	bfa_sm_send_event(lps, BFA_LPS_SM_FWRSP);
+}
+
+/**
+ * Space is available in request queue, resume queueing request to firmware.
+ */
+static void
+bfa_lps_reqq_resume(void *lps_arg)
+{
+	struct bfa_lps_s	*lps = lps_arg;
+
+	bfa_sm_send_event(lps, BFA_LPS_SM_RESUME);
+}
+
+/**
+ * lps is freed -- triggered by vport delete
+ */
+static void
+bfa_lps_free(struct bfa_lps_s *lps)
+{
+	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(lps->bfa);
+
+	list_del(&lps->qe);
+	list_add_tail(&lps->qe, &mod->lps_free_q);
+}
+
+/**
+ * send login request to firmware
+ */
+static void
+bfa_lps_send_login(struct bfa_lps_s *lps)
+{
+	struct bfi_lps_login_req_s	*m;
+
+	m = bfa_reqq_next(lps->bfa, lps->reqq);
+	bfa_assert(m);
+
+	bfi_h2i_set(m->mh, BFI_MC_LPS, BFI_LPS_H2I_LOGIN_REQ,
+                        bfa_lpuid(lps->bfa));
+
+	m->lp_tag	= lps->lp_tag;
+	m->alpa		= lps->alpa;
+	m->pdu_size	= bfa_os_htons(lps->pdusz);
+	m->pwwn		= lps->pwwn;
+	m->nwwn		= lps->nwwn;
+	m->fdisc	= lps->fdisc;
+	m->auth_en	= lps->auth_en;
+
+	bfa_reqq_produce(lps->bfa, lps->reqq);
+}
+
+/**
+ * send logout request to firmware
+ */
+static void
+bfa_lps_send_logout(struct bfa_lps_s *lps)
+{
+	struct bfi_lps_logout_req_s *m;
+
+	m = bfa_reqq_next(lps->bfa, lps->reqq);
+	bfa_assert(m);
+
+	bfi_h2i_set(m->mh, BFI_MC_LPS, BFI_LPS_H2I_LOGOUT_REQ,
+                        bfa_lpuid(lps->bfa));
+
+	m->lp_tag	= lps->lp_tag;
+	bfa_reqq_produce(lps->bfa, lps->reqq);
+}
+
+/**
+ * Indirect login completion handler for non-fcs
+ */
+static void
+bfa_lps_login_comp_cb(void *arg, bfa_boolean_t complete)
+{
+	struct bfa_lps_s *lps	= arg;
+
+	if (!complete)
+		return;
+
+	if (lps->fdisc)
+		bfa_cb_lps_fdisc_comp(lps->bfa->bfad, lps->uarg, lps->status);
+	else
+		bfa_cb_lps_flogi_comp(lps->bfa->bfad, lps->uarg, lps->status);
+}
+
+/**
+ * Login completion handler -- direct call for fcs, queue for others
+ */
+static void
+bfa_lps_login_comp(struct bfa_lps_s *lps)
+{
+	if (!bfa_fw_disc_enabled(lps->bfa)) {
+		bfa_cb_queue(lps->bfa, &lps->hcb_qe, bfa_lps_login_comp_cb, lps);
+		return;
+	}
+	if (lps->fdisc)
+		bfa_cb_lps_fdisc_comp(lps->bfa->bfad, lps->uarg, lps->status);
+	else
+		bfa_cb_lps_flogi_comp(lps->bfa->bfad, lps->uarg, lps->status);
+}
+
+/**
+ * Indirect logout completion handler for non-fcs
+ */
+static void
+bfa_lps_logout_comp_cb(void *arg, bfa_boolean_t complete)
+{
+	struct bfa_lps_s *lps	= arg;
+
+	if (!complete)
+		return;
+
+	if (lps->fdisc)
+		bfa_cb_lps_fdisclogo_comp(lps->bfa->bfad, lps->uarg);
+	else
+		bfa_cb_lps_flogo_comp(lps->bfa->bfad, lps->uarg);
+}
+
+/**
+ * Logout completion handler -- direct call for fcs, queue for others
+ */
+static void
+bfa_lps_logout_comp(struct bfa_lps_s *lps)
+{
+	if (!bfa_fw_disc_enabled(lps->bfa)) {
+		bfa_cb_queue(lps->bfa, &lps->hcb_qe, bfa_lps_logout_comp_cb, lps);
+		return;
+	}
+
+	if (lps->fdisc)
+		bfa_cb_lps_fdisclogo_comp(lps->bfa->bfad, lps->uarg);
+	else
+		bfa_cb_lps_flogo_comp(lps->bfa->bfad, lps->uarg);
+}
+
+
+
+/**
+ *  lps_public BFA LPS public functions
+ */
+
+/**
+ * Allocate a lport srvice tag.
+ */
+struct bfa_lps_s  *
+bfa_lps_alloc(struct bfa_s *bfa)
+{
+	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(bfa);
+	struct bfa_lps_s	*lps = NULL;
+
+	bfa_q_deq(&mod->lps_free_q, &lps);
+
+	if (lps == NULL)
+		return NULL;
+
+	list_add_tail(&lps->qe, &mod->lps_active_q);
+
+	bfa_sm_set_state(lps, bfa_lps_sm_init);
+	return lps;
+}
+
+/**
+ * Free lport service tag. This can be called anytime after an alloc.
+ * No need to wait for any pending login/logout completions.
+ */
+void
+bfa_lps_delete(struct bfa_lps_s *lps)
+{
+	bfa_sm_send_event(lps, BFA_LPS_SM_DELETE);
+}
+
+/**
+ * Initiate a lport login.
+ */
+void
+bfa_lps_flogi(struct bfa_lps_s *lps, void *uarg, u8 alpa, u16 pdusz,
+	wwn_t pwwn, wwn_t nwwn, bfa_boolean_t auth_en)
+{
+	lps->uarg	= uarg;
+	lps->alpa	= alpa;
+	lps->pdusz	= pdusz;
+	lps->pwwn	= pwwn;
+	lps->nwwn	= nwwn;
+	lps->fdisc	= BFA_FALSE;
+	lps->auth_en	= auth_en;
+	bfa_sm_send_event(lps, BFA_LPS_SM_LOGIN);
+}
+
+/**
+ * Initiate a lport fdisc login.
+ */
+void
+bfa_lps_fdisc(struct bfa_lps_s *lps, void *uarg, u16 pdusz, wwn_t pwwn,
+	wwn_t nwwn)
+{
+	lps->uarg	= uarg;
+	lps->alpa	= 0;
+	lps->pdusz	= pdusz;
+	lps->pwwn	= pwwn;
+	lps->nwwn	= nwwn;
+	lps->fdisc	= BFA_TRUE;
+	lps->auth_en	= BFA_FALSE;
+	bfa_sm_send_event(lps, BFA_LPS_SM_LOGIN);
+}
+
+/**
+ * Initiate a lport logout (flogi).
+ */
+void
+bfa_lps_flogo(struct bfa_lps_s *lps)
+{
+	bfa_sm_send_event(lps, BFA_LPS_SM_LOGOUT);
+}
+
+/**
+ * Initiate a lport FDSIC logout.
+ */
+void
+bfa_lps_fdisclogo(struct bfa_lps_s *lps)
+{
+	bfa_sm_send_event(lps, BFA_LPS_SM_LOGOUT);
+}
+
+/**
+ * Discard a pending login request -- should be called only for
+ * link down handling.
+ */
+void
+bfa_lps_discard(struct bfa_lps_s *lps)
+{
+	bfa_sm_send_event(lps, BFA_LPS_SM_OFFLINE);
+}
+
+/**
+ * Return lport services tag
+ */
+u8
+bfa_lps_get_tag(struct bfa_lps_s *lps)
+{
+	return lps->lp_tag;
+}
+
+/**
+ * return if fabric login indicates support for NPIV
+ */
+bfa_boolean_t
+bfa_lps_is_npiv_en(struct bfa_lps_s *lps)
+{
+	return lps->npiv_en;
+}
+
+/**
+ * Return TRUE if attached to F-Port, else return FALSE
+ */
+bfa_boolean_t
+bfa_lps_is_fport(struct bfa_lps_s *lps)
+{
+	return lps->fport;
+}
+
+/**
+ * return TRUE if authentication is required
+ */
+bfa_boolean_t
+bfa_lps_is_authreq(struct bfa_lps_s *lps)
+{
+	return lps->auth_req;
+}
+
+/**
+ * return port id assigned to the lport
+ */
+u32
+bfa_lps_get_pid(struct bfa_lps_s *lps)
+{
+	return lps->lp_pid;
+}
+
+/**
+ * Return bb_credit assigned in FLOGI response
+ */
+u16
+bfa_lps_get_peer_bbcredit(struct bfa_lps_s *lps)
+{
+	return lps->pr_bbcred;
+}
+
+/**
+ * Return peer port name
+ */
+wwn_t
+bfa_lps_get_peer_pwwn(struct bfa_lps_s *lps)
+{
+	return lps->pr_pwwn;
+}
+
+/**
+ * Return peer node name
+ */
+wwn_t
+bfa_lps_get_peer_nwwn(struct bfa_lps_s *lps)
+{
+	return lps->pr_nwwn;
+}
+
+/**
+ * return reason code if login request is rejected
+ */
+u8
+bfa_lps_get_lsrjt_rsn(struct bfa_lps_s *lps)
+{
+	return lps->lsrjt_rsn;
+}
+
+/**
+ * return explanation code if login request is rejected
+ */
+u8
+bfa_lps_get_lsrjt_expl(struct bfa_lps_s *lps)
+{
+	return lps->lsrjt_expl;
+}
+
+
+/**
+ * LPS firmware message class handler.
+ */
+void
+bfa_lps_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
+{
+	union bfi_lps_i2h_msg_u	msg;
+
+	bfa_trc(bfa, m->mhdr.msg_id);
+	msg.msg = m;
+
+	switch (m->mhdr.msg_id) {
+	case BFI_LPS_H2I_LOGIN_RSP:
+		bfa_lps_login_rsp(bfa, msg.login_rsp);
+		break;
+
+	case BFI_LPS_H2I_LOGOUT_RSP:
+		bfa_lps_logout_rsp(bfa, msg.logout_rsp);
+		break;
+
+	default:
+		bfa_trc(bfa, m->mhdr.msg_id);
+		bfa_assert(0);
+	}
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_lps_priv.h patch/drivers/scsi/bfa/bfa_lps_priv.h
--- orig/drivers/scsi/bfa/bfa_lps_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_lps_priv.h	2009-03-14 11:44:57.232775000 -0700
@@ -0,0 +1,38 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_LPS_PRIV_H__
+#define __BFA_LPS_PRIV_H__
+
+#include <bfa_svc.h>
+
+struct bfa_lps_mod_s {
+	struct list_head		lps_free_q;
+	struct list_head		lps_active_q;
+	struct bfa_lps_s	*lps_arr;
+	int			num_lps;
+};
+
+#define BFA_LPS_MOD(__bfa)		(&(__bfa)->modules.lps_mod)
+#define BFA_LPS_FROM_TAG(__mod, __tag)	(&(__mod)->lps_arr[__tag])
+
+/*
+ * external functions
+ */
+void	bfa_lps_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+
+#endif /* __BFA_LPS_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_module.c patch/drivers/scsi/bfa/bfa_module.c
--- orig/drivers/scsi/bfa/bfa_module.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_module.c	2009-03-14 11:44:57.240621000 -0700
@@ -0,0 +1,92 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <bfa.h>
+#include <defs/bfa_defs_pci.h>
+#include <cs/bfa_debug.h>
+#include <bfa_iocfc.h>
+#include <bfa_fabric.h>
+#include <bfa_lport.h>
+#include <bfa_vport.h>
+
+/**
+ * BFA module list terminated by NULL
+ */
+struct bfa_module_s *hal_mods[] = {
+	&hal_mod_sgpg,
+	&hal_mod_pport,
+	&hal_mod_fcxp,
+	&hal_mod_lps,
+	&hal_mod_uf,
+	&hal_mod_rport,
+	&hal_mod_fcpim,
+	&hal_mod_lport,
+	&hal_mod_fabric,
+	NULL
+};
+
+/**
+ * Message handlers for various modules.
+ */
+bfa_isr_func_t  bfa_isrs[BFI_MC_MAX] = {
+	bfa_isr_unhandled,	/* NONE */
+	bfa_isr_unhandled,	/* BFI_MC_IOC */
+	bfa_fcdiag_intr,	/* BFI_MC_DIAG */
+	bfa_isr_unhandled,	/* BFI_MC_FLASH */
+	bfa_isr_unhandled,	/* BFI_MC_CEE */
+	bfa_pport_isr,		/* BFI_MC_PORT */
+	bfa_isr_unhandled,	/* BFI_MC_IOCFC */
+	bfa_isr_unhandled,	/* BFI_MC_LL */
+	bfa_uf_isr,		/* BFI_MC_UF */
+	bfa_fcxp_isr,		/* BFI_MC_FCXP */
+	bfa_lps_isr,		/* BFI_MC_LPS */
+	bfa_rport_isr,		/* BFI_MC_RPORT */
+	bfa_itnim_isr,		/* BFI_MC_ITNIM */
+	bfa_isr_unhandled,	/* BFI_MC_IOIM_READ */
+	bfa_isr_unhandled,	/* BFI_MC_IOIM_WRITE */
+	bfa_isr_unhandled,	/* BFI_MC_IOIM_IO */
+	bfa_ioim_isr,		/* BFI_MC_IOIM */
+	bfa_ioim_good_comp_isr,	/* BFI_MC_IOIM_IOCOM */
+	bfa_tskim_isr,		/* BFI_MC_TSKIM */
+	bfa_isr_unhandled,	/* BFI_MC_SBOOT */
+	bfa_isr_unhandled,	/* BFI_MC_IPFC */
+	bfa_fabric_isr,	    /* BFI_MC_FABRIC */
+	bfa_lport_isr,	    /* BFI_MC_LPORT */
+	bfa_isr_unhandled,  /* BFI_MC_ITNTM */
+	bfa_isr_unhandled,	/* BFI_MC_IOTM_READ */
+	bfa_isr_unhandled,	/* BFI_MC_IOTM_WRITE */
+	bfa_isr_unhandled,	/* BFI_MC_IOTM_IO */
+	bfa_isr_unhandled,	/* BFI_MC_IOTM_IOCOM */
+	bfa_isr_unhandled, 	/* BFI_MC_IOTM */
+	bfa_isr_unhandled, 	/* BFI_MC_TSKTM */
+	bfa_isr_unhandled,	/* BFI_MC_SB */
+	bfa_vport_isr,  	/* BFI_MC_VPORT */
+};
+
+/**
+ * Message handlers for mailbox command classes
+ */
+bfa_ioc_mbox_mcfunc_t  bfa_mbox_isrs[BFI_MC_MAX] = {
+	NULL,
+	NULL,			/* BFI_MC_IOC	*/
+	NULL,		/* BFI_MC_DIAG	*/
+	NULL,		/* BFI_MC_FLASH */
+	NULL,			/* BFI_MC_CEE	*/
+	NULL,			/* BFI_MC_PORT	*/
+	bfa_iocfc_isr,		/* BFI_MC_IOCFC */
+	NULL,
+};
+
diff -urpN orig/drivers/scsi/bfa/bfa_modules_priv.h patch/drivers/scsi/bfa/bfa_modules_priv.h
--- orig/drivers/scsi/bfa/bfa_modules_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_modules_priv.h	2009-03-14 11:44:57.248485000 -0700
@@ -0,0 +1,42 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_MODULES_PRIV_H__
+#define __BFA_MODULES_PRIV_H__
+
+#include "bfa_uf_priv.h"
+#include "bfa_lport.h"
+#include "bfa_rport.h"
+#include "bfa_port_priv.h"
+#include "bfa_fcxp_priv.h"
+#include "bfa_lps_priv.h"
+#include "bfa_diag_priv.h"
+#include "bfa_fcpim.h"
+
+struct bfa_modules_s {
+	struct bfa_pport_s	pport;		/*  physical port module     */
+	struct bfa_fcxp_mod_s	fcxp_mod;	/*  fcxp module	      */
+	struct bfa_lps_mod_s	lps_mod;	/*  lps module		      */
+	struct bfa_uf_mod_s	uf_mod;		/*  unsolicited frame module */
+	struct bfa_rport_mod_s	rport_mod;	/*  remote port module	      */
+	struct bfa_fcpim_mod_s	fcpim_mod;	/*  FCP initiator module     */
+	struct bfa_sgpg_mod_s	sgpg_mod;	/*  SG page module	      */
+	struct bfa_diag_s	diag_mod;	/*  diagnostics module	      */
+	struct bfa_lport_mod_s	lport_mod;	/*  lport_mod		      */
+};
+
+#endif /* __BFA_MODULES_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_os_inc.h patch/drivers/scsi/bfa/bfa_os_inc.h
--- orig/drivers/scsi/bfa/bfa_os_inc.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_os_inc.h	2009-03-14 11:44:57.255823000 -0700
@@ -0,0 +1,197 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ * Contains declarations all OS Specific files needed for BFA layer
+ */
+
+#ifndef __BFA_OS_INC_H__
+#define __BFA_OS_INC_H__
+
+#ifndef __KERNEL__
+#include <stdint.h>
+#else
+#include <linux/types.h>
+
+#include <linux/version.h>
+#include <linux/pci.h>
+
+#include <linux/dma-mapping.h>
+#define SET_MODULE_VERSION(VER)
+
+#include <linux/idr.h>
+
+#include <linux/interrupt.h>
+#include <linux/cdev.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/vmalloc.h>
+
+#include <linux/workqueue.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_transport.h>
+
+#define BFA_ERR			KERN_ERR
+#define BFA_WARNING		KERN_WARNING
+#define BFA_NOTICE		KERN_NOTICE
+#define BFA_INFO		KERN_INFO
+#define BFA_DEBUG		KERN_DEBUG
+
+#define LOG_BFAD_INIT		0x00000001
+#define LOG_FCP_IO		0x00000002
+
+#ifdef DEBUG
+#define BFA_LOG_TRACE(bfad, level, mask, fmt, arg...)			\
+		BFA_LOG(bfad, level, mask, fmt, ## arg)
+#define BFA_DEV_TRACE(bfad, level, fmt, arg...)				\
+		BFA_DEV_PRINTF(bfad, level, fmt, ## arg)
+#define BFA_TRACE(level, fmt, arg...)					\
+		BFA_PRINTF(level, fmt, ## arg)
+#else
+#define BFA_LOG_TRACE(bfad, level, mask, fmt, arg...)
+#define BFA_DEV_TRACE(bfad, level, fmt, arg...)
+#define BFA_TRACE(level, fmt, arg...)
+#endif
+
+#define BFA_ASSERT(p) do {						\
+	if (!(p)) {      \
+		printk(KERN_ERR "assert(%s) failed at %s:%d\n",		\
+		#p, __FILE__, __LINE__ );      \
+		BUG( );      \
+	}								\
+} while (0)
+
+
+#define BFA_LOG(bfad, level, mask, fmt, arg...)				\
+do { 									\
+	if (((mask) & (((struct bfad_s *)(bfad))->			\
+		cfg_data[cfg_log_mask])) || (level[1] <= '3'))		\
+		dev_printk(level, &(((struct bfad_s *)			\
+			(bfad))->pcidev->dev), fmt, ##arg );      \
+} while (0)
+
+#ifndef BFA_DEV_PRINTF
+#define BFA_DEV_PRINTF(bfad, level, fmt, arg...)			\
+		dev_printk(level, &(((struct bfad_s *)			\
+			(bfad))->pcidev->dev), fmt, ##arg);
+#endif
+
+#define BFA_PRINTF(level, fmt, arg...)					\
+		printk(level fmt, ##arg);
+
+int bfa_os_MWB(void *);
+
+#define bfa_os_mmiowb()		mmiowb()
+
+#define bfa_swap_3b(_x)				\
+	((((_x) & 0xff) << 16) |		\
+	((_x) & 0x00ff00) |			\
+	(((_x) & 0xff0000) >> 16))
+
+#define bfa_swap_8b(_x) 				\
+     ((((_x) & 0xff00000000000000ull) >> 56)		\
+      | (((_x) & 0x00ff000000000000ull) >> 40)		\
+      | (((_x) & 0x0000ff0000000000ull) >> 24)		\
+      | (((_x) & 0x000000ff00000000ull) >> 8)		\
+      | (((_x) & 0x00000000ff000000ull) << 8)		\
+      | (((_x) & 0x0000000000ff0000ull) << 24)		\
+      | (((_x) & 0x000000000000ff00ull) << 40)		\
+      | (((_x) & 0x00000000000000ffull) << 56))
+
+#define bfa_os_swap32(_x) 			\
+	((((_x) & 0xff) << 24) 		|	\
+	(((_x) & 0x0000ff00) << 8)	|	\
+	(((_x) & 0x00ff0000) >> 8)	|	\
+	(((_x) & 0xff000000) >> 24))
+
+
+#ifndef __BIGENDIAN
+#define bfa_os_htons(_x) ((u16)((((_x) & 0xff00) >> 8) | \
+				 (((_x) & 0x00ff) << 8)))
+
+#define bfa_os_htonl(_x)	bfa_os_swap32(_x)
+#define bfa_os_htonll(_x)	bfa_swap_8b(_x)
+#define bfa_os_hton3b(_x)	bfa_swap_3b(_x)
+
+#define bfa_os_wtole(_x)   (_x)
+
+#else
+
+#define bfa_os_htons(_x)   (_x)
+#define bfa_os_htonl(_x)   (_x)
+#define bfa_os_hton3b(_x)  (_x)
+#define bfa_os_htonll(_x)  (_x)
+#define bfa_os_wtole(_x)   bfa_os_swap32(_x)
+
+#endif
+
+#define bfa_os_ntohs(_x)   bfa_os_htons(_x)
+#define bfa_os_ntohl(_x)   bfa_os_htonl(_x)
+#define bfa_os_ntohll(_x)  bfa_os_htonll(_x)
+#define bfa_os_ntoh3b(_x)  bfa_os_hton3b(_x)
+
+#define bfa_os_u32(__pa64) ((__pa64) >> 32)
+
+#define bfa_os_memset	memset
+#define bfa_os_memcpy	memcpy
+#define bfa_os_udelay	udelay
+#define bfa_os_vsprintf vsprintf
+
+#define bfa_os_addr_t void __iomem *
+#define bfa_os_panic()
+
+#define bfa_os_reg_read(_raddr)						\
+	bfa_os_wtole(*((volatile u32 __force *)(_raddr)))
+#define bfa_os_reg_write(_raddr, _val)					\
+	*((volatile u32 __force *)(_raddr)) = bfa_os_wtole((_val))
+#define bfa_os_mem_read(_raddr, _off)					\
+	bfa_os_ntohl(((volatile u32 __force *)(_raddr))[(_off) >> 2])
+#define bfa_os_mem_write(_raddr, _off, _val)				\
+	((((volatile u32 __force *)(_raddr))[(_off) >> 2])		\
+		 = bfa_os_htonl((_val)))
+
+#define BFA_TRC_TS(_trcm)						\
+			({						\
+				struct timeval tv;			\
+									\
+				do_gettimeofday(&tv );      \
+				(tv.tv_sec*1000000+tv.tv_usec );      \
+			 })
+
+struct bfa_log_mod_s;
+void bfa_os_printf(struct bfa_log_mod_s *log_mod, u32 msg_id,
+			const char *fmt, ...);
+#endif
+
+#define boolean_t int
+
+/**
+ * For current time stamp, OS API will fill-in
+ */
+struct bfa_timeval_s {
+	u32	tv_sec;		/*  seconds        */
+	u32	tv_usec;	/*  microseconds   */
+};
+
+void bfa_os_gettimeofday(struct bfa_timeval_s *tv);
+
+#endif /* __BFA_OS_INC_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_port.c patch/drivers/scsi/bfa/bfa_port.c
--- orig/drivers/scsi/bfa/bfa_port.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_port.c	2009-03-14 11:44:57.265979000 -0700
@@ -0,0 +1,1661 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include <bfi/bfi_pport.h>
+#include <cs/bfa_debug.h>
+#include <aen/bfa_aen.h>
+#include <cs/bfa_plog.h>
+#include <aen/bfa_aen_port.h>
+
+BFA_TRC_FILE(HAL, PPORT);
+BFA_MODULE(pport);
+
+#define bfa_pport_callback(__pport, __event) do {			\
+	if(!bfa_fw_disc_enabled(__pport->bfa)) {      \
+		if (__pport->bfa) {      \
+			(__pport)->event_cbfn((__pport)->event_cbarg, (__event) );      \
+		} else {							\
+			(__pport)->hcb_event = (__event );      \
+			bfa_cb_queue((__pport)->bfa, &(__pport)->hcb_qe,	\
+					__bfa_cb_port_event, (__pport) );      \
+		}								\
+	}\
+} while (0)
+
+/*
+ * The port is considered disabled if corresponding physical port or IOC are
+ * disabled explicitly
+ */
+#define BFA_PORT_IS_OFFLINE(bfa) \
+	((bfa_pport_is_disabled(bfa) == BFA_TRUE) || \
+	 (bfa_ioc_is_disabled(&bfa->ioc) == BFA_TRUE))
+
+/*
+ * forward declarations
+ */
+static bfa_boolean_t bfa_pport_send_enable(struct bfa_pport_s *port);
+static bfa_boolean_t bfa_pport_send_disable(struct bfa_pport_s *port);
+static void	bfa_pport_update_linkinfo(struct bfa_pport_s *pport);
+static void	bfa_pport_reset_linkinfo(struct bfa_pport_s *pport);
+static void	bfa_pport_set_wwns(struct bfa_pport_s *port);
+static void	__bfa_cb_port_event(void *cbarg, bfa_boolean_t complete);
+static void	__bfa_cb_port_stats(void *cbarg, bfa_boolean_t complete);
+static void	__bfa_cb_port_stats_clr(void *cbarg, bfa_boolean_t complete);
+static void	bfa_port_stats_timeout(void *cbarg);
+static void	bfa_port_stats_clr_timeout(void *cbarg);
+
+/**
+ *  hal_pport_private
+ */
+
+/**
+ * BFA port state machine events
+ */
+enum bfa_pport_sm_event {
+	BFA_PPORT_SM_START	= 1,	/*  start port state machine	*/
+	BFA_PPORT_SM_STOP	= 2,	/*  stop port state machine	*/
+	BFA_PPORT_SM_ENABLE	= 3,	/*  enable port		*/
+	BFA_PPORT_SM_DISABLE = 4,	/*  disable port state machine */
+	BFA_PPORT_SM_FWRSP	= 5,	/*  firmware enable/disable rsp */
+	BFA_PPORT_SM_LINKUP	= 6,	/*  firmware linkup event	*/
+	BFA_PPORT_SM_LINKDOWN = 7,	/*  firmware linkup down	*/
+	BFA_PPORT_SM_QRESUME = 8,	/*  CQ space available	*/
+	BFA_PPORT_SM_HWFAIL = 9,	/*  IOC h/w failure		*/
+};
+
+static void	bfa_pport_sm_uninit(struct bfa_pport_s *pport,
+					enum bfa_pport_sm_event event);
+static void	bfa_pport_sm_enabling_qwait(struct bfa_pport_s *pport,
+						enum bfa_pport_sm_event event);
+static void	bfa_pport_sm_enabling(struct bfa_pport_s *pport,
+						enum bfa_pport_sm_event event);
+static void	bfa_pport_sm_linkdown(struct bfa_pport_s *pport,
+						enum bfa_pport_sm_event event);
+static void	bfa_pport_sm_linkup(struct bfa_pport_s *pport,
+						enum bfa_pport_sm_event event);
+static void	bfa_pport_sm_disabling(struct bfa_pport_s *pport,
+						enum bfa_pport_sm_event event);
+static void	bfa_pport_sm_disabling_qwait(struct bfa_pport_s *pport,
+						enum bfa_pport_sm_event event);
+static void	bfa_pport_sm_disabled(struct bfa_pport_s *pport,
+						enum bfa_pport_sm_event event);
+static void	bfa_pport_sm_stopped(struct bfa_pport_s *pport,
+					 enum bfa_pport_sm_event event);
+static void	bfa_pport_sm_iocdown(struct bfa_pport_s *pport,
+					 enum bfa_pport_sm_event event);
+static void	bfa_pport_sm_iocfail(struct bfa_pport_s *pport,
+					 enum bfa_pport_sm_event event);
+
+static struct bfa_sm_table_s hal_pport_sm_table[] = {
+	{BFA_SM(bfa_pport_sm_uninit), BFA_PPORT_ST_UNINIT},
+	{BFA_SM(bfa_pport_sm_enabling_qwait), BFA_PPORT_ST_ENABLING_QWAIT},
+	{BFA_SM(bfa_pport_sm_enabling), BFA_PPORT_ST_ENABLING},
+	{BFA_SM(bfa_pport_sm_linkdown), BFA_PPORT_ST_LINKDOWN},
+	{BFA_SM(bfa_pport_sm_linkup), BFA_PPORT_ST_LINKUP},
+	{BFA_SM(bfa_pport_sm_disabling_qwait),
+						BFA_PPORT_ST_DISABLING_QWAIT},
+	{BFA_SM(bfa_pport_sm_disabling), BFA_PPORT_ST_DISABLING},
+	{BFA_SM(bfa_pport_sm_disabled), BFA_PPORT_ST_DISABLED},
+	{BFA_SM(bfa_pport_sm_stopped), BFA_PPORT_ST_STOPPED},
+	{BFA_SM(bfa_pport_sm_iocdown), BFA_PPORT_ST_IOCDOWN},
+	{BFA_SM(bfa_pport_sm_iocfail), BFA_PPORT_ST_IOCDOWN},
+};
+
+static void
+bfa_pport_aen_post(struct bfa_pport_s *pport, enum bfa_port_aen_event event)
+{
+	union bfa_aen_data_u aen_data;
+
+	struct bfa_log_mod_s *logmod = pport->bfa->logm;
+	wwn_t		pwwn = pport->pwwn;
+	char		*pwwn_ptr = NULL;
+
+	switch (event) {
+	case BFA_PORT_AEN_ONLINE:
+		bfa_log(logmod, BFA_AEN_PORT_ONLINE, pwwn_ptr);
+		break;
+	case BFA_PORT_AEN_OFFLINE:
+		bfa_log(logmod, BFA_AEN_PORT_OFFLINE, pwwn_ptr);
+		break;
+	case BFA_PORT_AEN_ENABLE:
+		bfa_log(logmod, BFA_AEN_PORT_ENABLE, pwwn_ptr);
+		break;
+	case BFA_PORT_AEN_DISABLE:
+		bfa_log(logmod, BFA_AEN_PORT_DISABLE, pwwn_ptr);
+		break;
+	case BFA_PORT_AEN_DISCONNECT:
+		bfa_log(logmod, BFA_AEN_PORT_DISCONNECT, pwwn_ptr);
+		break;
+	case BFA_PORT_AEN_QOS_NEG:
+		bfa_log(logmod, BFA_AEN_PORT_QOS_NEG, pwwn_ptr);
+		break;
+	default:
+		break;
+	}
+
+	aen_data.port.pwwn = pwwn;
+}
+
+static void
+bfa_pport_sm_uninit(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_START:
+		/**
+		 * Start event after IOC is configured and BFA is started.
+		 */
+		if (bfa_pport_send_enable(pport))
+			bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+		else
+			bfa_sm_set_state(pport,
+					 bfa_pport_sm_enabling_qwait);
+		break;
+
+	case BFA_PPORT_SM_ENABLE:
+		/**
+		 * Port is persistently configured to be in enabled state. Do
+		 * not change state. Port enabling is done when START event is
+		 * received.
+		 */
+		break;
+
+	case BFA_PPORT_SM_DISABLE:
+		/**
+		 * If a port is persistently configured to be disabled, the
+		 * first event will a port disable request.
+		 */
+		bfa_sm_set_state(pport, bfa_pport_sm_disabled);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_pport_sm_enabling_qwait(struct bfa_pport_s *pport,
+				enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_QRESUME:
+		bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+		bfa_pport_send_enable(pport);
+		break;
+
+	case BFA_PPORT_SM_STOP:
+		bfa_reqq_wcancel(&pport->reqq_wait);
+		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+		break;
+
+	case BFA_PPORT_SM_ENABLE:
+		/**
+		 * Already enable is in progress.
+		 */
+		break;
+
+	case BFA_PPORT_SM_DISABLE:
+		/**
+		 * Just send disable request to firmware when room becomes
+		 * available in request queue.
+		 */
+		bfa_sm_set_state(pport, bfa_pport_sm_disabling_qwait);
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_DISABLE);
+		break;
+
+	case BFA_PPORT_SM_LINKUP:
+	case BFA_PPORT_SM_LINKDOWN:
+		/**
+		 * Possible to get link events when doing back-to-back
+		 * enable/disables.
+		 */
+		break;
+
+	case BFA_PPORT_SM_HWFAIL:
+		bfa_reqq_wcancel(&pport->reqq_wait);
+		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_pport_sm_enabling(struct bfa_pport_s *pport,
+						enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	/* FCS_BRINGUP*/
+	printk(" function: %s, Line %d event %d\n",__FUNCTION__, __LINE__, event);
+	switch (event) {
+	case BFA_PPORT_SM_FWRSP:
+	case BFA_PPORT_SM_LINKDOWN:
+		bfa_sm_set_state(pport, bfa_pport_sm_linkdown);
+		break;
+
+	case BFA_PPORT_SM_LINKUP:
+		bfa_pport_update_linkinfo(pport);
+		bfa_sm_set_state(pport, bfa_pport_sm_linkup);
+		if(!bfa_fw_disc_enabled(pport->bfa)) {
+			bfa_assert(pport->event_cbfn);
+			bfa_pport_callback(pport, BFA_PPORT_LINKUP);
+		}
+		break;
+
+	case BFA_PPORT_SM_ENABLE:
+		/**
+		 * Already being enabled.
+		 */
+		break;
+
+	case BFA_PPORT_SM_DISABLE:
+		if (bfa_pport_send_disable(pport))
+			bfa_sm_set_state(pport, bfa_pport_sm_disabling);
+		else
+			bfa_sm_set_state(pport,
+					 bfa_pport_sm_disabling_qwait);
+
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_DISABLE);
+		break;
+
+	case BFA_PPORT_SM_STOP:
+		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+		break;
+
+	case BFA_PPORT_SM_HWFAIL:
+		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_pport_sm_linkdown(struct bfa_pport_s *pport,
+						enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	/* FCS_BRINGUP*/
+	printk(" function: %s, Line %d event %d\n",__FUNCTION__, __LINE__, event);
+	switch (event) {
+	case BFA_PPORT_SM_LINKUP:
+		bfa_pport_update_linkinfo(pport);
+		bfa_sm_set_state(pport, bfa_pport_sm_linkup);
+
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_ST_CHANGE, 0, "Port Linkup");
+		if(!bfa_fw_disc_enabled(pport->bfa)) {
+			bfa_assert(pport->event_cbfn);
+			bfa_pport_callback(pport, BFA_PPORT_LINKUP);
+		}
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_ONLINE);
+		/**
+		 * If QoS is enabled and it is not online,
+		 * Send a separate event.
+		 */
+		if ((pport->cfg.qos_enabled) &&
+			(bfa_os_ntohl(pport->qos_attr.state) != BFA_QOS_ONLINE))
+			bfa_pport_aen_post(pport, BFA_PORT_AEN_QOS_NEG);
+
+		break;
+
+	case BFA_PPORT_SM_LINKDOWN:
+		/**
+		 * Possible to get link down event.
+		 */
+		break;
+
+	case BFA_PPORT_SM_ENABLE:
+		/**
+		 * Already enabled.
+		 */
+		break;
+
+	case BFA_PPORT_SM_DISABLE:
+		if (bfa_pport_send_disable(pport))
+			bfa_sm_set_state(pport, bfa_pport_sm_disabling);
+		else
+			bfa_sm_set_state(pport,
+					 bfa_pport_sm_disabling_qwait);
+
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_DISABLE);
+		break;
+
+	case BFA_PPORT_SM_STOP:
+		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+		break;
+
+	case BFA_PPORT_SM_HWFAIL:
+		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_pport_sm_linkup(struct bfa_pport_s *pport, enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_ENABLE:
+		/**
+		 * Already enabled.
+		 */
+		break;
+
+	case BFA_PPORT_SM_DISABLE:
+		if (bfa_pport_send_disable(pport))
+			bfa_sm_set_state(pport, bfa_pport_sm_disabling);
+		else
+			bfa_sm_set_state(pport,
+					 bfa_pport_sm_disabling_qwait);
+
+		bfa_pport_reset_linkinfo(pport);
+		bfa_pport_callback(pport, BFA_PPORT_LINKDOWN);
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_DISABLE, 0, "Port Disable");
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_DISABLE);
+		break;
+
+	case BFA_PPORT_SM_LINKDOWN:
+		bfa_sm_set_state(pport, bfa_pport_sm_linkdown);
+		bfa_pport_reset_linkinfo(pport);
+		bfa_pport_callback(pport, BFA_PPORT_LINKDOWN);
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_ST_CHANGE, 0, "Port Linkdown");
+		if (BFA_PORT_IS_OFFLINE(pport->bfa)) {
+			bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
+		} else {
+			bfa_pport_aen_post(pport, BFA_PORT_AEN_DISCONNECT);
+		}
+		break;
+
+	case BFA_PPORT_SM_STOP:
+		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+		bfa_pport_reset_linkinfo(pport);
+		if (BFA_PORT_IS_OFFLINE(pport->bfa)) {
+			bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
+		} else {
+			bfa_pport_aen_post(pport, BFA_PORT_AEN_DISCONNECT);
+		}
+		break;
+
+	case BFA_PPORT_SM_HWFAIL:
+		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
+		bfa_pport_reset_linkinfo(pport);
+		bfa_pport_callback(pport, BFA_PPORT_LINKDOWN);
+		if (BFA_PORT_IS_OFFLINE(pport->bfa)) {
+			bfa_pport_aen_post(pport, BFA_PORT_AEN_OFFLINE);
+		} else {
+			bfa_pport_aen_post(pport, BFA_PORT_AEN_DISCONNECT);
+		}
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_pport_sm_disabling_qwait(struct bfa_pport_s *pport,
+				 enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_QRESUME:
+		bfa_sm_set_state(pport, bfa_pport_sm_disabling);
+		bfa_pport_send_disable(pport);
+		break;
+
+	case BFA_PPORT_SM_STOP:
+		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+		bfa_reqq_wcancel(&pport->reqq_wait);
+		break;
+
+	case BFA_PPORT_SM_ENABLE:
+		/**
+		 * Just send enable request to firmware when room becomes
+		 * available in request queue.
+		 */
+		bfa_sm_set_state(pport, bfa_pport_sm_enabling_qwait);
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_ENABLE, 0, "Port Enable");
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_ENABLE);
+		break;
+
+	case BFA_PPORT_SM_DISABLE:
+		/**
+		 * Already being disabled.
+		 */
+		bfa_sm_set_state(pport, bfa_pport_sm_disabling_qwait);
+		break;
+
+	case BFA_PPORT_SM_LINKUP:
+	case BFA_PPORT_SM_LINKDOWN:
+		/**
+		 * Possible to get link events when doing back-to-back
+		 * enable/disables.
+		 */
+		break;
+
+	case BFA_PPORT_SM_HWFAIL:
+		bfa_sm_set_state(pport, bfa_pport_sm_iocfail);
+		bfa_reqq_wcancel(&pport->reqq_wait);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_pport_sm_disabling(struct bfa_pport_s *pport,
+						enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	/* FCS_BRINGUP*/
+	printk(" function: %s, Line %d event %d\n",__FUNCTION__, __LINE__, event);
+	switch (event) {
+	case BFA_PPORT_SM_FWRSP:
+		bfa_sm_set_state(pport, bfa_pport_sm_disabled);
+		break;
+
+	case BFA_PPORT_SM_DISABLE:
+		/**
+		 * Already being disabled.
+		 */
+		break;
+
+	case BFA_PPORT_SM_ENABLE:
+		if (bfa_pport_send_enable(pport))
+			bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+		else
+			bfa_sm_set_state(pport,
+					 bfa_pport_sm_enabling_qwait);
+
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_ENABLE, 0, "Port Enable");
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_ENABLE);
+		break;
+
+	case BFA_PPORT_SM_STOP:
+		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+		break;
+
+	case BFA_PPORT_SM_LINKUP:
+	case BFA_PPORT_SM_LINKDOWN:
+		/**
+		 * Possible to get link events when doing back-to-back
+		 * enable/disables.
+		 */
+		break;
+
+	case BFA_PPORT_SM_HWFAIL:
+		bfa_sm_set_state(pport, bfa_pport_sm_iocfail);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_pport_sm_disabled(struct bfa_pport_s *pport,
+						enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_START:
+		/**
+		 * Ignore start event for a port that is disabled.
+		 */
+		break;
+
+	case BFA_PPORT_SM_STOP:
+		bfa_sm_set_state(pport, bfa_pport_sm_stopped);
+		break;
+
+	case BFA_PPORT_SM_ENABLE:
+		if (bfa_pport_send_enable(pport))
+			bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+		else
+			bfa_sm_set_state(pport,
+					 bfa_pport_sm_enabling_qwait);
+
+		bfa_plog_str(pport->bfa->plog, BFA_PL_MID_HAL,
+				BFA_PL_EID_PORT_ENABLE, 0, "Port Enable");
+		bfa_pport_aen_post(pport, BFA_PORT_AEN_ENABLE);
+		break;
+
+	case BFA_PPORT_SM_DISABLE:
+		/**
+		 * Already disabled.
+		 */
+		break;
+
+	case BFA_PPORT_SM_HWFAIL:
+		bfa_sm_set_state(pport, bfa_pport_sm_iocfail);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_pport_sm_stopped(struct bfa_pport_s *pport,
+			 enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_START:
+		if (bfa_pport_send_enable(pport))
+			bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+		else
+			bfa_sm_set_state(pport,
+					 bfa_pport_sm_enabling_qwait);
+		break;
+
+	default:
+		/**
+		 * Ignore all other events.
+		 */
+		;
+	}
+}
+
+/**
+ * Port is enabled. IOC is down/failed.
+ */
+static void
+bfa_pport_sm_iocdown(struct bfa_pport_s *pport,
+			 enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_START:
+		if (bfa_pport_send_enable(pport))
+			bfa_sm_set_state(pport, bfa_pport_sm_enabling);
+		else
+			bfa_sm_set_state(pport,
+					 bfa_pport_sm_enabling_qwait);
+		break;
+
+	default:
+		/**
+		 * Ignore all events.
+		 */
+		;
+	}
+}
+
+/**
+ * Port is disabled. IOC is down/failed.
+ */
+static void
+bfa_pport_sm_iocfail(struct bfa_pport_s *pport,
+			 enum bfa_pport_sm_event event)
+{
+	bfa_trc(pport->bfa, event);
+
+	switch (event) {
+	case BFA_PPORT_SM_START:
+		bfa_sm_set_state(pport, bfa_pport_sm_disabled);
+		break;
+
+	case BFA_PPORT_SM_ENABLE:
+		bfa_sm_set_state(pport, bfa_pport_sm_iocdown);
+		break;
+
+	default:
+		/**
+		 * Ignore all events.
+		 */
+		;
+	}
+}
+
+
+
+/**
+ *  hal_pport_private
+ */
+
+static void
+__bfa_cb_port_event(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_pport_s *pport = cbarg;
+
+	if (complete)
+		pport->event_cbfn(pport->event_cbarg, pport->hcb_event);
+}
+
+#define PPORT_STATS_DMA_SZ (BFA_ROUNDUP(sizeof(struct bfa_pport_stats_s), \
+							BFA_CACHELINE_SZ))
+
+static void
+bfa_pport_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,
+		u32 *dm_len)
+{
+	*dm_len += PPORT_STATS_DMA_SZ;
+}
+
+static void
+bfa_pport_qresume(void *cbarg)
+{
+	struct bfa_pport_s *port = cbarg;
+
+	bfa_sm_send_event(port, BFA_PPORT_SM_QRESUME);
+}
+
+static void
+bfa_pport_mem_claim(struct bfa_pport_s *pport, struct bfa_meminfo_s *meminfo)
+{
+	u8		*dm_kva;
+	u64	dm_pa;
+
+	dm_kva = bfa_meminfo_dma_virt(meminfo);
+	dm_pa = bfa_meminfo_dma_phys(meminfo);
+
+	pport->stats_kva = dm_kva;
+	pport->stats_pa = dm_pa;
+	pport->stats = (struct bfa_pport_stats_s *) dm_kva;
+
+	dm_kva += PPORT_STATS_DMA_SZ;
+	dm_pa += PPORT_STATS_DMA_SZ;
+
+	bfa_meminfo_dma_virt(meminfo) = dm_kva;
+	bfa_meminfo_dma_phys(meminfo) = dm_pa;
+}
+
+/**
+ * Memory initialization.
+ */
+static void
+bfa_pport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_pport_cfg_s *port_cfg = &pport->cfg;
+
+	bfa_os_memset(pport, 0, sizeof(struct bfa_pport_s));
+	pport->bfa = bfa;
+
+	bfa_pport_mem_claim(pport, meminfo);
+
+	bfa_sm_set_state(pport, bfa_pport_sm_uninit);
+
+	/**
+	 * initialize and set default configuration
+	 */
+	port_cfg->topology = BFA_PPORT_TOPOLOGY_P2P;
+	port_cfg->speed = BFA_PPORT_SPEED_AUTO;
+	port_cfg->trunked = BFA_FALSE;
+	port_cfg->maxfrsize = 0;
+
+	bfa_reqq_winit(&pport->reqq_wait, bfa_pport_qresume, pport);
+}
+
+static void
+bfa_pport_initdone(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	/**
+	 * Initialize port attributes from IOC hardware data.
+	 */
+	bfa_pport_set_wwns(pport);
+	if (pport->cfg.maxfrsize == 0)
+		pport->cfg.maxfrsize = bfa_ioc_maxfrsize(&bfa->ioc);
+	pport->cfg.rx_bbcredit = bfa_ioc_rx_bbcredit(&bfa->ioc);
+	pport->speed_sup = bfa_ioc_speed_sup(&bfa->ioc);
+
+	bfa_assert(pport->cfg.maxfrsize);
+	bfa_assert(pport->cfg.rx_bbcredit);
+	bfa_assert(pport->speed_sup);
+}
+
+static void
+bfa_pport_detach(struct bfa_s *bfa)
+{
+}
+
+/**
+ * Called when IOC is ready.
+ */
+static void
+bfa_pport_start(struct bfa_s *bfa)
+{
+	bfa_sm_send_event(BFA_PORT_MOD(bfa), BFA_PPORT_SM_START);
+}
+
+/**
+ * Called before IOC is stopped.
+ */
+static void
+bfa_pport_stop(struct bfa_s *bfa)
+{
+	bfa_sm_send_event(BFA_PORT_MOD(bfa), BFA_PPORT_SM_STOP);
+}
+
+/**
+ * Called when IOC failure is detected.
+ */
+static void
+bfa_pport_iocdisable(struct bfa_s *bfa)
+{
+	bfa_sm_send_event(BFA_PORT_MOD(bfa), BFA_PPORT_SM_HWFAIL);
+}
+
+static void
+bfa_pport_update_linkinfo(struct bfa_pport_s *pport)
+{
+	struct bfi_pport_event_s *pevent = pport->event_arg.i2hmsg.event;
+
+	pport->speed = pevent->link_state.speed;
+	pport->topology = pevent->link_state.topology;
+
+	if (pport->topology == BFA_PPORT_TOPOLOGY_LOOP)
+		pport->myalpa =
+			pevent->link_state.tl.loop_info.myalpa;
+
+	/* QoS Details */
+	pport->qos_attr    = pevent->link_state.qos_attr;
+	pport->qos_vc_attr = pevent->link_state.qos_vc_attr;
+
+	bfa_trc(pport->bfa, pport->speed);
+	bfa_trc(pport->bfa, pport->topology);
+}
+
+static void
+bfa_pport_reset_linkinfo(struct bfa_pport_s *pport)
+{
+	pport->speed = BFA_PPORT_SPEED_UNKNOWN;
+	pport->topology = BFA_PPORT_TOPOLOGY_NONE;
+}
+
+/**
+ * Send port enable message to firmware.
+ */
+static bfa_boolean_t
+bfa_pport_send_enable(struct bfa_pport_s *port)
+{
+	struct bfi_pport_enable_req_s *m;
+
+	/**
+	 * Increment message tag before queue check, so that responses to old
+	 * requests are discarded.
+	 */
+	port->msgtag++;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+	if (!m) {
+		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT,
+							&port->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_ENABLE_REQ,
+			bfa_lpuid(port->bfa));
+	m->nwwn = port->nwwn;
+	m->pwwn = port->pwwn;
+	m->port_cfg = port->cfg;
+	m->msgtag = port->msgtag;
+	m->port_cfg.maxfrsize = bfa_os_htons(port->cfg.maxfrsize);
+	bfa_dma_be_addr_set(m->stats_dma_addr, port->stats_pa);
+	bfa_trc(port->bfa, m->stats_dma_addr.a32.addr_lo);
+	bfa_trc(port->bfa, m->stats_dma_addr.a32.addr_hi);
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+	return BFA_TRUE;
+}
+
+/**
+ * Send port disable message to firmware.
+ */
+static	bfa_boolean_t
+bfa_pport_send_disable(struct bfa_pport_s *port)
+{
+	bfi_pport_disable_req_t *m;
+
+	/**
+	 * Increment message tag before queue check, so that responses to old
+	 * requests are discarded.
+	 */
+	port->msgtag++;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+	if (!m) {
+		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT,
+							&port->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_DISABLE_REQ,
+			bfa_lpuid(port->bfa));
+	m->msgtag = port->msgtag;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+
+	return BFA_TRUE;
+}
+
+static void
+bfa_pport_set_wwns(struct bfa_pport_s *port)
+{
+	port->pwwn = bfa_ioc_get_pwwn(&port->bfa->ioc);
+	port->nwwn = bfa_ioc_get_nwwn(&port->bfa->ioc);
+
+	bfa_trc(port->bfa, port->pwwn);
+	bfa_trc(port->bfa, port->nwwn);
+}
+
+static void
+bfa_port_send_txcredit(void *port_cbarg)
+{
+
+	struct bfa_pport_s *port = port_cbarg;
+	struct bfi_pport_set_svc_params_req_s *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+	if (!m) {
+		bfa_reqq_winit(&port->svcreq_wait,
+					bfa_port_send_txcredit, port);
+		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT,
+							&port->svcreq_wait);
+		return;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_SET_SVC_PARAMS_REQ,
+			bfa_lpuid(port->bfa));
+	m->tx_bbcredit = bfa_os_htons((u16)port->cfg.tx_bbcredit);
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+}
+
+
+
+/**
+ *  hal_pport_public
+ */
+
+/**
+ * Firmware message handler.
+ */
+void
+bfa_pport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	union bfi_pport_i2h_msg_u i2hmsg;
+
+	/* FCS_BRINGUP*/
+	printk(" pport %p , msg %p bfa %p\n",pport, msg, bfa);
+	i2hmsg.msg = msg;
+	pport->event_arg.i2hmsg = i2hmsg;
+
+	/* FCS_BRINGUP*/
+	printk(" function: %s, Line %d msg_id %d\n",__FUNCTION__, __LINE__, msg->mhdr.msg_id);
+	switch (msg->mhdr.msg_id) {
+	case BFI_PPORT_I2H_ENABLE_RSP:
+		if (pport->msgtag == i2hmsg.enable_rsp->msgtag)
+			bfa_sm_send_event(pport, BFA_PPORT_SM_FWRSP);
+		break;
+
+	case BFI_PPORT_I2H_DISABLE_RSP:
+		if (pport->msgtag == i2hmsg.enable_rsp->msgtag)
+			bfa_sm_send_event(pport, BFA_PPORT_SM_FWRSP);
+		break;
+
+	case BFI_PPORT_I2H_EVENT:
+	printk(" function: %s, Line %d linkstate %d\n",__FUNCTION__, __LINE__, i2hmsg.event->link_state.linkstate);
+		switch (i2hmsg.event->link_state.linkstate) {
+		case BFA_PPORT_LINKUP:
+			bfa_sm_send_event(pport, BFA_PPORT_SM_LINKUP);
+			break;
+		case BFA_PPORT_LINKDOWN:
+			bfa_sm_send_event(pport, BFA_PPORT_SM_LINKDOWN);
+			break;
+		case BFA_PPORT_TRUNK_LINKDOWN:
+			/** todo: event notification */
+			break;
+		}
+		break;
+
+	case BFI_PPORT_I2H_GET_STATS_RSP:
+	case BFI_PPORT_I2H_GET_QOS_STATS_RSP:
+		/*
+		 * check for timer pop before processing the rsp
+		 */
+		if (pport->stats_busy == BFA_FALSE
+				|| pport->stats_status == BFA_STATUS_ETIMER)
+			break;
+
+		bfa_timer_stop(&pport->timer);
+		pport->stats_status = i2hmsg.getstats_rsp->status;
+		bfa_cb_queue(pport->bfa, &pport->hcb_qe, __bfa_cb_port_stats,
+									pport);
+		break;
+	case BFI_PPORT_I2H_CLEAR_STATS_RSP:
+	case BFI_PPORT_I2H_CLEAR_QOS_STATS_RSP:
+		/*
+		 * check for timer pop before processing the rsp
+		 */
+		if (pport->stats_busy == BFA_FALSE
+				|| pport->stats_status == BFA_STATUS_ETIMER)
+			break;
+
+		bfa_timer_stop(&pport->timer);
+		pport->stats_status = BFA_STATUS_OK;
+		bfa_cb_queue(pport->bfa, &pport->hcb_qe,
+					__bfa_cb_port_stats_clr, pport);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  hal_pport_api
+ */
+
+/**
+ * Registered callback for port events.
+ */
+void
+bfa_pport_event_register(struct bfa_s *bfa,
+				void (*cbfn) (void *cbarg,
+				bfa_pport_event_t event),
+				void *cbarg)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	pport->event_cbfn = cbfn;
+	pport->event_cbarg = cbarg;
+}
+
+bfa_status_t
+bfa_pport_enable(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	if (pport->diag_busy)
+		return (BFA_STATUS_DIAG_BUSY);
+
+	bfa_sm_send_event(BFA_PORT_MOD(bfa), BFA_PPORT_SM_ENABLE);
+	return BFA_STATUS_OK;
+}
+
+bfa_status_t
+bfa_pport_disable(struct bfa_s *bfa)
+{
+	bfa_sm_send_event(BFA_PORT_MOD(bfa), BFA_PPORT_SM_DISABLE);
+	return BFA_STATUS_OK;
+}
+
+/**
+ * Configure port speed.
+ */
+bfa_status_t
+bfa_pport_cfg_speed(struct bfa_s *bfa, enum bfa_pport_speed speed)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, speed);
+
+	if ((speed != BFA_PPORT_SPEED_AUTO) && (speed > pport->speed_sup)) {
+		bfa_trc(bfa, pport->speed_sup);
+		return BFA_STATUS_UNSUPP_SPEED;
+	}
+
+	pport->cfg.speed = speed;
+
+	return (BFA_STATUS_OK);
+}
+
+/**
+ * Get current speed.
+ */
+enum bfa_pport_speed
+bfa_pport_get_speed(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	return port->speed;
+}
+
+/**
+ * Configure port topology.
+ */
+bfa_status_t
+bfa_pport_cfg_topology(struct bfa_s *bfa, enum bfa_pport_topology topology)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, topology);
+	bfa_trc(bfa, pport->cfg.topology);
+
+	switch (topology) {
+	case BFA_PPORT_TOPOLOGY_P2P:
+	case BFA_PPORT_TOPOLOGY_LOOP:
+	case BFA_PPORT_TOPOLOGY_AUTO:
+		break;
+
+	default:
+		return BFA_STATUS_EINVAL;
+	}
+
+	pport->cfg.topology = topology;
+	return (BFA_STATUS_OK);
+}
+
+/**
+ * Get current topology.
+ */
+enum bfa_pport_topology
+bfa_pport_get_topology(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	return port->topology;
+}
+
+bfa_status_t
+bfa_pport_cfg_hardalpa(struct bfa_s *bfa, u8 alpa)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, alpa);
+	bfa_trc(bfa, pport->cfg.cfg_hardalpa);
+	bfa_trc(bfa, pport->cfg.hardalpa);
+
+	pport->cfg.cfg_hardalpa = BFA_TRUE;
+	pport->cfg.hardalpa = alpa;
+
+	return (BFA_STATUS_OK);
+}
+
+bfa_status_t
+bfa_pport_clr_hardalpa(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, pport->cfg.cfg_hardalpa);
+	bfa_trc(bfa, pport->cfg.hardalpa);
+
+	pport->cfg.cfg_hardalpa = BFA_FALSE;
+	return (BFA_STATUS_OK);
+}
+
+bfa_boolean_t
+bfa_pport_get_hardalpa(struct bfa_s *bfa, u8 *alpa)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	*alpa = port->cfg.hardalpa;
+	return port->cfg.cfg_hardalpa;
+}
+
+u8
+bfa_pport_get_myalpa(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	return port->myalpa;
+}
+
+bfa_status_t
+bfa_pport_cfg_maxfrsize(struct bfa_s *bfa, u16 maxfrsize)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, maxfrsize);
+	bfa_trc(bfa, pport->cfg.maxfrsize);
+
+	/* with in range */
+	if ((maxfrsize > FC_MAX_PDUSZ) || (maxfrsize < FC_MIN_PDUSZ))
+		return (BFA_STATUS_INVLD_DFSZ);
+
+	/* power of 2, if not the max frame size of 2112 */
+	if ((maxfrsize != FC_MAX_PDUSZ) && (maxfrsize & (maxfrsize - 1)))
+		return (BFA_STATUS_INVLD_DFSZ);
+
+	pport->cfg.maxfrsize = maxfrsize;
+	return (BFA_STATUS_OK);
+}
+
+u16
+bfa_pport_get_maxfrsize(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	return port->cfg.maxfrsize;
+}
+
+u32
+bfa_pport_mypid(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	return port->mypid;
+}
+
+u8
+bfa_pport_get_rx_bbcredit(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	return port->cfg.rx_bbcredit;
+}
+
+void
+bfa_pport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	port->cfg.tx_bbcredit = (u8)tx_bbcredit;
+	bfa_port_send_txcredit(port);
+}
+
+/**
+ * Get port attributes.
+ */
+
+wwn_t
+bfa_pport_get_wwn(struct bfa_s *bfa, bfa_boolean_t node)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	if (node)
+		return pport->nwwn;
+	else
+		return pport->pwwn;
+}
+
+void
+bfa_pport_get_attr(struct bfa_s *bfa, struct bfa_pport_attr_s *attr)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_os_memset(attr, 0, sizeof(struct bfa_pport_attr_s));
+
+	attr->nwwn = pport->nwwn;
+	attr->pwwn = pport->pwwn;
+
+	bfa_os_memcpy(&attr->pport_cfg, &pport->cfg,
+		sizeof(struct bfa_pport_cfg_s));
+	/* speed attributes */
+	attr->pport_cfg.speed = pport->cfg.speed;
+	attr->speed_supported = pport->speed_sup;
+	attr->speed = pport->speed;
+	attr->cos_supported = FC_CLASS_3;
+
+	/* topology attributes */
+	attr->pport_cfg.topology = pport->cfg.topology;
+	attr->topology = pport->topology;
+
+	/* beacon attributes */
+	attr->beacon = pport->beacon;
+	attr->link_e2e_beacon = pport->link_e2e_beacon;
+	attr->plog_enabled = bfa_plog_get_setting(pport->bfa->plog);
+
+	attr->pport_cfg.path_tov  = bfa_fcpim_path_tov_get(bfa);
+	attr->pport_cfg.q_depth  = bfa_fcpim_qdepth_get(bfa);
+	attr->port_state = bfa_sm_to_state(hal_pport_sm_table, pport->sm);
+}
+
+static void
+bfa_port_stats_query(void *cbarg)
+{
+	struct bfa_pport_s *port = (struct bfa_pport_s *) cbarg;
+	bfi_pport_get_stats_req_t *msg;
+
+	msg = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+
+	if (!msg) {
+		bfa_reqq_winit(&port->stats_reqq_wait,
+						bfa_port_stats_query, port);
+		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT,
+						&port->stats_reqq_wait);
+		return;
+	}
+
+	bfa_os_memset(msg, 0, sizeof(bfi_pport_get_stats_req_t));
+	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_GET_STATS_REQ,
+			bfa_lpuid(port->bfa));
+	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+
+	return;
+}
+
+static void
+bfa_port_stats_clear(void *cbarg)
+{
+	struct bfa_pport_s *port = (struct bfa_pport_s *) cbarg;
+	bfi_pport_clear_stats_req_t *msg;
+
+	msg = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+
+	if (!msg) {
+		bfa_reqq_winit(&port->stats_reqq_wait,
+						bfa_port_stats_clear, port);
+		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT,
+						&port->stats_reqq_wait);
+		return;
+	}
+
+	bfa_os_memset(msg, 0, sizeof(bfi_pport_clear_stats_req_t));
+	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_CLEAR_STATS_REQ,
+			bfa_lpuid(port->bfa));
+	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+	return;
+}
+
+static void
+bfa_port_qos_stats_clear(void *cbarg)
+{
+	struct bfa_pport_s *port = (struct bfa_pport_s *) cbarg;
+	bfi_pport_clear_qos_stats_req_t *msg;
+
+	msg = bfa_reqq_next(port->bfa, BFA_REQQ_PORT);
+
+	if (!msg) {
+		bfa_reqq_winit(&port->stats_reqq_wait,
+						bfa_port_qos_stats_clear, port);
+		bfa_reqq_wait(port->bfa, BFA_REQQ_PORT,
+						&port->stats_reqq_wait);
+		return;
+	}
+
+	bfa_os_memset(msg, 0, sizeof(bfi_pport_clear_qos_stats_req_t));
+	bfi_h2i_set(msg->mh, BFI_MC_FC_PORT, BFI_PPORT_H2I_CLEAR_QOS_STATS_REQ,
+			bfa_lpuid(port->bfa));
+	bfa_reqq_produce(port->bfa, BFA_REQQ_PORT);
+	return;
+}
+
+static void
+bfa_pport_stats_swap(struct bfa_pport_stats_s *d, struct bfa_pport_stats_s *s)
+{
+	u32	*dip = (u32 *) d;
+	u32	*sip = (u32 *) s;
+	int		i;
+
+	/* Do 64 bit fields swap first */
+	for (i = 0; i < ((sizeof(struct bfa_pport_stats_s) -
+		sizeof(struct bfa_qos_stats_s))/sizeof(u32)); i = i + 2) {
+#ifdef __BIGENDIAN
+		dip[i] = bfa_os_ntohl(sip[i]);
+		dip[i + 1] = bfa_os_ntohl(sip[i + 1]);
+#else
+		dip[i] = bfa_os_ntohl(sip[i + 1]);
+		dip[i + 1] = bfa_os_ntohl(sip[i]);
+#endif
+	}
+
+	/* Now swap the 32 bit fields */
+	for (; i < (sizeof(struct bfa_pport_stats_s)/sizeof(u32)); ++i)
+		dip[i] = bfa_os_ntohl(sip[i]);
+}
+
+static void
+__bfa_cb_port_stats_clr(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_pport_s *port = cbarg;
+
+	if (complete) {
+		port->stats_cbfn(port->stats_cbarg, port->stats_status);
+	} else {
+		port->stats_busy = BFA_FALSE;
+		port->stats_status = BFA_STATUS_OK;
+	}
+}
+
+static void
+bfa_port_stats_clr_timeout(void *cbarg)
+{
+	struct bfa_pport_s *port = (struct bfa_pport_s *) cbarg;
+
+	bfa_trc(port->bfa, 0);
+
+	port->stats_status = BFA_STATUS_ETIMER;
+	bfa_cb_queue(port->bfa, &port->hcb_qe, __bfa_cb_port_stats_clr, port);
+}
+
+static void
+__bfa_cb_port_stats(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_pport_s *port = cbarg;
+
+	if (complete) {
+		if (port->stats_status == BFA_STATUS_OK)
+			bfa_pport_stats_swap(port->stats_ret, port->stats);
+		port->stats_cbfn(port->stats_cbarg, port->stats_status);
+	} else {
+		port->stats_busy = BFA_FALSE;
+		port->stats_status = BFA_STATUS_OK;
+	}
+}
+
+static void
+bfa_port_stats_timeout(void *cbarg)
+{
+	struct bfa_pport_s *port = (struct bfa_pport_s *) cbarg;
+
+	bfa_trc(port->bfa, 0);
+
+	port->stats_status = BFA_STATUS_ETIMER;
+	bfa_cb_queue(port->bfa, &port->hcb_qe, __bfa_cb_port_stats, port);
+}
+
+#define BFA_PORT_STATS_TOV	1000
+
+/**
+ * Fetch port attributes.
+ */
+bfa_status_t
+bfa_pport_get_stats(struct bfa_s *bfa, struct bfa_pport_stats_s *stats,
+			bfa_cb_pport_t cbfn, void *cbarg)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	if (port->stats_busy) {
+		bfa_trc(bfa, port->stats_busy);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	port->stats_busy = BFA_TRUE;
+	port->stats_ret = stats;
+	port->stats_cbfn = cbfn;
+	port->stats_cbarg = cbarg;
+
+	bfa_port_stats_query(port);
+
+	bfa_timer_start(bfa, &port->timer, bfa_port_stats_timeout, port,
+						BFA_PORT_STATS_TOV);
+	return (BFA_STATUS_OK);
+}
+
+bfa_status_t
+bfa_pport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	if (port->stats_busy) {
+		bfa_trc(bfa, port->stats_busy);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	port->stats_busy = BFA_TRUE;
+	port->stats_cbfn = cbfn;
+	port->stats_cbarg = cbarg;
+
+	bfa_port_stats_clear(port);
+
+	bfa_timer_start(bfa, &port->timer, bfa_port_stats_clr_timeout,
+					port, BFA_PORT_STATS_TOV);
+	return (BFA_STATUS_OK);
+}
+
+bfa_status_t
+bfa_pport_trunk_enable(struct bfa_s *bfa, u8 bitmap)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, bitmap);
+	bfa_trc(bfa, pport->cfg.trunked);
+	bfa_trc(bfa, pport->cfg.trunk_ports);
+
+	if (!bitmap || (bitmap & (bitmap - 1)))
+		return BFA_STATUS_EINVAL;
+
+	pport->cfg.trunked = BFA_TRUE;
+	pport->cfg.trunk_ports = bitmap;
+
+	return BFA_STATUS_OK;
+}
+
+void
+bfa_pport_qos_get_attr(struct bfa_s *bfa, struct bfa_qos_attr_s *qos_attr)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	qos_attr->state = bfa_os_ntohl(pport->qos_attr.state);
+	qos_attr->total_bb_cr = bfa_os_ntohl(pport->qos_attr.total_bb_cr);
+}
+
+void
+bfa_pport_qos_get_vc_attr(struct bfa_s *bfa,
+	struct bfa_qos_vc_attr_s *qos_vc_attr)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+	struct bfa_qos_vc_attr_s *bfa_vc_attr = &pport->qos_vc_attr;
+	u32 i = 0;
+
+	qos_vc_attr->total_vc_count = bfa_os_ntohs(bfa_vc_attr->total_vc_count);
+	qos_vc_attr->shared_credit  = bfa_os_ntohs(bfa_vc_attr->shared_credit);
+	qos_vc_attr->elp_opmode_flags  =
+			bfa_os_ntohl(bfa_vc_attr->elp_opmode_flags);
+
+	/* Individual VC info */
+	while (i < qos_vc_attr->total_vc_count) {
+		qos_vc_attr->vc_info[i].vc_credit      =
+				bfa_vc_attr->vc_info[i].vc_credit;
+		qos_vc_attr->vc_info[i].borrow_credit  =
+				bfa_vc_attr->vc_info[i].borrow_credit;
+		qos_vc_attr->vc_info[i].priority       =
+				bfa_vc_attr->vc_info[i].priority;
+		++i;
+	}
+}
+
+/**
+ * Fetch QoS Stats.
+ */
+bfa_status_t
+bfa_pport_get_qos_stats(struct bfa_s *bfa, struct bfa_pport_stats_s *stats,
+			bfa_cb_pport_t cbfn, void *cbarg)
+{
+	/* QoS stats is embedded in port stats */
+	return (bfa_pport_get_stats(bfa, stats, cbfn, cbarg));
+}
+
+bfa_status_t
+bfa_pport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn, void *cbarg)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	if (port->stats_busy) {
+		bfa_trc(bfa, port->stats_busy);
+		return (BFA_STATUS_DEVBUSY);
+	}
+
+	port->stats_busy = BFA_TRUE;
+	port->stats_cbfn = cbfn;
+	port->stats_cbarg = cbarg;
+
+	bfa_port_qos_stats_clear(port);
+
+	bfa_timer_start(bfa, &port->timer, bfa_port_stats_clr_timeout,
+					port, BFA_PORT_STATS_TOV);
+	return (BFA_STATUS_OK);
+}
+
+/**
+ * Fetch port attributes.
+ */
+bfa_status_t
+bfa_pport_trunk_disable(struct bfa_s *bfa)
+{
+	return (BFA_STATUS_OK);
+}
+
+bfa_boolean_t
+bfa_pport_trunk_query(struct bfa_s *bfa, u32 *bitmap)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	*bitmap = port->cfg.trunk_ports;
+	return port->cfg.trunked;
+}
+
+bfa_boolean_t
+bfa_pport_is_disabled(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *port = BFA_PORT_MOD(bfa);
+
+	return (bfa_sm_to_state(hal_pport_sm_table, port->sm) ==
+		BFA_PPORT_ST_DISABLED);
+
+}
+
+bfa_boolean_t
+bfa_pport_is_ratelim(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	return(pport->cfg.ratelimit ? BFA_TRUE : BFA_FALSE);
+
+}
+
+void
+bfa_pport_cfg_qos(struct bfa_s *bfa, bfa_boolean_t on_off)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, on_off);
+	bfa_trc(bfa, pport->cfg.qos_enabled);
+
+	pport->cfg.qos_enabled = on_off;
+}
+
+void
+bfa_pport_cfg_ratelim(struct bfa_s *bfa, bfa_boolean_t on_off)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, on_off);
+	bfa_trc(bfa, pport->cfg.ratelimit);
+
+	pport->cfg.ratelimit = on_off;
+	if (pport->cfg.trl_def_speed == BFA_PPORT_SPEED_UNKNOWN)
+		pport->cfg.trl_def_speed = BFA_PPORT_SPEED_1GBPS;
+}
+
+/**
+ * Configure default minimum ratelim speed
+ */
+bfa_status_t
+bfa_pport_cfg_ratelim_speed(struct bfa_s *bfa, enum bfa_pport_speed speed)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, speed);
+
+	/* Auto and speeds greater than the supported speed, are invalid */
+	if ((speed == BFA_PPORT_SPEED_AUTO) || (speed > pport->speed_sup)) {
+		bfa_trc(bfa, pport->speed_sup);
+		return BFA_STATUS_UNSUPP_SPEED;
+	}
+
+	pport->cfg.trl_def_speed = speed;
+
+	return (BFA_STATUS_OK);
+}
+
+/**
+ * Get default minimum ratelim speed
+ */
+enum bfa_pport_speed
+bfa_pport_get_ratelim_speed(struct bfa_s *bfa)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, pport->cfg.trl_def_speed);
+	return(pport->cfg.trl_def_speed);
+
+}
+void
+bfa_pport_busy(struct bfa_s *bfa, bfa_boolean_t status)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, status);
+	bfa_trc(bfa, pport->diag_busy);
+
+	pport->diag_busy = status;
+}
+
+void
+bfa_pport_beacon(struct bfa_s *bfa, bfa_boolean_t beacon,
+	bfa_boolean_t link_e2e_beacon)
+{
+	struct bfa_pport_s *pport = BFA_PORT_MOD(bfa);
+
+	bfa_trc(bfa, beacon);
+	bfa_trc(bfa, link_e2e_beacon);
+	bfa_trc(bfa, pport->beacon);
+	bfa_trc(bfa, pport->link_e2e_beacon);
+
+	pport->beacon = beacon;
+	pport->link_e2e_beacon = link_e2e_beacon;
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_port_priv.h patch/drivers/scsi/bfa/bfa_port_priv.h
--- orig/drivers/scsi/bfa/bfa_port_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_port_priv.h	2009-03-14 11:44:57.273079000 -0700
@@ -0,0 +1,89 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_PORT_PRIV_H__
+#define __BFA_PORT_PRIV_H__
+
+#include <defs/bfa_defs_pport.h>
+#include <bfi/bfi_pport.h>
+#include "bfa_intr_priv.h"
+
+/**
+ * BFA physical port data structure
+ */
+struct bfa_pport_s {
+	struct bfa_s 		*bfa;	/*  parent BFA instance */
+	bfa_sm_t		sm;	/*  port state machine */
+	wwn_t			nwwn;	/*  node wwn of physical port */
+	wwn_t			pwwn;	/*  port wwn of physical oprt */
+	enum bfa_pport_speed speed_sup;
+					/*  supported speeds */
+	enum bfa_pport_speed speed;	/*  current speed */
+	enum bfa_pport_topology topology;	/*  current topology */
+	u8			myalpa;	/*  my ALPA in LOOP topology */
+	u8			rsvd[3];
+	struct bfa_pport_cfg_s	cfg;	/*  current port configuration */
+	struct bfa_qos_attr_s  qos_attr;   /* QoS Attributes */
+	struct bfa_qos_vc_attr_s qos_vc_attr;  /*  VC info from ELP */
+	struct bfa_reqq_wait_s	reqq_wait;
+					/*  to wait for room in reqq */
+	struct bfa_reqq_wait_s	svcreq_wait;
+					/*  to wait for room in reqq */
+	struct bfa_reqq_wait_s	stats_reqq_wait;
+					/*  to wait for room in reqq (stats) */
+	void			*event_cbarg;
+	void			(*event_cbfn) (void *cbarg,
+						bfa_pport_event_t event);
+	union {
+		union bfi_pport_i2h_msg_u i2hmsg;
+	} event_arg;
+	void			*bfad;	/*  BFA driver handle */
+	struct bfa_cb_qe_s		hcb_qe;	/*  BFA callback queue elem */
+	enum bfa_pport_linkstate	hcb_event;
+					/*  link event for callback */
+	u32		msgtag;	/*  fimrware msg tag for reply */
+	u8			*stats_kva;
+	u64		stats_pa;
+	struct bfa_pport_stats_s *stats;	/*  pport stats */
+	u32		mypid : 24;
+	u32		rsvd_b : 8;
+	struct bfa_timer_s 	timer;	/*  timer */
+	struct bfa_pport_stats_s 	*stats_ret;
+					/*  driver stats location */
+	bfa_status_t		stats_status;
+					/*  stats/statsclr status */
+	bfa_boolean_t   	stats_busy;
+					/*  outstanding stats/statsclr */
+	bfa_boolean_t   	diag_busy;
+					/*  diag busy status */
+	bfa_boolean_t   	beacon;
+					/*  port beacon status */
+	bfa_boolean_t   	link_e2e_beacon;
+					/*  link beacon status */
+	bfa_cb_pport_t		stats_cbfn;
+					/*  driver callback function */
+	void			*stats_cbarg;
+					/* *!< user callback arg */
+};
+
+#define BFA_PORT_MOD(__bfa)	(&(__bfa)->modules.pport)
+
+/*
+ * public functions
+ */
+void	bfa_pport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+#endif /* __BFA_PORT_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_priv.h patch/drivers/scsi/bfa/bfa_priv.h
--- orig/drivers/scsi/bfa/bfa_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_priv.h	2009-03-14 11:44:57.280544000 -0700
@@ -0,0 +1,120 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFA_PRIV_H__
+#define __BFA_PRIV_H__
+
+#include "bfa_iocfc.h"
+#include "bfa_intr_priv.h"
+#include "bfa_trcmod_priv.h"
+#include "bfa_modules_priv.h"
+#include "bfa_fwimg_priv.h"
+#include <cs/bfa_log.h>
+#include <bfa_timer.h>
+#include <bfa_fabric.h>
+
+/**
+ * Macro to define a new BFA module
+ */
+#define BFA_MODULE(__mod) 						\
+	static void bfa_ ## __mod ## _meminfo(				\
+			struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len,	\
+			u32 *dm_len );      \
+	static void bfa_ ## __mod ## _attach(struct bfa_s *bfa,		\
+			void *bfad, struct bfa_iocfc_cfg_s *cfg, 	\
+			struct bfa_meminfo_s *meminfo,			\
+			struct bfa_pcidev_s *pcidev );      \
+	static void bfa_ ## __mod ## _initdone(struct bfa_s *bfa );      \
+	static void bfa_ ## __mod ## _detach(struct bfa_s *bfa );      \
+	static void bfa_ ## __mod ## _start(struct bfa_s *bfa );      \
+	static void bfa_ ## __mod ## _stop(struct bfa_s *bfa );      \
+	static void bfa_ ## __mod ## _iocdisable(struct bfa_s *bfa );      \
+									\
+	extern struct bfa_module_s hal_mod_ ## __mod;			\
+	struct bfa_module_s hal_mod_ ## __mod = {			\
+		bfa_ ## __mod ## _meminfo,				\
+		bfa_ ## __mod ## _attach,				\
+		bfa_ ## __mod ## _initdone,				\
+		bfa_ ## __mod ## _detach,				\
+		bfa_ ## __mod ## _start,				\
+		bfa_ ## __mod ## _stop,					\
+		bfa_ ## __mod ## _iocdisable,				\
+	}
+
+#define BFA_CACHELINE_SZ	(256)
+
+/**
+ * Structure used to interact between different BFA sub modules
+ *
+ * Each sub module needs to implement only the entry points relevant to it (and
+ * can leave entry points as NULL)
+ */
+struct bfa_module_s {
+	void (*meminfo) (struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+			u32 *dm_len);
+	void (*attach) (struct bfa_s *bfa, void *bfad,
+			struct bfa_iocfc_cfg_s *cfg,
+			struct bfa_meminfo_s *meminfo,
+			struct bfa_pcidev_s *pcidev);
+	void (*initdone) (struct bfa_s *bfa);
+	void (*detach) (struct bfa_s *bfa);
+	void (*start) (struct bfa_s *bfa);
+	void (*stop) (struct bfa_s *bfa);
+	void (*iocdisable) (struct bfa_s *bfa);
+};
+
+extern struct bfa_module_s *hal_mods[];
+
+struct bfa_s {
+	void			*bfad;		/*  BFA driver instance    */
+	struct bfa_aen_s	*aen;		/*  AEN module		    */
+	struct bfa_plog_s	*plog;		/*  portlog buffer	    */
+	struct bfa_log_mod_s	*logm;		/*  driver logging modulen */
+	struct bfa_trc_mod_s	*trcmod;	/*  driver tracing	    */
+	struct bfa_fabric_s	fabric;	/*  fabric*/
+	struct bfa_driver_info_s driver_info;
+	struct bfa_ioc_s	ioc;		/*  IOC module		    */
+	struct bfa_iocfc_s	iocfc;		/*  IOCFC module	    */
+	struct bfa_timer_mod_s	timer_mod;	/*  timer module	    */
+	struct bfa_modules_s	modules;	/*  BFA modules	    */
+	struct list_head		comp_q;		/*  pending completions    */
+	struct list_head		reqq_waitq[BFI_IOC_MAX_CQS];
+};
+
+/**
+ * Macros to get fcs config info given bfa
+ */
+#define	bfa_bport_role(__bfa)		(((struct bfa_s *)__bfa)->iocfc.cfg.drvcfg.bport_role)
+#define	bfa_fw_disc_enabled(__bfa)	(((struct bfa_s *)__bfa)->iocfc.cfg.drvcfg.fw_disc_enabled)
+
+extern bfa_isr_func_t bfa_isrs[BFI_MC_MAX];
+extern bfa_ioc_mbox_mcfunc_t  bfa_mbox_isrs[];
+extern bfa_boolean_t bfa_auto_recover;
+extern struct bfa_module_s hal_mod_flash;
+extern struct bfa_module_s hal_mod_diag;
+extern struct bfa_module_s hal_mod_sgpg;
+extern struct bfa_module_s hal_mod_pport;
+extern struct bfa_module_s hal_mod_fcxp;
+extern struct bfa_module_s hal_mod_lps;
+extern struct bfa_module_s hal_mod_uf;
+extern struct bfa_module_s hal_mod_rport;
+extern struct bfa_module_s hal_mod_fcpim;
+extern struct bfa_module_s hal_mod_fabric;
+extern struct bfa_module_s hal_mod_lport;
+
+#endif /* __BFA_PRIV_H__ */
+
diff -urpN orig/drivers/scsi/bfa/bfa_rport.c patch/drivers/scsi/bfa/bfa_rport.c
--- orig/drivers/scsi/bfa/bfa_rport.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_rport.c	2009-03-14 11:44:57.289196000 -0700
@@ -0,0 +1,1113 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include <bfa_rport.h>
+#include <bfa_fcpim.h>
+#include <cs/bfa_debug.h>
+#include <bfi/bfi_rport.h>
+#include <bfa_fcpim.h>
+#include "bfa_intr_priv.h"
+#include "bfa_lport.h"
+
+BFA_TRC_FILE(HAL, RPORT);
+BFA_MODULE(rport);
+
+#define bfa_rport_offline_cb(__rp) do {					\
+		bfa_cb_queue((__rp)->bfa, &(__rp)->hcb_qe,		\
+				__bfa_cb_rport_offline, (__rp) );      \
+} while (0)
+
+/* 
+#define bfa_rport_offline_cb(__rp) do {					\
+	 fw discovery is enabled in initiator mode 			\
+	if ((bfa_lport_is_initiator((__rp)->bfa, (__rp)->lport_tag)) 	\
+			&& bfa_fw_disc_enabled((__rp)->bfa)) {      \
+		bfa_itnim_offline((__rp) );      \
+	 bfa is target mode - rport is initiator 			\
+	} else if (bfa_lport_is_target((__rp)->bfa),(__rp)->lport_tag) {      \
+		bfa_itntm_rport_offline((__rp) );      \
+	} else {							\
+		bfa_cb_queue((__rp)->bfa, &(__rp)->hcb_qe,		\
+				__bfa_cb_rport_offline, (__rp) );      \
+	}								\
+} while (0)
+*/
+
+#define bfa_rport_online_cb(__rp) do {					\
+	bfa_cb_queue((__rp)->bfa, &(__rp)->hcb_qe,			\
+				  __bfa_cb_rport_online, (__rp) );      \
+} while (0)
+
+/*
+ * forward declarations
+ */
+static struct bfa_rport_s *bfa_rport_alloc(struct bfa_rport_mod_s *rp_mod);
+static void		bfa_rport_free(struct bfa_rport_s *rport);
+static bfa_boolean_t 	bfa_rport_send_fwcreate(struct bfa_rport_s *rp);
+static bfa_boolean_t	bfa_rport_send_fwdelete(struct bfa_rport_s *rp);
+static bfa_boolean_t	bfa_rport_send_fwspeed(struct bfa_rport_s *rp);
+static void		__bfa_cb_rport_online(void *cbarg,
+							bfa_boolean_t complete);
+static void		__bfa_cb_rport_offline(void *cbarg,
+							bfa_boolean_t complete);
+static void bfa_rport_register(struct bfa_rport_s *rp);
+static bfa_boolean_t bfa_rport_send_cleanup_rsp(struct bfa_rport_s *rp);
+
+/**
+ *  bfa_rport_sm BFA rport state machine
+ */
+
+
+enum bfa_rport_event {
+	BFA_RPORT_SM_CREATE	= 1,	/*  rport create event	*/
+	BFA_RPORT_SM_DELETE = 2,	/*  deleting an existing rport */
+	BFA_RPORT_SM_ONLINE = 3,	/*  rport is online		*/
+	BFA_RPORT_SM_OFFLINE = 4,	/*  rport is offline		*/
+	BFA_RPORT_SM_FWRSP	= 5,	/*  firmware response		*/
+	BFA_RPORT_SM_HWFAIL	= 6,	/*  IOC h/w failure		*/
+	BFA_RPORT_SM_QOS_SCN = 7,	/*  QoS change notification from fw */
+	BFA_RPORT_SM_SET_SPEED = 8,	/*  Set Rport Speed 				*/
+
+	/*
+	 * FCS rport related events 
+	 */
+	BFA_RPORT_SM_ADD        = 9,    /*! < rport add event from f/w */
+	BFA_RPORT_SM_REMOVE     = 10,   /*! < rport remove event from f/w */
+	BFA_RPORT_SM_DOWN       = 11,   /*! < rport down event from f/w */
+	BFA_RPORT_SM_UP         = 12,   /*! < rport up event from f/w */
+	BFA_RPORT_SM_CLEANUP_DONE = 13,	/*! < itnim & io clean up done */
+};
+
+static void	bfa_rport_sm_uninit(struct bfa_rport_s *rp,
+					enum bfa_rport_event event);
+static void	bfa_rport_sm_created(struct bfa_rport_s *rp,
+					 enum bfa_rport_event event);
+static void	bfa_rport_sm_fwcreate(struct bfa_rport_s *rp,
+					  enum bfa_rport_event event);
+static void	bfa_rport_sm_online(struct bfa_rport_s *rp,
+					enum bfa_rport_event event);
+static void	bfa_rport_sm_fwdelete(struct bfa_rport_s *rp,
+					  enum bfa_rport_event event);
+static void	bfa_rport_sm_offline(struct bfa_rport_s *rp,
+					 enum bfa_rport_event event);
+static void	bfa_rport_sm_deleting(struct bfa_rport_s *rp,
+					  enum bfa_rport_event event);
+static void	bfa_rport_sm_offline_pending(struct bfa_rport_s *rp,
+					  enum bfa_rport_event event);
+static void	bfa_rport_sm_delete_pending(struct bfa_rport_s *rp,
+					  enum bfa_rport_event event);
+static void	bfa_rport_sm_iocdisable(struct bfa_rport_s *rp,
+					    enum bfa_rport_event event);
+
+/**
+ * Rport SM states for FCS discovery in f/w
+ */ 
+static void	bfa_rport_sm_up(struct bfa_rport_s *rp,
+						enum bfa_rport_event event);
+static void	bfa_rport_sm_cleanup(struct bfa_rport_s *rp,
+						enum bfa_rport_event event);
+static void	bfa_rport_sm_down(struct bfa_rport_s *rp,
+						enum bfa_rport_event event);
+
+/**
+ * Beginning state, only online event expected.
+ */
+static void
+bfa_rport_sm_uninit(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_CREATE:
+		bfa_stats(rp, sm_un_cr);
+		bfa_sm_set_state(rp, bfa_rport_sm_created);
+		break;
+
+	case    BFA_RPORT_SM_ADD:
+		bfa_sm_set_state(rp, bfa_rport_sm_up);
+		bfa_rport_register(rp);
+	break;
+
+	default:
+		bfa_stats(rp, sm_un_unexp);
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_rport_sm_created(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_ONLINE:
+		bfa_stats(rp, sm_cr_on);
+		bfa_sm_set_state(rp, bfa_rport_sm_fwcreate);
+		bfa_rport_send_fwcreate(rp);
+		break;
+
+	case BFA_RPORT_SM_DELETE:
+		bfa_stats(rp, sm_cr_del);
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+		bfa_rport_free(rp);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_cr_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_iocdisable);
+		break;
+
+	default:
+		bfa_stats(rp, sm_cr_unexp);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Waiting for rport create response from firmware.
+ */
+static void
+bfa_rport_sm_fwcreate(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_FWRSP:
+		bfa_stats(rp, sm_fwc_rsp);
+		bfa_sm_set_state(rp, bfa_rport_sm_online);
+		bfa_rport_online_cb(rp);
+		break;
+
+	case BFA_RPORT_SM_DELETE:
+		bfa_stats(rp, sm_fwc_del);
+		bfa_sm_set_state(rp, bfa_rport_sm_delete_pending);
+		break;
+
+	case BFA_RPORT_SM_OFFLINE:
+		bfa_stats(rp, sm_fwc_off);
+		bfa_sm_set_state(rp, bfa_rport_sm_offline_pending);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_fwc_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_iocdisable);
+		break;
+
+	default:
+		bfa_stats(rp, sm_fwc_unexp);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Online state - normal parking state.
+ */
+static void
+bfa_rport_sm_online(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	struct bfi_rport_qos_scn_s *qos_scn;
+
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_OFFLINE:
+		bfa_stats(rp, sm_on_off);
+		bfa_sm_set_state(rp, bfa_rport_sm_fwdelete);
+		bfa_rport_send_fwdelete(rp);
+		break;
+
+	case BFA_RPORT_SM_DELETE:
+		bfa_stats(rp, sm_on_del);
+		bfa_sm_set_state(rp, bfa_rport_sm_deleting);
+		bfa_rport_send_fwdelete(rp);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_on_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_iocdisable);
+		break;
+
+	case BFA_RPORT_SM_SET_SPEED:
+		bfa_rport_send_fwspeed(rp);
+		break;
+
+	case BFA_RPORT_SM_QOS_SCN:
+		qos_scn = (struct bfi_rport_qos_scn_s *) rp->event_arg.fw_msg;
+		rp->qos_attr = qos_scn->new_qos_attr;
+		bfa_trc(rp->bfa, qos_scn->old_qos_attr.qos_flow_id);
+		bfa_trc(rp->bfa, qos_scn->new_qos_attr.qos_flow_id);
+		bfa_trc(rp->bfa, qos_scn->old_qos_attr.qos_priority);
+		bfa_trc(rp->bfa, qos_scn->new_qos_attr.qos_priority);
+
+		qos_scn->old_qos_attr.qos_flow_id  =
+			bfa_os_ntohl(qos_scn->old_qos_attr.qos_flow_id);
+		qos_scn->new_qos_attr.qos_flow_id  =
+			bfa_os_ntohl(qos_scn->new_qos_attr.qos_flow_id);
+		qos_scn->old_qos_attr.qos_priority =
+			bfa_os_ntohl(qos_scn->old_qos_attr.qos_priority);
+		qos_scn->new_qos_attr.qos_priority =
+			bfa_os_ntohl(qos_scn->new_qos_attr.qos_priority);
+
+		if (qos_scn->old_qos_attr.qos_flow_id !=
+			qos_scn->new_qos_attr.qos_flow_id)
+			bfa_cb_rport_qos_scn_flowid(rp->rport_drv,
+						    qos_scn->old_qos_attr,
+						    qos_scn->new_qos_attr);
+		if (qos_scn->old_qos_attr.qos_priority !=
+			qos_scn->new_qos_attr.qos_priority)
+			bfa_cb_rport_qos_scn_prio(rp->rport_drv,
+						  qos_scn->old_qos_attr,
+						  qos_scn->new_qos_attr);
+		break;
+
+	default:
+		bfa_stats(rp, sm_on_unexp);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Firmware rport is being deleted - awaiting f/w response.
+ */
+static void
+bfa_rport_sm_fwdelete(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_FWRSP:
+		bfa_stats(rp, sm_fwd_rsp);
+		bfa_sm_set_state(rp, bfa_rport_sm_offline);
+		bfa_rport_offline_cb(rp);
+		break;
+
+	case BFA_RPORT_SM_DELETE:
+		bfa_stats(rp, sm_fwd_del);
+		bfa_sm_set_state(rp, bfa_rport_sm_deleting);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_fwd_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_iocdisable);
+		bfa_rport_offline_cb(rp);
+		break;
+
+	default:
+		bfa_stats(rp, sm_fwd_unexp);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Offline state.
+ */
+static void
+bfa_rport_sm_offline(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_DELETE:
+		bfa_stats(rp, sm_off_del);
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+		bfa_rport_free(rp);
+		break;
+
+	case BFA_RPORT_SM_ONLINE:
+		bfa_stats(rp, sm_off_on);
+		bfa_sm_set_state(rp, bfa_rport_sm_fwcreate);
+		bfa_rport_send_fwcreate(rp);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_off_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_iocdisable);
+		break;
+
+	default:
+		bfa_stats(rp, sm_off_unexp);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Rport is deleted, waiting for firmware response to delete.
+ */
+static void
+bfa_rport_sm_deleting(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_FWRSP:
+		bfa_stats(rp, sm_del_fwrsp);
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+		bfa_rport_free(rp);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_del_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+		bfa_rport_free(rp);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Waiting for rport create response from firmware. A delete is pending.
+ */
+static void
+bfa_rport_sm_delete_pending(struct bfa_rport_s *rp,
+				enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_FWRSP:
+		bfa_stats(rp, sm_delp_fwrsp);
+		bfa_sm_set_state(rp, bfa_rport_sm_deleting);
+		bfa_rport_send_fwdelete(rp);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_delp_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+		bfa_rport_free(rp);
+		break;
+
+	default:
+		bfa_stats(rp, sm_delp_unexp);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * Waiting for rport create response from firmware. Rport offline is pending.
+ */
+static void
+bfa_rport_sm_offline_pending(struct bfa_rport_s *rp,
+				 enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_FWRSP:
+		bfa_stats(rp, sm_offp_fwrsp);
+		bfa_sm_set_state(rp, bfa_rport_sm_fwdelete);
+		bfa_rport_send_fwdelete(rp);
+		break;
+
+	case BFA_RPORT_SM_DELETE:
+		bfa_stats(rp, sm_offp_del);
+		bfa_sm_set_state(rp, bfa_rport_sm_delete_pending);
+		break;
+
+	case BFA_RPORT_SM_HWFAIL:
+		bfa_stats(rp, sm_offp_hwf);
+		bfa_sm_set_state(rp, bfa_rport_sm_iocdisable);
+		break;
+
+	default:
+		bfa_stats(rp, sm_offp_unexp);
+		bfa_assert(0);
+	}
+}
+
+/**
+ * IOC h/w failed.
+ */
+static void
+bfa_rport_sm_iocdisable(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+	case BFA_RPORT_SM_OFFLINE:
+		bfa_stats(rp, sm_iocd_off);
+		bfa_rport_offline_cb(rp);
+		break;
+
+	case BFA_RPORT_SM_DELETE:
+		bfa_stats(rp, sm_iocd_del);
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+		bfa_rport_free(rp);
+		break;
+
+	case BFA_RPORT_SM_ONLINE:
+		bfa_stats(rp, sm_iocd_on);
+		bfa_sm_set_state(rp, bfa_rport_sm_fwcreate);
+		bfa_rport_send_fwcreate(rp);
+		break;
+
+	default:
+		bfa_stats(rp, sm_iocd_unexp);
+		bfa_assert(0);
+	}
+}
+
+/**
+ *   RPORT States for FCS discovery in f/w
+ */
+
+/**
+ * f/w discovered rport & is operational  
+ */
+static void
+bfa_rport_sm_up(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_itnim_t	*itnim = BFA_ITNIM_FROM_TAG(BFA_FCPIM_MOD(rp->bfa),rp->rport_tag);	
+	bfa_boolean_t	status;
+
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+	switch (event) {
+	
+	case	BFA_RPORT_SM_DOWN:
+		/*
+		 * Initiator mode & RP is rpob type
+		 * do IO clean up and send rsp to f/w
+		 */
+		if (bfa_lport_is_initiator(rp->bfa, rp->lport_tag) & (rp->type)) {
+			bfa_sm_set_state(rp, bfa_rport_sm_cleanup);
+			bfa_itnim_offline(itnim);
+			return;
+		} 
+					
+		if (bfa_lport_is_target(rp->bfa,rp->lport_tag)) {
+			bfa_assert(0);
+			/* Target mode 
+			bfa_itntm_offline(BFA_ITNTM_FROM_TAG(BFA_FCPTM_MOD(rp->bfa), rp->rport_tag));
+			*/
+			return;
+		}
+		/*
+		 * rport is rpib type, so no clean up required
+		 */	
+		bfa_sm_set_state(rp, bfa_rport_sm_down);
+		status = bfa_rport_send_cleanup_rsp(rp);	
+		bfa_assert(status == BFA_STATUS_OK);
+	break;	
+
+	default:
+		bfa_assert(0);
+	break;
+	}
+	
+}
+
+/**
+ * rport is waiting for itnim clean up to finish
+ */
+static void
+bfa_rport_sm_cleanup(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_boolean_t	status;
+
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+	switch (event) {
+
+	case	BFA_RPORT_SM_CLEANUP_DONE:
+		bfa_sm_set_state(rp, bfa_rport_sm_down);
+		status = bfa_rport_send_cleanup_rsp(rp);	
+		bfa_assert(status == BFA_STATUS_OK);
+	break;
+	
+	default:
+		bfa_assert(0);
+	break;
+	}
+
+}
+
+/**
+ * rport is down - f/w is running either running rport_del timer or
+ * relogin is in progress. 
+ */
+static void
+bfa_rport_sm_down(struct bfa_rport_s *rp, enum bfa_rport_event event)
+{
+	bfa_trc(rp->bfa, rp->rport_tag);
+	bfa_trc(rp->bfa, event);
+
+	switch (event) {
+
+	case	BFA_RPORT_SM_UP:
+		bfa_sm_set_state(rp, bfa_rport_sm_up);
+	break;
+
+	case	BFA_RPORT_SM_REMOVE:
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+		break;
+	default:
+		bfa_assert(0);
+	break;
+	}
+}
+
+
+
+/**
+ *  bfa_rport_private BFA rport private functions
+ */
+
+static void
+__bfa_cb_rport_online(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_rport_s *rp = cbarg;
+
+	if (complete)
+		bfa_cb_rport_online(rp->rport_drv);
+}
+
+static void
+__bfa_cb_rport_offline(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_rport_s *rp = cbarg;
+
+	if (complete)
+		bfa_cb_rport_offline(rp->rport_drv);
+}
+
+static void
+bfa_rport_qresume(void *cbarg)
+{
+	bfa_assert(0);
+}
+
+static void
+bfa_rport_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+		u32 *dm_len)
+{
+	if (cfg->fwcfg.num_rports < BFA_RPORT_MIN)
+		cfg->fwcfg.num_rports = BFA_RPORT_MIN;
+
+	*km_len += cfg->fwcfg.num_rports * sizeof(struct bfa_rport_s);
+}
+
+static void
+bfa_rport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		     struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_rport_mod_s *mod = BFA_RPORT_MOD(bfa);
+	struct bfa_rport_s *rp;
+	u16        i;
+
+	INIT_LIST_HEAD(&mod->rp_free_q);
+	INIT_LIST_HEAD(&mod->rp_active_q);
+
+	rp = (struct bfa_rport_s *) bfa_meminfo_kva(meminfo);
+	mod->rps_list = rp;
+	mod->num_rports = cfg->fwcfg.num_rports;
+
+	bfa_assert(mod->num_rports
+		   && !(mod->num_rports & (mod->num_rports - 1)));
+
+	for (i = 0; i < mod->num_rports; i++, rp++) {
+		bfa_os_memset(rp, 0, sizeof(struct bfa_rport_s));
+		rp->bfa = bfa;
+		rp->rport_tag = i;
+		bfa_sm_set_state(rp, bfa_rport_sm_uninit);
+
+		/**
+		 *  - is unused
+		 */
+		if (i)
+			list_add_tail(&rp->qe, &mod->rp_free_q);
+
+		bfa_reqq_winit(&rp->reqq_wait, bfa_rport_qresume, rp);
+	}
+
+	/**
+	 * consume memory
+	 */
+	bfa_meminfo_kva(meminfo) = (u8 *) rp;
+}
+
+static void
+bfa_rport_initdone(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_rport_detach(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_rport_start(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_rport_stop(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_rport_iocdisable(struct bfa_s *bfa)
+{
+	struct bfa_rport_mod_s *mod = BFA_RPORT_MOD(bfa);
+	struct bfa_rport_s *rport;
+	struct list_head        *qe, *qen;
+
+	list_for_each_safe(qe, qen, &mod->rp_active_q) {
+		rport = (struct bfa_rport_s *) qe;
+		bfa_sm_send_event(rport, BFA_RPORT_SM_HWFAIL);
+	}
+}
+
+static struct bfa_rport_s *
+bfa_rport_alloc(struct bfa_rport_mod_s *mod)
+{
+	struct bfa_rport_s *rport;
+
+	bfa_q_deq(&mod->rp_free_q, &rport);
+	if (rport)
+		list_add_tail(&rport->qe, &mod->rp_active_q);
+
+	return (rport);
+}
+
+static void
+bfa_rport_free(struct bfa_rport_s *rport)
+{
+	struct bfa_rport_mod_s *mod = BFA_RPORT_MOD(rport->bfa);
+
+	bfa_assert(bfa_q_is_on_q(&mod->rp_active_q, rport));
+	list_del(&rport->qe);
+	list_add_tail(&rport->qe, &mod->rp_free_q);
+}
+
+static bfa_boolean_t
+bfa_rport_send_fwcreate(struct bfa_rport_s *rp)
+{
+	struct bfi_rport_create_req_s *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(rp->bfa, BFA_REQQ_RPORT);
+	if (!m) {
+		bfa_reqq_wait(rp->bfa, BFA_REQQ_RPORT, &rp->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_RPORT, BFI_RPORT_H2I_CREATE_REQ,
+			bfa_lpuid(rp->bfa));
+	m->rport_tag = rp->rport_tag;
+	m->max_frmsz = bfa_os_htons(rp->rport_info.maxfrsize);
+	m->pid = rp->rport_info.pid;
+	m->local_pid = rp->rport_info.local_pid;
+	m->fc_class = rp->rport_info.fc_class;
+	m->vf_en = rp->rport_info.vf_en;
+	m->vf_id = rp->rport_info.vf_id;
+	m->cisc = rp->rport_info.cisc;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(rp->bfa, BFA_REQQ_RPORT);
+	return BFA_TRUE;
+}
+
+static bfa_boolean_t
+bfa_rport_send_fwdelete(struct bfa_rport_s *rp)
+{
+	struct bfi_rport_delete_req_s *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(rp->bfa, BFA_REQQ_RPORT);
+	if (!m) {
+		bfa_reqq_wait(rp->bfa, BFA_REQQ_RPORT, &rp->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_RPORT, BFI_RPORT_H2I_DELETE_REQ,
+			bfa_lpuid(rp->bfa));
+	m->rport_tag = rp->rport_tag;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(rp->bfa, BFA_REQQ_RPORT);
+	return BFA_TRUE;
+}
+
+static bfa_boolean_t
+bfa_rport_send_fwspeed(struct bfa_rport_s *rp)
+{
+	struct bfi_rport_speed_req_s *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(rp->bfa, BFA_REQQ_RPORT);
+	if (!m) {
+		bfa_reqq_wait(rp->bfa, BFA_REQQ_RPORT, &rp->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_RPORT, BFI_RPORT_H2I_SET_SPEED_REQ,
+			bfa_lpuid(rp->bfa));
+	m->rport_tag = rp->rport_tag;
+	m->speed = bfa_os_htonl(rp->rport_info.rpsc_speed);
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(rp->bfa, BFA_REQQ_RPORT);
+	return BFA_TRUE;
+}
+
+static bfa_boolean_t
+bfa_rport_send_cleanup_rsp(struct bfa_rport_s *rp)
+{
+	struct bfi_rport_offline_rsp_s *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(rp->bfa, BFA_REQQ_RPORT);
+	if (!m) {
+		bfa_reqq_wait(rp->bfa, BFA_REQQ_RPORT, &rp->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_RPORT, BFI_RPORT_H2I_OFFLINE_RSP,
+			bfa_lpuid(rp->bfa));
+	m->rport_tag = rp->rport_tag;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(rp->bfa, BFA_REQQ_RPORT);
+	return BFA_TRUE;
+}
+
+/**
+ * 	F/w found a new rport. Register the rport with driver
+ */ 
+static void
+bfa_rport_register(struct bfa_rport_s *rp)
+{
+       	struct bfa_s                   *bfa = rp->bfa;
+       	void                    *bfad = bfa->bfad;
+       	struct  bfad_rport_s    *rport_drv;
+       	struct  bfad_itnim_s    *itnim_drv;
+	struct 	bfa_itnim_s	*bfa_itnim;
+	
+	/* allocate driver objects for rport & itnim  in initiator mode */
+       if (bfa_lport_is_initiator(bfa, rp->lport_tag)) {
+
+		/*
+	 	 * Allocate Driver's rport structure
+	 	 */ 
+		if (bfa_cb_rport_alloc(bfad, &rp, &rport_drv) != BFA_STATUS_OK) {
+			bfa_trc(bfa, rp->rport_info.pid);
+			return ;
+		}
+	
+		/*
+		 * Allocate Driver's ITNIM structure in advance
+		 */
+		bfa_cb_itnim_alloc(bfad, &bfa_itnim, &itnim_drv);
+		if (itnim_drv == NULL) {
+			bfa_trc(bfa, rp->rport_info.pid);
+			bfa_cb_rport_free(bfad, &rport_drv);
+			return ;	
+		}
+ 
+		rp->rport_drv = rport_drv;
+		
+		/* 
+                 * allocate bfa itnim instance
+		 */
+		bfa_itnim = bfa_itnim_create(bfa, rp, (void *)itnim_drv);
+		bfa_assert(bfa_itnim != NULL);
+		if (!bfa_itnim) {
+			bfa_trc(bfa, rp->rport_info.pid);
+			bfa_rport_delete(rp);
+			bfa_cb_rport_free(bfad, &rport_drv);
+			return ;
+		}
+
+	} else {
+		/* target mode */
+		bfa_assert(bfa_lport_is_target(rp->bfa, rp->lport_tag));
+		bfa_assert(0);
+	}
+ 
+}
+
+
+
+/**
+ *  bfa_rport_public
+ */
+
+/**
+ * 		Rport interrupt processing.
+ */
+void
+bfa_rport_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
+{
+	union bfi_rport_i2h_msg_u msg;
+	struct bfa_rport_s *rp;
+	struct bfa_rport_mod_s *mod = BFA_RPORT_MOD(bfa);
+
+	bfa_trc(bfa, m->mhdr.msg_id);
+
+	msg.msg = m;
+
+	switch (m->mhdr.msg_id) {
+	case BFI_RPORT_I2H_CREATE_RSP:
+		rp = BFA_RPORT_FROM_TAG(bfa, msg.create_rsp->rport_tag);
+		rp->rport_tag = msg.create_rsp->rport_tag;
+		rp->qos_attr = msg.create_rsp->qos_attr;
+		bfa_assert(msg.create_rsp->status == BFA_STATUS_OK);
+		bfa_sm_send_event(rp, BFA_RPORT_SM_FWRSP);
+		break;
+
+	case BFI_RPORT_I2H_DELETE_RSP:
+		rp = BFA_RPORT_FROM_TAG(bfa, msg.delete_rsp->rport_tag);
+		bfa_assert(msg.delete_rsp->status == BFA_STATUS_OK);
+		bfa_sm_send_event(rp, BFA_RPORT_SM_FWRSP);
+		break;
+
+	case BFI_RPORT_I2H_QOS_SCN:
+		rp = BFA_RPORT_FROM_TAG(bfa, msg.qos_scn_evt->rport_tag);
+		rp->event_arg.fw_msg = msg.qos_scn_evt;
+		bfa_sm_send_event(rp, BFA_RPORT_SM_QOS_SCN);
+		break;
+
+	case	BFI_RPORT_I2H_ADD:
+		/*
+		 * Rport_tag is already assigned in f/w
+		 * get the rport structure and enqueue
+		 * the element to active_q
+		 */
+		rp = BFA_RPORT_FROM_TAG(bfa, msg.add->rport_tag);	
+
+		/* assert that this rp is in free_q */
+		bfa_assert(bfa_q_is_on_q(&mod->rp_free_q, rp));
+		/*
+		 * dequeue from free_q & enqueue to active_q
+		 */
+		list_del(&rp->qe);
+		list_add_tail(&rp->qe, &mod->rp_active_q);
+
+		/**
+	 	 * initialize rport attributes
+		 * move these to bfa_rport_init(rp, msg);
+		 */
+		
+		rp->lport_tag	= msg.add->lport_tag;
+		rp->type	= msg.add->type;
+		rp->rport_info.pid	=  msg.add->rpid;
+		rp->rport_info.pwwn		= msg.add->pwwn;
+		rp->rport_info.nwwn		= msg.add->nwwn;
+		rp->rport_info.maxfrsize	= msg.add->max_frmsz;
+		rp->rport_info.fc_class		= msg.add->fc_class;
+		rp->rport_info.cisc		= msg.add->cisc;
+		rp->rport_info.vf_en		= msg.add->vf_en;
+		rp->rport_info.vf_id		= msg.add->vf_id;
+		rp->rport_info.scsi_function	= msg.add->scsi_function;
+		rp->rport_info.rpsc_speed	= msg.add->rpsc_speed;
+		rp->rport_info.assigned_speed	= msg.add->assigned_speed;
+
+		bfa_sm_send_event(rp, BFA_RPORT_SM_ADD);
+		break;
+
+	case	BFI_RPORT_I2H_REMOVE:
+		rp = BFA_RPORT_FROM_TAG(bfa, msg.add->rport_tag);
+
+		/* assert that this rp is in active_q */
+		bfa_assert(bfa_q_is_on_q(&mod->rp_active_q, rp));
+		/*
+		 * dequeue from active_q & enqueue to free_q
+		 */
+		list_del(&rp->qe);
+		list_add_tail(&rp->qe, &mod->rp_free_q);
+		
+		bfa_sm_send_event(rp, BFA_RPORT_SM_REMOVE);
+		break;
+
+	case	BFI_RPORT_I2H_OFFLINE:
+		rp = BFA_RPORT_FROM_TAG(bfa, msg.add->rport_tag);
+		bfa_sm_send_event(rp, BFA_RPORT_SM_DOWN);
+		break;
+
+	case	BFI_RPORT_I2H_ONLINE:
+		rp = BFA_RPORT_FROM_TAG(bfa, msg.add->rport_tag);
+		bfa_sm_send_event(rp, BFA_RPORT_SM_UP);
+		break;
+
+	default:
+		bfa_trc(bfa, m->mhdr.msg_id);
+		bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  bfa_rport_api
+ */
+
+struct bfa_rport_s *
+bfa_rport_create(struct bfa_s *bfa, void *rport_drv)
+{
+	struct bfa_rport_s *rp;
+
+	rp = bfa_rport_alloc(BFA_RPORT_MOD(bfa));
+
+	if (rp == NULL)
+		return (NULL);
+
+	rp->bfa = bfa;
+	rp->rport_drv = rport_drv;
+	bfa_rport_clear_stats(rp);
+
+	bfa_assert(bfa_sm_cmp_state(rp, bfa_rport_sm_uninit));
+	bfa_sm_send_event(rp, BFA_RPORT_SM_CREATE);
+
+	return (rp);
+}
+
+void
+bfa_rport_delete(struct bfa_rport_s *rport)
+{
+	bfa_sm_send_event(rport, BFA_RPORT_SM_DELETE);
+}
+
+void
+bfa_rport_online(struct bfa_rport_s *rport, struct bfa_rport_info_s *rport_info)
+{
+	bfa_assert(rport_info->maxfrsize != 0);
+
+	/**
+	 * Some JBODs are seen to be not setting PDU size correctly in PLOGI
+	 * responses. Default to minimum size.
+	 */
+	if (rport_info->maxfrsize == 0) {
+		bfa_trc(rport->bfa, rport->rport_tag);
+		rport_info->maxfrsize = FC_MIN_PDUSZ;
+	}
+
+	rport->rport_info = *rport_info;
+	bfa_sm_send_event(rport, BFA_RPORT_SM_ONLINE);
+}
+
+void
+bfa_rport_offline(struct bfa_rport_s *rport)
+{
+	bfa_sm_send_event(rport, BFA_RPORT_SM_OFFLINE);
+}
+
+void
+bfa_rport_speed(struct bfa_rport_s *rport, enum bfa_pport_speed speed)
+{
+	bfa_assert(speed != 0);
+	bfa_assert(speed != BFA_PPORT_SPEED_AUTO);
+
+	rport->rport_info.rpsc_speed = speed;
+	bfa_sm_send_event(rport, BFA_RPORT_SM_SET_SPEED);
+}
+
+void
+bfa_rport_get_hal_stats(struct bfa_rport_s *rport,
+	struct bfa_rport_hal_stats_s *stats)
+{
+	//*stats = rport->stats;
+	memcpy(stats, &rport->stats, sizeof(struct bfa_rport_hal_stats_s ));
+}
+
+void
+bfa_rport_get_stats(struct bfa_rport_s *rport,
+	struct bfa_rport_stats_s *stats)
+{
+	//TODO
+}
+
+void
+bfa_rport_get_qos_attr(struct bfa_rport_s *rport,
+					struct bfa_rport_qos_attr_s *qos_attr)
+{
+	qos_attr->qos_priority  = bfa_os_ntohl(rport->qos_attr.qos_priority);
+	qos_attr->qos_flow_id  = bfa_os_ntohl(rport->qos_attr.qos_flow_id);
+
+}
+
+void
+bfa_rport_clear_stats(struct bfa_rport_s *rport)
+{
+	bfa_os_memset(&rport->stats, 0, sizeof(rport->stats));
+}
+
+void
+bfa_rport_list_in_lport(u16 lport, char *buf)
+{
+	/*
+	 * return list of rports under the given lport
+	 */
+}
+
+/**
+ *  Callback for itnim_cleanup from itnim module
+ */
+void
+bfa_rport_cleanup_cb(struct bfa_s *bfa, struct bfa_rport_s *rport)
+{
+	bfa_trc(bfa, rport->rport_tag);
+	bfa_sm_send_event(rport, BFA_RPORT_SM_CLEANUP_DONE);
+}
+void 
+bfa_rport_get_attr(struct bfa_rport_s *rport, struct bfa_rport_attr_s *attr)
+{
+}
+void 
+bfa_rport_set_del_timeout(u8 rport_tmo)
+{
+}
+struct bfa_rport_s *
+bfa_rport_lookup(struct bfa_lport_s *port, wwn_t rpwwn)
+{
+	return NULL;
+}
+void 
+bfa_rport_set_speed(struct bfa_rport_s *rport, enum bfa_pport_speed speed)
+{
+}
+
diff -urpN orig/drivers/scsi/bfa/bfa_rport.h patch/drivers/scsi/bfa/bfa_rport.h
--- orig/drivers/scsi/bfa/bfa_rport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_rport.h	2009-03-14 11:44:57.296281000 -0700
@@ -0,0 +1,207 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __RPORT_H__
+#define __RPORT_H__
+
+#include <defs/bfa_defs_rport.h>
+#include <bfa_lport.h>
+
+/**
+ * P R I V A T E   D E F I N I T I O N S   - Used & visible to BFA RPORT module alone (private)
+ */
+
+
+#define BFA_RPORT_MIN	4
+#define BFA_RPORT_DEF_DEL_TIMEOUT   90  /* in secs */
+
+struct bfa_rport_mod_s {
+	struct bfa_rport_s *rps_list;	/*  list of rports	*/
+	struct list_head 	rp_free_q;	/*  free bfa_rports	*/
+	struct list_head 	rp_active_q;	/*  free bfa_rports 	*/
+	u16	num_rports;	/*  number of rports	*/
+};
+
+/**
+ *              BFA rport information.
+ */
+struct bfa_rport_info_s {
+        u16        maxfrsize;      /*  max rcv pdu size               */
+        u32        pid:24,         /*  remote port ID                 */
+                        rsvd1:8;
+        u32        local_pid:24,   /*  local port ID                  */
+                        cisc:8;         /*  CIRO supported                 */
+	wwn_t		pwwn;		/*  port wwn of rport */
+	wwn_t		nwwn;		/*  node wwn of rport */
+	struct bfa_rport_symname_s psym_name; /*  port symbolic name  */
+	enum bfa_rport_function	scsi_function;	/*  Initiator/Target */
+        u8         fc_class;       /*  supported FC classes. fc_cos_t */
+        u8         vf_en;          /*  virtual fabric enable          */
+        u16        vf_id;          /*  virtual fabric ID              */
+        enum bfa_pport_speed rpsc_speed; /* Current Speed from RPSC.
+					  * O if RPSC fails
+					  */
+        enum bfa_pport_speed assigned_speed; /* speed assigned by user.
+					      * Will be used if RPSC is not
+					      * supported by rport
+					      */
+};
+typedef struct bfa_rport_info_s bfa_rport_info_t;
+
+/**
+ * BFA rport data structure
+ */
+struct bfa_rport_s {
+        struct list_head          qe;       /*  queue element */
+        bfa_sm_t                sm;       /*  state machine */
+        struct bfa_s            *bfa;     /*  backpointer to BFA */
+        void                    *rport_drv; /*  driver rport object */
+        u16                rport_tag; /*  rport tag */
+        u8                 lport_tag; /*  lport tag */
+        u8			type;	   /*  rport type */
+        struct bfa_rport_info_s rport_info; /*  rport info from driver */
+        struct bfa_reqq_wait_s  reqq_wait; /*  to wait for room in reqq */
+        struct bfa_cb_qe_s      hcb_qe;  /*  BFA callback qelem */
+        struct bfa_rport_hal_stats_s    stats; /*  BFA rport statistics  */
+        struct bfa_rport_qos_attr_s     qos_attr;
+        union a {
+                bfa_status_t    status;  /*  f/w status */
+                void            *fw_msg; /*  QoS scn event */
+        } event_arg;
+};
+
+typedef struct bfa_rport_s bfa_rport_t;
+#define BFA_RPORT_FC_COS(_rport)        ((_rport)->rport_info.fc_class)
+
+#define BFA_RPORT_MOD(__bfa)	(&(__bfa)->modules.rport_mod)
+
+/**
+ * Convert rport tag to RPORT
+ */
+#define BFA_RPORT_FROM_TAG(__bfa, _tag)				\
+	(BFA_RPORT_MOD(__bfa)->rps_list +			\
+	 ((_tag) & (BFA_RPORT_MOD(__bfa)->num_rports - 1)))
+
+/*
+ * external functions
+ */
+void	bfa_rport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+
+
+
+
+
+/** 
+ * P R O T E C T E D   D E F I N I T I O N S  - Shared between modules within BFA layer (protected)
+ */
+void bfa_rport_cleanup_cb(struct bfa_s *bfa, bfa_rport_t *rp);
+
+
+
+/**
+ * P U B L I C   D E F I N I T I O N S   - Shared between BFA layer & Host Drivers (public)
+ */
+
+/**
+ * bfa rport API functions - exported to drivers
+ */
+
+
+struct bfad_s;
+struct bfad_rport_s;
+
+/*
+ * Used by Solaris
+ */
+struct	bfa_rport_s	*bfa_rport_create(struct bfa_s *bfa, void *rport_drv);
+void	bfa_rport_delete(struct bfa_rport_s *rport);
+void 	bfa_rport_online(struct bfa_rport_s *rport, struct bfa_rport_info_s *rport_info);
+void	bfa_rport_offline(struct bfa_rport_s *rport);
+void	bfa_rport_speed(struct bfa_rport_s *rport, enum bfa_pport_speed speed);
+void	bfa_cb_rport_qos_scn_flowid(void *rport, struct bfa_rport_qos_attr_s old_qos_attr,
+                        			struct bfa_rport_qos_attr_s new_qos_attr);
+void bfa_cb_rport_online(void *rport);
+void bfa_cb_rport_offline(void *rport);
+void bfa_cb_rport_qos_scn_prio(void *rport,
+                        struct bfa_rport_qos_attr_s old_qos_attr,
+                        struct bfa_rport_qos_attr_s new_qos_attr);
+void bfa_rport_get_qos_attr(struct bfa_rport_s *rport,
+                        struct bfa_rport_qos_attr_s *qos_attr);
+
+void bfa_rport_list_in_lport(u16 lport_tag, char *buf); /* list of rports under lport */
+void bfa_rport_get_attr(struct bfa_rport_s *rport, struct bfa_rport_attr_s *attr);
+void bfa_rport_get_stats(struct bfa_rport_s *rport, struct bfa_rport_stats_s *stats);
+void bfa_rport_get_hal_stats(struct bfa_rport_s *rport, struct bfa_rport_hal_stats_s *stats);
+void bfa_rport_clear_stats(struct bfa_rport_s *rport);
+struct bfa_rport_s *bfa_rport_lookup(struct bfa_lport_s *port, wwn_t rpwwn);
+struct bfa_rport_s *bfa_rport_lookup_by_nwwn( struct bfa_lport_s *port, wwn_t rnwwn);
+
+void bfa__rport_set_del_timeout(u8 rport_tmo);
+
+void bfa_rport_set_speed(struct bfa_rport_s *rport, enum bfa_pport_speed speed);
+void bfa_rport_set_del_timeout(u8 rport_tmo);
+
+/*
+ * Callback functions from BFA to driver
+ */
+
+/**
+ *      Completion callback for bfa_rport_add().
+ *
+ * @param[in] rport_drv - driver instance of rport
+ *
+ * @return None
+ */
+void bfa_cb_rport_add(struct bfad_rport_s *rport_drv);
+
+/**
+ *      Completion callback for bfa_rport_remove().
+ *
+ * @param[in] rport_drv - driver instance of rport
+ *
+ * @return None
+ */
+void bfa_cb_rport_remove(struct bfad_rport_s *rport_drv);
+
+/**
+ *              Call to allocate a rport instance.
+ *
+ * @param[in] bfad - driver instance
+ * @param[out] rport - BFA instance of rport
+ * @param[out] rport_drv - driver instance of rport
+ *
+ * @retval BFA_STATUS_OK - successfully allocated
+ * @retval BFA_STATUS_ENOMEM - cannot allocate
+ */
+bfa_status_t bfa_cb_rport_alloc(struct bfad_s *bfad,
+                        struct bfa_rport_s **rport,
+                        struct bfad_rport_s **rport_drv);
+
+/**
+ *      Call to free rport memory resources.
+ *
+ * @param[in] bfad - driver instance
+ * @param[in] rport_drv - driver instance of rport
+ *
+ * @return None
+ */
+void bfa_cb_rport_free(struct bfad_s *bfad, struct bfad_rport_s **rport_drv);
+
+
+
+
+#endif /* __RPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_sgpg.c patch/drivers/scsi/bfa/bfa_sgpg.c
--- orig/drivers/scsi/bfa/bfa_sgpg.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_sgpg.c	2009-03-14 11:44:57.303411000 -0700
@@ -0,0 +1,231 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+
+BFA_TRC_FILE(HAL, SGPG);
+BFA_MODULE(sgpg);
+
+/**
+ *  hal_sgpg_mod BFA SGPG Mode module
+ */
+
+/**
+ * Compute and return memory needed by FCP(im) module.
+ */
+static void
+bfa_sgpg_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *km_len,
+		u32 *dm_len)
+{
+	if (cfg->drvcfg.num_sgpgs < BFA_SGPG_MIN)
+		cfg->drvcfg.num_sgpgs = BFA_SGPG_MIN;
+
+	*km_len += (cfg->drvcfg.num_sgpgs + 1) * sizeof(struct bfa_sgpg_s);
+	*dm_len += (cfg->drvcfg.num_sgpgs + 1) * sizeof(struct bfi_sgpg_s);
+}
+
+
+static void
+bfa_sgpg_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		    struct bfa_meminfo_s *minfo, struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_sgpg_mod_s	*mod = BFA_SGPG_MOD(bfa);
+	int				i;
+	struct bfa_sgpg_s		*hsgpg;
+	struct bfi_sgpg_s 	*sgpg;
+	u64		align_len;
+
+	union {
+		u64        pa;
+		union bfi_addr_u      addr;
+	} sgpg_pa;
+
+	INIT_LIST_HEAD(&mod->sgpg_q);
+	INIT_LIST_HEAD(&mod->sgpg_wait_q);
+
+	bfa_trc(bfa, cfg->drvcfg.num_sgpgs);
+
+	mod->num_sgpgs = cfg->drvcfg.num_sgpgs;
+	mod->sgpg_arr_pa = bfa_meminfo_dma_phys(minfo);
+	align_len = (BFA_SGPG_ROUNDUP(mod->sgpg_arr_pa) - mod->sgpg_arr_pa);
+	mod->sgpg_arr_pa += align_len;
+	mod->hsgpg_arr = (struct bfa_sgpg_s *) (bfa_meminfo_kva(minfo) +
+						align_len);
+	mod->sgpg_arr = (struct bfi_sgpg_s *) (bfa_meminfo_dma_virt(minfo) +
+						align_len);
+
+	hsgpg = mod->hsgpg_arr;
+	sgpg = mod->sgpg_arr;
+	sgpg_pa.pa = mod->sgpg_arr_pa;
+	mod->free_sgpgs = mod->num_sgpgs;
+
+	bfa_assert(!(sgpg_pa.pa & (sizeof(struct bfi_sgpg_s) - 1)));
+
+	for (i = 0; i < mod->num_sgpgs; i++) {
+		bfa_os_memset(hsgpg, 0, sizeof(*hsgpg));
+		bfa_os_memset(sgpg, 0, sizeof(*sgpg));
+
+		hsgpg->sgpg = sgpg;
+		hsgpg->sgpg_pa = sgpg_pa.addr;
+		list_add_tail(&hsgpg->qe, &mod->sgpg_q);
+
+		hsgpg++;
+		sgpg++;
+		sgpg_pa.pa += sizeof(struct bfi_sgpg_s);
+	}
+
+	bfa_meminfo_kva(minfo) = (u8 *) hsgpg;
+	bfa_meminfo_dma_virt(minfo) = (u8 *) sgpg;
+	bfa_meminfo_dma_phys(minfo) = sgpg_pa.pa;
+}
+
+static void
+bfa_sgpg_initdone(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_sgpg_detach(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_sgpg_start(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_sgpg_stop(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_sgpg_iocdisable(struct bfa_s *bfa)
+{
+}
+
+
+
+/**
+ *  hal_sgpg_public BFA SGPG public functions
+ */
+
+bfa_status_t
+bfa_sgpg_malloc(struct bfa_s *bfa, struct list_head *sgpg_q, int nsgpgs)
+{
+	struct bfa_sgpg_mod_s *mod = BFA_SGPG_MOD(bfa);
+	struct bfa_sgpg_s *hsgpg;
+	int             i;
+
+	bfa_trc_fp(bfa, nsgpgs);
+
+	if (mod->free_sgpgs < nsgpgs)
+		return BFA_STATUS_ENOMEM;
+
+	for (i = 0; i < nsgpgs; i++) {
+		bfa_q_deq(&mod->sgpg_q, &hsgpg);
+		bfa_assert(hsgpg);
+		list_add_tail(&hsgpg->qe, sgpg_q);
+	}
+
+	mod->free_sgpgs -= nsgpgs;
+	return BFA_STATUS_OK;
+}
+
+void
+bfa_sgpg_mfree(struct bfa_s *bfa, struct list_head *sgpg_q, int nsgpg)
+{
+	struct bfa_sgpg_mod_s *mod = BFA_SGPG_MOD(bfa);
+	struct bfa_sgpg_wqe_s *wqe;
+
+	bfa_trc_fp(bfa, nsgpg);
+
+	mod->free_sgpgs += nsgpg;
+	bfa_assert(mod->free_sgpgs <= mod->num_sgpgs);
+
+	list_splice_tail_init(sgpg_q, &mod->sgpg_q);
+
+	if (list_empty(&mod->sgpg_wait_q))
+		return;
+
+	/**
+	 * satisfy as many waiting requests as possible
+	 */
+	do {
+		wqe = bfa_q_first(&mod->sgpg_wait_q);
+		if (mod->free_sgpgs < wqe->nsgpg)
+			nsgpg = mod->free_sgpgs;
+		else
+			nsgpg = wqe->nsgpg;
+		bfa_sgpg_malloc(bfa, &wqe->sgpg_q, nsgpg);
+		wqe->nsgpg -= nsgpg;
+		if (wqe->nsgpg == 0) {
+			list_del(&wqe->qe);
+			wqe->cbfn(wqe->cbarg);
+		}
+	} while (mod->free_sgpgs && !list_empty(&mod->sgpg_wait_q));
+}
+
+void
+bfa_sgpg_wait(struct bfa_s *bfa, struct bfa_sgpg_wqe_s *wqe, int nsgpg)
+{
+	struct bfa_sgpg_mod_s *mod = BFA_SGPG_MOD(bfa);
+
+	bfa_assert(nsgpg > 0);
+	bfa_assert(nsgpg > mod->free_sgpgs);
+
+	wqe->nsgpg_total = wqe->nsgpg = nsgpg;
+
+	/**
+	 * allocate any left to this one first
+	 */
+	if (mod->free_sgpgs) {
+		/**
+		 * no one else is waiting for SGPG
+		 */
+		bfa_assert(list_empty(&mod->sgpg_wait_q));
+		list_splice_tail_init(&mod->sgpg_q, &wqe->sgpg_q);
+		wqe->nsgpg -= mod->free_sgpgs;
+		mod->free_sgpgs = 0;
+	}
+
+	list_add_tail(&wqe->qe, &mod->sgpg_wait_q);
+}
+
+void
+bfa_sgpg_wcancel(struct bfa_s *bfa, struct bfa_sgpg_wqe_s *wqe)
+{
+	struct bfa_sgpg_mod_s *mod = BFA_SGPG_MOD(bfa);
+
+	bfa_assert(bfa_q_is_on_q(&mod->sgpg_wait_q, wqe));
+	list_del(&wqe->qe);
+
+	if (wqe->nsgpg_total != wqe->nsgpg)
+		bfa_sgpg_mfree(bfa, &wqe->sgpg_q,
+				   wqe->nsgpg_total - wqe->nsgpg);
+}
+
+void
+bfa_sgpg_winit(struct bfa_sgpg_wqe_s *wqe, void (*cbfn) (void *cbarg),
+		   void *cbarg)
+{
+	INIT_LIST_HEAD(&wqe->sgpg_q);
+	wqe->cbfn = cbfn;
+	wqe->cbarg = cbarg;
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_sgpg_priv.h patch/drivers/scsi/bfa/bfa_sgpg_priv.h
--- orig/drivers/scsi/bfa/bfa_sgpg_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_sgpg_priv.h	2009-03-14 11:44:57.310403000 -0700
@@ -0,0 +1,79 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  hal_sgpg.h BFA SG page module
+ */
+
+#ifndef __BFA_SGPG_PRIV_H__
+#define __BFA_SGPG_PRIV_H__
+
+#include <cs/bfa_q.h>
+
+#define BFA_SGPG_MIN	(32)
+
+/**
+ * Alignment macro for SG page allocation
+ */
+#define BFA_SGPG_ROUNDUP(_l) (((_l) + (sizeof(struct bfi_sgpg_s) - 1)) \
+			& ~(sizeof(struct bfi_sgpg_s) - 1))
+
+struct bfa_sgpg_wqe_s {
+	struct list_head qe;		/*  queue sg page element	*/
+	int	nsgpg;		/*  pages to be allocated	*/
+	int	nsgpg_total;	/*  total pages required	*/
+	void	(*cbfn) (void *cbarg);
+				/*  callback function		*/
+	void	*cbarg;		/*  callback arg		*/
+	struct list_head sgpg_q;		/*  queue of alloced sgpgs	*/
+};
+
+struct bfa_sgpg_s {
+	struct list_head 	qe;	/*  queue sg page element	*/
+	struct bfi_sgpg_s *sgpg;	/*  va of SG page		*/
+	union bfi_addr_u sgpg_pa;/*  pa of SG page		*/
+};
+
+/**
+ * Given number of SG elements, BFA_SGPG_NPAGE() returns the number of
+ * SG pages required.
+ */
+#define BFA_SGPG_NPAGE(_nsges)  (((_nsges) / BFI_SGPG_DATA_SGES) + 1)
+
+struct bfa_sgpg_mod_s {
+	struct bfa_s *bfa;
+	int		num_sgpgs;	/*  number of SG pages		*/
+	int		free_sgpgs;	/*  number of free SG pages	*/
+	struct bfa_sgpg_s	*hsgpg_arr;	/*  BFA SG page array	*/
+	struct bfi_sgpg_s *sgpg_arr;	/*  actual SG page array	*/
+	u64	sgpg_arr_pa;	/*  SG page array DMA addr	*/
+	struct list_head 	sgpg_q;		/*  queue of free SG pages	*/
+	struct list_head 	sgpg_wait_q;	/*  wait queue for SG pages	*/
+};
+#define BFA_SGPG_MOD(__bfa)	(&(__bfa)->modules.sgpg_mod)
+
+bfa_status_t	bfa_sgpg_malloc(struct bfa_s *bfa, struct list_head *sgpg_q,
+								int nsgpgs);
+void		bfa_sgpg_mfree(struct bfa_s *bfa, struct list_head *sgpg_q,
+								int nsgpgs);
+void		bfa_sgpg_winit(struct bfa_sgpg_wqe_s *wqe,
+				   void (*cbfn) (void *cbarg), void *cbarg);
+void		bfa_sgpg_wait(struct bfa_s *bfa, struct bfa_sgpg_wqe_s *wqe,
+								int nsgpgs);
+void		bfa_sgpg_wcancel(struct bfa_s *bfa, struct bfa_sgpg_wqe_s *wqe);
+
+#endif /* __BFA_SGPG_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_sm.c patch/drivers/scsi/bfa/bfa_sm.c
--- orig/drivers/scsi/bfa/bfa_sm.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_sm.c	2009-03-14 11:44:57.317686000 -0700
@@ -0,0 +1,38 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfasm.c BFA State machine utility functions
+ */
+
+#include <cs/bfa_sm.h>
+
+/**
+ *  cs_sm_api
+ */
+
+int
+bfa_sm_to_state(struct bfa_sm_table_s *smt, bfa_sm_t sm)
+{
+	int             i = 0;
+
+	while (smt[i].sm && smt[i].sm != sm)
+		i++;
+	return smt[i].state;
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_timer.c patch/drivers/scsi/bfa/bfa_timer.c
--- orig/drivers/scsi/bfa/bfa_timer.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_timer.c	2009-03-14 11:44:57.324871000 -0700
@@ -0,0 +1,90 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa_timer.h>
+#include <cs/bfa_debug.h>
+
+void
+bfa_timer_init(struct bfa_timer_mod_s *mod)
+{
+	INIT_LIST_HEAD(&mod->timer_q);
+}
+
+void
+bfa_timer_beat(struct bfa_timer_mod_s *mod)
+{
+	struct list_head        *qh = &mod->timer_q;
+	struct list_head        *qe, *qe_next;
+	struct bfa_timer_s *elem;
+	struct list_head         timedout_q;
+
+	INIT_LIST_HEAD(&timedout_q);
+
+	qe = bfa_q_next(qh);
+
+	while (qe != qh) {
+		qe_next = bfa_q_next(qe);
+
+		elem = (struct bfa_timer_s *) qe;
+		if (elem->timeout <= BFA_TIMER_FREQ) {
+			elem->timeout = 0;
+			list_del(&elem->qe);
+			list_add_tail(&elem->qe, &timedout_q);
+		} else {
+			elem->timeout -= BFA_TIMER_FREQ;
+		}
+
+		qe = qe_next;	/* go to next elem */
+	}
+
+	/*
+	 * Pop all the timeout entries
+	 */
+	while (!list_empty(&timedout_q)) {
+		bfa_q_deq(&timedout_q, &elem);
+		elem->timercb(elem->arg);
+	}
+}
+
+/**
+ * Should be called with lock protection
+ */
+void
+bfa_timer_begin(struct bfa_timer_mod_s *mod, struct bfa_timer_s *timer,
+		    void (*timercb) (void *), void *arg, unsigned int timeout)
+{
+
+	bfa_assert(timercb != NULL);
+	bfa_assert(!bfa_q_is_on_q(&mod->timer_q, timer));
+
+	timer->timeout = timeout;
+	timer->timercb = timercb;
+	timer->arg = arg;
+
+	list_add_tail(&timer->qe, &mod->timer_q);
+}
+
+/**
+ * Should be called with lock protection
+ */
+void
+bfa_timer_stop(struct bfa_timer_s *timer)
+{
+	bfa_assert(!list_empty(&timer->qe));
+
+	list_del(&timer->qe);
+}
diff -urpN orig/drivers/scsi/bfa/bfa_trcmod_priv.h patch/drivers/scsi/bfa/bfa_trcmod_priv.h
--- orig/drivers/scsi/bfa/bfa_trcmod_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_trcmod_priv.h	2009-03-14 11:44:57.331948000 -0700
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  hal_trcmod.h BFA trace modules
+ */
+
+#ifndef __BFA_TRCMOD_PRIV_H__
+#define __BFA_TRCMOD_PRIV_H__
+
+#include <cs/bfa_trc.h>
+
+/*
+ * !!! Only append to the enums defined here to avoid any versioning
+ * !!! needed between trace utility and driver version
+ */
+enum {
+	BFA_TRC_HAL_IOC		= 1,
+	BFA_TRC_HAL_INTR	= 2,
+	BFA_TRC_HAL_FCXP	= 3,
+	BFA_TRC_HAL_UF		= 4,
+	BFA_TRC_HAL_DIAG	= 5,
+	BFA_TRC_HAL_RPORT	= 6,
+	BFA_TRC_HAL_FCPIM	= 7,
+	BFA_TRC_HAL_IOIM	= 8,
+	BFA_TRC_HAL_TSKIM	= 9,
+	BFA_TRC_HAL_ITNIM	= 10,
+	BFA_TRC_HAL_PPORT	= 11,
+	BFA_TRC_HAL_SGPG	= 12,
+	BFA_TRC_HAL_FLASH	= 13,
+	BFA_TRC_HAL_DEBUG	= 14,
+	BFA_TRC_HAL_WWN		= 15,
+	BFA_TRC_HAL_FLASH_RAW	= 16,
+	BFA_TRC_HAL_SBOOT	= 17,
+	BFA_TRC_HAL_SBTEST	= 18,
+	BFA_TRC_HAL_IPFC	= 19,
+	BFA_TRC_HAL_IOCFC	= 20,
+	BFA_TRC_HAL_FCPTM	= 21,
+	BFA_TRC_HAL_IOTM	= 22,
+	BFA_TRC_HAL_TSKTM	= 23,
+	BFA_TRC_HAL_ITNTM	= 24,
+	BFA_TRC_HAL_LPS		= 25,
+	BFA_TRC_HAL_FCDIAG	= 26,
+	BFA_TRC_HAL_LPORT	= 27,
+	BFA_TRC_HAL_VPORT	= 28,
+	BFA_TRC_HAL_FABRIC	= 29,
+};
+
+#endif /* __BFA_TRCMOD_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_tskim.c patch/drivers/scsi/bfa/bfa_tskim.c
--- orig/drivers/scsi/bfa/bfa_tskim.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_tskim.c	2009-03-14 11:44:57.340095000 -0700
@@ -0,0 +1,689 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa.h>
+#include <bfa_cb_ioim_macros.h>
+
+BFA_TRC_FILE(HAL, TSKIM);
+
+/**
+ * task management completion handling
+ */
+#define bfa_tskim_qcomp(__tskim, __cbfn) do {			     \
+	bfa_cb_queue((__tskim)->bfa, &(__tskim)->hcb_qe, __cbfn, (__tskim) );      \
+	bfa_tskim_notify_comp(__tskim );      \
+} while (0)
+
+#define bfa_tskim_notify_comp(__tskim) do {				     \
+	if ((__tskim)->notify)					     	     \
+		bfa_itnim_tskdone((__tskim)->itnim );      \
+} while (0)
+
+/*
+ * forward declarations
+ */
+static void     __bfa_cb_tskim_done(void *cbarg, bfa_boolean_t complete);
+static void     __bfa_cb_tskim_failed(void *cbarg, bfa_boolean_t complete);
+static bfa_boolean_t bfa_tskim_match_scope(struct bfa_tskim_s *tskim,
+					       lun_t lun);
+static void     bfa_tskim_gather_ios(struct bfa_tskim_s *tskim);
+static void     bfa_tskim_cleanp_comp(void *tskim_cbarg);
+static void     bfa_tskim_cleanup_ios(struct bfa_tskim_s *tskim);
+static bfa_boolean_t bfa_tskim_send(struct bfa_tskim_s *tskim);
+static bfa_boolean_t bfa_tskim_send_abort(struct bfa_tskim_s *tskim);
+static void     bfa_tskim_iocdisable_ios(struct bfa_tskim_s *tskim);
+
+/**
+ *  hal_tskim_sm
+ */
+
+enum bfa_tskim_event {
+	BFA_TSKIM_SM_START        = 1,  /*  TM command start            */
+	BFA_TSKIM_SM_DONE         = 2,  /*  TM completion               */
+	BFA_TSKIM_SM_QRESUME      = 3,  /*  resume after qfull          */
+	BFA_TSKIM_SM_HWFAIL       = 5,  /*  IOC h/w failure event       */
+	BFA_TSKIM_SM_HCB          = 6,  /*  BFA callback completion     */
+	BFA_TSKIM_SM_IOS_DONE     = 7,  /*  IO and sub TM completions   */
+	BFA_TSKIM_SM_CLEANUP      = 8,  /*  TM cleanup on ITN offline   */
+	BFA_TSKIM_SM_CLEANUP_DONE = 9,  /*  TM abort completion         */
+};
+
+static void     bfa_tskim_sm_uninit(struct bfa_tskim_s *tskim,
+					enum bfa_tskim_event event);
+static void     bfa_tskim_sm_active(struct bfa_tskim_s *tskim,
+					enum bfa_tskim_event event);
+static void     bfa_tskim_sm_cleanup(struct bfa_tskim_s *tskim,
+					 enum bfa_tskim_event event);
+static void     bfa_tskim_sm_iocleanup(struct bfa_tskim_s *tskim,
+					 enum bfa_tskim_event event);
+static void     bfa_tskim_sm_qfull(struct bfa_tskim_s *tskim,
+				       enum bfa_tskim_event event);
+static void     bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
+				       enum bfa_tskim_event event);
+static void     bfa_tskim_sm_hcb(struct bfa_tskim_s *tskim,
+				     enum bfa_tskim_event event);
+
+/**
+ *      Task management command beginning state.
+ */
+static void
+bfa_tskim_sm_uninit(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
+{
+	bfa_trc(tskim->bfa, event);
+
+	switch (event) {
+	case BFA_TSKIM_SM_START:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_active);
+		bfa_tskim_gather_ios(tskim);
+
+		/**
+		 * If device is offline, do not send TM on wire. Just cleanup
+		 * any pending IO requests and complete TM request.
+		 */
+		if (!bfa_itnim_is_online(tskim->itnim)) {
+			bfa_sm_set_state(tskim, bfa_tskim_sm_iocleanup);
+			tskim->tsk_status = BFI_TSKIM_STS_OK;
+			bfa_tskim_cleanup_ios(tskim);
+			return;
+		}
+
+		if (!bfa_tskim_send(tskim)) {
+			bfa_sm_set_state(tskim, bfa_tskim_sm_qfull);
+			bfa_reqq_wait(tskim->bfa, tskim->itnim->reqq,
+					  &tskim->reqq_wait);
+		}
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ * brief
+ *	TM command is active, awaiting completion from firmware to
+ *	cleanup IO requests in TM scope.
+ */
+static void
+bfa_tskim_sm_active(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
+{
+	bfa_trc(tskim->bfa, event);
+
+	switch (event) {
+	case BFA_TSKIM_SM_DONE:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_iocleanup);
+		bfa_tskim_cleanup_ios(tskim);
+		break;
+
+	case BFA_TSKIM_SM_CLEANUP:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_cleanup);
+		if (!bfa_tskim_send_abort(tskim)) {
+			bfa_sm_set_state(tskim, bfa_tskim_sm_cleanup_qfull);
+			bfa_reqq_wait(tskim->bfa, tskim->itnim->reqq,
+				&tskim->reqq_wait);
+		}
+		break;
+
+	case BFA_TSKIM_SM_HWFAIL:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_hcb);
+		bfa_tskim_iocdisable_ios(tskim);
+		bfa_tskim_qcomp(tskim, __bfa_cb_tskim_failed);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ *	An active TM is being cleaned up since ITN is offline. Awaiting cleanup
+ *	completion event from firmware.
+ */
+static void
+bfa_tskim_sm_cleanup(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
+{
+	bfa_trc(tskim->bfa, event);
+
+	switch (event) {
+	case BFA_TSKIM_SM_DONE:
+		/**
+		 * Ignore and wait for ABORT completion from firmware.
+		 */
+		break;
+
+	case BFA_TSKIM_SM_CLEANUP_DONE:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_iocleanup);
+		bfa_tskim_cleanup_ios(tskim);
+		break;
+
+	case BFA_TSKIM_SM_HWFAIL:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_hcb);
+		bfa_tskim_iocdisable_ios(tskim);
+		bfa_tskim_qcomp(tskim, __bfa_cb_tskim_failed);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+static void
+bfa_tskim_sm_iocleanup(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
+{
+	bfa_trc(tskim->bfa, event);
+
+	switch (event) {
+	case BFA_TSKIM_SM_IOS_DONE:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_hcb);
+		bfa_tskim_qcomp(tskim, __bfa_cb_tskim_done);
+		break;
+
+	case BFA_TSKIM_SM_CLEANUP:
+		/**
+		 * Ignore, TM command completed on wire.
+		 * Notify TM conmpletion on IO cleanup completion.
+		 */
+		break;
+
+	case BFA_TSKIM_SM_HWFAIL:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_hcb);
+		bfa_tskim_iocdisable_ios(tskim);
+		bfa_tskim_qcomp(tskim, __bfa_cb_tskim_failed);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ *      Task management command is waiting for room in request CQ
+ */
+static void
+bfa_tskim_sm_qfull(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
+{
+	bfa_trc(tskim->bfa, event);
+
+	switch (event) {
+	case BFA_TSKIM_SM_QRESUME:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_active);
+		bfa_tskim_send(tskim);
+		break;
+
+	case BFA_TSKIM_SM_CLEANUP:
+		/**
+		 * No need to send TM on wire since ITN is offline.
+		 */
+		bfa_sm_set_state(tskim, bfa_tskim_sm_iocleanup);
+		bfa_reqq_wcancel(&tskim->reqq_wait);
+		bfa_tskim_cleanup_ios(tskim);
+		break;
+
+	case BFA_TSKIM_SM_HWFAIL:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_hcb);
+		bfa_reqq_wcancel(&tskim->reqq_wait);
+		bfa_tskim_iocdisable_ios(tskim);
+		bfa_tskim_qcomp(tskim, __bfa_cb_tskim_failed);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ *      Task management command is active, awaiting for room in request CQ
+ *	to send clean up request.
+ */
+static void
+bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
+		enum bfa_tskim_event event)
+{
+	bfa_trc(tskim->bfa, event);
+
+	switch (event) {
+	case BFA_TSKIM_SM_DONE:
+		bfa_reqq_wcancel(&tskim->reqq_wait);
+		/**
+		 *
+		 * Fall through !!!
+		 */
+
+	case BFA_TSKIM_SM_QRESUME:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_cleanup);
+		bfa_tskim_send_abort(tskim);
+		break;
+
+	case BFA_TSKIM_SM_HWFAIL:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_hcb);
+		bfa_reqq_wcancel(&tskim->reqq_wait);
+		bfa_tskim_iocdisable_ios(tskim);
+		bfa_tskim_qcomp(tskim, __bfa_cb_tskim_failed);
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+/**
+ *      BFA callback is pending
+ */
+static void
+bfa_tskim_sm_hcb(struct bfa_tskim_s *tskim, enum bfa_tskim_event event)
+{
+	bfa_trc(tskim->bfa, event);
+
+	switch (event) {
+	case BFA_TSKIM_SM_HCB:
+		bfa_sm_set_state(tskim, bfa_tskim_sm_uninit);
+		bfa_tskim_free(tskim);
+		break;
+
+	case BFA_TSKIM_SM_CLEANUP:
+		bfa_tskim_notify_comp(tskim);
+		break;
+
+	case BFA_TSKIM_SM_HWFAIL:
+		break;
+
+	default:
+		bfa_assert(0);
+	}
+}
+
+
+
+/**
+ *  hal_tskim_private
+ */
+
+static void
+__bfa_cb_tskim_done(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_tskim_s *tskim = cbarg;
+
+	if (!complete) {
+		bfa_sm_send_event(tskim, BFA_TSKIM_SM_HCB);
+		return;
+	}
+
+	bfa_stats(tskim->itnim, tm_success);
+	bfa_cb_tskim_done(tskim->bfa->bfad, tskim->dtsk, tskim->tsk_status);
+}
+
+static void
+__bfa_cb_tskim_failed(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_tskim_s *tskim = cbarg;
+
+	if (!complete) {
+		bfa_sm_send_event(tskim, BFA_TSKIM_SM_HCB);
+		return;
+	}
+
+	bfa_stats(tskim->itnim, tm_failures);
+	bfa_cb_tskim_done(tskim->bfa->bfad, tskim->dtsk,
+			   BFI_TSKIM_STS_FAILED);
+}
+
+static          bfa_boolean_t
+bfa_tskim_match_scope(struct bfa_tskim_s *tskim, lun_t lun)
+{
+	switch (tskim->tm_cmnd) {
+	case FCP_TM_TARGET_RESET:
+		return BFA_TRUE;
+
+	case FCP_TM_ABORT_TASK_SET:
+	case FCP_TM_CLEAR_TASK_SET:
+	case FCP_TM_LUN_RESET:
+	case FCP_TM_CLEAR_ACA:
+		return (tskim->lun == lun);
+
+	default:
+		bfa_assert(0);
+	}
+
+	return BFA_FALSE;
+}
+
+/**
+ *      Gather affected IO requests and task management commands.
+ */
+static void
+bfa_tskim_gather_ios(struct bfa_tskim_s *tskim)
+{
+	struct bfa_itnim_s *itnim = tskim->itnim;
+	struct bfa_ioim_s *ioim;
+	struct list_head        *qe, *qen;
+
+	INIT_LIST_HEAD(&tskim->io_q);
+
+	/**
+	 * Gather any active IO requests first.
+	 */
+	list_for_each_safe(qe, qen, &itnim->io_q) {
+		ioim = (struct bfa_ioim_s *) qe;
+		if (bfa_tskim_match_scope
+		    (tskim, bfa_cb_ioim_get_lun(ioim->dio))) {
+			list_del(&ioim->qe);
+			list_add_tail(&ioim->qe, &tskim->io_q);
+		}
+	}
+
+	/**
+	 * Failback any pending IO requests immediately.
+	 */
+	list_for_each_safe(qe, qen, &itnim->pending_q) {
+		ioim = (struct bfa_ioim_s *) qe;
+		if (bfa_tskim_match_scope
+		    (tskim, bfa_cb_ioim_get_lun(ioim->dio))) {
+			list_del(&ioim->qe);
+			list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
+			bfa_ioim_tov(ioim);
+		}
+	}
+}
+
+/**
+ * 		IO cleanup completion
+ */
+static void
+bfa_tskim_cleanp_comp(void *tskim_cbarg)
+{
+	struct bfa_tskim_s *tskim = tskim_cbarg;
+
+	bfa_stats(tskim->itnim, tm_io_comps);
+	bfa_sm_send_event(tskim, BFA_TSKIM_SM_IOS_DONE);
+}
+
+/**
+ *      Gather affected IO requests and task management commands.
+ */
+static void
+bfa_tskim_cleanup_ios(struct bfa_tskim_s *tskim)
+{
+	struct bfa_ioim_s *ioim;
+	struct list_head        *qe, *qen;
+
+	bfa_wc_init(&tskim->wc, bfa_tskim_cleanp_comp, tskim);
+
+	list_for_each_safe(qe, qen, &tskim->io_q) {
+		ioim = (struct bfa_ioim_s *) qe;
+		bfa_wc_up(&tskim->wc);
+		bfa_ioim_cleanup_tm(ioim, tskim);
+	}
+
+	bfa_wc_wait(&tskim->wc);
+}
+
+/**
+ *      Send task management request to firmware.
+ */
+static bfa_boolean_t
+bfa_tskim_send(struct bfa_tskim_s *tskim)
+{
+	struct bfa_itnim_s *itnim = tskim->itnim;
+	struct bfi_tskim_req_s *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(tskim->bfa, itnim->reqq);
+	if (!m)
+		return BFA_FALSE;
+
+	/**
+	 * build i/o request message next
+	 */
+	bfi_h2i_set(m->mh, BFI_MC_TSKIM, BFI_TSKIM_H2I_TM_REQ,
+			bfa_lpuid(tskim->bfa));
+
+	m->tsk_tag = bfa_os_htons(tskim->tsk_tag);
+	m->itn_fhdl = tskim->itnim->rport->rport_tag;
+	m->t_secs = tskim->tsecs;
+	m->lun = tskim->lun;
+	m->tm_flags = tskim->tm_cmnd;
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(tskim->bfa, itnim->reqq);
+	return BFA_TRUE;
+}
+
+/**
+ *      Send abort request to cleanup an active TM to firmware.
+ */
+static bfa_boolean_t
+bfa_tskim_send_abort(struct bfa_tskim_s *tskim)
+{
+	struct bfa_itnim_s             *itnim = tskim->itnim;
+	struct bfi_tskim_abortreq_s    *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(tskim->bfa, itnim->reqq);
+	if (!m)
+		return BFA_FALSE;
+
+	/**
+	 * build i/o request message next
+	 */
+	bfi_h2i_set(m->mh, BFI_MC_TSKIM, BFI_TSKIM_H2I_ABORT_REQ,
+			bfa_lpuid(tskim->bfa));
+
+	m->tsk_tag  = bfa_os_htons(tskim->tsk_tag);
+
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(tskim->bfa, itnim->reqq);
+	return BFA_TRUE;
+}
+
+/**
+ *      Call to resume task management cmnd waiting for room in request queue.
+ */
+static void
+bfa_tskim_qresume(void *cbarg)
+{
+	struct bfa_tskim_s *tskim = cbarg;
+
+	bfa_fcpim_stats(tskim->fcpim, qresumes);
+	bfa_stats(tskim->itnim, tm_qresumes);
+	bfa_sm_send_event(tskim, BFA_TSKIM_SM_QRESUME);
+}
+
+/**
+ * Cleanup IOs associated with a task mangement command on IOC failures.
+ */
+static void
+bfa_tskim_iocdisable_ios(struct bfa_tskim_s *tskim)
+{
+	struct bfa_ioim_s *ioim;
+	struct list_head        *qe, *qen;
+
+	list_for_each_safe(qe, qen, &tskim->io_q) {
+		ioim = (struct bfa_ioim_s *) qe;
+		bfa_ioim_iocdisable(ioim);
+	}
+}
+
+
+
+/**
+ *  hal_tskim_friend
+ */
+
+/**
+ * Notification on completions from related ioim.
+ */
+void
+bfa_tskim_iodone(struct bfa_tskim_s *tskim)
+{
+	bfa_wc_down(&tskim->wc);
+}
+
+/**
+ * Handle IOC h/w failure notification from itnim.
+ */
+void
+bfa_tskim_iocdisable(struct bfa_tskim_s *tskim)
+{
+	tskim->notify = BFA_FALSE;
+	bfa_stats(tskim->itnim, tm_iocdowns);
+	bfa_sm_send_event(tskim, BFA_TSKIM_SM_HWFAIL);
+}
+
+/**
+ * Cleanup TM command and associated IOs as part of ITNIM offline.
+ */
+void
+bfa_tskim_cleanup(struct bfa_tskim_s *tskim)
+{
+	tskim->notify = BFA_TRUE;
+	bfa_stats(tskim->itnim, tm_cleanups);
+	bfa_sm_send_event(tskim, BFA_TSKIM_SM_CLEANUP);
+}
+
+/**
+ *      Memory allocation and initialization.
+ */
+void
+bfa_tskim_attach(struct bfa_fcpim_mod_s *fcpim, struct bfa_meminfo_s *minfo)
+{
+	struct bfa_tskim_s *tskim;
+	u16        i;
+
+	INIT_LIST_HEAD(&fcpim->tskim_free_q);
+
+	tskim = (struct bfa_tskim_s *) bfa_meminfo_kva(minfo);
+	fcpim->tskim_arr = tskim;
+
+	for (i = 0; i < fcpim->num_tskim_reqs; i++, tskim++) {
+		/*
+		 * initialize TSKIM
+		 */
+		bfa_os_memset(tskim, 0, sizeof(struct bfa_tskim_s));
+		tskim->tsk_tag = i;
+		tskim->bfa     = fcpim->bfa;
+		tskim->fcpim   = fcpim;
+		tskim->notify  = BFA_FALSE;
+		bfa_reqq_winit(&tskim->reqq_wait, bfa_tskim_qresume,
+				   tskim);
+		bfa_sm_set_state(tskim, bfa_tskim_sm_uninit);
+
+		list_add_tail(&tskim->qe, &fcpim->tskim_free_q);
+	}
+
+	bfa_meminfo_kva(minfo) = (u8 *) tskim;
+}
+
+void
+bfa_tskim_detach(struct bfa_fcpim_mod_s *fcpim)
+{
+    /**
+     * @todo
+     */
+}
+
+void
+bfa_tskim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	struct bfi_tskim_rsp_s *rsp = (struct bfi_tskim_rsp_s *) m;
+	struct bfa_tskim_s *tskim;
+	u16        tsk_tag = bfa_os_ntohs(rsp->tsk_tag);
+
+	tskim = BFA_TSKIM_FROM_TAG(fcpim, tsk_tag);
+	bfa_assert(tskim->tsk_tag == tsk_tag);
+
+	tskim->tsk_status = rsp->tsk_status;
+
+	/**
+	 * Firmware sends BFI_TSKIM_STS_ABORTED status for abort
+	 * requests. All other statuses are for normal completions.
+	 */
+	if (rsp->tsk_status == BFI_TSKIM_STS_ABORTED) {
+		bfa_stats(tskim->itnim, tm_cleanup_comps);
+		bfa_sm_send_event(tskim, BFA_TSKIM_SM_CLEANUP_DONE);
+	} else {
+		bfa_stats(tskim->itnim, tm_fw_rsps);
+		bfa_sm_send_event(tskim, BFA_TSKIM_SM_DONE);
+	}
+}
+
+
+
+/**
+ *  hal_tskim_api
+ */
+
+
+struct bfa_tskim_s *
+bfa_tskim_alloc(struct bfa_s *bfa, struct bfad_tskim_s *dtsk)
+{
+	struct bfa_fcpim_mod_s *fcpim = BFA_FCPIM_MOD(bfa);
+	struct bfa_tskim_s *tskim;
+
+	bfa_q_deq(&fcpim->tskim_free_q, &tskim);
+
+	if (!tskim)
+		bfa_fcpim_stats(fcpim, no_tskims);
+	else
+		tskim->dtsk = dtsk;
+
+	return tskim;
+}
+
+void
+bfa_tskim_free(struct bfa_tskim_s *tskim)
+{
+	bfa_assert(bfa_q_is_on_q_func(&tskim->itnim->tsk_q, &tskim->qe));
+	list_del(&tskim->qe);
+	list_add_tail(&tskim->qe, &tskim->fcpim->tskim_free_q);
+}
+
+/**
+ *      Start a task management command.
+ *
+ * @param[in]       tskim       BFA task management command instance
+ * @param[in]       itnim       i-t nexus for the task management command
+ * @param[in]       lun         lun, if applicable
+ * @param[in]       tm_cmnd     Task management command code.
+ * @param[in]       t_secs      Timeout in seconds
+ *
+ * @return None.
+ */
+void
+bfa_tskim_start(struct bfa_tskim_s *tskim, struct bfa_itnim_s *itnim, lun_t lun,
+		    fcp_tm_cmnd_t tm_cmnd, u8 tsecs)
+{
+	tskim->itnim   = itnim;
+	tskim->lun     = lun;
+	tskim->tm_cmnd = tm_cmnd;
+	tskim->tsecs   = tsecs;
+	tskim->notify  = BFA_FALSE;
+	bfa_stats(itnim, tm_cmnds);
+
+	list_add_tail(&tskim->qe, &itnim->tsk_q);
+	bfa_sm_send_event(tskim, BFA_TSKIM_SM_START);
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_uf.c patch/drivers/scsi/bfa/bfa_uf.c
--- orig/drivers/scsi/bfa/bfa_uf.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_uf.c	2009-03-14 11:44:57.347166000 -0700
@@ -0,0 +1,339 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_uf.c BFA unsolicited frame receive implementation
+ */
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include <bfi/bfi_uf.h>
+#include <cs/bfa_debug.h>
+
+BFA_TRC_FILE(HAL, UF);
+BFA_MODULE(uf);
+
+/*
+ *****************************************************************************
+ * Internal functions
+ *****************************************************************************
+ */
+static void
+__bfa_cb_uf_recv(void *cbarg, bfa_boolean_t complete)
+{
+	struct bfa_uf_s   *uf = cbarg;
+	struct bfa_uf_mod_s *ufm = BFA_UF_MOD(uf->bfa);
+
+	if (complete)
+		ufm->ufrecv(ufm->cbarg, uf);
+}
+
+static void
+claim_uf_pbs(struct bfa_uf_mod_s *ufm, struct bfa_meminfo_s *mi)
+{
+	u32        uf_pb_tot_sz;
+
+	ufm->uf_pbs_kva = (struct bfa_uf_buf_s *) bfa_meminfo_dma_virt(mi);
+	ufm->uf_pbs_pa = bfa_meminfo_dma_phys(mi);
+	uf_pb_tot_sz = BFA_ROUNDUP((sizeof(struct bfa_uf_buf_s) * ufm->num_ufs),
+							BFA_DMA_ALIGN_SZ);
+
+	bfa_meminfo_dma_virt(mi) += uf_pb_tot_sz;
+	bfa_meminfo_dma_phys(mi) += uf_pb_tot_sz;
+
+	bfa_os_memset((void *)ufm->uf_pbs_kva, 0, uf_pb_tot_sz);
+}
+
+static void
+claim_uf_post_msgs(struct bfa_uf_mod_s *ufm, struct bfa_meminfo_s *mi)
+{
+	struct bfi_uf_buf_post_s *uf_bp_msg;
+	struct bfi_sge_s      *sge;
+	union bfi_addr_u      sga_zero = { {0} };
+	u16        i;
+	u16        buf_len;
+
+	ufm->uf_buf_posts = (struct bfi_uf_buf_post_s *) bfa_meminfo_kva(mi);
+	uf_bp_msg = ufm->uf_buf_posts;
+
+	for (i = 0, uf_bp_msg = ufm->uf_buf_posts; i < ufm->num_ufs;
+	     i++, uf_bp_msg++) {
+		bfa_os_memset(uf_bp_msg, 0, sizeof(struct bfi_uf_buf_post_s));
+
+		uf_bp_msg->buf_tag = i;
+		buf_len = sizeof(struct bfa_uf_buf_s);
+		uf_bp_msg->buf_len = bfa_os_htons(buf_len);
+		bfi_h2i_set(uf_bp_msg->mh, BFI_MC_UF, BFI_UF_H2I_BUF_POST,
+			    bfa_lpuid(ufm->bfa));
+
+		sge = uf_bp_msg->sge;
+		sge[0].sg_len = buf_len;
+		sge[0].flags = BFI_SGE_DATA_LAST;
+		bfa_dma_addr_set(sge[0].sga, ufm_pbs_pa(ufm, i));
+		bfa_sge_to_be(sge);
+
+		sge[1].sg_len = buf_len;
+		sge[1].flags = BFI_SGE_PGDLEN;
+		sge[1].sga = sga_zero;
+		bfa_sge_to_be(&sge[1]);
+	}
+
+	/**
+	 * advance pointer beyond consumed memory
+	 */
+	bfa_meminfo_kva(mi) = (u8 *) uf_bp_msg;
+}
+
+static void
+claim_ufs(struct bfa_uf_mod_s *ufm, struct bfa_meminfo_s *mi)
+{
+	u16        i;
+	struct bfa_uf_s   *uf;
+
+	/*
+	 * Claim block of memory for UF list
+	 */
+	ufm->uf_list = (struct bfa_uf_s *) bfa_meminfo_kva(mi);
+
+	/*
+	 * Initialize UFs and queue it in UF free queue
+	 */
+	for (i = 0, uf = ufm->uf_list; i < ufm->num_ufs; i++, uf++) {
+		bfa_os_memset(uf, 0, sizeof(struct bfa_uf_s));
+		uf->bfa = ufm->bfa;
+		uf->uf_tag = i;
+		uf->pb_len = sizeof(struct bfa_uf_buf_s);
+		uf->buf_kva = (void *)&ufm->uf_pbs_kva[i];
+		uf->buf_pa = ufm_pbs_pa(ufm, i);
+		list_add_tail(&uf->qe, &ufm->uf_free_q);
+	}
+
+	/**
+	 * advance memory pointer
+	 */
+	bfa_meminfo_kva(mi) = (u8 *) uf;
+}
+
+static void
+uf_mem_claim(struct bfa_uf_mod_s *ufm, struct bfa_meminfo_s *mi)
+{
+	claim_uf_pbs(ufm, mi);
+	claim_ufs(ufm, mi);
+	claim_uf_post_msgs(ufm, mi);
+}
+
+static void
+bfa_uf_meminfo(struct bfa_iocfc_cfg_s *cfg, u32 *ndm_len, u32 *dm_len)
+{
+	u32        num_ufs = cfg->fwcfg.num_uf_bufs;
+
+	/*
+	 * dma-able memory for UF posted bufs
+	 */
+	*dm_len += BFA_ROUNDUP((sizeof(struct bfa_uf_buf_s) * num_ufs),
+							BFA_DMA_ALIGN_SZ);
+
+	/*
+	 * kernel Virtual memory for UFs and UF buf post msg copies
+	 */
+	*ndm_len += sizeof(struct bfa_uf_s) * num_ufs;
+	*ndm_len += sizeof(struct bfi_uf_buf_post_s) * num_ufs;
+}
+
+static void
+bfa_uf_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
+		  struct bfa_meminfo_s *meminfo, struct bfa_pcidev_s *pcidev)
+{
+	struct bfa_uf_mod_s *ufm = BFA_UF_MOD(bfa);
+
+	bfa_os_memset(ufm, 0, sizeof(struct bfa_uf_mod_s));
+	ufm->bfa = bfa;
+	ufm->num_ufs = cfg->fwcfg.num_uf_bufs;
+	INIT_LIST_HEAD(&ufm->uf_free_q);
+	INIT_LIST_HEAD(&ufm->uf_posted_q);
+
+	uf_mem_claim(ufm, meminfo);
+}
+
+static void
+bfa_uf_initdone(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_uf_detach(struct bfa_s *bfa)
+{
+}
+
+static struct bfa_uf_s *
+bfa_uf_get(struct bfa_uf_mod_s *uf_mod)
+{
+	struct bfa_uf_s   *uf;
+
+	bfa_q_deq(&uf_mod->uf_free_q, &uf);
+	return (uf);
+}
+
+static void
+bfa_uf_put(struct bfa_uf_mod_s *uf_mod, struct bfa_uf_s *uf)
+{
+	list_add_tail(&uf->qe, &uf_mod->uf_free_q);
+}
+
+static void
+bfa_uf_post(struct bfa_uf_mod_s *ufm, struct bfa_uf_s *uf)
+{
+	struct bfi_uf_buf_post_s *uf_post_msg;
+
+	uf_post_msg = bfa_reqq_next(ufm->bfa, BFA_REQQ_FCXP);
+
+	bfa_os_memcpy(uf_post_msg, &ufm->uf_buf_posts[uf->uf_tag],
+		      sizeof(struct bfi_uf_buf_post_s));
+	bfa_reqq_produce(ufm->bfa, BFA_REQQ_FCXP);
+
+	bfa_trc(ufm->bfa, uf->uf_tag);
+
+	list_add_tail(&uf->qe, &ufm->uf_posted_q);
+}
+
+static void
+bfa_uf_post_all(struct bfa_uf_mod_s *uf_mod)
+{
+	struct bfa_uf_s   *uf;
+
+	while ((uf = bfa_uf_get(uf_mod)) != NULL)
+		bfa_uf_post(uf_mod, uf);
+}
+
+static void
+uf_recv(struct bfa_s *bfa, struct bfi_uf_frm_rcvd_s *m)
+{
+	struct bfa_uf_mod_s *ufm = BFA_UF_MOD(bfa);
+	u16        uf_tag = m->buf_tag;
+	struct bfa_uf_buf_s *uf_buf = &ufm->uf_pbs_kva[uf_tag];
+	struct bfa_uf_s   *uf = &ufm->uf_list[uf_tag];
+	u8        *buf = &uf_buf->d[0];
+	fchs_t         *fchs;
+
+	m->frm_len = bfa_os_ntohs(m->frm_len);
+	m->xfr_len = bfa_os_ntohs(m->xfr_len);
+
+	fchs = (fchs_t *) uf_buf;
+
+	list_del(&uf->qe);	/* dequeue from posted queue */
+
+	uf->data_ptr = buf;
+	uf->data_len = m->xfr_len;
+
+	bfa_assert(uf->data_len >= sizeof(fchs_t));
+
+	if (uf->data_len == sizeof(fchs_t)) {
+		bfa_plog_fchdr(bfa->plog, BFA_PL_MID_HAL_UF, BFA_PL_EID_RX,
+			       uf->data_len, (fchs_t *) buf);
+	} else {
+		u32        pld_w0 = *((u32 *) (buf + sizeof(fchs_t)));
+		bfa_plog_fchdr_and_pl(bfa->plog, BFA_PL_MID_HAL_UF,
+				      BFA_PL_EID_RX, uf->data_len,
+				      (fchs_t *) buf, pld_w0);
+	}
+
+	bfa_cb_queue(bfa, &uf->hcb_qe, __bfa_cb_uf_recv, uf);
+}
+
+static void
+bfa_uf_stop(struct bfa_s *bfa)
+{
+}
+
+static void
+bfa_uf_iocdisable(struct bfa_s *bfa)
+{
+	struct bfa_uf_mod_s *ufm = BFA_UF_MOD(bfa);
+	struct bfa_uf_s   *uf;
+	struct list_head        *qe, *qen;
+
+	list_for_each_safe(qe, qen, &ufm->uf_posted_q) {
+		uf = (struct bfa_uf_s *) qe;
+		list_del(&uf->qe);
+		bfa_uf_put(ufm, uf);
+	}
+}
+
+static void
+bfa_uf_start(struct bfa_s *bfa)
+{
+	bfa_uf_post_all(BFA_UF_MOD(bfa));
+}
+
+
+
+/**
+ *  hal_uf_api
+ */
+
+/**
+ * 		Register handler for all unsolicted recieve frames.
+ *
+ * @param[in]	bfa		BFA instance
+ * @param[in]	ufrecv	receive handler function
+ * @param[in]	cbarg	receive handler arg
+ */
+void
+bfa_uf_recv_register(struct bfa_s *bfa, bfa_cb_uf_recv_t ufrecv, void *cbarg)
+{
+	struct bfa_uf_mod_s *ufm = BFA_UF_MOD(bfa);
+
+	ufm->ufrecv = ufrecv;
+	ufm->cbarg = cbarg;
+}
+
+/**
+ * 		Free an unsolicited frame back to BFA.
+ *
+ * @param[in]		uf		unsolicited frame to be freed
+ *
+ * @return None
+ */
+void
+bfa_uf_free(struct bfa_uf_s *uf)
+{
+	bfa_uf_post(BFA_UF_MOD(uf->bfa), uf);
+}
+
+
+
+/**
+ *  uf_pub BFA uf module public functions
+ */
+
+void
+bfa_uf_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
+{
+	bfa_trc(bfa, msg->mhdr.msg_id);
+
+	switch (msg->mhdr.msg_id) {
+	case BFI_UF_I2H_FRM_RCVD:
+		uf_recv(bfa, (struct bfi_uf_frm_rcvd_s *) msg);
+		break;
+
+	default:
+		bfa_trc(bfa, msg->mhdr.msg_id);
+		bfa_assert(0);
+	}
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_uf_priv.h patch/drivers/scsi/bfa/bfa_uf_priv.h
--- orig/drivers/scsi/bfa/bfa_uf_priv.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_uf_priv.h	2009-03-14 11:44:57.354529000 -0700
@@ -0,0 +1,47 @@
+/*
+ * Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_UF_PRIV_H__
+#define __BFA_UF_PRIV_H__
+
+#include <cs/bfa_sm.h>
+#include <bfa_svc.h>
+#include <bfi/bfi_uf.h>
+
+#define BFA_UF_MIN	(4)
+
+struct bfa_uf_mod_s {
+	struct bfa_s *bfa;		/*  back pointer to BFA */
+	struct bfa_uf_s *uf_list;	/*  array of UFs */
+	u16	num_ufs;	/*  num unsolicited rx frames */
+	struct list_head 	uf_free_q;	/*  free UFs */
+	struct list_head 	uf_posted_q;	/*  UFs posted to IOC */
+	struct bfa_uf_buf_s *uf_pbs_kva;	/*  list UF bufs request pld */
+	u64	uf_pbs_pa;	/*  phy addr for UF bufs */
+	struct bfi_uf_buf_post_s *uf_buf_posts;
+					/*  pre-built UF post msgs */
+	bfa_cb_uf_recv_t ufrecv;	/*  uf recv handler function */
+	void		*cbarg;		/*  uf receive handler arg */
+};
+
+#define BFA_UF_MOD(__bfa)	(&(__bfa)->modules.uf_mod)
+
+#define ufm_pbs_pa(_ufmod, _uftag)	\
+	((_ufmod)->uf_pbs_pa + sizeof(struct bfa_uf_buf_s) * (_uftag))
+
+void	bfa_uf_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+
+#endif /* __BFA_UF_PRIV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfa_vfapi.c patch/drivers/scsi/bfa/bfa_vfapi.c
--- orig/drivers/scsi/bfa/bfa_vfapi.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_vfapi.c	2009-03-14 11:44:57.361676000 -0700
@@ -0,0 +1,319 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  vfapi.c Fabric module implementation.
+ */
+
+#include <bfa.h>
+#include <bfa_fabric.h>
+#include <bfi/bfi_fabric.h>
+
+BFA_TRC_FILE(HAL, FABRIC);
+
+/**
+ *  vf_api virtual fabrics API
+ */
+
+/**
+ * 		Enable VF mode.
+ *
+ * @param[in]		bfa		bfa module instance
+ * @param[in]		vf_id		default vf_id of port, FC_VF_ID_NULL
+ * 					to use standard default vf_id of 1.
+ *
+ * @retval	BFA_STATUS_OK		vf mode is enabled
+ * @retval	BFA_STATUS_BUSY		Port is active. Port must be disabled
+ *					before VF mode can be enabled.
+ */
+bfa_status_t
+bfa_vf_mode_enable(struct bfa_s *bfa, u16 vf_id)
+{
+	return BFA_STATUS_OK;
+}
+
+/**
+ * 		Disable VF mode.
+ *
+ * @param[in]		bfa		bfa module instance
+ *
+ * @retval	BFA_STATUS_OK		vf mode is disabled
+ * @retval	BFA_STATUS_BUSY		VFs are present and being used. All
+ * 					VFs must be deleted before disabling
+ *					VF mode.
+ */
+bfa_status_t
+bfa_vf_mode_disable(struct bfa_s *bfa)
+{
+	return BFA_STATUS_OK;
+}
+
+/**
+ * 		Create a new VF instance.
+ *
+ *  A new VF is created using the given VF configuration. A VF is identified
+ *  by VF id. No duplicate VF creation is allowed with the same VF id. Once
+ *  a VF is created, VF is automatically started after link initialization
+ *  and EVFP exchange is completed.
+ *
+ * 	param[in] vf		- 	bfa vf data structure. Memory is
+ *					allocated by caller (driver)
+ * 	param[in] bfa 		- 	bfa module
+ * 	param[in] vf_cfg	- 	VF configuration
+ * 	param[in] vf_drv 	- 	Opaque handle back to the driver's
+ *					virtual vf structure
+ *
+ * 	retval BFA_STATUS_OK VF creation is successful
+ * 	retval BFA_STATUS_FAILED VF creation failed
+ * 	retval BFA_STATUS_EEXIST A VF exists with the given vf_id
+ */
+bfa_status_t
+bfa_vf_create(bfa_vf_t *vf, struct bfa_s *bfa, u16 vf_id,
+		  struct bfa_port_cfg_s *port_cfg, struct bfad_vf_s *vf_drv)
+{
+	bfa_trc(bfa, vf_id);
+	return BFA_STATUS_OK;
+}
+
+/**
+ *  	Use this function to delete a HAL VF object. VF object should
+ * 		be stopped before this function call.
+ *
+ * 	param[in] vf - pointer to bfa_vf_t.
+ *
+ * 	retval BFA_STATUS_OK	On vf deletion success
+ * 	retval BFA_STATUS_BUSY VF is not in a stopped state
+ * 	retval BFA_STATUS_INPROGRESS VF deletion in in progress
+ */
+bfa_status_t
+bfa_vf_delete(bfa_vf_t *vf)
+{
+	bfa_trc(vf->bfa, vf->vf_id);
+	return BFA_STATUS_OK;
+}
+
+/**
+ *  	Start participation in VF. This triggers login to the virtual fabric.
+ *
+ * 	param[in] vf - pointer to bfa_vf_t.
+ *
+ * 	return None
+ */
+void
+bfa_vf_start(bfa_vf_t *vf)
+{
+	struct bfi_fabric_start_req_s req;
+
+	bfa_trc(vf->bfa, vf->vf_id);
+	req.mh.msg_id = BFI_FABRIC_H2I_START_REQ;
+	req.vf_id = vf->vf_id;
+	bfi_h2i_set(req.mh, BFI_MC_FABRIC, BFI_FABRIC_H2I_START_REQ,
+			bfa_lpuid(vf->bfa));
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(vf->bfa, vf->reqq);
+
+}
+
+/**
+ *  	Logout with the virtual fabric.
+ *
+ * 	param[in] vf - pointer to bfa_vf_t.
+ *
+ * 	retval BFA_STATUS_OK 	On success.
+ * 	retval BFA_STATUS_INPROGRESS VF is being stopped.
+ */
+bfa_status_t
+bfa_vf_stop(bfa_vf_t *vf)
+{
+	struct bfi_fabric_stop_req_s req;
+	bfa_trc(vf->bfa, vf->vf_id);
+	req.mh.msg_id = BFI_FABRIC_H2I_STOP_REQ;
+	bfi_h2i_set(req.mh, BFI_MC_FABRIC, BFI_FABRIC_H2I_STOP_REQ,
+			bfa_lpuid(vf->bfa));
+	/**
+	 * queue I/O message to firmware
+	 */
+	bfa_reqq_produce(vf->bfa, vf->reqq);
+
+	//bfa_cb_vf_stop(vf_drv);
+	return BFA_STATUS_OK;
+}
+
+/**
+ *  	Returns attributes of the given VF.
+ *
+ * 	param[in] 	vf			pointer to bfa_vf_t.
+ * 	param[out] vf_attr 	vf attributes returned
+ *
+ * 	return None
+ */
+void
+bfa_vf_get_attr(bfa_vf_t *vf, struct bfa_vf_attr_s *vf_attr)
+{
+	bfa_trc(vf->bfa, vf->vf_id);
+}
+
+/**
+ * 		Return statistics associated with the given vf.
+ *
+ * 	param[in] 	vf			pointer to bfa_vf_t.
+ * 	param[out] vf_stats 	vf statistics returned
+ *
+ *  @return None
+ */
+void
+bfa_vf_get_stats(bfa_vf_t *vf, struct bfa_vf_stats_s *vf_stats)
+{
+	bfa_os_memcpy(vf_stats, &vf->stats, sizeof(struct bfa_vf_stats_s));
+	return;
+}
+
+void
+/**
+ * 		clear statistics associated with the given vf.
+ *
+ * 	param[in] 	vf			pointer to bfa_vf_t.
+ *
+ *  @return None
+ */
+bfa_vf_clear_stats(bfa_vf_t *vf)
+{
+	bfa_os_memset(&vf->stats, 0, sizeof(struct bfa_vf_stats_s));
+	return;
+}
+
+/**
+ *  	Returns bfa vf structure for a given vf_id.
+ *
+ * 	param[in] 	vf_id		- VF_ID
+ *
+ * 	return
+ * 		If lookup succeeds, retuns bfa vf object, otherwise returns NULL
+ */
+bfa_vf_t   *
+bfa_vf_lookup(struct bfa_s *bfa, u16 vf_id)
+{
+	bfa_vf_t *vf;
+	struct list_head        *qe;
+
+	bfa_trc(bfa, vf_id);
+	if (vf_id == FC_VF_ID_NULL)
+		return (&bfa->fabric);
+
+	list_for_each(qe, &bfa->fabric.vf_q) {
+		vf = (bfa_vf_t *) qe;
+		if (vf->vf_id == vf_id)
+			return vf;
+	}
+
+	return NULL;
+}
+
+/**
+ *  	Returns driver VF structure for a given bfa vf.
+ *
+ * 	param[in] 	vf		- pointer to bfa_vf_t
+ *
+ * 	return Driver VF structure
+ */
+struct bfad_vf_s      *
+bfa_vf_get_drv_vf(bfa_vf_t *vf)
+{
+	bfa_assert(vf);
+	bfa_trc(vf->bfa, vf->vf_id);
+	return vf->vf_drv;
+}
+
+/**
+ *  	Return the list of VFs configured.
+ *
+ * 	param[in]	bfa	bfa module instance
+ * 	param[out] 	vf_ids	returned list of vf_ids
+ * 	param[in,out] 	nvfs	in:size of vf_ids array,
+ * 				out:total elements present,
+ * 				actual elements returned is limited by the size
+ *
+ * 	return Driver VF structure
+ */
+void
+bfa_vf_list(struct bfa_s *bfa, u16 *vf_ids, int *nvfs)
+{
+	bfa_trc(bfa, *nvfs);
+}
+
+/**
+ *  	Return the list of all VFs visible from fabric.
+ *
+ * 	param[in]	bfa	bfa module instance
+ * 	param[out] 	vf_ids	returned list of vf_ids
+ * 	param[in,out] 	nvfs	in:size of vf_ids array,
+ *				out:total elements present,
+ * 				actual elements returned is limited by the size
+ *
+ * 	return Driver VF structure
+ */
+void
+bfa_vf_list_all(struct bfa_s *bfa, u16 *vf_ids, int *nvfs)
+{
+	bfa_trc(bfa, *nvfs);
+}
+
+/**
+ * 		Return the list of local logical ports present in the given VF.
+ *
+ * 	param[in]	vf	vf for which logical ports are returned
+ * 	param[out] 	lpwwn	returned logical port wwn list
+ * 	param[in,out] 	nlports	in:size of lpwwn list;
+ *				out:total elements present,
+ * 				actual elements returned is limited by the size
+ *
+ */
+void
+bfa_vf_get_ports(bfa_vf_t *vf, wwn_t lpwwn[], int *nlports)
+{
+	struct list_head        *qe;
+	struct bfa_vport_s *vport;
+	int             i;
+	struct bfa_s      *bfa;
+
+	if (vf == NULL || lpwwn == NULL || *nlports == 0)
+		return;
+
+	bfa = vf->bfa;
+
+	bfa_trc(bfa, vf->vf_id);
+	bfa_trc(bfa, (u32) *nlports);
+
+	i = 0;
+	lpwwn[i++] = vf->bport.port_cfg.pwwn;
+
+	list_for_each(qe, &vf->vport_q) {
+		if (i >= *nlports)
+			break;
+
+		vport = (struct bfa_vport_s *) qe;
+		lpwwn[i++] = vport->lport.port_cfg.pwwn;
+	}
+
+	bfa_trc(bfa, i);
+	*nlports = i;
+	return;
+}
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_vport.c patch/drivers/scsi/bfa/bfa_vport.c
--- orig/drivers/scsi/bfa/bfa_vport.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_vport.c	2009-03-14 11:44:57.369130000 -0700
@@ -0,0 +1,305 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_vport.c Virtual port state machine
+ */
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include <bfa_lport.h>
+#include <bfa_vport.h>
+#include <bfa_fabric.h>
+#include <bfi/bfi_vport.h>
+#include <aen/bfa_aen_lport.h>
+
+BFA_TRC_FILE(HAL, VPORT);
+
+/*
+ * forward declarations
+ */
+static bfa_boolean_t bfa_vport_send_fwcreate(struct bfa_vport_s *vport);
+static bfa_boolean_t bfa_vport_send_fwdelete(struct bfa_vport_s *vport);
+static void bfa_vport_delete_comp(struct bfa_vport_s *vport);
+
+/**
+ *  bfa_vport_priv Virtual port private functions 
+ */
+
+void
+bfa_vport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg)
+{
+	union bfi_vport_i2h_msg_u event;
+	struct bfa_vport_s *vport;
+
+	event.msg = msg;
+	switch (event.msg->mhdr.msg_id) {
+	case BFI_VPORT_I2H_DELETE_RSP:
+		vport = BFA_VPORT_FROM_TAG(bfa, event.delete_rsp->vport_tag);
+		bfa_assert(event.delete_rsp->status == BFA_STATUS_OK);
+		bfa_vport_delete_comp(vport);
+		break;
+	}
+}
+
+static bfa_boolean_t
+bfa_vport_send_fwcreate(struct bfa_vport_s *vport)
+{
+	struct bfa_lport_s *lport = &vport->lport;
+	struct bfa_s *bfa = lport->bfa;
+	struct bfi_vport_create_req_s *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(bfa, BFA_REQQ_VPORT);
+	if (!m) {
+		/* TODO 
+		bfa_reqq_wait(vport->fabric->bfa, BFA_REQQ_VPORT,
+			&vport->reqq_wait);
+		*/
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_VPORT, BFI_VPORT_H2I_CREATE_REQ,
+			bfa_lpuid(bfa));
+
+	bfa_lport_msg_init(&vport->lport, m);
+
+	/**
+	 * queue message to firmware
+	 */
+	bfa_reqq_produce(bfa, BFA_REQQ_VPORT);
+
+	return BFA_TRUE;
+}
+
+static bfa_boolean_t
+bfa_vport_send_fwdelete(struct bfa_vport_s *vport)
+{
+	struct bfa_lport_s *lport = &vport->lport;
+	struct bfa_s *bfa = lport->bfa;
+	struct bfi_vport_delete_req_s *m;
+
+	/**
+	 * check for room in queue to send request now
+	 */
+	m = bfa_reqq_next(bfa, BFA_REQQ_VPORT);
+	if (!m) {
+		// bfa_reqq_wait(vport->fabric->bfa, vport->reqq, &vport->reqq_wait);
+		return BFA_FALSE;
+	}
+
+	bfi_h2i_set(m->mh, BFI_MC_VPORT, BFI_VPORT_H2I_DELETE_REQ,
+			bfa_lpuid(bfa));
+
+	m->fabric_tag = lport->fabric_tag;
+	m->vport_tag = lport->lport_tag->lport_tag;
+
+	/**
+	 * queue message to firmware
+	 */
+	bfa_reqq_produce(bfa, BFA_REQQ_VPORT);
+
+	return BFA_TRUE;
+}
+
+static void
+bfa_vport_delete_comp(struct bfa_vport_s *vport)
+{
+	struct bfa_lport_s *lport = &vport->lport;
+
+	bfa_lport_tag_free(BFA_LPTAG_FROM_LPORT(lport));
+	bfa_fabric_del_vport(lport->fabric, vport);
+	bfa_cb_vport_delete(vport->vport_drv);
+}
+
+
+
+/**
+ *  bfa_vport_api Virtual port API
+ */
+
+/**
+ *  	Use this function to instantiate a new BFA vport object. This
+ * 	function will not trigger any HW initialization process (which will be
+ * 	done in vport_start() call)
+ *
+ * 	param[in] vport	- 	pointer to bfa_vport_t. This space
+ *					needs to be allocated by the driver.
+ * 	param[in] bfa 		- 	BFA instance
+ * 	param[in] vport_cfg	- 	vport configuration
+ * 	param[in] vf_id    	- 	VF_ID if vport is created within a VF.
+ *                          		FC_VF_ID_NULL to specify base fabric.
+ * 	param[in] vport_drv 	- 	Opaque handle back to the driver's vport
+ * 					structure
+ *
+ * 	retval BFA_STATUS_OK - on success.
+ * 	retval BFA_STATUS_FAILED - on failure.
+ */
+bfa_status_t
+bfa_vport_create(struct bfa_vport_s *vport, struct bfa_s *bfa,
+		u16 vf_id, struct bfa_port_cfg_s *vport_cfg,
+		struct bfad_vport_s *vport_drv)
+{
+	struct bfa_lptag_s *lptag;
+	struct bfa_fabric_s *fabric;
+
+	if (vport_cfg->pwwn == 0)
+		return (BFA_STATUS_INVALID_WWN);
+
+	fabric = bfa_vf_lookup(bfa, vf_id);
+
+	if (bfa_lport_get_pwwn(bfa_fabric_get_bport(fabric)) == vport_cfg->pwwn)
+		return BFA_STATUS_VPORT_WWN_BP;
+
+	if (bfa_fabric_vport_lookup(fabric, vport_cfg->pwwn) != NULL)
+		return BFA_STATUS_VPORT_EXISTS;
+
+	if (bfa_fabric_vport_count(fabric) == (BFA_LPORT_MAX-1))
+		return BFA_STATUS_VPORT_MAX;
+	
+	lptag = bfa_lport_tag_alloc(BFA_LPORT_MOD(bfa));
+	if (lptag == NULL)
+		return BFA_STATUS_VPORT_MAX;
+
+	vport->vport_drv = vport_drv;
+	
+	bfa_lport_init(&vport->lport, bfa, vf_id, lptag, vport_cfg, vport);
+	bfa_fabric_add_vport(fabric, vport);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ *  	Use this function initialize the vport.
+ *
+ *  @param[in] vport - pointer to bfa_vport_t.
+ *
+ *  @returns None
+ */
+bfa_status_t
+bfa_vport_start(struct bfa_vport_s *vport)
+{
+	/* Send message to FW to start vport */
+	bfa_vport_send_fwcreate(vport);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ *  	Use this function quiese the vport object. This function will return
+ * 	immediately, when the vport is actually stopped, the
+ * 	bfa_drv_vport_stop_cb() will be called.
+ *
+ * 	param[in] vport - pointer to bfa_vport_t.
+ *
+ * 	return None
+ */
+bfa_status_t
+bfa_vport_stop(struct bfa_vport_s *vport)
+{
+	/* Send message to FW to stop vport */
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ *  	Use this function to delete a vport object. Fabric object should
+ * 		be stopped before this function call.
+ *
+ * 	param[in] vport - pointer to bfa_vport_t.
+ *
+ * 	return     None
+ */
+bfa_status_t
+bfa_vport_delete(struct bfa_vport_s *vport)
+{
+	bfa_vport_send_fwdelete(vport);
+
+	return BFA_STATUS_OK;
+}
+
+/**
+ *  	Use this function to get vport's current status info.
+ *
+ * 	param[in] 	vport 		pointer to bfa_vport_t.
+ * 	param[out]	attr 		pointer to return vport attributes
+ *
+ * 	return None
+ */
+void
+bfa_vport_get_attr(struct bfa_vport_s *vport, struct bfa_vport_attr_s *attr)
+{
+	if (vport == NULL || attr == NULL)
+		return;
+
+	bfa_os_memset(attr, 0, sizeof(struct bfa_vport_attr_s));
+
+	/* Send message to FW to get attribute */
+}
+
+/**
+ *  	Use this function to get vport's statistics.
+ *
+ * 	param[in] 	vport 		pointer to bfa_vport_t.
+ * 	param[out]	stats		pointer to return vport statistics in
+ *
+ * 	return None
+ */
+void
+bfa_vport_get_stats(struct bfa_vport_s *vport,
+		struct bfa_vport_stats_s *stats)
+{
+	//*stats = vport->vport_stats;
+	/* Send message to FW to get stats */
+}
+
+/**
+ *  	Use this function to clear vport's statistics.
+ *
+ * 	param[in] 	vport 		pointer to bfa_vport_t.
+ *
+ * 	return None
+ */
+void
+bfa_vport_clr_stats(struct bfa_vport_s *vport)
+{
+	/* Send message to FW to clear stats */
+}
+
+struct bfa_vport_s *
+bfa_vport_lookup(struct bfa_s *bfa, u16 vf_id, wwn_t vpwwn)
+{
+	struct bfa_vport_s *vport;
+	struct bfa_fabric_s *fabric;
+
+	bfa_trc(bfa, vf_id);
+	bfa_trc(bfa, vpwwn);
+
+	fabric = bfa_vf_lookup(bfa, vf_id);
+	if (!fabric) {
+		bfa_trc(bfa, vf_id);
+		return NULL;
+	}
+
+	vport = bfa_fabric_vport_lookup(fabric, vpwwn);
+	return (vport);
+}
+
+
+
diff -urpN orig/drivers/scsi/bfa/bfa_vport.h patch/drivers/scsi/bfa/bfa_vport.h
--- orig/drivers/scsi/bfa/bfa_vport.h	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfa_vport.h	2009-03-14 11:44:57.376096000 -0700
@@ -0,0 +1,88 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfa_fcs_vport.h BFA fcs vport module public interface
+ */
+
+#ifndef __BFA_VPORT_H__
+#define __BFA_VPORT_H__
+
+#include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_port.h>
+#include <defs/bfa_defs_vport.h>
+#include <cs/bfa_q.h>
+#include <bfa_lport.h>
+
+/**
+ * P R I V A T E   D E F I N I T I O N S
+ * - Used & visible to BFA RPORT module alone (private)
+ */
+struct bfa_vport_mod_s {
+
+};
+typedef struct bfa_vport_mod_s bfa_vport_mod_t;
+
+#define BFA_VPORT_FROM_TAG(__bfa, _tag)					\
+	((struct bfa_lport_s *)BFA_LPORT_FROM_TAG(__bfa, _tag))->vport
+
+/**
+ * P R O T E C T E D   D E F I N I T I O N S
+ * - Shared between modules within BFA layer (protected)
+ */
+void bfa_vport_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
+
+#define bfa_vport_get_vpdrv(vport) vport->vport_drv 
+
+/**
+ * P U B L I C   D E F I N I T I O N S
+ * - Shared between BFA layer & Host Drivers (public)
+ */
+
+struct bfa_vport_s {
+	struct list_head		qe;		/*  queue elem */
+	bfa_lport_t		lport;		/*  logical port */
+	u8			reqq;		/*  CQ for requests */
+	struct bfad_vport_s	*vport_drv;	/*  Driver private */
+};
+typedef struct bfa_fcs_vport_s bfa_fcs_vport_t;
+
+bfa_status_t bfa_vport_create(struct bfa_vport_s *vport,
+			struct bfa_s *bfa, u16 vf_id,
+			struct bfa_port_cfg_s *port_cfg,
+			struct bfad_vport_s *vport_drv);
+bfa_status_t bfa_vport_delete(struct bfa_vport_s *vport);
+bfa_status_t bfa_vport_start(struct bfa_vport_s *vport);
+bfa_status_t bfa_vport_stop(struct bfa_vport_s *vport);
+void bfa_vport_get_attr(struct bfa_vport_s *vport,
+			struct bfa_vport_attr_s *vport_attr);
+void bfa_vport_get_stats(struct bfa_vport_s *vport,
+			struct bfa_vport_stats_s *vport_stats);
+void bfa_vport_clr_stats(struct bfa_vport_s *vport);
+struct bfa_vport_s *bfa_vport_lookup(struct bfa_s *bfa,
+			u16 vf_id, wwn_t vpwwn);
+
+/**
+ *      Completion callback for bfa_vport_delete().
+ *
+ * @param[in] vport_drv - driver instance of vport
+ *
+ * @return None
+ */
+void bfa_cb_vport_delete(struct bfad_vport_s *vport_drv);
+
+#endif /* __BFA_VPORT_H__ */
diff -urpN orig/drivers/scsi/bfa/plog.c patch/drivers/scsi/bfa/plog.c
--- orig/drivers/scsi/bfa/plog.c	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/plog.c	2009-03-14 11:44:57.387685000 -0700
@@ -0,0 +1,183 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <bfa_os_inc.h>
+#include <cs/bfa_plog.h>
+#include <cs/bfa_debug.h>
+
+static int
+plkd_validate_logrec(struct bfa_plog_rec_s *pl_rec)
+{
+	if ((pl_rec->log_type != BFA_PL_LOG_TYPE_INT)
+	    && (pl_rec->log_type != BFA_PL_LOG_TYPE_STRING))
+		return 1;
+
+	if ((pl_rec->log_type != BFA_PL_LOG_TYPE_INT)
+	    && (pl_rec->log_num_ints > BFA_PL_INT_LOG_SZ))
+		return 1;
+
+	return 0;
+}
+
+static void
+bfa_plog_add(struct bfa_plog_s *plog, struct bfa_plog_rec_s *pl_rec)
+{
+	u16        tail;
+	struct bfa_plog_rec_s *pl_recp;
+
+	if (plog->plog_enabled == 0)
+		return;
+
+	if (plkd_validate_logrec(pl_rec)) {
+		bfa_assert(0);
+		return;
+	}
+
+	tail = plog->tail;
+
+	pl_recp = &(plog->plog_recs[tail]);
+
+	bfa_os_memcpy(pl_recp, pl_rec, sizeof(struct bfa_plog_rec_s));
+
+	pl_recp->tv = BFA_TRC_TS(plog);
+	BFA_PL_LOG_REC_INCR(plog->tail);
+
+	if (plog->head == plog->tail)
+		BFA_PL_LOG_REC_INCR(plog->head);
+}
+
+void
+bfa_plog_init(struct bfa_plog_s *plog)
+{
+	bfa_os_memset((char *)plog, 0, sizeof(struct bfa_plog_s));
+
+	bfa_os_memcpy(plog->plog_sig, BFA_PL_SIG_STR, BFA_PL_SIG_LEN);
+	plog->head = plog->tail = 0;
+	plog->plog_enabled = 1;
+}
+
+void
+bfa_plog_str(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+		enum bfa_plog_eid event,
+		u16 misc, char *log_str)
+{
+	struct bfa_plog_rec_s  lp;
+
+	if (plog->plog_enabled) {
+		bfa_os_memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
+		lp.mid = mid;
+		lp.eid = event;
+		lp.log_type = BFA_PL_LOG_TYPE_STRING;
+		lp.misc = misc;
+		strncpy(lp.log_entry.string_log, log_str,
+			BFA_PL_STRING_LOG_SZ - 1);
+		lp.log_entry.string_log[BFA_PL_STRING_LOG_SZ - 1] = '\0';
+		bfa_plog_add(plog, &lp);
+	}
+}
+
+void
+bfa_plog_intarr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+		enum bfa_plog_eid event,
+		u16 misc, u32 *intarr, u32 num_ints)
+{
+	struct bfa_plog_rec_s  lp;
+	u32        i;
+
+	if (num_ints > BFA_PL_INT_LOG_SZ)
+		num_ints = BFA_PL_INT_LOG_SZ;
+
+	if (plog->plog_enabled) {
+		bfa_os_memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
+		lp.mid = mid;
+		lp.eid = event;
+		lp.log_type = BFA_PL_LOG_TYPE_INT;
+		lp.misc = misc;
+
+		for (i = 0; i < num_ints; i++)
+			lp.log_entry.int_log[i] = intarr[i];
+
+		lp.log_num_ints = (u8) num_ints;
+
+		bfa_plog_add(plog, &lp);
+	}
+}
+
+void
+bfa_plog_fchdr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+			enum bfa_plog_eid event,
+			u16 misc, fchs_t *fchdr)
+{
+	struct bfa_plog_rec_s  lp;
+	u32       *tmp_int = (u32 *) fchdr;
+	u32        ints[BFA_PL_INT_LOG_SZ];
+
+	if (plog->plog_enabled) {
+		bfa_os_memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
+
+		ints[0] = tmp_int[2];
+		ints[1] = tmp_int[3];
+		ints[2] = tmp_int[6];
+
+		bfa_plog_intarr(plog, mid, event, misc, ints, 3);
+	}
+}
+
+void
+bfa_plog_fchdr_and_pl(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
+		      enum bfa_plog_eid event, u16 misc, fchs_t *fchdr,
+		      u32 pld_w0)
+{
+	struct bfa_plog_rec_s  lp;
+	u32       *tmp_int = (u32 *) fchdr;
+	u32        ints[BFA_PL_INT_LOG_SZ];
+
+	if (plog->plog_enabled) {
+		bfa_os_memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
+
+		ints[0] = tmp_int[2];
+		ints[1] = tmp_int[3];
+		ints[2] = tmp_int[6];
+		ints[3] = pld_w0;
+
+		bfa_plog_intarr(plog, mid, event, misc, ints, 4);
+	}
+}
+
+void
+bfa_plog_clear(struct bfa_plog_s *plog)
+{
+	plog->head = plog->tail = 0;
+}
+
+void
+bfa_plog_enable(struct bfa_plog_s *plog)
+{
+	plog->plog_enabled = 1;
+}
+
+void
+bfa_plog_disable(struct bfa_plog_s *plog)
+{
+	plog->plog_enabled = 0;
+}
+
+bfa_boolean_t
+bfa_plog_get_setting(struct bfa_plog_s *plog)
+{
+	return((bfa_boolean_t)plog->plog_enabled);
+}
