From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 7/11] iscsi bugfixes: dont use GFP_KERNEL for sending errors
Date: Mon, 24 Jul 2006 15:47:34 -0500
Message-ID: <1153774054.1040.38.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:17600 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751444AbWGXUuA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 16:50:00 -0400
Received: from [192.168.0.7] (c-24-118-221-159.hsd1.mn.comcast.net [24.118.221.159])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k6OKnd5V012556
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 15:50:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

iscsi_tcp can send error events from soft irq context so we 
cannot use GFP_KERNEL.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 7b9e8fa..30a47c1 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -634,13 +634,13 @@ mempool_zone_get_skb(struct mempool_zone
 }
 
 static int
-iscsi_broadcast_skb(struct mempool_zone *zone, struct sk_buff *skb)
+iscsi_broadcast_skb(struct mempool_zone *zone, struct sk_buff *skb, gfp_t gfp)
 {
 	unsigned long flags;
 	int rc;
 
 	skb_get(skb);
-	rc = netlink_broadcast(nls, skb, 0, 1, GFP_KERNEL);
+	rc = netlink_broadcast(nls, skb, 0, 1, gfp);
 	if (rc < 0) {
 		mempool_free(skb, zone->pool);
 		printk(KERN_ERR "iscsi: can not broadcast skb (%d)\n", rc);
@@ -749,7 +749,7 @@ void iscsi_conn_error(struct iscsi_cls_c
 	ev->r.connerror.cid = conn->cid;
 	ev->r.connerror.sid = iscsi_conn_get_sid(conn);
 
-	iscsi_broadcast_skb(conn->z_error, skb);
+	iscsi_broadcast_skb(conn->z_error, skb, GFP_ATOMIC);
 
 	dev_printk(KERN_INFO, &conn->dev, "iscsi: detected conn error (%d)\n",
 		   error);
@@ -895,7 +895,7 @@ int iscsi_if_destroy_session_done(struct
 	 * this will occur if the daemon is not up, so we just warn
 	 * the user and when the daemon is restarted it will handle it
 	 */
-	rc = iscsi_broadcast_skb(conn->z_pdu, skb);
+	rc = iscsi_broadcast_skb(conn->z_pdu, skb, GFP_KERNEL);
 	if (rc < 0)
 		dev_printk(KERN_ERR, &conn->dev, "Cannot notify userspace of "
 			  "session destruction event. Check iscsi daemon\n");
@@ -958,7 +958,7 @@ int iscsi_if_create_session_done(struct 
 	 * this will occur if the daemon is not up, so we just warn
 	 * the user and when the daemon is restarted it will handle it
 	 */
-	rc = iscsi_broadcast_skb(conn->z_pdu, skb);
+	rc = iscsi_broadcast_skb(conn->z_pdu, skb, GFP_KERNEL);
 	if (rc < 0)
 		dev_printk(KERN_ERR, &conn->dev, "Cannot notify userspace of "
 			  "session creation event. Check iscsi daemon\n");


