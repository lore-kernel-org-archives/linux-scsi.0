Received: from rcdn-iport-3.cisco.com (rcdn-iport-3.cisco.com [173.37.86.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABF02141B8;
	Wed,  2 Oct 2024 18:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727893875; cv=none; b=XzdgGREOBq8/BdMUrPU0WZZ8rEWfCGRifdF6ehRIfW8yraT2rXVZmXfFzumnnti5Bp+BY/rCCU2cShHOKx6i0SPBjMoFN6KWBW1l2Rdv5RNABzr5H97vIXxYU1Fv2PlIIuBR5DhHvLDATUc3V1x+bxHzvEApDIQ7U1FMDM7UJiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727893875; c=relaxed/simple;
	bh=SUWeRVYtbacFrAICX+DMlELHaUjKH4vcYPQbaVoPTtI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GJGDWexfoj+74iUj0wtFZ902oj9Lep5akpb/kXFQLz2KzMBWJBdQfIRl0nQihxocXUEefRfzrsPQrsJXVmaUQEMPLWBFVX/GWPPGJXtpgEROHVMQTKoQDVJl2J2IzfUQLs3uNASOi4xS0uZks7CidPhR81EaEhuCOnw1DvrmSDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=WuMcaY/2; arc=none smtp.client-ip=173.37.86.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="WuMcaY/2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=179546; q=dns/txt;
  s=iport; t=1727893867; x=1729103467;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rPtznb0G9vM0T4FtiSAo/mO/SnLJaG7TDGj8iFtCTKA=;
  b=WuMcaY/2dnSXp8tunxFyk9aQgMxe5yYYOYgJU3BAmV/s2s6u4vEyXGaG
   /x5FezHgJrCdq5F2ste0aEjADlogu4mcRywwpkEC2p4IokHQXPLUS0U/o
   Gq8IMnnAUFKzIg1Wtv6tLsF7OY7D1UYfx7nt3bU0hMHNhQD+kMmJuoR3o
   w=;
X-CSE-ConnectionGUID: /XovsLRFS1GZnkyvX0g6hw==
X-CSE-MsgGUID: 4xPMjMg0SsecvZzIwlb8Dg==
X-IronPort-AV: E=Sophos;i="6.11,172,1725321600"; 
   d="scan'208";a="269301820"
Received: from rcdn-core-8.cisco.com ([173.37.93.144])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2024 18:31:06 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-8.cisco.com (8.15.2/8.15.2) with ESMTPSA id 492IOHQv009807
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 2 Oct 2024 18:31:05 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v4 12/14] scsi: fnic: Code cleanup
Date: Wed,  2 Oct 2024 11:24:08 -0700
Message-Id: <20241002182410.68093-13-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241002182410.68093-1-kartilak@cisco.com>
References: <20241002182410.68093-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: rcdn-core-8.cisco.com

Replace existing host structure with fnic host.
Add headers from scsi to support new functionality.
Remove unused code and declarations.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
----
Changes between v2 and v3:
    Replace additional fnic->lport->host with fnic->host to prevent
    compilation errors.
---
 drivers/scsi/fnic/fdls_disc.c    | 556 ++++++++++++++++---------------
 drivers/scsi/fnic/fip.c          |  81 +++--
 drivers/scsi/fnic/fnic.h         |  11 +-
 drivers/scsi/fnic/fnic_debugfs.c |   2 +-
 drivers/scsi/fnic/fnic_fcs.c     | 126 +++----
 drivers/scsi/fnic/fnic_isr.c     |  28 +-
 drivers/scsi/fnic/fnic_main.c    |  67 ++--
 drivers/scsi/fnic/fnic_scsi.c    | 235 ++++++-------
 8 files changed, 555 insertions(+), 551 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 0ff4ce683dcb..383f61670ea7 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -345,7 +345,7 @@ uint16_t fdls_alloc_oxid(struct fnic_iport_s *iport,
 	idx = find_next_zero_bit(bitmap, meta->sz, meta->next_idx);
 
 	if (idx == meta->sz) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			"Alloc oxid: all oxid slots are busy iport state:%d\n",
 			iport->state);
 		return 0xFFFF;
@@ -369,7 +369,7 @@ void fdls_free_oxid(struct fnic_iport_s *iport,
 	idx = FDLS_OXID_TO_IDX(meta, oxid);
 
 	if (!test_bit(idx, bitmap)) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "Free oxid: already freed, iport state:%d\n",
 		     iport->state);
 	}
@@ -488,7 +488,7 @@ int fnic_fdls_expected_rsp(struct fnic_iport_s *iport, uint16_t oxid)
 		(oxid != iport->fdmi_oxid_pool.active_oxid_fdmi_plogi) &&
 		(oxid != iport->fdmi_oxid_pool.active_oxid_fdmi_rhba) &&
 		(oxid != iport->fdmi_oxid_pool.active_oxid_fdmi_rpa)) {
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"Received oxid(0x%x) not matching in oxid pool (0x%x) state:%d",
 			oxid, iport->fabric_oxid_pool.active_oxid_fabric_req,
 			iport->fabric.state);
@@ -596,7 +596,7 @@ fdls_start_fabric_timer(struct fnic_iport_s *iport, int timeout)
 	struct fnic *fnic = iport->fnic;
 
 	if (iport->fabric.timer_pending) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "iport fcid: 0x%x: Canceling fabric disc timer\n",
 					 iport->fcid);
 		fnic_del_fabric_timer_sync(fnic);
@@ -609,7 +609,7 @@ fdls_start_fabric_timer(struct fnic_iport_s *iport, int timeout)
 	fabric_tov = jiffies + msecs_to_jiffies(timeout);
 	mod_timer(&iport->fabric.retry_timer, round_jiffies(fabric_tov));
 	iport->fabric.timer_pending = 1;
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "fabric timer is %d ", timeout);
 }
 
@@ -621,7 +621,7 @@ fdls_start_tport_timer(struct fnic_iport_s *iport,
 	struct fnic *fnic = iport->fnic;
 
 	if (tport->timer_pending) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "tport fcid 0x%x: Canceling disc timer\n",
 					 tport->fcid);
 		fnic_del_tport_timer_sync(fnic, tport);
@@ -698,7 +698,7 @@ fdls_send_tport_abts(struct fnic_iport_s *iport,
 
 	tport_abts->fh_ox_id = tport->oxid_used;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FDLS sending tport abts: tport->state: %d ",
 				 tport->state);
 
@@ -766,7 +766,7 @@ static void fdls_send_fabric_abts(struct fnic_iport_s *iport)
 	oxid = iport->fabric_oxid_pool.active_oxid_fabric_req;
 	FNIC_STD_SET_OX_ID(fabric_abts, htons(oxid));
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "FDLS sending fabric abts. iport->fabric.state: %d, oxid:%x",
 		 iport->fabric.state, oxid);
 
@@ -831,13 +831,13 @@ static void fdls_send_fabric_flogi(struct fnic_iport_s *iport)
 	oxid = fdls_alloc_fabric_oxid(iport, &iport->fabric_oxid_pool,
 				  FNIC_FABRIC_FLOGI_RSP);
 	if (oxid == 0xFFFF) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "Failed to allocate OXID to send flogi %p", iport);
 		return;
 	}
 	FNIC_STD_SET_OX_ID(&flogi.fchdr, htons(oxid));
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "0x%x: FDLS send fabric flogi with oxid:%x", iport->fcid,
 		 oxid);
 
@@ -856,6 +856,8 @@ static void fdls_send_fabric_plogi(struct fnic_iport_s *iport)
 	uint16_t oxid;
 
 	memcpy(&plogi, &fnic_std_plogi_req, sizeof(struct fc_std_flogi));
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+				 "0x%x: FDLS send fabric PLOGI", iport->fcid);
 
 	hton24(fcid, iport->fcid);
 
@@ -867,14 +869,14 @@ static void fdls_send_fabric_plogi(struct fnic_iport_s *iport)
 	oxid = fdls_alloc_fabric_oxid(iport, &iport->fabric_oxid_pool,
 				  FNIC_FABRIC_PLOGI_RSP);
 	if (oxid == 0xFFFF) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "Failed to allocate OXID to send fabric plogi %p",
 		     iport);
 		return;
 	}
 	FNIC_STD_SET_OX_ID(fchdr, htons(oxid));
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "0x%x: FDLS send fabric PLOGI with oxid:%x", iport->fcid,
 		 oxid);
 
@@ -898,7 +900,7 @@ static void fdls_send_fdmi_plogi(struct fnic_iport_s *iport)
 	oxid = fdls_alloc_fabric_oxid(iport, &iport->fdmi_oxid_pool,
 				      FNIC_FDMI_PLOGI_RSP);
 	if (oxid == 0xFFFF) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "Failed to allocate OXID to send fdmi plogi %p",
 			     iport);
 		return;
@@ -914,7 +916,7 @@ static void fdls_send_fdmi_plogi(struct fnic_iport_s *iport)
 	FNIC_LOGI_SET_NODE_NAME(&plogi.els, iport->wwnn);
 	FNIC_LOGI_SET_RDF_SIZE(&plogi.els, iport->max_payload_size);
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "fcid: 0x%x: FDLS send FDMI PLOGI with oxid:%x",
 		     iport->fcid, oxid);
 
@@ -933,6 +935,8 @@ static void fdls_send_rpn_id(struct fnic_iport_s *iport)
 	uint16_t oxid;
 
 	memcpy(&rpn_id, &fnic_std_rpn_id_req, sizeof(struct fc_std_rpn_id));
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+				 "0x%x: FDLS send RPN ID", iport->fcid);
 
 	hton24(fcid, iport->fcid);
 
@@ -943,13 +947,13 @@ static void fdls_send_rpn_id(struct fnic_iport_s *iport)
 	oxid = fdls_alloc_fabric_oxid(iport, &iport->fabric_oxid_pool,
 				  FNIC_FABRIC_RPN_RSP);
 	if (oxid == 0xFFFF) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "Failed to allocate OXID to send rpn id %p", iport);
 		return;
 	}
 	FNIC_STD_SET_OX_ID(&rpn_id.fchdr, htons(oxid));
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "0x%x: FDLS send RPN ID with oxid:%x", iport->fcid, oxid);
 
 	fnic_send_fcoe_frame(iport, &rpn_id, sizeof(struct fc_std_rpn_id));
@@ -965,6 +969,8 @@ static void fdls_send_scr(struct fnic_iport_s *iport)
 	uint16_t oxid;
 
 	memcpy(&scr, &fnic_std_scr_req, sizeof(struct fc_std_scr));
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+				 "0x%x: FDLS send SCR", iport->fcid);
 
 	hton24(fcid, iport->fcid);
 	FNIC_STD_SET_S_ID((&scr.fchdr), fcid);
@@ -972,13 +978,13 @@ static void fdls_send_scr(struct fnic_iport_s *iport)
 	oxid = fdls_alloc_fabric_oxid(iport, &iport->fabric_oxid_pool,
 				  FNIC_FABRIC_SCR_RSP);
 	if (oxid == 0xFFFF) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "Failed to allocate OXID to send scr %p", iport);
 		return;
 	}
 	FNIC_STD_SET_OX_ID(&scr.fchdr, htons(oxid));
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "0x%x: FDLS send SCR with oxid:%x", iport->fcid, oxid);
 
 	atomic64_inc(&iport->iport_stats.fabric_scr_sent);
@@ -1002,13 +1008,13 @@ static void fdls_send_gpn_ft(struct fnic_iport_s *iport, int fdls_state)
 	oxid = fdls_alloc_fabric_oxid(iport, &iport->fabric_oxid_pool,
 				  FNIC_FABRIC_GPN_FT_RSP);
 	if (oxid == 0xFFFF) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "Failed to allocate OXID to send GPN FT %p", iport);
 		return;
 	}
 	FNIC_STD_SET_OX_ID(&gpn_ft.fchdr, htons(oxid));
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "0x%x: FDLS send GPN FT with oxid:%x", iport->fcid, oxid);
 
 	fnic_send_fcoe_frame(iport, &gpn_ft, sizeof(struct fc_std_gpn_ft));
@@ -1039,7 +1045,7 @@ fdls_send_tgt_adisc(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 
 	oxid = htons(fdls_alloc_tgt_oxid(iport, &iport->adisc_oxid_pool));
 	if (oxid == 0xFFFF) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Failed to allocate OXID to send ADISC %p", iport);
 		return;
 	}
@@ -1055,7 +1061,7 @@ fdls_send_tgt_adisc(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 	memcpy(adisc.els.adisc_port_id, s_id, 3);
 	adisc.els.adisc_cmd = ELS_ADISC;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "sending ADISC to tgt fcid: 0x%x", tport->fcid);
 
 	atomic64_inc(&iport->iport_stats.tport_adisc_sent);
@@ -1071,7 +1077,7 @@ bool fdls_delete_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 
 	if ((tport->state == FDLS_TGT_STATE_OFFLINING)
 	    || (tport->state == FDLS_TGT_STATE_OFFLINE)) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "tport fcid 0x%x: tport state is offlining/offline\n",
 			     tport->fcid);
 		return false;
@@ -1086,7 +1092,7 @@ bool fdls_delete_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 	tport->flags |= FNIC_FDLS_TPORT_TERMINATING;
 
 	if (tport->timer_pending) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "tport fcid 0x%x: Canceling disc timer\n",
 					 tport->fcid);
 		fnic_del_tport_timer_sync(fnic, tport);
@@ -1102,7 +1108,7 @@ bool fdls_delete_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 			tport_del_evt =
 				kzalloc(sizeof(struct fnic_tport_event_s), GFP_ATOMIC);
 			if (!tport_del_evt) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Failed to allocate memory for tport fcid: 0x%0x\n",
 					 tport->fcid);
 				return false;
@@ -1112,7 +1118,7 @@ bool fdls_delete_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 			list_add_tail(&tport_del_evt->links, &fnic->tport_event_list);
 			queue_work(fnic_event_queue, &fnic->tport_work);
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "tport 0x%x not reg with scsi_transport. Freeing locally",
 				 tport->fcid);
 			list_del(&tport->links);
@@ -1132,7 +1138,7 @@ fdls_send_tgt_plogi(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 	struct fnic *fnic = iport->fnic;
 	uint32_t timeout;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Send tgt PLOGI to fcid: 0x%x", tport->fcid);
 
 	memcpy(&plogi, &fnic_std_plogi_req, sizeof(struct fc_std_flogi));
@@ -1146,13 +1152,13 @@ fdls_send_tgt_plogi(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 
 	oxid = htons(fdls_alloc_tgt_oxid(iport, &iport->plogi_oxid_pool));
 	if (oxid == 0xFFFF) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: Failed to allocate oxid to send PLOGI to fcid: 0x%x",
 				 iport->fcid, tport->fcid);
 		return;
 	}
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "send tgt PLOGI: tgt fcid: 0x%x oxid: 0x%x", tport->fcid,
 				 ntohs(oxid));
 	tport->oxid_used = oxid;
@@ -1180,7 +1186,7 @@ fnic_fc_plogi_rsp_rdf(struct fnic_iport_s *iport,
 	    be16_to_cpu(plogi_rsp->els.fl_cssp[2].cp_rdfs) & FNIC_FC_C3_RDF;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "MFS: b2b_rdf_size: 0x%x spc3_rdf_size: 0x%x",
 			 b2b_rdf_size, spc3_rdf_size);
 
@@ -1204,13 +1210,13 @@ static void fdls_send_register_fc4_types(struct fnic_iport_s *iport)
 	oxid = fdls_alloc_fabric_oxid(iport, &iport->fabric_oxid_pool,
 				  FNIC_FABRIC_RFT_RSP);
 	if (oxid == 0xFFFF) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "Failed to allocate OXID to send RFT %p", iport);
 		return;
 	}
 	FNIC_STD_SET_OX_ID(&rft_id.fchdr, htons(oxid));
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "0x%x: FDLS sending FC4 Typeswith oxid:%x", iport->fcid,
 		 oxid);
 
@@ -1233,6 +1239,8 @@ static void fdls_send_register_fc4_features(struct fnic_iport_s *iport)
 	uint16_t oxid;
 
 	memcpy(&rff_id, &fnic_std_rff_id_req, sizeof(struct fc_std_rff_id));
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+				 "0x%x: FDLS sending FC4 features", iport->fcid);
 
 	hton24(fcid, iport->fcid);
 
@@ -1242,20 +1250,20 @@ static void fdls_send_register_fc4_features(struct fnic_iport_s *iport)
 	oxid = fdls_alloc_fabric_oxid(iport, &iport->fabric_oxid_pool,
 				  FNIC_FABRIC_RFF_RSP);
 	if (oxid == 0xFFFF) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "Failed to allocate OXID to send RFF %p", iport);
 		return;
 	}
 	FNIC_STD_SET_OX_ID(&rff_id.fchdr, htons(oxid));
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "0x%x: FDLS sending FC4 features with %x", iport->fcid,
 		 oxid);
 
 	if (IS_FNIC_FCP_INITIATOR(fnic)) {
 		rff_id.rff_id.fr_type = FC_TYPE_FCP;
 	} else {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "0x%x: Unknown type", iport->fcid);
 	}
 
@@ -1273,16 +1281,16 @@ fdls_send_tgt_prli(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 	struct fnic *fnic = iport->fnic;
 	uint32_t timeout;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FDLS sending PRLI to tgt: 0x%x", tport->fcid);
 
 	oxid = htons(fdls_alloc_tgt_oxid(iport, &iport->prli_oxid_pool));
 	if (oxid == 0xFFFF) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Failed to allocate OXID to send PRLI %p", iport);
 		return;
 	}
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FDLS sending PRLI to tgt: 0x%x OXID: 0x%x", tport->fcid,
 				 ntohs(oxid));
 
@@ -1322,7 +1330,7 @@ void fdls_send_fabric_logo(struct fnic_iport_s *iport)
 	struct fnic *fnic = iport->fnic;
 	uint16_t oxid;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Sending logo to fabric from iport->fcid: 0x%x",
 				 iport->fcid);
 	memcpy(&logo, &fnic_std_logo_req, sizeof(struct fc_std_logo));
@@ -1335,7 +1343,7 @@ void fdls_send_fabric_logo(struct fnic_iport_s *iport)
 	oxid = fdls_alloc_fabric_oxid(iport, &iport->fabric_oxid_pool,
 				  FNIC_FABRIC_LOGO_RSP);
 	if (oxid == 0xFFFF) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "Failed to allocate OXID to send fabric logo %p",
 		     iport);
 		return;
@@ -1350,7 +1358,7 @@ void fdls_send_fabric_logo(struct fnic_iport_s *iport)
 
 	iport->fabric.flags &= ~FNIC_FDLS_FABRIC_ABORT_ISSUED;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "Sending logo to fabric from fcid %x with oxid %x",
 		 iport->fcid, oxid);
 
@@ -1376,7 +1384,7 @@ void fdls_tgt_logout(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 	struct fnic *fnic = iport->fnic;
 	uint16_t oxid;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Sending logo to tport fcid: 0x%x", tport->fcid);
 	memcpy(&logo, &fnic_std_logo_req, sizeof(struct fc_std_logo));
 
@@ -1403,7 +1411,7 @@ static void fdls_tgt_discovery_start(struct fnic_iport_s *iport)
 	u32 old_link_down_cnt = iport->fnic->link_down_cnt;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: Starting FDLS target discovery", iport->fcid);
 
 	list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
@@ -1457,7 +1465,7 @@ static void fdls_target_restart_nexus(struct fnic_tport_s *tport)
 	struct fnic *fnic = iport->fnic;
 	bool retval = true;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "tport fcid: 0x%x state: %d restart_count: %d",
 				 tport->fcid, tport->state, tport->nexus_restart_count);
 
@@ -1467,13 +1475,13 @@ static void fdls_target_restart_nexus(struct fnic_tport_s *tport)
 
 	retval = fdls_delete_tport(iport, tport);
 	if (retval != true) {
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			     "Error deleting tport: 0x%x", fcid);
 		return;
 	}
 
 	if (nexus_restart_count >= FNIC_TPORT_MAX_NEXUS_RESTART) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "Exceeded nexus restart retries tport: 0x%x",
 			     fcid);
 		return;
@@ -1490,7 +1498,7 @@ static void fdls_target_restart_nexus(struct fnic_tport_s *tport)
 	 */
 	new_tport = fdls_create_tport(iport, fcid, wwpn);
 	if (!new_tport) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Error creating new tport: 0x%x", fcid);
 		return;
 	}
