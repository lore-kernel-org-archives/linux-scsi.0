Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E03228BA91
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 16:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753116418; cv=none; b=qFXXzeoiS2fVc/aBmGlXxtzBt6i+3YRFwEL/7Z4cNiJZ20YenA6BDzYRL0U0oePLfLk14U7IrPKzA8L9JKaJx5AutsQRj+Mwi7ZhLuUqe0WXelQqz7sFvzpdf3v5zzgTXxQbOFT54l4pH49OmdTC7Arcsw8cPR/CkDt77ZlXL+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753116418; c=relaxed/simple;
	bh=kmaqGAJuuAyViHwazRaeuSnf9vK1V8IM0E0LPLSiWro=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Nz/7wVPOq31vkYDBsaIwjzwy94ouRHvkH7lmQiEPAnpi+StexenU7ceEuYqFBac5JQfOHGwCToKgUXcSC3BS1Fo+Ms2SNZYDkXc8pN3b592eqw6/VCdqFo6yPFPkMrVIPM+bRrY3NH1god+O3YmtSoKFiRvy2s1b0rf4Q7Nvj+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QdEazhuF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QdEazhuF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753116416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=suX8mhxpayW9+4HAx07jEpmZ/rnHzKZN3z4nBiEZ+f4=;
	b=QdEazhuFNcTX2xwhYiDRLSQEJHM1/hvadAQNIHCzFoug13tqBscqnmL8EPf/eS+G/HZPsc
	zAlGA6n1/pPYU7ZvKD03y431Sm4A2Yfua6Pf9LqyddCZe9+v1kUBYJKYjUhaW7lM9JiWld
	RAWBY2NGZlG6N7BVaLH3SnA3h/fWwCY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-611-V39TPfTXO7aO__dcW6uOhw-1; Mon,
 21 Jul 2025 12:46:54 -0400
X-MC-Unique: V39TPfTXO7aO__dcW6uOhw-1
X-Mimecast-MFC-AGG-ID: V39TPfTXO7aO__dcW6uOhw_1753116413
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 92F8819560B0
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 16:46:53 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.64.119])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2F13119560A3
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 16:46:53 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: scsi_transport_fc: Add comments to describe added "rport" parameter to functions.
Date: Mon, 21 Jul 2025 12:46:52 -0400
Message-ID: <20250721164652.335716-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Note that there is no executable code altered by this patch.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507181446.aAoFiDm5-lkp@intel.com/
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_transport_fc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 82d091d627c0..3a821afee9bc 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2807,6 +2807,7 @@ fc_flush_work(struct Scsi_Host *shost)
 /**
  * fc_queue_devloss_work - Schedule work for the fc_host devloss workqueue.
  * @shost:	Pointer to Scsi_Host bound to fc_host.
+ * @rport:	rport associated with the devloss work
  * @work:	Work to queue for execution.
  * @delay:	jiffies to delay the work queuing
  *
@@ -2832,6 +2833,7 @@ fc_queue_devloss_work(struct Scsi_Host *shost, struct fc_rport *rport,
 /**
  * fc_flush_devloss - Flush a fc_host's devloss workqueue.
  * @shost:	Pointer to Scsi_Host bound to fc_host.
+ * @rport:	rport associated with the devloss work
  */
 static void
 fc_flush_devloss(struct Scsi_Host *shost, struct fc_rport *rport)
-- 
2.47.1

