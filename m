Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5435F283FEE
	for <linux-scsi@vger.kernel.org>; Thu,  2 Oct 2025 19:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759433131; cv=none; b=NHucdo9CXqLcvtfqV7rfjIk6NjC91G5vAwUB4+7TeRJzoOKh+QNlcqr0F6CHP7zebUFpw0vqehiT1DLNaZDjSg+3CIMs/L4fbRz6Ud8ehH1nAsi40AzUYlsV3x3Ckd75WDyVmpLgqcrh9NuUTQsmlNR/vvNtQ73SkOp4v99dLYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759433131; c=relaxed/simple;
	bh=dbrjZh0GGPkXXhPQLvVxnMseapgPSgZPvNw5/QOIN7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWuY/R7Z7rVGTbMcURudOpWrFeGhWgyE+g71TXLDljYt4hh9u6uinkefF3rw+MqGNwBDjBy3L0gpDoLp+5nvW2Tp65gX4XaEFCTepVELOPsx0rjvIEx4rQc9Zgytp/F2utkNmJk3bMFoOFXCe1cnalV1sqMKCT9CXo72RNMeEA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JJIHWPVo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JJIHWPVo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759433129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QtuthjZ25ovQT/etmS55yT7s58jE6zyyYqVxmMGrL/4=;
	b=JJIHWPVoQZ20yzyDPyoMHS4wlhCguOetQEd+8q7l6qztyTCKyGU88iJu2vNXfSap1X28Qd
	Z4+n3RWOrcQqdleslZXFKq2k0IstdPwH+t5jc0+Vzth3rqVmYuhqx1fKe1YB8W9UF6FspV
	4mNeNk3iZS8P4uv9nCaUGIZHUUr9cvw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-312-PnXcilHBNDqTn8g3MPw8XQ-1; Thu,
 02 Oct 2025 15:25:26 -0400
X-MC-Unique: PnXcilHBNDqTn8g3MPw8XQ-1
X-Mimecast-MFC-AGG-ID: PnXcilHBNDqTn8g3MPw8XQ_1759433123
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C8E86195608A;
	Thu,  2 Oct 2025 19:25:23 +0000 (UTC)
Received: from emilne-na.ibmlowe.csb (unknown [10.17.17.93])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 916341955F19;
	Thu,  2 Oct 2025 19:25:22 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	hare@suse.de
Subject: [PATCH v4 7/9] scsi: Simplify nested if conditional in scsi_probe_lun()
Date: Thu,  2 Oct 2025 15:25:08 -0400
Message-ID: <20251002192510.1922731-8-emilne@redhat.com>
In-Reply-To: <20251002192510.1922731-1-emilne@redhat.com>
References: <20251002192510.1922731-1-emilne@redhat.com>
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
 drivers/scsi/scsi_scan.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c754b1d566e0..348ecfe5cdb0 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -717,16 +717,14 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
 				result ? "failed" : "successful", result));
 
-		if (result == 0) {
-			/*
-			 * if nothing was transferred, we try
-			 * again. It's a workaround for some USB
-			 * devices.
-			 */
-			if (resid == try_inquiry_len)
-				continue;
-		}
-		break;
+		if (result || resid != try_inquiry_len)
+			break;
+
+		/*
+		 * If the status was good but nothing was transferred,
+		 * we retry. It is a workaround for some buggy devices
+		 * or SAT which sometimes do not return any data.
+		 */
 	}
 
 	if (result == 0) {
-- 
2.47.1

