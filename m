Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07192DDA9
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 00:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758844973; cv=none; b=l7A6s+2eaLVL1iShD/UsHD1yFeNZ6mLq5Ej4cerveGX3mqvqswzVN5ahgQDBXrcaq6kTJdk+97XhHzZiQ6YyPe+QZWBu9pgL2N3abjShwt/BK2rUgPZwKePg6j71EBMDemr9F5vln/aXiujxUdVLeJ1M/ArZ8+Nxk9P0Kum7vRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758844973; c=relaxed/simple;
	bh=fBfaRUboi+fFyGb2NEZhdqXU2tbzuPAWWM0F0jjmFjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Mv2oqw+DKbeAy234IWOwyUK024e4IPT+Y/QFgX+PTJ/w/DHmeJZQDwFjDd6TC5Gp7gjaw1R1YUJO6ISywg2ubg/oshmBoEuvU9c2pzW+kuuACQ6wiv7d3NK4F+YsEM4agi7LrVYnq+Y3NDzPMYqGnNnPFp9LSxfFGgT49xgM9AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MLCUgQWz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MLCUgQWz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758844971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qgOa77ByGMYJukt5FEjcJ2QbirwcIX6m2gPfY7CQnZk=;
	b=MLCUgQWzSfN/2PAnpyZFcQ396thIKUoEplovP49JqRKIIxIdiWCSuvOGZnAiTu1M7bsUZ/
	7Z/9r13lAX2qi/3oeUhyjh/hq9nE/P3XoKmJnVxi1qECHyzJ5+V4FIQEodA6W0Eyfy7cbr
	rtVaelF7BrYIdTIwvDs6a5QMfQqJocI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-458-arq9V-ZmO4WF1KEOl-K-qw-1; Thu,
 25 Sep 2025 20:02:45 -0400
X-MC-Unique: arq9V-ZmO4WF1KEOl-K-qw-1
X-Mimecast-MFC-AGG-ID: arq9V-ZmO4WF1KEOl-K-qw_1758844963
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 97AEA1800359;
	Fri, 26 Sep 2025 00:02:43 +0000 (UTC)
Received: from jmeneghi-thinkpadp1gen7.rmtusnh.csb (unknown [10.22.81.200])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E7E8C1800579;
	Fri, 26 Sep 2025 00:02:40 +0000 (UTC)
From: John Meneghini <jmeneghi@redhat.com>
To: hare@suse.de,
	kbusch@kernel.org,
	martin.petersen@oracle.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Cc: bgurney@redhat.com,
	axboe@kernel.dk,
	emilne@redhat.com,
	gustavoars@kernel.org,
	hch@lst.de,
	james.smart@broadcom.com,
	jmeneghi@redhat.com,
	kees@kernel.org,
	linux-hardening@vger.kernel.org,
	njavali@marvell.com,
	sagi@grimberg.me
Subject: [PATCH v10 11/11] scsi: qla2xxx: Fix 2 memcpy field-spanning write issue
Date: Thu, 25 Sep 2025 20:02:00 -0400
Message-ID: <20250926000200.837025-12-jmeneghi@redhat.com>
In-Reply-To: <20250926000200.837025-1-jmeneghi@redhat.com>
References: <20250926000200.837025-1-jmeneghi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

purex_item.iocb is defined as a 64-element u8 array, but 64 is the
minimum size and it can be allocated larger. This makes it a standard
empty flex array.

This was motivated by field-spanning write warnings during FPIN testing.

  >  kernel: memcpy: detected field-spanning write (size 60) of single
  >  field "((uint8_t *)fpin_pkt + buffer_copy_offset)"
  >  at drivers/scsi/qla2xxx/qla_isr.c:1221 (size 44)

I removed the outer wrapper from the iocb flex array, so that it can be
linked to `purex_item.size` with `__counted_by`.

These changes remove the default minimum 64-byte allocation, requiring
further changes.

  In `struct scsi_qla_host` the embedded `default_item` is now followed
  by `__default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE]` to reserve space
  that will be used as `default_item.iocb`. This is wrapped using the
  `TRAILING_OVERLAP()` macro helper, which effectively creates a union
  between flexible-array member `default_item.iocb` and
  `__default_item_iocb`.

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

In qla_os.c:qla24xx_process_purex_rdp()

To avoid a null pointer dereference the vha->default_item should be set
to 0 last if the item pointer passed to the function matches.  Also use
a local variable to avoid multiple de-referencing of the item.

Tested-by: Bryan Gurney <bgurney@redhat.com>
Co-developed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h  | 10 ++++++----
 drivers/scsi/qla2xxx/qla_isr.c  | 17 ++++++++---------
 drivers/scsi/qla2xxx/qla_nvme.c |  2 +-
 drivers/scsi/qla2xxx/qla_os.c   |  9 ++++++---
 4 files changed, 21 insertions(+), 17 deletions(-)

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
index 8ff8781dae47..ccb044693dcb 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1078,17 +1078,17 @@ static struct purex_item *
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
@@ -1128,17 +1128,16 @@ qla24xx_queue_purex_item(scsi_qla_host_t *vha, struct purex_item *pkt,
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
index d4b484c0fd9d..32437bae1a30 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6459,9 +6459,12 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 void
 qla24xx_free_purex_item(struct purex_item *item)
 {
-	if (item == &item->vha->default_item)
-		memset(&item->vha->default_item, 0, sizeof(struct purex_item));
-	else
+	scsi_qla_host_t *base_vha = item->vha;
+
+	if (item == &base_vha->default_item) {
+		memset(&base_vha->__default_item_iocb, 0, QLA_DEFAULT_PAYLOAD_SIZE);
+		memset(&base_vha->default_item, 0, sizeof(struct purex_item));
+	} else
 		kfree(item);
 }
 
-- 
2.51.0

