From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm + blk-mq soft lockup complaint
Date: Wed, 14 Jan 2015 10:16:12 +0100
Message-ID: <54B633DC.4090806@sandisk.com>
References: <54B3FFAE.4070609@kernel.dk>
 <alpine.LNX.2.00.1501121738000.4026@localhost.lm.intel.com>
 <54B40E8A.6010005@kernel.dk>
 <alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
 <alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
 <20150112191138.GC21518@redhat.com> <20150112202113.GA23234@redhat.com>
 <54B50F9D.2040000@sandisk.com> <20150113141746.GA30411@redhat.com>
 <54B52B73.7040807@sandisk.com> <20150113162052.GA30837@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------050405030609050102030001"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0058.outbound.protection.outlook.com ([207.46.100.58]:46499
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751182AbbANJQX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2015 04:16:23 -0500
In-Reply-To: <20150113162052.GA30837@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, linux-scsi@vger.kernel.org

--------------050405030609050102030001
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit

On 01/13/15 17:21, Mike Snitzer wrote:
> OK, I assume you specified the mpath device for the test that failed.

Yes, of course ...

> This test works fine on my 100MB scsi_debug device with 4 paths exported
> over virtio-blk to a guest that assembles the mpath device.
> 
> Could be a hang that is unique to scsi-mq.
> 
> Any chance you'd be willing to provide a HOWTO for setting up your
> SRP/iscsi configuration?
> 
> Are you carrying any related changes that are not upstream?  (I can hunt
> down the email in this thread where you describe your kernel tree...)
> 
> I'll try to reproduce but this info could be useful to others that are
> more scsi-mq inclined who might need to chase this too.

The four patches I had used in my tests at the initiator side and that
are not yet in v3.19-rc4 have been attached to this e-mail (I have not
yet had the time to post all of these patches for review).

