Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4E51482E7
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2025 18:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753729121; cv=none; b=Ea2RULbtpLzcT+VslHQQuQBA6vu+JhtIzvixR7SGY2+CJ0HKo5Qw+v363n+H/OG7XflJjwIhNE7uc5JdaZRJBPEaKZH0XMzUUQMBiiwUyb8v0lCAXD/n8K9ny3dAbMd5xEPwUJWmsV97bAtR/W6FhqWDSWt7G6LEPk39b9x1FgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753729121; c=relaxed/simple;
	bh=QwSVKowQfe4G8NOdqVX8M8h3EwnD4uTT13Iuy+nlqFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vA5SiyTXY1aFIKlM1nUmDuZdTDqBBfcYcxHl4zDzDOnGwGK8q0E/WDshbJ4Y011vy9Yc4Tj//A48jDV6nzbW+Iik1sUA5JFiuKKvBF9NvuJBoXMACKiVLrzRhR/eFm8C3lyzF5aZtjASmnG8iI9wRiGjdPhqEG2oiaA9xfFfnBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c2WVD9l1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c2WVD9l1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753729118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ISZY9N+ZkYz9f5q6zAvEpVRHwDOrffpq3hJ3yMycINs=;
	b=c2WVD9l1zjNuXI62t+XtkGhLV76o9JFSfWhXchpb2UORxX2HkcZ++g5uRG3RglK32WwPKN
	6zgvtXLF3xMHT2O+V8uWUBhALUNuH8E2oHbt9sEqEJ5+8HMrfnv2wixn5b4T72uCSW+gT6
	xPlI7Gavoku17s4U41bWfNgZCE4bKP0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-9gjPXvPGMFa3o6FoUXj-jw-1; Mon,
 28 Jul 2025 14:58:34 -0400
X-MC-Unique: 9gjPXvPGMFa3o6FoUXj-jw-1
X-Mimecast-MFC-AGG-ID: 9gjPXvPGMFa3o6FoUXj-jw_1753729113
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACDB8195608D;
	Mon, 28 Jul 2025 18:58:33 +0000 (UTC)
Received: from cleech-thinkpadt14sgen2i.rmtusor.csb (unknown [10.2.16.27])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E7D6E1800286;
	Mon, 28 Jul 2025 18:58:31 +0000 (UTC)
From: Chris Leech <cleech@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: Nilesh Javali <njavali@marvell.com>,
	Kees Cook <kees@kernel.org>,
	Bryan Gurney <bgurney@redhat.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>
Subject: [PATCH v2 1/1] scsi: qla2xxx: replace non-standard flexible array purex_item.iocb
Date: Mon, 28 Jul 2025 11:57:25 -0700
Message-ID: <20250728185725.2501761-1-cleech@redhat.com>
In-Reply-To: <20250725212732.2038027-2-cleech@redhat.com>
References: <20250725212732.2038027-2-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

purex_item.iocb is defined as a 64-element u8 array, but 64 is the
minimum size and it can be allocated larger.
This makes it a standard empty flex array.

This was motivated by field-spanning write warnings during FPIN testing.
https://lore.kernel.org/linux-nvme/20250709211919.49100-1-bgurney@redhat.com/

  >  kernel: memcpy: detected field-spanning write (size 60) of single field
  >  "((uint8_t *)fpin_pkt + buffer_copy_offset)"
  >  at drivers/scsi/qla2xxx/qla_isr.c:1221 (size 44)

I removed the outer wrapper from the iocb flex array, so that it can be
linked to purex_item.size with __counted_by.

The non-flex-array portion of purex_item is now defined within the
struct_group_tagged macro to create a type definition for just the
header. This was then used for the scsi_qla_host.default_item
definition to deal with -Wflex-array-member-not-at-end warnings.

These changes remove the default minimum 64-byte allocation, requiring
further changes.

  In struct scsi_qla_host the embedded default_item is now followed by
  __default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE] to reserve space that
  will be used as default_item.iocb

  qla24xx_alloc_purex_item is adjusted to no longer expect the default
  minimum size to be part of sizeof(struct purex_item), the entire
  flexible array size is added to the structure size for allocation.

This also slightly changes the layout of the purex_item struct, as
2-bytes of padding are added to purex_item_hdr and therefor between size
and iocb. The resulting size is the same, but iocb is shifted 2-bytes
(the old purex_item was padded at the end, after the 64-byte defined
array size). I don't think this is a problem.

Tested-by: Bryan Gurney <bgurney@redhat.com>
Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/scsi/qla2xxx/qla_def.h  | 23 ++++++++++++-----------
 drivers/scsi/qla2xxx/qla_isr.c  | 19 +++++++++----------
 drivers/scsi/qla2xxx/qla_nvme.c |  2 +-
 drivers/scsi/qla2xxx/qla_os.c   |  9 +++++----
 4 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index cb95b7b12051d..0e7d201b1feb0 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4883,16 +4883,16 @@ struct active_regions {
  * is variable) starting at "iocb".
  */
 struct purex_item {
-	void *purls_context;
-	struct list_head list;
-	struct scsi_qla_host *vha;
-	void (*process_item)(struct scsi_qla_host *vha,
-			     struct purex_item *pkt);
-	atomic_t in_use;
-	uint16_t size;
-	struct {
-		uint8_t iocb[64];
-	} iocb;
+	struct_group_tagged(purex_item_hdr, __hdr,
+		void *purls_context;
+		struct list_head list;
+		struct scsi_qla_host *vha;
+		void (*process_item)(struct scsi_qla_host *vha,
+				     struct purex_item *pkt);
+		atomic_t in_use;
+		uint16_t size;
+	);
+	uint8_t iocb[] __counted_by(size);
 };
 
 #include "qla_edif.h"
@@ -5101,7 +5101,8 @@ typedef struct scsi_qla_host {
 		struct list_head head;
 		spinlock_t lock;
 	} purex_list;
-	struct purex_item default_item;
+	struct purex_item_hdr default_item;
+	uint8_t __default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE];
 
 	struct name_list_extended gnl;
 	/* Count of active session/fcport */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index fe98c76e9be32..a00c06a9898ec 100644
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
-			item = &vha->default_item;
+			item = (struct purex_item *)&vha->default_item;
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
index 8ee2e337c9e1b..92488890bc04e 100644
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
index d4b484c0fd9d7..ef8a4fce0e03c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3971,7 +3971,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 static inline void
 qla24xx_free_purex_list(struct purex_list *list)
 {
-	struct purex_item *item, *next;
+	struct purex_item_hdr *item, *next;
 	ulong flags;
 
 	spin_lock_irqsave(&list->lock, flags);
@@ -6459,9 +6459,10 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 void
 qla24xx_free_purex_item(struct purex_item *item)
 {
-	if (item == &item->vha->default_item)
-		memset(&item->vha->default_item, 0, sizeof(struct purex_item));
-	else
+	if (item == (struct purex_item *)&item->vha->default_item) {
+		memset(&item->vha->default_item, 0, sizeof(struct purex_item_hdr));
+		memset(&item->vha->__default_item_iocb, 0, QLA_DEFAULT_PAYLOAD_SIZE);
+	} else
 		kfree(item);
 }
 
-- 
2.50.1

