Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AC4211460
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 13:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758805666; cv=none; b=PxGR4t/g8cLLNeGeLYi4CDLP6DcQc9LneKQYU90pj9U37NdoAWmiOzfJWHjMZAlLTQjMOQ39sl3NhBN8W2elFCImnWvakNSoNwybHZum47K4zfeRthB4wLXb+8rlVC5fLf/sQrmkgWaInj3LeslRPRXTTggOIKOsThny5UOwVAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758805666; c=relaxed/simple;
	bh=AXgg6aVQhrKS0z+6GonYS5IUww9XN7DP7viYWSWFnfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Dzx/c2xfaKt+6bJ/XPUop3yGQ8yRTTmEp9pixDTmX+zudj/uDKFKQUqhJDNZz/Y43CFK7FzEp1g8OFjCfKmBhOanj8m4+yVq2pKWMR1ZosoIR8tT62MJ1V6Jn7tmG7twQpnDP0eRQ5ssdGS3sW4npAX4oqzU30+z3F/iEXGqUuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BigewqUG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BigewqUG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758805663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MkQYmrCxrc8CnKCxeo6oVs5/RyiJjlpdil5P3w+AxXI=;
	b=BigewqUG+UpsOO7yi08r2DdIoSN+LXM0xGI4AuJvkVUZTGurEKsVT2oSRMh4cbm/wDGKIz
	BFnRLueICZncj9P20m7W9CPxM2L5HO07R5lgDIRtP+qK67qA3c+Wh9kST+Ntp4qv54DbdB
	be/gpye2kiAH/wXm0AWE4xrUVY3tNHc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-263-ZYqVUPb8NOaGbku-hYrT1g-1; Thu,
 25 Sep 2025 09:07:40 -0400
X-MC-Unique: ZYqVUPb8NOaGbku-hYrT1g-1
X-Mimecast-MFC-AGG-ID: ZYqVUPb8NOaGbku-hYrT1g_1758805658
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9726E1800286;
	Thu, 25 Sep 2025 13:07:37 +0000 (UTC)
Received: from jmeneghi-thinkpadp1gen7.rmtusnh.csb (unknown [10.22.81.200])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E45BB180035C;
	Thu, 25 Sep 2025 13:07:32 +0000 (UTC)
From: John Meneghini <jmeneghi@redhat.com>
To: martin.petersen@oracle.com
Cc: axboe@kernel.dk,
	bgurney@redhat.com,
	emilne@redhat.com,
	gustavoars@kernel.org,
	hare@suse.de,
	hch@lst.de,
	james.smart@broadcom.com,
	jmeneghi@redhat.com,
	kbusch@kernel.org,
	kees@kernel.org,
	linux-hardening@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	njavali@marvell.com,
	sagi@grimberg.me
Subject: [PATCH] Revert "scsi: qla2xxx: Fix memcpy() field-spanning write issue"
Date: Thu, 25 Sep 2025 09:07:29 -0400
Message-ID: <20250925130729.776904-1-jmeneghi@redhat.com>
In-Reply-To: <yq1zfajqpec.fsf@ca-mkp.ca.oracle.com>
References: <yq1zfajqpec.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

This reverts commit 6f4b10226b6b1e7d1ff3cdb006cf0f6da6eed71e.

We've been testing this patch and it turns out there is a significant
bug here. This leaks memory and causes a driver hang.

Link:
https://lore.kernel.org/linux-scsi/yq1zfajqpec.fsf@ca-mkp.ca.oracle.com/

Signed-off-by: John Meneghini <jmeneghi@redhat.com>
---
 drivers/scsi/qla2xxx/qla_def.h  | 10 ++++------
 drivers/scsi/qla2xxx/qla_isr.c  | 17 +++++++++--------
 drivers/scsi/qla2xxx/qla_nvme.c |  2 +-
 drivers/scsi/qla2xxx/qla_os.c   |  5 ++---
 4 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 604e66bead1e..cb95b7b12051 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4890,7 +4890,9 @@ struct purex_item {
 			     struct purex_item *pkt);
 	atomic_t in_use;
 	uint16_t size;
