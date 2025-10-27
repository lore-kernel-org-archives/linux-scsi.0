Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74332218EB1
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 18:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590824; cv=none; b=X1quki4UjNieGiwK3Hl5Q/drru2MyWNQH4QY/63SZSq630IiCPg7Rk6gx/4jGc01edhlLplRy8YKQh6stTp9ie5o8Yy6etvpLTBo+WCic8Aryy3Ssff1wLyPlfXU/FyVK3bEY5csSHuNWSL4fCjQDaxqaR0+xnhUlF0CSa7MtXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590824; c=relaxed/simple;
	bh=TfMmZnj2RwCooQu3QXgnkZ8FTUoWRKtts5xhCslkJ2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJ7A2Dd1qAAwRyBIu+6izuK03ot8vAwC61h+08dIDFg/d9BVKxiH6CAuOhNJ6zgprEcXLK2lWAzEoP5zc8XySVnXnLekimLVCYTNipzpUckVF38hifCQopHmNs74+mbaYQQyhY6elod+CbjIR2vOz8gxOrVelBvaVhYjCCnSvj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HnMX979x; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HnMX979x"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cwMtV0HTJzlfnBn;
	Mon, 27 Oct 2025 18:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761590816; x=1764182817; bh=03uH5
	dXIL5DXsdHJsf4do+be8cgo4HSh1Dz8I1j+mRM=; b=HnMX979xO6q0ypFPX1rfW
	XlF8qeuxb30WTFwUmcPchAMYl7rJktw2QF9pKVj6lkPz82EY/0bXCacQAh7HV5Bv
	T8jAKaDf3sSPl9l8iw81dvepqHpi+XsAL+IIfR8d70wF70+MQZ9Dx0UNDLSl0dR+
	LgbJR7VQfpeo1kCiJ8fb7VTZFP4XurEvPdoyy/kLzL075RO0+wWZceTZhikza7pr
	2pVYbJpM4/s+XuIuvCs3+LrPXESZ9yrrdoL/FqtZMx9QAnwXWyK8sNzf6BxlAgJO
	JSvJW+so5/V0d6nb+oJa/RIFcIzVErba0ycQEMEfqZgpq0oAWm7A2B+ozKfTYfKN
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fsE8IVYmGqNN; Mon, 27 Oct 2025 18:46:56 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cwMtQ3VSrzlgrtT;
	Mon, 27 Oct 2025 18:46:53 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 1/2] scsi: target: Do not write NUL characters into ASCII configfs output
Date: Mon, 27 Oct 2025 11:46:38 -0700
Message-ID: <20251027184639.3501254-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.838.g19442a804e-goog
In-Reply-To: <20251027184639.3501254-1-bvanassche@acm.org>
References: <20251027184639.3501254-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

NUL characters are not allowed in ASCII configfs output. Hence this patch=
.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_configfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targe=
t_core_configfs.c
index b19acd662726..1bd28482e7cb 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2772,7 +2772,6 @@ static ssize_t target_lu_gp_members_show(struct con=
fig_item *item, char *page)
 		cur_len =3D snprintf(buf, LU_GROUP_NAME_BUF, "%s/%s\n",
 			config_item_name(&hba->hba_group.cg_item),
 			config_item_name(&dev->dev_group.cg_item));
-		cur_len++; /* Extra byte for NULL terminator */
=20
 		if ((cur_len + len) > PAGE_SIZE || cur_len > LU_GROUP_NAME_BUF) {
 			pr_warn("Ran out of lu_gp_show_attr"
