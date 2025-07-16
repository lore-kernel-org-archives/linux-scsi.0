Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1EE263F5B
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 18:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752691726; cv=none; b=SHHVcinXz+o2n5fNPfDhVb+n+vgiqdMExmsHRAZgAC1K2muqmQFFC5bpHebZtk3mJRUbXxVaLD4lfT2LpYTncAnRNVT9uUNO+fYCJky735MZbMNZmAcEmrgDidItS4IH+H/XMEfgwJEWKnz15h3r6era+UC99HWNKrP9OPq3Syo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752691726; c=relaxed/simple;
	bh=PIwdzorAAcwnojA3yCgjZ7Ef6A1Bw1AYHSCbob+CiQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyXtuLZviR2X36iRGqmcG5gyugXHR1j/jiO3F+ue8jwpNddSxfA6/3DYEDlRZ98GCOTPqeEr5vX8u2x8RVYUcXCnZG70Bdn9PYn406r/Qk1DRNMeX/2qrJjIXRdDBx9bQhMya5aWttI5GSFehnZnXAEt5/KOs/2854Q8dar2rVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LmFDqzn9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LmFDqzn9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752691723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EkJPsI1671YnsyzeAtTXNmgU57iOLptDdRe2UwxgtJM=;
	b=LmFDqzn9onY4xVpnf+9l8o7rKstHrnc7NNKE9GnEvWmFN9cNo4N2ALjHP4FW2vNnTquJTt
	qfWDTuAR/aYUMXp1RzBXl7piXU+A7xWp7SXCkU0oHhoabFMSMOsz0QEiIzl9Eon5pTr9K3
	otr/1j+9/y0F5bnBGMwshNxSo4hOuG4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-354-JKjgXsboMde7GVOKZc6Izw-1; Wed,
 16 Jul 2025 14:48:40 -0400
X-MC-Unique: JKjgXsboMde7GVOKZc6Izw-1
X-Mimecast-MFC-AGG-ID: JKjgXsboMde7GVOKZc6Izw_1752691719
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 53CCF1800283;
	Wed, 16 Jul 2025 18:48:39 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.88.244])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 308C51800D82;
	Wed, 16 Jul 2025 18:48:37 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com
Subject: [PATCH 3/5] scsi: sd: Remove checks for -EOVERFLOW in sd_read_capacity()
Date: Wed, 16 Jul 2025 14:48:31 -0400
Message-ID: <20250716184833.67055-4-emilne@redhat.com>
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

Remove checks for -EOVERFLOW in sd_read_capacity() because this value has not
been returned to it since commit 72deb455b5ec ("block: remove CONFIG_LBDAF").

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 72ad4b82f0f3..f8bc5f6a6511 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2850,8 +2850,6 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
 
 	if (sd_try_rc16_first(sdp)) {
 		sector_size = read_capacity_16(sdkp, sdp, lim, buffer);
-		if (sector_size == -EOVERFLOW)
-			goto got_data;
 		if (sector_size == -ENODEV)
 			return;
 		if (sector_size < 0)
@@ -2860,8 +2858,6 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
 			return;
 	} else {
 		sector_size = read_capacity_10(sdkp, sdp, buffer);
-		if (sector_size == -EOVERFLOW)
-			goto got_data;
 		if (sector_size < 0)
 			return;
 		if ((sizeof(sdkp->capacity) > 4) &&
-- 
2.47.1

