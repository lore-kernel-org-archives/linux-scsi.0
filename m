From: Ke Wei <kewei@marvell.com>
Subject: [PATCH] mvsas: ATAPI LUN issue
Date: Tue, 25 Mar 2008 12:28:23 +0800
Message-ID: <47E87F67.4080501@marvell.com>
Reply-To: kewei@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:29751 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751171AbYCYE2X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Mar 2008 00:28:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, jeff@garzik.org

    I found that sending REPORT_LUNS command to some DVD device will 
cause fis error and controller error record. As a result, scsi mid layer 
get some wrong LUNs. Also I can get some queer messages.

scsi: host 12 channel 0 id 2 lun 0x30302e302f686f73 has a LUN larger 
than currently supported.
scsi: host 12 channel 0 id 2 lun 0x7431322f706f7274 has a LUN larger 
than currently supported.
scsi: host 12 channel 0 id 2 lun 0x2d31323a322f656e has a LUN larger 
than currently supported.
...

    The patch forced to clear the sg buffer of SATA response if FIS is 
error. But I suggest these codes should remove to the libsas module.


Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index e55b903..42f3e90 100644
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -1263,8 +1263,14 @@ static int mvs_sata_done(struct mvs_info *mvi, 
struct sas_task *task,
            SATA_RECEIVED_D2H_FIS(port->taskfileset),
            sizeof(struct dev_to_host_fis));
     tstat->buf_valid_size = sizeof(*resp);
-    if (unlikely(err))
+    if (unlikely(err)) {
+        struct scatterlist *sg = task->scatter;
+        u8 *buf;
         stat = SAS_PROTO_RESPONSE;
+        buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
+        memset(buf, 0, sg->length);
+        kunmap_atomic(buf - sg->offset, KM_IRQ0);
+    }
     return stat;
 }
 
-- 
1.5.4



