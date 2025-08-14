Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D32322DFA5
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 18:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755196159; cv=none; b=Q+ojxc+IjTnlAywOsIlUds6GELUo4d3M88dValfziSsUKU2RU/p1vgJNLUtE8w3xVL9372sst2+HKQtTvAFJqfUOnJpCk8M5ShMuF3L0rNjDH9KjgKy6nngGMBvXJcIIznVD8hFwiWDpwsE6sKPfB/iUMW4B3iqJd3f633L/Cjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755196159; c=relaxed/simple;
	bh=98sAuCFuJ+Oizmz6saInVdEF6IQ6y4P5D1CesQ+PROw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7fWNsYIIfE4IQb5vwmVDs+0nYhXR5tIx7ATYdKDC5J2moOmovhacCoO9K2px0CprOCETrKpqOuEdJBPGQzl9Al4Jf9Klr6WBscQbhrXo6XaERQEV8JqM7de0dRqs3xVNV0elNlGSDuyDZqaYDlpoDK2f7vujc1wX3cRFWM93qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O2qHfTqC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O2qHfTqC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755196156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sI5CHEdf+aFpSSMkEaA25jNGCkPHgFNpcfT29HfNTwY=;
	b=O2qHfTqC+fK4YZxOLuXKuQzLEkFJ4vAAZwuHkz+NOvcfoSOiQRT5APJRWknAQAsBxFD1Cb
	ihaYr7BtbYgufy/CKgss+r15ftqj6zgKpF5dZpALJol9AwY7jcflAIZbltZLXZMF2LFN/W
	K/mVJHPAnsYj7ZGjwK0wfZUo/1ONYCE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-169-Ax7UrdDoOFSKJ9fiz8KQrg-1; Thu,
 14 Aug 2025 14:29:14 -0400
X-MC-Unique: Ax7UrdDoOFSKJ9fiz8KQrg-1
X-Mimecast-MFC-AGG-ID: Ax7UrdDoOFSKJ9fiz8KQrg_1755196153
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0756B1955D78;
	Thu, 14 Aug 2025 18:29:13 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.65.61])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F0261180044F;
	Thu, 14 Aug 2025 18:29:11 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org
Subject: [PATCH v2 2/9] scsi: sd: Explicitly specify .ascq = SCMD_FAILURE_ASCQ_ANY for ASC 0x3a
Date: Thu, 14 Aug 2025 14:29:00 -0400
Message-ID: <20250814182907.1501213-3-emilne@redhat.com>
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

This makes the handling in read_capacity_10() consistent with other
cases, e.g. sd_spinup_disk().  Omitting .ascq in scsi_failure did not
result in wildcard matching, it only handled ASCQ 0x00.  This patch
changes the retry behavior, we no longer retry 3 times on ASC 0x3a
if a nonzero ASCQ is ever returned.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 78f5903cc8d0..e3b802b26f0e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2729,11 +2729,13 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		{
 			.sense = UNIT_ATTENTION,
 			.asc = 0x3A,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			.sense = NOT_READY,
 			.asc = 0x3A,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		 /* Device reset might occur several times so retry a lot */
-- 
2.47.1