@@ -1519,12 +1527,12 @@ static struct fnic_tport_s *fdls_create_tport(struct fnic_iport_s *iport,
 	struct fnic_tport_s *tport;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "FDLS create tport: fcid: 0x%x wwpn: 0x%llx", fcid, wwpn);
 
 	tport = kzalloc(sizeof(struct fnic_tport_s), GFP_ATOMIC);
 	if (!tport) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Memory allocation failure while creating tport: 0x%x\n",
 			 fcid);
 		return NULL;
@@ -1537,12 +1545,12 @@ static struct fnic_tport_s *fdls_create_tport(struct fnic_iport_s *iport,
 	tport->wwpn = wwpn;
 	tport->iport = iport;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Need to setup tport timer callback");
 
 	timer_setup(&tport->retry_timer, fdls_tport_timer_callback, 0);
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Added tport 0x%x", tport->fcid);
 	fdls_set_tport_state(tport, FDLS_TGT_STATE_INIT);
 	list_add_tail(&tport->links, &iport->tport_list);
@@ -1582,7 +1590,7 @@ static void fdls_fdmi_register_hba(struct fnic_iport_s *iport)
 	oxid = fdls_alloc_fabric_oxid(iport, &iport->fdmi_oxid_pool,
 				      FNIC_FDMI_REG_HBA_RSP);
 	if (oxid == 0xFFFF) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "Failed to allocate OXID to send fdmi reg hba %p",
 			     iport);
 		return;
@@ -1637,7 +1645,7 @@ static void fdls_fdmi_register_pa(struct fnic_iport_s *iport)
 	oxid = fdls_alloc_fabric_oxid(iport, &iport->fdmi_oxid_pool,
 				      FNIC_FDMI_RPA_RSP);
 	if (oxid == 0xFFFF) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "Failed to allocate OXID to send fdmi rpa %p",
 			     iport);
 		return;
@@ -1674,10 +1682,10 @@ static void fdls_fdmi_register_pa(struct fnic_iport_s *iport)
 	fdmi_rpa.current_speed = htonl(port_speed_bm);
 	fdmi_rpa.fc4_type[2] = 1;
 	snprintf(fdmi_rpa.os_name, sizeof(fdmi_rpa.os_name) - 1, "host%d",
-		 fnic->lport->host->host_no);
-	sprintf(fc_host_system_hostname(fnic->lport->host), "%s", utsname()->nodename);
+		 fnic->host->host_no);
+	sprintf(fc_host_system_hostname(fnic->host), "%s", utsname()->nodename);
 	snprintf(fdmi_rpa.host_name, sizeof(fdmi_rpa.host_name) - 1, "%s",
-		 fc_host_system_hostname(fnic->lport->host));
+		 fc_host_system_hostname(fnic->host));
 
 	fnic_send_fcoe_frame(iport, &fdmi_rpa, sizeof(struct fc_std_fdmi_rpa));
 	iport->fabric.fdmi_pending |= FDLS_FDMI_RPA_PENDING;
@@ -1691,7 +1699,7 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 	struct fnic *fnic = iport->fnic;
 	unsigned long flags;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "tp: %d fab state: %d fab retry counter: %d max_flogi_retries: %d",
 		 iport->fabric.timer_pending, iport->fabric.state,
 		 iport->fabric.retry_counter, iport->max_flogi_retries);
@@ -1706,7 +1714,7 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 	if (iport->fabric.del_timer_inprogress) {
 		iport->fabric.del_timer_inprogress = 0;
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "fabric_del_timer inprogress(%d). Skip timer cb",
 					 iport->fabric.del_timer_inprogress);
 		return;
@@ -1734,7 +1742,7 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 				iport->fabric.flags &= ~FNIC_FDLS_FABRIC_ABORT_ISSUED;
 				fdls_send_fabric_flogi(iport);
 			} else
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "Exceeded max FLOGI retries");
 		}
 		break;
@@ -1756,7 +1764,7 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 				iport->fabric.flags &= ~FNIC_FDLS_FABRIC_ABORT_ISSUED;
 				fdls_send_fabric_plogi(iport);
 			} else
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "Exceeded max PLOGI retries");
 		}
 		break;
@@ -1787,7 +1795,7 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 		else {
 			/* ABTS has timed out */
 			fdls_schedule_fabric_oxid_free(iport);
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "ABTS timed out. Starting PLOGI: %p", iport);
 			fnic_fdls_start_plogi(iport);
 		}
@@ -1804,7 +1812,7 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 		} else {
 			/* ABTS has timed out */
 			fdls_schedule_fabric_oxid_free(iport);
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				"ABTS timed out. Starting PLOGI: %p", iport);
 			fnic_fdls_start_plogi(iport);	/* go back to fabric Plogi */
 		}
@@ -1821,7 +1829,7 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 		else {
 			/* ABTS has timed out */
 			fdls_schedule_fabric_oxid_free(iport);
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				"ABTS timed out. Starting PLOGI %p", iport);
 			fnic_fdls_start_plogi(iport);	/* go back to fabric Plogi */
 		}
@@ -1843,7 +1851,7 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 			if (iport->fabric.retry_counter < FDLS_RETRY_COUNT) {
 				fdls_send_gpn_ft(iport, iport->fabric.state);
 			} else {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "ABTS timeout for fabric GPN_FT. Check name server: %p",
 					 iport);
 			}
@@ -1885,7 +1893,7 @@ void fdls_fdmi_timer_callback(struct timer_list *t)
 	/* If max retries not exhaused, start over from fdmi plogi */
 	if (iport->fabric.fdmi_retry < FDLS_FDMI_MAX_RETRY) {
 		iport->fabric.fdmi_retry++;
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "retry fdmi timer %d", iport->fabric.fdmi_retry);
 		fdls_send_fdmi_plogi(iport);
 	}
@@ -1903,7 +1911,7 @@ static void fdls_send_delete_tport_msg(struct fnic_tport_s *tport)
 
 	tport_del_evt = kzalloc(sizeof(struct fnic_tport_event_s), GFP_ATOMIC);
 	if (!tport_del_evt) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Failed to allocate memory for tport event fcid: 0x%x",
 			 tport->fcid);
 		return;
@@ -1936,13 +1944,13 @@ static void fdls_tport_timer_callback(struct timer_list *t)
 	if (tport->del_timer_inprogress) {
 		tport->del_timer_inprogress = 0;
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "tport_del_timer inprogress. Skip timer cb tport fcid: 0x%x\n",
 			 tport->fcid);
 		return;
 	}
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "tport fcid: 0x%x timer pending: %d state: %d retry counter: %d",
 		 tport->fcid, tport->timer_pending, tport->state,
 		 tport->retry_counter);
@@ -2013,14 +2021,14 @@ static void fdls_tport_timer_callback(struct timer_list *t)
 			fdls_schedule_tgt_oxid_free(iport,
 						    &iport->adisc_oxid_pool,
 						    oxid);
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "ADISC not responding. Deleting target port: 0x%x",
 					 tport->fcid);
 			fdls_send_delete_tport_msg(tport);
 		}
 		break;
 	default:
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Unknown tport state: 0x%x", tport->state);
 		break;
 	}
@@ -2071,26 +2079,26 @@ fdls_process_tgt_adisc_rsp(struct fnic_iport_s *iport,
 	tport = fnic_find_tport_by_fcid(iport, tgt_fcid);
 
 	if (!tport) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Tgt ADISC response tport not found: 0x%x", tgt_fcid);
 		return;
 	}
 	if ((iport->state != FNIC_IPORT_STATE_READY)
 		|| (tport->state != FDLS_TGT_STATE_ADISC)
 		|| (tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Dropping this ADISC response");
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "iport state: %d tport state: %d Is abort issued on PRLI? %d",
 			 iport->state, tport->state,
 			 (tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED));
 		return;
 	}
 	if (ntohs(fchdr->fh_ox_id) != ntohs(tport->oxid_used)) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Dropping frame from target: 0x%x",
 			 tgt_fcid);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Reason: Stale ADISC/Aborted ADISC/OOO frame delivery");
 		return;
 	}
@@ -2102,7 +2110,7 @@ fdls_process_tgt_adisc_rsp(struct fnic_iport_s *iport,
 	case ELS_LS_ACC:
 		atomic64_inc(&iport->iport_stats.tport_adisc_ls_accepts);
 		if (tport->timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "tport 0x%p Canceling fabric disc timer\n",
 						 tport);
 			fnic_del_tport_timer_sync(fnic, tport);
@@ -2112,12 +2120,12 @@ fdls_process_tgt_adisc_rsp(struct fnic_iport_s *iport,
 		frame_wwnn = get_unaligned_be64(&adisc_rsp->els.adisc_wwnn);
 		frame_wwpn = get_unaligned_be64(&adisc_rsp->els.adisc_wwpn);
 		if ((frame_wwnn == tport->wwnn) && (frame_wwpn == tport->wwpn)) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "ADISC accepted from target: 0x%x. Target logged in",
 				 tgt_fcid);
 			fdls_set_tport_state(tport, FDLS_TGT_STATE_READY);
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Error mismatch frame: ADISC");
 		}
 		break;
@@ -2127,14 +2135,14 @@ fdls_process_tgt_adisc_rsp(struct fnic_iport_s *iport,
 		if (((els_rjt->u.rej.er_reason == ELS_RJT_BUSY)
 		     || (els_rjt->u.rej.er_reason == ELS_RJT_UNAB))
 			&& (tport->retry_counter < FDLS_RETRY_COUNT)) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "ADISC ret ELS_LS_RJT BUSY. Retry from timer routine: 0x%x",
 				 tgt_fcid);
 
 			/* Retry ADISC again from the timer routine. */
 			tport->flags |= FNIC_FDLS_RETRY_FRAME;
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "ADISC returned ELS_LS_RJT from target: 0x%x",
 						 tgt_fcid);
 			fdls_delete_tport(iport, tport);
@@ -2160,33 +2168,33 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
 	fcid = FNIC_STD_GET_S_ID(fchdr);
 	tgt_fcid = ntoh24(fcid);
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FDLS processing target PLOGI response: tgt_fcid: 0x%x",
 				 tgt_fcid);
 
 	tport = fnic_find_tport_by_fcid(iport, tgt_fcid);
 	if (!tport) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "tport not found: 0x%x", tgt_fcid);
 		return;
 	}
 	if ((iport->state != FNIC_IPORT_STATE_READY)
 		|| (tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Dropping frame! iport state: %d tport state: %d",
 					 iport->state, tport->state);
 		return;
 	}
 
 	if (tport->state != FDLS_TGT_STATE_PLOGI) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "PLOGI rsp recvd in wrong state. Drop the frame and restart nexus");
 		fdls_target_restart_nexus(tport);
 		return;
 	}
 
 	if (fchdr->fh_ox_id != tport->oxid_used) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "PLOGI response from target: 0x%x. Dropping frame",
 			 tgt_fcid);
 		return;
@@ -2198,7 +2206,7 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
 	switch (plogi_rsp->els.fl_cmd) {
 	case ELS_LS_ACC:
 		atomic64_inc(&iport->iport_stats.tport_plogi_ls_accepts);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "PLOGI accepted by target: 0x%x", tgt_fcid);
 		break;
 
@@ -2207,14 +2215,14 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
 		if (((els_rjt->u.rej.er_reason == ELS_RJT_BUSY)
 		     || (els_rjt->u.rej.er_reason == ELS_RJT_UNAB))
 			&& (tport->retry_counter < iport->max_plogi_retries)) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "PLOGI ret ELS_LS_RJT BUSY. Retry from timer routine: 0x%x",
 				 tgt_fcid);
 			/* Retry plogi again from the timer routine. */
 			tport->flags |= FNIC_FDLS_RETRY_FRAME;
 			return;
 		}
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "PLOGI returned ELS_LS_RJT from target: 0x%x",
 					 tgt_fcid);
 		fdls_delete_tport(iport, tport);
@@ -2222,18 +2230,18 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
 
 	default:
 		atomic64_inc(&iport->iport_stats.tport_plogi_misc_rejects);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "PLOGI not accepted from target fcid: 0x%x",
 					 tgt_fcid);
 		return;
 	}
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Found the PLOGI target: 0x%x and state: %d",
 				 (unsigned int) tgt_fcid, tport->state);
 
 	if (tport->timer_pending) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "tport fcid 0x%x: Canceling disc timer\n",
 					 tport->fcid);
 		fnic_del_tport_timer_sync(fnic, tport);
@@ -2251,13 +2259,13 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
 		MIN(max_payload_size, iport->max_payload_size);
 
 	if (tport->max_payload_size < FNIC_MIN_DATA_FIELD_SIZE) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "MFS: tport max frame size below spec bounds: %d",
 			 tport->max_payload_size);
 		tport->max_payload_size = FNIC_MIN_DATA_FIELD_SIZE;
 	}
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "MAX frame size: %d iport max_payload_size: %d tport mfs: %d",
 		 max_payload_size, iport->max_payload_size,
 		 tport->max_payload_size);
@@ -2286,12 +2294,12 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 	fcid = FNIC_STD_GET_S_ID(fchdr);
 	tgt_fcid = ntoh24(fcid);
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FDLS process tgt PRLI response: 0x%x", tgt_fcid);
 
 	tport = fnic_find_tport_by_fcid(iport, tgt_fcid);
 	if (!tport) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "tport not found: 0x%x", tgt_fcid);
 		/* Handle or just drop? */
 		return;
@@ -2299,24 +2307,24 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 
 	if ((iport->state != FNIC_IPORT_STATE_READY)
 		|| (tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Dropping frame! iport st: %d tport st: %d tport fcid: 0x%x",
 			 iport->state, tport->state, tport->fcid);
 		return;
 	}
 
 	if (tport->state != FDLS_TGT_STATE_PRLI) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "PRLI rsp recvd in wrong state. Drop frame. Restarting nexus");
 		fdls_target_restart_nexus(tport);
 		return;
 	}
 
 	if (fchdr->fh_ox_id != tport->oxid_used) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Dropping PRLI response from target: 0x%x ",
 			 tgt_fcid);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Reason: Stale PRLI response/Aborted PDISC/OOO frame delivery");
 		return;
 	}
@@ -2327,11 +2335,11 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 	switch (prli_rsp->els_prli.prli_cmd) {
 	case ELS_LS_ACC:
 		atomic64_inc(&iport->iport_stats.tport_prli_ls_accepts);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "PRLI accepted from target: 0x%x", tgt_fcid);
 
 		if (prli_rsp->sp.spp_type != FC_FC4_TYPE_SCSI) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "mismatched target zoned with FC SCSI initiator: 0x%x",
 				 tgt_fcid);
 			mismatched_tgt = true;
@@ -2348,7 +2356,7 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 		     || (els_rjt->u.rej.er_reason == ELS_RJT_UNAB))
 			&& (tport->retry_counter < FDLS_RETRY_COUNT)) {
 
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "PRLI ret ELS_LS_RJT BUSY. Retry from timer routine: 0x%x",
 				 tgt_fcid);
 
@@ -2356,7 +2364,7 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 			tport->flags |= FNIC_FDLS_RETRY_FRAME;
 			return;
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "PRLI returned ELS_LS_RJT from target: 0x%x",
 						 tgt_fcid);
 
@@ -2368,18 +2376,18 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 
 	default:
 		atomic64_inc(&iport->iport_stats.tport_prli_misc_rejects);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "PRLI not accepted from target: 0x%x", tgt_fcid);
 		return;
 		break;
 	}
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Found the PRLI target: 0x%x and state: %d",
 				 (unsigned int) tgt_fcid, tport->state);
 
 	if (tport->timer_pending) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "tport fcid 0x%x: Canceling disc timer\n",
 					 tport->fcid);
 		fnic_del_tport_timer_sync(fnic, tport);
@@ -2395,7 +2403,7 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 
 	/* Check if the device plays Target Mode Function */
 	if (!(tport->fcp_csp & FCP_PRLI_FUNC_TARGET)) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Remote port(0x%x): no target support. Deleting it\n",
 			 tgt_fcid);
 		fdls_tgt_logout(iport, tport);
@@ -2408,14 +2416,14 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 	/* Inform the driver about new target added */
 	tport_add_evt = kzalloc(sizeof(struct fnic_tport_event_s), GFP_ATOMIC);
 	if (!tport_add_evt) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "tport event memory allocation failure: 0x%0x\n",
 				 tport->fcid);
 		return;
 	}
 	tport_add_evt->event = TGT_EV_RPORT_ADD;
 	tport_add_evt->arg1 = (void *) tport;
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "iport fcid: 0x%x add tport event fcid: 0x%x\n",
 			 tport->fcid, iport->fcid);
 	list_add_tail(&tport_add_evt->links, &fnic->tport_event_list);
@@ -2434,14 +2442,14 @@ fdls_process_rff_id_rsp(struct fnic_iport_s *iport,
 	uint8_t reason_code;
 
 	if (fdls_get_state(fdls) != FDLS_STATE_REGISTER_FC4_FEATURES) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "RFF_ID resp recvd in state(%d). Dropping.",
 					 fdls_get_state(fdls));
 		return;
 	}
 
 	rsp = FNIC_STD_GET_FC_CT_CMD((&rff_rsp->fc_std_ct_hdr));
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS process RFF ID response: 0x%04x", iport->fcid,
 				 (uint32_t) rsp);
 
@@ -2451,7 +2459,7 @@ fdls_process_rff_id_rsp(struct fnic_iport_s *iport,
 	switch (rsp) {
 	case FC_FS_ACC:
 		if (iport->fabric.timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Canceling fabric disc timer %p\n", iport);
 			fnic_del_fabric_timer_sync(fnic);
 		}
@@ -2465,18 +2473,18 @@ fdls_process_rff_id_rsp(struct fnic_iport_s *iport,
 		if (((reason_code == FC_FS_RJT_BSY)
 			|| (reason_code == FC_FS_RJT_UNABL))
 			&& (fdls->retry_counter < FDLS_RETRY_COUNT)) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "RFF_ID ret ELS_LS_RJT BUSY. Retry from timer routine %p",
 					 iport);
 
 			/* Retry again from the timer routine */
 			fdls->flags |= FNIC_FDLS_RETRY_FRAME;
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "RFF_ID returned ELS_LS_RJT. Halting discovery %p",
 			 iport);
 			if (iport->fabric.timer_pending) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "Canceling fabric disc timer %p\n", iport);
 				fnic_del_fabric_timer_sync(fnic);
 			}
@@ -2500,14 +2508,14 @@ fdls_process_rft_id_rsp(struct fnic_iport_s *iport,
 	struct fnic *fnic = iport->fnic;
 
 	if (fdls_get_state(fdls) != FDLS_STATE_REGISTER_FC4_TYPES) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "RFT_ID resp recvd in state(%d). Dropping.",
 					 fdls_get_state(fdls));
 		return;
 	}
 
 	rsp = FNIC_STD_GET_FC_CT_CMD((&rft_rsp->fc_std_ct_hdr));
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS process RFT ID response: 0x%04x", iport->fcid,
 				 (uint32_t) rsp);
 
@@ -2517,7 +2525,7 @@ fdls_process_rft_id_rsp(struct fnic_iport_s *iport,
 	switch (rsp) {
 	case FC_FS_ACC:
 		if (iport->fabric.timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Canceling fabric disc timer %p\n", iport);
 			fnic_del_fabric_timer_sync(fnic);
 		}
@@ -2531,19 +2539,19 @@ fdls_process_rft_id_rsp(struct fnic_iport_s *iport,
 		if (((reason_code == FC_FS_RJT_BSY)
 			|| (reason_code == FC_FS_RJT_UNABL))
 			&& (fdls->retry_counter < FDLS_RETRY_COUNT)) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: RFT_ID ret ELS_LS_RJT BUSY. Retry from timer routine",
 				 iport->fcid);
 
 			/* Retry again from the timer routine */
 			fdls->flags |= FNIC_FDLS_RETRY_FRAME;
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: RFT_ID REJ. Halting discovery reason %d expl %d",
 				 iport->fcid, reason_code,
 			 rft_rsp->fc_std_ct_hdr.ct_explan);
 			if (iport->fabric.timer_pending) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "Canceling fabric disc timer %p\n", iport);
 				fnic_del_fabric_timer_sync(fnic);
 			}
