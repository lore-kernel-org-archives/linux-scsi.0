From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: fix crash in automatic module unloading
Date: Tue, 26 Feb 2008 23:30:57 +0100 (CET)
Message-ID: <tkrat.6515bdc94ebad712@s5r6.in-berlin.de>
References: <tkrat.43f73e8c841b3161@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.43f73e8c841b3161@s5r6.in-berlin.de>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

"modprobe firewire-ohci; sleep .1; modprobe -r firewire-ohci" used to
result in crashes like this:

    BUG: unable to handle kernel paging request at ffffffff8807b455
    IP: [<ffffffff8807b455>]
    PGD 203067 PUD 207063 PMD 7c170067 PTE 0
    Oops: 0010 [1] PREEMPT SMP 
    CPU 0 
    Modules linked in: i915 drm cpufreq_ondemand acpi_cpufreq freq_table applesmc input_polldev led_class coretemp hwmon eeprom snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss button thermal processor sg snd_hda_intel snd_pcm snd_timer snd snd_page_alloc sky2 i2c_i801 rtc [last unloaded: crc_itu_t]
    Pid: 9, comm: events/0 Not tainted 2.6.25-rc2 #3
    RIP: 0010:[<ffffffff8807b455>]  [<ffffffff8807b455>]
    RSP: 0018:ffff81007dcdde88  EFLAGS: 00010246
    RAX: ffff81007dc95040 RBX: ffff81007dee5390 RCX: 0000000000005e13
    RDX: 0000000000008c8b RSI: 0000000000000001 RDI: ffff81007dee5388
    RBP: ffff81007dc5eb40 R08: 0000000000000002 R09: ffffffff8022d05c
    R10: ffffffff8023b34c R11: ffffffff8041a353 R12: ffff81007dee5388
    R13: ffffffff8807b455 R14: ffffffff80593bc0 R15: 0000000000000000
    FS:  0000000000000000(0000) GS:ffffffff8055a000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
    CR2: ffffffff8807b455 CR3: 0000000000201000 CR4: 00000000000006e0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    Process events/0 (pid: 9, threadinfo ffff81007dcdc000, task ffff81007dc95040)
    Stack:  ffffffff8023b396 ffffffff88082524 0000000000000000 ffffffff8807d9ae
    ffff81007dc5eb40 ffff81007dc9dce0 ffff81007dc5eb40 ffff81007dc5eb80
    ffff81007dc9dce0 ffffffffffffffff ffffffff8023be87 0000000000000000
    Call Trace:
    [<ffffffff8023b396>] ? run_workqueue+0xdf/0x1df
    [<ffffffff8023be87>] ? worker_thread+0xd8/0xe3
    [<ffffffff8023e917>] ? autoremove_wake_function+0x0/0x2e
    [<ffffffff8023bdaf>] ? worker_thread+0x0/0xe3
    [<ffffffff8023e813>] ? kthread+0x47/0x74
    [<ffffffff804198e0>] ? trace_hardirqs_on_thunk+0x35/0x3a
    [<ffffffff8020c008>] ? child_rip+0xa/0x12
    [<ffffffff8020b6e3>] ? restore_args+0x0/0x3d
    [<ffffffff8023e68a>] ? kthreadd+0x14c/0x171
    [<ffffffff8023e68a>] ? kthreadd+0x14c/0x171
    [<ffffffff8023e7cc>] ? kthread+0x0/0x74
    [<ffffffff8020bffe>] ? child_rip+0x0/0x12


    Code:  Bad RIP value.
    RIP  [<ffffffff8807b455>]
    RSP <ffff81007dcdde88>
    CR2: ffffffff8807b455
    ---[ end trace c7366c6657fe5bed ]---

Note that this crash happened _after_ firewire-core was unloaded.  The
shared workqueue tried to run firewire-core's device initialization jobs
or similar jobs.

The fix makes sure that firewire-ohci and hence firewire-core is not
unloaded before all device shutdown jobs have been completed.  This is
determined by the count of device initializations minus device releases.

