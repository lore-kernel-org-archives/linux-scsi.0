Received: from alln-iport-7.cisco.com (alln-iport-7.cisco.com [173.37.142.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D1A3A1A8;
	Fri,  9 Aug 2024 16:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723222293; cv=none; b=PpPr7KJMAps9JLYU1UpVaU8oXtvMAVH6ABSpifOTSrYYLmVa0AzT6OibQuWfgDXdCyIalMVm6FBgW7hTSuZ/XxH+dlXEOaIQtE0oA4ZjHOWJXCq+UkbjUJcjh/bAUDjrsSYc1uAHIUD2in7Vsv3TJAvHtrINfQL6cXh2LgHHvfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723222293; c=relaxed/simple;
	bh=KUGsapUA+vADq/Jrzom60Xn7Vc0mRXZ47o/Yc5P/T5M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UJC869W3rdlT6VunlTWBruTUT7PCpZIH6qTlDtSkxN8pKnEU4IpAb9GgtGygN9WY2qP81Z9LRRnTzYA0qqkJwl+S6R+OA95f7sHkH5aeQNyHFtbQrV4j+S8rK8UjFWewtRa7/8niH22xB5r1YzGsuJVkrMczVmI5aUjsVHH0NFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=RNqOaXun; arc=none smtp.client-ip=173.37.142.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="RNqOaXun"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=160838; q=dns/txt;
  s=iport; t=1723222286; x=1724431886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=usOiTpqyXFfZHIxrX18c54xrgBsaD8iO1ApDmudqYBs=;
  b=RNqOaXunWdkh9HXGzgnoo/vWXYpKRrncDJvYyy5ds2xtWPmDdDlpAJZr
   utmZW4Q8SGk4Xonmg4C0oCvzoqeBMHRNX4/NAhNanfdcJr7zAGwTHYhTa
   2jby3dGw8BxpJfeiS2jkSjKMb/riPOs4KcJkgdlUSMMLvcLuqaWnrTQlw
   c=;
X-CSE-ConnectionGUID: azD6ra0iQGOFwtCrYfWJ5w==
X-CSE-MsgGUID: pZgyGMiGR82SAbH8Oo0ZKA==
X-IronPort-AV: E=Sophos;i="6.09,276,1716249600"; 
   d="scan'208";a="329539449"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by alln-iport-7.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 16:51:25 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPSA id 479Ggo2h031305
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 9 Aug 2024 16:51:24 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v2 12/14] scsi: fnic: Code cleanup
Date: Fri,  9 Aug 2024 09:42:38 -0700
Message-Id: <20240809164240.47561-13-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240809164240.47561-1-kartilak@cisco.com>
References: <20240809164240.47561-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: rcdn-core-5.cisco.com

Replace existing host structure with fnic host.
Add headers from scsi to support new functionality.
Remove unused code and declarations.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fdls_disc.c    | 508 +++++++++++++++----------------
 drivers/scsi/fnic/fip.c          |  78 ++---
 drivers/scsi/fnic/fnic.h         |  11 +-
 drivers/scsi/fnic/fnic_debugfs.c |   2 +-
 drivers/scsi/fnic/fnic_fcs.c     | 126 ++++----
 drivers/scsi/fnic/fnic_isr.c     |  28 +-
 drivers/scsi/fnic/fnic_main.c    |  13 +-
 drivers/scsi/fnic/fnic_scsi.c    | 197 ++++++------
 8 files changed, 481 insertions(+), 482 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 6b27d23625b5..73ff9f803c87 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -286,7 +286,7 @@ static void fdls_free_tgt_oxid(struct fnic_iport_s *iport, uint16_t oxid)
 	struct fnic *fnic = iport->fnic;
 
 	if (iport->tgt_oxid_pool[oxid - FDLS_PLOGI_OXID_BASE] != 1) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Freeing unused OXID: 0x%x", oxid);
 	}
 	iport->tgt_oxid_pool[oxid - FDLS_PLOGI_OXID_BASE] = 0;
@@ -318,7 +318,7 @@ fdls_start_fabric_timer(struct fnic_iport_s *iport, int timeout)
 	struct fnic *fnic = iport->fnic;
 
 	if (iport->fabric.timer_pending) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "iport fcid: 0x%x: Canceling fabric disc timer\n",
 					 iport->fcid);
 		fnic_del_fabric_timer_sync(fnic);
@@ -331,7 +331,7 @@ fdls_start_fabric_timer(struct fnic_iport_s *iport, int timeout)
 	fabric_tov = jiffies + msecs_to_jiffies(timeout);
 	mod_timer(&iport->fabric.retry_timer, round_jiffies(fabric_tov));
 	iport->fabric.timer_pending = 1;
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "fabric timer is %d ", timeout);
 }
 
@@ -343,7 +343,7 @@ fdls_start_tport_timer(struct fnic_iport_s *iport,
 	struct fnic *fnic = iport->fnic;
 
 	if (tport->timer_pending) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "tport fcid 0x%x: Canceling disc timer\n",
 					 tport->fcid);
 		fnic_del_tport_timer_sync(fnic, tport);
@@ -417,7 +417,7 @@ fdls_send_tport_abts(struct fnic_iport_s *iport,
 
 	tport_abts->ox_id = tport->oxid_used;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FDLS sending tport abts: tport->state: %d ",
 				 tport->state);
 
@@ -487,7 +487,7 @@ static void fdls_send_fabric_abts(struct fnic_iport_s *iport)
 	default:
 		return;
 	}
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FDLS sending fabric abts. iport->fabric.state: %d",
 				 iport->fabric.state);
 
@@ -504,7 +504,7 @@ static void fdls_send_fabric_flogi(struct fnic_iport_s *iport)
 	struct fc_els_s flogi;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS send fabric FLOGI", iport->fcid);
 
 	memcpy(&flogi, &fnic_flogi_req, sizeof(struct fc_els_s));
@@ -527,7 +527,7 @@ static void fdls_send_fabric_plogi(struct fnic_iport_s *iport)
 	uint8_t fcid[3];
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS send fabric PLOGI", iport->fcid);
 
 	memcpy(&plogi, &fnic_plogi_req, sizeof(struct fc_els_s));
@@ -553,7 +553,7 @@ static void fdls_send_fdmi_plogi(struct fnic_iport_s *iport)
 	struct fnic *fnic = iport->fnic;
 	u64 fdmi_tov;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "fcid: 0x%x: FDLS send FDMI PLOGI", iport->fcid);
 
 	memcpy(&plogi, &fnic_plogi_req, sizeof(plogi));
@@ -581,7 +581,7 @@ static void fdls_send_rpn_id(struct fnic_iport_s *iport)
 	uint8_t fcid[3];
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS send RPN ID", iport->fcid);
 
 	memcpy(&rpn_id, &fnic_rpn_id_req, sizeof(struct fc_rpn_id_s));
@@ -603,7 +603,7 @@ static void fdls_send_scr(struct fnic_iport_s *iport)
 	uint8_t fcid[3];
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS send SCR", iport->fcid);
 
 	memcpy(&scr_req, &fnic_scr_req, sizeof(struct fc_scr_s));
@@ -623,7 +623,7 @@ static void fdls_send_gpn_ft(struct fnic_iport_s *iport, int fdls_state)
 	uint8_t fcid[3];
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS send GPN FT", iport->fcid);
 
 	memcpy(&gpn_ft, &fnic_gpn_ft_req, sizeof(struct fc_gpn_ft_s));
@@ -658,7 +658,7 @@ fdls_send_tgt_adisc(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 
 	oxid = htons(fdls_alloc_tgt_oxid(iport, FDLS_ADISC_OXID_BASE));
 	if (oxid == 0xFFFF) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Failed to allocate OXID to send ADISC %p", iport);
 		return;
 	}
@@ -673,7 +673,7 @@ fdls_send_tgt_adisc(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 	memcpy(adisc.fcid, s_id, 3);
 	adisc.command = ELS_ADISC;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "sending ADISC to tgt fcid: 0x%x", tport->fcid);
 
 	atomic64_inc(&iport->iport_stats.tport_adisc_sent);
@@ -701,7 +701,7 @@ void fdls_delete_tport(struct fnic_iport_s *iport,
 	tport->flags |= FNIC_FDLS_TPORT_TERMINATING;
 
 	if (tport->timer_pending) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "tport fcid 0x%x: Canceling disc timer\n",
 					 tport->fcid);
 		fnic_del_tport_timer_sync(fnic, tport);
@@ -717,7 +717,7 @@ void fdls_delete_tport(struct fnic_iport_s *iport,
 			tport_del_evt =
 				kzalloc(sizeof(struct fnic_tport_event_s), GFP_ATOMIC);
 			if (!tport_del_evt) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Failed to allocate memory for tport fcid: 0x%0x\n",
 					 tport->fcid);
 				return;
@@ -727,7 +727,7 @@ void fdls_delete_tport(struct fnic_iport_s *iport,
 			list_add_tail(&tport_del_evt->links, &fnic->tport_event_list);
 			queue_work(fnic_event_queue, &fnic->tport_work);
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "tport 0x%x not reg with scsi_transport. Freeing locally",
 				 tport->fcid);
 			list_del(&tport->links);
@@ -746,7 +746,7 @@ fdls_send_tgt_plogi(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 	struct fnic *fnic = iport->fnic;
 	uint32_t timeout;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Send tgt PLOGI to fcid: 0x%x", tport->fcid);
 
 	memcpy(&plogi, &fnic_plogi_req, sizeof(struct fc_els_s));
@@ -760,13 +760,13 @@ fdls_send_tgt_plogi(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 
 	oxid = htons(fdls_alloc_tgt_oxid(iport, FDLS_PLOGI_OXID_BASE));
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
@@ -794,7 +794,7 @@ fnic_fc_plogi_rsp_rdf(struct fnic_iport_s *iport,
 		 FNIC_FC_C3_RDF);
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "MFS: b2b_rdf_size: 0x%x spc3_rdf_size: 0x%x",
 			 b2b_rdf_size, spc3_rdf_size);
 
@@ -807,7 +807,7 @@ static void fdls_send_register_fc4_types(struct fnic_iport_s *iport)
 	uint8_t fcid[3];
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS sending FC4 Types", iport->fcid);
 
 	memset(&rft_id, 0, sizeof(struct fc_rft_id));
@@ -830,7 +830,7 @@ static void fdls_send_register_fc4_features(struct fnic_iport_s *iport)
 	uint8_t fcid[3];
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS sending FC4 features", iport->fcid);
 	memcpy(&rff_id, &fnic_rff_id_req, sizeof(struct fc_rff_id));
 
@@ -842,7 +842,7 @@ static void fdls_send_register_fc4_features(struct fnic_iport_s *iport)
 	if (IS_FNIC_FCP_INITIATOR(fnic)) {
 		rff_id.fc4_type = 0x08;
 	} else {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "0x%x: Unknown type", iport->fcid);
 	}
 