@@ -2567,14 +2575,14 @@ fdls_process_rpn_id_rsp(struct fnic_iport_s *iport,
 	struct fnic *fnic = iport->fnic;
 
 	if (fdls_get_state(fdls) != FDLS_STATE_RPN_ID) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "RPN_ID resp recvd in state(%d). Dropping.",
 					 fdls_get_state(fdls));
 		return;
 	}
 
 	rsp = FNIC_STD_GET_FC_CT_CMD((&rpn_rsp->fc_std_ct_hdr));
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS process RPN ID response: 0x%04x", iport->fcid,
 				 (uint32_t) rsp);
 
@@ -2584,7 +2592,7 @@ fdls_process_rpn_id_rsp(struct fnic_iport_s *iport,
 	switch (rsp) {
 	case FC_FS_ACC:
 		if (iport->fabric.timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Canceling fabric disc timer %p\n", iport);
 			fnic_del_fabric_timer_sync(fnic);
 		}
@@ -2598,17 +2606,17 @@ fdls_process_rpn_id_rsp(struct fnic_iport_s *iport,
 		if (((reason_code == FC_FS_RJT_BSY)
 			|| (reason_code == FC_FS_RJT_UNABL))
 			&& (fdls->retry_counter < FDLS_RETRY_COUNT)) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "RPN_ID returned REJ BUSY. Retry from timer routine %p",
 					 iport);
 
 			/* Retry again from the timer routine */
 			fdls->flags |= FNIC_FDLS_RETRY_FRAME;
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "RPN_ID ELS_LS_RJT. Halting discovery %p", iport);
 			if (iport->fabric.timer_pending) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "Canceling fabric disc timer %p\n", iport);
 				fnic_del_fabric_timer_sync(fnic);
 			}
@@ -2630,12 +2638,12 @@ fdls_process_scr_rsp(struct fnic_iport_s *iport,
 	struct fc_std_els_rsp *els_rjt = (struct fc_std_els_rsp *) fchdr;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FDLS process SCR response: 0x%04x",
 		 (uint32_t) scr_rsp->scr.scr_cmd);
 
 	if (fdls_get_state(fdls) != FDLS_STATE_SCR) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "SCR resp recvd in state(%d). Dropping.",
 					 fdls_get_state(fdls));
 		return;
@@ -2648,7 +2656,7 @@ fdls_process_scr_rsp(struct fnic_iport_s *iport,
 	case ELS_LS_ACC:
 		atomic64_inc(&iport->iport_stats.fabric_scr_ls_accepts);
 		if (iport->fabric.timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Canceling fabric disc timer %p\n", iport);
 			fnic_del_fabric_timer_sync(fnic);
 		}
@@ -2662,17 +2670,17 @@ fdls_process_scr_rsp(struct fnic_iport_s *iport,
 		if (((els_rjt->u.rej.er_reason == ELS_RJT_BUSY)
 	     || (els_rjt->u.rej.er_reason == ELS_RJT_UNAB))
 			&& (fdls->retry_counter < FDLS_RETRY_COUNT)) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "SCR ELS_LS_RJT BUSY. Retry from timer routine %p",
 						 iport);
 			/* Retry again from the timer routine */
 			fdls->flags |= FNIC_FDLS_RETRY_FRAME;
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "SCR returned ELS_LS_RJT. Halting discovery %p",
 						 iport);
 			if (iport->fabric.timer_pending) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					     "Canceling fabric disc timer %p\n",
 					     iport);
 				fnic_del_fabric_timer_sync(fnic);
@@ -2700,7 +2708,7 @@ fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *iport,
 	u32 old_link_down_cnt = iport->fnic->link_down_cnt;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS process GPN_FT tgt list", iport->fcid);
 
 	gpn_ft_tgt =
@@ -2714,7 +2722,7 @@ fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *iport,
 		fcid = ntoh24(gpn_ft_tgt->fcid);
 		wwpn = ntohll(gpn_ft_tgt->wwpn);
 
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "tport: 0x%x: ctrl:0x%x", fcid, gpn_ft_tgt->ctrl);
 
 		if (fcid == iport->fcid) {
@@ -2761,7 +2769,7 @@ fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *iport,
 		rem_len -= sizeof(struct fc_gpn_ft_rsp_iu);
 	}
 	if (rem_len <= 0) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "GPN_FT response: malformed/corrupt frame rxlen: %d remlen: %d",
 			 len, rem_len);
 	}
@@ -2771,7 +2779,7 @@ fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *iport,
 		list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
 
 			if (!(tport->flags & FNIC_FDLS_TPORT_IN_GPN_FT_LIST)) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Remove port: 0x%x not found in GPN_FT list",
 					 tport->fcid);
 				fdls_delete_tport(iport, tport);
@@ -2799,7 +2807,7 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
 	u32 old_link_down_cnt = iport->fnic->link_down_cnt;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FDLS process GPN_FT response: iport state: %d len: %d",
 				 iport->state, len);
 
@@ -2819,7 +2827,7 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
 			  && ((fdls_get_state(fdls) == FDLS_STATE_RSCN_GPN_FT)
 				  || (fdls_get_state(fdls) == FDLS_STATE_SEND_GPNFT)
 				  || (fdls_get_state(fdls) == FDLS_STATE_TGT_DISCOVERY))))) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "GPNFT resp recvd in fab state(%d) iport_state(%d). Dropping.",
 			 fdls_get_state(fdls), iport->state);
 		return;
@@ -2834,10 +2842,10 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
 	switch (rsp) {
 
 	case FC_FS_ACC:
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "0x%x: GPNFT_RSP accept", iport->fcid);
 		if (iport->fabric.timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "0x%x: Canceling fabric disc timer\n",
 						 iport->fcid);
 			fnic_del_fabric_timer_sync(fnic);
@@ -2852,7 +2860,7 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
 		 * that will be taken care in next link up event
 		 */
 		if (iport->state != FNIC_IPORT_STATE_READY) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Halting target discovery: fab st: %d iport st: %d ",
 				 fdls_get_state(fdls), iport->state);
 			break;
@@ -2862,22 +2870,22 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
 
 	case FC_FS_RJT:
 		reason_code = gpn_ft_rsp->fc_std_ct_hdr.ct_reason;
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "0x%x: GPNFT_RSP Reject reason: %d", iport->fcid, reason_code);
 
 		if (((reason_code == FC_FS_RJT_BSY)
 		     || (reason_code == FC_FS_RJT_UNABL))
 			&& (fdls->retry_counter < FDLS_RETRY_COUNT)) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: GPNFT_RSP ret REJ/BSY. Retry from timer routine",
 				 iport->fcid);
 			/* Retry again from the timer routine */
 			fdls->flags |= FNIC_FDLS_RETRY_FRAME;
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "0x%x: GPNFT_RSP reject", iport->fcid);
 			if (iport->fabric.timer_pending) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "0x%x: Canceling fabric disc timer\n",
 							 iport->fcid);
 				fnic_del_fabric_timer_sync(fnic);
@@ -2891,7 +2899,7 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
 			count = 0;
 			list_for_each_entry_safe(tport, next, &iport->tport_list,
 									 links) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "GPN_FT_REJECT: Remove port: 0x%x",
 							 tport->fcid);
 				fdls_delete_tport(iport, tport);
@@ -2901,7 +2909,7 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
 				}
 				count++;
 			}
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "GPN_FT_REJECT: Removed (0x%x) ports", count);
 		}
 		break;
@@ -2929,7 +2937,7 @@ fdls_process_fabric_logo_rsp(struct fnic_iport_s *iport,
 	switch (flogo_rsp->els.fl_cmd) {
 	case ELS_LS_ACC:
 		if (iport->fabric.state != FDLS_STATE_FABRIC_LOGO) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Flogo response. Fabric not in LOGO state. Dropping! %p",
 				 iport);
 			return;
@@ -2939,25 +2947,25 @@ fdls_process_fabric_logo_rsp(struct fnic_iport_s *iport,
 		iport->state = FNIC_IPORT_STATE_LINK_WAIT;
 
 		if (iport->fabric.timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "iport 0x%p Canceling fabric disc timer\n",
 						 iport);
 			fnic_del_fabric_timer_sync(fnic);
 		}
 		iport->fabric.timer_pending = 0;
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Flogo response from Fabric for did: 0x%x",
 		     ntoh24(fchdr->fh_d_id));
 		return;
 
 	case ELS_LS_RJT:
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Flogo response from Fabric for did: 0x%x returned ELS_LS_RJT",
 		     ntoh24(fchdr->fh_d_id));
 		return;
 
 	default:
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "FLOGO response not accepted or rejected: 0x%x",
 		     flogo_rsp->els.fl_cmd);
 	}
@@ -2974,11 +2982,11 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 	uint8_t fcmac[6] = { 0x0E, 0XFC, 0x00, 0x00, 0x00, 0x00 };
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS processing FLOGI response", iport->fcid);
 
 	if (fdls_get_state(fabric) != FDLS_STATE_FABRIC_FLOGI) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "FLOGI response received in state (%d). Dropping frame",
 					 fdls_get_state(fabric));
 		return;
@@ -2991,7 +2999,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 	case ELS_LS_ACC:
 		atomic64_inc(&iport->iport_stats.fabric_flogi_ls_accepts);
 		if (iport->fabric.timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "iport fcid: 0x%x Canceling fabric disc timer\n",
 						 iport->fcid);
 			fnic_del_fabric_timer_sync(fnic);
@@ -3001,7 +3009,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 		iport->fabric.retry_counter = 0;
 		fcid = FNIC_STD_GET_D_ID(fchdr);
 		iport->fcid = ntoh24(fcid);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "0x%x: FLOGI response accepted", iport->fcid);
 
 		/* Learn the Service Params */
@@ -3011,7 +3019,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 			iport->max_payload_size = MIN(rdf_size,
 								  iport->max_payload_size);
 
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "max_payload_size from fabric: %d set: %d", rdf_size,
 					 iport->max_payload_size);
 
@@ -3021,26 +3029,26 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 		if (FNIC_LOGI_FEATURES(&flogi_rsp->els) & FNIC_FC_EDTOV_NSEC)
 			iport->e_d_tov = iport->e_d_tov / FNIC_NSEC_TO_MSEC;
 
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "From fabric: R_A_TOV: %d E_D_TOV: %d",
 					 iport->r_a_tov, iport->e_d_tov);
 
 		if (IS_FNIC_FCP_INITIATOR(fnic)) {
-			fc_host_fabric_name(iport->fnic->lport->host) =
+			fc_host_fabric_name(iport->fnic->host) =
 			get_unaligned_be64(&FNIC_LOGI_NODE_NAME(&flogi_rsp->els));
-			fc_host_port_id(iport->fnic->lport->host) = iport->fcid;
+			fc_host_port_id(iport->fnic->host) = iport->fcid;
 		}
 
 		fnic_fdls_learn_fcoe_macs(iport, rx_frame, fcid);
 
 		if (fnic_fdls_register_portid(iport, iport->fcid, rx_frame) != 0) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "0x%x: FLOGI registration failed", iport->fcid);
 			break;
 		}
 
 		memcpy(&fcmac[3], fcid, 3);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Adding vNIC device MAC addr: %02x:%02x:%02x:%02x:%02x:%02x",
 			 fcmac[0], fcmac[1], fcmac[2], fcmac[3], fcmac[4],
 			 fcmac[5]);
@@ -3048,7 +3056,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 
 		if (fdls_get_state(fabric) == FDLS_STATE_FABRIC_FLOGI) {
 			fnic_fdls_start_plogi(iport);
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "FLOGI response received. Starting PLOGI");
 		} else {
 			/* From FDLS_STATE_FABRIC_FLOGI state fabric can only go to
@@ -3056,7 +3064,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 			 * state, hence we don't have to worry about undoing:
 			 * the fnic_fdls_register_portid and vnic_dev_add_addr
 			 */
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FLOGI response received in state (%d). Dropping frame",
 				 fdls_get_state(fabric));
 		}
@@ -3065,7 +3073,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 	case ELS_LS_RJT:
 		atomic64_inc(&iport->iport_stats.fabric_flogi_ls_rejects);
 		if (fabric->retry_counter < iport->max_flogi_retries) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FLOGI returned ELS_LS_RJT BUSY. Retry from timer routine %p",
 				 iport);
 
@@ -3073,11 +3081,11 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 			fabric->flags |= FNIC_FDLS_RETRY_FRAME;
 
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "FLOGI returned ELS_LS_RJT. Halting discovery %p",
 			 iport);
 			if (iport->fabric.timer_pending) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "iport 0x%p Canceling fabric disc timer\n",
 							 iport);
 				fnic_del_fabric_timer_sync(fnic);
@@ -3088,7 +3096,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 		break;
 
 	default:
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "FLOGI response not accepted: 0x%x",
 		     flogi_rsp->els.fl_cmd);
 		atomic64_inc(&iport->iport_stats.fabric_flogi_misc_rejects);
@@ -3105,7 +3113,7 @@ fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 	struct fnic *fnic = iport->fnic;
 
 	if (fdls_get_state((&iport->fabric)) != FDLS_STATE_FABRIC_PLOGI) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Fabric PLOGI response received in state (%d). Dropping frame",
 			 fdls_get_state(&iport->fabric));
 		return;
@@ -3118,7 +3126,7 @@ fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 	case ELS_LS_ACC:
 		atomic64_inc(&iport->iport_stats.fabric_plogi_ls_accepts);
 		if (iport->fabric.timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "iport fcid: 0x%x fabric PLOGI response: Accepted\n",
 				 iport->fcid);
 			fnic_del_fabric_timer_sync(fnic);
@@ -3133,15 +3141,15 @@ fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 		if (((els_rjt->u.rej.er_reason == ELS_RJT_BUSY)
 	     || (els_rjt->u.rej.er_reason == ELS_RJT_UNAB))
 			&& (iport->fabric.retry_counter < iport->max_plogi_retries)) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: Fabric PLOGI ELS_LS_RJT BUSY. Retry from timer routine",
 				 iport->fcid);
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: Fabric PLOGI ELS_LS_RJT. Halting discovery",
 				 iport->fcid);
 			if (iport->fabric.timer_pending) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "iport fcid: 0x%x Canceling fabric disc timer\n",
 							 iport->fcid);
 				fnic_del_fabric_timer_sync(fnic);
@@ -3152,7 +3160,7 @@ fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 		}
 		break;
 	default:
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "PLOGI response not accepted: 0x%x",
 		     plogi_rsp->els.fl_cmd);
 		atomic64_inc(&iport->iport_stats.fabric_plogi_misc_rejects);
@@ -3177,9 +3185,9 @@ static void fdls_process_fdmi_plogi_rsp(struct fnic_iport_s *iport,
 		iport->fabric.fdmi_pending = 0;
 		switch (plogi_rsp->els.fl_cmd) {
 		case ELS_LS_ACC:
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FDLS process fdmi PLOGI response status: ELS_LS_ACC\n");
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Sending fdmi registration for port 0x%x\n",
 				 iport->fcid);
 
@@ -3190,7 +3198,7 @@ static void fdls_process_fdmi_plogi_rsp(struct fnic_iport_s *iport,
 				  round_jiffies(fdmi_tov));
 			break;
 		case ELS_LS_RJT:
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Fabric FDMI PLOGI returned ELS_LS_RJT reason: 0x%x",
 				     els_rjt->u.rej.er_reason);
 
@@ -3214,7 +3222,7 @@ static void fdls_process_fdmi_reg_ack(struct fnic_iport_s *iport,
 	struct fnic *fnic = iport->fnic;
 
 	if (!iport->fabric.fdmi_pending) {
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			     "Received FDMI ack while not waiting:%x\n",
 			     ntohs(FNIC_STD_GET_OX_ID(fchdr)));
 		return;
@@ -3228,13 +3236,13 @@ static void fdls_process_fdmi_reg_ack(struct fnic_iport_s *iport,
 	fdls_free_fabric_oxid(iport, &iport->fdmi_oxid_pool,
 			      ntohs(FNIC_STD_GET_OX_ID(fchdr)));
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		"iport fcid: 0x%x: Received FDMI registration ack\n",
 		 iport->fcid);
 
 	if (!iport->fabric.fdmi_pending) {
 		del_timer_sync(&iport->fabric.fdmi_timer);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "iport fcid: 0x%x: Canceling FDMI timer\n",
 					 iport->fcid);
 	}
@@ -3249,7 +3257,7 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
 	s_id = ntoh24(FNIC_STD_GET_S_ID(fchdr));
 
 	if (!(s_id != 0xFFFFFA)) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "Received abts rsp with invalid SID: 0x%x. Dropping frame",
 			     s_id);
 		return;
@@ -3280,14 +3288,14 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 
 	if (!((s_id == FC_DIR_SERVER) || (s_id == FC_DOMAIN_CONTR)
 		  || (s_id == FC_FABRIC_CONTROLLER))) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Received abts rsp with invalid SID: 0x%x. Dropping frame",
 			 s_id);
 		return;
 	}
 
 	if (iport->fabric.timer_pending) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Canceling fabric disc timer %p\n", iport);
 		fnic_del_fabric_timer_sync(fnic);
 	}
@@ -3295,11 +3303,11 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 	iport->fabric.flags &= ~FNIC_FDLS_FABRIC_ABORT_ISSUED;
 
 	if (fchdr->fh_r_ctl == FNIC_BA_ACC_RCTL) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Received abts rsp BA_ACC for fabric_state: %d OX_ID: 0x%x",
 		     fabric_state, be16_to_cpu(ba_acc->acc.ba_ox_id));
 	} else if (fchdr->fh_r_ctl == FNIC_BA_RJT_RCTL) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "BA_RJT fs: %d OX_ID: 0x%x rc: 0x%x rce: 0x%x",
 		     fabric_state, be16_to_cpu(ba_rjt->fchdr.fh_ox_id),
 		     ba_rjt->rjt.br_reason, ba_rjt->rjt.br_explan);
@@ -3316,10 +3324,10 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 			if (iport->fabric.retry_counter < iport->max_flogi_retries)
 				fdls_send_fabric_flogi(iport);
 			else
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Exceeded max FLOGI retries");
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Unknown abts rsp OX_ID: 0x%x FABRIC_FLOGI state. Drop frame",
 			 fchdr->fh_ox_id);
 		}
@@ -3329,7 +3337,7 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 			if (!RETRIES_EXHAUSTED(iport))
 				fdls_send_fabric_logo(iport);
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Unknown abts rsp OX_ID: 0x%x FABRIC_FLOGI state. Drop frame",
 			 fchdr->fh_ox_id);
 		}
@@ -3339,10 +3347,10 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 			if (iport->fabric.retry_counter < iport->max_plogi_retries)
 				fdls_send_fabric_plogi(iport);
 			else
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Exceeded max PLOGI retries");
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Unknown abts rsp OX_ID: 0x%x FABRIC_PLOGI state. Drop frame",
 			 fchdr->fh_ox_id);
 		}
@@ -3357,7 +3365,7 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 				fnic_fdls_start_plogi(iport);
 			}
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Unknown abts rsp OX_ID: 0x%x RPN_ID state. Drop frame",
 			 fchdr->fh_ox_id);
 		}
@@ -3368,13 +3376,13 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 			if (iport->fabric.retry_counter <= FDLS_RETRY_COUNT)
 				fdls_send_scr(iport);
 			else {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "abts rsp fab SCR after two tries. Start fabric PLOGI %p",
 					 iport);
 				fnic_fdls_start_plogi(iport);	/* go back to fabric Plogi */
 			}
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Unknown abts rsp OX_ID: 0x%x SCR state. Drop frame",
 			 fchdr->fh_ox_id);
 		}
@@ -3384,13 +3392,13 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 			if (iport->fabric.retry_counter <= FDLS_RETRY_COUNT) {
 				fdls_send_register_fc4_types(iport);
 			} else {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "abts rsp fab RFT_ID two tries. Start fabric PLOGI %p",
 					 iport);
 				fnic_fdls_start_plogi(iport);	/* go back to fabric Plogi */
 			}
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Unknown abts rsp OX_ID: 0x%x RFT state. Drop frame",
 			 fchdr->fh_ox_id);
 		}
@@ -3400,13 +3408,13 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 			if (iport->fabric.retry_counter <= FDLS_RETRY_COUNT)
 				fdls_send_register_fc4_features(iport);
 			else {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "abts rsp fab SCR after two tries. Start fabric PLOGI %p",
 					 iport);
 				fnic_fdls_start_plogi(iport);	/* go back to fabric Plogi */
 			}
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Unknown abts rsp OX_ID: 0x%x RFF state. Drop frame",
 			 fchdr->fh_ox_id);
 		}
