Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B1E3A8FE9
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 17:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789493886; cv=none; b=ig5fNMBI7wLzCZqcKqd/2ydH6sjuxLGBKWobheNlG1GJmsEAigxUC2oiK/m49kKmzBE6lWUh3lxDwqGqbT6pLjoCGvkbP63Qf1Z5j3AEk+f2HAC6ct4he+4TKcW7x9LPrQNJKocXrAJcidoMGrX+NW9RBLlIBHDY7RYedgx+CWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789493886; c=relaxed/simple;
	bh=HPslPY4Vy3MJ7JAbE41VHg/C92Qz0w2yPQluOG4LZUI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=WEQX4eFkkVxcWNZ3JWJGP4aRErr19yFb0aWtb8IaasMwWnZuxRXsWWo7qT3uPERNx0g1mUrcwJZC3iGstOHcUnRCQLbHz2cVgdHacZPJpK/AjLHFt29OeqVrYFOrXXtPw2/NMncdzp2cgNouQVLlPB45tKdKExmyZEVyzZS7q4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GMcw6SY1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GMcw6SY1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789493884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lvLKwXLBs+Nx6mnBvndSscS74iFNQYIv5jX4lyzK3os=;
	b=GMcw6SY1C/zNqwkd0Xd0M3WpXZ0ZCYQspAJtcyjYVG2HvjuMBJbrh0xAtL6DDy0c9PPCUO
	wvy+jD3JZ8pPiQ9Ni+ZRpeu55F54ndZ2hGBVSTfcI1p106Kbaezk7/QJ/DCyxrKdUqgU/V
	j/41vWNIdcUKLIFsmusOL5AgA5qRW5o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-oScFk6pbNeu5h5Qdbqoc5A-1; Tue,
 15 Sep 2026 13:38:02 -0400
X-MC-Unique: oScFk6pbNeu5h5Qdbqoc5A-1
X-Mimecast-MFC-AGG-ID: oScFk6pbNeu5h5Qdbqoc5A_1789493882
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01EB319560AD
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 17:38:02 +0000 (UTC)
Received: from emilne-na.westford.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9DFE23003EFB
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 17:38:01 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: devinfo: add BLIST_SKIP_IO_HINTS for EMC Symmetrix
Date: Tue, 15 Sep 2026 13:38:00 -0400
Message-ID: <20260915173800.39117-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

EMC Symmetrix returns an error on MODE SENSE for page 0Ah subpage 05h
because it does not implement the SBC-5 I/O hints.  These commands
began to be sent as a result of commit 4f53138fffc2 ("scsi: sd: Translate
data lifetime information").  Add BLIST_SKIP_IO_HINTS to avoid sending
these commands because in large configurations the failed commands are
displacing other useful information in internal error logs.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_devinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 2bccadf4f22f..cfc259fd0141 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -161,7 +161,7 @@ static struct {
 	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* EMC CLARiiON, no storage on LUN 0 */
 	{"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN |
-	 BLIST_REPORTLUN2 | BLIST_RETRY_ITF},
+	 BLIST_REPORTLUN2 | BLIST_RETRY_ITF | BLIST_SKIP_IO_HINTS},
 	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
 	{"easyRAID", "16P", NULL, BLIST_NOREPORTLUN},
 	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},
-- 
2.47.1

