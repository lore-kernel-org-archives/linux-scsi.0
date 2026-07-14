Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3FF377ABF
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 18:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784055394; cv=none; b=gtLGX/dhe0rjx8Pvzw02q3bjIwmm62uS+8MeOK5GYF5SafB0gAS9CEONVyBmp2J3TwWvQD74iT+a8U4TuyeO7fVT3VC9EeSmNYl5zu95kJcvj0uMU9llPTFVoInwQ5NxANMYNj9OjLIe7JnFDKgsw0XnGJJbSKtsZohufWw7t54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784055394; c=relaxed/simple;
	bh=2ROpMVICHpOtmuiy/EY2fHl4S1i7++2jmcrNx4zwWFs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eqqHYZ6Ps46R/EctOWVDApg3hu+2bKXLyPi5n2WTELeVAj++IjNF6HbTlJYYha8heRi/3vqxFC1RPeK5Yh/aMc+VWELj96PzOC6JrthlV/UK2DhLHVD0bqYWUIklmbtiLfFfcYdH2Nh8P4I0uFQ1bA5WsrE6Od2bYZK07b1inp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FseA2hJF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FseA2hJF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784055390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VWUOSBEZcrPjpmh/6/BvqpkPNaOYnA+YhKKN9c6L/vU=;
	b=FseA2hJFk088262Wkl1SuQlVveKH479ZoAjMEQJgrUzRKYU3fZp8we18qfVEDmiMb5O07/
	xMLLC33cdu3M7Xu5WmP3HBWAO96BzP57utU7xue27tk+JldMiP273uMQKSb2p1ttsiJHDk
	wG3iuaoBMK4SDI50J7wMpgBdQBua3OI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-213-wtU5yLOoO9idEdBhTbKXCA-1; Tue,
 14 Jul 2026 14:56:27 -0400
X-MC-Unique: wtU5yLOoO9idEdBhTbKXCA-1
X-Mimecast-MFC-AGG-ID: wtU5yLOoO9idEdBhTbKXCA_1784055385
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65C461956064;
	Tue, 14 Jul 2026 18:56:25 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.17.17.152])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 38A4730002DD;
	Tue, 14 Jul 2026 18:56:23 +0000 (UTC)
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
	Jesse Taube <jtaubepe@redhat.com>
Subject: [PATCH v2] scsi: qla2xxx: Fix flex array member not at end
Date: Tue, 14 Jul 2026 14:56:21 -0400
Message-ID: <20260714185621.610105-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

In qla_edif_bsg.h: `struct fc_bsg_reply` and `struct fc_bsg_request`
have flexible array members, thus they must be the last member of
the parent structure. Contininging in the effort to add
`-Wflex-array-member-not-at-end`, move the structs to the end of
the parent structures, `struct qla_bsg_auth_els_reply` and
`struct qla_bsg_auth_els_request `.

Suggested-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
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

