Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E01D30C63A
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768236855; cv=none; b=ltE0tqem15XYAOXN5g1jKwvxOUY99bm8H94UShC2m7VvaWGG7O03krEqAeE72wGnzXF8gnmlXCza2btBj9fgacjfwxieN2GcElIASSrsXbFmk6yifJdJLpzG6WLC5UVm6jUdXBWTNWbi0pRmH4Wb5Sc71CupV+r3jdHDxjzWq8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768236855; c=relaxed/simple;
	bh=jnv4YR+HC37D29MSOAo5YJFPOx4HrYc1sxgSZsjrvlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRrqFon5RYYeHvWpcq4mIDM9gkZr85ffhI1iDutPsDF9RbYu2FmTsTNkEF0sVeSZMkgpg1y0mS4ed4ms+yitiy+UuoFCJY1MYHR4+bnAGm05o7m/WNoFiMNDhzLfVvwhNb/241/IiazbU5oIqh0ZaFFxMVRuX637PkXh+B1+XA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ajkDJksV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ajkDJksV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768236853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ggzmW4a7rbC/ZilVgU58X2oEV4Qpt19xaRP76gpfoow=;
	b=ajkDJksVwfwCM94PxXOzKwYivWFGIk9PiYcq7eVX5a9rbP5esyJONrxMHgCjGjR+UCpg5B
	74vob5vcuLNdbmVA5LZgTb/20U+YXabMLihP38lwIa/hDSvfJiFhrsi/y3IWF+AecyKkiG
	ntkrHfZflaluV50pFzewQJeQBmcTVMY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-SClEgqJ8MimdVBwl49Q2qQ-1; Mon,
 12 Jan 2026 11:54:09 -0500
X-MC-Unique: SClEgqJ8MimdVBwl49Q2qQ-1
X-Mimecast-MFC-AGG-ID: SClEgqJ8MimdVBwl49Q2qQ_1768236848
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3576218301CF;
	Mon, 12 Jan 2026 16:54:00 +0000 (UTC)
Received: from rocky.redhat.com (unknown [10.44.32.113])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 72A721800577;
	Mon, 12 Jan 2026 16:53:58 +0000 (UTC)
From: Maurizio Lombardi <mlombard@redhat.com>
To: martin.petersen@oracle.com
Cc: mlombard@bsdbackstore.eu,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	michael.christie@oracle.com
Subject: [PATCH 2/2] scsi: target: iscsi: fix use-after-free in iscsit_dec_session_usage_count()
Date: Mon, 12 Jan 2026 17:53:52 +0100
Message-ID: <20260112165352.138606-3-mlombard@redhat.com>
In-Reply-To: <20260112165352.138606-1-mlombard@redhat.com>
References: <20260112165352.138606-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

In iscsit_dec_session_usage_count(), the function calls complete() while
holding the sess->session_usage_lock. Similar to the connection usage
count logic, the waiter signaled by complete() (e.g., in the session
release path) may wake up and free the iscsit_session
structure immediately.

This creates a race condition where the current thread may attempt to
execute spin_unlock_bh() on a session structure that has already been
deallocated, resulting in a KASAN slab-use-after-free.

To resolve this, release the session_usage_lock before calling complete()
to ensure all dereferences of the sess pointer are finished before the
waiter is allowed to proceed with deallocation.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reported-by: Zhaojuan Guo <zguo@redhat.com>
---
 drivers/target/iscsi/iscsi_target_util.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 3319394bf542..c1888c42afdd 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -741,8 +741,11 @@ void iscsit_dec_session_usage_count(struct iscsit_session *sess)
 	spin_lock_bh(&sess->session_usage_lock);
 	sess->session_usage_count--;
 
-	if (!sess->session_usage_count && sess->session_waiting_on_uc)
+	if (!sess->session_usage_count && sess->session_waiting_on_uc) {
+		spin_unlock_bh(&sess->session_usage_lock);
 		complete(&sess->session_waiting_on_uc_comp);
+		return;
+	}
 
 	spin_unlock_bh(&sess->session_usage_lock);
 }
-- 
2.47.3

