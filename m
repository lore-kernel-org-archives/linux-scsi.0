Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62DD2D3A89
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 19:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770751137; cv=none; b=Hyg/+ifzfUur9dtL6rJKw+OTUp72bjmLu1n3iXhI49q1BbkC75NBRXjnUnq7JEfU9xfMW+GQ+/EIgWDJ/D2Ai80IThIBF720ofuFy2I5NToGEHX/LDHXuDNZbWffhne15cWtOgF53/uZZnmpTwyVwjm4eBQt5FBO8Faw7PQMzlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770751137; c=relaxed/simple;
	bh=ErHp/v1VC5jf8zDEqDoFHJRRTOBfFZEA9+mMEZN6j+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OwEZoRahXARqIWxzByy6leJFeknmkz1sKcTbUGeeveUEetJDoi6G4cNUVtr//JGRq3SXLIsWlgkhjN4bUiLD23E1R5oomPUFfkN6eSJE3H0No0DjHb0ThgkRoVh2MCKjprNBvxyKpg4GZt2mQtMnHa0UPcarIlu4UvQvysqxjUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IbgHsPCv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IbgHsPCv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770751135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jhKnI7LyQ6k1aerlYWiEAQ7BcCXzhRrp9u9m9Yh2LYA=;
	b=IbgHsPCvQa2ozvEtA8aGEXm7m4pEMekxHArcqzEJby2LKP3mpKoNkigLVZ160Tv7SEnf4o
	L1QaKRgs0YFTGh+625UqpN+CigRmGzyEdPO191JGb6oGaYkH7N1Ux2Xz1MbBmbORdVbhPE
	OU8PBtbKw6JlilWDsCqMZeYM5WHxCDs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-264-4UV_KRkkOlOlkVLHjY5JzA-1; Tue,
 10 Feb 2026 14:18:54 -0500
X-MC-Unique: 4UV_KRkkOlOlkVLHjY5JzA-1
X-Mimecast-MFC-AGG-ID: 4UV_KRkkOlOlkVLHjY5JzA_1770751133
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA201195608F
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 19:18:53 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.224.253])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CA7931956053;
	Tue, 10 Feb 2026 19:18:52 +0000 (UTC)
From: Tomas Henzl <thenzl@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: djeffery@redhat.com
Subject: [PATCH] scsi: ses: fix devices attaching to different hosts
Date: Tue, 10 Feb 2026 20:18:50 +0100
Message-ID: <20260210191850.36784-1-thenzl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On a multipath SAS scsi system some devices don't end up with enclosure
symlinks from a scsi device to its enclosure. Scsi devices which have
enclosures linked to them are linked to enclosures on different
scsi hosts.
In ses_match_to_enclosure is being called enclosure_for_each_device which
iterates over all enclosures not just enclosures on the current host.
Fix this by replacing this call with ses_enclosure_find_by_addr.

Reviewed-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/ses.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 789b170da652..98a7367d2f20 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -528,9 +528,8 @@ struct efd {
 };
 
 static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
-				      void *data)
+				      struct efd *efd)
 {
-	struct efd *efd = data;
 	int i;
 	struct ses_component *scomp;
 
@@ -683,7 +682,7 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 	if (efd.addr) {
 		efd.dev = &sdev->sdev_gendev;
 
-		enclosure_for_each_device(ses_enclosure_find_by_addr, &efd);
+		ses_enclosure_find_by_addr(edev, &efd);
 	}
 }
 
-- 
2.52.0

