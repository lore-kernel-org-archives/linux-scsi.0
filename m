From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 08/23] bfa: fix interrupt coalescing setting
Date: Tue, 15 Jun 2010 11:37:40 -0700
Message-ID: <1276627060-8868-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:41962 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754731Ab0FOSho (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2010 14:37:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vravindr@brocade.com, rvadivel@brocade.com, kgudipat@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

Do not update the coalesce flag of the intr_attr struct in driver config area
on config response.  This is to prevent the coalesce flag being reported as on
after an ioc disable/enable even if it was set to off before disable.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_iocfc.c |   43 +++++++++++++++++++++++++++++------------
 1 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_iocfc.c b/drivers/scsi/bfa/bfa_iocfc.c
index 6f54bea..0776d74 100644
--- a/drivers/scsi/bfa/bfa_iocfc.c
+++ b/drivers/scsi/bfa/bfa_iocfc.c
@@ -113,7 +113,6 @@ bfa_iocfc_send_cfg(void *bfa_arg)
 	bfa_assert(cfg->fwcfg.num_cqs <= BFI_IOC_MAX_CQS);
 	bfa_trc(bfa, cfg->fwcfg.num_cqs);
 
-	iocfc->cfgdone = BFA_FALSE;
 	bfa_iocfc_reset_queues(bfa);
 
 	/**
@@ -145,6 +144,15 @@ bfa_iocfc_send_cfg(void *bfa_arg)
 	}
 
 	/**
+	 * Enable interrupt coalescing if it is driver init path
+	 * and not ioc disable/enable path.
+	 */
+	if (!iocfc->cfgdone)
+		cfg_info->intr_attr.coalesce = BFA_TRUE;
+
+	iocfc->cfgdone = BFA_FALSE;
+
+	/**
 	 * dma map IOC configuration itself
 	 */
 	bfi_h2i_set(cfg_req.mh, BFI_MC_IOCFC, BFI_IOCFC_H2I_CFG_REQ,
@@ -364,7 +372,6 @@ bfa_iocfc_cfgrsp(struct bfa_s *bfa)
 	struct bfa_iocfc_s		*iocfc	 = &bfa->iocfc;
 	struct bfi_iocfc_cfgrsp_s	*cfgrsp  = iocfc->cfgrsp;
 	struct bfa_iocfc_fwcfg_s	*fwcfg   = &cfgrsp->fwcfg;
-	struct bfi_iocfc_cfg_s 		*cfginfo = iocfc->cfginfo;
 
 	fwcfg->num_cqs        = fwcfg->num_cqs;
 	fwcfg->num_ioim_reqs  = bfa_os_ntohs(fwcfg->num_ioim_reqs);
@@ -373,10 +380,6 @@ bfa_iocfc_cfgrsp(struct bfa_s *bfa)
 	fwcfg->num_uf_bufs    = bfa_os_ntohs(fwcfg->num_uf_bufs);
 	fwcfg->num_rports     = bfa_os_ntohs(fwcfg->num_rports);
 
-	cfginfo->intr_attr.coalesce = cfgrsp->intr_attr.coalesce;
-	cfginfo->intr_attr.delay    = bfa_os_ntohs(cfgrsp->intr_attr.delay);
-	cfginfo->intr_attr.latency  = bfa_os_ntohs(cfgrsp->intr_attr.latency);
-
 	iocfc->cfgdone = BFA_TRUE;
 
 	/**
@@ -737,10 +740,20 @@ bfa_adapter_get_id(struct bfa_s *bfa)
 void
 bfa_iocfc_get_attr(struct bfa_s *bfa, struct bfa_iocfc_attr_s *attr)
 {
-	struct bfa_iocfc_s	*iocfc = &bfa->iocfc;
+	struct bfa_iocfc_s      *iocfc = &bfa->iocfc;
+
+	attr->intr_attr.coalesce = iocfc->cfginfo->intr_attr.coalesce;
+
+	attr->intr_attr.delay = iocfc->cfginfo->intr_attr.delay ?
+			bfa_os_ntohs(iocfc->cfginfo->intr_attr.delay) :
+			bfa_os_ntohs(iocfc->cfgrsp->intr_attr.delay);
+
+	attr->intr_attr.latency = iocfc->cfginfo->intr_attr.latency ?
+			bfa_os_ntohs(iocfc->cfginfo->intr_attr.latency) :
+			bfa_os_ntohs(iocfc->cfgrsp->intr_attr.latency);
+
+	attr->config    = iocfc->cfg;
 
-	attr->intr_attr = iocfc->cfginfo->intr_attr;
-	attr->config	= iocfc->cfg;
 }
 
 bfa_status_t
@@ -749,7 +762,10 @@ bfa_iocfc_israttr_set(struct bfa_s *bfa, struct bfa_iocfc_intr_attr_s *attr)
 	struct bfa_iocfc_s		*iocfc = &bfa->iocfc;
 	struct bfi_iocfc_set_intr_req_s *m;
 
-	iocfc->cfginfo->intr_attr = *attr;
+	iocfc->cfginfo->intr_attr.coalesce = attr->coalesce;
+	iocfc->cfginfo->intr_attr.delay = bfa_os_htons(attr->delay);
+	iocfc->cfginfo->intr_attr.latency = bfa_os_htons(attr->latency);
+
 	if (!bfa_iocfc_is_operational(bfa))
 		return BFA_STATUS_OK;
 
@@ -759,9 +775,10 @@ bfa_iocfc_israttr_set(struct bfa_s *bfa, struct bfa_iocfc_intr_attr_s *attr)
 
 	bfi_h2i_set(m->mh, BFI_MC_IOCFC, BFI_IOCFC_H2I_SET_INTR_REQ,
 			bfa_lpuid(bfa));
-	m->coalesce = attr->coalesce;
-	m->delay    = bfa_os_htons(attr->delay);
-	m->latency  = bfa_os_htons(attr->latency);
+	m->coalesce = iocfc->cfginfo->intr_attr.coalesce;
+	m->delay    = iocfc->cfginfo->intr_attr.delay;
+	m->latency  = iocfc->cfginfo->intr_attr.latency;
+
 
 	bfa_trc(bfa, attr->delay);
 	bfa_trc(bfa, attr->latency);
-- 
1.6.5.2

