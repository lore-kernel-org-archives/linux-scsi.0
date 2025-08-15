Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C379F2836F
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 21:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755292538; cv=none; b=Yed8hMuAviuKynXNIIN3R26b9F/rc55mggPtRdv5tibldUp0k4eYG/qqGimgDn4Npo8iNuKH+pktYBN1r82Jtv6wHhZsXup0oAXd44aHy7IK3J7rZmwks7LPfFlSROa3U3RqP6XPdt1iSG1qA6jlObtZh/Vq5nhihQ12W09717U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755292538; c=relaxed/simple;
	bh=53T2nta0oYWE9uUPGGKUzFMVFFtqHTKj24e5AWGmA6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsohJBWOPAczVkdlniMufeCPYEirCOJNsIJqnlz/D652gwBJMe1j0kzH/PEDAdPmQW9UpV/Rdo9wVWcRefZ4b9kBxAWnYd70M4b3hXgFR8/TtcjZDrhooa0bcK0oRJFtvelH89M3Z1U8cVNOn4dfJ06ZaO6BH//WV6ZhVHaws/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b5FPDzxr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b5FPDzxr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755292534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gocn/7hpql95UK491SYXtCL4s2osIrDGn+cZF2NJ9t8=;
	b=b5FPDzxrTZ09ZgBEfhL5UlgJYVuOcHIqQLZYIU5Xn/mxwZg8+sMtvp+/XEb1gVWgIkKr8u
	wPC+ug6nII2qQoqubfm4sxVsLjnmD6q4xoPimHYa7C9SynBvQ8LrrbDUKQJ0klK6qtaJ3P
	+1RsLGkbZoPcJ+SXTWBTESzwpslMr/k=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-20jARxOsN5-ScXouBQsPZw-1; Fri,
 15 Aug 2025 17:15:31 -0400
X-MC-Unique: 20jARxOsN5-ScXouBQsPZw-1
X-Mimecast-MFC-AGG-ID: 20jARxOsN5-ScXouBQsPZw_1755292530
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00D751800340;
	Fri, 15 Aug 2025 21:15:30 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.65.61])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9DBFA19327C0;
	Fri, 15 Aug 2025 21:15:28 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org,
	dlemoal@kernel.org
Subject: [PATCH v3 1/8] scsi: Explicitly specify .ascq = 0x00 for ASC 0x28/0x29 scsi_failures
Date: Fri, 15 Aug 2025 17:15:18 -0400
Message-ID: <20250815211525.1524254-2-emilne@redhat.com>
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

This does not change any behavior (since .ascq was initialized to 0 by
the compiler) but makes explicit that the entry in the scsi_failures
array does not handle cases where ASCQ is nonzero, consistent with other
usage.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_scan.c | 2 ++
 drivers/scsi/sd.c        | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3c6e089e80c3..c754b1d566e0 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -660,11 +660,13 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		{
 			.sense = UNIT_ATTENTION,
 			.asc = 0x28,
+			.ascq = 0x00,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			.sense = UNIT_ATTENTION,
 			.asc = 0x29,
+			.ascq = 0x00,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5b8668accf8e..78f5903cc8d0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2740,6 +2740,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		{
 			.sense = UNIT_ATTENTION,
 			.asc = 0x29,
+			.ascq = 0x00,
 			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
-- 
2.47.1

