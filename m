Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC1529AAF0
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 20:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750796689; cv=none; b=Qxn4mxMHt5rS0GhnGyR9YG7Z+mtBB0Lv3ATCa7lmCSpCFWetyuImjbxiq6OTRQJoajCBi+7tKL+X5HeLRFmxFWHqZ5mG5IRZEmo4HANvW+wjfUlsdawDP+/gZEAsrzqcerikEgBVO5Qmf2wexClT/WBjp0tiP5eFHYFOGghLI0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750796689; c=relaxed/simple;
	bh=V34mUKhsTpjWX6qRFxxtIjUh7eko+JMQyNK9hl9N8YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnw1boKmppa355sZf1yJWYSEQ8AjopIyQGdiYus5mhu9hPHmFPoLZMS04jqI+KRTkczp1nt3v0v/WkZFMYR0Y+Xezv3bJP3MYySMqbYq2OYsgB1dXG904UnN69ZNe9MAUKQr9+PzQSPrHb/s+Us2LaZwUHi/DeTNXuq0fLXJqcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bUWXzPys; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bUWXzPys"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750796683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mJF24feMQXxiRuDZgUDBqcA2bVPP7UeSX00J+hPtylU=;
	b=bUWXzPysvWj2xJlXjjjpf/pi3wpzC7jJXFuRaS1SEPXNncq+eqvbDaA+tCa1bWKlEqLaT4
	k30Lt7hcyMkJXvrfDxq7xO9hWXnT0aGM68TZNxSpERZR1SyaFtr6HIa2odcubWaj2j3gSw
	JuOsKdOQgl2d20wd08+TFII/j0JPmPc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-14-jg1vbO1BPTmPJiLycoEfug-1; Tue,
 24 Jun 2025 16:24:38 -0400
X-MC-Unique: jg1vbO1BPTmPJiLycoEfug-1
X-Mimecast-MFC-AGG-ID: jg1vbO1BPTmPJiLycoEfug_1750796677
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16E1019560A3;
	Tue, 24 Jun 2025 20:24:37 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.45.226.95])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67B0E195608D;
	Tue, 24 Jun 2025 20:24:31 +0000 (UTC)
From: Bryan Gurney <bgurney@redhat.com>
To: linux-nvme@lists.infradead.org,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	axboe@kernel.dk
Cc: james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	njavali@marvell.com,
	linux-scsi@vger.kernel.org,
	hare@suse.de,
	bgurney@redhat.com,
	jmeneghi@redhat.com
Subject: [PATCH v7 6/6] nvme: sysfs: emit the marginal path state in show_state()
Date: Tue, 24 Jun 2025 16:20:20 -0400
Message-ID: <20250624202020.42612-7-bgurney@redhat.com>
In-Reply-To: <20250624202020.42612-1-bgurney@redhat.com>
References: <20250624202020.42612-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

If a controller has received a link integrity or congestion event, and
has the NVME_CTRL_MARGINAL flag set, emit "marginal" in the state
instead of "live", to identify the marginal paths.

Co-developed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
 drivers/nvme/host/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/sysfs.c b/drivers/nvme/host/sysfs.c
index 29430949ce2f..4a6135c2f9cb 100644
--- a/drivers/nvme/host/sysfs.c
+++ b/drivers/nvme/host/sysfs.c
@@ -430,7 +430,9 @@ static ssize_t nvme_sysfs_show_state(struct device *dev,
 	};
 
 	if (state < ARRAY_SIZE(state_name) && state_name[state])
-		return sysfs_emit(buf, "%s\n", state_name[state]);
+		return sysfs_emit(buf, "%s\n",
+			(nvme_ctrl_is_marginal(ctrl)) ? "marginal" :
+			state_name[state]);
 
 	return sysfs_emit(buf, "unknown state\n");
 }
-- 
2.49.0

