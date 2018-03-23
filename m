From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH 2/3] Netvsc: Use the vmbus functiton to calculate ring buffer
 percentage
Date: Thu, 22 Mar 2018 17:15:37 -0700
Message-ID: <20180323001538.31876-2-longli@linuxonhyperv.com>
References: <20180323001538.31876-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180323001538.31876-1-longli@linuxonhyperv.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, devel@linuxdriverproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

In Vmbus, we have defined a function to calculate available ring buffer
percentage to write.

Use that function and remove duplicate netvsc code.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/hyperv/netvsc.c     | 17 +++--------------
 drivers/net/hyperv/netvsc_drv.c |  3 ---
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 0265d703eb03..8af0069e4d8c 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -31,7 +31,6 @@
 #include <linux/vmalloc.h>
 #include <linux/rtnetlink.h>
 #include <linux/prefetch.h>
-#include <linux/reciprocal_div.h>
 
 #include <asm/sync_bitops.h>
 
@@ -590,17 +589,6 @@ void netvsc_device_remove(struct hv_device *device)
 #define RING_AVAIL_PERCENT_HIWATER 20
 #define RING_AVAIL_PERCENT_LOWATER 10
 
-/*
- * Get the percentage of available bytes to write in the ring.
- * The return value is in range from 0 to 100.
- */
-static u32 hv_ringbuf_avail_percent(const struct hv_ring_buffer_info *ring_info)
-{
-	u32 avail_write = hv_get_bytes_to_write(ring_info);
-
-	return reciprocal_divide(avail_write  * 100, netvsc_ring_reciprocal);
-}
-
 static inline void netvsc_free_send_slot(struct netvsc_device *net_device,
 					 u32 index)
 {
@@ -649,7 +637,8 @@ static void netvsc_send_tx_complete(struct netvsc_device *net_device,
 		wake_up(&net_device->wait_drain);
 
 	if (netif_tx_queue_stopped(netdev_get_tx_queue(ndev, q_idx)) &&
-	    (hv_ringbuf_avail_percent(&channel->outbound) > RING_AVAIL_PERCENT_HIWATER ||
+	    (hv_get_avail_to_write_percent(&channel->outbound) >
+	     RING_AVAIL_PERCENT_HIWATER ||
 	     queue_sends < 1)) {
 		netif_tx_wake_queue(netdev_get_tx_queue(ndev, q_idx));
 		ndev_ctx->eth_stats.wake_queue++;
@@ -757,7 +746,7 @@ static inline int netvsc_send_pkt(
 	struct netdev_queue *txq = netdev_get_tx_queue(ndev, packet->q_idx);
 	u64 req_id;
 	int ret;
-	u32 ring_avail = hv_ringbuf_avail_percent(&out_channel->outbound);
+	u32 ring_avail = hv_get_avail_to_write_percent(&out_channel->outbound);
 
 	nvmsg.hdr.msg_type = NVSP_MSG1_TYPE_SEND_RNDIS_PKT;
 	if (skb)
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index faea0be18924..b0b1c2fd2b7b 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -35,7 +35,6 @@
 #include <linux/slab.h>
 #include <linux/rtnetlink.h>
 #include <linux/netpoll.h>
-#include <linux/reciprocal_div.h>
 
 #include <net/arp.h>
 #include <net/route.h>
@@ -55,7 +54,6 @@ static unsigned int ring_size __ro_after_init = 128;
 module_param(ring_size, uint, S_IRUGO);
 MODULE_PARM_DESC(ring_size, "Ring buffer size (# of pages)");
 unsigned int netvsc_ring_bytes __ro_after_init;
-struct reciprocal_value netvsc_ring_reciprocal __ro_after_init;
 
 static const u32 default_msg = NETIF_MSG_DRV | NETIF_MSG_PROBE |
 				NETIF_MSG_LINK | NETIF_MSG_IFUP |
@@ -2186,7 +2184,6 @@ static int __init netvsc_drv_init(void)
 			ring_size);
 	}
 	netvsc_ring_bytes = ring_size * PAGE_SIZE;
-	netvsc_ring_reciprocal = reciprocal_value(netvsc_ring_bytes);
 
 	ret = vmbus_driver_register(&netvsc_drv);
 	if (ret)
-- 
2.14.1
