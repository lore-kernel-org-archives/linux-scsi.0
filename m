From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 2/4] fcoe/libfcoe: Move common code for fcoe_get_lesb to
 fcoe_transport
Date: Mon, 3 Oct 2011 16:45:01 -0700
Message-ID: <1317685503-22622-3-git-send-email-bprakash@broadcom.com>
References: <1317685503-22622-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1272 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab1JCXpT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Oct 2011 19:45:19 -0400
In-Reply-To: <1317685503-22622-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, devel@open-fcoe.org

Except for obtaining the netdev from lport, fcoe_get_lesb is the common code
for the LLDs.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/fcoe/fcoe.c           |   21 +--------------------
 drivers/scsi/fcoe/fcoe_transport.c |   29 +++++++++++++++++++++++++++++
 include/scsi/libfcoe.h             |    2 ++
 3 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index c30fa27..bc52ad9 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2533,28 +2533,9 @@ static void fcoe_set_vport_symbolic_name(struct fc_vport *vport)
 static void fcoe_get_lesb(struct fc_lport *lport,
 			 struct fc_els_lesb *fc_lesb)
 {
-	unsigned int cpu;
-	u32 lfc, vlfc, mdac;
-	struct fcoe_dev_stats *devst;
-	struct fcoe_fc_els_lesb *lesb;
-	struct rtnl_link_stats64 temp;
 	struct net_device *netdev = fcoe_netdev(lport);
 
-	lfc = 0;
-	vlfc = 0;
-	mdac = 0;
-	lesb = (struct fcoe_fc_els_lesb *)fc_lesb;
-	memset(lesb, 0, sizeof(*lesb));
-	for_each_possible_cpu(cpu) {
-		devst = per_cpu_ptr(lport->dev_stats, cpu);
-		lfc += devst->LinkFailureCount;
-		vlfc += devst->VLinkFailureCount;
-		mdac += devst->MissDiscAdvCount;
-	}
-	lesb->lesb_link_fail = htonl(lfc);
-	lesb->lesb_vlink_fail = htonl(vlfc);
-	lesb->lesb_miss_fka = htonl(mdac);
-	lesb->lesb_fcs_error = htonl(dev_get_stats(netdev, &temp)->rx_crc_errors);
+	__fcoe_get_lesb(lport, fc_lesb, netdev);
 }
 
 /**
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 50c8c4a..7264d0d 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -83,6 +83,35 @@ static struct notifier_block libfcoe_notifier = {
 	.notifier_call = libfcoe_device_notification,
 };
 
+void __fcoe_get_lesb(struct fc_lport *lport,
+		     struct fc_els_lesb *fc_lesb,
+		     struct net_device *netdev)
+{
+	unsigned int cpu;
+	u32 lfc, vlfc, mdac;
+	struct fcoe_dev_stats *devst;
+	struct fcoe_fc_els_lesb *lesb;
+	struct rtnl_link_stats64 temp;
+
+	lfc = 0;
+	vlfc = 0;
+	mdac = 0;
+	lesb = (struct fcoe_fc_els_lesb *)fc_lesb;
+	memset(lesb, 0, sizeof(*lesb));
+	for_each_possible_cpu(cpu) {
+		devst = per_cpu_ptr(lport->dev_stats, cpu);
+		lfc += devst->LinkFailureCount;
+		vlfc += devst->VLinkFailureCount;
+		mdac += devst->MissDiscAdvCount;
+	}
+	lesb->lesb_link_fail = htonl(lfc);
+	lesb->lesb_vlink_fail = htonl(vlfc);
+	lesb->lesb_miss_fka = htonl(mdac);
+	lesb->lesb_fcs_error =
+			htonl(dev_get_stats(netdev, &temp)->rx_crc_errors);
+}
+EXPORT_SYMBOL_GPL(__fcoe_get_lesb);
+
 void fcoe_wwn_to_str(u64 wwn, char *buf, int len)
 {
 	u8 wwpn[8];
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 0b2f843..d1e95c6 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -230,6 +230,8 @@ int fcoe_libfc_config(struct fc_lport *, struct fcoe_ctlr *,
 u32 fcoe_fc_crc(struct fc_frame *fp);
 int fcoe_start_io(struct sk_buff *skb);
 int fcoe_get_wwn(struct net_device *netdev, u64 *wwn, int type);
+void __fcoe_get_lesb(struct fc_lport *lport, struct fc_els_lesb *fc_lesb,
+		     struct net_device *netdev);
 void fcoe_wwn_to_str(u64 wwn, char *buf, int len);
 int fcoe_validate_vport_create(struct fc_vport *vport);
 
-- 
1.7.0.6


