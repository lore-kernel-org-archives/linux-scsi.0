From: Meelis Roos <mroos@linux.ee>
Subject: Re: bisected regression: qla2xxx endianness on sparc64
Date: Wed, 3 Jun 2015 11:20:35 +0300 (EEST)
Message-ID: <alpine.LRH.2.11.1506031116120.16353@math.ut.ee>
References: <alpine.DEB.2.03.1411022004230.3979@cyber.ee> <alpine.OSX.2.00.1411031508560.1960@administrators-macbook-pro.local> <20141110141519.GA12347@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:56550 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbbFCIRm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Jun 2015 04:17:42 -0400
In-Reply-To: <20141110141519.GA12347@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Joe Carnuccio <joe.carnuccio@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Christoph Hellwig <hch@lst.de>, qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>

On Mon, 10 Nov 2014, Christoph Hellwig wrote:

> On Mon, Nov 03, 2014 at 03:09:47PM -0500, Chad Dupuis wrote:
> > We should revert that change. What were some of the other failures you were
> > seeing?
> 
> Can you please send me the revert ASAP?

Since QLogic is still silent on this one, I will send it to you:

Revert change that breaks QLA2XXX on big-endian systems, 
__constant_cpu_to_le16() is still needed.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 42bb357..88d3143 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -91,7 +91,7 @@ struct nvram_24xx {
 	/* Firmware Initialization Control Block. */
 	uint16_t version;
 	uint16_t reserved_1;
-	__le16 frame_payload_size;
+	uint16_t frame_payload_size;
 	uint16_t execution_throttle;
 	uint16_t exchange_count;
 	uint16_t hard_address;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 285cb20..ed973a1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2658,18 +2658,18 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 			nv->firmware_options[1] = BIT_7 | BIT_5;
 			nv->add_firmware_options[0] = BIT_5;
 			nv->add_firmware_options[1] = BIT_5 | BIT_4;
-			nv->frame_payload_size = 2048;
+			nv->frame_payload_size = __constant_cpu_to_le16(2048);
 			nv->special_options[1] = BIT_7;
 		} else if (IS_QLA2200(ha)) {
 			nv->firmware_options[0] = BIT_2 | BIT_1;
 			nv->firmware_options[1] = BIT_7 | BIT_5;
 			nv->add_firmware_options[0] = BIT_5;
 			nv->add_firmware_options[1] = BIT_5 | BIT_4;
-			nv->frame_payload_size = 1024;
+			nv->frame_payload_size = __constant_cpu_to_le16(1024);
 		} else if (IS_QLA2100(ha)) {
 			nv->firmware_options[0] = BIT_3 | BIT_1;
 			nv->firmware_options[1] = BIT_5;
-			nv->frame_payload_size = 1024;
+			nv->frame_payload_size = __constant_cpu_to_le16(1024);
 		}
 
 		nv->max_iocb_allocation = __constant_cpu_to_le16(256);
@@ -2705,7 +2705,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	 * are valid.
 	 */
 	if (ia64_platform_is("sn2")) {
-		nv->frame_payload_size = 2048;
+		nv->frame_payload_size = __constant_cpu_to_le16(2048);
 		if (IS_QLA23XX(ha))
 			nv->special_options[1] = BIT_7;
 	}
@@ -5022,7 +5022,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 		memset(nv, 0, ha->nvram_size);
 		nv->nvram_version = __constant_cpu_to_le16(ICB_VERSION);
 		nv->version = __constant_cpu_to_le16(ICB_VERSION);
-		nv->frame_payload_size = 2048;
+		nv->frame_payload_size = __constant_cpu_to_le16(2048);
 		nv->execution_throttle = __constant_cpu_to_le16(0xFFFF);
 		nv->exchange_count = __constant_cpu_to_le16(0);
 		nv->hard_address = __constant_cpu_to_le16(124);
@@ -5969,7 +5969,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 		memset(nv, 0, ha->nvram_size);
 		nv->nvram_version = __constant_cpu_to_le16(ICB_VERSION);
 		nv->version = __constant_cpu_to_le16(ICB_VERSION);
-		nv->frame_payload_size = 2048;
+		nv->frame_payload_size = __constant_cpu_to_le16(2048);
 		nv->execution_throttle = __constant_cpu_to_le16(0xFFFF);
 		nv->exchange_count = __constant_cpu_to_le16(0);
 		nv->port_name[0] = 0x21;

-- 
Meelis Roos (mroos@linux.ee)
