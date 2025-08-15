Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8931A39FF3
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 21:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755292542; cv=none; b=bbb+KSL4FT5sY1FNc2xh3LpGUo6+FO2q6SWohrB0DZ0j2S4WRfB8ndD6HGKH+xi8JuZBeIpX4bkeRzH0K/cLX8CwZY6pUoHH1XTn4t0EdVAM4Mu1hSmiMfXTzBwEna3aVxqasZEMYMEfm7moE76AaffryD5qYBJKVNPUSc6jWrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755292542; c=relaxed/simple;
	bh=fBBcPOojtCZ+zsaAPizArlNWrgu3rNSaGz62rFQ7msI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpMxsQLGQ1d9u/f8+YGQcxneJDcjA2LW6WQnkO0oMgVGc8naHwmBDd2lSZPa+dgkjfEu9Z0L3ZDfU+0Ht1gnYZwySNi9XBR0eu/Ejds6G+V9g9/el2muK3uJ3TbAa8cJ2dWy9ltf10oAh3u7Y1tOlqZCmWUJbb8C4Jh9+hqcADE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MeNC0KF3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MeNC0KF3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755292539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gdmrfQuQexqyZbM15QEIHSzR8uGhQB6yNxhahss0N/8=;
	b=MeNC0KF3hRd+QUQEPpdsUGvEHpEJpxUeBv259AYkyR6ZrFro2tzwojQSniDyL6PhEBbt9T
	cvGZlx3vhd1ZcR+S/8V1VBOtbs9+8CnwUA++2A5nowowlsFZMpFWCPeuaID6yKaoVKZxVY
	QSnCzQSVu2/mOpJPqL3sdfb/9LSNTjw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-qmsryfQyObWYoEn4x5gtQw-1; Fri,
 15 Aug 2025 17:15:36 -0400
X-MC-Unique: qmsryfQyObWYoEn4x5gtQw-1
X-Mimecast-MFC-AGG-ID: qmsryfQyObWYoEn4x5gtQw_1755292535
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1DA0B1956086;
	Fri, 15 Aug 2025 21:15:35 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.65.61])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A424719327C0;
	Fri, 15 Aug 2025 21:15:33 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org,
	dlemoal@kernel.org
Subject: [PATCH v3 4/8] scsi: sd: Avoid passing potentially uninitialized "sense_valid" to read_capacity_error()
Date: Fri, 15 Aug 2025 17:15:21 -0400
Message-ID: <20250815211525.1524254-5-emilne@redhat.com>
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

read_capacity_10() sets "sense_valid" in a different conditional statement prior to
calling read_capacity_error(), and does not use this value otherwise.  Move the call
to scsi_sense_valid() to read_capacity_error() instead of passing it as a parameter
from read_capacity_16() and read_capacity_10().

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 25561d01f972..d465609a66e3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2597,9 +2597,10 @@ static void sd_config_protection(struct scsi_disk *sdkp,
 }
 
 static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
-			struct scsi_sense_hdr *sshdr, int sense_valid,
-			int the_result)
+				struct scsi_sense_hdr *sshdr, int the_result)
 {
+	bool sense_valid = scsi_sense_valid(sshdr);
+
 	if (sense_valid)
 		sd_print_sense_hdr(sdkp, sshdr);
 	else
@@ -2722,7 +2723,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
-		read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);
+		read_capacity_error(sdkp, sdp, &sshdr, the_result);
 		return -EINVAL;
 	}
 
@@ -2799,7 +2800,6 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		.sshdr = &sshdr,
 		.failures = &failures,
 	};
-	int sense_valid = 0;
 	int the_result;
 	sector_t lba;
 	unsigned sector_size;
@@ -2811,15 +2811,13 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 				      &exec_args);
 
 	if (the_result > 0) {
-		sense_valid = scsi_sense_valid(&sshdr);
-
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
 	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(10) failed", the_result);
-		read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);
+		read_capacity_error(sdkp, sdp, &sshdr, the_result);
 		return -EINVAL;
 	}
 
-- 
2.47.1

