Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED4E18B12
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 21:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755292546; cv=none; b=R9Ca88kOnjsERUIv/DkCOpJ/pQTv1JPdbQ4/tcmjue9o1XnZFtaOMqcN1Vfi4sZFJ2+kFD845hiF6qNhPxV5KMXPAHk6ZHraKHOO2iLC6f0GIi1giJQCYNFktreM2+HEjegczy2gM7TWsgq32ugsQj2wCtCnwM8kn2tdca/sLaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755292546; c=relaxed/simple;
	bh=9gJwc2rZeW/t55fmHp5OQkNInGF5BsEul3iFTcOuuVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iF7a8YNS8MvxlymR+sNb5/UutjtkC8wb5bQkq5HKh/EAyw/OvEKsk3ikxRewnm4j8O6DoCQYqQYfmPh7j1Uawgv+W4jNM9fBu7gf+Uxqmgm+W3RTJeqSLkwH+Ep+wSbUr7OpMaAuC2VIEVTjsHKeU0bIBJDkjmMsW5dzBjPvhC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MsteTNY/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MsteTNY/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755292541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Mqzvys+AEq/qf22KPN1CDpo1NgXc7AOUZpX375dkC8=;
	b=MsteTNY/D5F55hPd1YzdFBY+p8doG0aANoh/v5uV+Ev0qBVtRNHupe6OM06VhUfLO7a2S0
	au2bjok4LdXLOdy4Deay3GySLb11GWzMeKBLCB0G1cogVqHi2YGzy1a+497O+pzsllxJyH
	hYYkrVtziVFKOAF5rS39y8PEqEqwsuQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-267-l_u320FoOru2BbWwpfheAQ-1; Fri,
 15 Aug 2025 17:15:38 -0400
X-MC-Unique: l_u320FoOru2BbWwpfheAQ-1
X-Mimecast-MFC-AGG-ID: l_u320FoOru2BbWwpfheAQ_1755292536
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA7EC19560B3;
	Fri, 15 Aug 2025 21:15:36 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.65.61])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7B64119327C0;
	Fri, 15 Aug 2025 21:15:35 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org,
	dlemoal@kernel.org
Subject: [PATCH v3 5/8] scsi: sd: Remove checks for -EOVERFLOW in sd_read_capacity()
Date: Fri, 15 Aug 2025 17:15:22 -0400
Message-ID: <20250815211525.1524254-6-emilne@redhat.com>
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

Remove checks for -EOVERFLOW in sd_read_capacity() because this value has not
been returned to it since commit 72deb455b5ec ("block: remove CONFIG_LBDAF").

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d465609a66e3..acd79e9a0d82 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2863,8 +2863,6 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
 
 	if (sd_try_rc16_first(sdp)) {
 		sector_size = read_capacity_16(sdkp, sdp, lim, buffer);
-		if (sector_size == -EOVERFLOW)
-			goto got_data;
 		if (sector_size == -ENODEV)
 			return;
 		if (sector_size < 0)
@@ -2873,8 +2871,6 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
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