@@ -860,16 +860,16 @@ fdls_send_tgt_prli(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 	struct fnic *fnic = iport->fnic;
 	uint32_t timeout;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FDLS sending PRLI to tgt: 0x%x", tport->fcid);
 
 	oxid = htons(fdls_alloc_tgt_oxid(iport, FDLS_PRLI_OXID_BASE));
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
 
@@ -908,7 +908,7 @@ void fdls_send_fabric_logo(struct fnic_iport_s *iport)
 	uint8_t d_id[3] = { 0xFF, 0xFF, 0xFE };
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Sending logo to fabric from iport->fcid: 0x%x",
 				 iport->fcid);
 	memcpy(&logo, &fnic_logo_req, sizeof(struct fc_logo_req_s));
@@ -947,7 +947,7 @@ void fdls_tgt_logout(struct fnic_iport_s *iport,
 	uint8_t d_id[3];
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Sending logo to tport fcid: 0x%x", tport->fcid);
 	memcpy(&logo, &fnic_logo_req, sizeof(struct fc_logo_req_s));
 
@@ -971,7 +971,7 @@ static void fdls_tgt_discovery_start(struct fnic_iport_s *iport)
 	u32 old_link_down_cnt = iport->fnic->link_down_cnt;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: Starting FDLS target discovery", iport->fcid);
 
 	list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
@@ -1024,7 +1024,7 @@ static void fdls_target_restart_nexus(struct fnic_tport_s *tport)
 	int nexus_restart_count;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "tport fcid: 0x%x state: %d restart_count: %d",
 				 tport->fcid, tport->state, tport->nexus_restart_count);
 
@@ -1035,7 +1035,7 @@ static void fdls_target_restart_nexus(struct fnic_tport_s *tport)
 	fdls_delete_tport(iport, tport);
 
 	if (nexus_restart_count >= FNIC_TPORT_MAX_NEXUS_RESTART) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Exceeded nexus restart retries tport: 0x%x", fcid);
 		return;
 	}
@@ -1051,7 +1051,7 @@ static void fdls_target_restart_nexus(struct fnic_tport_s *tport)
 	 */
 	new_tport = fdls_create_tport(iport, fcid, wwpn);
 	if (!new_tport) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Error creating new tport: 0x%x", fcid);
 		return;
 	}
@@ -1080,12 +1080,12 @@ static struct fnic_tport_s *fdls_create_tport(struct fnic_iport_s *iport,
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
@@ -1098,12 +1098,12 @@ static struct fnic_tport_s *fdls_create_tport(struct fnic_iport_s *iport,
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
@@ -1207,7 +1207,7 @@ static void fdls_fdmi_register_pa(struct fnic_iport_s *iport)
 	fdmi_rpa.current_speed = htonl(port_speed_bm);
 	fdmi_rpa.fc4_type[2] = 1;
 	snprintf(fdmi_rpa.os_name, sizeof(fdmi_rpa.os_name) - 1, "host%d",
-			 fnic->lport->host->host_no);
+			 fnic->host->host_no);
 	snprintf(fdmi_rpa.host_name, sizeof(fdmi_rpa.host_name) - 1, "%s",
 			 utsname()->nodename);
 	fnic_send_fcoe_frame(iport, &fdmi_rpa, sizeof(struct fc_fdmi_rpa_s));
@@ -1221,7 +1221,7 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 	struct fnic *fnic = iport->fnic;
 	unsigned long flags;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "tp: %d fab state: %d fab retry counter: %d max_flogi_retries: %d",
 		 iport->fabric.timer_pending, iport->fabric.state,
 		 iport->fabric.retry_counter, iport->max_flogi_retries);
@@ -1236,7 +1236,7 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 	if (iport->fabric.del_timer_inprogress) {
 		iport->fabric.del_timer_inprogress = 0;
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "fabric_del_timer inprogress(%d). Skip timer cb",
 					 iport->fabric.del_timer_inprogress);
 		return;
@@ -1264,7 +1264,7 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 				iport->fabric.flags &= ~FNIC_FDLS_FABRIC_ABORT_ISSUED;
 				fdls_send_fabric_flogi(iport);
 			} else
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "Exceeded max FLOGI retries");
 		}
 		break;
@@ -1286,7 +1286,7 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 				iport->fabric.flags &= ~FNIC_FDLS_FABRIC_ABORT_ISSUED;
 				fdls_send_fabric_plogi(iport);
 			} else
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "Exceeded max PLOGI retries");
 		}
 		break;
@@ -1314,7 +1314,7 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 			fdls_send_fabric_abts(iport);
 		else {
 			/* ABTS has timed out (2*ra_tov), we give up */
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "ABTS timed out. Starting PLOGI: %p", iport);
 			fnic_fdls_start_plogi(iport);
 		}
@@ -1330,7 +1330,7 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 			fdls_send_fabric_abts(iport);
 		} else {
 			/* ABTS has timed out (2*ra_tov), we give up */
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "ABTS timed out. Starting PLOGI: %p", iport);
 			fnic_fdls_start_plogi(iport);	/* go back to fabric Plogi */
 		}
@@ -1346,7 +1346,7 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 			fdls_send_fabric_abts(iport);
 		else {
 			/* ABTS has timed out (2*ra_tov), we give up */
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "ABTS timed out. Starting PLOGI %p", iport);
 			fnic_fdls_start_plogi(iport);	/* go back to fabric Plogi */
 		}
@@ -1370,7 +1370,7 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 			if (iport->fabric.retry_counter < FDLS_RETRY_COUNT) {
 				fdls_send_gpn_ft(iport, iport->fabric.state);
 			} else {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "ABTS timeout for fabric GPN_FT. Check name server: %p",
 					 iport);
 			}
@@ -1391,7 +1391,7 @@ void fdls_fdmi_timer_callback(struct timer_list *t)
 
 	if (iport->fabric.fdmi_retry < 7) {
 		iport->fabric.fdmi_retry++;
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "retry fdmi timer %d", iport->fabric.fdmi_retry);
 		fdls_send_fdmi_plogi(iport);
 	} else {
@@ -1410,7 +1410,7 @@ static void fdls_send_delete_tport_msg(struct fnic_tport_s *tport)
 
 	tport_del_evt = kzalloc(sizeof(struct fnic_tport_event_s), GFP_ATOMIC);
 	if (!tport_del_evt) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Failed to allocate memory for tport event fcid: 0x%x",
 			 tport->fcid);
 		return;
@@ -1443,13 +1443,13 @@ static void fdls_tport_timer_callback(struct timer_list *t)
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
@@ -1515,14 +1515,14 @@ static void fdls_tport_timer_callback(struct timer_list *t)
 		} else {
 			/* exceeded retry count */
 			fdls_free_tgt_oxid(iport, oxid);
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
@@ -1574,26 +1574,26 @@ fdls_process_tgt_adisc_rsp(struct fnic_iport_s *iport,
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
 	if (ntohs(fchdr->ox_id) != ntohs(tport->oxid_used)) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Dropping frame from target: 0x%x",
 			 tgt_fcid);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Reason: Stale ADISC/Aborted ADISC/OOO frame delivery");
 		return;
 	}
@@ -1602,7 +1602,7 @@ fdls_process_tgt_adisc_rsp(struct fnic_iport_s *iport,
 	case ELS_LS_ACC:
 		atomic64_inc(&iport->iport_stats.tport_adisc_ls_accepts);
 		if (tport->timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "tport 0x%p Canceling fabric disc timer\n",
 						 tport);
 			fnic_del_tport_timer_sync(fnic, tport);
@@ -1614,12 +1614,12 @@ fdls_process_tgt_adisc_rsp(struct fnic_iport_s *iport,
 		frame_wwnn = get_unaligned_be64(&adisc_rsp->node_name);
 		frame_wwpn = get_unaligned_be64(&adisc_rsp->nport_name);
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
@@ -1629,14 +1629,14 @@ fdls_process_tgt_adisc_rsp(struct fnic_iport_s *iport,
 		if (((els_rjt->reason_code == FC_ELS_RJT_LOGICAL_BUSY)
 			 || (els_rjt->reason_code == FC_ELS_RJT_BUSY))
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
 			oxid = ntohs(fchdr->ox_id);
@@ -1664,26 +1664,26 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
 	fcid = FNIC_GET_S_ID(fchdr);
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
 			 "PLOGI rsp recvd in wrong state. Restarting nexus");
 		oxid = ntohs(FNIC_GET_OX_ID(fchdr));
 		fdls_free_tgt_oxid(iport, oxid);
@@ -1692,7 +1692,7 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
 	}
 
 	if (ntohs(fchdr->ox_id) != ntohs(tport->oxid_used)) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "PLOGI response from target: 0x%x. Dropping frame",
 			 tgt_fcid);
 		return;
@@ -1701,7 +1701,7 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
 	switch (plogi_rsp->command) {
 	case ELS_LS_ACC:
 		atomic64_inc(&iport->iport_stats.tport_plogi_ls_accepts);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "PLOGI accepted by target: 0x%x", tgt_fcid);
 		oxid = ntohs(FNIC_GET_OX_ID(fchdr));
 		fdls_free_tgt_oxid(iport, oxid);
@@ -1712,14 +1712,14 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
 		if (((els_rjt->reason_code == FC_ELS_RJT_LOGICAL_BUSY)
 			 || (els_rjt->reason_code == FC_ELS_RJT_BUSY))
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
 		oxid = ntohs(fchdr->ox_id);
@@ -1729,18 +1729,18 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
 
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
@@ -1758,13 +1758,13 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
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
@@ -1793,12 +1793,12 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 	fcid = FNIC_GET_S_ID(fchdr);
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
@@ -1806,14 +1806,14 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 
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
 					 "PRLI rsp recvd in wrong state. Restarting nexus");
 		oxid = ntohs(FNIC_GET_OX_ID(fchdr));
 		fdls_free_tgt_oxid(iport, oxid);
@@ -1822,10 +1822,10 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 	}
 
 	if (ntohs(fchdr->ox_id) != ntohs(tport->oxid_used)) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Dropping PRLI response from target: 0x%x ",
 			 tgt_fcid);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Reason: Stale PRLI response/Aborted PDISC/OOO frame delivery");
 		return;
 	}
