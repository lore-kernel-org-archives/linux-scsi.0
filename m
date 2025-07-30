Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D18C22127B;
	Wed, 30 Jul 2025 22:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753916097; cv=none; b=KN7V1qTc83fWTqovPXTm/N2WwOewmg6lPAd8yaxZK/tYUCCv75lFsThDOsJa4G8vfvKisszI4IMXy6x5ki6r78p3niuiC9UfkdnHlS4f4nwlXnwFNwSJO/q6iqZr3cnypyiVZFcmrSRBhhJ7v2TaoR1lXD33uR2mM+bhTkcGUB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753916097; c=relaxed/simple;
	bh=pOfy+AFEbv8g+/bl6S8ZK4+BmrUdOjmBq2YoCg+3iQY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ABX+AOCc6lO5s6G2l4d0eCDmvqMNN0Guj7Mt+/F3Ox1wC8aZsYjrBjobTOTNDBTkJR1w4pVZmfahiKjubKL75FqW3rBtD2RsXAeTOD2T7aMnUnWuYznSPDQfk/8lBJE86EH/dHyAwyZM9GSqjTVtY+NgKLr1vNqgcBXZi19l8ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lX7A9++h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lX7A9++h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCA2C4CEE3;
	Wed, 30 Jul 2025 22:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753916096;
	bh=pOfy+AFEbv8g+/bl6S8ZK4+BmrUdOjmBq2YoCg+3iQY=;
	h=Date:From:To:Cc:Subject:From;
	b=lX7A9++h/2CIUqod0w+FBedkfMSGI61KMJjYdsoz2RayDhBCk4qFwlHCbLxjWQJ8/
	 GIsb+BHRbotVjKhtTuLM9AXPKQVqrFSfiKS24JMuNPPSS6rpbZRS5Nh4buA901jyuc
	 /qUEU26slKf+EF+593cTTf5Aw0FsLmjF21V5BVwUJguo8uMa35dsBwyO5pumGUM274
	 NTReLm5P1dqIxoX9OADGzshiIZwnASoDHhcBO1jJrR/kLo5CdK7JSqhOvSkSO3Cy8l
	 mNfIpG8dSIL1q2F+o5dJB44LaWfJa1UI1YeJUllQSbHo6IjHFQlGW6Mej0FqOQzYvU
	 dBJcnxgIWb+Rg==
Date: Wed, 30 Jul 2025 16:54:52 -0600
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Chris Leech <cleech@redhat.com>, Bryan Gurney <bgurney@redhat.com>,
	Nilesh Javali <njavali@marvell.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] scsi: qla2xxx: Fix memcpy field-spanning write issue
Message-ID: <aIqivJeq8kxRUX0N@kspp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

purex_item.iocb is defined as a 64-element u8 array, but 64 is the
minimum size and it can be allocated larger. This makes it a standard
empty flex array.

This was motivated by field-spanning write warnings during FPIN testing.
https://lore.kernel.org/linux-nvme/20250709211919.49100-1-bgurney@redhat.com/

  >  kernel: memcpy: detected field-spanning write (size 60) of single field
  >  "((uint8_t *)fpin_pkt + buffer_copy_offset)"
  >  at drivers/scsi/qla2xxx/qla_isr.c:1221 (size 44)

I removed the outer wrapper from the iocb flex array, so that it can be
linked to `purex_item.size` with `__counted_by`.

These changes remove the default minimum 64-byte allocation, requiring
further changes.

  In `struct scsi_qla_host` the embedded `default_item` is now followed
  by `__default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE]` to reserve space
  that will be used as `default_item.iocb`. This is wrapped using the
  `TRAILING_OVERLAP()` macro helper, which effectively creates a union
  between flexible-array member `default_item.iocb` and `__default_item_iocb`.

  Since `struct pure_item` now contains a flexible-array member, the
  helper must be placed at the end of `struct scsi_qla_host` to prevent
  a `-Wflex-array-member-not-at-end` warning.

  `qla24xx_alloc_purex_item()` is adjusted to no longer expect the
  default minimum size to be part of `sizeof(struct purex_item)`,
  the entire flexible array size is added to the structure size for
  allocation.

This also slightly changes the layout of the purex_item struct, as
2-bytes of padding are added between `size` and `iocb`. The resulting
size is the same, but iocb is shifted 2-bytes (the original `purex_item`
structure was padded at the end, after the 64-byte defined array size).
I don't think this is a problem.

