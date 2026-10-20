Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792500668;
	b=xQlWtW9LLKR5Mik55W2NjarL2/n9Jq7l9hIlzCsjeC04T5N9agI80Er2JJg/8WTLvHev
	 ndu5VUxsOWLuuwvgCV2GjsA0VgWgzq9GwjnDwci0lW8zetWAPAVjh6JFnd8mscazy3RrJ
	 7U3hMuUP89zqLfzIxC/SnqDGKiebVTv1oy0z8AalzpkQdlk3X/WCuZfqAzKbf0+6tW5lV
	 psgjcEl4O3SYsSqDsh4nHX6wiRuLSmWNvFqUlwOZ+G4CgeQPH8mCY9rbmcKXGGZMcmjT/
	 Rmz+ba/jIJwaJWWj/2pR3TNj1qnNDXepH10Q20v/DBUWn5o+2OucX4MVwKe2mIhTXJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792500668;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Scanned-By;
	bh=YxottX/ImyknSsFNy+uHufp0WQNNy3hoX9V92370Wdg=;
	b=iXnyGVsxR8f6Jq6HS09TyALtPxcLrIU5RMzPwzSN5hLnMcARcH3lw9sT5ahiN8nTZ7Hf
	 p7gisjL2XEP41S3tZbaauk9yerThxwwYgw0lD2oWxRtocbLfWZGaIihF/5P6lEGIKqzMs
	 NOzURo0qImKFZ0qXJVwphxFKc84wZbJG3JAlUmaCK1cOR0B7VOkY7JBMXqQ5zH3mHQQgF
	 Wlp8rwYuHNe+u8E9qQt8DGAUCQK/xebMomkqgCjE81K82zccCH4l9vnIwfHjFWQD7/AHK
	 MfDuNddxhtRWNgT+s7uNg0EQMT3dYyxnBIMA9IWJpT7uxYsVJnWwtUNBzTpLBPPGrQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="TOqko/Io";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B76606A322
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 12:51:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16B76606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TOqko/Io
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792500667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YxottX/ImyknSsFNy+uHufp0WQNNy3hoX9V92370Wdg=;
	b=TOqko/Io9QtL5PuSvwhBFRDdUrNauqqoc37XG3KqaEbCfIOHn3ABmKy2ijvnG3ie4oQuP6
	gu02j45VACTS9X9ZS29yZqq8ZtbF0uz5qatlTAXlbU12vYw58A7dnNmZ4MH7NvWM0uXXx8
	W5ZUByJ27nNN4ZwUB7BP/+OBj5LZVgM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-696-wnZYHm72PJuDxZ9TrXFQ5w-1; Tue,
 20 Oct 2026 12:51:05 +0000
X-MC-Unique: wnZYHm72PJuDxZ9TrXFQ5w-1
X-Mimecast-MFC-AGG-ID: wnZYHm72PJuDxZ9TrXFQ5w_1792500664
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0EEA61955EAB;
	Tue, 20 Oct 2026 12:51:04 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D48CA1803A51;
	Tue, 20 Oct 2026 12:51:02 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add Laurence Oberman and John Meneghini as SCSI tape driver maintainers
Date: Tue, 20 Oct 2026 08:50:59 -0400
Message-ID: <20261020125059.1797559-1-loberman@redhat.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

The SCSI tape driver (st) is currently marked as orphaned. Add
Laurence Oberman and John Meneghini as co-maintainers and change the
status to Maintained.

Also add a link to the tape_tests repository, which contains the test
suite used to validate the st driver.

Kai Mäkisara, the previous maintainer, has agreed to this change.

Cc: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Signed-off-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
---
 MAINTAINERS | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4ad924aeaf16..10bde5d86026 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24576,8 +24576,11 @@ F:	include/uapi/scsi/
 F:	include/ufs/
 
 SCSI TAPE DRIVER
+M:	Laurence Oberman <loberman@redhat.com>
+M:	John Meneghini <jmeneghi@redhat.com>
 L:	linux-scsi@vger.kernel.org
-S:	Orphan
+S:	Maintained
+W:	https://github.com/johnmeneghini/tape_tests
 F:	Documentation/scsi/st.rst
 F:	drivers/scsi/st.*
 F:	drivers/scsi/st_*.h
-- 
2.56.0

