Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DE732143D
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 06:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779950179; cv=none; b=LmGCtQCDy9EFJVFg8b50w8mZt7M2XLoqZeoBF2Hs/Qt3NSBLNp2F3yJZ4vYyZEJ9/pfH/QNzw4v77MgktzlgqykH/LijeEC9AEsg8WPK81r69OIScmlHFJKNkPYQ/chkphF625Btsdkx/nJT2QcCrI4l6FIGPQu+KT+uppzRcAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779950179; c=relaxed/simple;
	bh=DOw/ZzBYmSXzyyeK4zS/+QP0W3u9NBakFd664Tw7VRg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GF4697LsB9GGu3kcV2r9V7/HPabZci0Fj4dqGnkMiLv+aJ/WIPg7mEvkd88su2isUuGfUS/FurzRGWRKhr0G3fzJ5o7RqnDiy153J2USBvRRqP99xafB89qtdOWSBjctYZS0NwJtRPOJQxHeYAFcX0AWnVpgf4mjGInMYlESwg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HxjGX4tf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HxjGX4tf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779950177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TZ6g7N7FYYJkIC7fUk7B2y1NVe4LfZURAyPrJmAFUYk=;
	b=HxjGX4tfvlEgGO85c/nDXDWJcKs0KOr4rxTZamQdmT/HGoM4VtnW0cdHi9aluRBAvRfNjh
	a6EONkornEEdI2W2IuSGYyl2gEpTgHacjoAnMuV9XLS3EkkGtR5tyiJLNYK5DjANPqNUJL
	FOICarueinOI/soMT8X9CUAQawSGZA8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607--ne4_we-P8uCNYU_trN5CQ-1; Thu,
 28 May 2026 02:36:14 -0400
X-MC-Unique: -ne4_we-P8uCNYU_trN5CQ-1
X-Mimecast-MFC-AGG-ID: -ne4_we-P8uCNYU_trN5CQ_1779950173
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E9DCA18002C8;
	Thu, 28 May 2026 06:36:12 +0000 (UTC)
Received: from nprabudo-thinkpadp16vgen1.rmtin.csb (unknown [10.74.81.42])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D973A19560AB;
	Thu, 28 May 2026 06:36:09 +0000 (UTC)
From: Nimal Prabudoss I <nprabudo@redhat.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com,
	nilesh.javali@marvell.com,
	Nimal Prabudoss I <nprabudo@redhat.com>,
	Jesse T <jtaubepe@redhat.com>
Subject: [PATCH v2] scsi: qedf: drop invalid skb_transport_header check to prevent panic
Date: Thu, 28 May 2026 02:36:06 -0400
Message-ID: <20260528063606.22324-1-nprabudo@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

During intensive FCOE Tier 1 CTC boot tests, the qedf driver triggers a
warning assertion in include/linux/skbuff.h. This happens because the
driver attempts to access an uninitialized transport header offset via
skb_transport_header() under a CONFIG_DEBUG_NET environment.

Remove the invalid helper call within qedf_recv_frame() to eliminate the
warning assertion and prevent the subsequent system panic.

Co-developed-by: Jesse T <jtaubepe@redhat.com>
Signed-off-by: Nimal Prabudoss I <nprabudo@redhat.com>
Signed-off-by: Jesse T <jtaubepe@redhat.com>
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
2.54.0

