Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350B2271456
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 15:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784042570; cv=none; b=NBdwTCtAOYWg/DzOxgFUmUjPXuKwlIpUQtLsejqL+3wX2+d6m+h60FoIKXnok5G+KU2tHUrpjZHHR0sfHl7H/GRTcODbVdzQrO6N2FIhCI/tCrKnyD/C1xbFwyn1aM1PcGAkd3p+5QFpKSPCPgAlcmSCriqMWwjfKc32dHth0Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784042570; c=relaxed/simple;
	bh=MiZNs3K5dRllkjW5iOz2ZQ3thz2YRxLQomtAaKNKzGM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t1dC2UPRGnS8z6tR3UWXixcWRDYnrYUYtABzzbu6uazKtEGJsKQeSx2LzB3ilwm+SNiIneyqGxPhO9Vsn7cibrC/wnoPTzSyK4oSXiQdq+M7yVBd06ptlqWC9jDmmvPSyuu0Uq/IkBX0nozSnCHLV8Zrh/zbc5ezhsYQS/+Anj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DxjpDvw/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DxjpDvw/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784042568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zSmydwKOKw+iuaVJZHAYyikSta/hRg+7yhoWUJYhBkU=;
	b=DxjpDvw/le0rVDhrjaJWADLONmsjNZk6FjiW9Wrw62ZHVZnHUtU3KfAzE2X9IzK8hzLiO6
	0Z+irSdx9VkVU4yvLLRYyMgSZrKkmTZAVf4VLJFXLFh6OqgI3GGylqv10S+IC5M2BUV+C5
	TacfCpjzPUHHECADTJCMPKAgFTMH5aQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-502-S6EkA1ByOQ-FCVWye7DB7A-1; Tue,
 14 Jul 2026 11:22:44 -0400
X-MC-Unique: S6EkA1ByOQ-FCVWye7DB7A-1
X-Mimecast-MFC-AGG-ID: S6EkA1ByOQ-FCVWye7DB7A_1784042562
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6CBD1800598;
	Tue, 14 Jul 2026 15:22:41 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.17.17.152])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CED8118005AE;
	Tue, 14 Jul 2026 15:22:39 +0000 (UTC)
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
Subject: [PATCH] scsi: qla2xxx: Fix flex array member not at end
Date: Tue, 14 Jul 2026 11:22:38 -0400
Message-ID: <20260714152238.541704-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

In qla_edif_bsg.h: `struct fc_bsg_reply` and `struct fc_bsg_request`
have flexible array members, thus they must be the last member of
the parent structure. Contininging in the effort to add
`-Wflex-array-member-not-at-end`, move the structs to the end of
the parent structures, `struct qla_bsg_auth_els_reply` and
`struct qla_bsg_auth_els_request `.

Suggested-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
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