@@ -3417,12 +3425,12 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 			if (iport->fabric.retry_counter <= FDLS_RETRY_COUNT) {
 				fdls_send_gpn_ft(iport, fabric_state);
 			} else {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "abts rsp fab GPN_FT after two tries %p",
 					 iport);
 			}
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Unknown abts rsp OX_ID: 0x%x GPN_FT state. Drop frame",
 			 fchdr->fh_ox_id);
 		}
@@ -3444,7 +3452,7 @@ fdls_process_abts_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
 	struct fnic_tgt_oxid_pool_s *oxid_pool;
 
 	nport_id = ntoh24(fchdr->fh_s_id);
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Received abort from SID %8x", nport_id);
 
 	tport = fnic_find_tport_by_fcid(iport, nport_id);
@@ -3481,7 +3489,7 @@ fdls_process_unsupported_els_req(struct fnic_iport_s *iport,
 	memcpy(&ls_rsp, &fnic_std_els_rjt, FC_ELS_RSP_REJ_SIZE);
 
 	if (iport->fcid != d_id) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Dropping unsupported ELS with illegal frame bits 0x%x\n",
 			 d_id);
 		atomic64_inc(&iport->iport_stats.unsupported_frames_dropped);
@@ -3490,14 +3498,14 @@ fdls_process_unsupported_els_req(struct fnic_iport_s *iport,
 
 	if ((iport->state != FNIC_IPORT_STATE_READY)
 		&& (iport->state != FNIC_IPORT_STATE_FABRIC_DISC)) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Dropping unsupported ELS request in iport state: %d",
 			 iport->state);
 		atomic64_inc(&iport->iport_stats.unsupported_frames_dropped);
 		return;
 	}
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Process unsupported ELS request from SID: 0x%x",
 		     ntoh24(fchdr->fh_s_id));
 	/* We don't support this ELS request, send a reject */
@@ -3522,12 +3530,12 @@ fdls_process_rls_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
 	uint16_t oxid;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Process RLS request %d", iport->fnic->fnic_num);
 
 	if ((iport->state != FNIC_IPORT_STATE_READY)
 		&& (iport->state != FNIC_IPORT_STATE_FABRIC_DISC)) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Received RLS req in iport state: %d. Dropping the frame.",
 			 iport->state);
 		return;
@@ -3568,32 +3576,32 @@ fdls_process_els_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr,
 
 	if ((iport->state != FNIC_IPORT_STATE_READY)
 		&& (iport->state != FNIC_IPORT_STATE_FABRIC_DISC)) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Dropping ELS frame type :%x in iport state: %d",
 				 type, iport->state);
 		return;
 	}
 	switch (type) {
 	case ELS_ECHO:
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "sending LS_ACC for ECHO request %d\n",
 					 iport->fnic->fnic_num);
 		break;
 
 	case ELS_RRQ:
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "sending LS_ACC for RRQ request %d\n",
 					 iport->fnic->fnic_num);
 		break;
 
 	default:
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "sending LS_ACC for %x ELS frame\n", type);
 		break;
 	}
 	dst_frame = kzalloc(len, GFP_ATOMIC);
 	if (!dst_frame) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Failed to allocate ELS response for %x", type);
 		return;
 	}
@@ -3639,18 +3647,18 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 
 	tport = fnic_find_tport_by_fcid(iport, s_id);
 	if (!tport) {
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					 "Received tgt abts rsp with invalid SID: 0x%x", s_id);
 		return;
 	}
 
 	if (tport->timer_pending) {
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					 "tport 0x%p Canceling fabric disc timer\n", tport);
 		fnic_del_tport_timer_sync(fnic, tport);
 	}
 	if (iport->state != FNIC_IPORT_STATE_READY) {
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					 "Received tgt abts rsp in iport state(%d). Dropping.",
 					 iport->state);
 		return;
@@ -3663,15 +3671,15 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 	/*This abort rsp is for ADISC */
 	if ((oxid >= FDLS_ADISC_OXID_BASE) && (oxid < FDLS_TGT_OXID_POOL_END)) {
 		if (fchdr->fh_r_ctl == FNIC_BA_ACC_RCTL) {
-			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				     "OX_ID: 0x%x tgt_fcid: 0x%x rcvd tgt adisc abts resp BA_ACC",
 				     be16_to_cpu(ba_acc->acc.ba_ox_id),
 				     tport->fcid);
 		} else if (fchdr->fh_r_ctl == FNIC_BA_RJT_RCTL) {
-			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				 "ADISC BA_RJT rcvd tport_fcid: 0x%x tport_state: %d ",
 				 tport->fcid, tport_state);
-			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				 "reason code: 0x%x reason code explanation:0x%x ",
 				     ba_rjt->rjt.br_reason,
 				     ba_rjt->rjt.br_explan);
@@ -3685,7 +3693,7 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 		}
 
 		fdls_free_tgt_oxid(iport, &iport->adisc_oxid_pool, oxid);
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					 "ADISC not responding. Deleting target port: 0x%x",
 					 tport->fcid);
 		fdls_delete_tport(iport, tport);
@@ -3701,14 +3709,14 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 	/*This abort rsp is for PLOGI */
 	if ((oxid >= FDLS_PLOGI_OXID_BASE) && (oxid < FDLS_PRLI_OXID_BASE)) {
 		if (fchdr->fh_r_ctl == FNIC_BA_ACC_RCTL) {
-			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				 "Received tgt PLOGI abts response BA_ACC tgt_fcid: 0x%x",
 				 tport->fcid);
 		} else if (fchdr->fh_r_ctl == FNIC_BA_RJT_RCTL) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "PLOGI BA_RJT received for tport_fcid: 0x%x OX_ID: 0x%x",
 				     tport->fcid, fchdr->fh_ox_id);
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "reason code: 0x%x reason code explanation: 0x%x",
 				     ba_rjt->rjt.br_reason,
 				     ba_rjt->rjt.br_explan);
@@ -3735,14 +3743,14 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 	/*This abort rsp is for PRLI */
 	if ((oxid >= FDLS_PRLI_OXID_BASE) && (oxid < FDLS_ADISC_OXID_BASE)) {
 		if (fchdr->fh_r_ctl == FNIC_BA_ACC_RCTL) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: Received tgt PRLI abts response BA_ACC",
 				 tport->fcid);
 		} else if (fchdr->fh_r_ctl == FNIC_BA_RJT_RCTL) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "PRLI BA_RJT received for tport_fcid: 0x%x OX_ID: 0x%x ",
 				     tport->fcid, fchdr->fh_ox_id);
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "reason code: 0x%x reason code explanation: 0x%x",
 				     ba_rjt->rjt.br_reason,
 				     ba_rjt->rjt.br_explan);
@@ -3759,7 +3767,7 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 		return;
 	}
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Received ABTS response for unknown frame %p", iport);
 }
 
@@ -3775,19 +3783,19 @@ fdls_process_plogi_req(struct fnic_iport_s *iport,
 	memcpy(&plogi_rsp, &fnic_std_els_rjt, sizeof(struct fc_std_els_rsp));
 
 	if (iport->fcid != d_id) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Received PLOGI with illegal frame bits. Dropping frame %p",
 			 iport);
 		return;
 	}
 
 	if (iport->state != FNIC_IPORT_STATE_READY) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Received PLOGI request in iport state: %d Dropping frame",
 			 iport->state);
 		return;
 	}
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Process PLOGI request from SID: 0x%x",
 		     ntoh24(fchdr->fh_s_id));
 
@@ -3820,11 +3828,11 @@ fdls_process_logo_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
 	nport_id = ntoh24(logo->els.fl_n_port_id);
 	nport_name = logo->els.fl_n_port_wwn;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Process LOGO request from fcid: 0x%x", nport_id);
 
 	if (iport->state != FNIC_IPORT_STATE_READY) {
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			 "Dropping LOGO req from 0x%x in iport state: %d",
 			 nport_id, iport->state);
 		return;
@@ -3834,19 +3842,19 @@ fdls_process_logo_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
 
 	if (!tport) {
 		/* We are not logged in with the nport, log and drop... */
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			 "Received LOGO from an nport not logged in: 0x%x(0x%llx)",
 			 nport_id, nport_name);
 		return;
 	}
 	if (tport->fcid != nport_id) {
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 		 "Received LOGO with invalid target port fcid: 0x%x(0x%llx)",
 		 nport_id, nport_name);
 		return;
 	}
 	if (tport->timer_pending) {
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					 "tport fcid 0x%x: Canceling disc timer\n",
 					 tport->fcid);
 		fnic_del_tport_timer_sync(fnic, tport);
@@ -3863,7 +3871,7 @@ fdls_process_logo_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
 		if ((iport->state == FNIC_IPORT_STATE_READY)
 			&& (fdls_get_state(&iport->fabric) != FDLS_STATE_SEND_GPNFT)
 			&& (fdls_get_state(&iport->fabric) != FDLS_STATE_RSCN_GPN_FT)) {
-			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 						 "Sending GPNFT in response to LOGO from Target:0x%x",
 						 nport_id);
 			fdls_send_gpn_ft(iport, FDLS_STATE_SEND_GPNFT);
@@ -3876,7 +3884,7 @@ fdls_process_logo_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
 		fdls_send_logo_resp(iport, &logo->fchdr);
 		if ((fdls_get_state(&iport->fabric) != FDLS_STATE_SEND_GPNFT) &&
 			(fdls_get_state(&iport->fabric) != FDLS_STATE_RSCN_GPN_FT)) {
-			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 						 "Sending GPNFT in response to LOGO from Target:0x%x",
 						 nport_id);
 			fdls_send_gpn_ft(iport, FDLS_STATE_SEND_GPNFT);
@@ -3900,11 +3908,11 @@ fdls_process_rscn(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
 
 	atomic64_inc(&iport->iport_stats.num_rscns);
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FDLS process RSCN %p", iport);
 
 	if (iport->state != FNIC_IPORT_STATE_READY) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "FDLS RSCN received in state(%d). Dropping",
 					 fdls_get_state(fdls));
 		return;
@@ -3918,21 +3926,21 @@ fdls_process_rscn(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
 	    || (rscn_payload_len > 1024)
 	    || (rscn->els.rscn_page_len != 4)) {
 		num_ports = 0;
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "RSCN payload_len: 0x%x page_len: 0x%x",
 				     rscn_payload_len, rscn->els.rscn_page_len);
 		/* if this happens then we need to send ADISC to all the tports. */
 		list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
 			if (tport->state == FDLS_TGT_STATE_READY)
 				tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "RSCN for port id: 0x%x", tport->fcid);
 		}
 	} else {
 		num_ports = (rscn_payload_len - 4) / rscn->els.rscn_page_len;
 		rscn_port = (struct fc_els_rscn_page *)(rscn + 1);
 	}
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "RSCN received for num_ports: %d payload_len: %d page_len: %d ",
 		     num_ports, rscn_payload_len, rscn->els.rscn_page_len);
 
@@ -3956,14 +3964,14 @@ fdls_process_rscn(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
 				if (tport->state == FDLS_TGT_STATE_READY)
 					tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
 
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "RSCN for port id: 0x%x", tport->fcid);
 			}
 			break;
 		}
 		tport = fnic_find_tport_by_fcid(iport, nport_id);
 
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "RSCN port id list: 0x%x", nport_id);
 
 		if (!tport) {
@@ -3974,7 +3982,7 @@ fdls_process_rscn(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
 			tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
 	}
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "FDLS process RSCN sending GPN_FT: newports: %d", newports);
 	fdls_send_gpn_ft(iport, FDLS_STATE_RSCN_GPN_FT);
 	fdls_send_rscn_resp(iport, fchdr);
@@ -3985,8 +3993,8 @@ void fnic_fdls_disc_start(struct fnic_iport_s *iport)
 	struct fnic *fnic = iport->fnic;
 
 	if (IS_FNIC_FCP_INITIATOR(fnic)) {
-		fc_host_fabric_name(iport->fnic->lport->host) = 0;
-		fc_host_post_event(iport->fnic->lport->host, fc_get_event_number(),
+		fc_host_fabric_name(iport->fnic->host) = 0;
+		fc_host_post_event(iport->fnic->host, fc_get_event_number(),
 						   FCH_EVT_LIPRESET, 0);
 	}
 
@@ -4018,20 +4026,20 @@ fdls_process_adisc_req(struct fnic_iport_s *iport,
 	uint16_t oxid;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Process ADISC request %d", iport->fnic->fnic_num);
 
 	fcid = FNIC_STD_GET_S_ID(fchdr);
 	tgt_fcid = ntoh24(fcid);
 	tport = fnic_find_tport_by_fcid(iport, tgt_fcid);
 	if (!tport) {
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					 "tport for fcid: 0x%x not found. Dropping ADISC req.",
 					 tgt_fcid);
 		return;
 	}
 	if (iport->state != FNIC_IPORT_STATE_READY) {
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			 "Dropping ADISC req from fcid: 0x%x in iport state: %d",
 			 tgt_fcid, iport->state);
 		return;
@@ -4042,10 +4050,10 @@ fdls_process_adisc_req(struct fnic_iport_s *iport,
 
 	if ((frame_wwnn != tport->wwnn) || (frame_wwpn != tport->wwpn)) {
 		/* send reject */
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			 "ADISC req from fcid: 0x%x mismatch wwpn: 0x%llx wwnn: 0x%llx",
 			 tgt_fcid, frame_wwpn, frame_wwnn);
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			 "local tport wwpn: 0x%llx wwnn: 0x%llx. Sending RJT",
 			 tport->wwpn, tport->wwnn);
 
@@ -4115,7 +4123,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 	if (iport->fcid)
 		if (fdls_get_state(fabric) > FDLS_STATE_FABRIC_FLOGI) {
 			if ((iport->fcid != d_id) || (!FNIC_FC_FRAME_CS_CTL(fchdr))) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "invalid frame received. Dropping frame");
 				return -1;
 			}
@@ -4125,7 +4133,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 	if ((fchdr->fh_r_ctl == FNIC_BA_ACC_RCTL)
 	|| (fchdr->fh_r_ctl == FNIC_BA_RJT_RCTL)) {
 		if (!(FNIC_FC_FRAME_TYPE_BLS(fchdr))) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Received ABTS invalid frame. Dropping frame");
 			return -1;
 
@@ -4134,7 +4142,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 	}
 	if ((fchdr->fh_r_ctl == FC_ABTS_RCTL)
 	&& (FNIC_FC_FRAME_TYPE_BLS(fchdr))) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Receiving Abort Request from s_id: 0x%x", s_id);
 		return FNIC_BLS_ABTS_REQ;
 	}
@@ -4146,7 +4154,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 			if ((!FNIC_FC_FRAME_FCTL_FIRST_LAST_SEQINIT(fchdr))
 				|| (!FNIC_FC_FRAME_UNSOLICITED(fchdr))
 				|| (!FNIC_FC_FRAME_TYPE_ELS(fchdr))) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "Received LOGO invalid frame. Dropping frame");
 				return -1;
 			}
@@ -4155,12 +4163,12 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 			if ((!FNIC_FC_FRAME_FCTL_FIRST_LAST_SEQINIT(fchdr))
 				|| (!FNIC_FC_FRAME_TYPE_ELS(fchdr))
 				|| (!FNIC_FC_FRAME_UNSOLICITED(fchdr))) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Received RSCN invalid FCTL. Dropping frame");
 				return -1;
 			}
 			if (s_id != FC_FABRIC_CONTROLLER)
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				     "Received RSCN from target FCTL: 0x%x type: 0x%x s_id: 0x%x.",
 				     fchdr->fh_f_ctl[0], fchdr->fh_type, s_id);
 			return FNIC_ELS_RSCN_REQ;
@@ -4175,7 +4183,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 		case ELS_RRQ:
 			return FNIC_ELS_RRQ;
 		default:
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Unsupported frame (type:0x%02x) from fcid: 0x%x",
 				 type, s_id);
 			return FNIC_ELS_UNSUPPORTED_REQ;
@@ -4186,7 +4194,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 	if ((ntohs(oxid) >= FDLS_PLOGI_OXID_BASE)
 		&& (ntohs(oxid) < FDLS_PRLI_OXID_BASE)) {
 		if (!FNIC_FC_FRAME_TYPE_ELS(fchdr)) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				"Dropping Unknown frame in PLOGI exchange range type: 0x%x.",
 				     fchdr->fh_type);
 			return -1;
@@ -4196,7 +4204,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 	if ((ntohs(oxid) >= FDLS_PRLI_OXID_BASE)
 		&& (ntohs(oxid) < FDLS_ADISC_OXID_BASE)) {
 		if (!FNIC_FC_FRAME_TYPE_ELS(fchdr)) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				"Dropping Unknown frame in PRLI exchange range type: 0x%x.",
 				     fchdr->fh_type);
 			return -1;
@@ -4207,7 +4215,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 	if ((ntohs(oxid) >= FDLS_ADISC_OXID_BASE)
 		&& (ntohs(oxid) < FDLS_TGT_OXID_POOL_END)) {
 		if (!FNIC_FC_FRAME_TYPE_ELS(fchdr)) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				"Dropping Unknown frame in ADISC exchange range type: 0x%x.",
 				     fchdr->fh_type);
 			return -1;
@@ -4224,7 +4232,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 		if (type == ELS_LS_ACC) {
 			if ((s_id != FC_DOMAIN_CONTR)
 				|| (!FNIC_FC_FRAME_TYPE_ELS(fchdr))) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Received unknown frame. Dropping frame");
 				return -1;
 			}
@@ -4235,7 +4243,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 		if (type == ELS_LS_ACC) {
 			if ((s_id != FC_DIR_SERVER)
 				|| (!FNIC_FC_FRAME_TYPE_ELS(fchdr))) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Received unknown frame. Dropping frame");
 				return -1;
 			}
@@ -4246,7 +4254,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 		if (type == ELS_LS_ACC) {
 			if ((s_id != FC_FABRIC_CONTROLLER)
 				|| (!FNIC_FC_FRAME_TYPE_ELS(fchdr))) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Received unknown frame. Dropping frame");
 				return -1;
 			}
@@ -4255,7 +4263,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 
 	case FNIC_FABRIC_RPN_RSP:
 		if ((s_id != FC_DIR_SERVER) || (!FNIC_FC_FRAME_TYPE_FC_GS(fchdr))) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Received unknown frame. Dropping frame");
 			return -1;
 		}
@@ -4263,7 +4271,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 
 	case FNIC_FABRIC_RFT_RSP:
 		if ((s_id != FC_DIR_SERVER) || (!FNIC_FC_FRAME_TYPE_FC_GS(fchdr))) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Received unknown frame. Dropping frame");
 			return -1;
 		}
@@ -4271,7 +4279,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 
 	case FNIC_FABRIC_RFF_RSP:
 		if ((s_id != FC_DIR_SERVER) || (!FNIC_FC_FRAME_TYPE_FC_GS(fchdr))) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Received unknown frame. Dropping frame");
 			return -1;
 		}
@@ -4279,7 +4287,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 
 	case FNIC_FABRIC_GPN_FT_RSP:
 		if ((s_id != FC_DIR_SERVER) || (!FNIC_FC_FRAME_TYPE_FC_GS(fchdr))) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Received unknown frame. Dropping frame");
 			return -1;
 		}
@@ -4292,7 +4300,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 	break;
 	default:
 		/* Drop the Rx frame and log/stats it */
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Solicited response: unknown OXID: 0x%x", oxid);
 		return -1;
 	}
@@ -4360,7 +4368,7 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 		break;
 	case FNIC_TPORT_LOGO_RSP:
 		/* Logo response from tgt which we have deleted */
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Logo response from tgt: 0x%x",
 			     ntoh24(fchdr->fh_s_id));
 		break;
@@ -4410,9 +4418,9 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 		fdls_process_fdmi_reg_ack(iport, fchdr, frame_type);
 		break;
 	default:
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "s_id: 0x%x d_did: 0x%x", s_id, d_id);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Received unknown FCoE frame of len: %d. Dropping frame", len);
 		break;
 	}
@@ -4430,7 +4438,7 @@ void fnic_fdls_link_down(struct fnic_iport_s *iport)
 	struct fnic_tport_s *tport, *next;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS processing link down", iport->fcid);
 
 	fdls_set_state((&iport->fabric), FDLS_STATE_LINKDOWN);
@@ -4443,7 +4451,7 @@ void fnic_fdls_link_down(struct fnic_iport_s *iport)
 		fdls_init_oxid_pool(iport);
 
 		list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "removing rport: 0x%x", tport->fcid);
 			fdls_delete_tport(iport, tport);
 		}
