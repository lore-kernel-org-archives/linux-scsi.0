Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1A7242D6C
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 21:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755292547; cv=none; b=nEgmN5LbirYrVcTWgYbVdwoOkYcazyIu4PKvvwKVFYGPZQb+c2tASHrRnlqdayF/77Fvbu/F6/Mqx5YaYpOPFu4bCH/frbN+RWhJsh9N/1ESRFAukJR5LRHMAVKRI+sOQpYWa1pnnj28VaK8Ui+yFAXkeFH+oZ44CeCTcqxoZJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755292547; c=relaxed/simple;
	bh=35yUHmcTXqFfQwg72ihh0AhVga4gPfUdiEkdeDJ5t5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOC6vSbYzUWgIFEkyF02pvAKMx5eIOnwTPE7Mr0exvWgSR3h9VJq6nDKIBNYXzLR8izKzfAg/Uo/Q2DOeyKTdh6bGf7vBwv91B5so6nMNeJyux5Mc2d1wLQaN5/bYo2QAWSo4OwaF6QkNppfcvVl0v7mgxuZ/ViYzocabQ2bXhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XOdUvERw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XOdUvERw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755292544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WHkwPLfYksQ2LUKmiAQCy0MYfPSI9/YA9pPMCjwbyTE=;
	b=XOdUvERwLKs9xeiBKJRiqdilLObM+KBcGC1sMOhNPr/0lbvZMx3b7bGhLecLE5/EYCRDsL
	rtCnGdWC2JqvC2fK59z/Xws/+KlUcVEzRhawJ+LNJ0PyEzrn8u6U24y/GHQgTPNX7A4ozt
	1RXvnVoutnmbNf445EuwK6b3AH35zGE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-mhJUN-vnNz2TpFnUbYvJDQ-1; Fri,
 15 Aug 2025 17:15:41 -0400
X-MC-Unique: mhJUN-vnNz2TpFnUbYvJDQ-1
X-Mimecast-MFC-AGG-ID: mhJUN-vnNz2TpFnUbYvJDQ_1755292540
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0DA0818003FC;
	Fri, 15 Aug 2025 21:15:40 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.65.61])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B993B19327C0;
	Fri, 15 Aug 2025 21:15:38 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org,
	dlemoal@kernel.org
Subject: [PATCH v3 7/8] scsi: Simplify nested if conditional in scsi_probe_lun()
Date: Fri, 15 Aug 2025 17:15:24 -0400
Message-ID: <20250815211525.1524254-8-emilne@redhat.com>
In-Reply-To: <20250815211525.1524254-1-emilne@redhat.com>
References: <20250815211525.1524254-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Make code congruent with similar code in read_capacity_16()/read_capacity_10().

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_scan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c754b1d566e0..9527b8fc5262 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -717,14 +717,13 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
 				result ? "failed" : "successful", result));
 
-		if (result == 0) {
+		if (result == 0 && resid == try_inquiry_len) {
 			/*
 			 * if nothing was transferred, we try
 			 * again. It's a workaround for some USB
 			 * devices.
 			 */
-			if (resid == try_inquiry_len)
-				continue;
+			continue;
 		}
 		break;
 	}
-- 
2.47.1

