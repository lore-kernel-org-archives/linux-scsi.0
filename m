From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 03/12] IB/srp: Remove an extraneous scsi_host_put() from an
 error path
Date: Thu, 30 Apr 2015 10:57:36 +0200
Message-ID: <5541EE80.6070505@sandisk.com>
References: <5541EE21.3050809@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5541EE21.3050809-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Fix a scsi_get_host() / scsi_host_put() imbalance in the error
path of srp_create_target(). See also patch "IB/srp: Avoid that
I/O hangs due to a cable pull during LUN scanning" (commit ID
34aa654ecb8e).

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #v3.19
---
 drivers/infiniband/ulp/srp/ib_srp.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 918814c..5ce6cfd 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3172,11 +3172,11 @@ static ssize_t srp_create_target(struct device *dev,
 
 	ret = srp_parse_options(buf, target);
 	if (ret)
-		goto err;
+		goto out;
 
 	ret = scsi_init_shared_tag_map(target_host, target_host->can_queue);
 	if (ret)
-		goto err;
+		goto out;
 
 	target->req_ring_size = target->queue_size - SRP_TSK_MGMT_SQ_SIZE;
 
@@ -3187,7 +3187,7 @@ static ssize_t srp_create_target(struct device *dev,
 			     be64_to_cpu(target->ioc_guid),
 			     be64_to_cpu(target->initiator_ext));
 		ret = -EEXIST;
-		goto err;
+		goto out;
 	}
 
 	if (!srp_dev->has_fmr && !srp_dev->has_fr && !target->allow_ext_sg &&
@@ -3208,7 +3208,7 @@ static ssize_t srp_create_target(struct device *dev,
 	spin_lock_init(&target->lock);
 	ret = ib_query_gid(ibdev, host->port, 0, &target->sgid);
 	if (ret)
-		goto err;
+		goto out;
 
 	ret = -ENOMEM;
 	target->ch_count = max_t(unsigned, num_online_nodes(),
@@ -3219,7 +3219,7 @@ static ssize_t srp_create_target(struct device *dev,
 	target->ch = kcalloc(target->ch_count, sizeof(*target->ch),
 			     GFP_KERNEL);
 	if (!target->ch)
-		goto err;
+		goto out;
 
 	node_idx = 0;
 	for_each_online_node(node) {
@@ -3315,9 +3315,6 @@ err_disconnect:
 	}
 
 	kfree(target->ch);
-
-err:
-	scsi_host_put(target_host);
 	goto out;
 }
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
