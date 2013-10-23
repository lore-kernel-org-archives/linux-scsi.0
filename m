From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] SCSI fixes for 3.12-rc6
Date: Wed, 23 Oct 2013 15:07:14 +0100
Message-ID: <1382537234.21850.7.camel@dabdike>
References: <1382527624.16097.23.camel@dabdike.quadriga.com>
	 <CA+55aFzo-sA4P_rMC1wWfLp50QswfP0GdLxMQ+Wbw8ArK5capw@mail.gmail.com>
	 <1382530790.16097.29.camel@dabdike.quadriga.com>
	 <CA+55aFyLpN6aym28n96+eO-cJhopZ5G9Er=nHvf-d4i72fQsGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyLpN6aym28n96+eO-cJhopZ5G9Er=nHvf-d4i72fQsGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-10-23 at 13:42 +0100, Linus Torvalds wrote:
> You need to think about *WHY* we had a "new driver" exception. And
> realize that it probably will never actually be relevant for any SCSI
> driver (not counting things like USB storage etc).

OK, point taken, here's the new pull request

----

This is a set of 2 fixes which cause oopses (Buslogic, qla2xxx) and 1
fix which may cause a hang because of request miscounting (sd).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Aaron Lu (1):
      sd: call blk_pm_runtime_init before add_disk

Chad Dupuis (1):
      qla2xxx: Fix request queue null dereference.

Khalid Aziz (1):
      BusLogic: Fix an oops when intializing multimaster adapter

And the diffstat:

 drivers/scsi/BusLogic.c        | 16 ++++++++--------
 drivers/scsi/qla2xxx/qla_dbg.c |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c |  9 +++++++++
 drivers/scsi/sd.c              |  2 +-
 4 files changed, 19 insertions(+), 10 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index feab3a5..757eb07 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -696,7 +696,7 @@ static int __init blogic_init_mm_probeinfo(struct blogic_adapter *adapter)
 	while ((pci_device = pci_get_device(PCI_VENDOR_ID_BUSLOGIC,
 					PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER,
 					pci_device)) != NULL) {
-		struct blogic_adapter *adapter = adapter;
+		struct blogic_adapter *host_adapter = adapter;
 		struct blogic_adapter_info adapter_info;
 		enum blogic_isa_ioport mod_ioaddr_req;
 		unsigned char bus;
@@ -744,9 +744,9 @@ static int __init blogic_init_mm_probeinfo(struct blogic_adapter *adapter)
 		   known and enabled, note that the particular Standard ISA I/O
 		   Address should not be probed.
 		 */
-		adapter->io_addr = io_addr;
-		blogic_intreset(adapter);
-		if (blogic_cmd(adapter, BLOGIC_INQ_PCI_INFO, NULL, 0,
+		host_adapter->io_addr = io_addr;
+		blogic_intreset(host_adapter);
+		if (blogic_cmd(host_adapter, BLOGIC_INQ_PCI_INFO, NULL, 0,
 				&adapter_info, sizeof(adapter_info)) ==
 				sizeof(adapter_info)) {
 			if (adapter_info.isa_port < 6)
@@ -762,7 +762,7 @@ static int __init blogic_init_mm_probeinfo(struct blogic_adapter *adapter)
 		   I/O Address assigned at system initialization.
 		 */
 		mod_ioaddr_req = BLOGIC_IO_DISABLE;
-		blogic_cmd(adapter, BLOGIC_MOD_IOADDR, &mod_ioaddr_req,
+		blogic_cmd(host_adapter, BLOGIC_MOD_IOADDR, &mod_ioaddr_req,
 				sizeof(mod_ioaddr_req), NULL, 0);
 		/*
 		   For the first MultiMaster Host Adapter enumerated,
@@ -779,12 +779,12 @@ static int __init blogic_init_mm_probeinfo(struct blogic_adapter *adapter)
 
 			fetch_localram.offset = BLOGIC_AUTOSCSI_BASE + 45;
 			fetch_localram.count = sizeof(autoscsi_byte45);
-			blogic_cmd(adapter, BLOGIC_FETCH_LOCALRAM,
+			blogic_cmd(host_adapter, BLOGIC_FETCH_LOCALRAM,
 					&fetch_localram, sizeof(fetch_localram),
 					&autoscsi_byte45,
 					sizeof(autoscsi_byte45));
-			blogic_cmd(adapter, BLOGIC_GET_BOARD_ID, NULL, 0, &id,
-					sizeof(id));
+			blogic_cmd(host_adapter, BLOGIC_GET_BOARD_ID, NULL, 0,
+					&id, sizeof(id));
 			if (id.fw_ver_digit1 == '5')
 				force_scan_order =
 					autoscsi_byte45.force_scan_order;
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 2ef497e..ee5c183 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -20,7 +20,7 @@
  * | Device Discovery             |       0x2095       | 0x2020-0x2022, |
  * |                              |                    | 0x2011-0x2012, |
  * |                              |                    | 0x2016         |
- * | Queue Command and IO tracing |       0x3058       | 0x3006-0x300b  |
+ * | Queue Command and IO tracing |       0x3059       | 0x3006-0x300b  |
  * |                              |                    | 0x3027-0x3028  |
  * |                              |                    | 0x303d-0x3041  |
  * |                              |                    | 0x302d,0x3033  |
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index df1b30b..ff9c86b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1957,6 +1957,15 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	que = MSW(sts->handle);
 	req = ha->req_q_map[que];
 
+	/* Check for invalid queue pointer */
+	if (req == NULL ||
+	    que >= find_first_zero_bit(ha->req_qid_map, ha->max_req_queues)) {
+		ql_dbg(ql_dbg_io, vha, 0x3059,
+		    "Invalid status handle (0x%x): Bad req pointer. req=%p, "
+		    "que=%u.\n", sts->handle, req, que);
+		return;
+	}
+
 	/* Validate handle. */
 	if (handle < req->num_outstanding_cmds)
 		sp = req->outstanding_cmds[handle];
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e62d17d..5693f6d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2854,6 +2854,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 		gd->events |= DISK_EVENT_MEDIA_CHANGE;
 	}
 
+	blk_pm_runtime_init(sdp->request_queue, dev);
 	add_disk(gd);
 	if (sdkp->capacity)
 		sd_dif_config_host(sdkp);
@@ -2862,7 +2863,6 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
-	blk_pm_runtime_init(sdp->request_queue, dev);
 	scsi_autopm_put_device(sdp);
 	put_device(&sdkp->dev);
 }
