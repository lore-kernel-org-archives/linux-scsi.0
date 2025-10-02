Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBEC27B34F
	for <linux-scsi@vger.kernel.org>; Thu,  2 Oct 2025 19:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759433122; cv=none; b=qULeFuiIg8sPm+uYZgg2qp+gs/03I7jhdWhfFtvQ0K/0V69MuZKtRr6sEPueLv0RXd1RJwNeHdOwqTzLgUSp9HrBvlfKQlbCyUW2R0jbjwmoW/8Eaapnh/w2dZ52QB9MfAGOeHMGq0THgw3rD1wAKUs/pHy7ayWr/Grdu9WOCQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759433122; c=relaxed/simple;
	bh=98sAuCFuJ+Oizmz6saInVdEF6IQ6y4P5D1CesQ+PROw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2kTQlssqhK0MeeTkwu6CCc3yc5Z3beCr7fzwSRAjV8+ySySfel3cmLpcRmypYPd1fWQfmLKDMwgvAhn3ylts5IS7QH04A36JGFhS253IDqxaG+IdpBMLPoQSIwQ85qW/Pokon/lsuUjF1wPBGdhL1CHXy/eWLyOQT4+/huaxoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JikuTcb0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JikuTcb0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759433119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sI5CHEdf+aFpSSMkEaA25jNGCkPHgFNpcfT29HfNTwY=;
	b=JikuTcb0UmS36VoDIH3HjuHr9yZL/8UI1XZT1v5DTInftpiLbLJfCrSGbtIUbqjXGfg8fq
	US4q8nUfwUWpsZADBwVIMkO0r/GVrYP/bcjoSluWda2+b5CfiBZnRSFDomoWqSvaK49FKa
	Fz+Y/+WAer23If8j3N39sRyWqXiOCVA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-I8x86I8CMbCJbVi0qIhXww-1; Thu,
 02 Oct 2025 15:25:17 -0400
X-MC-Unique: I8x86I8CMbCJbVi0qIhXww-1
X-Mimecast-MFC-AGG-ID: I8x86I8CMbCJbVi0qIhXww_1759433116
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 19C041956050;
	Thu,  2 Oct 2025 19:25:16 +0000 (UTC)
Received: from emilne-na.ibmlowe.csb (unknown [10.17.17.93])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C3236195419F;
	Thu,  2 Oct 2025 19:25:14 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	hare@suse.de
Subject: [PATCH v4 2/9] scsi: sd: Do not retry ASC 0x3a in read_capacity_10() with any ASCQ
Date: Thu,  2 Oct 2025 15:25:03 -0400
Message-ID: <20251002192510.1922731-3-emilne@redhat.com>
In-Reply-To: <20251002192510.1922731-1-emilne@redhat.com>
References: <20251002192510.1922731-1-emilne@redhat.com>
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