This is how my I had configured the initiator system:
* If the version of the srptools package supplied by your distro is
lower than 1.0.2, build and install the latest version from the source
code available at git://git.openfabrics.org/~bvanassche/srptools.git/.git.
* Install the latest version of lsscsi
(http://sg.danny.cz/scsi/lsscsi.html). This version has SRP transport
support but is not yet in any distro AFAIK.
* Build and install a kernel >= v3.19-rc4 that includes the dm patches
at the start of this e-mail thread.
* Check whether the IB links are up (should display "State: Active"):
ibstat | grep State:
* Spread completion interrupts statically over CPU cores, e.g. via the
attached script (spread-mlx4-ib-interrupts).
* Check whether the SRP target system is visible from the SRP initiator
system - the command below should print at least one line:
ibsrpdm -c
* Enable blk-mq:
echo Y > /sys/module/scsi_mod/parameters/use_blk_mq
* Configure the SRP kernel module parameters as follows:
echo 'options ib_srp cmd_sg_entries=255 dev_loss_tmo=60 ch_count=6' >
/etc/modprobe.d/ib_srp.conf
* Unload and reload the SRP initiator kernel module to apply these
parameters:
rmmod ib_srp; modprobe ib_srp
* Start srpd and wait until SRP login has finished:
systemctl start srpd
while ! lsscsi -t | grep -q srp:; do sleep 1; done
* Start multipathd and check the table it has built:
systemctl start multipathd
dmsetup table /dev/dm-0
* Set the I/O scheduler to noop, disable add_random and set rq_affinity
to 2 for all SRP and dm block devices.
* Run the I/O load of your preference.

Please let me know if you need any further information.

Bart.

--------------050405030609050102030001
Content-Type: text/x-patch;
	name="0001-e1000-Avoid-that-e1000_netpoll-triggers-a-kernel-war.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-e1000-Avoid-that-e1000_netpoll-triggers-a-kernel-war.pa";
	filename*1="tch"

>From 664b7adce6c09b9c939b4983f7f32b7539497ef4 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 2 Jan 2015 14:52:07 +0100
Subject: [PATCH 1/4] e1000: Avoid that e1000_netpoll() triggers a kernel
 warning

console_cont_flush(), which is called by console_unlock(), calls
call_console_drivers() and hence also the netconsole function
write_msg() with local interrupts disabled. This means that it is
not allowed to call disable_irq() from inside a netpoll callback
function. Hence eliminate the disable_irq() / enable_irq() pair
from the e1000 netpoll function. This patch avoids that the e1000
networking driver triggers the following complaint:

BUG: sleeping function called from invalid context at kernel/irq/manage.c:104

Call Trace:
 [<ffffffff814d1ec5>] dump_stack+0x4c/0x65
 [<ffffffff8107bcc5>] ___might_sleep+0x175/0x230
 [<ffffffff8107bdba>] __might_sleep+0x3a/0xa0
 [<ffffffff810a78c8>] synchronize_irq+0x38/0xa0
 [<ffffffff810a7a20>] disable_irq+0x20/0x30
 [<ffffffffa04b4442>] e1000_netpoll+0x102/0x130 [e1000e]
 [<ffffffff813ffff2>] netpoll_poll_dev+0x72/0x350
 [<ffffffff81400489>] netpoll_send_skb_on_dev+0x1b9/0x2b0
 [<ffffffff81400842>] netpoll_send_udp+0x2c2/0x430
 [<ffffffffa058187f>] write_msg+0xcf/0x120 [netconsole]
 [<ffffffff810a4682>] call_console_drivers.constprop.25+0xc2/0x250
 [<ffffffff810a5588>] console_unlock+0x328/0x4c0
 [<ffffffff810a59f0>] vprintk_emit+0x2d0/0x570
 [<ffffffff810a5def>] vprintk_default+0x1f/0x30
 [<ffffffff814cf680>] printk+0x46/0x48

See also "[RFC PATCH net-next 00/11] net: remove disable_irq() from
->ndo_poll_controller" (http://thread.gmane.org/gmane.linux.network/342096).

See also patch "sched/wait: Add might_sleep() checks" (kernel v3.19-rc1;
commit e22b886a8a43).

Reported-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 drivers/net/ethernet/intel/e1000/e1000.h      |  5 +++++
 drivers/net/ethernet/intel/e1000/e1000_main.c | 27 ++++++++++++++++++++++-----
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000.h b/drivers/net/ethernet/intel/e1000/e1000.h
index 6970710..d85d19f 100644
--- a/drivers/net/ethernet/intel/e1000/e1000.h
+++ b/drivers/net/ethernet/intel/e1000/e1000.h
@@ -323,6 +323,11 @@ struct e1000_adapter {
 	struct delayed_work watchdog_task;
 	struct delayed_work fifo_stall_task;
 	struct delayed_work phy_info_task;
+
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	/* Used to serialize e1000 interrupts and the e1000 netpoll callback. */
+	spinlock_t netpoll_lock;
+#endif
 };
 
 enum e1000_state_t {
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 83140cb..e5866f1 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -1313,6 +1313,9 @@ static int e1000_sw_init(struct e1000_adapter *adapter)
 	e1000_irq_disable(adapter);
 
 	spin_lock_init(&adapter->stats_lock);
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	spin_lock_init(&adapter->netpoll_lock);
+#endif
 
 	set_bit(__E1000_DOWN, &adapter->flags);
 
@@ -3747,10 +3750,8 @@ void e1000_update_stats(struct e1000_adapter *adapter)
  * @irq: interrupt number
  * @data: pointer to a network interface device structure
  **/
-static irqreturn_t e1000_intr(int irq, void *data)
+static irqreturn_t __e1000_intr(int irq, struct e1000_adapter *adapter)
 {
-	struct net_device *netdev = data;
-	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
 	u32 icr = er32(ICR);
 
@@ -3792,6 +3793,24 @@ static irqreturn_t e1000_intr(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t e1000_intr(int irq, void *data)
+{
+	struct net_device *netdev = data;
+	struct e1000_adapter *adapter = netdev_priv(netdev);
+	irqreturn_t ret;
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->netpoll_lock, flags);
+	ret = __e1000_intr(irq, adapter);
+	spin_unlock_irqrestore(&adapter->netpoll_lock, flags);
+#else
+	ret = __e1000_intr(irq, adapter);
+#endif
+
+	return ret;
+}
+
 /**
  * e1000_clean - NAPI Rx polling callback
  * @adapter: board private structure
@@ -5216,9 +5235,7 @@ static void e1000_netpoll(struct net_device *netdev)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
-	disable_irq(adapter->pdev->irq);
 	e1000_intr(adapter->pdev->irq, netdev);
-	enable_irq(adapter->pdev->irq);
 }
 #endif
 
-- 
2.1.2


--------------050405030609050102030001
Content-Type: text/x-patch;
	name="0002-e1000e-Avoid-that-e1000_netpoll-triggers-a-kernel-wa.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0002-e1000e-Avoid-that-e1000_netpoll-triggers-a-kernel-wa.pa";
	filename*1="tch"

>From af2c97b3882a73f9b5a098e6aca322efb341ce6d Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 5 Jan 2015 11:40:23 +0100
Subject: [PATCH 2/4] e1000e: Avoid that e1000_netpoll() triggers a kernel
 warning

---
 drivers/net/ethernet/intel/e1000e/e1000.h  |  5 ++
 drivers/net/ethernet/intel/e1000e/netdev.c | 73 ++++++++++++++++++++++++------
 2 files changed, 65 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index 7785240..e89b80f 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -344,6 +344,11 @@ struct e1000_adapter {
 	struct ptp_clock_info ptp_clock_info;
 
 	u16 eee_advert;
+
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	/* Used to serialize e1000 interrupts and the e1000 netpoll callback. */
+	spinlock_t netpoll_lock;
+#endif
 };
 
 struct e1000_info {
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index e14fd85..c6d0ffb 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -1761,11 +1761,10 @@ static void e1000e_downshift_workaround(struct work_struct *work)
  * @irq: interrupt number
  * @data: pointer to a network interface device structure
  **/
-static irqreturn_t e1000_intr_msi(int __always_unused irq, void *data)
+static irqreturn_t __e1000_intr_msi(struct e1000_adapter *adapter)
 {
-	struct net_device *netdev = data;
-	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
+	struct net_device *netdev = adapter->netdev;
 	u32 icr = er32(ICR);
 
 	/* read ICR disables interrupts using IAM */
@@ -1823,16 +1822,32 @@ static irqreturn_t e1000_intr_msi(int __always_unused irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t e1000_intr_msi(int __always_unused irq, void *data)
+{
+	struct e1000_adapter *adapter = netdev_priv(data);
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&adapter->netpoll_lock, flags);
+	ret = __e1000_intr_msi(adapter);
+	spin_unlock_irqrestore(&adapter->netpoll_lock, flags);
+
+	return ret;
+#else
+	return __e1000_intr_msi(adapter);
+#endif
+}
+
 /**
  * e1000_intr - Interrupt Handler
  * @irq: interrupt number
  * @data: pointer to a network interface device structure
  **/
-static irqreturn_t e1000_intr(int __always_unused irq, void *data)
+static irqreturn_t __e1000_intr(struct e1000_adapter *adapter)
 {
-	struct net_device *netdev = data;
-	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
+	struct net_device *netdev = adapter->netdev;
 	u32 rctl, icr = er32(ICR);
 
 	if (!icr || test_bit(__E1000_DOWN, &adapter->state))
@@ -1903,6 +1918,23 @@ static irqreturn_t e1000_intr(int __always_unused irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t e1000_intr(int __always_unused irq, void *data)
+{
+	struct e1000_adapter *adapter = netdev_priv(data);
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&adapter->netpoll_lock, flags);
+	ret = __e1000_intr(adapter);
+	spin_unlock_irqrestore(&adapter->netpoll_lock, flags);
+
+	return ret;
+#else
+	return __e1000_intr(adapter);
+#endif
+}
+
 static irqreturn_t e1000_msix_other(int __always_unused irq, void *data)
 {
 	struct net_device *netdev = data;
@@ -4180,6 +4212,9 @@ static int e1000_sw_init(struct e1000_adapter *adapter)
 	adapter->rx_ring_count = E1000_DEFAULT_RXD;
 
 	spin_lock_init(&adapter->stats64_lock);
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	spin_lock_init(&adapter->netpoll_lock);
+#endif
 
 	e1000e_set_interrupt_capability(adapter);
 
@@ -6437,10 +6472,9 @@ static void e1000_shutdown(struct pci_dev *pdev)
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 
-static irqreturn_t e1000_intr_msix(int __always_unused irq, void *data)
+static irqreturn_t __e1000_intr_msix(struct e1000_adapter *adapter)
 {
-	struct net_device *netdev = data;
-	struct e1000_adapter *adapter = netdev_priv(netdev);
+	struct net_device *netdev = adapter->netdev;
 
 	if (adapter->msix_entries) {
 		int vector, msix_irq;
@@ -6467,6 +6501,23 @@ static irqreturn_t e1000_intr_msix(int __always_unused irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t e1000_intr_msix(int __always_unused irq, void *data)
+{
+	struct e1000_adapter *adapter = netdev_priv(data);
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->netpoll_lock, flags);
+	ret = __e1000_intr_msix(adapter);
+	spin_unlock_irqrestore(&adapter->netpoll_lock, flags);
+
+	return ret;
+#else
+	return __e1000_intr_msix(adapter);
+#endif
+}
+
 /**
  * e1000_netpoll
  * @netdev: network interface device structure
@@ -6484,14 +6535,10 @@ static void e1000_netpoll(struct net_device *netdev)
 		e1000_intr_msix(adapter->pdev->irq, netdev);
 		break;
 	case E1000E_INT_MODE_MSI:
-		disable_irq(adapter->pdev->irq);
 		e1000_intr_msi(adapter->pdev->irq, netdev);
-		enable_irq(adapter->pdev->irq);
 		break;
 	default:		/* E1000E_INT_MODE_LEGACY */
-		disable_irq(adapter->pdev->irq);
 		e1000_intr(adapter->pdev->irq, netdev);
-		enable_irq(adapter->pdev->irq);
 		break;
 	}
 }
-- 
2.1.2


--------------050405030609050102030001
Content-Type: text/x-patch;
	name="0003-Avoid-that-sd_shutdown-triggers-a-kernel-warning.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0003-Avoid-that-sd_shutdown-triggers-a-kernel-warning.patch"

>From 54e10ead0a0e98bdf39a631c65c0a585211ffa22 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 5 Jan 2015 10:51:13 +0100
Subject: [PATCH 3/4] Avoid that sd_shutdown() triggers a kernel warning

Since kernel v3.19-rc1 module_refcount() returns 1 instead of 0
when called from inside module_exit(). This breaks the
module_refcount() test in scsi_device_put() and hence causes the
following kernel warning to be reported when unloading the ib_srp
kernel module:

WARNING: CPU: 5 PID: 228 at kernel/module.c:954 module_put+0x207/0x220()

Call Trace:
 [<ffffffff814d1fcf>] dump_stack+0x4c/0x65
 [<ffffffff81053ada>] warn_slowpath_common+0x8a/0xc0
 [<ffffffff81053bca>] warn_slowpath_null+0x1a/0x20
 [<ffffffff810d0507>] module_put+0x207/0x220
 [<ffffffffa000bea8>] scsi_device_put+0x48/0x50 [scsi_mod]
 [<ffffffffa03676d2>] scsi_disk_put+0x32/0x50 [sd_mod]
 [<ffffffffa0368d4c>] sd_shutdown+0x8c/0x150 [sd_mod]
 [<ffffffffa0368e79>] sd_remove+0x69/0xc0 [sd_mod]
 [<ffffffff813457ef>] __device_release_driver+0x7f/0xf0
 [<ffffffff81345885>] device_release_driver+0x25/0x40
 [<ffffffff81345134>] bus_remove_device+0x124/0x1b0
 [<ffffffff8134189e>] device_del+0x13e/0x250
 [<ffffffffa001cdcd>] __scsi_remove_device+0xcd/0xe0 [scsi_mod]
 [<ffffffffa001b39f>] scsi_forget_host+0x6f/0x80 [scsi_mod]
 [<ffffffffa000d5f6>] scsi_remove_host+0x86/0x140 [scsi_mod]
 [<ffffffffa07d5c0b>] srp_remove_work+0x9b/0x210 [ib_srp]
 [<ffffffff8106fd28>] process_one_work+0x1d8/0x780
 [<ffffffff810703eb>] worker_thread+0x11b/0x4a0
 [<ffffffff81075a6f>] kthread+0xef/0x110
 [<ffffffff814dad6c>] ret_from_fork+0x7c/0xb0

See also patch "module: Remove stop_machine from module unloading"
(Masami Hiramatsu; commit e513cc1c07e2; kernel v3.19-rc1).

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c        | 63 ++++++++++++++++++++++++++++++++--------------
 drivers/scsi/sd.c          | 44 +++++++++++++++++---------------
 include/scsi/scsi_device.h |  2 ++
 3 files changed, 70 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e028854..2cae46b 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -973,30 +973,63 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 EXPORT_SYMBOL(scsi_report_opcode);
 
 /**
- * scsi_device_get  -  get an additional reference to a scsi_device
+ * scsi_dev_get - get an additional reference to a scsi_device
  * @sdev:	device to get a reference to
+ * @get_lld:    whether or not to increase the LLD kernel module refcount
  *
- * Description: Gets a reference to the scsi_device and increments the use count
- * of the underlying LLDD module.  You must hold host_lock of the
- * parent Scsi_Host or already have a reference when calling this.
+ * Description: Gets a reference to the scsi_device and optionally increments
+ * the use count of the associated LLDD module. You must hold host_lock of
+ * the parent Scsi_Host or already have a reference when calling this.
  */
-int scsi_device_get(struct scsi_device *sdev)
+int scsi_dev_get(struct scsi_device *sdev, bool get_lld)
 {
 	if (sdev->sdev_state == SDEV_DEL)
 		return -ENXIO;
 	if (!get_device(&sdev->sdev_gendev))
 		return -ENXIO;
-	/* We can fail this if we're doing SCSI operations
-	 * from module exit (like cache flush) */
-	try_module_get(sdev->host->hostt->module);
+	/* Can fail if invoked during module exit (like cache flush) */
+	if (get_lld && !try_module_get(sdev->host->hostt->module)) {
+		put_device(&sdev->sdev_gendev);
+		return -ENXIO;
+	}
 
 	return 0;
 }
+EXPORT_SYMBOL(scsi_dev_get);
+
+/**
+ * scsi_dev_put - release a reference to a scsi_device
+ * @sdev:	device to release a reference on
+ * @put_lld:    whether or not to decrease the LLD kernel module refcount
+ *
+ * Description: Release a reference to the scsi_device. The device is freed
+ * once the last user vanishes.
+ */
+void scsi_dev_put(struct scsi_device *sdev, bool put_lld)
+{
+	if (put_lld)
+		module_put(sdev->host->hostt->module);
+	put_device(&sdev->sdev_gendev);
+}
+EXPORT_SYMBOL(scsi_dev_put);
+
+/**
+ * scsi_device_get - get an additional reference to a scsi_device
+ * @sdev:	device to get a reference to
+ *
+ * Description: Gets a reference to the scsi_device and increments the use count
+ * of the underlying LLDD module.  You must hold host_lock of the
+ * parent Scsi_Host or already have a reference when calling this.
+ */
+int scsi_device_get(struct scsi_device *sdev)
+{
+	return scsi_dev_get(sdev, true);
+}
 EXPORT_SYMBOL(scsi_device_get);
 
 /**
- * scsi_device_put  -  release a reference to a scsi_device
- * @sdev:	device to release a reference on.
+ * scsi_device_put - release a reference to a scsi_device
+ * @sdev:	device to release a reference on
  *
  * Description: Release a reference to the scsi_device and decrements the use
  * count of the underlying LLDD module.  The device is freed once the last
@@ -1004,15 +1037,7 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-#ifdef CONFIG_MODULE_UNLOAD
-	struct module *module = sdev->host->hostt->module;
-
-	/* The module refcount will be zero if scsi_device_get()
-	 * was called from a module removal routine */
-	if (module && module_refcount(module) != 0)
-		module_put(module);
-#endif
-	put_device(&sdev->sdev_gendev);
+	scsi_dev_put(sdev, true);
 }
 EXPORT_SYMBOL(scsi_device_put);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3995169..bd641a8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -564,13 +564,13 @@ static int sd_major(int major_idx)
 	}
 }
 
-static struct scsi_disk *__scsi_disk_get(struct gendisk *disk)
+static struct scsi_disk *__scsi_disk_get(struct gendisk *disk, bool get_lld)
 {
 	struct scsi_disk *sdkp = NULL;
 
 	if (disk->private_data) {
 		sdkp = scsi_disk(disk);
-		if (scsi_device_get(sdkp->device) == 0)
+		if (scsi_dev_get(sdkp->device, get_lld) == 0)
 			get_device(&sdkp->dev);
 		else
 			sdkp = NULL;
@@ -578,35 +578,36 @@ static struct scsi_disk *__scsi_disk_get(struct gendisk *disk)
 	return sdkp;
 }
 
-static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
+static struct scsi_disk *scsi_disk_get(struct gendisk *disk, bool get_lld)
 {
 	struct scsi_disk *sdkp;
 
 	mutex_lock(&sd_ref_mutex);
-	sdkp = __scsi_disk_get(disk);
+	sdkp = __scsi_disk_get(disk, get_lld);
 	mutex_unlock(&sd_ref_mutex);
 	return sdkp;
 }
 
-static struct scsi_disk *scsi_disk_get_from_dev(struct device *dev)
+static struct scsi_disk *scsi_disk_get_from_dev(struct device *dev,
+						bool get_lld)
 {
 	struct scsi_disk *sdkp;
 
 	mutex_lock(&sd_ref_mutex);
 	sdkp = dev_get_drvdata(dev);
 	if (sdkp)
-		sdkp = __scsi_disk_get(sdkp->disk);
+		sdkp = __scsi_disk_get(sdkp->disk, get_lld);
 	mutex_unlock(&sd_ref_mutex);
 	return sdkp;
 }
 
-static void scsi_disk_put(struct scsi_disk *sdkp)
+static void scsi_disk_put(struct scsi_disk *sdkp, bool put_lld)
 {
 	struct scsi_device *sdev = sdkp->device;
 
 	mutex_lock(&sd_ref_mutex);
 	put_device(&sdkp->dev);
-	scsi_device_put(sdev);
+	scsi_dev_put(sdev, put_lld);
 	mutex_unlock(&sd_ref_mutex);
 }
 
@@ -1184,7 +1185,7 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
  **/
 static int sd_open(struct block_device *bdev, fmode_t mode)
 {
-	struct scsi_disk *sdkp = scsi_disk_get(bdev->bd_disk);
+	struct scsi_disk *sdkp = scsi_disk_get(bdev->bd_disk, true);
 	struct scsi_device *sdev;
 	int retval;
 
@@ -1239,7 +1240,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 	return 0;
 
 error_out:
-	scsi_disk_put(sdkp);
+	scsi_disk_put(sdkp, true);
 	return retval;	
 }
 
@@ -1273,7 +1274,7 @@ static void sd_release(struct gendisk *disk, fmode_t mode)
 	 * XXX is followed by a "rmmod sd_mod"?
 	 */
 
-	scsi_disk_put(sdkp);
+	scsi_disk_put(sdkp, true);
 }
 
 static int sd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
@@ -1525,11 +1526,11 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 
 static void sd_rescan(struct device *dev)
 {
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, true);
 
 	if (sdkp) {
 		revalidate_disk(sdkp->disk);
-		scsi_disk_put(sdkp);
+		scsi_disk_put(sdkp, true);
 	}
 }
 
@@ -3143,11 +3144,14 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 /*
  * Send a SYNCHRONIZE CACHE instruction down to the device through
  * the normal SCSI command structure.  Wait for the command to
- * complete.
+ * complete.  Since this function can be called during SCSI LLD kernel
+ * module unload and since try_module_get() fails after kernel module
+ * unload has started this function must not try to increase the SCSI
+ * LLD kernel module refcount.
  */
 static void sd_shutdown(struct device *dev)
 {
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, false);
 
 	if (!sdkp)
 		return;         /* this can happen */
@@ -3166,12 +3170,12 @@ static void sd_shutdown(struct device *dev)
 	}
 
 exit:
-	scsi_disk_put(sdkp);
+	scsi_disk_put(sdkp, false);
 }
 
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 {
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, true);
 	int ret = 0;
 
 	if (!sdkp)