@@ -4454,7 +4462,7 @@ void fnic_fdls_link_down(struct fnic_iport_s *iport)
 		iport->fabric.fdmi_pending = 0;
 	}
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS finish processing link down", iport->fcid);
 }
 
diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
index 1a12266845da..3d1175cc244e 100644
--- a/drivers/scsi/fnic/fip.c
+++ b/drivers/scsi/fnic/fip.c
@@ -29,7 +29,7 @@ void fnic_fcoe_reset_vlans(struct fnic *fnic)
 	}
 
 	spin_unlock_irqrestore(&fnic->vlans_lock, flags);
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "Reset vlan complete\n");
 }
 
@@ -46,17 +46,17 @@ void fnic_fcoe_send_vlan_req(struct fnic *fnic)
 	int fr_len;
 	struct fip_vlan_req_s vlan_req;
 
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "Enter send vlan req\n");
 	fnic_fcoe_reset_vlans(fnic);
 
 	fnic->set_vlan(fnic, 0);
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "set vlan done\n");
 
 	fr_len = sizeof(struct fip_vlan_req_s);
 
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "got MAC 0x%x:%x:%x:%x:%x:%x\n", iport->hwmac[0],
 		     iport->hwmac[1], iport->hwmac[2], iport->hwmac[3],
 		     iport->hwmac[4], iport->hwmac[5]);
@@ -70,12 +70,12 @@ void fnic_fcoe_send_vlan_req(struct fnic *fnic)
 	iport->fip.state = FDLS_FIP_VLAN_DISCOVERY_STARTED;
 
 	fnic_send_fip_frame(iport, &vlan_req, fr_len);
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "vlan req sent\n");
 
 	vlan_tov = jiffies + msecs_to_jiffies(FCOE_CTLR_FIPVLAN_TOV);
 	mod_timer(&fnic->retry_fip_timer, round_jiffies(vlan_tov));
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "fip timer set\n");
 }
 
@@ -99,13 +99,12 @@ void fnic_fcoe_process_vlan_resp(struct fnic *fnic, struct fip_header_s *fiph)
 	struct fip_vlan_desc_s *vlan_desc;
 	unsigned long flags;
 
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "fnic 0x%p got vlan resp\n", fnic);
 
 	desc_len = ntohs(vlan_notif->fip.desc_len);
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "desc_len %d\n", desc_len);
-
 	spin_lock_irqsave(&fnic->vlans_lock, flags);
 
 	cur_desc = 0;
@@ -116,22 +115,21 @@ void fnic_fcoe_process_vlan_resp(struct fnic *fnic, struct fip_header_s *fiph)
 
 		if (vlan_desc->type == FIP_TYPE_VLAN) {
 			if (vlan_desc->len != 1) {
-				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host,
+				FNIC_FIP_DBG(KERN_INFO, fnic->host,
 					     fnic->fnic_num,
 					     "Invalid descriptor length(%x) in VLan response\n",
 					     vlan_desc->len);
-
 			}
 			num_vlan++;
 			vid = ntohs(vlan_desc->vlan);
-			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host,
+			FNIC_FIP_DBG(KERN_INFO, fnic->host,
 				     fnic->fnic_num,
 				     "process_vlan_resp: FIP VLAN %d\n", vid);
 			vlan = kzalloc(sizeof(*vlan), GFP_KERNEL);
 
 			if (!vlan) {
 				/* retry from timer */
-				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host,
+				FNIC_FIP_DBG(KERN_INFO, fnic->host,
 					     fnic->fnic_num,
 					     "Mem Alloc failure\n");
 				spin_unlock_irqrestore(&fnic->vlans_lock,
@@ -143,7 +141,7 @@ void fnic_fcoe_process_vlan_resp(struct fnic *fnic, struct fip_header_s *fiph)
 			list_add_tail(&vlan->list, &fnic->vlan_list);
 			break;
 		} else {
-			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host,
+			FNIC_FIP_DBG(KERN_INFO, fnic->host,
 				     fnic->fnic_num,
 				     "Invalid descriptor type(%x) in VLan response\n",
 				     vlan_desc->type);
@@ -159,7 +157,7 @@ void fnic_fcoe_process_vlan_resp(struct fnic *fnic, struct fip_header_s *fiph)
 	/* any VLAN descriptors present ? */
 	if (num_vlan == 0) {
 		atomic64_inc(&fnic_stats->vlan_stats.resp_withno_vlanID);
-		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "fnic 0x%p No VLAN descriptors in FIP VLAN response\n",
 			     fnic);
 	}
@@ -182,7 +180,7 @@ void fnic_fcoe_start_fcf_discovery(struct fnic *fnic)
 	int fr_len;
 	struct fip_discovery_s disc_sol;
 
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "fnic 0x%p start fcf discovery\n", fnic);
 	fr_len = sizeof(struct fip_discovery_s);
 	memset(iport->selected_fcf.fcf_mac, 0, ETH_ALEN);
@@ -200,9 +198,8 @@ void fnic_fcoe_start_fcf_discovery(struct fnic *fnic)
 	fcs_tov = jiffies + msecs_to_jiffies(FCOE_CTLR_FCS_TOV);
 	mod_timer(&fnic->retry_fip_timer, round_jiffies(fcs_tov));
 
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "fnic 0x%p Started FCF discovery", fnic);
-
 }
 
 /**
@@ -230,7 +227,7 @@ void fnic_fcoe_fip_discovery_resp(struct fnic *fnic, struct fip_header_s *fiph)
 	switch (iport->fip.state) {
 	case FDLS_FIP_FCF_DISCOVERY_STARTED:
 		if (ntohs(disc_adv->fip.flags) & FIP_FLAG_S) {
-			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host,
+			FNIC_FIP_DBG(KERN_INFO, fnic->host,
 				     fnic->fnic_num,
 				     "fnic 0x%p Solicited adv\n", fnic);
 
@@ -238,7 +235,7 @@ void fnic_fcoe_fip_discovery_resp(struct fnic *fnic, struct fip_header_s *fiph)
 			     iport->selected_fcf.fcf_priority)
 			    && (ntohs(disc_adv->fip.flags) & FIP_FLAG_A)) {
 
-				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host,
+				FNIC_FIP_DBG(KERN_INFO, fnic->host,
 					     fnic->fnic_num,
 					     "fnic 0x%p FCF Available\n", fnic);
 				memcpy(iport->selected_fcf.fcf_mac,
@@ -247,7 +244,7 @@ void fnic_fcoe_fip_discovery_resp(struct fnic *fnic, struct fip_header_s *fiph)
 				    disc_adv->prio_desc.priority;
 				iport->selected_fcf.fka_adv_period =
 				    ntohl(disc_adv->fka_adv_desc.fka_adv);
-				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host,
+				FNIC_FIP_DBG(KERN_INFO, fnic->host,
 					     fnic->fnic_num, "adv time %d",
 					     iport->selected_fcf.fka_adv_period);
 				iport->selected_fcf.ka_disabled =
@@ -267,7 +264,7 @@ void fnic_fcoe_fip_discovery_resp(struct fnic *fnic, struct fip_header_s *fiph)
 					iport->selected_fcf.fka_adv_period =
 					    ntohl(disc_adv->fka_adv_desc.fka_adv);
 					FNIC_FIP_DBG(KERN_INFO,
-						     fnic->lport->host,
+						     fnic->host,
 						     fnic->fnic_num,
 						     "change fka to %d",
 						     iport->selected_fcf.fka_adv_period);
@@ -335,7 +332,7 @@ void fnic_fcoe_start_flogi(struct fnic *fnic)
 	struct fc_frame_header *fchdr = &flogi_req.flogi_desc.flogi.fchdr;
 
 	fr_len = sizeof(struct fip_flogi_s);
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "fnic 0x%p Start fip FLOGI\n", fnic);
 
 	memcpy(&flogi_req, &fip_flogi_tmpl, fr_len);
@@ -380,11 +377,11 @@ void fnic_fcoe_process_flogi_resp(struct fnic *fnic, struct fip_header_s *fiph)
 	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	struct fc_frame_header *fchdr = &flogi_rsp->rsp_desc.flogi.fchdr;
 
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "fnic 0x%p FIP FLOGI rsp\n", fnic);
 	desc_len = ntohs(flogi_rsp->fip.desc_len);
 	if (desc_len != 38) {
-		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "Invalid Descriptor List len (%x). Dropping frame\n",
 			     desc_len);
 		return;
@@ -394,7 +391,7 @@ void fnic_fcoe_process_flogi_resp(struct fnic *fnic, struct fip_header_s *fiph)
 	      && (flogi_rsp->rsp_desc.len == 36))
 	    || !((flogi_rsp->mac_desc.type == 2)
 		 && (flogi_rsp->mac_desc.len == 2))) {
-		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "Dropping frame invalid type and len mix\n");
 		return;
 	}
@@ -407,7 +404,7 @@ void fnic_fcoe_process_flogi_resp(struct fnic *fnic, struct fip_header_s *fiph)
 	    || (s_id != 0xFFFFFE)
 	    || (exp_rsp_type != FNIC_FABRIC_FLOGI_RSP)
 	    || (fchdr->fh_type != 0x01)) {
-		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "Dropping invalid frame: s_id %x F %x R %x t %x OX_ID %x\n",
 			     s_id, fchdr->fh_f_ctl[0], fchdr->fh_r_ctl,
 			     fchdr->fh_type, fchdr->fh_ox_id);
@@ -415,7 +412,7 @@ void fnic_fcoe_process_flogi_resp(struct fnic *fnic, struct fip_header_s *fiph)
 	}
 
 	if (iport->fip.state == FDLS_FIP_FLOGI_STARTED) {
-		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "fnic 0x%p rsp for pending FLOGI\n", fnic);
 
 		del_timer_sync(&fnic->retry_fip_timer);
@@ -423,7 +420,7 @@ void fnic_fcoe_process_flogi_resp(struct fnic *fnic, struct fip_header_s *fiph)
 		if ((ntohs(flogi_rsp->fip.desc_len) == 38)
 		    && (flogi_rsp->rsp_desc.flogi.els.fl_cmd == ELS_LS_ACC)) {
 
-			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host,
+			FNIC_FIP_DBG(KERN_INFO, fnic->host,
 				     fnic->fnic_num,
 				     "fnic 0x%p FLOGI success\n", fnic);
 			memcpy(iport->fpma, flogi_rsp->mac_desc.mac, ETH_ALEN);
@@ -440,7 +437,7 @@ void fnic_fcoe_process_flogi_resp(struct fnic *fnic, struct fip_header_s *fiph)
 
 			if (fnic_fdls_register_portid(iport, iport->fcid, NULL)
 			    != 0) {
-				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host,
+				FNIC_FIP_DBG(KERN_INFO, fnic->host,
 					     fnic->fnic_num,
 					     "fnic 0x%p flogi registration failed\n",
 					     fnic);
@@ -449,7 +446,7 @@ void fnic_fcoe_process_flogi_resp(struct fnic *fnic, struct fip_header_s *fiph)
 
 			iport->fip.state = FDLS_FIP_FLOGI_COMPLETE;
 			iport->state = FNIC_IPORT_STATE_FABRIC_DISC;
-			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host,
+			FNIC_FIP_DBG(KERN_INFO, fnic->host,
 				     fnic->fnic_num, "iport->state:%d\n",
 				     iport->state);
 			fnic_fdls_disc_start(iport);
@@ -496,7 +493,7 @@ void fnic_common_fip_cleanup(struct fnic *fnic)
 
 	if (!iport->usefip)
 		return;
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "fnic 0x%p fip cleanup\n", fnic);
 
 	iport->fip.state = FDLS_FIP_INIT;
@@ -538,7 +535,7 @@ void fnic_fcoe_process_cvl(struct fnic *fnic, struct fip_header_s *fiph)
 	int found = false;
 	int max_count = 0;
 
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "fnic 0x%p clear virtual link handler\n", fnic);
 
 	if (!((cvl_msg->fcf_mac_desc.type == 2)
@@ -546,7 +543,7 @@ void fnic_fcoe_process_cvl(struct fnic *fnic, struct fip_header_s *fiph)
 	    || !((cvl_msg->name_desc.type == 4)
 		 && (cvl_msg->name_desc.len == 3))) {
 
-		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "invalid mix: ft %x fl %x ndt %x ndl %x",
 			     cvl_msg->fcf_mac_desc.type,
 			     cvl_msg->fcf_mac_desc.len, cvl_msg->name_desc.type,
@@ -560,7 +557,7 @@ void fnic_fcoe_process_cvl(struct fnic *fnic, struct fip_header_s *fiph)
 			if (!((cvl_msg->vn_ports_desc[i].type == 11)
 			      && (cvl_msg->vn_ports_desc[i].len == 5))) {
 
-				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host,
+				FNIC_FIP_DBG(KERN_INFO, fnic->host,
 					     fnic->fnic_num,
 					     "Invalid type and len mix type: %d len: %d\n",
 					     cvl_msg->vn_ports_desc[i].type,
@@ -584,12 +581,12 @@ void fnic_fcoe_process_cvl(struct fnic *fnic, struct fip_header_s *fiph)
 			spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 			max_count++;
 			if (max_count >= FIP_FNIC_RESET_WAIT_COUNT) {
-				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Rthr waited too long. Skipping handle link event %p\n",
 					 fnic);
 				return;
 			}
-			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "fnic reset in progress. Link event needs to wait %p",
 				 fnic);
 		}
@@ -638,7 +635,7 @@ void fnic_work_on_fip_timer(struct work_struct *work)
 	struct fnic *fnic = container_of(work, struct fnic, fip_timer_work);
 	struct fnic_iport_s *iport = &fnic->iport;
 
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "FIP timeout\n");
 
 	if (iport->fip.state == FDLS_FIP_VLAN_DISCOVERY_STARTED) {
@@ -646,7 +643,7 @@ void fnic_work_on_fip_timer(struct work_struct *work)
 	} else if (iport->fip.state == FDLS_FIP_FCF_DISCOVERY_STARTED) {
 		u8 zmac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
 
-		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "FCF Discovery timeout\n");
 		if (memcmp(iport->selected_fcf.fcf_mac, zmac, ETH_ALEN) != 0) {
 
@@ -668,12 +665,12 @@ void fnic_work_on_fip_timer(struct work_struct *work)
 					  round_jiffies(fcf_tov));
 			}
 		} else {
-			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host,
+			FNIC_FIP_DBG(KERN_INFO, fnic->host,
 				     fnic->fnic_num, "FCF Discovery timeout\n");
 			fnic_vlan_discovery_timeout(fnic);
 		}
 	} else if (iport->fip.state == FDLS_FIP_FLOGI_STARTED) {
-		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			     "FLOGI timeout\n");
 		if (iport->fip.flogi_retry < fnic->config.flogi_retries)
 			fnic_fcoe_start_flogi(fnic);
@@ -851,7 +848,7 @@ void fnic_work_on_fcs_ka_timer(struct work_struct *work)
 	*fnic = container_of(work, struct fnic, fip_timer_work);
 	struct fnic_iport_s *iport = &fnic->iport;
 
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		     "fnic 0x%p fcs ka timeout\n", fnic);
 
 	fnic_common_fip_cleanup(fnic);
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 33256d99023a..5ad9d6df92a8 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -10,8 +10,10 @@
 #include <linux/netdevice.h>
 #include <linux/workqueue.h>
 #include <linux/bitops.h>
-#include <scsi/libfc.h>
-#include <scsi/libfcoe.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fc.h>
+#include <scsi/fc_frame.h>
 #include "fnic_io.h"
 #include "fnic_res.h"
 #include "fnic_trace.h"
@@ -342,8 +344,6 @@ struct fnic {
 	enum fnic_role_e role;
 	struct fnic_iport_s iport;
 	struct Scsi_Host *host;
-	struct fc_lport *lport;
-	struct fcoe_ctlr ctlr;		/* FIP FCoE controller structure */
 	struct vnic_dev_bar bar0;
 
 	struct fnic_msix_entry msix[FNIC_MSIX_INTR_MAX];
@@ -376,9 +376,6 @@ struct fnic {
 	u32 vlan_hw_insert:1;	        /* let hw insert the tag */
 	u32 in_remove:1;                /* fnic device in removal */
 	u32 stop_rx_link_events:1;      /* stop proc. rx frames, link events */
-	u32 link_events:1;              /* set when we get any link event*/
-
-	struct completion *remove_wait; /* device remove thread blocks */
 
 	struct completion *fw_reset_done;
 	u32 reset_in_progress;
diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index 3748bbe190f7..caee32bc9190 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -682,7 +682,7 @@ int fnic_stats_debugfs_init(struct fnic *fnic)
 	int rc = -1;
 	char name[16];
 
-	snprintf(name, sizeof(name), "host%d", fnic->lport->host->host_no);
+	snprintf(name, sizeof(name), "host%d", fnic->host->host_no);
 
 	if (!fnic_stats_debugfs_root) {
 		pr_debug("fnic_stats root doesn't exist\n");
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index c1bc7e8b4f67..314ed3dd0a7a 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -16,7 +16,8 @@
 #include <scsi/fc/fc_els.h>
 #include <scsi/fc/fc_fcoe.h>
 #include <scsi/fc_frame.h>
-#include <scsi/libfc.h>
+#include <linux/etherdevice.h>
+#include <scsi/scsi_transport_fc.h>
 #include "fnic_io.h"
 #include "fnic.h"
 #include "fnic_fip.h"
@@ -57,7 +58,7 @@ uint8_t FCOE_ALL_FCF_MAC[6] = { 0x0e, 0xfc, 0x00, 0xff, 0xff, 0xfe };
 static inline void fnic_fdls_set_fcoe_srcmac(struct fnic *fnic,
 							 uint8_t *src_mac)
 {
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Setting src mac: %02x:%02x:%02x:%02x:%02x:%02x",
 				 src_mac[0], src_mac[1], src_mac[2], src_mac[3],
 				 src_mac[4], src_mac[5]);
@@ -72,7 +73,7 @@ static inline void fnic_fdls_set_fcoe_srcmac(struct fnic *fnic,
 static inline  void fnic_fdls_set_fcoe_dstmac(struct fnic *fnic,
 							 uint8_t *dst_mac)
 {
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Setting dst mac: %02x:%02x:%02x:%02x:%02x:%02x",
 				 dst_mac[0], dst_mac[1], dst_mac[2], dst_mac[3],
 				 dst_mac[4], dst_mac[5]);
@@ -100,7 +101,7 @@ void fnic_fdls_link_status_change(struct fnic *fnic, int linkup)
 {
 	struct fnic_iport_s *iport = &fnic->iport;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "link up: %d, usefip: %d", linkup, iport->usefip);
 
 	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
@@ -108,12 +109,12 @@ void fnic_fdls_link_status_change(struct fnic *fnic, int linkup)
 	if (linkup) {
 		if (iport->usefip) {
 			iport->state = FNIC_IPORT_STATE_FIP;
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "link up: %d, usefip: %d", linkup, iport->usefip);
 			fnic_fcoe_send_vlan_req(fnic);
 		} else {
 			iport->state = FNIC_IPORT_STATE_FABRIC_DISC;
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "iport->state: %d", iport->state);
 			fnic_fdls_disc_start(iport);
 		}
@@ -143,13 +144,13 @@ void fnic_fdls_learn_fcoe_macs(struct fnic_iport_s *iport, void *rx_frame,
 
 	memcpy(&fcmac[3], fcid, 3);
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "learn fcoe: dst_mac: %02x:%02x:%02x:%02x:%02x:%02x",
 				 ethhdr->dst_mac[0], ethhdr->dst_mac[1],
 				 ethhdr->dst_mac[2], ethhdr->dst_mac[3],
 				 ethhdr->dst_mac[4], ethhdr->dst_mac[5]);
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "learn fcoe: fc_mac: %02x:%02x:%02x:%02x:%02x:%02x",
 				 fcmac[0], fcmac[1], fcmac[2], fcmac[3], fcmac[4],
 				 fcmac[5]);
@@ -167,7 +168,7 @@ void fnic_fdls_init(struct fnic *fnic, int usefip)
 	iport->fnic = fnic;
 	iport->usefip = usefip;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "iportsrcmac: %02x:%02x:%02x:%02x:%02x:%02x",
 				 iport->hwmac[0], iport->hwmac[1], iport->hwmac[2],
 				 iport->hwmac[3], iport->hwmac[4], iport->hwmac[5]);
