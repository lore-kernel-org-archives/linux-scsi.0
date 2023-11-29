Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J9uovXUc"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86774D67
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 08:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701274439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FfHwnk3dAJr64E5NmsccUYWsX/gl4ZBhTuLyU5XnOhM=;
	b=J9uovXUcTeuxlJHlZ/GwEouHjay7XRGZ35aKZUajcmvdHdAFx8SnaBRrmaSgma2MQ/UPx6
	bf7RMu/GYV+CBA62Uc4QJQ3xdJNRue85Kp7jv8OZxdvaJWprSmAbRCEoR/1XDn/7wSww8K
	A3G9YNy3GytS64QTcV8ChyKnOluRykM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-411-YsLBblRTP5i1TMiIGcCOnA-1; Wed,
 29 Nov 2023 11:13:56 -0500
X-MC-Unique: YsLBblRTP5i1TMiIGcCOnA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6328280D475;
	Wed, 29 Nov 2023 16:13:55 +0000 (UTC)
Received: from bcodding.csb.redhat.com (unknown [10.22.48.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 527631121309;
	Wed, 29 Nov 2023 16:13:55 +0000 (UTC)
From: Benjamin Coddington <bcodding@redhat.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH] scsi: target: enable READ CAPACITY for PR EARO
Date: Wed, 29 Nov 2023 11:13:54 -0500
Message-ID: <ad095388dbc550c5b199a1dfa71bcbfc575a7abe.1701272679.git.bcodding@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

SBC-4, Table 13 allows READ CAPACITY for all PR types.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
---
 drivers/target/target_core_pr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 49d9167bb263..80b7d85030d0 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -470,6 +470,7 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 	case INQUIRY:
 	case LOG_SENSE:
 	case SERVICE_ACTION_IN_12:
+	case READ_CAPACITY:
 	case REPORT_LUNS:
 	case REQUEST_SENSE:
 	case PERSISTENT_RESERVE_IN:
-- 
2.41.0