@@ -3197,7 +3201,7 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 	}
 
 done:
-	scsi_disk_put(sdkp);
+	scsi_disk_put(sdkp, true);
 	return ret;
 }
 
@@ -3213,7 +3217,7 @@ static int sd_suspend_runtime(struct device *dev)
 
 static int sd_resume(struct device *dev)
 {
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, true);
 	int ret = 0;
 
 	if (!sdkp->device->manage_start_stop)
@@ -3223,7 +3227,7 @@ static int sd_resume(struct device *dev)
 	ret = sd_start_stop_device(sdkp, 1);
 
 done:
-	scsi_disk_put(sdkp);
+	scsi_disk_put(sdkp, true);
 	return ret;
 }
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3a4edd1..a4cb852 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -330,6 +330,8 @@ extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
 void scsi_attach_vpd(struct scsi_device *sdev);
 
+extern int scsi_dev_get(struct scsi_device *, bool get_lld);
+extern void scsi_dev_put(struct scsi_device *, bool put_lld);
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
-- 
2.1.2


--------------050405030609050102030001
Content-Type: text/x-patch;
	name="0004-IB-srp-Process-REQ_PREEMPT-requests-correctly.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0004-IB-srp-Process-REQ_PREEMPT-requests-correctly.patch"

>From 6f593a0e9fcfd9b6c99fd24ac981450ed6eb0a0f Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 8 Jan 2015 09:42:45 +0100
Subject: [PATCH 4/4] IB/srp: Process REQ_PREEMPT requests correctly