@@ -1833,13 +1833,13 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 	switch (prli_rsp->command) {
 	case ELS_LS_ACC:
 		atomic64_inc(&iport->iport_stats.tport_prli_ls_accepts);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "PRLI accepted from target: 0x%x", tgt_fcid);
 		oxid = ntohs(FNIC_GET_OX_ID(fchdr));
 		fdls_free_tgt_oxid(iport, oxid);
 
 		if (prli_rsp->sp.type != FC_FC4_TYPE_SCSI) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "mismatched target zoned with FC SCSI initiator: 0x%x",
 				 tgt_fcid);
 			mismatched_tgt = true;
@@ -1857,7 +1857,7 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 			 || (els_rjt->reason_code == FC_ELS_RJT_BUSY))
 			&& (tport->retry_counter < FDLS_RETRY_COUNT)) {
 
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "PRLI ret ELS_LS_RJT BUSY. Retry from timer routine: 0x%x",
 				 tgt_fcid);
 
@@ -1865,7 +1865,7 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 			tport->flags |= FNIC_FDLS_RETRY_FRAME;
 			return;
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "PRLI returned ELS_LS_RJT from target: 0x%x",
 						 tgt_fcid);
 
@@ -1879,18 +1879,18 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 
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
@@ -1909,7 +1909,7 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 
 	/* Check if the device plays Target Mode Function */
 	if (!(tport->fcp_csp & FCP_PRLI_FUNC_TARGET)) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Remote port(0x%x): no target support. Deleting it\n",
 			 tgt_fcid);
 		fdls_tgt_logout(iport, tport);
@@ -1922,14 +1922,14 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
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
@@ -1947,21 +1947,21 @@ fdls_process_rff_id_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 	uint8_t reason_code;
 
 	if (fdls_get_state(fdls) != FDLS_STATE_REGISTER_FC4_FEATURES) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "RFF_ID resp recvd in state(%d). Dropping.",
 					 fdls_get_state(fdls));
 		return;
 	}
 
 	rsp = FNIC_GET_FC_CT_CMD((&rff_rsp->fc_ct_hdr));
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS process RFF ID response: 0x%04x", iport->fcid,
 				 (uint32_t) rsp);
 
 	switch (rsp) {
 	case FC_CT_ACC:
 		if (iport->fabric.timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Canceling fabric disc timer %p\n", iport);
 			fnic_del_fabric_timer_sync(fnic);
 		}
@@ -1975,17 +1975,17 @@ fdls_process_rff_id_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 		if (((reason_code == FC_CT_RJT_LOGICAL_BUSY)
 			 || (reason_code == FC_CT_RJT_BUSY))
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
 					 "RFF_ID returned ELS_LS_RJT. Halting discovery %p", iport);
 			if (iport->fabric.timer_pending) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "Canceling fabric disc timer %p\n", iport);
 				fnic_del_fabric_timer_sync(fnic);
 			}
@@ -2008,21 +2008,21 @@ fdls_process_rft_id_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 	struct fnic *fnic = iport->fnic;
 
 	if (fdls_get_state(fdls) != FDLS_STATE_REGISTER_FC4_TYPES) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "RFT_ID resp recvd in state(%d). Dropping.",
 					 fdls_get_state(fdls));
 		return;
 	}
 
 	rsp = FNIC_GET_FC_CT_CMD((&rft_rsp->fc_ct_hdr));
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS process RFT ID response: 0x%04x", iport->fcid,
 				 (uint32_t) rsp);
 
 	switch (rsp) {
 	case FC_CT_ACC:
 		if (iport->fabric.timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Canceling fabric disc timer %p\n", iport);
 			fnic_del_fabric_timer_sync(fnic);
 		}
@@ -2036,19 +2036,19 @@ fdls_process_rft_id_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 		if (((reason_code == FC_CT_RJT_LOGICAL_BUSY)
 			 || (reason_code == FC_CT_RJT_BUSY))
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
 				 rft_rsp->fc_ct_hdr.reason_expl);
 			if (iport->fabric.timer_pending) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "Canceling fabric disc timer %p\n", iport);
 				fnic_del_fabric_timer_sync(fnic);
 			}
@@ -2071,21 +2071,21 @@ fdls_process_rpn_id_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 	struct fnic *fnic = iport->fnic;
 
 	if (fdls_get_state(fdls) != FDLS_STATE_RPN_ID) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "RPN_ID resp recvd in state(%d). Dropping.",
 					 fdls_get_state(fdls));
 		return;
 	}
 
 	rsp = FNIC_GET_FC_CT_CMD((&rpn_rsp->fc_ct_hdr));
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS process RPN ID response: 0x%04x", iport->fcid,
 				 (uint32_t) rsp);
 
 	switch (rsp) {
 	case FC_CT_ACC:
 		if (iport->fabric.timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Canceling fabric disc timer %p\n", iport);
 			fnic_del_fabric_timer_sync(fnic);
 		}
@@ -2099,17 +2099,17 @@ fdls_process_rpn_id_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 		if (((reason_code == FC_CT_RJT_LOGICAL_BUSY)
 			 || (reason_code == FC_CT_RJT_BUSY))
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
@@ -2130,12 +2130,12 @@ fdls_process_scr_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 	struct fc_els_reject_s *els_rjt = (struct fc_els_reject_s *) fchdr;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FDLS process SCR response: 0x%04x",
 				 (uint32_t) scr_rsp->command);
 
 	if (fdls_get_state(fdls) != FDLS_STATE_SCR) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "SCR resp recvd in state(%d). Dropping.",
 					 fdls_get_state(fdls));
 		return;
@@ -2145,7 +2145,7 @@ fdls_process_scr_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 	case ELS_LS_ACC:
 		atomic64_inc(&iport->iport_stats.fabric_scr_ls_accepts);
 		if (iport->fabric.timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Canceling fabric disc timer %p\n", iport);
 			fnic_del_fabric_timer_sync(fnic);
 		}
@@ -2159,17 +2159,17 @@ fdls_process_scr_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 		if (((els_rjt->reason_code == FC_ELS_RJT_LOGICAL_BUSY)
 			 || (els_rjt->reason_code == FC_ELS_RJT_BUSY))
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
 							 "Canceling fabric disc timer %p\n", iport);
 				fnic_del_fabric_timer_sync(fnic);
 			}
@@ -2197,7 +2197,7 @@ fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *iport,
 	u32 old_link_down_cnt = iport->fnic->link_down_cnt;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS process GPN_FT tgt list", iport->fcid);
 
 	gpn_ft_tgt =
@@ -2212,7 +2212,7 @@ fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *iport,
 		fcid = ntoh24(gpn_ft_tgt->fcid);
 		wwpn = ntohll(gpn_ft_tgt->wwpn);
 
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "tport: 0x%x: ctrl:0x%x", fcid, gpn_ft_tgt->ctrl);
 
 		if (fcid == iport->fcid) {
@@ -2259,7 +2259,7 @@ fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *iport,
 		rem_len -= sizeof(struct fc_gpn_ft_rsp_iu_s);
 	}
 	if (rem_len <= 0) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "GPN_FT response: malformed/corrupt frame rxlen: %d remlen: %d",
 			 len, rem_len);
 	}
@@ -2269,7 +2269,7 @@ fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *iport,
 		list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
 
 			if (!(tport->flags & FNIC_FDLS_TPORT_IN_GPN_FT_LIST)) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Remove port: 0x%x not found in GPN_FT list",
 					 tport->fcid);
 				fdls_delete_tport(iport, tport);
@@ -2297,7 +2297,7 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 	u32 old_link_down_cnt = iport->fnic->link_down_cnt;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FDLS process GPN_FT response: iport state: %d len: %d",
 				 iport->state, len);
 
@@ -2317,7 +2317,7 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 			  && ((fdls_get_state(fdls) == FDLS_STATE_RSCN_GPN_FT)
 				  || (fdls_get_state(fdls) == FDLS_STATE_SEND_GPNFT)
 				  || (fdls_get_state(fdls) == FDLS_STATE_TGT_DISCOVERY))))) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "GPNFT resp recvd in fab state(%d) iport_state(%d). Dropping.",
 			 fdls_get_state(fdls), iport->state);
 		return;
@@ -2329,10 +2329,10 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 	switch (rsp) {
 
 	case FC_CT_ACC:
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "0x%x: GPNFT_RSP accept", iport->fcid);
 		if (iport->fabric.timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "0x%x: Canceling fabric disc timer\n",
 						 iport->fcid);
 			fnic_del_fabric_timer_sync(fnic);
@@ -2347,7 +2347,7 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 		 * that will be taken care in next link up event
 		 */
 		if (iport->state != FNIC_IPORT_STATE_READY) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Halting target discovery: fab st: %d iport st: %d ",
 				 fdls_get_state(fdls), iport->state);
 			break;
@@ -2357,22 +2357,22 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 
 	case FC_CT_REJ:
 		reason_code = gpn_ft_rsp->fc_ct_hdr.reason_code;
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "0x%x: GPNFT_RSP Reject", iport->fcid);
 
 		if (((reason_code == FC_CT_RJT_LOGICAL_BUSY)
 			 || (reason_code == FC_CT_RJT_BUSY))
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
@@ -2386,7 +2386,7 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 			count = 0;
 			list_for_each_entry_safe(tport, next, &iport->tport_list,
 									 links) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "GPN_FT_REJECT: Remove port: 0x%x",
 							 tport->fcid);
 				fdls_delete_tport(iport, tport);
@@ -2396,7 +2396,7 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 				}
 				count++;
 			}
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "GPN_FT_REJECT: Removed (0x%x) ports", count);
 		}
 		break;
@@ -2421,7 +2421,7 @@ fdls_process_fabric_logo_rsp(struct fnic_iport_s *iport,
 	switch (flogo_rsp->command) {
 	case ELS_LS_ACC:
 		if (iport->fabric.state != FDLS_STATE_FABRIC_LOGO) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Flogo response. Fabric not in LOGO state. Dropping! %p",
 				 iport);
 			return;
@@ -2431,25 +2431,25 @@ fdls_process_fabric_logo_rsp(struct fnic_iport_s *iport,
 		iport->state = FNIC_IPORT_STATE_LINK_WAIT;
 
 		if (iport->fabric.timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-						 "lport 0x%p Canceling fabric disc timer\n",
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+						 "iport 0x%p Canceling fabric disc timer\n",
 						 iport);
 			fnic_del_fabric_timer_sync(fnic);
 		}
 		iport->fabric.timer_pending = 0;
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Flogo response from Fabric for did: 0x%x",
 					 ntoh24(fchdr->did));
 		return;
 
 	case ELS_LS_RJT:
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Flogo response from Fabric for did: 0x%x returned ELS_LS_RJT",
 			 ntoh24(fchdr->did));
 		return;
 
 	default:
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "FLOGO response not accepted or rejected: 0x%x",
 					 flogo_rsp->command);
 	}
