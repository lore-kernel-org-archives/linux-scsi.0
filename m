Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075672D7DCE
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 16:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768236852; cv=none; b=MKEKsWui+9DytBma/31YIXrkvWIB6GpdrgMzAIuRqFJlJ+hq/swhOdVrLzbxdAv93bcIZ0pP1K9pQytsB/GuPDARTLahkQTTZT5Ey+a0/4G1DDjX/OR0HeQWpYXczJTOJv+hrk6pSaGNxOBph2X8NjlOjO3KKHgKLg77/zQMONQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768236852; c=relaxed/simple;
	bh=sOihRZTiSdTh3W2c55Bu+Q8LlJJOhDYFVI/yS6DKboQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9eTcQqWvFJAMrYMMzPz8DkHpyfzFwmEgQR0YymGIT6Ur7h0uUaYcI7aJ8FS57eWZ5m6OKzdq4AZswiigTwmq2etROjryOnKVsRFbJkNntrFqmvXgZTF+St5bkYTINtCXANim3aqI8rysYFFUvDa9U2ag7udxT7/avmt9VxVqqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RPtVLxoj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RPtVLxoj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768236850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q0WUARLoOLwgVa5y6+nXOLB7rMGFoqVYTpB2Sdx3w08=;
	b=RPtVLxojQPuXbjSKSSRVGO/n1kOF7DvpktOcBGUqD95h5IF9/zJFUg9ywZEpYTx3jAXy96
	qMf2zdZHwiTW/o9GwM/8CQBokdT5K3ax0CCOzshmfjRV/m4jcLSb5ksZTjwPIaXTqtg90Y
	kMyI6ycqbsoiRC8WI6/MIfOelr5PFeo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-397-ZR8aou_PP5qJKeJZHs3hUg-1; Mon,
 12 Jan 2026 11:54:06 -0500
X-MC-Unique: ZR8aou_PP5qJKeJZHs3hUg-1
X-Mimecast-MFC-AGG-ID: ZR8aou_PP5qJKeJZHs3hUg_1768236845
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 003261955F01;
	Mon, 12 Jan 2026 16:53:58 +0000 (UTC)
Received: from rocky.redhat.com (unknown [10.44.32.113])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2355B1801A45;
	Mon, 12 Jan 2026 16:53:55 +0000 (UTC)
From: Maurizio Lombardi <mlombard@redhat.com>
To: martin.petersen@oracle.com
Cc: mlombard@bsdbackstore.eu,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	michael.christie@oracle.com
Subject: [PATCH 1/2] scsi: target: iscsi: fix use-after-free in iscsit_dec_conn_usage_count()
Date: Mon, 12 Jan 2026 17:53:51 +0100
Message-ID: <20260112165352.138606-2-mlombard@redhat.com>
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

In iscsit_dec_conn_usage_count(), the function calls complete() while
holding the conn->conn_usage_lock. As soon as complete() is invoked,
the waiter (such as iscsit_close_connection) may wake up and proceed
to free the iscsit_conn structure.

If the waiter frees the memory before the current thread reaches
spin_unlock_bh(), it results in a KASAN slab-use-after-free as the
function attempts to release a lock within the already-freed
connection structure.

Fix this by releasing the spinlock before calling complete().

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reported-by: Zhaojuan Guo <zguo@redhat.com>
---
 drivers/target/iscsi/iscsi_target_util.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 5e6cf34929b5..3319394bf542 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -810,8 +810,11 @@ void iscsit_dec_conn_usage_count(struct iscsit_conn *conn)
 	spin_lock_bh(&conn->conn_usage_lock);
 	conn->conn_usage_count--;
 
-	if (!conn->conn_usage_count && conn->conn_waiting_on_uc)
+	if (!conn->conn_usage_count && conn->conn_waiting_on_uc) {
+		spin_unlock_bh(&conn->conn_usage_lock);
 		complete(&conn->conn_waiting_on_uc_comp);
+		return;
+	}
 
 	spin_unlock_bh(&conn->conn_usage_lock);
 }
-- 
2.47.3