Tested-by: Bryan Gurney <bgurney@redhat.com>
Co-developed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h  | 10 ++++++----
 drivers/scsi/qla2xxx/qla_isr.c  | 17 ++++++++---------
 drivers/scsi/qla2xxx/qla_nvme.c |  2 +-
 drivers/scsi/qla2xxx/qla_os.c   |  5 +++--
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index cb95b7b12051..604e66bead1e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4890,9 +4890,7 @@ struct purex_item {
 			     struct purex_item *pkt);
 	atomic_t in_use;
 	uint16_t size;
-	struct {
-		uint8_t iocb[64];
-	} iocb;
+	uint8_t iocb[] __counted_by(size);
 };
 
 #include "qla_edif.h"
@@ -5101,7 +5099,6 @@ typedef struct scsi_qla_host {
 		struct list_head head;
 		spinlock_t lock;
 	} purex_list;
-	struct purex_item default_item;
 
 	struct name_list_extended gnl;
 	/* Count of active session/fcport */
@@ -5130,6 +5127,11 @@ typedef struct scsi_qla_host {
 #define DPORT_DIAG_IN_PROGRESS                 BIT_0
 #define DPORT_DIAG_CHIP_RESET_IN_PROGRESS      BIT_1
 	uint16_t dport_status;
+
+	/* Must be last --ends in a flexible-array member. */
+	TRAILING_OVERLAP(struct purex_item, default_item, iocb,
+		uint8_t __default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE];
+	);
 } scsi_qla_host_t;
 
 struct qla27xx_image_status {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c4c6b5c6658c..4559b490614d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1077,17 +1077,17 @@ static struct purex_item *
 qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
 {
 	struct purex_item *item = NULL;
-	uint8_t item_hdr_size = sizeof(*item);
 
 	if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
-		item = kzalloc(item_hdr_size +
-		    (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
+		item = kzalloc(struct_size(item, iocb, size), GFP_ATOMIC);
 	} else {
 		if (atomic_inc_return(&vha->default_item.in_use) == 1) {
 			item = &vha->default_item;
 			goto initialize_purex_header;
 		} else {
-			item = kzalloc(item_hdr_size, GFP_ATOMIC);
+			item = kzalloc(
+				struct_size(item, iocb, QLA_DEFAULT_PAYLOAD_SIZE),
+				GFP_ATOMIC);
 		}
 	}
 	if (!item) {
@@ -1127,17 +1127,16 @@ qla24xx_queue_purex_item(scsi_qla_host_t *vha, struct purex_item *pkt,
  * @vha: SCSI driver HA context
  * @pkt: ELS packet
  */
-static struct purex_item
-*qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
+static struct purex_item *
+qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
 {
 	struct purex_item *item;
 
-	item = qla24xx_alloc_purex_item(vha,
-					QLA_DEFAULT_PAYLOAD_SIZE);
+	item = qla24xx_alloc_purex_item(vha, QLA_DEFAULT_PAYLOAD_SIZE);
 	if (!item)
 		return item;
 
-	memcpy(&item->iocb, pkt, sizeof(item->iocb));
+	memcpy(&item->iocb, pkt, QLA_DEFAULT_PAYLOAD_SIZE);
 	return item;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 8ee2e337c9e1..92488890bc04 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -1308,7 +1308,7 @@ void qla2xxx_process_purls_iocb(void **pkt, struct rsp_que **rsp)
 
 	ql_dbg(ql_dbg_unsol, vha, 0x2121,
 	       "PURLS OP[%01x] size %d xchg addr 0x%x portid %06x\n",
-	       item->iocb.iocb[3], item->size, uctx->exchange_address,
+	       item->iocb[3], item->size, uctx->exchange_address,
 	       fcport->d_id.b24);
 	/* +48    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
 	 * ----- -----------------------------------------------
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d4b484c0fd9d..253f802605d6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6459,9 +6459,10 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 void
 qla24xx_free_purex_item(struct purex_item *item)
 {
-	if (item == &item->vha->default_item)
+	if (item == &item->vha->default_item) {
 		memset(&item->vha->default_item, 0, sizeof(struct purex_item));
-	else
+		memset(&item->vha->__default_item_iocb, 0, QLA_DEFAULT_PAYLOAD_SIZE);
+	} else
 		kfree(item);
 }
 
-- 
2.43.0