@@ -2467,11 +2467,11 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
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
@@ -2481,7 +2481,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 	case ELS_LS_ACC:
 		atomic64_inc(&iport->iport_stats.fabric_flogi_ls_accepts);
 		if (iport->fabric.timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "iport fcid: 0x%x Canceling fabric disc timer\n",
 						 iport->fcid);
 			fnic_del_fabric_timer_sync(fnic);
@@ -2491,7 +2491,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 		iport->fabric.retry_counter = 0;
 		fcid = FNIC_GET_D_ID(fchdr);
 		iport->fcid = ntoh24(fcid);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "0x%x: FLOGI response accepted", iport->fcid);
 
 		/* Learn the Service Params */
@@ -2501,7 +2501,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 			iport->max_payload_size = MIN(rdf_size,
 								  iport->max_payload_size);
 
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "max_payload_size from fabric: %d set: %d", rdf_size,
 					 iport->max_payload_size);
 
@@ -2511,26 +2511,26 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 		if (flogi_rsp->u.csp_flogi.features & FNIC_FC_EDTOV_NSEC)
 			iport->e_d_tov = iport->e_d_tov / FNIC_NSEC_TO_MSEC;
 
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "From fabric: R_A_TOV: %d E_D_TOV: %d",
 					 iport->r_a_tov, iport->e_d_tov);
 
 		if (IS_FNIC_FCP_INITIATOR(fnic)) {
-			fc_host_fabric_name(iport->fnic->lport->host) =
+			fc_host_fabric_name(iport->fnic->host) =
 				get_unaligned_be64(&flogi_rsp->node_name);
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
@@ -2538,7 +2538,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 
 		if (fdls_get_state(fabric) == FDLS_STATE_FABRIC_FLOGI) {
 			fnic_fdls_start_plogi(iport);
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "FLOGI response received. Starting PLOGI");
 		} else {
 			/* From FDLS_STATE_FABRIC_FLOGI state fabric can only go to
@@ -2546,7 +2546,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 			 * state, hence we don't have to worry about undoing:
 			 * the fnic_fdls_register_portid and vnic_dev_add_addr
 			 */
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FLOGI response received in state (%d). Dropping frame",
 				 fdls_get_state(fabric));
 		}
@@ -2556,7 +2556,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 		atomic64_inc(&iport->iport_stats.fabric_flogi_ls_rejects);
 		els_rjt = (struct fc_els_reject_s *) fchdr;
 		if (fabric->retry_counter < iport->max_flogi_retries) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FLOGI returned ELS_LS_RJT BUSY. Retry from timer routine %p",
 				 iport);
 
@@ -2564,10 +2564,10 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 			fabric->flags |= FNIC_FDLS_RETRY_FRAME;
 
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "FLOGI returned ELS_LS_RJT. Halting discovery %p", iport);
 			if (iport->fabric.timer_pending) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "iport 0x%p Canceling fabric disc timer\n",
 							 iport);
 				fnic_del_fabric_timer_sync(fnic);
@@ -2578,7 +2578,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 		break;
 
 	default:
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "FLOGI response not accepted: 0x%x",
 					 flogi_rsp->command);
 		atomic64_inc(&iport->iport_stats.fabric_flogi_misc_rejects);
@@ -2595,7 +2595,7 @@ fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 	struct fnic *fnic = iport->fnic;
 
 	if (fdls_get_state((&iport->fabric)) != FDLS_STATE_FABRIC_PLOGI) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Fabric PLOGI response received in state (%d). Dropping frame",
 			 fdls_get_state(&iport->fabric));
 		return;
@@ -2605,7 +2605,7 @@ fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 	case ELS_LS_ACC:
 		atomic64_inc(&iport->iport_stats.fabric_plogi_ls_accepts);
 		if (iport->fabric.timer_pending) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "iport fcid: 0x%x fabric PLOGI response: Accepted\n",
 				 iport->fcid);
 			fnic_del_fabric_timer_sync(fnic);
@@ -2620,15 +2620,15 @@ fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 		if (((els_rjt->reason_code == FC_ELS_RJT_LOGICAL_BUSY)
 			 || (els_rjt->reason_code == FC_ELS_RJT_BUSY))
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
@@ -2639,7 +2639,7 @@ fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 		}
 		break;
 	default:
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "PLOGI response not accepted: 0x%x",
 					 plogi_rsp->command);
 		atomic64_inc(&iport->iport_stats.fabric_plogi_misc_rejects);
@@ -2660,9 +2660,9 @@ static void fdls_process_fdmi_plogi_rsp(struct fnic_iport_s *iport,
 		iport->fabric.fdmi_pending = 0;
 		switch (plogi_rsp->command) {
 		case ELS_LS_ACC:
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FDLS process fdmi PLOGI response status: ELS_LS_ACC\n");
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Sending fdmi registration for port 0x%x\n",
 				 iport->fcid);
 
@@ -2673,7 +2673,7 @@ static void fdls_process_fdmi_plogi_rsp(struct fnic_iport_s *iport,
 			iport->fabric.fdmi_pending = 2;
 			break;
 		case ELS_LS_RJT:
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Fabric FDMI PLOGI returned ELS_LS_RJT reason: 0x%x",
 				 els_rjt->reason_code);
 
@@ -2697,13 +2697,13 @@ static void fdls_process_fdmi_reg_ack(struct fnic_iport_s *iport,
 
 	if (iport->fabric.fdmi_pending > 0) {
 		iport->fabric.fdmi_pending--;
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "iport fcid: 0x%x: Received FDMI registration ack\n",
 					 iport->fcid);
 
 		if (iport->fabric.fdmi_pending == 0) {
 			del_timer_sync(&iport->fabric.fdmi_timer);
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "iport fcid: 0x%x: Canceling FDMI timer\n",
 						 iport->fcid);
 		}
@@ -2725,14 +2725,14 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 
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
@@ -2740,11 +2740,11 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 	iport->fabric.flags &= ~FNIC_FDLS_FABRIC_ABORT_ISSUED;
 
 	if (fchdr->r_ctl == FNIC_BA_ACC_RCTL) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Received abts rsp BA_ACC for fabric_state: %d OX_ID: 0x%x",
 			 fabric_state, ba_acc->ox_id);
 	} else if (fchdr->r_ctl == FNIC_BA_RJT_RCTL) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "BA_RJT fs: %d OX_ID: 0x%x rc: 0x%x rce: 0x%x",
 			 fabric_state, ba_rjt->fchdr.ox_id,
 			 ba_rjt->reason_code, ba_rjt->reason_explanation);
@@ -2757,10 +2757,10 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
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
 				 fchdr->ox_id);
 		}
@@ -2770,7 +2770,7 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 			if (!RETRIES_EXHAUSTED(iport))
 				fdls_send_fabric_logo(iport);
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Unknown abts rsp OX_ID: 0x%x FABRIC_FLOGI state. Drop frame",
 				 fchdr->ox_id);
 		}
@@ -2780,10 +2780,10 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
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
 				 fchdr->ox_id);
 		}
@@ -2798,7 +2798,7 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 				fnic_fdls_start_plogi(iport);
 			}
 		} else {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Unknown abts rsp OX_ID: 0x%x RPN_ID state. Drop frame",
 				 fchdr->ox_id);
 		}
@@ -2809,13 +2809,13 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
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
 				 fchdr->ox_id);
 		}
@@ -2825,13 +2825,13 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
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
 				 fchdr->ox_id);
 		}
@@ -2841,13 +2841,13 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
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
 				 fchdr->ox_id);
 		}
@@ -2858,12 +2858,12 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
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
 				 fchdr->ox_id);
 		}
@@ -2884,7 +2884,7 @@ fdls_process_abts_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 	struct fnic *fnic = iport->fnic;
 
 	nport_id = ntoh24(fchdr->sid);
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Received abort from SID %8x", nport_id);
 
 	tport = fnic_find_tport_by_fcid(iport, nport_id);
@@ -2920,7 +2920,7 @@ fdls_process_unsupported_els_req(struct fnic_iport_s *iport,
 	memcpy(&ls_rsp, &fnic_els_rjt, sizeof(struct fc_els_reject_s));
 
 	if (iport->fcid != d_id) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Dropping unsupported ELS with illegal frame bits 0x%x\n",
 			 d_id);
 		atomic64_inc(&iport->iport_stats.unsupported_frames_dropped);
@@ -2929,14 +2929,14 @@ fdls_process_unsupported_els_req(struct fnic_iport_s *iport,
 
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
 				 ntoh24(fchdr->sid));
 	/* We don't support this ELS request, send a reject */
@@ -2960,12 +2960,12 @@ fdls_process_rls_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
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
@@ -3005,32 +3005,32 @@ fdls_process_els_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 
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
@@ -3076,18 +3076,18 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 
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
@@ -3100,14 +3100,14 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 	/*This abort rsp is for ADISC */
 	if ((oxid >= FDLS_ADISC_OXID_BASE) && (oxid < FDLS_TGT_OXID_POOL_END)) {
 		if (fchdr->r_ctl == FNIC_BA_ACC_RCTL) {
-			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				 "OX_ID: 0x%x tgt_fcid: 0x%x rcvd tgt adisc abts resp BA_ACC",
 				 ba_acc->ox_id, tport->fcid);
 		} else if (fchdr->r_ctl == FNIC_BA_RJT_RCTL) {
-			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				 "ADISC BA_RJT rcvd tport_fcid: 0x%x tport_state: %d ",
 				 tport->fcid, tport_state);
-			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				 "reason code: 0x%x reason code explanation:0x%x ",
 				 ba_rjt->reason_code, ba_rjt->reason_explanation);
 		}
@@ -3118,7 +3118,7 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 			return;
 		}
 		fdls_free_tgt_oxid(iport, oxid);
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					 "ADISC not responding. Deleting target port: 0x%x",
 					 tport->fcid);
 		fdls_delete_tport(iport, tport);
