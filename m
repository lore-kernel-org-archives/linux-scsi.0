Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 260CCC4363A
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 09:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC0DF221FC
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 09:28:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="MhDk1Pme"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390850AbgJUJ25 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 05:28:57 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17900 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390847AbgJUJ25 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Oct 2020 05:28:57 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09L9Q8hB027369
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2020 02:28:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=A9gThR+EN/2j4eiLKcu+cFuhnEgI4JXTJI/f2EXTI2E=;
 b=MhDk1Pmev/Y4BsRK8SA0RF3CzqctPT7bDCeuylE5gIRR31t2/FZp64unxgDWwIVIDrSV
 fvs8nIDjhTZwhKyefb76idScA8j6ZA4Ef1f53tZjkjEIeZhzBMGiKxzG9nh3DoP5xwD9
 hmZt1m9EPnVM3eXNP1+QnE9e6rEfxYKtqYfeEe0ESch1GTfDfCToKrEMkCXGIr6yFBjK
 Gl8CGNZiKsrkmQnSGHwTwd/uHrryPribmSfSM17imrlGGmE9XqOs5E6VBiOdpKWOc5L+
 UTqlnIfvGbH02IOwERAhnc9DsxWgcnELKnvn90qefpTqGYOAMJpMb0kXJyMvrFI8o/mx jA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34804nv98u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2020 02:28:53 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Oct
 2020 02:28:52 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Oct
 2020 02:28:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Oct 2020 02:28:52 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D13E13F703F;
        Wed, 21 Oct 2020 02:28:51 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 09L9SpLe022725;
        Wed, 21 Oct 2020 02:28:51 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 09L9SpC6022723;
        Wed, 21 Oct 2020 02:28:51 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 3/5] scsi: fc: Parse FPIN packets and update statistics
Date:   Wed, 21 Oct 2020 02:27:13 -0700
Message-ID: <20201021092715.22669-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201021092715.22669-1-njavali@marvell.com>
References: <20201021092715.22669-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-21_03:2020-10-20,2020-10-21 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shyam Sundar <ssundar@marvell.com>

Parse the incoming FPIN packets and update the host and rport FPIN
statistics based on the FPINs.

Signed-off-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/scsi_transport_fc.c | 293 +++++++++++++++++++++++++++++++
 include/scsi/scsi_transport_fc.h |   1 +
 2 files changed, 294 insertions(+)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 501e165ae6f1..4dfa0e40d8e5 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -34,6 +34,11 @@ static int fc_bsg_hostadd(struct Scsi_Host *, struct fc_host_attrs *);
 static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
 static void fc_bsg_remove(struct request_queue *);
 static void fc_bsg_goose_queue(struct fc_rport *);
