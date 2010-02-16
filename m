From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 6/9] fnic: Allow multicast and unicast address registrations
	for fnic
Date: Tue, 16 Feb 2010 12:15:44 -0800
Message-ID: <20100216201544.26581.37215.stgit@localhost.localdomain>
References: <20100216201513.26581.83756.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:33235 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933293Ab0BPUPp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Feb 2010 15:15:45 -0500
In-Reply-To: <20100216201513.26581.83756.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Brian Uchino <buchino@cisco.com>, Herman Lee <hermlee@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Venkata Siva Vijayendra Bhamidipati <vbhamidi@cisco.com>

To enable FIP support in fnic, we have to register with hardware to receive
FIP solication frames on a well-known multicast address.
Before FIP support, the firmware interface allowed multicast address
registrations only for enic devices. This is a minor change in fnic to
allow the firmware interface to now register mcast addresses for fnic too.

Signed-off-by: Brian Uchino <buchino@cisco.com>
Signed-off-by: Herman Lee <hermlee@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fnic/fnic_main.c   |    2 ++
 drivers/scsi/fnic/vnic_devcmd.h |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index fe1b103..5bab7e0 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -620,6 +620,8 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	if (fnic->config.flags & VFCF_FIP_CAPABLE) {
 		shost_printk(KERN_INFO, fnic->lport->host,
 			     "firmware supports FIP\n");
+		/* enable directed and multicast */
+		vnic_dev_packet_filter(fnic->vdev, 1, 1, 0, 0, 0);
 		vnic_dev_add_addr(fnic->vdev, FIP_ALL_ENODE_MACS);
 		vnic_dev_add_addr(fnic->vdev, fnic->ctlr.ctl_src_addr);
 	} else {
diff --git a/drivers/scsi/fnic/vnic_devcmd.h b/drivers/scsi/fnic/vnic_devcmd.h
index d62b906..7c9ccbd 100644
--- a/drivers/scsi/fnic/vnic_devcmd.h
+++ b/drivers/scsi/fnic/vnic_devcmd.h
@@ -94,7 +94,7 @@ enum vnic_devcmd_cmd {
 	CMD_STATS_DUMP          = _CMDC(_CMD_DIR_WRITE, _CMD_VTYPE_ALL, 4),
 
 	/* set Rx packet filter: (u32)a0=filters (see CMD_PFILTER_*) */
-	CMD_PACKET_FILTER	= _CMDCNW(_CMD_DIR_WRITE, _CMD_VTYPE_ENET, 7),
+	CMD_PACKET_FILTER       = _CMDCNW(_CMD_DIR_WRITE, _CMD_VTYPE_ALL, 7),
 
 	/* hang detection notification */
 	CMD_HANG_NOTIFY         = _CMDC(_CMD_DIR_NONE, _CMD_VTYPE_ALL, 8),

