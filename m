Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D466255F5C
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 21:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753478965; cv=none; b=uMZSUj5stWpbsnh49pzjXKkPATe6lIpVaThvcwBvdWo7eGI30dBoMF1GAMdP+ROlcywWdJRR6TUa8oBpXk94Ja9MOLAe352SglGZtlHNEeD/SWUGOHhPpoESNXIuFFJtWj4wlhgyy7RVTqd/78rQIAl56/RqMkWP7OqmRSRbMU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753478965; c=relaxed/simple;
	bh=tOSKxmWNXyi4BM/WUC8WJSCtuTZe2l5ng0YPgqHH02A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHEsq7rXTRNr8hl6T4e36W6nGr1O7QjGj0W6xgKUHjTxbBP2SkouGQZo8ivBFZKCyYx0IFJG75JCMMX5inrKYcaONLqX2ZQvJerQqRX3L4UXnMd/x5ykdhqMn9xXbO7Ubx5r3i5aSFgL7BROLCnBTzuvlpokOH3Wp+3iesdgbMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gMhyR0Pc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gMhyR0Pc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753478963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tI9VUFIGTNpppkXBFldK9MIVsrUUa9pQ9GBq4L2gaSY=;
	b=gMhyR0PcQfdKUyJSWSnxC/9CSWu+gSENrQTrB9PvmZf4uJeyBVSL1fLDauik9jkM9ZKn+f
	+ckY0HkWKc6P9A6eEWBUPeOwhWoZESXhBq0+uyCqR2whUQv/52LP+skDuBC5E0zjuWBPt6
	RFibyG6cAEKBmNBotyxcDrckHYQcOy8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-74-Bka_Q-8QOQOY2e949dYc4Q-1; Fri,
 25 Jul 2025 17:29:21 -0400
X-MC-Unique: Bka_Q-8QOQOY2e949dYc4Q-1
X-Mimecast-MFC-AGG-ID: Bka_Q-8QOQOY2e949dYc4Q_1753478960
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 708F018003FC;
	Fri, 25 Jul 2025 21:29:20 +0000 (UTC)
Received: from cleech-thinkpadt14sgen2i.rmtusor.csb (unknown [10.2.16.27])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0A0AB195608D;
	Fri, 25 Jul 2025 21:29:18 +0000 (UTC)
From: Chris Leech <cleech@redhat.com>
To: linux-scsi@vger.kernel.org,
	Nilesh Javali <njavali@marvell.com>
Cc: Kees Cook <kees@kernel.org>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Bryan Gurney <bgurney@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>
Subject: [PATCH 1/2] scsi: qla2xxx: replace non-standard flexible array purex_item.iocb
Date: Fri, 25 Jul 2025 14:27:31 -0700
Message-ID: <20250725212732.2038027-2-cleech@redhat.com>
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

This is defined as a 64-element u8 array, but 64 is the minimum size and
it can be allocated larger. I don't know why the array was wrapped as a
single element struct of the same name.

Replace with a union around DECLARE_FLEX_ARRAY and padding to maintain
sizeof(struct purex_item) and associated use.

This was triggering a field-spanning write warning during FPIN testing
https://lore.kernel.org/linux-nvme/20250709211919.49100-1-bgurney@redhat.com/

  >  kernel: memcpy: detected field-spanning write (size 60) of single field
  >  "((uint8_t *)fpin_pkt + buffer_copy_offset)"
  >  at drivers/scsi/qla2xxx/qla_isr.c:1221 (size 44)

Tested-by: Bryan Gurney <bgurney@redhat.com>
Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index cb95b7b12051d..6237fefeca149 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4890,8 +4890,9 @@ struct purex_item {
 			     struct purex_item *pkt);
 	atomic_t in_use;
 	uint16_t size;
-	struct {
-		uint8_t iocb[64];
+	union {
+		uint8_t __padding[QLA_DEFAULT_PAYLOAD_SIZE];
+		DECLARE_FLEX_ARRAY(uint8_t, iocb);
 	} iocb;
 };
 
-- 
2.50.1

