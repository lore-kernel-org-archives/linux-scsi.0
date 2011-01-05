From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 5/8] BNX2I: Added TCP timestamps option support
Date: Wed, 5 Jan 2011 12:44:24 -0800
Message-ID: <1294260267-17413-6-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1851 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab1AEUl6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 15:41:58 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

This TCP timestamps option is a module wise feature which can be
enabled via the module param (time_stamps).  Once enabled, the TCP
connection will advertise timestamps as an option to get negotiated.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Acked-by: Benjamin Li <benli@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i.h       |    1 +
 drivers/scsi/bnx2i/bnx2i_init.c  |    4 ++++
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    2 ++
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index e1ca5fe..cc7ebc1 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -701,6 +701,7 @@ struct bnx2i_endpoint {
 extern unsigned int error_mask1, error_mask2;
 extern u64 iscsi_error_mask;
 extern unsigned int en_tcp_dack;
+extern unsigned int time_stamps;
 extern unsigned int event_coal_div;
 extern unsigned int event_coal_min;
 
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 5ef01c9..c053764 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -48,6 +48,10 @@ unsigned int en_tcp_dack = 1;
 module_param(en_tcp_dack, int, 0664);
 MODULE_PARM_DESC(en_tcp_dack, "Enable TCP Delayed ACK");
 
+unsigned int time_stamps = 0x00;
+module_param(time_stamps, int, 0664);
+MODULE_PARM_DESC(time_stamps, "Enable TCP TimeStamps [1 = Enable]");
+
 unsigned int error_mask1 = 0x00;
 module_param(error_mask1, int, 0664);
 MODULE_PARM_DESC(error_mask1, "Config FW iSCSI Error Mask #1");
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index f9415aa..86ddc08 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1832,6 +1832,8 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 	bnx2i_ep->cm_sk->rcv_buf = 256 * 1024;
 	bnx2i_ep->cm_sk->snd_buf = 256 * 1024;
 	clear_bit(SK_TCP_TIMESTAMP, &bnx2i_ep->cm_sk->tcp_flags);
+	if (time_stamps)
+		set_bit(SK_TCP_TIMESTAMP, &bnx2i_ep->cm_sk->tcp_flags);
 
 	memset(&saddr, 0, sizeof(saddr));
 	if (dst_addr->sa_family == AF_INET) {
-- 
1.7.0.5


