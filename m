From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 1/8] zfcp: Adapt to new FC_PORTSPEED semantics
Date: Tue, 04 Sep 2012 15:23:29 +0200
Message-ID: <20120904132348.304927022@linux.vnet.ibm.com>
References: <20120904132328.564402930@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:34838 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab2IDNaA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Sep 2012 09:30:00 -0400
Received: from /spool/local
	by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Tue, 4 Sep 2012 14:29:58 +0100
Content-Disposition: inline; filename=705-zfcp-adapt-to-new-FC_PORTSPEED-semantics.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, stable@vger.kernel.org

From: Steffen Maier <maier@linux.vnet.ibm.com>

Commit a9277e7783651d4e0a849f7988340b1c1cf748a4
"[SCSI] scsi_transport_fc: Getting FC Port Speed in sync with FC-GS"
changed the semantics of FC_PORTSPEED defines to
FDMI port attributes of FC-HBA/SM-HBA
which is different from the previous bit reversed
Report Port Speed Capabilities (RPSC) ELS of FC-GS/FC-LS.

Zfcp showed "10 Gbit" instead of "4 Gbit" for supported_speeds.
It now uses explicit bit conversion as the other LLDs already
do, in order to be independent of the kernel bit semantics.
See also http://marc.info/?l=linux-scsi&m=134452926830730&w=2

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org> #3.4+
---
 drivers/s390/scsi/zfcp_fsf.c |   34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -437,6 +437,34 @@ void zfcp_fsf_req_dismiss_all(struct zfc
 	}
 }
 
+#define ZFCP_FSF_PORTSPEED_1GBIT	(1 <<  0)
+#define ZFCP_FSF_PORTSPEED_2GBIT	(1 <<  1)
+#define ZFCP_FSF_PORTSPEED_4GBIT	(1 <<  2)
+#define ZFCP_FSF_PORTSPEED_10GBIT	(1 <<  3)
+#define ZFCP_FSF_PORTSPEED_8GBIT	(1 <<  4)
+#define ZFCP_FSF_PORTSPEED_16GBIT	(1 <<  5)
+#define ZFCP_FSF_PORTSPEED_NOT_NEGOTIATED (1 << 15)
+
+static u32 zfcp_fsf_convert_portspeed(u32 fsf_speed)
+{
+	u32 fdmi_speed = 0;
+	if (fsf_speed & ZFCP_FSF_PORTSPEED_1GBIT)
+		fdmi_speed |= FC_PORTSPEED_1GBIT;
+	if (fsf_speed & ZFCP_FSF_PORTSPEED_2GBIT)
+		fdmi_speed |= FC_PORTSPEED_2GBIT;
+	if (fsf_speed & ZFCP_FSF_PORTSPEED_4GBIT)
+		fdmi_speed |= FC_PORTSPEED_4GBIT;
+	if (fsf_speed & ZFCP_FSF_PORTSPEED_10GBIT)
+		fdmi_speed |= FC_PORTSPEED_10GBIT;
+	if (fsf_speed & ZFCP_FSF_PORTSPEED_8GBIT)
+		fdmi_speed |= FC_PORTSPEED_8GBIT;
+	if (fsf_speed & ZFCP_FSF_PORTSPEED_16GBIT)
+		fdmi_speed |= FC_PORTSPEED_16GBIT;
+	if (fsf_speed & ZFCP_FSF_PORTSPEED_NOT_NEGOTIATED)
+		fdmi_speed |= FC_PORTSPEED_NOT_NEGOTIATED;
+	return fdmi_speed;
+}
+
 static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 {
 	struct fsf_qtcb_bottom_config *bottom = &req->qtcb->bottom.config;
@@ -456,7 +484,8 @@ static int zfcp_fsf_exchange_config_eval
 	fc_host_port_name(shost) = nsp->fl_wwpn;
 	fc_host_node_name(shost) = nsp->fl_wwnn;
 	fc_host_port_id(shost) = ntoh24(bottom->s_id);
-	fc_host_speed(shost) = bottom->fc_link_speed;
+	fc_host_speed(shost) =
+		zfcp_fsf_convert_portspeed(bottom->fc_link_speed);
 	fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
 
 	adapter->hydra_version = bottom->adapter_type;
@@ -580,7 +609,8 @@ static void zfcp_fsf_exchange_port_evalu
 	} else
 		fc_host_permanent_port_name(shost) = fc_host_port_name(shost);
 	fc_host_maxframe_size(shost) = bottom->maximum_frame_size;
-	fc_host_supported_speeds(shost) = bottom->supported_speed;
+	fc_host_supported_speeds(shost) =
+		zfcp_fsf_convert_portspeed(bottom->supported_speed);
 	memcpy(fc_host_supported_fc4s(shost), bottom->supported_fc4_types,
 	       FC_FC4_LIST_SIZE);
 	memcpy(fc_host_active_fc4s(shost), bottom->active_fc4_types,