@@ -3134,14 +3134,14 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 	/*This abort rsp is for PLOGI */
 	if ((oxid >= FDLS_PLOGI_OXID_BASE) && (oxid < FDLS_PRLI_OXID_BASE)) {
 		if (fchdr->r_ctl == FNIC_BA_ACC_RCTL) {
-			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				 "Received tgt PLOGI abts response BA_ACC tgt_fcid: 0x%x",
 				 tport->fcid);
 		} else if (fchdr->r_ctl == FNIC_BA_RJT_RCTL) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "PLOGI BA_RJT received for tport_fcid: 0x%x OX_ID: 0x%x",
 				 tport->fcid, fchdr->ox_id);
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "reason code: 0x%x reason code explanation: 0x%x",
 				  ba_rjt->reason_code, ba_rjt->reason_explanation);
 		}
@@ -3165,14 +3165,14 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 	/*This abort rsp is for PRLI */
 	if ((oxid >= FDLS_PRLI_OXID_BASE) && (oxid < FDLS_ADISC_OXID_BASE)) {
 		if (fchdr->r_ctl == FNIC_BA_ACC_RCTL) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: Received tgt PRLI abts response BA_ACC",
 				 tport->fcid);
 		} else if (fchdr->r_ctl == FNIC_BA_RJT_RCTL) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "PRLI BA_RJT received for tport_fcid: 0x%x OX_ID: 0x%x ",
 				 tport->fcid, fchdr->ox_id);
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "reason code: 0x%x reason code explanation: 0x%x",
 				 ba_rjt->reason_code,
 				 ba_rjt->reason_explanation);
@@ -3189,7 +3189,7 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 		return;
 	}
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Received ABTS response for unknown frame %p", iport);
 }
 
@@ -3204,19 +3204,19 @@ fdls_process_plogi_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 	memcpy(&plogi_rsp, &fnic_els_rjt, sizeof(struct fc_els_reject_s));
 
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
 				 ntoh24(fchdr->sid));
 
@@ -3249,11 +3249,11 @@ fdls_process_logo_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 	nport_id = ntoh24(logo->fcid);
 	nport_name = logo->wwpn;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Process LOGO request from fcid: 0x%x", nport_id);
 
 	if (iport->state != FNIC_IPORT_STATE_READY) {
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			 "Dropping LOGO req from 0x%x in iport state: %d",
 			 nport_id, iport->state);
 		return;
@@ -3263,19 +3263,19 @@ fdls_process_logo_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 
 	if (!tport) {
 		/* We are not logged in with the nport, log and drop... */
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					 "Received LOGO from an nport not logged in: 0x%x",
 					 nport_id);
 		return;
 	}
 	if (tport->fcid != nport_id) {
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					 "Received LOGO with invalid target port fcid: 0x%x",
 					 nport_id);
 		return;
 	}
 	if (tport->timer_pending) {
-		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					 "tport fcid 0x%x: Canceling disc timer\n",
 					 tport->fcid);
 		fnic_del_tport_timer_sync(fnic, tport);
@@ -3292,7 +3292,7 @@ fdls_process_logo_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 		if ((iport->state == FNIC_IPORT_STATE_READY)
 			&& (fdls_get_state(&iport->fabric) != FDLS_STATE_SEND_GPNFT)
 			&& (fdls_get_state(&iport->fabric) != FDLS_STATE_RSCN_GPN_FT)) {
-			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 						 "Sending GPNFT in response to LOGO from Target:0x%x",
 						 nport_id);
 			fdls_send_gpn_ft(iport, FDLS_STATE_SEND_GPNFT);
@@ -3305,7 +3305,7 @@ fdls_process_logo_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 		fdls_send_logo_resp(iport, &logo->fchdr);
 		if ((fdls_get_state(&iport->fabric) != FDLS_STATE_SEND_GPNFT) &&
 			(fdls_get_state(&iport->fabric) != FDLS_STATE_RSCN_GPN_FT)) {
-			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 						 "Sending GPNFT in response to LOGO from Target:0x%x",
 						 nport_id);
 			fdls_send_gpn_ft(iport, FDLS_STATE_SEND_GPNFT);
@@ -3328,11 +3328,11 @@ fdls_process_rscn(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 
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
@@ -3343,21 +3343,21 @@ fdls_process_rscn(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 	if ((rscn->payload_len % 4 != 0) || (rscn->payload_len < 8)
 		|| (rscn->payload_len > 1024) || (rscn->page_len != 4)) {
 		num_ports = 0;
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "RSCN payload_len: 0x%x page_len: 0x%x",
 					 rscn->payload_len, rscn->page_len);
 		/* if this happens then we need to send ADISC to all the tports. */
 		list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
 			if (tport->state == FDLS_TGT_STATE_READY)
 				tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "RSCN for port id: 0x%x", tport->fcid);
 		}
 	} else {
 		num_ports = (rscn->payload_len - 4) / rscn->page_len;
 		rscn_port = (struct fc_rscn_port_s *) (rscn + 1);
 	}
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "RSCN received for num_ports: %d payload_len: %d page_len: %d ",
 			 num_ports, rscn->payload_len, rscn->page_len);
 
@@ -3372,7 +3372,7 @@ fdls_process_rscn(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 		memcpy(fcid, rscn_port->port_id, 3);
 
 		nport_id = ntoh24(fcid);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "RSCN event: 0x%x for 0x%x", rscn_port->rscn_evt_q,
 					 nport_id);
 		rscn_port++;
@@ -3384,14 +3384,14 @@ fdls_process_rscn(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
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
@@ -3402,7 +3402,7 @@ fdls_process_rscn(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 			tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
 	}
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FDLS process RSCN sending GPN_FT %p", iport);
 	fdls_send_gpn_ft(iport, FDLS_STATE_RSCN_GPN_FT);
 	fdls_send_rscn_resp(iport, fchdr);
@@ -3413,8 +3413,8 @@ void fnic_fdls_disc_start(struct fnic_iport_s *iport)
 	struct fnic *fnic = iport->fnic;
 
 	if (IS_FNIC_FCP_INITIATOR(fnic)) {
-		fc_host_fabric_name(iport->fnic->lport->host) = 0;
-		fc_host_post_event(iport->fnic->lport->host, fc_get_event_number(),
+		fc_host_fabric_name(iport->fnic->host) = 0;
+		fc_host_post_event(iport->fnic->host, fc_get_event_number(),
 						   FCH_EVT_LIPRESET, 0);
 	}
 
@@ -3445,20 +3445,20 @@ fdls_process_adisc_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 	uint16_t oxid;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Process ADISC request %d", iport->fnic->fnic_num);
 
 	fcid = FNIC_GET_S_ID(fchdr);
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
@@ -3469,10 +3469,10 @@ fdls_process_adisc_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 
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
 
@@ -3536,7 +3536,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 	if (iport->fcid)
 		if (fdls_get_state(fabric) > FDLS_STATE_FABRIC_FLOGI) {
 			if ((iport->fcid != d_id) || (!FNIC_FC_FRAME_CS_CTL(fchdr))) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "invalid frame received. Dropping frame");
 				return -1;
 			}
@@ -3546,7 +3546,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 	if ((fchdr->r_ctl == FNIC_BA_ACC_RCTL)
 		|| (fchdr->r_ctl == FNIC_BA_RJT_RCTL)) {
 		if (!(FNIC_FC_FRAME_TYPE_BLS(fchdr))) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Received ABTS invalid frame. Dropping frame");
 			return -1;
 
@@ -3554,7 +3554,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 		return FNIC_BLS_ABTS_RSP;
 	}
 	if ((fchdr->r_ctl == FC_ABTS_RCTL) && (FNIC_FC_FRAME_TYPE_BLS(fchdr))) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Receiving Abort Request from s_id: 0x%x", s_id);
 		return FNIC_BLS_ABTS_REQ;
 	}
@@ -3566,7 +3566,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 			if ((!FNIC_FC_FRAME_FCTL_FIRST_LAST_SEQINIT(fchdr))
 				|| (!FNIC_FC_FRAME_UNSOLICITED(fchdr))
 				|| (!FNIC_FC_FRAME_TYPE_ELS(fchdr))) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "Received LOGO invalid frame. Dropping frame");
 				return -1;
 			}
@@ -3575,7 +3575,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 			if ((!FNIC_FC_FRAME_FCTL_FIRST_LAST_SEQINIT(fchdr))
 				|| (!FNIC_FC_FRAME_TYPE_ELS(fchdr))
 				|| (!FNIC_FC_FRAME_UNSOLICITED(fchdr))) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "Received RSCN invalid FCTL. Dropping frame");
 				return -1;
 			}
@@ -3593,7 +3593,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 		case ELS_RRQ:
 			return FNIC_ELS_RRQ;
 		default:
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Unsupported frame (type:0x%02x) from fcid: 0x%x",
 				 type, s_id);
 			return FNIC_ELS_UNSUPPORTED_REQ;
@@ -3604,7 +3604,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 	if ((ntohs(oxid) >= FDLS_PLOGI_OXID_BASE)
 		&& (ntohs(oxid) < FDLS_PRLI_OXID_BASE)) {
 		if (!FNIC_FC_FRAME_TYPE_ELS(fchdr)) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				"Dropping Unknown frame in PLOGI exchange range type: 0x%x.",
 				fchdr->type);
 			return -1;
@@ -3614,7 +3614,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 	if ((ntohs(oxid) >= FDLS_PRLI_OXID_BASE)
 		&& (ntohs(oxid) < FDLS_ADISC_OXID_BASE)) {
 		if (!FNIC_FC_FRAME_TYPE_ELS(fchdr)) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				"Dropping Unknown frame in PRLI exchange range type: 0x%x.",
 				fchdr->type);
 			return -1;
@@ -3625,7 +3625,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 	if ((ntohs(oxid) >= FDLS_ADISC_OXID_BASE)
 		&& (ntohs(oxid) < FDLS_TGT_OXID_POOL_END)) {
 		if (!FNIC_FC_FRAME_TYPE_ELS(fchdr)) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				"Dropping Unknown frame in ADISC exchange range type: 0x%x.",
 				fchdr->type);
 			return -1;
@@ -3646,7 +3646,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 		if (type == ELS_LS_ACC) {
 			if ((s_id != FC_DOMAIN_CONTR)
 				|| (!FNIC_FC_FRAME_TYPE_ELS(fchdr))) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Received unknown frame. Dropping frame");
 				return -1;
 			}
@@ -3657,7 +3657,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 		if (type == ELS_LS_ACC) {
 			if ((s_id != FC_DIR_SERVER)
 				|| (!FNIC_FC_FRAME_TYPE_ELS(fchdr))) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Received unknown frame. Dropping frame");
 				return -1;
 			}
@@ -3674,7 +3674,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 		if (type == ELS_LS_ACC) {
 			if ((s_id != FC_FABRIC_CONTROLLER)
 				|| (!FNIC_FC_FRAME_TYPE_ELS(fchdr))) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Received unknown frame. Dropping frame");
 				return -1;
 			}
