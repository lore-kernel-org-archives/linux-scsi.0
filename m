From: Vaishali Thakkar <vthakkar1994@gmail.com>
Subject: [PATCH v2] [SCSI] qla4xxx: Replace __constant_cpu_to_le16 with
 cpu_to_le16
Date: Sat, 6 Jun 2015 06:15:12 +0530
Message-ID: <20150606004512.GA8197@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

In big endian cases, macro cpu_to_le16 unfolds to __swab16 which
provides special case for constants. In little endian cases,
__constant_cpu_to_le16 and cpu_to_le16 expand directly to the
same expression. So, replace __constant_cpu_to_le16 with
cpu_to_le16 with the goal of getting rid of the definition of
__constant_cpu_to_le16 completely.

The semantic patch that performs this transformation is as follows:

@@expression x;@@

- __constant_cpu_to_le16(x)
+ cpu_to_le16(x)

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
Changes since v1:
	- Make subject more concise
---
 drivers/scsi/qla4xxx/ql4_nx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 7c33658..06d6cce 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -3741,9 +3741,9 @@ qla4_8xxx_get_flt_info(struct scsi_qla_host *ha, uint32_t flt_addr)
 			goto no_flash_data;
 	}
 
-	if (*wptr == __constant_cpu_to_le16(0xffff))
+	if (*wptr == cpu_to_le16(0xffff))
 		goto no_flash_data;
-	if (flt->version != __constant_cpu_to_le16(1)) {
+	if (flt->version != cpu_to_le16(1)) {
 		DEBUG2(ql4_printk(KERN_INFO, ha, "Unsupported FLT detected: "
 			"version=0x%x length=0x%x checksum=0x%x.\n",
 			le16_to_cpu(flt->version), le16_to_cpu(flt->length),
@@ -3846,7 +3846,7 @@ qla4_82xx_get_fdt_info(struct scsi_qla_host *ha)
 	qla4_82xx_read_optrom_data(ha, (uint8_t *)ha->request_ring,
 	    hw->flt_region_fdt << 2, OPTROM_BURST_SIZE);
 
-	if (*wptr == __constant_cpu_to_le16(0xffff))
+	if (*wptr == cpu_to_le16(0xffff))
 		goto no_flash_data;
 
 	if (fdt->sig[0] != 'Q' || fdt->sig[1] != 'L' || fdt->sig[2] != 'I' ||
-- 
1.9.1
