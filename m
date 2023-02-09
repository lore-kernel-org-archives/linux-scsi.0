Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0646DC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Feb 2023 10:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjBIKmb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Feb 2023 05:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjBIKmS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2023 05:42:18 -0500
X-Greylist: delayed 589 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Feb 2023 02:41:57 PST
Received: from relay.smtp-ext.broadcom.com (saphodev.broadcom.com [192.19.144.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B403ECDCA
        for <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2023 02:41:55 -0800 (PST)
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id D722DC0000F7;
        Thu,  9 Feb 2023 02:32:03 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com D722DC0000F7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1675938725;
        bh=XIfuLwe9BhRLjUElu7zVMRvKF7WEt0AuR9Hld8jFFeE=;
        h=From:To:Cc:Subject:Date:From;
        b=nafj+8gfXG0AxddqwTPNBIb/Jdy/YNxSim2K7blGBRFJCLnG1Q7tW3Eghdk5yHxNc
         mrLoa+FY9WkY1kSes2qsH2KpcHURz9vKr7m8qBC9F2vMSr/Y4RWUfISLFDvXSYQ1Jv
         PaNdq6c9VACiOts+TevfFdCYYzOdZ5jKWcq1x9Hs=
From:   Muneendra Kumar <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com
Cc:     hare@suse.de, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH] scsi:scsi_transport_fc:Add an additional flag to fc_host_fpin_rcv()
Date:   Wed,  8 Feb 2023 19:43:26 -0800
Message-Id: <20230209034326.882514-1-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Muneendra <muneendra.kumar@broadcom.com>

The LLDD and the stack currently process FPINs received from the fabric,
but the stack is not aware of any action taken by the driver to alleviate
congestion. The current interface between the driver and the SCSI stack is
limited to passing the notification mainly for statistics and heuristics.

The reaction to an FPIN could be handled either by the driver or by the
stack (marginal path and failover). This patch enhances the interface to
indicate if action on an FPIN has already been reacted to by the
LLDDs or not.Add an additional flag to fc_host_fpin_rcv() to indicate
if the FPIN has been acknowledged/reacted to by the driver.

Also added a new event code FCH_EVT_LINK_FPIN_ACK to notify to the user
that the event has been acknowledged/reacted by the LLDD driver

Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c     |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c   |  2 +-
 drivers/scsi/scsi_transport_fc.c | 10 +++++++---
 include/scsi/scsi_transport_fc.h |  4 +++-
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 569639dc8b2c..aee5d0d1187d 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -10287,7 +10287,7 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void *p, u32 fpin_length)
 		/* Send every descriptor individually to the upper layer */
 		if (deliver)
 			fc_host_fpin_rcv(lpfc_shost_from_vport(vport),
-					 fpin_length, (char *)fpin);
+					 fpin_length, (char *)fpin, 0);
 		desc_cnt++;
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 46e8b38603f0..030625ebb4e6 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -45,7 +45,7 @@ qla27xx_process_purex_fpin(struct scsi_qla_host *vha, struct purex_item *item)
 	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x508f,
 		       pkt, pkt_size);
 
-	fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt);
+	fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt, 0);
 }
 
 const char *const port_state_str[] = {
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 0965f8a7134f..f12e9467ebb4 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -137,6 +137,7 @@ static const struct {
 	{ FCH_EVT_PORT_FABRIC,		"port_fabric" },
 	{ FCH_EVT_LINK_UNKNOWN,		"link_unknown" },
 	{ FCH_EVT_LINK_FPIN,		"link_FPIN" },
+	{ FCH_EVT_LINK_FPIN_ACK,	"link_FPIN_ACK" },
 	{ FCH_EVT_VENDOR_UNIQUE,	"vendor_unique" },
 };
 fc_enum_name_search(host_event_code, fc_host_event_code,
@@ -894,17 +895,20 @@ fc_fpin_congn_stats_update(struct Scsi_Host *shost,
  * @shost:		host the FPIN was received on
  * @fpin_len:		length of FPIN payload, in bytes
  * @fpin_buf:		pointer to FPIN payload
- *
+ * @event_acknowledge:	1, if LLDD handles this event.
  * Notes:
  *	This routine assumes no locks are held on entry.
  */
 void
-fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf)
+fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf,
+		u8 event_acknowledge)
 {
 	struct fc_els_fpin *fpin = (struct fc_els_fpin *)fpin_buf;
 	struct fc_tlv_desc *tlv;
 	u32 desc_cnt = 0, bytes_remain;
 	u32 dtag;
+	enum fc_host_event_code event_code =
+		event_acknowledge ? FCH_EVT_LINK_FPIN_ACK : FCH_EVT_LINK_FPIN;
 
 	/* Update Statistics */
 	tlv = (struct fc_tlv_desc *)&fpin->fpin_desc[0];
@@ -934,7 +938,7 @@ fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf)
 	}
 
 	fc_host_post_fc_event(shost, fc_get_event_number(),
-				FCH_EVT_LINK_FPIN, fpin_len, fpin_buf, 0);
+				event_code, fpin_len, fpin_buf, 0);
 }
 EXPORT_SYMBOL(fc_host_fpin_rcv);
 
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 3dcda19d3520..483513c57597 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -496,6 +496,7 @@ enum fc_host_event_code  {
 	FCH_EVT_PORT_FABRIC		= 0x204,
 	FCH_EVT_LINK_UNKNOWN		= 0x500,
 	FCH_EVT_LINK_FPIN		= 0x501,
+	FCH_EVT_LINK_FPIN_ACK		= 0x502,
 	FCH_EVT_VENDOR_UNIQUE		= 0xffff,
 };
 
@@ -856,7 +857,8 @@ void fc_host_post_fc_event(struct Scsi_Host *shost, u32 event_number,
 	 * Note: when calling fc_host_post_fc_event(), vendor_id may be
 	 *   specified as 0.
 	 */
-void fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf);
+void fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf,
+		u8 event_acknowledge);
 struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
-- 
2.26.2