@@ -3683,21 +3683,21 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 
 	case FNIC_RPN_REQ_OXID:
 		if ((s_id != FC_DIR_SERVER) || (!FNIC_FC_FRAME_TYPE_FC_GS(fchdr))) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Received unknown frame. Dropping frame");
 			return -1;
 		}
 		return FNIC_FABRIC_RPN_RSP;
 	case FNIC_RFT_REQ_OXID:
 		if ((s_id != FC_DIR_SERVER) || (!FNIC_FC_FRAME_TYPE_FC_GS(fchdr))) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Received unknown frame. Dropping frame");
 			return -1;
 		}
 		return FNIC_FABRIC_RFT_RSP;
 	case FNIC_RFF_REQ_OXID:
 		if ((s_id != FC_DIR_SERVER) || (!FNIC_FC_FRAME_TYPE_FC_GS(fchdr))) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Received unknown frame. Dropping frame");
 			return -1;
 		}
@@ -3705,7 +3705,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 
 	case FNIC_GPN_FT_OXID:
 		if ((s_id != FC_DIR_SERVER) || (!FNIC_FC_FRAME_TYPE_FC_GS(fchdr))) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Received unknown frame. Dropping frame");
 			return -1;
 		}
@@ -3713,7 +3713,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 
 	default:
 		/* Drop the Rx frame and log/stats it */
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Solicited response: unknown OXID: 0x%x", oxid);
 		return -1;
 	}
@@ -3779,7 +3779,7 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 		break;
 	case FNIC_TPORT_LOGO_RSP:
 		/* Logo response from tgt which we have deleted */
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Logo response from tgt: 0x%x",
 					 ntoh24(fchdr->sid));
 		break;
@@ -3824,7 +3824,7 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 		fdls_process_fdmi_reg_ack(iport, fchdr);
 		break;
 	default:
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Received unknown FCoE frame of len: %d. Dropping frame", len);
 		break;
 	}
@@ -3842,7 +3842,7 @@ void fnic_fdls_link_down(struct fnic_iport_s *iport)
 	struct fnic_tport_s *tport, *next;
 	struct fnic *fnic = iport->fnic;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS processing link down", iport->fcid);
 
 	fdls_set_state((&iport->fabric), FDLS_STATE_LINKDOWN);
@@ -3855,7 +3855,7 @@ void fnic_fdls_link_down(struct fnic_iport_s *iport)
 		fdls_init_tgt_oxid_pool(iport);
 
 		list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "removing rport: 0x%x", tport->fcid);
 			fdls_delete_tport(iport, tport);
 		}
@@ -3866,7 +3866,7 @@ void fnic_fdls_link_down(struct fnic_iport_s *iport)
 		iport->fabric.fdmi_pending = 0;
 	}
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "0x%x: FDLS finish processing link down", iport->fcid);
 }
 
diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
index 22898b037cd6..e40b82dc94d0 100644
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
 
@@ -100,11 +100,11 @@ void fnic_fcoe_process_vlan_resp(struct fnic *fnic,
 	struct fip_vlan_desc_s *vlan_desc;
 	unsigned long flags;
 
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "fnic 0x%p got vlan resp\n", fnic);
 
 	desc_len = ntohs(vlan_notif->fip.desc_len);
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "desc_len %d\n", desc_len);
 
 	spin_lock_irqsave(&fnic->vlans_lock, flags);
@@ -117,20 +117,20 @@ void fnic_fcoe_process_vlan_resp(struct fnic *fnic,
 
 		if (vlan_desc->type == FIP_TYPE_VLAN) {
 			if (vlan_desc->len != 1) {
-				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Invalid descriptor length(%x) in VLan response\n",
 					 vlan_desc->len);
 
 			}
 			num_vlan++;
 			vid = ntohs(vlan_desc->vlan);
-			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "process_vlan_resp: FIP VLAN %d\n", vid);
 			vlan = kzalloc(sizeof(*vlan), GFP_ATOMIC);
 
 			if (!vlan) {
 				/* retry from timer */
-				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "Mem Alloc failure\n");
 				spin_unlock_irqrestore(&fnic->vlans_lock, flags);
 				goto out;
@@ -140,7 +140,7 @@ void fnic_fcoe_process_vlan_resp(struct fnic *fnic,
 			list_add_tail(&vlan->list, &fnic->vlan_list);
 			break;
 		} else {
-			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Invalid descriptor type(%x) in VLan response\n",
 				 vlan_desc->type);
 			/*
@@ -155,7 +155,7 @@ void fnic_fcoe_process_vlan_resp(struct fnic *fnic,
 	/* any VLAN descriptors present ? */
 	if (num_vlan == 0) {
 		atomic64_inc(&fnic_stats->vlan_stats.resp_withno_vlanID);
-		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "fnic 0x%p No VLAN descriptors in FIP VLAN response\n",
 					 fnic);
 	}
@@ -178,7 +178,7 @@ void fnic_fcoe_start_fcf_discovery(struct fnic *fnic)
 	int fr_len;
 	struct fip_discovery_s disc_sol;
 
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "fnic 0x%p start fcf discovery\n", fnic);
 	fr_len = sizeof(struct fip_discovery_s);
 	memset(iport->selected_fcf.fcf_mac, 0, ETH_ALEN);
@@ -196,7 +196,7 @@ void fnic_fcoe_start_fcf_discovery(struct fnic *fnic)
 	fcs_tov = jiffies + msecs_to_jiffies(FCOE_CTLR_FCS_TOV);
 	mod_timer(&fnic->retry_fip_timer, round_jiffies(fcs_tov));
 
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "fnic 0x%p Started FCF discovery", fnic);
 
 }
@@ -227,14 +227,14 @@ void fnic_fcoe_fip_discovery_resp(struct fnic *fnic,
 	switch (iport->fip.state) {
 	case FDLS_FIP_FCF_DISCOVERY_STARTED:
 		if (ntohs(disc_adv->fip.flags) & FIP_FLAG_S) {
-			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "fnic 0x%p Solicited adv\n", fnic);
 
 			if ((disc_adv->prio_desc.priority <
 				 iport->selected_fcf.fcf_priority)
 				&& (ntohs(disc_adv->fip.flags) & FIP_FLAG_A)) {
 
-				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "fnic 0x%p FCF Available\n", fnic);
 				memcpy(iport->selected_fcf.fcf_mac, disc_adv->mac_desc.mac,
 					   ETH_ALEN);
@@ -242,7 +242,7 @@ void fnic_fcoe_fip_discovery_resp(struct fnic *fnic,
 					disc_adv->prio_desc.priority;
 				iport->selected_fcf.fka_adv_period =
 					ntohl(disc_adv->fka_adv_desc.fka_adv);
-				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "adv time %d",
 							 iport->selected_fcf.fka_adv_period);
 				iport->selected_fcf.ka_disabled =
@@ -260,7 +260,7 @@ void fnic_fcoe_fip_discovery_resp(struct fnic *fnic,
 					!= ntohl(disc_adv->fka_adv_desc.fka_adv)) {
 					iport->selected_fcf.fka_adv_period =
 						ntohl(disc_adv->fka_adv_desc.fka_adv);
-					FNIC_FIP_DBG(KERN_INFO, fnic->lport->host,
+					FNIC_FIP_DBG(KERN_INFO, fnic->host,
 						 fnic->fnic_num, "change fka to %d",
 						 iport->selected_fcf.fka_adv_period);
 				}
@@ -320,7 +320,7 @@ void fnic_fcoe_start_flogi(struct fnic *fnic)
 	u64 flogi_tov;
 
 	fr_len = sizeof(struct fip_flogi_s);
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "fnic 0x%p Start fip FLOGI\n", fnic);
 
 	memcpy(&flogi_req, &fip_flogi_tmpl, fr_len);
@@ -357,11 +357,11 @@ void fnic_fcoe_process_flogi_resp(struct fnic *fnic,
 
 	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
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
@@ -372,7 +372,7 @@ void fnic_fcoe_process_flogi_resp(struct fnic *fnic,
 		 && (flogi_rsp->rsp_desc.len == 36))
 		|| !((flogi_rsp->mac_desc.type == 2)
 			 && (flogi_rsp->mac_desc.len == 2))) {
-		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Dropping frame invalid type and len mix\n");
 		return;
 	}
@@ -383,7 +383,7 @@ void fnic_fcoe_process_flogi_resp(struct fnic *fnic,
 		|| (s_id != 0xFFFFFE)
 		|| (flogi_rsp->rsp_desc.els.fchdr.ox_id != FNIC_FLOGI_OXID)
 		|| (flogi_rsp->rsp_desc.els.fchdr.type != 0x01)) {
-		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Dropping invalid frame: s_id %x F %x R %x t %x OX_ID %x\n",
 			 s_id,
 			 flogi_rsp->rsp_desc.els.fchdr.f_ctl,
@@ -394,7 +394,7 @@ void fnic_fcoe_process_flogi_resp(struct fnic *fnic,
 	}
 
 	if (iport->fip.state == FDLS_FIP_FLOGI_STARTED) {
-		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "fnic 0x%p rsp for pending FLOGI\n", fnic);
 
 		del_timer_sync(&fnic->retry_fip_timer);
@@ -402,7 +402,7 @@ void fnic_fcoe_process_flogi_resp(struct fnic *fnic,
 		if ((ntohs(flogi_rsp->fip.desc_len) == 38)
 			&& (flogi_rsp->rsp_desc.els.command == ELS_LS_ACC)) {
 
-			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "fnic 0x%p FLOGI success\n", fnic);
 			memcpy(iport->fpma, flogi_rsp->mac_desc.mac, ETH_ALEN);
 			iport->fcid = ntoh24(flogi_rsp->rsp_desc.els.fchdr.did);
@@ -416,7 +416,7 @@ void fnic_fcoe_process_flogi_resp(struct fnic *fnic,
 			vnic_dev_add_addr(fnic->vdev, flogi_rsp->mac_desc.mac);
 
 			if (fnic_fdls_register_portid(iport, iport->fcid, NULL) != 0) {
-				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 							 "fnic 0x%p flogi registration failed\n",
 							 fnic);
 				return;
@@ -424,7 +424,7 @@ void fnic_fcoe_process_flogi_resp(struct fnic *fnic,
 
 			iport->fip.state = FDLS_FIP_FLOGI_COMPLETE;
 			iport->state = FNIC_IPORT_STATE_FABRIC_DISC;
-			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "iport->state:%d\n", iport->state);
 			fnic_fdls_disc_start(iport);
 			if (!((iport->selected_fcf.ka_disabled)
@@ -465,7 +465,7 @@ void fnic_common_fip_cleanup(struct fnic *fnic)
 
 	if (!iport->usefip)
 		return;
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "fnic 0x%p fip cleanup\n", fnic);
 
 	iport->fip.state = FDLS_FIP_INIT;
@@ -507,7 +507,7 @@ void fnic_fcoe_process_cvl(struct fnic *fnic, struct fip_header_s *fiph)
 	int found = false;
 	int max_count = 0;
 
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "fnic 0x%p clear virtual link handler\n", fnic);
 
 	if (!
@@ -515,7 +515,7 @@ void fnic_fcoe_process_cvl(struct fnic *fnic, struct fip_header_s *fiph)
 		 && (cvl_msg->fcf_mac_desc.len == 2))
 || !((cvl_msg->name_desc.type == 4) && (cvl_msg->name_desc.len == 3))) {
 
-		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "invalid mix: ft %x fl %x ndt %x ndl %x",
 			 cvl_msg->fcf_mac_desc.type, cvl_msg->fcf_mac_desc.len,
 			 cvl_msg->name_desc.type, cvl_msg->name_desc.len);
@@ -528,7 +528,7 @@ void fnic_fcoe_process_cvl(struct fnic *fnic, struct fip_header_s *fiph)
 			if (!((cvl_msg->vn_ports_desc[i].type == 11)
 				  && (cvl_msg->vn_ports_desc[i].len == 5))) {
 
-				FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Invalid type and len mix type: %d len: %d\n",
 					 cvl_msg->vn_ports_desc[i].type,
 					 cvl_msg->vn_ports_desc[i].len);
@@ -550,12 +550,12 @@ void fnic_fcoe_process_cvl(struct fnic *fnic, struct fip_header_s *fiph)
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
@@ -604,7 +604,7 @@ void fnic_work_on_fip_timer(struct work_struct *work)
 	struct fnic *fnic = container_of(work, struct fnic, fip_timer_work);
 	struct fnic_iport_s *iport = &fnic->iport;
 
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FIP timeout\n");
 
 	if (iport->fip.state == FDLS_FIP_VLAN_DISCOVERY_STARTED) {
@@ -612,7 +612,7 @@ void fnic_work_on_fip_timer(struct work_struct *work)
 	} else if (iport->fip.state == FDLS_FIP_FCF_DISCOVERY_STARTED) {
 		u8 zmac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
 
-		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "FCF Discovery timeout\n");
 		if (memcmp(iport->selected_fcf.fcf_mac, zmac, ETH_ALEN) != 0) {
 
@@ -632,12 +632,12 @@ void fnic_work_on_fip_timer(struct work_struct *work)
 				mod_timer(&fnic->fcs_ka_timer, round_jiffies(fcf_tov));
 			}
 		} else {
-			FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "FCF Discovery timeout\n");
 			fnic_vlan_discovery_timeout(fnic);
 		}
 	} else if (iport->fip.state == FDLS_FIP_FLOGI_STARTED) {
-		FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "FLOGI timeout\n");
 		if (iport->fip.flogi_retry < fnic->config.flogi_retries)
 			fnic_fcoe_start_flogi(fnic);
@@ -813,7 +813,7 @@ void fnic_work_on_fcs_ka_timer(struct work_struct *work)
 	*fnic = container_of(work, struct fnic, fip_timer_work);
 	struct fnic_iport_s *iport = &fnic->iport;
 
-	FNIC_FIP_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FIP_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "fnic 0x%p fcs ka timeout\n", fnic);
 
 	fnic_common_fip_cleanup(fnic);
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 9f712e552064..11b36c7f681e 100644
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
index 8cf7e4364114..ae886823bc70 100644
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
@@ -324,7 +325,7 @@ void fnic_handle_frame(struct work_struct *work)
 		 */
 		if (fnic->state != FNIC_IN_FC_MODE &&
 			fnic->state != FNIC_IN_ETH_MODE) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Cannot process frame in transitional state\n");
 			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 			return;