@@ -186,14 +187,14 @@ void fnic_handle_link(struct work_struct *work)
 	int max_count = 0;
 
 	if (vnic_dev_get_intr_mode(fnic->vdev) != VNIC_DEV_INTR_MODE_MSI)
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Interrupt mode is not MSI\n");
 
 	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 
 	if (fnic->stop_rx_link_events) {
 		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Stop link rx events\n");
 		return;
 	}
@@ -202,10 +203,10 @@ void fnic_handle_link(struct work_struct *work)
 	if ((fnic->state != FNIC_IN_ETH_MODE)
 		&& (fnic->state != FNIC_IN_FC_MODE)) {
 		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "fnic in transitional state: %d. link up: %d ignored",
 			 fnic->state, vnic_dev_link_status(fnic->vdev));
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Current link status: %d iport state: %d\n",
 			 fnic->link_status, fnic->iport.state);
 		return;
@@ -217,36 +218,36 @@ void fnic_handle_link(struct work_struct *work)
 	fnic->link_down_cnt = vnic_dev_link_down_cnt(fnic->vdev);
 
 	while (fnic->reset_in_progress == IN_PROGRESS) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "fnic reset in progress. Link event needs to wait\n");
 
 		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "waiting for reset completion\n");
 		wait_for_completion_timeout(&fnic->reset_completion_wait,
 									msecs_to_jiffies(5000));
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "woken up from reset completion wait\n");
 		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 
 		max_count++;
 		if (max_count >= MAX_RESET_WAIT_COUNT) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Rstth waited for too long. Skipping handle link event\n");
 			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 			return;
 		}
 	}
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Marking fnic reset in progress\n");
 	fnic->reset_in_progress = IN_PROGRESS;
 
 	if ((vnic_dev_get_intr_mode(fnic->vdev) != VNIC_DEV_INTR_MODE_MSI) ||
 		(fnic->link_status != old_link_status)) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "old link status: %d link status: %d\n",
 					 old_link_status, (int) fnic->link_status);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "old down count %d down count: %d\n",
 					 old_link_down_cnt, (int) fnic->link_down_cnt);
 	}
@@ -255,36 +256,36 @@ void fnic_handle_link(struct work_struct *work)
 		if (!fnic->link_status) {
 			/* DOWN -> DOWN */
 			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "down->down\n");
 		} else {
 			if (old_link_down_cnt != fnic->link_down_cnt) {
 				/* UP -> DOWN -> UP */
 				spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "up->down. Link down\n");
 				fnic_fdls_link_status_change(fnic, 0);
 
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "down->up. Link up\n");
 				fnic_fdls_link_status_change(fnic, 1);
 			} else {
 				/* UP -> UP */
 				spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "up->up\n");
 			}
 		}
 	} else if (fnic->link_status) {
 		/* DOWN -> UP */
 		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "down->up. Link up\n");
 		fnic_fdls_link_status_change(fnic, 1);
 	} else {
 		/* UP -> DOWN */
 		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "up->down. Link down\n");
 		fnic_fdls_link_status_change(fnic, 0);
 	}
@@ -293,7 +294,7 @@ void fnic_handle_link(struct work_struct *work)
 	fnic->reset_in_progress = NOT_IN_PROGRESS;
 	complete(&fnic->reset_completion_wait);
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Marking fnic reset completion\n");
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 }
@@ -323,7 +324,7 @@ void fnic_handle_frame(struct work_struct *work)
 		 */
 		if (fnic->state != FNIC_IN_FC_MODE &&
 			fnic->state != FNIC_IN_ETH_MODE) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Cannot process frame in transitional state\n");
 			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 			return;
@@ -349,7 +350,7 @@ void fnic_handle_fip_frame(struct work_struct *work)
 	struct fnic_frame_list *cur_frame, *next;
 	struct fnic *fnic = container_of(work, struct fnic, fip_frame_work);
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Processing FIP frame\n");
 
 	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
@@ -428,7 +429,7 @@ void fnic_update_mac_locked(struct fnic *fnic, u8 *new)
 	if (ether_addr_equal(data, new))
 		return;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Update MAC: %u\n", *new);
 
 	if (!is_zero_ether_addr(data) && !ether_addr_equal(data, ctl))
@@ -498,7 +499,7 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 
 		if (!fcs_ok) {
 			atomic64_inc(&fnic_stats->misc_stats.frame_errors);
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "fnic 0x%p fcs error.  Dropping packet.\n", fnic);
 			goto drop;
 		}
@@ -508,21 +509,21 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 			if (fnic_import_rq_eth_pkt(fnic, fp))
 				return;
 
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "Dropping ether_type 0x%x",
 							 ntohs(eh->ether_type));
 			goto drop;
 		}
 	} else {
 		/* wrong CQ type */
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "fnic rq_cmpl wrong cq type x%x\n", type);
 		goto drop;
 	}
 
 	if (!fcs_ok || packet_error || !fcoe_fnic_crc_ok || fcoe_enc_error) {
 		atomic64_inc(&fnic_stats->misc_stats.frame_errors);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "fcoe %x fcsok %x pkterr %x ffco %x fee %x\n",
 			 fcoe, fcs_ok, packet_error,
 			 fcoe_fnic_crc_ok, fcoe_enc_error);
@@ -532,7 +533,7 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	if (fnic->stop_rx_link_events) {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "fnic->stop_rx_link_events: %d\n",
 					 fnic->stop_rx_link_events);
 		goto drop;
@@ -544,7 +545,7 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 		kzalloc(sizeof(struct fnic_frame_list),
 						   GFP_ATOMIC);
 	if (!frame_elem) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Unable to alloc frame element of size: %ld\n",
 					 sizeof(struct fnic_frame_list));
 		goto drop;
@@ -590,7 +591,7 @@ int fnic_rq_cmpl_handler(struct fnic *fnic, int rq_work_to_do)
 		if (cur_work_done && fnic->stop_rx_link_events != 1) {
 			err = vnic_rq_fill(&fnic->rq[i], fnic_alloc_rq_frame);
 			if (err)
-				shost_printk(KERN_ERR, fnic->lport->host,
+				shost_printk(KERN_ERR, fnic->host,
 					     "fnic_alloc_rq_frame can't alloc"
 					     " frame\n");
 		}
@@ -616,7 +617,7 @@ int fnic_alloc_rq_frame(struct vnic_rq *rq)
 	len = FNIC_FRAME_HT_ROOM;
 	buf = kmalloc(len, GFP_ATOMIC);
 	if (!buf) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Unable to allocate RQ buffer of size: %d\n", len);
 		return -ENOMEM;
 	}
@@ -624,7 +625,7 @@ int fnic_alloc_rq_frame(struct vnic_rq *rq)
 	pa = dma_map_single(&fnic->pdev->dev, buf, len, DMA_FROM_DEVICE);
 	if (dma_mapping_error(&fnic->pdev->dev, pa)) {
 		ret = -ENOMEM;
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "PCI mapping failed with error %d\n", ret);
 		goto free_buf;
 	}
@@ -663,7 +664,7 @@ static int fnic_send_frame(struct fnic *fnic, void *frame, int frame_len)
 	if ((fnic_fc_trace_set_data(fnic->fnic_num,
 				FNIC_FC_SEND | 0x80, (char *) frame,
 				frame_len)) != 0) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "fnic ctlr frame trace error");
 	}
 
@@ -671,7 +672,7 @@ static int fnic_send_frame(struct fnic *fnic, void *frame, int frame_len)
 
 	if (!vnic_wq_desc_avail(wq)) {
 		dma_unmap_single(&fnic->pdev->dev, pa, frame_len, DMA_TO_DEVICE);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "vnic work queue descriptor is not available");
 		ret = -1;
 		goto fnic_send_frame_end;
@@ -699,7 +700,7 @@ fdls_send_fcoe_frame(struct fnic *fnic, void *payload, int payload_sz,
 
 	frame = kzalloc(max_framesz, GFP_ATOMIC);
 	if (!frame) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Failed to allocate frame for flogi\n");
 		return -ENOMEM;
 	}
@@ -727,12 +728,13 @@ fdls_send_fcoe_frame(struct fnic *fnic, void *payload, int payload_sz,
 		&& (fnic->state != FNIC_IN_ETH_MODE)) {
 		frame_elem = kzalloc(sizeof(struct fnic_frame_list), GFP_ATOMIC);
 		if (!frame_elem) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Failed to allocate memory for fnic_frame_list: %lu\n",
 						 sizeof(struct fnic_frame_list));
 			return -ENOMEM;
 		}
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Queuing frame: 0x%p\n", frame);
 
 		frame_elem->fp = frame;
@@ -754,7 +756,7 @@ fdls_send_fip_frame(struct fnic *fnic, void *payload, int payload_sz)
 
 	frame = kzalloc(max_framesz, GFP_ATOMIC);
 	if (!frame) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "fnic 0x%p Failed to allocate fip frame\n", fnic);
 		return -1;
 	}
@@ -813,7 +815,7 @@ void fnic_flush_tx(struct work_struct *work)
 	struct fc_frame *fp;
 	struct fnic_frame_list *cur_frame, *next;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Flush queued frames");
 
 	list_for_each_entry_safe(cur_frame, next, &fnic->tx_queue, links) {
@@ -831,7 +833,7 @@ fnic_fdls_register_portid(struct fnic_iport_s *iport, u32 port_id,
 	struct fnic_eth_hdr_s *ethhdr;
 	int ret;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Setting port id: 0x%x fp: 0x%p fnic state: %d", port_id,
 				 fp, fnic->state);
 
@@ -844,7 +846,7 @@ fnic_fdls_register_portid(struct fnic_iport_s *iport, u32 port_id,
 	if (fnic->state == FNIC_IN_ETH_MODE || fnic->state == FNIC_IN_FC_MODE)
 		fnic->state = FNIC_IN_ETH_TRANS_FC_MODE;
 	else {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Unexpected fnic state while processing FLOGI response\n");
 		return -1;
 	}
@@ -855,7 +857,7 @@ fnic_fdls_register_portid(struct fnic_iport_s *iport, u32 port_id,
 	 */
 	ret = fnic_flogi_reg_handler(fnic, port_id);
 	if (ret < 0) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "FLOGI registration error ret: %d fnic state: %d\n",
 					 ret, fnic->state);
 		if (fnic->state == FNIC_IN_ETH_TRANS_FC_MODE)
@@ -865,7 +867,7 @@ fnic_fdls_register_portid(struct fnic_iport_s *iport, u32 port_id,
 	}
 	iport->fabric.flags |= FNIC_FDLS_FPMA_LEARNT;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FLOGI registration success\n");
 	return 0;
 }
@@ -945,7 +947,7 @@ fnic_fdls_add_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tport,
 	struct fc_rport_identifiers ids;
 	struct rport_dd_data_s *rdd_data;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Adding rport fcid: 0x%x", tport->fcid);
 
 	ids.node_name = tport->wwnn;
@@ -954,15 +956,15 @@ fnic_fdls_add_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tport,
 	ids.roles = FC_RPORT_ROLE_FCP_TARGET;
 
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-	rport = fc_remote_port_add(fnic->lport->host, 0, &ids);
+	rport = fc_remote_port_add(fnic->host, 0, &ids);
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	if (!rport) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Failed to add rport for tport: 0x%x", tport->fcid);
 		return;
 	}
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Added rport fcid: 0x%x", tport->fcid);
 
 	/* Mimic these assignments in queuecommand to avoid timing issues */
@@ -1001,7 +1003,7 @@ fnic_fdls_remove_tport(struct fnic_iport_s *iport,
 		fc_remote_port_delete(rport);
 
 		spin_lock_irqsave(&fnic->fnic_lock, flags);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "Deregistered and freed tport fcid: 0x%x from scsi transport fc",
 		 tport->fcid);
 
@@ -1028,7 +1030,7 @@ void fnic_delete_fcp_tports(struct fnic *fnic)
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	list_for_each_entry_safe(tport, next, &fnic->iport.tport_list, links) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "removing fcp rport fcid: 0x%x", tport->fcid);
 		fdls_set_tport_state(tport, FDLS_TGT_STATE_OFFLINING);
 		fnic_del_tport_timer_sync(fnic, tport);
@@ -1055,36 +1057,36 @@ void fnic_tport_event_handler(struct work_struct *work)
 		tport = cur_evt->arg1;
 		switch (cur_evt->event) {
 		case TGT_EV_RPORT_ADD:
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Add rport event");
 			if (tport->state == FDLS_TGT_STATE_READY) {
 				fnic_fdls_add_tport(&fnic->iport,
 					(struct fnic_tport_s *) cur_evt->arg1, flags);
 			} else {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Target not ready. Add rport event dropped: 0x%x",
 					 tport->fcid);
 			}
 			break;
 		case TGT_EV_RPORT_DEL:
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Remove rport event");
 			if (tport->state == FDLS_TGT_STATE_OFFLINING) {
 				fnic_fdls_remove_tport(&fnic->iport,
 					   (struct fnic_tport_s *) cur_evt->arg1, flags);
 			} else {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "remove rport event dropped tport fcid: 0x%x",
 							 tport->fcid);
 			}
 			break;
 		case TGT_EV_TPORT_DELETE:
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Delete tport event");
 			fdls_delete_tport(tport->iport, tport);
 			break;
 		default:
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Unknown tport event");
 			break;
 		}
diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
index ff85441c6cea..7ed50b11afa6 100644
--- a/drivers/scsi/fnic/fnic_isr.c
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -7,7 +7,7 @@
 #include <linux/errno.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
-#include <scsi/libfc.h>
+#include <scsi/scsi_transport_fc.h>
 #include <scsi/fc_frame.h>
 #include "vnic_dev.h"
 #include "vnic_intr.h"
@@ -222,7 +222,7 @@ int fnic_request_intr(struct fnic *fnic)
 							fnic->msix[i].devname,
 							fnic->msix[i].devid);
 			if (err) {
-				FNIC_ISR_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				FNIC_ISR_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 							"request_irq failed with error: %d\n",
 							err);
 				fnic_free_intr(fnic);
@@ -250,10 +250,10 @@ int fnic_set_intr_mode_msix(struct fnic *fnic)
 	 * We need n RQs, m WQs, o Copy WQs, n+m+o CQs, and n+m+o+1 INTRs
 	 * (last INTR is used for WQ/RQ errors and notification area)
 	 */
-	FNIC_ISR_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_ISR_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		"rq-array size: %d wq-array size: %d copy-wq array size: %d\n",
 		n, m, o);
-	FNIC_ISR_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_ISR_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		"rq_count: %d raw_wq_count: %d wq_copy_count: %d cq_count: %d\n",
 		fnic->rq_count, fnic->raw_wq_count,
 		fnic->wq_copy_count, fnic->cq_count);
@@ -265,17 +265,17 @@ int fnic_set_intr_mode_msix(struct fnic *fnic)
 
 		vec_count = pci_alloc_irq_vectors(fnic->pdev, min_irqs, vecs,
 					PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
-		FNIC_ISR_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_ISR_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					"allocated %d MSI-X vectors\n",
 					vec_count);
 
 		if (vec_count > 0) {
 			if (vec_count < vecs) {
-				FNIC_ISR_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				FNIC_ISR_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				"interrupts number mismatch: vec_count: %d vecs: %d\n",
 				vec_count, vecs);
 				if (vec_count < min_irqs) {
-					FNIC_ISR_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					FNIC_ISR_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 								"no interrupts for copy wq\n");
 					return 1;
 				}
@@ -287,7 +287,7 @@ int fnic_set_intr_mode_msix(struct fnic *fnic)
 			fnic->wq_copy_count = vec_count - n - m - 1;
 			fnic->wq_count = fnic->raw_wq_count + fnic->wq_copy_count;
 			if (fnic->cq_count != vec_count - 1) {
-				FNIC_ISR_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				FNIC_ISR_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				"CQ count: %d does not match MSI-X vector count: %d\n",
 				fnic->cq_count, vec_count);
 				fnic->cq_count = vec_count - 1;
@@ -295,23 +295,23 @@ int fnic_set_intr_mode_msix(struct fnic *fnic)
 			fnic->intr_count = vec_count;
 			fnic->err_intr_offset = fnic->rq_count + fnic->wq_count;
 
-			FNIC_ISR_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_ISR_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				"rq_count: %d raw_wq_count: %d copy_wq_base: %d\n",
 				fnic->rq_count,
 				fnic->raw_wq_count, fnic->copy_wq_base);
 
-			FNIC_ISR_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_ISR_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				"wq_copy_count: %d wq_count: %d cq_count: %d\n",
 				fnic->wq_copy_count,
 				fnic->wq_count, fnic->cq_count);
 
-			FNIC_ISR_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_ISR_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				"intr_count: %d err_intr_offset: %u",
 				fnic->intr_count,
 				fnic->err_intr_offset);
 
 			vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_MSIX);
-			FNIC_ISR_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_ISR_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					"fnic using MSI-X\n");
 			return 0;
 		}
@@ -351,7 +351,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
 		fnic->intr_count = 1;
 		fnic->err_intr_offset = 0;
 
-		FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_ISR_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 			     "Using MSI Interrupts\n");
 		vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_MSI);
 
@@ -377,7 +377,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
 		fnic->cq_count = 3;
 		fnic->intr_count = 3;
 
-		FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_ISR_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 			     "Using Legacy Interrupts\n");
 		vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_INTX);
 
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index a1c7f666093b..8fcfcaf8a527 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -22,7 +22,6 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi_tcq.h>
-#include <scsi/libfc.h>
 #include <scsi/fc_frame.h>
 
 #include "vnic_dev.h"
@@ -175,7 +174,7 @@ static void fnic_get_host_speed(struct Scsi_Host *shost)
 	u32 port_speed = vnic_dev_port_speed(fnic->vdev);
 	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
-	FNIC_MAIN_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_MAIN_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				  "port_speed: %d Mbps", port_speed);
 	atomic64_set(&fnic_stats->misc_stats.port_speed_in_mbps, port_speed);
 
@@ -225,7 +224,7 @@ static void fnic_get_host_speed(struct Scsi_Host *shost)
 		fc_host_speed(shost) = FC_PORTSPEED_128GBIT;
 		break;
 	default:
-		FNIC_MAIN_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_MAIN_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					  "Unknown FC speed: %d Mbps", port_speed);
 		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 		break;
@@ -251,7 +250,7 @@ static struct fc_host_statistics *fnic_get_stats(struct Scsi_Host *host)
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
 	if (ret) {
-		FNIC_MAIN_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_MAIN_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 					  "fnic: Get vnic stats failed: 0x%x", ret);
 		return stats;
 	}
@@ -360,7 +359,7 @@ static void fnic_reset_host_stats(struct Scsi_Host *host)
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
 	if (ret) {
-		FNIC_MAIN_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_MAIN_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 				"fnic: Reset vnic stats failed"
 				" 0x%x", ret);
 		return;
