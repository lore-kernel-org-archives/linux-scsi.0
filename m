Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD2029AB05
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 17:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784914789; cv=none; b=G6uXfWFuOkuS40S0y/Y1DQXA5tTkkS0mjs/u8yGTU6aQiD8kb+mlznWI9oB2QtRnx5eIy2N9vrzzaUppxrdXkOKuobz/Jjf1f2DyMJA7QGT0PcmAJ1R11tk4eLfKS80eDHnqDkyelQphtrYVf4Glg+b8ijyPnC1Y78I2UZPV4Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784914789; c=relaxed/simple;
	bh=ySWzsajFkibEeZrA3R2xvALpeX1/n2PTPArrGZyHtvs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PznoiTRdtWMTDNJ0/QPzwlWOCshxzuNt6mQmG/MesiSvdtv6yJFzG5IO5bRBAfWvvcLuZv6EV/y0+vMpy53Yl/JjECsSa+j2TnEBFZdaZe235dv83nP2m4am1OtbGLp23JXY9K56IQu/+nYg+/VUpnqNoo7Z5xooLIZ0egme3zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PqSVcQk0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PqSVcQk0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784914787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wRgOCGPnxIibRZZ2MVzGlKVa5u8lUBCyYyNkywtggwE=;
	b=PqSVcQk0i3buBUy8MUcqCa5hV1Jj3rNV7FIwQje2UsGmR8zS0cAJIrSLRwUb4cRJW7mVpd
	BS7XlNtSvYnWMx8035mLNCqBdesmVeFEGBoZ32U7+1jr0ABQeXCrNMZUycETVuGAwOu1XS
	iNXypWwfmyBynIhgvwxOnT6+H4/5X+o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-166-8PmTLOkwOaGCoJbtmeTkNg-1; Fri,
 24 Jul 2026 13:39:43 -0400
X-MC-Unique: 8PmTLOkwOaGCoJbtmeTkNg-1
X-Mimecast-MFC-AGG-ID: 8PmTLOkwOaGCoJbtmeTkNg_1784914782
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 790181955D88;
	Fri, 24 Jul 2026 17:39:41 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.22.64.219])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9317BD6E;
	Fri, 24 Jul 2026 17:39:37 +0000 (UTC)
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
Subject: [PATCH v3] scsi: qla2xxx: Fix flex array member not at end
Date: Fri, 24 Jul 2026 13:39:35 -0400
Message-ID: <20260724173935.1959397-1-jtaubepe@redhat.com>
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
---
 drivers/scsi/qla2xxx/qla_edif_bsg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/qla_edif_bsg.h
index 514c265ba86e..bcc35d149c1f 100644
--- a/drivers/scsi/qla2xxx/qla_edif_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
@@ -36,16 +36,16 @@ struct extra_auth_els {
 } __packed;
 
 struct qla_bsg_auth_els_request {
-	struct fc_bsg_request r;
 	struct extra_auth_els e;
+	struct fc_bsg_request r;
 };
 
 struct qla_bsg_auth_els_reply {
-	struct fc_bsg_reply r;
 	uint32_t rx_xchg_address;
 	uint8_t version;
 	uint8_t pad[VND_CMD_PAD_SIZE];
 	uint8_t reserved[VND_CMD_APP_RESERVED_SIZE];
+	struct fc_bsg_reply r;
 };
 
 struct app_id {
-- 
2.54.0

