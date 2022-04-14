Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE5AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Apr 2022 05:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239946AbiDNF5R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Apr 2022 01:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbiDNF5P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Apr 2022 01:57:15 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC1534BAC
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 22:54:51 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23E1YSGD002601
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 22:54:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=bSpDQwbzXRyZQGTdm41CL5m/j+LAPtKE2NrV3fQVhq8=;
 b=Tmln9ZblqmavDkg0CKTf9Kif7YBNk5FjT7/Vw/DElZ4pT+luwqn5DSqnsPJNn/XXMnKe
 GJ73tS210tNr5fwYbRNBbMu7aPMFWqSNB0DPSzrUZFV1G5ompr8SSB4R78emMEiU2Lu5
 HmE08B/uoewOk2XxxZPwacaeJsSdMUlUtS46NLqBWrFJfmNxK7vQXWMf2wXqvxdVQZRn
 nExtRW/Ea/LjfnlCS561c7d/3yb+PlLx6re9iZME0exGo+KTyNS8HLrx0PapVLOLPUB5
 ZCOghulE9X149QF+Y7dFHQloT43n+tbpL48boFZS0uVns43VOhJx1r2Taq6AMy+FPFE4 sg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3fea2m8sy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 22:54:50 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Apr
 2022 22:54:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Apr 2022 22:54:49 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 42E3C3F7043;
        Wed, 13 Apr 2022 22:54:49 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 23E5skuZ019755;
        Wed, 13 Apr 2022 22:54:46 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 23E5sV5Q019746;
        Wed, 13 Apr 2022 22:54:31 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH] qla2xxx: Add an additional flag to fc_host_fpin_rcv()
Date:   Wed, 13 Apr 2022 22:54:31 -0700
Message-ID: <20220414055431.19712-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: SlL9FlZ2F2EcRg5izCokzCg8mHz5hGAl
X-Proofpoint-ORIG-GUID: SlL9FlZ2F2EcRg5izCokzCg8mHz5hGAl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_01,2022-04-13_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Anil Gurumurthy <agurumurthy@marvell.com>

The LLDD and the stack currently process FPINs received from the fabric,
but the stack is not aware of any action taken by the driver to alleviate
congestion. The current interface between the driver and the SCSI stack is
limited to passing the notification mainly for statistics and heuristics.

The reaction to an FPIN could be handled either by the driver or by the
stack (marginal path and failover). This patch enhances the interface to
indicate if action on an FPIN has already been taken by the LLDDs or not.
Add an additional flag to fc_host_fpin_rcv() to indicate if the FPIN has
been processed by the driver.

Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/lpfc/lpfc_els.c     | 2 +-
 drivers/scsi/qla2xxx/qla_isr.c   | 2 +-
 drivers/scsi/scsi_transport_fc.c | 6 +++++-
 include/scsi/scsi_transport_fc.h | 2 +-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3a445a0fea86..e221c25b848d 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -10084,7 +10084,7 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void *p, u32 fpin_length)
 		/* Send every descriptor individually to the upper layer */
 		if (deliver)
 			fc_host_fpin_rcv(lpfc_shost_from_vport(vport),
-					 fpin_length, (char *)fpin);
+					 fpin_length, (char *)fpin, false);
 		desc_cnt++;
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 21b31d6359c8..e01d9a671749 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -45,7 +45,7 @@ qla27xx_process_purex_fpin(struct scsi_qla_host *vha, struct purex_item *item)
 	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x508f,
 		       pkt, pkt_size);
 
-	fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt);
+	fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt, false);
 }
 
 const char *const port_state_str[] = {
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index a2524106206d..6de476f13512 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -892,12 +892,13 @@ fc_fpin_congn_stats_update(struct Scsi_Host *shost,
  * @shost:		host the FPIN was received on
  * @fpin_len:		length of FPIN payload, in bytes
  * @fpin_buf:		pointer to FPIN payload
+ * @hba_process:	true if LLDD has acted on the FPIN
  *
  * Notes:
  *	This routine assumes no locks are held on entry.
  */
 void
-fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf)
+fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf, bool hba_process)
 {
 	struct fc_els_fpin *fpin = (struct fc_els_fpin *)fpin_buf;
 	struct fc_tlv_desc *tlv;
@@ -925,6 +926,9 @@ fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf)
 		case ELS_DTAG_CONGESTION:
 			fc_fpin_congn_stats_update(shost, tlv);
 		}
+		/* If the event has not been processed, mark path as marginal */
+		if (!hba_process)
+			fc_host_port_state(shost) = FC_PORTSTATE_MARGINAL;
 
 		desc_cnt++;
 		bytes_remain -= FC_TLV_DESC_SZ_FROM_LENGTH(tlv);
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index e80a7c542c88..a987db5c7d63 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -856,7 +856,7 @@ void fc_host_post_fc_event(struct Scsi_Host *shost, u32 event_number,
 	 * Note: when calling fc_host_post_fc_event(), vendor_id may be
 	 *   specified as 0.
 	 */
-void fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf);
+void fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf, bool hba_process);
 struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
-- 
2.23.1

