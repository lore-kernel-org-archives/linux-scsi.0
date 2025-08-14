Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612B822332E
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 18:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755196162; cv=none; b=sphTBrsrqG9htYwuuJb6VM4eaL8YyuUpQZHL3SQ/DqA8NZmhVyCk4YeiGE/d2e5j9uQvvAxd5hrouzqtSUbZ6FWB6F1joNCo3rERM4Fuu4UyJlRWd3o1qXigEh0UdJhPbQYJK45xHb6PoNdPFwzsZRCOsB9tX5MQJ4OuOakQNKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755196162; c=relaxed/simple;
	bh=O81X8DKnuCb7t21Yh1be+bTXB097C6E5fw9NmyyMnIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfFyQcJH+kj5vAca/MIXsKwag0ho0lp3Ge5QOgmVkGXuHMOgrzPNZqBtXXKc7ANgGRT86vWOXvGmS8Tld3mlRYr5dLi395z/6J+VcUfr2XoGiEKI0kstcSo823pQGsD9CPYyzJDrN8/SEP2Dz6zDFOR3rBwZKwJJC8Kxyn3z7Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hX3uJDLh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hX3uJDLh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755196160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7NvNyFEre7xyPSGF6RPAp9/DHG5Z9KH+Hybh64tOsdw=;
	b=hX3uJDLhIAWT3qHW1s0tIDlyyACMeUh0jEIhU+vbkgqd8BVfxHR/HtEA6RuZJ1fSMqEa+8
	eelUavGjJLmWp874bIXBiW2V67QT7lOJjIGYiP/OPgtre/vMmhdQTpST3XTNFs4xGt6g2L
	SfKJfqYh37DktKd0Yd27IpOa40+1zXU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-382-tKS0bDb1PTyQSYdUyzDSSg-1; Thu,
 14 Aug 2025 14:29:18 -0400
X-MC-Unique: tKS0bDb1PTyQSYdUyzDSSg-1
X-Mimecast-MFC-AGG-ID: tKS0bDb1PTyQSYdUyzDSSg_1755196157
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BBB11955D56;
	Thu, 14 Aug 2025 18:29:17 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.65.61])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 762DE180044F;
	Thu, 14 Aug 2025 18:29:16 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org
Subject: [PATCH v2 5/9] scsi: sd: Avoid passing potentially uninitialized "sense_valid" to read_capacity_error()
Date: Thu, 14 Aug 2025 14:29:03 -0400
Message-ID: <20250814182907.1501213-6-emilne@redhat.com>
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

read_capacity_10() sets "sense_valid" in a different conditional statement prior to
calling read_capacity_error(), and does not use this value otherwise.  Move the call
to scsi_sense_valid() to read_capacity_error() instead of passing it as a parameter
from read_capacity_16() and read_capacity_10().

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 44422751c95e..10ba6ec5012d 100644
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
@@ -2723,7 +2724,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
-		read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);
+		read_capacity_error(sdkp, sdp, &sshdr, the_result);
 		return -EINVAL;
 	}
 
@@ -2805,7 +2806,6 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		.sshdr = &sshdr,
 		.failures = &failures,
 	};
-	int sense_valid = 0;
 	int the_result;
 	sector_t lba;
 	unsigned sector_size;
@@ -2817,15 +2817,13 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
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

