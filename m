Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B292231826
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2025 21:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752096276; cv=none; b=UtkQmJUhtsKlfBr3ehbQ0OWUSBzEkcjaIYIFBDp7e/8zNn3KrGrTShAZmAJIk+MQ9Fk+vUzjsqrifjhNoVa3KYS5+wN+PWQ6LTlnQfwR7i7TIw9E5UQ+uMcLvz5ckg2hhYpFl0PhW/6skvTVLPGyxWU2kUKN+GgRexaRbyVlcyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752096276; c=relaxed/simple;
	bh=py57+ep1YA7hjrdIwCahBwxZ03rdprtK6EbPayyT3Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjehJwRvj9Si30cs5Ro44TvLGM0qn7Mv+meA6KCdWg9bV0ACWAjH4OnrZEADyagikAoqv6xGPuR5K5Y0xiclZbdC0hLFNuj6DLIEH16h4ZCPDusgMPSP5Fwj27bsphoJS58pFnuiLAQx1QeHWg3f9adGds+vDQjyb0m7Zv8vS30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IDwbFrWQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IDwbFrWQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752096273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Pz8FWKpJsdd6RLc/Th77/Cg2FldKi1xIHR2uJ0kz4E=;
	b=IDwbFrWQw4LMixaiBT3TlUlzkVLqQPie8yYQzxVqAUAgsJ7gapiWn5OyRqLqjEIAPtKWK4
	VXs1kHLIXL+i4QcX4HML1e6wI2SndT9Zkk8W8/Vccknnmw3+r+gYXRvef8FohRYQYcN/Ym
	sdfbpO7GfeqZQy+FqfX0qjMWKpuwX/I=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-131-4_cqwEddMjSQH1Qt2Tcdtg-1; Wed,
 09 Jul 2025 17:24:30 -0400
X-MC-Unique: 4_cqwEddMjSQH1Qt2Tcdtg-1
X-Mimecast-MFC-AGG-ID: 4_cqwEddMjSQH1Qt2Tcdtg_1752096268
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7A3B1956061;
	Wed,  9 Jul 2025 21:24:28 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.44.33.49])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50DE719560AD;
	Wed,  9 Jul 2025 21:24:22 +0000 (UTC)
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
Subject: [PATCH v8 7/8] nvme: sysfs: emit the marginal path state in show_state()
Date: Wed,  9 Jul 2025 17:19:18 -0400
Message-ID: <20250709211919.49100-8-bgurney@redhat.com>
In-Reply-To: <20250709211919.49100-1-bgurney@redhat.com>
References: <20250709211919.49100-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

If a controller has received a link integrity or congestion event, and
has the NVME_CTRL_MARGINAL flag set, emit "marginal" in the state
instead of "live", to identify the marginal paths.

Co-developed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Tested-by: Muneendra Kumar <muneendra.kumar@broadcom.com>
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
2.50.0

