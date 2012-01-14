From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v5 5/7] libsas: fix sas_unregister_ports vs sas_drain_work
Date: Sat, 14 Jan 2012 10:10:34 -0800
Message-ID: <20120114181029.25887.26129.stgit@localhost6.localdomain6>
References: <20120114180904.25887.75601.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120114180904.25887.75601.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>
List-Id: linux-scsi@vger.kernel.org

We need to hold drain_mutex across the unregistration as port down events
queue device removal as chained events, so we need to make sure no other
drainers are active.

[ 1118.673968] WARNING: at kernel/workqueue.c:996 __queue_work+0x11a/0x326()
[ 1118.681982] Hardware name: S2600CP
[ 1118.686193] Modules linked in: isci(-) libsas scsi_transport_sas nls_utf8
ipv6 uinput sg iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core ioatdma dca
sd_mod sr_mod cdrom ahci libahci libata [last unloaded: scsi_transport_sas]
[ 1118.709893] Pid: 6831, comm: rmmod Not tainted 3.2.0-isci+ #1
[ 1118.716727] Call Trace:
[ 1118.719867]  [<ffffffff8103e9f5>] warn_slowpath_common+0x85/0x9d
[ 1118.727000]  [<ffffffff8103ea27>] warn_slowpath_null+0x1a/0x1c
[ 1118.733942]  [<ffffffff81056d44>] __queue_work+0x11a/0x326
[ 1118.740481]  [<ffffffff81056f99>] queue_work_on+0x1b/0x22
[ 1118.746925]  [<ffffffff81057106>] queue_work+0x37/0x3e
[ 1118.753105]  [<ffffffffa0120e05>] ? sas_discover_event+0x55/0x82 [libsas]
[ 1118.761094]  [<ffffffff813217c3>] scsi_queue_work+0x42/0x44
[ 1118.767717]  [<ffffffffa0120e19>] sas_discover_event+0x69/0x82 [libsas]
[ 1118.775509]  [<ffffffffa0120f5b>] sas_unregister_dev+0xc3/0xcc [libsas]
[ 1118.783319]  [<ffffffffa0120fae>] sas_unregister_domain_devices+0x4a/0xc8 [libsas]
[ 1118.792731]  [<ffffffffa0120071>] sas_deform_port+0x60/0x1a6 [libsas]
[ 1118.800339]  [<ffffffffa01201ea>] sas_unregister_ports+0x33/0x44 [libsas]
[ 1118.808342]  [<ffffffffa011f7e5>] sas_unregister_ha+0x41/0x6b [libsas]
[ 1118.816055]  [<ffffffffa0134055>] isci_unregister+0x22/0x4d [isci]
[ 1118.823384]  [<ffffffffa0143040>] isci_pci_remove+0x2e/0x60 [isci]

Reported-by: Jacek Danecki <jacek.danecki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_init.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index dc93e118..1e13cf4 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -163,14 +163,18 @@ int sas_unregister_ha(struct sas_ha_struct *sas_ha)
 	unsigned long flags;
 
 	/* Set the state to unregistered to avoid further unchained
-	 * events to be queued
+	 * events to be queued, but since sas_unregister_ports()
+	 * generates unchained events relative to any in progress drains
+	 * we need to hold drain_mutex.
 	 */
+	mutex_lock(&sas_ha->drain_mutex);
 	spin_lock_irqsave(&sas_ha->state_lock, flags);
 	clear_bit(SAS_HA_REGISTERED, &sas_ha->state);
 	spin_unlock_irqrestore(&sas_ha->state_lock, flags);
-	sas_drain_work(sas_ha);
 
 	sas_unregister_ports(sas_ha);
+	mutex_unlock(&sas_ha->drain_mutex);
+
 	sas_drain_work(sas_ha);
 
 	if (sas_ha->lldd_max_execute_num > 1) {