@@ -354,7 +355,7 @@ void fnic_handle_fip_frame(struct work_struct *work)
 	struct fnic *fnic = container_of(work, struct fnic, fip_frame_work);
 
 	fnic_stats = &fnic->fnic_stats;
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Processing FIP frame\n");
 
 	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
@@ -433,7 +434,7 @@ void fnic_update_mac_locked(struct fnic *fnic, u8 *new)
 	if (ether_addr_equal(data, new))
 		return;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Update MAC: %u\n", *new);
 
 	if (!is_zero_ether_addr(data) && !ether_addr_equal(data, ctl))
@@ -503,7 +504,7 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 
 		if (!fcs_ok) {
 			atomic64_inc(&fnic_stats->misc_stats.frame_errors);
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 						 "fnic 0x%p fcs error.  Dropping packet.\n", fnic);
 			goto drop;
 		}
@@ -513,21 +514,21 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
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
@@ -537,7 +538,7 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	if (fnic->stop_rx_link_events) {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "fnic->stop_rx_link_events: %d\n",
 					 fnic->stop_rx_link_events);
 		goto drop;
@@ -549,7 +550,7 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 		kzalloc(sizeof(struct fnic_frame_list),
 						   GFP_ATOMIC);
 	if (!frame_elem) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Unable to alloc frame element of size: %ld\n",
 					 sizeof(struct fnic_frame_list));
 		goto drop;
@@ -595,7 +596,7 @@ int fnic_rq_cmpl_handler(struct fnic *fnic, int rq_work_to_do)
 		if (cur_work_done && fnic->stop_rx_link_events != 1) {
 			err = vnic_rq_fill(&fnic->rq[i], fnic_alloc_rq_frame);
 			if (err)
-				shost_printk(KERN_ERR, fnic->lport->host,
+				shost_printk(KERN_ERR, fnic->host,
 					     "fnic_alloc_rq_frame can't alloc"
 					     " frame\n");
 		}
@@ -621,7 +622,7 @@ int fnic_alloc_rq_frame(struct vnic_rq *rq)
 	len = FNIC_FRAME_HT_ROOM;
 	buf = kmalloc(len, GFP_ATOMIC);
 	if (!buf) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Unable to allocate RQ buffer of size: %d\n", len);
 		return -ENOMEM;
 	}
@@ -629,7 +630,7 @@ int fnic_alloc_rq_frame(struct vnic_rq *rq)
 	pa = dma_map_single(&fnic->pdev->dev, buf, len, DMA_FROM_DEVICE);
 	if (dma_mapping_error(&fnic->pdev->dev, pa)) {
 		ret = -ENOMEM;
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "PCI mapping failed with error %d\n", ret);
 		goto free_buf;
 	}
@@ -668,7 +669,7 @@ static int fnic_send_frame(struct fnic *fnic, void *frame, int frame_len)
 	if ((fnic_fc_trace_set_data(fnic->fnic_num,
 				FNIC_FC_SEND | 0x80, (char *) frame,
 				frame_len)) != 0) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "fnic ctlr frame trace error");
 	}
 
@@ -676,7 +677,7 @@ static int fnic_send_frame(struct fnic *fnic, void *frame, int frame_len)
 
 	if (!vnic_wq_desc_avail(wq)) {
 		dma_unmap_single(&fnic->pdev->dev, pa, frame_len, DMA_TO_DEVICE);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "vnic work queue descriptor is not available");
 		ret = -1;
 		goto fnic_send_frame_end;
@@ -704,7 +705,7 @@ fdls_send_fcoe_frame(struct fnic *fnic, void *payload, int payload_sz,
 
 	frame = kzalloc(max_framesz, GFP_ATOMIC);
 	if (!frame) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "Failed to allocate frame for flogi\n");
 		return -ENOMEM;
 	}
@@ -732,12 +733,13 @@ fdls_send_fcoe_frame(struct fnic *fnic, void *payload, int payload_sz,
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
@@ -759,7 +761,7 @@ fdls_send_fip_frame(struct fnic *fnic, void *payload, int payload_sz)
 
 	frame = kzalloc(max_framesz, GFP_ATOMIC);
 	if (!frame) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "fnic 0x%p Failed to allocate fip frame\n", fnic);
 		return -1;
 	}
@@ -818,7 +820,7 @@ void fnic_flush_tx(struct work_struct *work)
 	struct fc_frame *fp;
 	struct fnic_frame_list *cur_frame, *next;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Flush queued frames");
 
 	list_for_each_entry_safe(cur_frame, next, &fnic->tx_queue, links) {
@@ -836,7 +838,7 @@ fnic_fdls_register_portid(struct fnic_iport_s *iport, u32 port_id,
 	struct fnic_eth_hdr_s *ethhdr;
 	int ret;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Setting port id: 0x%x fp: 0x%p fnic state: %d", port_id,
 				 fp, fnic->state);
 
@@ -849,7 +851,7 @@ fnic_fdls_register_portid(struct fnic_iport_s *iport, u32 port_id,
 	if (fnic->state == FNIC_IN_ETH_MODE || fnic->state == FNIC_IN_FC_MODE)
 		fnic->state = FNIC_IN_ETH_TRANS_FC_MODE;
 	else {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			 "Unexpected fnic state while processing FLOGI response\n");
 		return -1;
 	}
@@ -860,7 +862,7 @@ fnic_fdls_register_portid(struct fnic_iport_s *iport, u32 port_id,
 	 */
 	ret = fnic_flogi_reg_handler(fnic, port_id);
 	if (ret < 0) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "FLOGI registration error ret: %d fnic state: %d\n",
 					 ret, fnic->state);
 		if (fnic->state == FNIC_IN_ETH_TRANS_FC_MODE)
@@ -870,7 +872,7 @@ fnic_fdls_register_portid(struct fnic_iport_s *iport, u32 port_id,
 	}
 	iport->fabric.flags |= FNIC_FDLS_FPMA_LEARNT;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "FLOGI registration success\n");
 	return 0;
 }
@@ -950,7 +952,7 @@ fnic_fdls_add_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tport,
 	struct fc_rport_identifiers ids;
 	struct rport_dd_data_s *rdd_data;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Adding rport fcid: 0x%x", tport->fcid);
 
 	ids.node_name = tport->wwnn;
@@ -959,15 +961,15 @@ fnic_fdls_add_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tport,
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
@@ -1006,7 +1008,7 @@ fnic_fdls_remove_tport(struct fnic_iport_s *iport,
 		fc_remote_port_delete(rport);
 
 		spin_lock_irqsave(&fnic->fnic_lock, flags);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "Deregistered and freed tport fcid: 0x%x from scsi transport fc",
 		 tport->fcid);
 
