From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 2/2] storvsc: remove unnecessary channel inbound lock
Date: Thu, 18 May 2017 09:18:12 -0700
Message-ID: <20170518161812.14124-3-sthemmin@microsoft.com>
References: <20170518161812.14124-1-sthemmin@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170518161812.14124-1-sthemmin@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, kys@microsoft.com
Cc: devel@linuxdriverproject.org, Stephen Hemminger <sthemmin@microsoft.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In storvsc driver, inbound messages do not go through inbound lock.
The only effect of this lock was is to provide a barrier for
connect and remove logic.

Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 drivers/hv/channel_mgmt.c  | 1 -
 drivers/scsi/storvsc_drv.c | 8 +++-----
 include/linux/hyperv.h     | 1 -
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 735f9363f2e4..685572bae1f0 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -332,7 +332,6 @@ static struct vmbus_channel *alloc_channel(void)
 	if (!channel)
 		return NULL;
 
-	spin_lock_init(&channel->inbound_lock);
 	spin_lock_init(&channel->lock);
 
 	INIT_LIST_HEAD(&channel->sc_list);
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index f8a1649e4c63..8d955db6424f 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1206,13 +1206,13 @@ static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size,
 static int storvsc_dev_remove(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
-	unsigned long flags;
 
 	stor_device = hv_get_drvdata(device);
 
-	spin_lock_irqsave(&device->channel->inbound_lock, flags);
 	stor_device->destroy = true;
-	spin_unlock_irqrestore(&device->channel->inbound_lock, flags);
+
+	/* Make sure flag is set before waiting */
+	wmb();
 
 	/*
 	 * At this point, all outbound traffic should be disable. We
@@ -1229,9 +1229,7 @@ static int storvsc_dev_remove(struct hv_device *device)
 	 * we have drained - to drain the outgoing packets, we need to
 	 * allow incoming packets.
 	 */
-	spin_lock_irqsave(&device->channel->inbound_lock, flags);
 	hv_set_drvdata(device, NULL);
-	spin_unlock_irqrestore(&device->channel->inbound_lock, flags);
 
 	/* Close the channel */
 	vmbus_close(device->channel);
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index e09fc8290c2f..b7d7bbec74e0 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -744,7 +744,6 @@ struct vmbus_channel {
 	u32 ringbuffer_pagecount;
 	struct hv_ring_buffer_info outbound;	/* send to parent */
 	struct hv_ring_buffer_info inbound;	/* receive from parent */
-	spinlock_t inbound_lock;
 
 	struct vmbus_close_msg close_msg;
 
-- 
2.11.0
