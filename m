From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 1/3] Resolve circular lock warning and is_vendor check
Date: Thu, 23 Dec 2010 21:35:51 -0800
Message-ID: <1293168951.4676.509.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1496 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab0LXFgS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Dec 2010 00:36:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: mchan@broadcom.com, michaelc@cs.wisc.edu, yi.zou@intel.com

Resolve circular lock between fcoe_config_mutex and ft_mutex.
Fixed the is_vendor check to add vendor drivers to the head.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/fcoe/fcoe.c              |    8 ++++----
 drivers/scsi/fcoe/libfcoe_transport.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 8382f5a..711d441 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2349,16 +2349,16 @@ static int __init fcoe_init(void)
 	unsigned int cpu;
 	int rc = 0;
 
-	mutex_lock(&fcoe_config_mutex);
-
 	/* register as a fcoe transport */
 	rc = fcoe_transport_attach(&fcoe_sw_transport);
 	if (rc) {
 		printk(KERN_ERR "failed to register an fcoe transport, check "
 			"if libfcoe is loaded\n");
-		goto out_unlock;
+		goto out_return;
 	}
 
+	mutex_lock(&fcoe_config_mutex);
+
 	for_each_possible_cpu(cpu) {
 		p = &per_cpu(fcoe_percpu, cpu);
 		skb_queue_head_init(&p->fcoe_rx_list);
@@ -2386,8 +2386,8 @@ out_free:
 	for_each_online_cpu(cpu) {
 		fcoe_percpu_thread_destroy(cpu);
 	}
-out_unlock:
 	mutex_unlock(&fcoe_config_mutex);
+out_return:
 	return rc;
 }
 module_init(fcoe_init);
diff --git a/drivers/scsi/fcoe/libfcoe_transport.c b/drivers/scsi/fcoe/libfcoe_transport.c
index fec0fb8..8fd29ea 100644
--- a/drivers/scsi/fcoe/libfcoe_transport.c
+++ b/drivers/scsi/fcoe/libfcoe_transport.c
@@ -127,7 +127,7 @@ int fcoe_transport_attach(struct fcoe_transport *ft)
 	}
 
 	/* Add vendor specific transport to the head */
-	if (!ft->is_vendor)
+	if (ft->is_vendor)
 		list_add(&ft->list, &fcoe_transports);
 	else
 		list_add_tail(&ft->list, &fcoe_transports);
-- 
1.7.0.6




