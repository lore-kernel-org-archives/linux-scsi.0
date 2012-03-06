From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] iscsi class: fix gfp use in ping compl and host event
Date: Tue,  6 Mar 2012 16:09:01 -0600
Message-ID: <1331071741-5951-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758988Ab2CFWJK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Mar 2012 17:09:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If a ping or host event were to occur when memory is low
we do not want to use GFP_KERNEL, because the paths
sending them cannot block for data to be written. These
paths might be needed to recover write paths. Use GFP_NOIO
instead.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index fac3173..1cf640e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1486,7 +1486,7 @@ void iscsi_post_host_event(uint32_t host_no, struct iscsi_transport *transport,
 	struct iscsi_uevent *ev;
 	int len = NLMSG_SPACE(sizeof(*ev) + data_size);
 
-	skb = alloc_skb(len, GFP_KERNEL);
+	skb = alloc_skb(len, GFP_NOIO);
 	if (!skb) {
 		printk(KERN_ERR "gracefully ignored host event (%d):%d OOM\n",
 		       host_no, code);
@@ -1504,7 +1504,7 @@ void iscsi_post_host_event(uint32_t host_no, struct iscsi_transport *transport,
 	if (data_size)
 		memcpy((char *)ev + sizeof(*ev), data, data_size);
 
-	iscsi_multicast_skb(skb, ISCSI_NL_GRP_ISCSID, GFP_KERNEL);
+	iscsi_multicast_skb(skb, ISCSI_NL_GRP_ISCSID, GFP_NOIO);
 }
 EXPORT_SYMBOL_GPL(iscsi_post_host_event);
 
@@ -1517,7 +1517,7 @@ void iscsi_ping_comp_event(uint32_t host_no, struct iscsi_transport *transport,
 	struct iscsi_uevent *ev;
 	int len = NLMSG_SPACE(sizeof(*ev) + data_size);
 
-	skb = alloc_skb(len, GFP_KERNEL);
+	skb = alloc_skb(len, GFP_NOIO);
 	if (!skb) {
 		printk(KERN_ERR "gracefully ignored ping comp: OOM\n");
 		return;
@@ -1533,7 +1533,7 @@ void iscsi_ping_comp_event(uint32_t host_no, struct iscsi_transport *transport,
 	ev->r.ping_comp.data_size = data_size;
 	memcpy((char *)ev + sizeof(*ev), data, data_size);
 
-	iscsi_multicast_skb(skb, ISCSI_NL_GRP_ISCSID, GFP_KERNEL);
+	iscsi_multicast_skb(skb, ISCSI_NL_GRP_ISCSID, GFP_NOIO);
 }
 EXPORT_SYMBOL_GPL(iscsi_ping_comp_event);
 
-- 
1.7.7.6

