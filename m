From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/3] IB/srp: Handle partial connection success correctly
Date: Fri, 31 Jul 2015 14:13:22 -0700
Message-ID: <55BBE4F2.3030700@sandisk.com>
References: <55BBE4A2.5090505@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55BBE4A2.5090505-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Avoid that the following kernel warning is reported if the SRP
target system accepts fewer channels per connection than what
was requested by the initiator system:

WARNING: at drivers/infiniband/ulp/srp/ib_srp.c:617 srp_destroy_qp+0xb1/0x120 [ib_srp]()
Call Trace:
[<ffffffff8105d67f>] warn_slowpath_common+0x7f/0xc0
[<ffffffff8105d6da>] warn_slowpath_null+0x1a/0x20
[<ffffffffa05419e1>] srp_destroy_qp+0xb1/0x120 [ib_srp]
[<ffffffffa05445fb>] srp_create_ch_ib+0x19b/0x420 [ib_srp]
[<ffffffffa0545257>] srp_create_target+0x7d7/0xa94 [ib_srp]
[<ffffffff8138dac0>] dev_attr_store+0x20/0x30
[<ffffffff812079ef>] sysfs_write_file+0xef/0x170
[<ffffffff81191fc4>] vfs_write+0xb4/0x130
[<ffffffff8119276f>] sys_write+0x5f/0xa0
[<ffffffff815a0a59>] system_call_fastpath+0x16/0x1b

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/ulp/srp/ib_srp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 61dadac..ab18665 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3262,7 +3262,7 @@ static ssize_t srp_create_target(struct device *dev,
 					srp_free_ch_ib(target, ch);
 					srp_free_req_data(target, ch);
 					target->ch_count = ch - target->ch;
-					break;
+					goto connected;
 				}
 			}
 
@@ -3272,6 +3272,7 @@ static ssize_t srp_create_target(struct device *dev,
 		node_idx++;
 	}
 
+connected:
 	target->scsi_host->nr_hw_queues = target->ch_count;
 
 	ret = srp_add_target(host, target);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