Reported-by: Max Gurtuvoy <maxg@mellanox.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 0747c05..77a7a2f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2003,8 +2003,13 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	if (in_scsi_eh)
 		mutex_lock(&rport->mutex);
 
+	/*
+	 * The "blocked" state of SCSI devices is ignored by the SCSI core for
+	 * REQ_PREEMPT requests. Hence the explicit check below for the SCSI
+	 * device state.
+	 */
 	scmnd->result = srp_chkready(target->rport);
-	if (unlikely(scmnd->result))
+	if (unlikely(scmnd->result != 0 || scsi_device_blocked(scmnd->device)))
 		goto err;
 
 	WARN_ON_ONCE(scmnd->request->tag < 0);
-- 
2.1.2


--------------050405030609050102030001
Content-Type: text/plain; charset="us-ascii";
	name="spread-mlx4-ib-interrupts"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="spread-mlx4-ib-interrupts"

#!/bin/awk -f

BEGIN {
  "ls -1d /sys/devices/system/node/node* 2>&1 | wc -l" | getline nodes
  if (nodes > 1) {
    for (i = 0; i < nodes; i++) {
      cpus_per_node = 0
      while (("cd /sys/devices/system/cpu && ls -d cpu*/node" i " | sed 's/^cpu//;s,/.*,,'|sort -n" | getline j) > 0) {
        #print "[" i ", " cpus_per_node "]: " j
        cpu[i, cpus_per_node++] = j
      }
    }
  } else {
      cpus_per_node = 0
      while (("cd /sys/devices/system/cpu && ls -d cpu[0-9]* | sed 's/^cpu//'|sort -n" | getline j) > 0) {
        #print "[0, " cpus_per_node "]: " j
        cpu[0, cpus_per_node++] = j
      }
  }
  for (i = 0; i < nodes; i++)
      nextcpu[i] = 0
  while (("sed -n 's/.*mlx4-ib-\\([0-9]*\\)-[0-9]*@\\(.*\\)$/\\1 \\2/p' /proc/interrupts | uniq" | getline) > 0) {
    port = $1
    bus = substr($0, length($1) + 2)
    #print "port = " port "; bus = " bus
    irqcount = 0
    while (("sed -n 's/^[[:blank:]]*\\([0-9]*\\):[0-9[:blank:]]*[^[:blank:]]*[[:blank:]]*\\(mlx4-ib-" port "-[0-9]*@" bus "\\)$/\\1 \\2/p' </proc/interrupts" | getline) > 0) {
      irq[irqcount] = $1
      irqname[irqcount] = substr($0, length($1) + 2)
      irqcount++
    }
    for (i = 0; i < nodes; i++) {
      ch_start = i * irqcount / nodes
      ch_end = (i + 1) * irqcount / nodes
      for (ch = ch_start; ch < ch_end; ch++) {
        c = cpu[i, nextcpu[i]++ % cpus_per_node]
        if (nodes > 1)
            nodetxt =  " (node " i ")"
        else
            nodetxt = ""
        print "IRQ " irq[ch] " (" irqname[ch] "): CPU " c nodetxt
        cmd="echo " c " >/proc/irq/" irq[ch] "/smp_affinity_list"
	#print cmd
	system(cmd)
      }
    }
  }
  exit 0
}

--------------050405030609050102030001--
