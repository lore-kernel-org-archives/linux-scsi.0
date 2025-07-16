Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6F821D5B8
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 18:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752691725; cv=none; b=F4JBoC92GKu+xTZdmewcM7uKei6UNELuHGOaavNXc9U0G9EW85/EkEbLxAGlLE4wIgUNa0JVdTYv+9+SEQsFK9XX1QUamcKmPnEpPOpi+y0Eth3+y09J9P5iRJKh1rzg1H6KJHYGaXfTNq6qUlWn2SZha76iQjL98hDPPLAqetk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752691725; c=relaxed/simple;
	bh=upFWMvD5kbcRD7Mxb8txVz09G1bPi2TWVh1SgsZwucM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1yu7VQ8Oj96pEPNt5yKpdYpOZnSksrjdzT51Xo39JeR2xUILFh7+SgfLANtJQVMiPtt+zfVp7ZL4nfJ0bYM0YqZjGljpUwXhwe1qxKh2xD6cjkNRnSy6f16lTBh/pPFHPb3TmGPWlY8O7wfDrZv0kyG44pG8zV65EtL6Ym4XQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CXf/U4+0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CXf/U4+0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752691722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XR/yoa9jWy1Bhsf3uA5qfTJQ5xx9pO0p5A2drEiQLDQ=;
	b=CXf/U4+0Argx13eYdUqlAWF7F7nxdUGT0Td9pAiDqPLvdwyNzRKgrnYu+ZwDh5w3mFw+iP
	98V7BMgOEx7MhyG9A+lp4/mgnbITxjlWvrPESn2+KoFeFxhJZOZ/M/RP3zp3FnTuEhrrb1
	MFQmra5oV+QTmdr59VWqVwfN7p0XyjI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-339-gObyGHHrPPW5ylAV0IUjMg-1; Wed,
 16 Jul 2025 14:48:38 -0400
X-MC-Unique: gObyGHHrPPW5ylAV0IUjMg-1
X-Mimecast-MFC-AGG-ID: gObyGHHrPPW5ylAV0IUjMg_1752691718
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE4DD1800359;
	Wed, 16 Jul 2025 18:48:37 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.88.244])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E165B18002AF;
	Wed, 16 Jul 2025 18:48:36 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com
Subject: [PATCH 2/5] scsi: sd: Avoid passing potentially uninitialized "sense_valid" to read_capacity_error()
Date: Wed, 16 Jul 2025 14:48:30 -0400
Message-ID: <20250716184833.67055-3-emilne@redhat.com>
In-Reply-To: <20250716184833.67055-1-emilne@redhat.com>
References: <20250716184833.67055-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

read_capacity_10() sets "sense_valid" in a different conditional statement prior to
calling read_capacity_error(), and does not use this value otherwise.  Move the call
to scsi_sense_valid() to read_capacity_error() instead of passing it as a parameter
from read_capacity_16() and read_capacity_10().

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 41b7dee5eaf1..72ad4b82f0f3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2592,9 +2592,10 @@ static void sd_config_protection(struct scsi_disk *sdkp,
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
@@ -2712,7 +2713,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
-		read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);
+		read_capacity_error(sdkp, sdp, &sshdr, the_result);
 		return -EINVAL;
 	}
 
@@ -2786,7 +2787,6 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		.sshdr = &sshdr,
 		.failures = &failures,
 	};
-	int sense_valid = 0;
 	int the_result;
 	sector_t lba;
 	unsigned sector_size;
@@ -2798,15 +2798,13 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
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