+static void fc_li_stats_update(struct fc_fn_li_desc *li_desc,
+			       struct fc_fpin_stats *stats);
+static void fc_delivery_stats_update(u32 reason_code,
+				     struct fc_fpin_stats *stats);
+static void fc_cn_stats_update(u16 event_type, struct fc_fpin_stats *stats);
 
 /*
  * Module Parameters
@@ -630,6 +635,262 @@ fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
 }
 EXPORT_SYMBOL(fc_host_post_vendor_event);
 
+/**
+ * fc_find_rport_by_wwpn - find the fc_rport pointer for a given wwpn
+ * @shost:		host the fc_rport is associated with
+ * @wwpn:		wwpn of the fc_rport device
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+struct fc_rport *
+fc_find_rport_by_wwpn(struct Scsi_Host *shost, u64 wwpn)
+{
+	struct fc_rport *rport;
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	list_for_each_entry(rport, &fc_host_rports(shost), peers) {
+		if (rport->port_state != FC_PORTSTATE_ONLINE)
+			continue;
+
+		if (rport->port_name == wwpn) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			return rport;
+		}
+	}
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	return NULL;
+}
+EXPORT_SYMBOL(fc_find_rport_by_wwpn);
+
+static void
+fc_li_stats_update(struct fc_fn_li_desc *li_desc,
+		   struct fc_fpin_stats *stats)
+{
+	stats->li += be32_to_cpu(li_desc->event_count);
+	switch (be16_to_cpu(li_desc->event_type)) {
+	case FPIN_LI_UNKNOWN:
+		stats->li_failure_unknown +=
+		    be32_to_cpu(li_desc->event_count);
+		break;
+	case FPIN_LI_LINK_FAILURE:
+		stats->li_link_failure_count +=
+		    be32_to_cpu(li_desc->event_count);
+		break;
+	case FPIN_LI_LOSS_OF_SYNC:
+		stats->li_loss_of_sync_count +=
+		    be32_to_cpu(li_desc->event_count);
+		break;
+	case FPIN_LI_LOSS_OF_SIG:
+		stats->li_loss_of_signals_count +=
+		    be32_to_cpu(li_desc->event_count);
+		break;
+	case FPIN_LI_PRIM_SEQ_ERR:
+		stats->li_prim_seq_err_count +=
+		    be32_to_cpu(li_desc->event_count);
+		break;
+	case FPIN_LI_INVALID_TX_WD:
+		stats->li_invalid_tx_word_count +=
+		    be32_to_cpu(li_desc->event_count);
+		break;
+	case FPIN_LI_INVALID_CRC:
+		stats->li_invalid_crc_count +=
+		    be32_to_cpu(li_desc->event_count);
+		break;
+	case FPIN_LI_DEVICE_SPEC:
+		stats->li_device_specific +=
+		    be32_to_cpu(li_desc->event_count);
+		break;
+	}
+}
+
+static void
+fc_delivery_stats_update(u32 reason_code, struct fc_fpin_stats *stats)
+{
+	stats->dn++;
+	switch (reason_code) {
+	case FPIN_DELI_UNKNOWN:
+		stats->dn_unknown++;
+		break;
+	case FPIN_DELI_TIMEOUT:
+		stats->dn_timeout++;
+		break;
+	case FPIN_DELI_UNABLE_TO_ROUTE:
+		stats->dn_unable_to_route++;
+		break;
+	case FPIN_DELI_DEVICE_SPEC:
+		stats->dn_device_specific++;
+		break;
+	}
+}
+
+static void
+fc_cn_stats_update(u16 event_type, struct fc_fpin_stats *stats)
+{
+	stats->cn++;
+	switch (event_type) {
+	case FPIN_CONGN_CLEAR:
+		stats->cn_clear++;
+		break;
+	case FPIN_CONGN_LOST_CREDIT:
+		stats->cn_lost_credit++;
+		break;
+	case FPIN_CONGN_CREDIT_STALL:
+		stats->cn_credit_stall++;
+		break;
+	case FPIN_CONGN_OVERSUBSCRIPTION:
+		stats->cn_oversubscription++;
+		break;
+	case FPIN_CONGN_DEVICE_SPEC:
+		stats->cn_device_specific++;
+	}
+}
+
+/*
+ * fc_fpin_li_stats_update - routine to update Link Integrity
+ * event statistics.
+ * @shost:		host the FPIN was received on
+ * @tlv:		pointer to link integrity descriptor
+ *
+ */
+static void
+fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_tlv_desc *tlv)
+{
+	u8 i;
+	struct fc_rport *rport = NULL;
+	struct fc_rport *attach_rport = NULL;
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_fn_li_desc *li_desc = (struct fc_fn_li_desc *)tlv;
+	u64 wwpn;
+
+	rport = fc_find_rport_by_wwpn(shost,
+				      be64_to_cpu(li_desc->attached_wwpn));
+	if (rport &&
+	    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
+	     rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
+		attach_rport = rport;
+		fc_li_stats_update(li_desc, &attach_rport->fpin_stats);
+	}
+
+	if (be32_to_cpu(li_desc->pname_count) > 0) {
+		for (i = 0;
+		    i < be32_to_cpu(li_desc->pname_count);
+		    i++) {
+			wwpn = be64_to_cpu(li_desc->pname_list[i]);
+			rport = fc_find_rport_by_wwpn(shost, wwpn);
+			if (rport &&
+			    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
+			    rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
+				if (rport == attach_rport)
+					continue;
+				fc_li_stats_update(li_desc,
+						   &rport->fpin_stats);
+			}
+		}
+	}
+
+	if (fc_host->port_name == be64_to_cpu(li_desc->attached_wwpn))
+		fc_li_stats_update(li_desc, &fc_host->fpin_stats);
+}
+
+/*
+ * fc_fpin_delivery_stats_update - routine to update Delivery Notification
+ * event statistics.
+ * @shost:		host the FPIN was received on
+ * @tlv:		pointer to delivery descriptor
+ *
+ */
+static void
+fc_fpin_delivery_stats_update(struct Scsi_Host *shost,
+			      struct fc_tlv_desc *tlv)
+{
+	struct fc_rport *rport = NULL;
+	struct fc_rport *attach_rport = NULL;
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_fn_deli_desc *dn_desc = (struct fc_fn_deli_desc *)tlv;
+	u32 reason_code = be32_to_cpu(dn_desc->deli_reason_code);
+
+	rport = fc_find_rport_by_wwpn(shost,
+				      be64_to_cpu(dn_desc->attached_wwpn));
+	if (rport &&
+	    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
+	     rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
+		attach_rport = rport;
+		fc_delivery_stats_update(reason_code,
+					 &attach_rport->fpin_stats);
+	}
+
+	if (fc_host->port_name == be64_to_cpu(dn_desc->attached_wwpn))
+		fc_delivery_stats_update(reason_code, &fc_host->fpin_stats);
+}
+
+/*
+ * fc_fpin_peer_congn_stats_update - routine to update Peer Congestion
+ * event statistics.
+ * @shost:		host the FPIN was received on
+ * @tlv:		pointer to peer congestion descriptor
+ *
+ */
+static void
+fc_fpin_peer_congn_stats_update(struct Scsi_Host *shost,
+				struct fc_tlv_desc *tlv)
+{
+	u8 i;
+	struct fc_rport *rport = NULL;
+	struct fc_rport *attach_rport = NULL;
+	struct fc_fn_peer_congn_desc *pc_desc =
+	    (struct fc_fn_peer_congn_desc *)tlv;
+	u16 event_type = be16_to_cpu(pc_desc->event_type);
+	u64 wwpn;
+
+	rport = fc_find_rport_by_wwpn(shost,
+				      be64_to_cpu(pc_desc->attached_wwpn));
+	if (rport &&
+	    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
+	     rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
+		attach_rport = rport;
+		fc_cn_stats_update(event_type, &attach_rport->fpin_stats);
+	}
+
+	if (be32_to_cpu(pc_desc->pname_count) > 0) {
+		for (i = 0;
+		    i < be32_to_cpu(pc_desc->pname_count);
+		    i++) {
+			wwpn = be64_to_cpu(pc_desc->pname_list[i]);
+			rport = fc_find_rport_by_wwpn(shost, wwpn);
+			if (rport &&
+			    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
+			     rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
+				if (rport == attach_rport)
+					continue;
+				fc_cn_stats_update(event_type,
+						   &rport->fpin_stats);
+			}
+		}
+	}
+}
+
+/*
+ * fc_fpin_congn_stats_update - routine to update Congestion
+ * event statistics.
+ * @shost:		host the FPIN was received on
+ * @tlv:		pointer to congestion descriptor
+ *
+ */
+static void
+fc_fpin_congn_stats_update(struct Scsi_Host *shost,
+			   struct fc_tlv_desc *tlv)
+{
+	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
+	struct fc_fn_congn_desc *congn = (struct fc_fn_congn_desc *)tlv;
+
+	fc_cn_stats_update(be16_to_cpu(congn->event_type),
+			   &fc_host->fpin_stats);
+}
+
 /**
  * fc_host_rcv_fpin - routine to process a received FPIN.
  * @shost:		host the FPIN was received on
@@ -642,6 +903,38 @@ EXPORT_SYMBOL(fc_host_post_vendor_event);
 void
 fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf)
 {
+	struct fc_els_fpin *fpin = (struct fc_els_fpin *)fpin_buf;
+	struct fc_tlv_desc *tlv;
+	u32 desc_cnt = 0, bytes_remain;
+	u32 dtag;
+
+	/* Update Statistics */
+	tlv = (struct fc_tlv_desc *)&fpin->fpin_desc[0];
+	bytes_remain = fpin_len - offsetof(struct fc_els_fpin, fpin_desc);
+	bytes_remain = min_t(u32, bytes_remain, be32_to_cpu(fpin->desc_len));
+
+	while (bytes_remain >= FC_TLV_DESC_HDR_SZ &&
+	       bytes_remain >= FC_TLV_DESC_SZ_FROM_LENGTH(tlv)) {
+		dtag = be32_to_cpu(tlv->desc_tag);
+		switch (dtag) {
+		case ELS_DTAG_LNK_INTEGRITY:
+			fc_fpin_li_stats_update(shost, tlv);
+			break;
+		case ELS_DTAG_DELIVERY:
+			fc_fpin_delivery_stats_update(shost, tlv);
+			break;
+		case ELS_DTAG_PEER_CONGEST:
+			fc_fpin_peer_congn_stats_update(shost, tlv);
+			break;
+		case ELS_DTAG_CONGESTION:
+			fc_fpin_congn_stats_update(shost, tlv);
+		}
+
+		desc_cnt++;
+		bytes_remain -= FC_TLV_DESC_SZ_FROM_LENGTH(tlv);
+		tlv = fc_tlv_next_desc(tlv);
+	}
+
 	fc_host_post_fc_event(shost, fc_get_event_number(),
 				FCH_EVT_LINK_FPIN, fpin_len, fpin_buf, 0);
 }
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 487a403ee51e..a636c1986e22 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -819,6 +819,7 @@ void fc_host_post_event(struct Scsi_Host *shost, u32 event_number,
 		enum fc_host_event_code event_code, u32 event_data);
 void fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
 		u32 data_len, char *data_buf, u64 vendor_id);
+struct fc_rport *fc_find_rport_by_wwpn(struct Scsi_Host *shost, u64 wwpn);
 void fc_host_post_fc_event(struct Scsi_Host *shost, u32 event_number,
 		enum fc_host_event_code event_code,
 		u32 data_len, char *data_buf, u64 vendor_id);
-- 
2.19.0.rc0

