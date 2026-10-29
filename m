Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793289898;
	b=IjHyUtOibBhQYujBQ9g2IICgld+fXLyzdQ7yAwNGYUXL5VgN2ogM7831Zi4D4rO3g3g6
	 C5zeQdwiLj/r/H7pT0Ixq9jqnApXfLaTR8OH8THxMgJFZ5ixgyiEVYmoeKqryQrhRrpUP
	 2+3a/fLp9krpPkPyXZ1MUymP3B1s0mYipZW/21QFPZjsMIg0zbfFUHSQQVMdGKua8YokA
	 C+28V9qhikoZpKj3DTadVHv3jqeSmlE6H6FgcgBWoLp+N7jK0HMW4xJksinvzM+cpDEJm
	 qX7460LkaRCE9kcLAoMo3VZJuWxReICJAj454IgCMOZjZlcVGoznT6mZFQatTHBYIXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793289898;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=Ujti69uAXYq3nrNEejy8limZ43MgliAb4aAxtO/+OGE=;
	b=gJ4lcBKUykU22nfX2vAVs5aFDu0P8Iv/cdnVlQ3T8sHsitBjvd0ZLWHyXguHQ+Sip+G3
	 f92ZZqpPmkkBRM8xecacGvpa/r8/1ZcwrzPZx87+EaVaOS5AvWLWmgAiH9yDRoJieYin6
	 LRo6m0Ci9bKp3yWxdSM+JEAhHAblHmK3lWP2DnCEGcy1nNKsSP8FJ4y6DmsCWwf6HB8wp
	 Tdy0CookPuJVtEv3qdU9Y0CulTRnLNApUWZSk/y6o7RpAmcZXUh2BSCsGI2huCYts4QaU
	 UNMpKmmBaUMF5WFERPlQCY6qnWbCQUfv3fHcwgZ38EaJP3zlNmJevQu9CJSONGxwa0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BFWmR8i8;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB24B606A333
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 16:04:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB24B606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BFWmR8i8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793289893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ujti69uAXYq3nrNEejy8limZ43MgliAb4aAxtO/+OGE=;
	b=BFWmR8i8lN39a/4W1Y3jxkiFLlHmb5bY3fd3pVVfCxtrExFElaY1dFvXiQ80/TQz5qn1Zz
	FoXfXtG124xbCW72AceY0ysLyFUCKLuFsIvx8LV856P0AWBtPCu8Gu5X0KsG7pboKOwPjo
	yvO6mO59uEBLAGNBppLgLt6p1WVKAiY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-313-djN2mtQlNgiWl8wg_aSqvQ-1; Thu,
 29 Oct 2026 12:04:47 -0400
X-MC-Unique: djN2mtQlNgiWl8wg_aSqvQ-1
X-Mimecast-MFC-AGG-ID: djN2mtQlNgiWl8wg_aSqvQ_1793289886
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 27730195FDE8;
	Thu, 29 Oct 2026 16:04:46 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.22.80.33])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6132F30002CB;
	Thu, 29 Oct 2026 16:04:44 +0000 (UTC)
From: Jesse Taube <jtaubepe@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Nimal Prabudoss I <nprabudo@redhat.com>,
	jmeneghi@redhat.com,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-ETH-Storage-Upstream@marvell.com,
	Jesse Taube <jtaubepe@redhat.com>
Subject: [PATCH] scsi: qedf: Remove unesseary function call
Date: Thu, 29 Oct 2026 12:04:43 -0400
Message-ID: <20261029160443.904468-1-jtaubepe@redhat.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The result of `skb_transport_header` was unused. Calling this function
warned when `skb_transport_header_was_set` returned false causing a
panic on debug kernels.

Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
---
 drivers/scsi/qedf/qedf_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index da429b3a4283..f2bc0ac684e0 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2496,7 +2496,6 @@ static void qedf_recv_frame(struct qedf_ctx *qedf,
 
 	/* Pull the header */
 	hp = (struct fcoe_hdr *)skb->data;
-	fh = (struct fc_frame_header *) skb_transport_header(skb);
 	skb_pull(skb, sizeof(struct fcoe_hdr));
 	fr_len = skb->len - sizeof(struct fcoe_crc_eof);
 
-- 
2.56.0

