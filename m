Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A3A221FB2
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 18:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755196167; cv=none; b=LxgRqMNCO3KWnof3UiDzaMVBSsiLQ6qBqGQrnTdEKotoJYihLsprxHcT3cL4/3hNtepxZejGR5hl9+1JT2srJRPLH3jMUbngIVO07jcNFG9fPePs+Exive6f2azXrgaMKaWCFIXa3a/ZCXU8us4rLY7pR6Q8cSkl6t5Vx5zoKKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755196167; c=relaxed/simple;
	bh=ZOcRcKidGIFGZEPBogvHIz89iH5YjF91QT+lpDyOi9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qF+QW8bYC5s7/0ylWWD53mPBFq57uBIVzFT1EHMFveaDWSrcrFmscbe7kMcNKirXtV025Q0eATL3iMcGwbZcyl1w+iJGB1DALu4L2inRj4gj4M2eoXbqmPDUrAcJwhsfr519zB6r9lSev1XWT8fOaCk/gsnyIS2n8eSWazAbLY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dNkP3ugS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dNkP3ugS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755196164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6TwlC3bQn7t26Yf+3zif0QT/B3Df+A67p9Cp5BXX8C0=;
	b=dNkP3ugS5IMvdOc46EXwgs88Mt9esB3HVfYFMBGnzvlEMenY1Cs1PvI5fCHMuJtSwe7pcx
	p1v/UarrXNn/vRxiV9Oke7VqmIxNxmDxrKybh96vp0ViIVTEsRaEEoxxv9uPYFcC3OYBx5
	1lGUSlpAkgf1yjlXTK1Ob5AbSBvNbmM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-600-Qlq5Rb4tMvKI30G56J0Apg-1; Thu,
 14 Aug 2025 14:29:23 -0400
X-MC-Unique: Qlq5Rb4tMvKI30G56J0Apg-1
X-Mimecast-MFC-AGG-ID: Qlq5Rb4tMvKI30G56J0Apg_1755196162
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D807180034D;
	Thu, 14 Aug 2025 18:29:22 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.65.61])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 197571800280;
	Thu, 14 Aug 2025 18:29:20 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org
Subject: [PATCH v2 8/9] scsi: Simplify nested if conditional in scsi_probe_lun()
Date: Thu, 14 Aug 2025 14:29:06 -0400
Message-ID: <20250814182907.1501213-9-emilne@redhat.com>
In-Reply-To: <20250814182907.1501213-1-emilne@redhat.com>
References: <20250814182907.1501213-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Make code congruent with similar code in read_capacity_16()/read_capacity_10().

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_scan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c754b1d566e0..1346a52f55c4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -717,14 +717,13 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
 				result ? "failed" : "successful", result));
 
-		if (result == 0) {
+		if ((result == 0) && (resid == try_inquiry_len)) {
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

