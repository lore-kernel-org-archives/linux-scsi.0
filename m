Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B162A1DC075
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2025 17:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750442323; cv=none; b=kI83SBdkzpyV+T3HBH2eaxrzdswH41ETaKXJnKJ6THQjXo2+sPEtlU/XrypK1ygDtW/snYpNMLtr2AQz6Bus1KtPGjGzz1mEM0KmQazDrPYNs10EvSd9t2SnRMZVWFKZQfJbPN67m5T5+maucVILVm89d9A4dgRiaSTZ6vjlogI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750442323; c=relaxed/simple;
	bh=7JGG5Ra6P+MHivZF+gkcePKLQw/1YXUotrRQoGbnWYc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l+LIORnw9P2mcVX41e5YbkanG42EcLnZSgMCd7c0vN2TIbXui78GJvvhrg+afV4tmsl1wVpotdtarWTsUKg/DoheocbRQjY0PBArTYoxZeMzyCAEWdGUhFzNKlOnLTaHZvdgLPc6Xl/M4umIJvSkkdHGBXm+lbiIhvPmHP0mVzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S19Zvf7P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S19Zvf7P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750442320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0zaFqRg/iXhIUEsepKOph+hj22aPgLsPlwmKc03n2to=;
	b=S19Zvf7P58Ua2jPBm3nrg6XWbTIM4M9hYls7j/bAQWBwQBigwqFY2UJx/filpiZWAzpoiO
	5LrJv06hvoCPSk2Lv9JKMCs09TFrE9GaNzxqksjeFjKMOLMVvdiMkF95vR+inajWPtIuTN
	ghwRyCeLggyF6dLRsOZB8434j0URAyk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-527-8yblL3FUMUKQ_GqT8V14dw-1; Fri,
 20 Jun 2025 13:58:37 -0400
X-MC-Unique: 8yblL3FUMUKQ_GqT8V14dw-1
X-Mimecast-MFC-AGG-ID: 8yblL3FUMUKQ_GqT8V14dw_1750442315
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCDF11800289;
	Fri, 20 Jun 2025 17:58:35 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.22.80.187])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF623180035E;
	Fri, 20 Jun 2025 17:58:32 +0000 (UTC)
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
Subject: [PATCH v6 6/6] nvme: sysfs: emit the marginal path state in show_state()
Date: Fri, 20 Jun 2025 13:58:20 -0400
Message-ID: <20250620175820.34795-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

If a controller has received a link integrity or congestion event, and
has the NVME_CTRL_MARGINAL flag set, emit "marginal" in the state
instead of "live", to identify the marginal paths.

Co-developed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
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

