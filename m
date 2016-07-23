From: james.smart@broadcom.com (James Smart)
Subject: [PATCH] nvme-fabrics: patch target code in prep for FC transport
 support
Date: Fri, 22 Jul 2016 17:23:51 -0700
Message-ID: <5792b917.3oKKdzw3zzjpaClb%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34366 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbcGWAXx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2016 20:23:53 -0400
Received: by mail-pa0-f54.google.com with SMTP id fi15so43870006pac.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2016 17:23:53 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org


Patch nvme-fabrics target code in prep for FC transport support:
- Add FC transport type decoding
- Add FC address family decoding

Patch is cut against the linux-nvme for-4.8/drivers branch

Note: this patch had been posted to the prior nvme fabrics repository but
not merged before being brought over to linux-nvme.

Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/nvme/target/configfs.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index af5e2dc..6ffd105 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -37,6 +37,8 @@ static ssize_t nvmet_addr_adrfam_show(struct config_item *item,
 		return sprintf(page, "ipv6\n");
 	case NVMF_ADDR_FAMILY_IB:
 		return sprintf(page, "ib\n");
+	case NVMF_ADDR_FAMILY_FC:
+		return sprintf(page, "fc\n");
 	default:
 		return sprintf(page, "\n");
 	}
@@ -59,6 +61,8 @@ static ssize_t nvmet_addr_adrfam_store(struct config_item *item,
 		port->disc_addr.adrfam = NVMF_ADDR_FAMILY_IP6;
 	} else if (sysfs_streq(page, "ib")) {
 		port->disc_addr.adrfam = NVMF_ADDR_FAMILY_IB;
+	} else if (sysfs_streq(page, "fc")) {
+		port->disc_addr.adrfam = NVMF_ADDR_FAMILY_FC;
 	} else {
 		pr_err("Invalid value '%s' for adrfam\n", page);
 		return -EINVAL;
@@ -209,6 +213,8 @@ static ssize_t nvmet_addr_trtype_show(struct config_item *item,
 		return sprintf(page, "rdma\n");
 	case NVMF_TRTYPE_LOOP:
 		return sprintf(page, "loop\n");
+	case NVMF_TRTYPE_FC:
+		return sprintf(page, "fc\n");
 	default:
 		return sprintf(page, "\n");
 	}
@@ -229,6 +235,12 @@ static void nvmet_port_init_tsas_loop(struct nvmet_port *port)
 	memset(&port->disc_addr.tsas, 0, NVMF_TSAS_SIZE);
 }
 
+static void nvmet_port_init_tsas_fc(struct nvmet_port *port)
+{
+	port->disc_addr.trtype = NVMF_TRTYPE_FC;
+	memset(&port->disc_addr.tsas, 0, NVMF_TSAS_SIZE);
+}
+
 static ssize_t nvmet_addr_trtype_store(struct config_item *item,
 		const char *page, size_t count)
 {
@@ -244,6 +256,8 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
 		nvmet_port_init_tsas_rdma(port);
 	} else if (sysfs_streq(page, "loop")) {
 		nvmet_port_init_tsas_loop(port);
+	} else if (sysfs_streq(page, "fc")) {
+		nvmet_port_init_tsas_fc(port);
 	} else {
 		pr_err("Invalid value '%s' for trtype\n", page);
 		return -EINVAL;
-- 
2.5.0