Also skip useless retries in the node initialization job if the node is
to be shut down.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Update:  Refreshed to be applicable after patch "firewire: fw-sbp2:
better fix for NULL pointer dereference in scsi_remove_device".


 drivers/firewire/fw-card.c        |   10 +++++++++-
 drivers/firewire/fw-device.c      |   21 ++++++---------------
 drivers/firewire/fw-device.h      |   16 ++++++++++++++--
 drivers/firewire/fw-sbp2.c        |    3 +++
 drivers/firewire/fw-transaction.h |    2 ++
 5 files changed, 34 insertions(+), 18 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -18,6 +18,7 @@
 
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/crc-itu-t.h>
@@ -398,6 +399,7 @@ fw_card_initialize(struct fw_card *card,
 	static atomic_t index = ATOMIC_INIT(-1);
 
 	kref_init(&card->kref);
+	atomic_set(&card->device_count, 0);
 	card->index = atomic_inc_return(&index);
 	card->driver = driver;
 	card->device = device;
@@ -528,8 +530,14 @@ fw_core_remove_card(struct fw_card *card
 	card->driver = &dummy_driver;
 
 	fw_destroy_nodes(card);
-	flush_scheduled_work();
+	/*
+	 * Wait for all device workqueue jobs to finish.  Otherwise the
+	 * firewire-core module could be unloaded before the jobs ran.
+	 */
+	while (atomic_read(&card->device_count) > 0)
+		msleep(100);
 
+	cancel_delayed_work_sync(&card->work);
 	fw_flush_transactions(card);
 	del_timer_sync(&card->flush_timer);
 
Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -150,21 +150,10 @@ struct bus_type fw_bus_type = {
 };
 EXPORT_SYMBOL(fw_bus_type);
 
-struct fw_device *fw_device_get(struct fw_device *device)
-{
-	get_device(&device->device);
-
-	return device;
-}
-
-void fw_device_put(struct fw_device *device)
-{
-	put_device(&device->device);
-}
-
 static void fw_device_release(struct device *dev)
 {
 	struct fw_device *device = fw_device(dev);
+	struct fw_card *card = device->card;
 	unsigned long flags;
 
 	/*
@@ -176,9 +165,9 @@ static void fw_device_release(struct dev
 	spin_unlock_irqrestore(&device->card->lock, flags);
 
 	fw_node_put(device->node);
-	fw_card_put(device->card);
 	kfree(device->config_rom);
 	kfree(device);
+	atomic_dec(&card->device_count);
 }
 
 int fw_device_enable_phys_dma(struct fw_device *device)
@@ -668,7 +657,8 @@ static void fw_device_init(struct work_s
 	 */
 
 	if (read_bus_info_block(device, device->generation) < 0) {
-		if (device->config_rom_retries < MAX_RETRIES) {
+		if (device->config_rom_retries < MAX_RETRIES &&
+		    atomic_read(&device->state) == FW_DEVICE_INITIALIZING) {
 			device->config_rom_retries++;
 			schedule_delayed_work(&device->work, RETRY_DELAY);
 		} else {
@@ -805,7 +795,8 @@ void fw_node_event(struct fw_card *card,
 		 */
 		device_initialize(&device->device);
 		atomic_set(&device->state, FW_DEVICE_INITIALIZING);
-		device->card = fw_card_get(card);
+		atomic_inc(&card->device_count);
+		device->card = card;
 		device->node = fw_node_get(node);
 		device->node_id = node->node_id;
 		device->generation = card->generation;
Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -791,6 +791,7 @@ static void sbp2_release_target(struct k
 
 	put_device(&tgt->unit->device);
 	scsi_host_put(shost);
+	fw_device_put(fw_device(tgt->unit->device.parent));
 }
 
 static struct workqueue_struct *sbp2_wq;
@@ -1088,6 +1089,8 @@ static int sbp2_probe(struct device *dev
 	if (scsi_add_host(shost, &unit->device) < 0)
 		goto fail_shost_put;
 
+	fw_device_get(device);
+
 	/* Initialize to values that won't match anything in our table. */
 	firmware_revision = 0xff000000;
 	model = 0xff000000;
Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -26,6 +26,7 @@
 #include <linux/fs.h>
 #include <linux/dma-mapping.h>
 #include <linux/firewire-constants.h>
+#include <asm/atomic.h>
 
 #define TCODE_IS_READ_REQUEST(tcode)	(((tcode) & ~1) == 4)
 #define TCODE_IS_BLOCK_PACKET(tcode)	(((tcode) &  1) != 0)
@@ -219,6 +220,7 @@ extern struct bus_type fw_bus_type;
 struct fw_card {
 	const struct fw_card_driver *driver;
 	struct device *device;
+	atomic_t device_count;
 	struct kref kref;
 
 	int node_id;
Index: linux/drivers/firewire/fw-device.h
===================================================================
--- linux.orig/drivers/firewire/fw-device.h
+++ linux/drivers/firewire/fw-device.h
@@ -76,9 +76,21 @@ fw_device_is_shutdown(struct fw_device *
 	return atomic_read(&device->state) == FW_DEVICE_SHUTDOWN;
 }
 
-struct fw_device *fw_device_get(struct fw_device *device);
+static inline struct fw_device *
+fw_device_get(struct fw_device *device)
+{
+	get_device(&device->device);
+
+	return device;
+}
+
+static inline void
+fw_device_put(struct fw_device *device)
+{
+	put_device(&device->device);
+}
+
 struct fw_device *fw_device_get_by_devt(dev_t devt);
-void fw_device_put(struct fw_device *device);
 int fw_device_enable_phys_dma(struct fw_device *device);
 
 void fw_device_cdev_update(struct fw_device *device);

-- 
Stefan Richter
-=====-==--- --=- ==-=-
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
