From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: vmbus: fix init_vp_index() for reloading
 hv_netvsc
Date: Thu, 13 Aug 2015 17:07:03 -0700
Message-ID: <1439510823-16280-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
List-Id: linux-scsi@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

This fixes the recent commit 3b71107d73b16074afa7658f3f0fcf837aabfe24:
Drivers: hv: vmbus: Further improve CPU affiliation logic

Without the fix, reloading hv_netvsc hangs the guest.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/channel_mgmt.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 3ab4753..8a4105c 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -204,6 +204,8 @@ void hv_process_channel_removal(struct vmbus_channel *channel, u32 relid)
 		spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
 		list_del(&channel->listentry);
 		spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
+
+		primary_channel = channel;
 	} else {
 		primary_channel = channel->primary_channel;
 		spin_lock_irqsave(&primary_channel->lock, flags);
@@ -211,6 +213,14 @@ void hv_process_channel_removal(struct vmbus_channel *channel, u32 relid)
 		primary_channel->num_sc--;
 		spin_unlock_irqrestore(&primary_channel->lock, flags);
 	}
+
+	/*
+	 * We need to free the bit for init_vp_index() to work in the case
+	 * of sub-channel, when we reload drivers like hv_netvsc.
+	 */
+	cpumask_clear_cpu(channel->target_cpu,
+			  &primary_channel->alloced_cpus_in_node);
+
 	free_channel(channel);
 }
 
@@ -457,6 +467,13 @@ static void init_vp_index(struct vmbus_channel *channel, const uuid_le *type_gui
 			continue;
 		}
 
+		/*
+		 * NOTE: in the case of sub-channel, we clear the sub-channel
+		 * related bit(s) in primary->alloced_cpus_in_node in
+		 * hv_process_channel_removal(), so when we reload drivers
+		 * like hv_netvsc in SMP guest, here we're able to re-allocate
+		 * bit from primary->alloced_cpus_in_node.
+		 */
 		if (!cpumask_test_cpu(cur_cpu,
 				&primary->alloced_cpus_in_node)) {
 			cpumask_set_cpu(cur_cpu,
-- 
1.7.4.1
