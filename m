From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 07/12] IB/srp: Remove superfluous casts
Date: Thu, 30 Apr 2015 11:00:23 +0200
Message-ID: <5541EF27.7000207@sandisk.com>
References: <5541EE21.3050809@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0066.outbound.protection.outlook.com ([157.56.110.66]:40838
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751056AbbD3JAb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 05:00:31 -0400
In-Reply-To: <5541EE21.3050809@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

A long time ago the data type int64_t was declared as long long
on x86 systems and as long on PPC systems. Today that data type
is declared as long long on all Linux architectures. This means
that the casts from uint64_t into unsigned long long are
superfluous.  Remove these superfluous casts.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 5d7d790..8b6f166 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -780,7 +780,7 @@ static int srp_send_req(struct srp_rdma_ch *ch, bool multich)
 		shost_printk(KERN_DEBUG, target->scsi_host,
 			     PFX "Topspin/Cisco initiator port ID workaround "
 			     "activated for target GUID %016llx\n",
-			     (unsigned long long) be64_to_cpu(target->ioc_guid));
+			     be64_to_cpu(target->ioc_guid));
 		memset(req->priv.initiator_port_id, 0, 8);
 		memcpy(req->priv.initiator_port_id + 8,
 		       &target->srp_host->srp_dev->dev->node_guid, 8);
@@ -2561,8 +2561,7 @@ static ssize_t show_id_ext(struct device *dev, struct device_attribute *attr,
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
 
-	return sprintf(buf, "0x%016llx\n",
-		       (unsigned long long) be64_to_cpu(target->id_ext));
+	return sprintf(buf, "0x%016llx\n", be64_to_cpu(target->id_ext));
 }
 
 static ssize_t show_ioc_guid(struct device *dev, struct device_attribute *attr,
@@ -2570,8 +2569,7 @@ static ssize_t show_ioc_guid(struct device *dev, struct device_attribute *attr,
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
 
-	return sprintf(buf, "0x%016llx\n",
-		       (unsigned long long) be64_to_cpu(target->ioc_guid));
+	return sprintf(buf, "0x%016llx\n", be64_to_cpu(target->ioc_guid));
 }
 
 static ssize_t show_service_id(struct device *dev,
@@ -2579,8 +2577,7 @@ static ssize_t show_service_id(struct device *dev,
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(dev));
 
-	return sprintf(buf, "0x%016llx\n",
-		       (unsigned long long) be64_to_cpu(target->service_id));
+	return sprintf(buf, "0x%016llx\n", be64_to_cpu(target->service_id));
 }
 
 static ssize_t show_pkey(struct device *dev, struct device_attribute *attr,
@@ -2771,7 +2768,7 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 
 	target->state = SRP_TARGET_SCANNING;
 	sprintf(target->target_name, "SRP.T10:%016llX",
-		 (unsigned long long) be64_to_cpu(target->id_ext));
+		be64_to_cpu(target->id_ext));
 
 	if (scsi_add_host(target->scsi_host, host->srp_dev->dev->dma_device))
 		return -ENODEV;
-- 
2.1.4