@@ -562,7 +561,7 @@ static void fnic_set_vlan(struct fnic *fnic, u16 vlan_id)
 
 static void fnic_scsi_init(struct fnic *fnic)
 {
-	struct Scsi_Host *host = fnic->lport->host;
+	struct Scsi_Host *host = fnic->host;
 
 	snprintf(fnic->name, sizeof(fnic->name) - 1, "%s%d", DRV_NAME,
 			 host->host_no);
@@ -572,7 +571,7 @@ static void fnic_scsi_init(struct fnic *fnic)
 
 static int fnic_scsi_drv_init(struct fnic *fnic)
 {
-	struct Scsi_Host *host = fnic->lport->host;
+	struct Scsi_Host *host = fnic->host;
 	int err;
 	struct pci_dev *pdev = fnic->pdev;
 	struct fnic_iport_s *iport = &fnic->iport;
@@ -609,41 +608,41 @@ static int fnic_scsi_drv_init(struct fnic *fnic)
 
 	fnic_scsi_init(fnic);
 
-	err = scsi_add_host(fnic->lport->host, &pdev->dev);
+	err = scsi_add_host(fnic->host, &pdev->dev);
 	if (err) {
 		dev_err(&fnic->pdev->dev, "fnic: scsi add host failed: aborting\n");
 		return -1;
 	}
-	fc_host_maxframe_size(fnic->lport->host) = iport->max_payload_size;
-	fc_host_dev_loss_tmo(fnic->lport->host) =
+	fc_host_maxframe_size(fnic->host) = iport->max_payload_size;
+	fc_host_dev_loss_tmo(fnic->host) =
 		fnic->config.port_down_timeout / 1000;
-	sprintf(fc_host_symbolic_name(fnic->lport->host),
+	sprintf(fc_host_symbolic_name(fnic->host),
 			DRV_NAME " v" DRV_VERSION " over %s", fnic->name);
-	fc_host_port_type(fnic->lport->host) = FC_PORTTYPE_NPORT;
-	fc_host_node_name(fnic->lport->host) = iport->wwnn;
-	fc_host_port_name(fnic->lport->host) = iport->wwpn;
-	fc_host_supported_classes(fnic->lport->host) = FC_COS_CLASS3;
-	memset(fc_host_supported_fc4s(fnic->lport->host), 0,
-		   sizeof(fc_host_supported_fc4s(fnic->lport->host)));
-	fc_host_supported_fc4s(fnic->lport->host)[2] = 1;
-	fc_host_supported_fc4s(fnic->lport->host)[7] = 1;
-	fc_host_supported_speeds(fnic->lport->host) = 0;
-	fc_host_supported_speeds(fnic->lport->host) |= FC_PORTSPEED_8GBIT;
-
-	dev_info(&fnic->pdev->dev, "shost_data: 0x%p\n", fnic->lport->host->shost_data);
-	if (fnic->lport->host->shost_data != NULL) {
+	fc_host_port_type(fnic->host) = FC_PORTTYPE_NPORT;
+	fc_host_node_name(fnic->host) = iport->wwnn;
+	fc_host_port_name(fnic->host) = iport->wwpn;
+	fc_host_supported_classes(fnic->host) = FC_COS_CLASS3;
+	memset(fc_host_supported_fc4s(fnic->host), 0,
+		   sizeof(fc_host_supported_fc4s(fnic->host)));
+	fc_host_supported_fc4s(fnic->host)[2] = 1;
+	fc_host_supported_fc4s(fnic->host)[7] = 1;
+	fc_host_supported_speeds(fnic->host) = 0;
+	fc_host_supported_speeds(fnic->host) |= FC_PORTSPEED_8GBIT;
+
+	dev_info(&fnic->pdev->dev, "shost_data: 0x%p\n", fnic->host->shost_data);
+	if (fnic->host->shost_data != NULL) {
 		if (fnic_tgt_id_binding == 0) {
 			dev_info(&fnic->pdev->dev, "Setting target binding to NONE\n");
-			fc_host_tgtid_bind_type(fnic->lport->host) = FC_TGTID_BIND_NONE;
+			fc_host_tgtid_bind_type(fnic->host) = FC_TGTID_BIND_NONE;
 		} else {
 			dev_info(&fnic->pdev->dev, "Setting target binding to WWPN\n");
-			fc_host_tgtid_bind_type(fnic->lport->host) = FC_TGTID_BIND_BY_WWPN;
+			fc_host_tgtid_bind_type(fnic->host) = FC_TGTID_BIND_BY_WWPN;
 		}
 	}
 
 	fnic->io_req_pool = mempool_create_slab_pool(2, fnic_io_req_cache);
 	if (!fnic->io_req_pool) {
-		scsi_remove_host(fnic->lport->host);
+		scsi_remove_host(fnic->host);
 		return -ENOMEM;
 	}
 
@@ -658,16 +657,16 @@ void fnic_mq_map_queues_cpus(struct Scsi_Host *host)
 	struct blk_mq_queue_map *qmap = &host->tag_set.map[HCTX_TYPE_DEFAULT];
 
 	if (intr_mode == VNIC_DEV_INTR_MODE_MSI || intr_mode == VNIC_DEV_INTR_MODE_INTX) {
-		FNIC_MAIN_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_MAIN_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"intr_mode is not msix\n");
 		return;
 	}
 
-	FNIC_MAIN_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_MAIN_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			"qmap->nr_queues: %d\n", qmap->nr_queues);
 
 	if (l_pdev == NULL) {
-		FNIC_MAIN_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_MAIN_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 						"l_pdev is null\n");
 		return;
 	}
@@ -829,7 +828,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			}
 			*((struct fnic **) shost_priv(host)) = fnic;
 
-			fnic->lport->host = host;
+			fnic->host = host;
 			fnic->role = FNIC_ROLE_FCP_INITIATOR;
 			dev_info(&fnic->pdev->dev, "fnic: %d is scsi initiator\n",
 					fnic->fnic_num);
@@ -1020,7 +1019,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 err_out_free_stats_debugfs:
 	fnic_stats_debugfs_remove(fnic);
-	scsi_remove_host(fnic->lport->host);
+	scsi_remove_host(fnic->host);
 err_out_scsi_drv_init:
 	fnic_free_intr(fnic);
 err_out_fnic_request_intr:
@@ -1041,7 +1040,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fnic_clear_intr_mode(fnic);
 err_out_fnic_set_intr_mode:
 	if (IS_FNIC_FCP_INITIATOR(fnic))
-		scsi_host_put(fnic->lport->host);
+		scsi_host_put(fnic->host);
 err_out_fnic_role:
 err_out_scsi_host_alloc:
 err_out_fnic_get_config:
@@ -1130,7 +1129,7 @@ static void fnic_remove(struct pci_dev *pdev)
 	ida_free(&fnic_ida, fnic->fnic_num);
 	if (IS_FNIC_FCP_INITIATOR(fnic)) {
 		fnic_scsi_unload_cleanup(fnic);
-		scsi_host_put(fnic->lport->host);
+		scsi_host_put(fnic->host);
 	}
 	kfree(fnic);
 }
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index aa463ed652c0..786cd545df86 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -23,7 +23,6 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/fc/fc_els.h>
 #include <scsi/fc/fc_fcoe.h>
-#include <scsi/libfc.h>
 #include <scsi/fc_frame.h>
 #include <scsi/scsi_transport_fc.h>
 #include "fnic_io.h"
@@ -174,7 +173,7 @@ unsigned int fnic_count_lun_ioreqs_wq(struct fnic *fnic, u32 hwq,
 
 		if (io_req != NULL) {
 			struct scsi_cmnd *sc =
-				scsi_host_find_tag(fnic->lport->host, io_req->tag);
+				scsi_host_find_tag(fnic->host, io_req->tag);
 
 			if (!sc)
 				continue;
@@ -297,11 +296,11 @@ int fnic_fw_reset_handler(struct fnic *fnic)
 
 	if (!ret) {
 		atomic64_inc(&fnic->fnic_stats.reset_stats.fw_resets);
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				"Issued fw reset\n");
 	} else {
 		fnic_clear_state_flags(fnic, FNIC_FLAGS_FWRESET);
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				"Failed to issue fw reset\n");
 	}
 
@@ -340,13 +339,13 @@ int fnic_flogi_reg_handler(struct fnic *fnic, u32 fc_id)
 						fc_id, gw_mac,
 						fnic->iport.fpma,
 						iport->r_a_tov, iport->e_d_tov);
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			      "FLOGI FIP reg issued fcid: 0x%x src %p dest %p\n",
 				  fc_id, fnic->iport.fpma, gw_mac);
 	} else {
 		fnic_queue_wq_copy_desc_flogi_reg(wq, SCSI_NO_TAG,
 						  format, fc_id, gw_mac);
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			"FLOGI reg issued fcid 0x%x dest %p\n",
 			fc_id, gw_mac);
 	}
@@ -427,7 +426,7 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 		free_wq_copy_descs(fnic, wq, hwq);
 
 	if (unlikely(!vnic_wq_copy_desc_avail(wq))) {
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			  "fnic_queue_wq_copy_desc failure - no descriptors\n");
 		atomic64_inc(&misc_stats->io_cpwq_alloc_failures);
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -492,7 +491,7 @@ int fnic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 
 	rport = starget_to_rport(scsi_target(sc->device));
 	if (!rport) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				"returning DID_NO_CONNECT for IO as rport is NULL\n");
 		sc->result = DID_NO_CONNECT << 16;
 		done(sc);
@@ -501,7 +500,7 @@ int fnic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 
 	ret = fc_remote_port_chkready(rport);
 	if (ret) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				"rport is not ready\n");
 		atomic64_inc(&fnic_stats->misc_stats.tport_not_ready);
 		sc->result = ret;
@@ -515,7 +514,7 @@ int fnic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 
 	if (iport->state != FNIC_IPORT_STATE_READY) {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					  "returning DID_NO_CONNECT for IO as iport state: %d\n",
 					  iport->state);
 		sc->result = DID_NO_CONNECT << 16;
@@ -529,13 +528,13 @@ int fnic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 	rdd_data = rport->dd_data;
 	tport = rdd_data->tport;
 	if (!tport || (rdd_data->iport != iport)) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					  "dd_data not yet set in SCSI for rport portid: 0x%x\n",
 					  rport->port_id);
 		tport = fnic_find_tport_by_fcid(iport, rport->port_id);
 		if (!tport) {
 			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-			FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 						  "returning DID_BUS_BUSY for IO as tport not found for: 0x%x\n",
 						  rport->port_id);
 			sc->result = DID_BUS_BUSY << 16;
@@ -558,7 +557,7 @@ int fnic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 	if ((tport->state != FDLS_TGT_STATE_READY)
 		&& (tport->state != FDLS_TGT_STATE_ADISC)) {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					  "returning DID_NO_CONNECT for IO as tport state: %d\n",
 					  tport->state);
 		sc->result = DID_NO_CONNECT << 16;
@@ -578,7 +577,7 @@ int fnic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 
 	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_FWRESET))) {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 		  "fnic flags FW reset: 0x%lx. Returning SCSI_MLQUEUE_HOST_BUSY\n",
 		  fnic->state_flags);
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -720,7 +719,7 @@ int fnic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 	atomic_dec(&tport->in_flight);
 
 	if (lun0_delay) {
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					  "LUN0 delay\n");
 		mdelay(LUN0_DELAY_TIME);
 	}
@@ -760,12 +759,12 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 	if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE) {
 		/* Check status of reset completion */
 		if (!hdr_status) {
-			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					"reset cmpl success\n");
 			/* Ready to send flogi out */
 			fnic->state = FNIC_IN_ETH_MODE;
 		} else {
-			FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				"reset failed with header status: %s\n",
 				fnic_fcpio_status_to_str(hdr_status));
 
@@ -774,7 +773,7 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 			ret = -1;
 		}
 	} else {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"Unexpected state while processing reset completion: %s\n",
 			fnic_state_to_str(fnic->state));
 		atomic64_inc(&reset_stats->fw_reset_failures);
@@ -826,19 +825,19 @@ static int fnic_fcpio_flogi_reg_cmpl_handler(struct fnic *fnic,
 
 		/* Check flogi registration completion status */
 		if (!hdr_status) {
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+			FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 				      "FLOGI reg succeeded\n");
 			fnic->state = FNIC_IN_FC_MODE;
 		} else {
 			FNIC_SCSI_DBG(KERN_DEBUG,
-				      fnic->lport->host, fnic->fnic_num,
+				      fnic->host, fnic->fnic_num,
 				      "fnic flogi reg failed: %s\n",
 				      fnic_fcpio_status_to_str(hdr_status));
 			fnic->state = FNIC_IN_ETH_MODE;
 			ret = -1;
 		}
 	} else {
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 			      "Unexpected fnic state %s while"
 			      " processing flogi reg completion\n",
 			      fnic_state_to_str(fnic->state));
@@ -911,7 +910,7 @@ static inline void fnic_fcpio_ack_handler(struct fnic *fnic,
 
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[wq_index], flags);
 	FNIC_TRACE(fnic_fcpio_ack_handler,
-		  fnic->lport->host->host_no, 0, 0, ox_id_tag[2], ox_id_tag[3],
+		  fnic->host->host_no, 0, 0, ox_id_tag[2], ox_id_tag[3],
 		  ox_id_tag[4], ox_id_tag[5]);
 }
 
@@ -949,36 +948,36 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic, unsigned int cq_ind
 	hwq = blk_mq_unique_tag_to_hwq(mqtag);
 
 	if (hwq != cq_index) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"hwq: %d mqtag: 0x%x tag: 0x%x cq index: %d ",
 			hwq, mqtag, tag, cq_index);
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"hdr status: %s icmnd completion on the wrong queue\n",
 			fnic_fcpio_status_to_str(hdr_status));
 	}
 
 	if (tag >= fnic->fnic_max_tag_id) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"hwq: %d mqtag: 0x%x tag: 0x%x cq index: %d ",
 			hwq, mqtag, tag, cq_index);
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"hdr status: %s Out of range tag\n",
 			fnic_fcpio_status_to_str(hdr_status));
 		return;
 	}
 	spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
 
-	sc = scsi_host_find_tag(fnic->lport->host, id);
+	sc = scsi_host_find_tag(fnic->host, id);
 	WARN_ON_ONCE(!sc);
 	if (!sc) {
 		atomic64_inc(&fnic_stats->io_stats.sc_null);
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
-		shost_printk(KERN_ERR, fnic->lport->host,
+		shost_printk(KERN_ERR, fnic->host,
 			  "icmnd_cmpl sc is null - "
 			  "hdr status = %s tag = 0x%x desc = 0x%p\n",
 			  fnic_fcpio_status_to_str(hdr_status), id, desc);
 		FNIC_TRACE(fnic_fcpio_icmnd_cmpl_handler,
-			  fnic->lport->host->host_no, id,
+			  fnic->host->host_no, id,
 			  ((u64)icmnd_cmpl->_resvd0[1] << 16 |
 			  (u64)icmnd_cmpl->_resvd0[0]),
 			  ((u64)hdr_status << 16 |
@@ -1001,7 +1000,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic, unsigned int cq_ind
 		atomic64_inc(&fnic_stats->io_stats.ioreq_null);
 		fnic_priv(sc)->flags |= FNIC_IO_REQ_NULL;
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
-		shost_printk(KERN_ERR, fnic->lport->host,
+		shost_printk(KERN_ERR, fnic->host,
 			  "icmnd_cmpl io_req is null - "
 			  "hdr status = %s tag = 0x%x sc 0x%p\n",
 			  fnic_fcpio_status_to_str(hdr_status), id, sc);
@@ -1028,7 +1027,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic, unsigned int cq_ind
 		if(FCPIO_ABORTED == hdr_status)
 			fnic_priv(sc)->flags |= FNIC_IO_ABORTED;
 
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			"icmnd_cmpl abts pending "
 			  "hdr status = %s tag = 0x%x sc = 0x%p "
 			  "scsi_status = %x residual = %d\n",
@@ -1120,7 +1119,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic, unsigned int cq_ind
 
 	if (hdr_status != FCPIO_SUCCESS) {
 		atomic64_inc(&fnic_stats->io_stats.io_failures);
-		shost_printk(KERN_ERR, fnic->lport->host, "hdr status = %s\n",
+		shost_printk(KERN_ERR, fnic->host, "hdr status = %s\n",
 			     fnic_fcpio_status_to_str(hdr_status));
 	}
 
@@ -1213,27 +1212,27 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic, unsigned int cq_inde
 	hwq = blk_mq_unique_tag_to_hwq(id & FNIC_TAG_MASK);
 
 	if (hwq != cq_index) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"hwq: %d mqtag: 0x%x tag: 0x%x cq index: %d ",
 			hwq, mqtag, tag, cq_index);
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"hdr status: %s ITMF completion on the wrong queue\n",
 			fnic_fcpio_status_to_str(hdr_status));
 	}
 
 	if (tag > fnic->fnic_max_tag_id) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"hwq: %d mqtag: 0x%x tag: 0x%x cq index: %d ",
 			hwq, mqtag, tag, cq_index);
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"hdr status: %s Tag out of range\n",
 			fnic_fcpio_status_to_str(hdr_status));
 		return;
 	}  else if ((tag == fnic->fnic_max_tag_id) && !(id & FNIC_TAG_DEV_RST)) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"hwq: %d mqtag: 0x%x tag: 0x%x cq index: %d ",
 			hwq, mqtag, tag, cq_index);
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"hdr status: %s Tag out of range\n",
 			fnic_fcpio_status_to_str(hdr_status));
 		return;
@@ -1249,14 +1248,14 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic, unsigned int cq_inde
 		if (io_req)
 			sc = io_req->sc;
 	} else {
-		sc = scsi_host_find_tag(fnic->lport->host, id & FNIC_TAG_MASK);
+		sc = scsi_host_find_tag(fnic->host, id & FNIC_TAG_MASK);
 	}
 
 	WARN_ON_ONCE(!sc);
 	if (!sc) {
 		atomic64_inc(&fnic_stats->io_stats.sc_null);
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
-		shost_printk(KERN_ERR, fnic->lport->host,
+		shost_printk(KERN_ERR, fnic->host,
 			  "itmf_cmpl sc is null - hdr status = %s tag = 0x%x\n",
 			  fnic_fcpio_status_to_str(hdr_status), tag);
 		return;
@@ -1268,7 +1267,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic, unsigned int cq_inde
 		atomic64_inc(&fnic_stats->io_stats.ioreq_null);
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 		fnic_priv(sc)->flags |= FNIC_IO_ABT_TERM_REQ_NULL;
-		shost_printk(KERN_ERR, fnic->lport->host,
+		shost_printk(KERN_ERR, fnic->host,
 			  "itmf_cmpl io_req is null - "
 			  "hdr status = %s tag = 0x%x sc 0x%p\n",
 			  fnic_fcpio_status_to_str(hdr_status), tag, sc);
@@ -1279,7 +1278,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic, unsigned int cq_inde
 	if ((id & FNIC_TAG_ABORT) && (id & FNIC_TAG_DEV_RST)) {
 		/* Abort and terminate completion of device reset req */
 		/* REVISIT : Add asserts about various flags */
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			"hwq: %d mqtag: 0x%x tag: 0x%x hst: %s Abt/term completion received\n",
 			hwq, mqtag, tag,
 			fnic_fcpio_status_to_str(hdr_status));
@@ -1291,7 +1290,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic, unsigned int cq_inde
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 	} else if (id & FNIC_TAG_ABORT) {
 		/* Completion of abort cmd */
-		shost_printk(KERN_DEBUG, fnic->lport->host,
+		shost_printk(KERN_DEBUG, fnic->host,
 			"hwq: %d mqtag: 0x%x tag: 0x%x Abort header status: %s\n",
 			hwq, mqtag, tag,
 			fnic_fcpio_status_to_str(hdr_status));
@@ -1306,7 +1305,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic, unsigned int cq_inde
 					&term_stats->terminate_fw_timeouts);
 			break;
 		case FCPIO_ITMF_REJECTED:
-			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				"abort reject recd. id %d\n",
 				(int)(id & FNIC_TAG_MASK));
 			break;
@@ -1341,7 +1340,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic, unsigned int cq_inde
 		if (!(fnic_priv(sc)->flags & (FNIC_IO_ABORTED | FNIC_IO_DONE)))
 			atomic64_inc(&misc_stats->no_icmnd_itmf_cmpls);
 
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 			      "abts cmpl recd. id %d status %s\n",
 			      (int)(id & FNIC_TAG_MASK),
 			      fnic_fcpio_status_to_str(hdr_status));
@@ -1354,11 +1353,11 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic, unsigned int cq_inde
 		if (io_req->abts_done) {
 			complete(io_req->abts_done);
 			spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
-			shost_printk(KERN_INFO, fnic->lport->host,
+			shost_printk(KERN_INFO, fnic->host,
 					"hwq: %d mqtag: 0x%x tag: 0x%x Waking up abort thread\n",
 					hwq, mqtag, tag);
 		} else {
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+			FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 				"hwq: %d mqtag: 0x%x tag: 0x%x hst: %s Completing IO\n",
 				hwq, mqtag,
 				tag, fnic_fcpio_status_to_str(hdr_status));
@@ -1389,7 +1388,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic, unsigned int cq_inde
 		}
 	} else if (id & FNIC_TAG_DEV_RST) {
 		/* Completion of device reset */
-		shost_printk(KERN_INFO, fnic->lport->host,
+		shost_printk(KERN_INFO, fnic->host,
 			"hwq: %d mqtag: 0x%x tag: 0x%x DR hst: %s\n",
 			hwq, mqtag,
 			tag, fnic_fcpio_status_to_str(hdr_status));
@@ -1401,7 +1400,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic, unsigned int cq_inde
 				  sc->device->host->host_no, id, sc,
 				  jiffies_to_msecs(jiffies - start_time),
 				  desc, 0, fnic_flags_and_state(sc));
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+			FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 				"hwq: %d mqtag: 0x%x tag: 0x%x hst: %s Terminate pending\n",
 				hwq, mqtag,
 				tag, fnic_fcpio_status_to_str(hdr_status));
