Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C236625F7A7
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 21:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753478970; cv=none; b=n7D/VFHWCR1E2QF/x5NOJzMeWEjZGmxa1kHGRGiIyq7ru2xcv3nuwl0lNU2/LHkN6m+5P5kc/Y6QnaNfrEexD0hEkaLrN3Pa+EBHCw3Wg1HOrLxswpXuhXWF8vN03TFqY9kt9Pod9EIfS6MJZQpD0BRe7t19lCfYEsmudjAj+JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753478970; c=relaxed/simple;
	bh=zrKMQQVEdWoy5mfIhqoWiLjlzVfamvf6O28P4h9O/zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAb8StfszIIeP/k2XrrLKRxgbwLoC4mE+mSx5ByG1QHdWebUiXVCjW0Smf8A8H7AgAmyhjKsOPTfnGSBlUfjxrBwWJfiaDj+v/ywJztO80tjjCJ9ekdZV75p9sW0/EYdtWwHosBFSDgEMrWLWSanJvbgBRyytUocZPn9vzVtwso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OAeRQlOO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OAeRQlOO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753478967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ala2tgd1HiQC5QRX4Bd1Xc6mHv2DGUq2dauMLwuYyNA=;
	b=OAeRQlOO6L/bxVVDxpT/SPn6XacSB4E2bsRucT+0sbATEXjNk5WCGjCDqtMkNyOlCYtfSG
	bbiYlI8DXuvRRG8OJ9sPF8rjbW8Jm4MJQ9w3G9irTuNyrKCVitkQpQ5nuCd5bZO1p5klAb
	7Hz3hZswI26oTzzYo8D7a6PxJu7Fej8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-421-qYjeMVaHOfqyJPT26iEX1w-1; Fri,
 25 Jul 2025 17:29:23 -0400
X-MC-Unique: qYjeMVaHOfqyJPT26iEX1w-1
X-Mimecast-MFC-AGG-ID: qYjeMVaHOfqyJPT26iEX1w_1753478962
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2D9D81800446;
	Fri, 25 Jul 2025 21:29:22 +0000 (UTC)
Received: from cleech-thinkpadt14sgen2i.rmtusor.csb (unknown [10.2.16.27])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C02A7195608D;
	Fri, 25 Jul 2025 21:29:20 +0000 (UTC)
From: Chris Leech <cleech@redhat.com>
To: linux-scsi@vger.kernel.org,
	Nilesh Javali <njavali@marvell.com>
Cc: Kees Cook <kees@kernel.org>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Bryan Gurney <bgurney@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>
Subject: [PATCH 2/2] scsi: qla2xxx: unwrap purex_item.iocb.iocb so that __counted_by can be used
Date: Fri, 25 Jul 2025 14:27:32 -0700
Message-ID: <20250725212732.2038027-3-cleech@redhat.com>
In-Reply-To: <20250725212732.2038027-1-cleech@redhat.com>
References: <20250725212732.2038027-1-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Remove the outer wrapper from the iocb flex array, so that it can be
linked to purex_item.size with __counted_by.

This removes the default minimum 64-byte allocation, requiring further
changes.

  In struct scsi_qla_host embedded default_item is now followed by
  __default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE] to reserve space that
  will be used as default_item.iocb

  qla24xx_alloc_purex_item is adjusted to no longer expect the default
  minimum size to be part of sizeof(struct purex_item), the entire
  flexible array size is added to the structure size for allocation.

Tested-by: Bryan Gurney <bgurney@redhat.com>
Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  6 ++----
 drivers/scsi/qla2xxx/qla_isr.c  | 15 +++++++--------
 drivers/scsi/qla2xxx/qla_nvme.c |  2 +-
 drivers/scsi/qla2xxx/qla_os.c   |  5 +++--
 4 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6237fefeca149..0a79ef2429f50 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4890,10 +4890,7 @@ struct purex_item {
 			     struct purex_item *pkt);
 	atomic_t in_use;
 	uint16_t size;
-	union {
-		uint8_t __padding[QLA_DEFAULT_PAYLOAD_SIZE];
-		DECLARE_FLEX_ARRAY(uint8_t, iocb);
-	} iocb;
+	uint8_t iocb[] __counted_by(size);
 };
 
 #include "qla_edif.h"
@@ -5103,6 +5100,7 @@ typedef struct scsi_qla_host {
 		spinlock_t lock;
 	} purex_list;
 	struct purex_item default_item;
+	uint8_t __default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE];
 
 	struct name_list_extended gnl;
 	/* Count of active session/fcport */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index fe98c76e9be32..83677f74fd8e6 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1080,14 +1080,14 @@ qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
 	uint8_t item_hdr_size = sizeof(*item);
 
 	if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
-		item = kzalloc(item_hdr_size +
-		    (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
+		item = kzalloc(item_hdr_size + size, GFP_ATOMIC);
 	} else {
 		if (atomic_inc_return(&vha->default_item.in_use) == 1) {
 			item = &vha->default_item;
 			goto initialize_purex_header;
 		} else {
-			item = kzalloc(item_hdr_size, GFP_ATOMIC);
+			item = kzalloc(item_hdr_size + QLA_DEFAULT_PAYLOAD_SIZE,
+					GFP_ATOMIC);
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
index d4b484c0fd9d7..253f802605d63 100644
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
2.50.1