@@ -1033,7 +1035,7 @@ void fnic_delete_fcp_tports(struct fnic *fnic)
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	list_for_each_entry_safe(tport, next, &fnic->iport.tport_list, links) {
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "removing fcp rport fcid: 0x%x", tport->fcid);
 		fdls_set_tport_state(tport, FDLS_TGT_STATE_OFFLINING);
 		fnic_fdls_remove_tport(&fnic->iport, tport, flags);
@@ -1058,36 +1060,36 @@ void fnic_tport_event_handler(struct work_struct *work)
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
index 5f9c33fa3a1d..3458d27fe492 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -22,7 +22,6 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi_tcq.h>
-#include <scsi/libfc.h>
 #include <scsi/fc_frame.h>
 
 #include "vnic_dev.h"
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
@@ -572,7 +571,7 @@ static void fnic_scsi_init(struct fnic *fnic)
 
 static int fnic_scsi_drv_init(struct fnic *fnic)
 {
-	struct Scsi_Host *host = fnic->lport->host;
+	struct Scsi_Host *host = fnic->host;
 	int err;
 	struct pci_dev *pdev = fnic->pdev;
 	struct fnic_iport_s *iport = &fnic->iport;
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
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 67b6105701e4..fc4eedcbc76d 100644
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
@@ -1839,6 +1838,8 @@ static bool fnic_rport_abort_io_iter(struct scsi_cmnd *sc, void *data)
 	if (fnic_priv(sc)->flags & FNIC_DEVICE_RESET) {
 		atomic64_inc(&reset_stats->device_reset_terminates);
 		abt_tag |= FNIC_TAG_DEV_RST;
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
+					  "dev reset sc 0x%p\n", sc);
 	}
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 		      "fnic_rport_exch_reset: dev rst sc 0x%p\n", sc);
@@ -2049,10 +2050,10 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
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
@@ -2061,18 +2062,18 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
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
@@ -2081,7 +2082,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 
 	if ((tport->state != FDLS_TGT_STATE_READY) &&
 		(tport->state != FDLS_TGT_STATE_ADISC)) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					  "tport state: %d\n", tport->state);
 		ret = FAILED;
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
@@ -2132,7 +2133,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	else
 		atomic64_inc(&abts_stats->abort_issued_greater_than_60_sec);
 
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 		"CDB Opcode: 0x%02x Abort issued time: %lu msec\n",
 		sc->cmnd[0], abt_issued_time);
 	/*
@@ -2223,7 +2224,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 
 	if (!(fnic_priv(sc)->flags & (FNIC_IO_ABORTED | FNIC_IO_DONE))) {
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			      "Issuing host reset due to out of order IO\n");
 
 		ret = FAILED;
@@ -2271,7 +2272,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 		  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
 		  fnic_flags_and_state(sc));
 
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 		      "Returning from abort cmd type %x %s\n", task_req,
 		      (ret == SUCCESS) ?
 		      "SUCCESS" : "FAILED");
@@ -2312,7 +2313,7 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
 		free_wq_copy_descs(fnic, wq, hwq);
 
 	if (!vnic_wq_copy_desc_avail(wq)) {
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 			  "queue_dr_io_req failure - no descriptors\n");
 		atomic64_inc(&misc_stats->devrst_cpwq_alloc_failures);
 		ret = -EAGAIN;
@@ -2380,7 +2381,7 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc, void *data)
 	 * Found IO that is still pending with firmware and
 	 * belongs to the LUN that we are resetting
 	 */
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 		      "Found IO in %s on lun\n",
 		      fnic_ioreq_state_to_str(fnic_priv(sc)->state));
 
@@ -2390,14 +2391,14 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc, void *data)
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
@@ -2413,7 +2414,7 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc, void *data)
 	BUG_ON(io_req->abts_done);
 
 	if (fnic_priv(sc)->flags & FNIC_DEVICE_RESET) {
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			      "dev rst sc 0x%p\n", sc);
 	}
 
@@ -2435,7 +2436,7 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc, void *data)
 			fnic_priv(sc)->state = old_ioreq_state;
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 		iter_data->ret = FAILED;
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 			"hwq: %d abt_tag: 0x%lx Abort could not be queued\n",
 			hwq, abt_tag);
 		return false;
@@ -2514,7 +2515,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 
 	iter_data.lr_sc = lr_sc;
 
-	scsi_host_busy_iter(fnic->lport->host,
+	scsi_host_busy_iter(fnic->host,
 			    fnic_pending_aborts_iter, &iter_data);
 	if (iter_data.ret == FAILED) {
 		ret = iter_data.ret;
@@ -2527,7 +2528,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 		ret = 1;
 
 clean_pending_aborts_end:
-	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			"exit status: %d\n", ret);
 	return ret;
 }
@@ -2577,7 +2578,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	rport = starget_to_rport(scsi_target(sc->device));
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 		"fcid: 0x%x lun: %llu hwq: %d mqtag: 0x%x flags: 0x%x Device reset\n",
 		rport->port_id, sc->device->lun, hwq, mqtag,
 		fnic_priv(sc)->flags);
@@ -2585,7 +2586,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	rdd_data = rport->dd_data;
 	tport = rdd_data->tport;
 	if (!tport) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 		  "Dev rst called after tport delete! rport fcid: 0x%x lun: %llu\n",
 		  rport->port_id, sc->device->lun);
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
@@ -2594,7 +2595,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 	if (iport->state != FNIC_IPORT_STATE_READY) {
 		atomic64_inc(&fnic_stats->misc_stats.iport_not_ready);
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					  "iport NOT in READY state");
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		goto fnic_device_reset_end;
@@ -2602,7 +2603,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 	if ((tport->state != FDLS_TGT_STATE_READY) &&
 		(tport->state != FDLS_TGT_STATE_ADISC)) {
-		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 					  "tport state: %d\n", tport->state);
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		goto fnic_device_reset_end;
@@ -2665,7 +2666,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	fnic_priv(sc)->lr_status = FCPIO_INVALID_CODE;
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
 
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num, "TAG %x\n", mqtag);
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num, "TAG %x\n", mqtag);
 
 	/*
 	 * issue the device reset, if enqueue failed, clean up the ioreq
@@ -2716,13 +2717,13 @@ int fnic_device_reset(struct scsi_cmnd *sc)
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
@@ -2737,7 +2738,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	 */
 	if (status == FCPIO_INVALID_CODE) {
 		atomic64_inc(&reset_stats->device_reset_timeouts);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 			      "Device reset timed out\n");
 		fnic_priv(sc)->flags |= FNIC_DEV_RST_TIMED_OUT;
 		int_to_scsilun(sc->device->lun, &fc_lun);
@@ -2750,7 +2751,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	if (status != FCPIO_SUCCESS) {
 		spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
 		FNIC_SCSI_DBG(KERN_DEBUG,
-			      fnic->lport->host, fnic->fnic_num,
+			      fnic->host, fnic->fnic_num,
 			      "Device reset completed - failed\n");
 		io_req = fnic_priv(sc)->io_req;
 		goto fnic_device_reset_clean;
@@ -2766,7 +2767,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	if (fnic_clean_pending_aborts(fnic, sc, new_sc)) {
 		spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
 		io_req = fnic_priv(sc)->io_req;
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 					  "Device reset failed: Cannot abort all IOs\n");
 		goto fnic_device_reset_clean;
 	}
@@ -2820,13 +2821,13 @@ int fnic_device_reset(struct scsi_cmnd *sc)
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
@@ -2861,13 +2862,13 @@ void fnic_reset(struct Scsi_Host *shost)
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
@@ -2878,7 +2879,7 @@ int fnic_issue_fc_host_lip(struct Scsi_Host *shost)
 	int ret = 0;
 	struct fnic *fnic = *((struct fnic **) shost_priv(shost));
 
-	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				  "FC host lip issued");
 
 	ret = fnic_host_reset(shost);
@@ -2904,7 +2905,7 @@ int fnic_host_reset(struct Scsi_Host *shost)
 		spin_lock_irqsave(&fnic->fnic_lock, flags);
 		if (fnic->reset_in_progress == IN_PROGRESS) {
 			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-			FNIC_SCSI_DBG(KERN_WARNING, fnic->lport->host, fnic->fnic_num,
+			FNIC_SCSI_DBG(KERN_WARNING, fnic->host, fnic->fnic_num,
 			  "Firmware reset in progress. Skipping another host reset\n");
 			return SUCCESS;
 		}
@@ -2942,7 +2943,7 @@ int fnic_host_reset(struct Scsi_Host *shost)
 	}
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				  "host reset return status: %d\n", ret);
 	return ret;
 }
@@ -2982,7 +2983,7 @@ static bool fnic_abts_pending_iter(struct scsi_cmnd *sc, void *data)
 	 * Found IO that is still pending with firmware and
 	 * belongs to the LUN that we are resetting
 	 */
-	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		"hwq: %d tag: 0x%x Found IO in state: %s on lun\n",
 		hwq, tag,
 		fnic_ioreq_state_to_str(fnic_priv(sc)->state));
@@ -3015,7 +3016,7 @@ int fnic_is_abts_pending(struct fnic *fnic, struct scsi_cmnd *lr_sc)
 	}
 
 	/* walk again to check, if IOs are still pending in fw */
-	scsi_host_busy_iter(fnic->lport->host,
+	scsi_host_busy_iter(fnic->host,
 			    fnic_abts_pending_iter, &iter_data);
 
 	return iter_data.ret;
@@ -3036,7 +3037,7 @@ int fnic_eh_host_reset_handler(struct scsi_cmnd *sc)
 	struct Scsi_Host *shost = sc->device->host;
 	struct fnic *fnic = *((struct fnic **) shost_priv(shost));
 
-	FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				  "SCSI error handling: fnic host reset");
 
 	ret = fnic_host_reset(shost);
@@ -3057,7 +3058,7 @@ void fnic_scsi_fcpio_reset(struct fnic *fnic)
 	if (unlikely(fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)) {
 		/* fw reset is in progress, poll for its completion */
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			  "fnic is in unexpected state: %d for fw_reset\n",
 			  fnic->state);
 		return;
@@ -3070,7 +3071,7 @@ void fnic_scsi_fcpio_reset(struct fnic *fnic)
 	fnic->fw_reset_done = &fw_reset_done;
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+	FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				  "Issuing fw reset\n");
 	if (fnic_fw_reset_handler(fnic)) {
 		spin_lock_irqsave(&fnic->fnic_lock, flags);
@@ -3078,14 +3079,14 @@ void fnic_scsi_fcpio_reset(struct fnic *fnic)
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