@@ -1414,7 +1413,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic, unsigned int cq_inde
 				  sc->device->host->host_no, id, sc,
 				  jiffies_to_msecs(jiffies - start_time),
 				  desc, 0, fnic_flags_and_state(sc));
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+			FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 				"dev reset cmpl recd after time out. "
 				"id %d status %s\n",
 				(int)(id & FNIC_TAG_MASK),
@@ -1423,7 +1422,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic, unsigned int cq_inde
 		}
 		fnic_priv(sc)->state = FNIC_IOREQ_CMD_COMPLETE;
 		fnic_priv(sc)->flags |= FNIC_DEV_RST_DONE;
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			"hwq: %d mqtag: 0x%x tag: 0x%x hst: %s DR completion received\n",
 			hwq, mqtag,
 			tag, fnic_fcpio_status_to_str(hdr_status));
@@ -1432,7 +1431,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic, unsigned int cq_inde
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 
 	} else {
-		shost_printk(KERN_ERR, fnic->lport->host,
+		shost_printk(KERN_ERR, fnic->host,
 			"%s: Unexpected itmf io state: hwq: %d tag 0x%x %s\n",
 			__func__, hwq, id, fnic_ioreq_state_to_str(fnic_priv(sc)->state));
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
@@ -1487,7 +1486,7 @@ static int fnic_fcpio_cmpl_handler(struct vnic_dev *vdev,
 		break;
 
 	default:
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 			      "firmware completion type %d\n",
 			      desc->hdr.type);
 		break;
@@ -1548,7 +1547,7 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data)
 	io_req = fnic_priv(sc)->io_req;
 	if (!io_req) {
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"hwq: %d mqtag: 0x%x tag: 0x%x flags: 0x%x No ioreq. Returning\n",
 			hwq, mqtag, tag, fnic_priv(sc)->flags);
 		return true;
@@ -1586,7 +1585,7 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data)
 	mempool_free(io_req, fnic->io_req_pool);
 
 	sc->result = DID_TRANSPORT_DISRUPTED << 16;
-	FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 	"mqtag: 0x%x tag: 0x%x sc: 0x%p duration = %lu DID_TRANSPORT_DISRUPTED\n",
 		mqtag, tag, sc, (jiffies - start_time));
 
@@ -1618,12 +1617,12 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 	struct scsi_cmnd *sc = NULL;
 
 	io_count = fnic_count_all_ioreqs(fnic);
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 				  "Outstanding ioreq count: %d active io count: %lld Waiting\n",
 				  io_count,
 				  atomic64_read(&fnic->fnic_stats.io_stats.active_ios));
 
-	scsi_host_busy_iter(fnic->lport->host,
+	scsi_host_busy_iter(fnic->host,
 						fnic_cleanup_io_iter, fnic);
 
 	/* with sg3utils device reset, SC needs to be retrieved from ioreq */
@@ -1643,7 +1642,7 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[0], flags);
 
 	while ((io_count = fnic_count_all_ioreqs(fnic))) {
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 		  "Outstanding ioreq count: %d active io count: %lld Waiting\n",
 		  io_count,
 		  atomic64_read(&fnic->fnic_stats.io_stats.active_ios));
@@ -1670,7 +1669,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 	if (id >= fnic->fnic_max_tag_id)
 		return;
 
-	sc = scsi_host_find_tag(fnic->lport->host, id);
+	sc = scsi_host_find_tag(fnic->host, id);
 	if (!sc)
 		return;
 
@@ -1699,7 +1698,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 
 wq_copy_cleanup_scsi_cmd:
 	sc->result = DID_NO_CONNECT << 16;
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num, "wq_copy_cleanup_handler:"
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num, "wq_copy_cleanup_handler:"
 		      " DID_NO_CONNECT\n");
 
 	FNIC_TRACE(fnic_wq_copy_cleanup_handler,
@@ -1743,7 +1742,7 @@ static inline int fnic_queue_abort_io_req(struct fnic *fnic, int tag,
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 		atomic_dec(&fnic->in_flight);
 		atomic_dec(&tport->in_flight);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 			"fnic_queue_abort_io_req: failure: no descriptors\n");
 		atomic64_inc(&misc_stats->abts_cpwq_alloc_failures);
 		return 1;
@@ -1788,7 +1787,7 @@ static bool fnic_rport_abort_io_iter(struct scsi_cmnd *sc, void *data)
 	hwq = blk_mq_unique_tag_to_hwq(abt_tag);
 
 	if (!sc) {
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 					  "sc is NULL abt_tag: 0x%x hwq: %d\n", abt_tag, hwq);
 		return true;
 	}
@@ -1802,7 +1801,7 @@ static bool fnic_rport_abort_io_iter(struct scsi_cmnd *sc, void *data)
 
 	if ((fnic_priv(sc)->flags & FNIC_DEVICE_RESET) &&
 	    !(fnic_priv(sc)->flags & FNIC_DEV_RST_ISSUED)) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"hwq: %d abt_tag: 0x%x flags: 0x%x Device reset is not pending\n",
 			hwq, abt_tag, fnic_priv(sc)->flags);
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
@@ -1819,16 +1818,16 @@ static bool fnic_rport_abort_io_iter(struct scsi_cmnd *sc, void *data)
 	}
 
 	if (io_req->abts_done) {
-		shost_printk(KERN_ERR, fnic->lport->host,
+		shost_printk(KERN_ERR, fnic->host,
 			"fnic_rport_exch_reset: io_req->abts_done is set state is %s\n",
 			fnic_ioreq_state_to_str(fnic_priv(sc)->state));
 	}
 
 	if (!(fnic_priv(sc)->flags & FNIC_IO_ISSUED)) {
-		shost_printk(KERN_ERR, fnic->lport->host,
+		shost_printk(KERN_ERR, fnic->host,
 			"rport_exch_reset IO not yet issued %p abt_tag 0x%x",
 			sc, abt_tag);
-		shost_printk(KERN_ERR, fnic->lport->host,
+		shost_printk(KERN_ERR, fnic->host,
 			"flags %x state %d\n", fnic_priv(sc)->flags,
 			fnic_priv(sc)->state);
 	}
@@ -1839,11 +1838,13 @@ static bool fnic_rport_abort_io_iter(struct scsi_cmnd *sc, void *data)
 	if (fnic_priv(sc)->flags & FNIC_DEVICE_RESET) {
 		atomic64_inc(&reset_stats->device_reset_terminates);
 		abt_tag |= FNIC_TAG_DEV_RST;
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
+					  "dev reset sc 0x%p\n", sc);
 	}
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 		      "fnic_rport_exch_reset: dev rst sc 0x%p\n", sc);
 	WARN_ON_ONCE(io_req->abts_done);
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 		      "fnic_rport_reset_exch: Issuing abts\n");
 
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
@@ -1861,7 +1862,7 @@ static bool fnic_rport_abort_io_iter(struct scsi_cmnd *sc, void *data)
 		 * lun reset
 		 */
 		spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"hwq: %d abt_tag: 0x%x flags: 0x%x Queuing abort failed\n",
 			hwq, abt_tag, fnic_priv(sc)->flags);
 		if (fnic_priv(sc)->state == FNIC_IOREQ_ABTS_PENDING)
@@ -1892,7 +1893,7 @@ void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 		.term_cnt = 0,
 	};
 
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 				  "fnic rport exchange reset for tport: 0x%06x\n",
 				  port_id);
 
@@ -1900,7 +1901,7 @@ void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 		return;
 
 	io_count = fnic_count_ioreqs(fnic, port_id);
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 				  "Starting terminates: rport:0x%x  portid-io-count: %d active-io-count: %lld\n",
 				  port_id, io_count,
 				  atomic64_read(&fnic->fnic_stats.io_stats.active_ios));
@@ -1914,7 +1915,7 @@ void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 	}
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-	scsi_host_busy_iter(fnic->lport->host, fnic_rport_abort_io_iter,
+	scsi_host_busy_iter(fnic->host, fnic_rport_abort_io_iter,
 			    &iter_data);
 
 	if (iter_data.term_cnt > atomic64_read(&term_stats->max_terminates))
@@ -1925,7 +1926,7 @@ void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 	while ((io_count = fnic_count_ioreqs(fnic, port_id)))
 		schedule_timeout(msecs_to_jiffies(1000));
 
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 				  "rport: 0x%x remaining portid-io-count: %d ",
 				  port_id, io_count);
 }
@@ -1996,8 +1997,8 @@ void fnic_scsi_unload_cleanup(struct fnic *fnic)
 {
 	int hwq = 0;
 
-	fc_remove_host(fnic->lport->host);
-	scsi_remove_host(fnic->lport->host);
+	fc_remove_host(fnic->host);
+	scsi_remove_host(fnic->host);
 	for (hwq = 0; hwq < fnic->wq_copy_count; hwq++)
 		kfree(fnic->sw_copy_wq[hwq].io_req_table);
 }
@@ -2054,10 +2055,10 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	tport = rdd_data->tport;
 
 	if (!tport) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			  "Abort cmd called after tport delete! rport fcid: 0x%x",
 			  rport->port_id);
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			  "lun: %llu hwq: 0x%x mqtag: 0x%x Op: 0x%x flags: 0x%x\n",
 			  sc->device->lun, hwq, mqtag,
 			  sc->cmnd[0], fnic_priv(sc)->flags);
@@ -2066,18 +2067,18 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 		goto fnic_abort_cmd_end;
 	}
 
-	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 	  "Abort cmd called rport fcid: 0x%x lun: %llu hwq: 0x%x mqtag: 0x%x",
 	  rport->port_id, sc->device->lun, hwq, mqtag);
 
-	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				  "Op: 0x%x flags: 0x%x\n",
 				  sc->cmnd[0],
 				  fnic_priv(sc)->flags);
 
 	if (iport->state != FNIC_IPORT_STATE_READY) {
 		atomic64_inc(&fnic_stats->misc_stats.iport_not_ready);
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					  "iport NOT in READY state");
 		ret = FAILED;
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
@@ -2086,7 +2087,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 
 	if ((tport->state != FDLS_TGT_STATE_READY) &&
 		(tport->state != FDLS_TGT_STATE_ADISC)) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					  "tport state: %d\n", tport->state);
 		ret = FAILED;
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
@@ -2137,7 +2138,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	else
 		atomic64_inc(&abts_stats->abort_issued_greater_than_60_sec);
 
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 		"CDB Opcode: 0x%02x Abort issued time: %lu msec\n",
 		sc->cmnd[0], abt_issued_time);
 	/*
@@ -2228,7 +2229,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 
 	if (!(fnic_priv(sc)->flags & (FNIC_IO_ABORTED | FNIC_IO_DONE))) {
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			      "Issuing host reset due to out of order IO\n");
 
 		ret = FAILED;
@@ -2276,7 +2277,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 		  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
 		  fnic_flags_and_state(sc));
 
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 		      "Returning from abort cmd type %x %s\n", task_req,
 		      (ret == SUCCESS) ?
 		      "SUCCESS" : "FAILED");
@@ -2317,7 +2318,7 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
 		free_wq_copy_descs(fnic, wq, hwq);
 
 	if (!vnic_wq_copy_desc_avail(wq)) {
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 			  "queue_dr_io_req failure - no descriptors\n");
 		atomic64_inc(&misc_stats->devrst_cpwq_alloc_failures);
 		ret = -EAGAIN;
@@ -2385,7 +2386,7 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc, void *data)
 	 * Found IO that is still pending with firmware and
 	 * belongs to the LUN that we are resetting
 	 */
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 		      "Found IO in %s on lun\n",
 		      fnic_ioreq_state_to_str(fnic_priv(sc)->state));
 
@@ -2395,14 +2396,14 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc, void *data)
 	}
 	if ((fnic_priv(sc)->flags & FNIC_DEVICE_RESET) &&
 	    (!(fnic_priv(sc)->flags & FNIC_DEV_RST_ISSUED))) {
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			      "dev rst not pending sc 0x%p\n", sc);
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 		return true;
 	}
 
 	if (io_req->abts_done)
-		shost_printk(KERN_ERR, fnic->lport->host,
+		shost_printk(KERN_ERR, fnic->host,
 			     "%s: io_req->abts_done is set state is %s\n",
 			     __func__, fnic_ioreq_state_to_str(fnic_priv(sc)->state));
 	old_ioreq_state = fnic_priv(sc)->state;
@@ -2418,7 +2419,7 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc, void *data)
 	BUG_ON(io_req->abts_done);
 
 	if (fnic_priv(sc)->flags & FNIC_DEVICE_RESET) {
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			      "dev rst sc 0x%p\n", sc);
 	}
 
@@ -2440,7 +2441,7 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc, void *data)
 			fnic_priv(sc)->state = old_ioreq_state;
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 		iter_data->ret = FAILED;
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"hwq: %d abt_tag: 0x%lx Abort could not be queued\n",
 			hwq, abt_tag);
 		return false;
@@ -2519,7 +2520,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 
 	iter_data.lr_sc = lr_sc;
 
-	scsi_host_busy_iter(fnic->lport->host,
+	scsi_host_busy_iter(fnic->host,
 			    fnic_pending_aborts_iter, &iter_data);
 	if (iter_data.ret == FAILED) {
 		ret = iter_data.ret;
@@ -2532,7 +2533,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 		ret = 1;
 
 clean_pending_aborts_end:
-	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			"exit status: %d\n", ret);
 	return ret;
 }
@@ -2582,7 +2583,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	rport = starget_to_rport(scsi_target(sc->device));
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 		"fcid: 0x%x lun: %llu hwq: %d mqtag: 0x%x flags: 0x%x Device reset\n",
 		rport->port_id, sc->device->lun, hwq, mqtag,
 		fnic_priv(sc)->flags);
@@ -2590,7 +2591,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	rdd_data = rport->dd_data;
 	tport = rdd_data->tport;
 	if (!tport) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 		  "Dev rst called after tport delete! rport fcid: 0x%x lun: %llu\n",
 		  rport->port_id, sc->device->lun);
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
@@ -2599,7 +2600,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 	if (iport->state != FNIC_IPORT_STATE_READY) {
 		atomic64_inc(&fnic_stats->misc_stats.iport_not_ready);
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					  "iport NOT in READY state");
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		goto fnic_device_reset_end;
@@ -2607,7 +2608,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 	if ((tport->state != FDLS_TGT_STATE_READY) &&
 		(tport->state != FDLS_TGT_STATE_ADISC)) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					  "tport state: %d\n", tport->state);
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		goto fnic_device_reset_end;
@@ -2670,7 +2671,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	fnic_priv(sc)->lr_status = FCPIO_INVALID_CODE;
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num, "TAG %x\n", mqtag);
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num, "TAG %x\n", mqtag);
 
 	/*
 	 * issue the device reset, if enqueue failed, clean up the ioreq
@@ -2721,13 +2722,13 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	io_req = fnic_priv(sc)->io_req;
 	if (!io_req) {
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 				"io_req is null mqtag 0x%x sc 0x%p\n", mqtag, sc);
 		goto fnic_device_reset_end;
 	}
 
 	if (exit_dr) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					  "Host reset called for fnic. Exit device reset\n");
 		io_req->dr_done = NULL;
 		goto fnic_device_reset_clean;
@@ -2742,7 +2743,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	 */
 	if (status == FCPIO_INVALID_CODE) {
 		atomic64_inc(&reset_stats->device_reset_timeouts);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 			      "Device reset timed out\n");
 		fnic_priv(sc)->flags |= FNIC_DEV_RST_TIMED_OUT;
 		int_to_scsilun(sc->device->lun, &fc_lun);
@@ -2755,7 +2756,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	if (status != FCPIO_SUCCESS) {
 		spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
 		FNIC_SCSI_DBG(KERN_DEBUG,
-			      fnic->lport->host, fnic->fnic_num,
+			      fnic->host, fnic->fnic_num,
 			      "Device reset completed - failed\n");
 		io_req = fnic_priv(sc)->io_req;
 		goto fnic_device_reset_clean;
@@ -2771,7 +2772,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	if (fnic_clean_pending_aborts(fnic, sc, new_sc)) {
 		spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
 		io_req = fnic_priv(sc)->io_req;
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 					  "Device reset failed: Cannot abort all IOs\n");
 		goto fnic_device_reset_clean;
 	}
@@ -2825,13 +2826,13 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 			ret = FAILED;
 			break;
 		}
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					  "Cannot clean up all IOs for the LUN\n");
 		schedule_timeout(msecs_to_jiffies(1000));
 		count++;
 	}
 
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 		      "Returning from device reset %s\n",
 		      (ret == SUCCESS) ?
 		      "SUCCESS" : "FAILED");
@@ -2866,13 +2867,13 @@ void fnic_reset(struct Scsi_Host *shost)
 	fnic = *((struct fnic **) shost_priv(shost));
 	reset_stats = &fnic->fnic_stats.reset_stats;
 
-	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				  "Issuing fnic reset\n");
 
 	atomic64_inc(&reset_stats->fnic_resets);
 	fnic_post_flogo_linkflap(fnic);
 
-	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				  "Returning from fnic reset");
 
 	atomic64_inc(&reset_stats->fnic_reset_completions);
@@ -2883,7 +2884,7 @@ int fnic_issue_fc_host_lip(struct Scsi_Host *shost)
 	int ret = 0;
 	struct fnic *fnic = *((struct fnic **) shost_priv(shost));
 
-	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				  "FC host lip issued");
 
 	ret = fnic_host_reset(shost);
@@ -2909,7 +2910,7 @@ int fnic_host_reset(struct Scsi_Host *shost)
 		spin_lock_irqsave(&fnic->fnic_lock, flags);
 		if (fnic->reset_in_progress == IN_PROGRESS) {
 			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-			FNIC_SCSI_DBG(KERN_WARNING, fnic->lport->host, fnic->fnic_num,
+			FNIC_SCSI_DBG(KERN_WARNING, fnic->host, fnic->fnic_num,
 			  "Firmware reset in progress. Skipping another host reset\n");
 			return SUCCESS;
 		}
@@ -2947,7 +2948,7 @@ int fnic_host_reset(struct Scsi_Host *shost)
 	}
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				  "host reset return status: %d\n", ret);
 	return ret;
 }
@@ -2987,7 +2988,7 @@ static bool fnic_abts_pending_iter(struct scsi_cmnd *sc, void *data)
 	 * Found IO that is still pending with firmware and
 	 * belongs to the LUN that we are resetting
 	 */
-	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		"hwq: %d tag: 0x%x Found IO in state: %s on lun\n",
 		hwq, tag,
 		fnic_ioreq_state_to_str(fnic_priv(sc)->state));
@@ -3020,7 +3021,7 @@ int fnic_is_abts_pending(struct fnic *fnic, struct scsi_cmnd *lr_sc)
 	}
 
 	/* walk again to check, if IOs are still pending in fw */
-	scsi_host_busy_iter(fnic->lport->host,
+	scsi_host_busy_iter(fnic->host,
 			    fnic_abts_pending_iter, &iter_data);
 
 	return iter_data.ret;
@@ -3041,7 +3042,7 @@ int fnic_eh_host_reset_handler(struct scsi_cmnd *sc)
 	struct Scsi_Host *shost = sc->device->host;
 	struct fnic *fnic = *((struct fnic **) shost_priv(shost));
 
-	FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				  "SCSI error handling: fnic host reset");
 
 	ret = fnic_host_reset(shost);
@@ -3062,7 +3063,7 @@ void fnic_scsi_fcpio_reset(struct fnic *fnic)
 	if (unlikely(fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)) {
 		/* fw reset is in progress, poll for its completion */
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			  "fnic is in unexpected state: %d for fw_reset\n",
 			  fnic->state);
 		return;
@@ -3075,7 +3076,7 @@ void fnic_scsi_fcpio_reset(struct fnic *fnic)
 	fnic->fw_reset_done = &fw_reset_done;
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				  "Issuing fw reset\n");
 	if (fnic_fw_reset_handler(fnic)) {
 		spin_lock_irqsave(&fnic->fnic_lock, flags);
@@ -3083,14 +3084,14 @@ void fnic_scsi_fcpio_reset(struct fnic *fnic)
 			fnic->state = old_state;
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 	} else {
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					  "Waiting for fw completion\n");
 		time_remain = wait_for_completion_timeout(&fw_reset_done,
 						  msecs_to_jiffies(FNIC_FW_RESET_TIMEOUT));
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					  "Woken up after fw completion timeout\n");
 		if (time_remain == 0) {
-			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				  "FW reset completion timed out after %d ms)\n",
 				  FNIC_FW_RESET_TIMEOUT);
 		}
-- 
2.31.1

