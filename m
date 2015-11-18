From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/srp: Fix a memory leak
Date: Wed, 18 Nov 2015 15:00:02 -0800
Message-ID: <564D02F2.5080200@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

If srp_connect_ch() returns a positive value then that is considered
by its caller as a connection failure but this does not result in a
scsi_host_put() call and additionally causes the srp_create_target()
function to return a positive value while it should return a negative
value. Avoid all this confusion and additionally fix a memory leak by
ensuring that srp_connect_ch() always returns a value that is <= 0.
This patch avoids that a rejected login triggers the following memory
leak:

unreferenced object 0xffff88021b24a220 (size 8):
  comm "srp_daemon", pid 56421, jiffies 4295006762 (age 4240.750s)
  hex dump (first 8 bytes):
    68 6f 73 74 35 38 00 a5                          host58..
  backtrace:
    [<ffffffff8151014a>] kmemleak_alloc+0x7a/0xc0
    [<ffffffff81165c1e>] __kmalloc_track_caller+0xfe/0x160
    [<ffffffff81260d2b>] kvasprintf+0x5b/0x90
    [<ffffffff81260e2d>] kvasprintf_const+0x8d/0xb0
    [<ffffffff81254b0c>] kobject_set_name_vargs+0x3c/0xa0
    [<ffffffff81337e3c>] dev_set_name+0x3c/0x40
    [<ffffffff81355757>] scsi_host_alloc+0x327/0x4b0
    [<ffffffffa03edc8e>] srp_create_target+0x4e/0x8a0 [ib_srp]
    [<ffffffff8133778b>] dev_attr_store+0x1b/0x20
    [<ffffffff811f27fa>] sysfs_kf_write+0x4a/0x60
    [<ffffffff811f1e8e>] kernfs_fop_write+0x14e/0x180
    [<ffffffff81176eef>] __vfs_write+0x2f/0xf0
    [<ffffffff811771e4>] vfs_write+0xa4/0x100
    [<ffffffff81177c64>] SyS_write+0x54/0xc0
    [<ffffffff8151b257>] entry_SYSCALL_64_fastpath+0x12/0x6f

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index eda427f8..3f4786a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -993,16 +993,16 @@ static int srp_connect_ch(struct srp_rdma_ch *ch, bool multich)
 
 	ret = srp_lookup_path(ch);
 	if (ret)
-		return ret;
+		goto out;
 
 	while (1) {
 		init_completion(&ch->done);
 		ret = srp_send_req(ch, multich);
 		if (ret)
-			return ret;
+			goto out;
 		ret = wait_for_completion_interruptible(&ch->done);
 		if (ret < 0)
-			return ret;
+			goto out;
 
 		/*
 		 * The CM event handling code will set status to
@@ -1010,15 +1010,16 @@ static int srp_connect_ch(struct srp_rdma_ch *ch, bool multich)
 		 * back, or SRP_DLID_REDIRECT if we get a lid/qp
 		 * redirect REJ back.
 		 */
-		switch (ch->status) {
+		ret = ch->status;
+		switch (ret) {
 		case 0:
 			ch->connected = true;
-			return 0;
+			goto out;
 
 		case SRP_PORT_REDIRECT:
 			ret = srp_lookup_path(ch);
 			if (ret)
-				return ret;
+				goto out;
 			break;
 
 		case SRP_DLID_REDIRECT:
@@ -1027,13 +1028,16 @@ static int srp_connect_ch(struct srp_rdma_ch *ch, bool multich)
 		case SRP_STALE_CONN:
 			shost_printk(KERN_ERR, target->scsi_host, PFX
 				     "giving up on stale connection\n");
-			ch->status = -ECONNRESET;
-			return ch->status;
+			ret = -ECONNRESET;
+			goto out;
 
 		default:
-			return ch->status;
+			goto out;
 		}
 	}
+
+out:
+	return ret <= 0 ? ret : -ENODEV;
 }
 
 static int srp_inv_rkey(struct srp_rdma_ch *ch, u32 rkey, u32 send_flags)
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
