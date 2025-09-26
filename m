Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA87334BA4D
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 00:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758844962; cv=none; b=h4Vik7EvynP+by56sRXoElwAzkkHN9cH+QJYAqjiM1axPC79OgRxeSaSc8oH7czoQ806a5WFJwFAXkt5OmcOEinw4JDzDx6/sNYUk8VX7NGNE3MuTDJq+SvusVVVu/8FVE08vXXWIxL57f/6jxozS2GAFrZL58zWCBVgk9BxYV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758844962; c=relaxed/simple;
	bh=gGvwsfciomeDFa0u187g5a0jXXRwdobh9Nigw52RoTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=EGsCZLU3b6qxje35BfkO+IsbwVuW2jCSfiCIGzka07iThvk8TV5ZzJZEWRJNz/6KvR41oA3WxA6MXl6ReYof7KpaQZ2rTnKOt+JXl7d2i30pVnnBKDYSV9mGTxNr132xAzG1Jz05GImebE2tGVlcwqkShuH2xjXy6lg+V1lWV80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fbTXYj3I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fbTXYj3I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758844960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=avR9HzpeWIVFloMhMV4QtPG2R/sAjZzj6Xge04iSKcY=;
	b=fbTXYj3IDTGJ5OOhWwY1Kw88x56QUxlTRtjklCHN2CnjVNYOPk7Lq1oOzsQ9aJtNde93Jm
	HdODetVCGBxt/UmLAQPA/Lnpr97RE52r4tdyNwgtsUyK983D7891WeKRSR9yRumXVL7baO
	yF2MP2RSWeDsQrHvPavazdV6XFFggu0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-462-YCMiM_KoPZ6ZUQ42SWObGg-1; Thu,
 25 Sep 2025 20:02:36 -0400
X-MC-Unique: YCMiM_KoPZ6ZUQ42SWObGg-1
X-Mimecast-MFC-AGG-ID: YCMiM_KoPZ6ZUQ42SWObGg_1758844954
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE4A7195609F;
	Fri, 26 Sep 2025 00:02:34 +0000 (UTC)
Received: from jmeneghi-thinkpadp1gen7.rmtusnh.csb (unknown [10.22.81.200])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 122A91800579;
	Fri, 26 Sep 2025 00:02:31 +0000 (UTC)
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
Subject: [PATCH v10 08/11] scsi: lpfc: enable FPIN notification for NVMe
Date: Thu, 25 Sep 2025 20:01:57 -0400
Message-ID: <20250926000200.837025-9-jmeneghi@redhat.com>
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

Call fc_host_fpin_set_nvme_rport_marginal() to enable FPIN notifications
for NVMe.

Co-developed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Bryan Gurney <bgurney@redhat.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 1511cabac636..bfd9ba4552f3 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -10256,9 +10256,14 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void *p, u32 fpin_length)
 		fpin_length += sizeof(struct fc_els_fpin); /* the entire FPIN */
 
 		/* Send every descriptor individually to the upper layer */
-		if (deliver)
+		if (deliver) {
 			fc_host_fpin_rcv(lpfc_shost_from_vport(vport),
 					 fpin_length, (char *)fpin, 0);
+			if (vport->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+				fc_host_fpin_set_nvme_rport_marginal(lpfc_shost_from_vport(vport),
+								fpin_length, (char *)fpin);
+			}
+		}
 		desc_cnt++;
 	}
 }
-- 
2.51.0

