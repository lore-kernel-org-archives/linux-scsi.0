Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F294435EDE
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 16:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785170942; cv=none; b=A7/s1Ny3sYdDsazVvSouL6enRboTS3wZGLVJ5mcOFhZ3hXLBjgnFT4xzb5x0TlYwUb7mVaFO3t8xyO+u6kTB/5LDSZocSNjHuVyf81lofb2R0Gq4s0xWvY7oi2L9cdO+/WjLdB4R8ETC7BkUN7pzcFlF+06tJi1kK9kCSjs07+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785170942; c=relaxed/simple;
	bh=sIWPLBzaaUrfGVje9a8BJ7xwdPrllL17PkcHV11XHNk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ha85XfgxgOUJEBONyyamEC1GBdjmjPfWZ+QmfsSXFkcc2Lv2AFykls+8ZhVWzx7deGbSTTrW+1o1LkPpGUzq6nRvLH5fPrvictuKmuiwX52lGZdzK+VB3rtaKKrCpc6MF/FH0wLbuxNr5ZcBiXRTLqGndbxhrgBi51BVwI7EMOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G6+fIkap; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G6+fIkap"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785170933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Jvtqw3+vV9T+UoY2qwgIAxvyQCdrL+AAFL9za9RgMWk=;
	b=G6+fIkapXosfIjWlajiFzRwguAgP2YJk0WwCy92+KHrcAIk38hVP7luZ/NuhPzNH3jdFv/
	tbjU8JKGeF+fThLaWisA9n6jcAFfFDGZeYuqOZgvT2aiPWo8qbvYMF37/TivMxmOtpGJFn
	IOnjdLIwqyvjxV41o0dfAw/AC7wcKYE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-373-WMhsRuOdOByt96MKb4u7KA-1; Mon,
 27 Jul 2026 12:48:48 -0400
X-MC-Unique: WMhsRuOdOByt96MKb4u7KA-1
X-Mimecast-MFC-AGG-ID: WMhsRuOdOByt96MKb4u7KA_1785170926
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8ABEF1955E86;
	Mon, 27 Jul 2026 16:48:46 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.17.17.11])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A222542B;
	Mon, 27 Jul 2026 16:48:44 +0000 (UTC)
From: Jesse Taube <jtaubepe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	John Meneghini <jmeneghi@redhat.com>,
	Chris Leech <cleech@redhat.com>,
	Jesse Taube <mr.bossman075@gmail.com>,
	Bryan Gurney <bgurney@redhat.com>,
	Jesse Taube <jtaubepe@redhat.com>
Subject: [PATCH v4] scsi: qla2xxx: Fix flex array member not at end
Date: Mon, 27 Jul 2026 12:48:42 -0400
Message-ID: <20260727164842.2123122-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

In qla_edif_bsg.h: `struct fc_bsg_reply` and `struct fc_bsg_request`
have flexible array members, thus they must be the last member of
the parent structure. Contininging in the effort to add
`-Wflex-array-member-not-at-end`, put `struct fc_bsg_*` inside a
union with the trailing members padded to the size of `struct fc_bsg_*`
to silence the warning. This is similar to TRAILING_OVERLAP, exept
that the position of the flexible array member is also in a union,
causing it to not be the last member of the structure.

Suggested-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
---
V1 -> V2:
 - Rewrite
V2 -> V3:
 - Fix commit description
V3 -> V4:
 - Accedentally sent V1 ;(
   Send correct version.
---
 drivers/scsi/qla2xxx/qla_edif_bsg.h | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/qla_edif_bsg.h
index 514c265ba86e..2b32a3185629 100644
--- a/drivers/scsi/qla2xxx/qla_edif_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
@@ -36,16 +36,26 @@ struct extra_auth_els {
 } __packed;
 
 struct qla_bsg_auth_els_request {
-	struct fc_bsg_request r;
-	struct extra_auth_els e;
+	union {
+		struct fc_bsg_request r;
+		struct {
+			unsigned char __fc_bsg_request_sz[sizeof(struct fc_bsg_request)];
+			struct extra_auth_els e;
+		};
+	};
 };
 
 struct qla_bsg_auth_els_reply {
-	struct fc_bsg_reply r;
-	uint32_t rx_xchg_address;
-	uint8_t version;
-	uint8_t pad[VND_CMD_PAD_SIZE];
-	uint8_t reserved[VND_CMD_APP_RESERVED_SIZE];
+	union {
+		struct fc_bsg_reply r;
+		struct {
+			unsigned char __fc_bsg_reply_sz[sizeof(struct fc_bsg_reply)];
+			uint32_t rx_xchg_address;
+			uint8_t version;
+			uint8_t pad[VND_CMD_PAD_SIZE];
+			uint8_t reserved[VND_CMD_APP_RESERVED_SIZE];
+		};
+	};
 };
 
 struct app_id {
-- 
2.54.0

