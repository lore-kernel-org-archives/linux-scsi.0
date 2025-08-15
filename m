Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F96257431
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 21:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755292800; cv=none; b=CY3e4eMGEq2NfmYJ1jQtaiM1GkmSio1/IbGk0MYR6eWXOvPpgFZHlbKlvlPa/LfAmpGvBe4RfORVLlFuK4TzyAXpc183Hux0JwNGZvzuyhfwnM6zxNqR5ePaWy+8FyPWFtulRYfsPd0KXXoru8KAQtiBj4p3rWs6U0/0cvDWELw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755292800; c=relaxed/simple;
	bh=98sAuCFuJ+Oizmz6saInVdEF6IQ6y4P5D1CesQ+PROw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgA/4QGSxJQIiuSN2ywRq7+uxDiypFjUG19Ed8wZDiCtoH6xLovAdJ8XSHcA9OtX0UVcqnl9Z+vhTvcxEGyOPfK3iT8urJZtfdtRwTYnDMoRVldPfLQpdW6MhWAX1GWYNCHw8CyE8GNTBqJLXXyv1RYps+H4Yem1YvNVFC9+vN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fPIZD3x7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fPIZD3x7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755292797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sI5CHEdf+aFpSSMkEaA25jNGCkPHgFNpcfT29HfNTwY=;
	b=fPIZD3x77eFOnqAz1SU1ewQicqX+8TggJFTpn+nsxwJFZc/VY3kB/2JQxFJ850iFmOtyn0
	6Je06ACof6H3gnGqDFstj21Tn35bEC0yKHH97VohwGZgQc1B25369F4PJS8glmHaq+O/O0
	Ed4NOyRtgyhU8YRH1OcZai/OJnkJIWA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-492-7MEmsmAvMxqCrEMr8zobXQ-1; Fri,
 15 Aug 2025 17:15:33 -0400
X-MC-Unique: 7MEmsmAvMxqCrEMr8zobXQ-1
X-Mimecast-MFC-AGG-ID: 7MEmsmAvMxqCrEMr8zobXQ_1755292532
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE5ED1954B13;
	Fri, 15 Aug 2025 21:15:31 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.65.61])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 657A419327C0;
	Fri, 15 Aug 2025 21:15:30 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org,
	dlemoal@kernel.org
Subject: [PATCH v3 2/8] scsi: sd: Explicitly specify .ascq = SCMD_FAILURE_ASCQ_ANY for ASC 0x3a
Date: Fri, 15 Aug 2025 17:15:19 -0400
Message-ID: <20250815211525.1524254-3-emilne@redhat.com>
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