-	uint8_t iocb[] __counted_by(size);
+	struct {
+		uint8_t iocb[64];
+	} iocb;
 };
 
 #include "qla_edif.h"
@@ -5099,6 +5101,7 @@ typedef struct scsi_qla_host {
 		struct list_head head;
 		spinlock_t lock;
 	} purex_list;
+	struct purex_item default_item;
 
 	struct name_list_extended gnl;
 	/* Count of active session/fcport */
@@ -5127,11 +5130,6 @@ typedef struct scsi_qla_host {
 #define DPORT_DIAG_IN_PROGRESS                 BIT_0
 #define DPORT_DIAG_CHIP_RESET_IN_PROGRESS      BIT_1
 	uint16_t dport_status;
-
-	/* Must be last --ends in a flexible-array member. */
-	TRAILING_OVERLAP(struct purex_item, default_item, iocb,
-		uint8_t __default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE];
-	);
 } scsi_qla_host_t;
 
 struct qla27xx_image_status {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 4559b490614d..c4c6b5c6658c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1077,17 +1077,17 @@ static struct purex_item *
 qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
 {
 	struct purex_item *item = NULL;
+	uint8_t item_hdr_size = sizeof(*item);
 
 	if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
-		item = kzalloc(struct_size(item, iocb, size), GFP_ATOMIC);
+		item = kzalloc(item_hdr_size +
+		    (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
 	} else {
 		if (atomic_inc_return(&vha->default_item.in_use) == 1) {
 			item = &vha->default_item;
 			goto initialize_purex_header;
 		} else {
-			item = kzalloc(
-				struct_size(item, iocb, QLA_DEFAULT_PAYLOAD_SIZE),
-				GFP_ATOMIC);
+			item = kzalloc(item_hdr_size, GFP_ATOMIC);
 		}
 	}
 	if (!item) {
@@ -1127,16 +1127,17 @@ qla24xx_queue_purex_item(scsi_qla_host_t *vha, struct purex_item *pkt,
  * @vha: SCSI driver HA context
  * @pkt: ELS packet
  */
-static struct purex_item *
-qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
+static struct purex_item
+*qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
 {
 	struct purex_item *item;
 
-	item = qla24xx_alloc_purex_item(vha, QLA_DEFAULT_PAYLOAD_SIZE);
+	item = qla24xx_alloc_purex_item(vha,
+					QLA_DEFAULT_PAYLOAD_SIZE);
 	if (!item)
 		return item;
 
-	memcpy(&item->iocb, pkt, QLA_DEFAULT_PAYLOAD_SIZE);
+	memcpy(&item->iocb, pkt, sizeof(item->iocb));
 	return item;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 065f9bcca26f..316594aa40cc 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -1308,7 +1308,7 @@ void qla2xxx_process_purls_iocb(void **pkt, struct rsp_que **rsp)
 
 	ql_dbg(ql_dbg_unsol, vha, 0x2121,
 	       "PURLS OP[%01x] size %d xchg addr 0x%x portid %06x\n",
-	       item->iocb[3], item->size, uctx->exchange_address,
+	       item->iocb.iocb[3], item->size, uctx->exchange_address,
 	       fcport->d_id.b24);
 	/* +48    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
 	 * ----- -----------------------------------------------
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 98a5c105fdfd..9a2f328200ab 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6459,10 +6459,9 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 void
 qla24xx_free_purex_item(struct purex_item *item)
 {
-	if (item == &item->vha->default_item) {
+	if (item == &item->vha->default_item)
 		memset(&item->vha->default_item, 0, sizeof(struct purex_item));
-		memset(&item->vha->__default_item_iocb, 0, QLA_DEFAULT_PAYLOAD_SIZE);
-	} else
+	else
 		kfree(item);
 }
 
-- 
2.51.0

