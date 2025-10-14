Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C9430171D
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760472137; cv=none; b=m6DYKq81pVWYr+mGmxYSRtqL81VF/FyyUuQ58/LAVl/XyRiStVyxXmJLFU2R0OcfuiEsgl6l2K73jDQJNSQaBPmLlM7EcUk0j1rWB/X2Ddgx+nOf5YHMExMpuo/pY5eGoYk3gfXDTKg/mf1Pj0/Nkp6SFhQID9zE/iYSHajy9uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760472137; c=relaxed/simple;
	bh=KScJ45H1R7+LKfmCdLJJB9jHrOKG4/fpcolCIn3XLUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fREt8LVkUveRbjiJ3WLbVFecmRG6vd9bmaeZwR2V/8nl+c4OA65hFVH2bB24XH5XfUJXjE+mJ8UdFhhvMoMlzTqn+3e1nilQsA7JL7+eLWOgPkYfgnvOrD+M/0Lt/PSLpwvKAcbwkGnOHf0CM9dWrl106+JehRLegjtrhvbs5ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aY7j4EsD; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aY7j4EsD"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cmQ9L38V3zlgqyf;
	Tue, 14 Oct 2025 20:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760472133; x=1763064134; bh=JBHHi
	oEph189Y5in2F7M2BGsCb2j8DsWjCdjV6LW9xM=; b=aY7j4EsD3dU5d5FCrl36x
	02jieYrlbU3xCTmmGAI8t25xpXb35HA2y6XI8+fwr4B+pMNNfIOxsP1hyc5RHjAT
	10pQY53yNd+VD2AxZ4nFKl9lG1w0W4A24z95nW/bbCwM0S89ajv+6huKyByhdH5n
	UFyroOtkHqE3DqcPwhVZUFbrWV3kgi0YP6rl9lxc4nTCTdK5QcSg6BqZJsaPKxgY
	j60b+G3+63oVSzDLZCvHUoJXKhGVaY6yzP6o8P3bwLOz/kNDP/m4vh/JAtJ5JOAU
	Rz9HFuyo7VZQRUp5Syfr0RTwjfnfdg+yAY2X5kF8KsLFvmf5ZRwh2Wjo6ETGYUWk
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id E619DBvGgO3l; Tue, 14 Oct 2025 20:02:13 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQ9C4bRJzlgqyn;
	Tue, 14 Oct 2025 20:02:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	Hoyoung Seo <hy50.seo@samsung.com>
Subject: [PATCH 3/8] ufs: core: Improve documentation in include/ufs/ufshci.h
Date: Tue, 14 Oct 2025 13:00:55 -0700
Message-ID: <20251014200118.3390839-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014200118.3390839-1-bvanassche@acm.org>
References: <20251014200118.3390839-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Make it easier to find the sections in the UFSHCI standard where these
constants come from.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/ufs/ufshci.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index e64b70132101..ff96056b2ac3 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -83,12 +83,14 @@ enum {
 };
=20
 enum {
+	/* Submission Queue (SQ) Configuration Registers */
 	REG_SQATTR		=3D 0x0,
 	REG_SQLBA		=3D 0x4,
 	REG_SQUBA		=3D 0x8,
 	REG_SQDAO		=3D 0xC,
 	REG_SQISAO		=3D 0x10,
=20
+	/* Completion Queue (CQ) Configuration Registers */
 	REG_CQATTR		=3D 0x20,
 	REG_CQLBA		=3D 0x24,
 	REG_CQUBA		=3D 0x28,
@@ -96,6 +98,7 @@ enum {
 	REG_CQISAO		=3D 0x30,
 };
=20
+/* Operation and Runtime Registers - Submission Queues and Completion Qu=
eues */
 enum {
 	REG_SQHP		=3D 0x0,
 	REG_SQTP		=3D 0x4,
