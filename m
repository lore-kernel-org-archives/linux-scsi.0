Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD05C224AFE
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2025 21:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752096197; cv=none; b=QRdG/5u9sU3/9FZbipWSsPEXy8F/15TgzfFLcI/wZjaVMNXvlTuAG8TbnrvzaLNx1n43wRXBv5kbzYujjQL3xSqEsnD/pnA+LdRSlAywpEigecs8GJpORHPUDotNr8t1SZiY2dIRcF7myC43cbWrIg09rrqAnkFn25Sw5YsyAVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752096197; c=relaxed/simple;
	bh=/MC/CnT6xVmib5F60JealImtnFgxHkY5L12vwEIJM7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UW2q5XOMYveVJlcLuesWja97cV/s4qP5WIE8pOhwrn/z/9U8XoZ6/WhX7FUkeyIHhlDVgU4V5+qlxLe2CsAMnMqyuHAhz5XTCgtRYLaGt1NDNj5RI5KPXEmvHsWO/0H3ED7qaAILDxGtbKgb1w+B95fodAdydhpJewppyq3ODkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T0XJeh+J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T0XJeh+J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752096195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NQeGOT2GM2z7h+sRtyQyZ/7OyFH5jaaYOb6VTVSrgMU=;
	b=T0XJeh+JL0mazpmJnZ5dhellFfbpHEGOB9ssHIaDSNQmGGPoPKQ3mEwtd8Va7cpNePS0xS
	I6bGbmUmfkvenLFq2UEevzOjEfcsxAN9N1FmrNP11om9gw65KCRC/8eWEJMVki2LLY183C
	DCYjtmhTu3AZcI85aQ+jcn656d3DIJs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-2Lht7qFyMaqU6NljWxC3Fw-1; Wed,
 09 Jul 2025 17:23:08 -0400
X-MC-Unique: 2Lht7qFyMaqU6NljWxC3Fw-1
X-Mimecast-MFC-AGG-ID: 2Lht7qFyMaqU6NljWxC3Fw_1752096187
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0E491944AAD;
	Wed,  9 Jul 2025 21:23:06 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.44.33.49])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA7BC18002B6;
	Wed,  9 Jul 2025 21:23:00 +0000 (UTC)
From: Bryan Gurney <bgurney@redhat.com>
To: linux-nvme@lists.infradead.org,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	axboe@kernel.dk
Cc: james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	njavali@marvell.com,
	linux-scsi@vger.kernel.org,
	hare@suse.de,
	bgurney@redhat.com,
	jmeneghi@redhat.com
Subject: [PATCH v8 5/8] lpfc: enable FPIN notification for NVMe
Date: Wed,  9 Jul 2025 17:19:16 -0400
Message-ID: <20250709211919.49100-6-bgurney@redhat.com>
In-Reply-To: <20250709211919.49100-1-bgurney@redhat.com>
References: <20250709211919.49100-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

From: Hannes Reinecke <hare@kernel.org>

Call 'nvme_fc_fpin_rcv()' to enable FPIN notifications for NVMe.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Tested-by: Bryan Gurney <bgurney@redhat.com>
Tested-by: Muneendra Kumar <muneendra.kumar@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c7cbc5b50dfe..146ed6fd41af 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -33,6 +33,7 @@
 #include <scsi/scsi_transport_fc.h>
 #include <uapi/scsi/fc/fc_fs.h>
 #include <uapi/scsi/fc/fc_els.h>
+#include <linux/nvme-fc-driver.h>
 
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
@@ -10249,9 +10250,15 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void *p, u32 fpin_length)
 		fpin_length += sizeof(struct fc_els_fpin); /* the entire FPIN */
 
 		/* Send every descriptor individually to the upper layer */
-		if (deliver)
+		if (deliver) {
 			fc_host_fpin_rcv(lpfc_shost_from_vport(vport),
 					 fpin_length, (char *)fpin, 0);
+#if (IS_ENABLED(CONFIG_NVME_FC))
+			if (vport->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
+				nvme_fc_fpin_rcv(vport->localport,
+						 fpin_length, (char *)fpin);
+#endif
+		}
 		desc_cnt++;
 	}
 }
-- 
2.50.0

