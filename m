Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380981DC075
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2025 17:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750442269; cv=none; b=R8/xpzgec0XdSYb8NisV9HXnrhOJuB2VD8YI24Q8rwGmUk4mmeqf+tb7E1+iuWlJoql+sADXQV27sGl9FZt5nt91fCrffIdyO1//YjtJSZDgXfHaUEptMythu2u9OC66Z0wnkr2Yk1MMdWoOvfCRbd3kpeA1mBIJg4Lp8CD5KUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750442269; c=relaxed/simple;
	bh=5Gjrf/8TSC1Wo1AyY42o5JZp5CQ472s+ulBndMDcJfg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e4c6d4Su/k2y4RGxIs2b53X8NBZv/tRmyiaKRmuCnh46h4JzgI6NcidBKrmEqPvcS2IcXpgeT7+JP9UR6YWDYyD/S7xRWV74vvowpbsGB7geu2lDYvEAkYFcChXjeLT5KDCEHhpmfRS9InQY/V9PUDM3XwmQ261bGe09S6acEgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XRHlUn0d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XRHlUn0d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750442267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LZHCVpRfqA1ZoANSnSbT28oQCdLRuu6wzz22Z7s4YUQ=;
	b=XRHlUn0dFE7cb+6Hs6kHo8JjhmIITtr+EkFABRlr6heZOBv2Qg7oUngFonVl73exJ+PTuR
	n+BHj2TADiCAW8+4/XUkjVmaSqGNX92C1+RNTWrUqmCQr8OcdyBKGP23STXzpzKarbn1+A
	+qe4R10uPR8lq6HdkrUImD+mi6DrnMM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-596--XMLh-CfO1SVYbYkGlfotg-1; Fri,
 20 Jun 2025 13:57:43 -0400
X-MC-Unique: -XMLh-CfO1SVYbYkGlfotg-1
X-Mimecast-MFC-AGG-ID: -XMLh-CfO1SVYbYkGlfotg_1750442262
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2187819560BC;
	Fri, 20 Jun 2025 17:57:42 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.22.80.187])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 48973180035E;
	Fri, 20 Jun 2025 17:57:38 +0000 (UTC)
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
Subject: [PATCH v6 4/6] lpfc: enable FPIN notification for NVMe
Date: Fri, 20 Jun 2025 13:57:32 -0400
Message-ID: <20250620175732.34731-1-bgurney@redhat.com>
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
---
 drivers/scsi/lpfc/lpfc_els.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 959603ab939a..396ed1a05bc9 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -33,6 +33,7 @@
 #include <scsi/scsi_transport_fc.h>
 #include <uapi/scsi/fc/fc_fs.h>
 #include <uapi/scsi/fc/fc_els.h>
+#include <linux/nvme-fc-driver.h>
 
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
@@ -10248,9 +10249,15 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void *p, u32 fpin_length)
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
2.49.0

