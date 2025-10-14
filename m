Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32CA30171D
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760472166; cv=none; b=bW3H7GNw5fJZE7680ZW7kqHGfviqW1BD5CHne/5er8gmFZ03WT6QWdGkdPLIfpDsg16IptPWpla3nA3HtysxMOEZn0EmLbSrHHHiYE9Bz+zpXrwfUsDFZDBmdMfIGtvkWYhwaLtoYP297pODFgQn3Afs85iG2HcKAxU2GWzMp/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760472166; c=relaxed/simple;
	bh=+kZjbrWMupmqHhmSsDG74E7/DfQYu1QJzFlYT5XwlQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1T/s/w4wzpHX02o7Hh+rGza61Oz5dLrihwDTPypQ/u8kEA8XbL6UjwcD9fvoshqXwTQTVuibQIUMFenH+dGJpIfk6/9rzp5Vu+4eBDWDlRWESTXR6t7o/YNpMGd8+xQ/HqfRetbecGqoQAVKHlyKvgLm9LyaVCo42Ua8kfcSnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=p8iuPg16; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="p8iuPg16"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cmQ9v6yC9zlgqVm;
	Tue, 14 Oct 2025 20:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760472162; x=1763064163; bh=MJGgo
	wvPZ6ZKsv5KfKdH91kTpOcLlMCNapk9YsbEuMA=; b=p8iuPg16nYlhj9+3l/AmL
	HETaqz1SM8KMmkOKYAHc5NI77FfkQF44GQMV/Tlmr8EMlI09VMgBFfvFoZNlAepk
	zhL91mjgFHOGa8+DyBugl+zBQcMcxaOnEC9aczDNovfqMwuvQBMTzM31Y1zPVf7J
	5oPszEWq8EM2/xnovuX4HfMhQA0QjnRCYEIaJiaA/RjfXM1vc8G/91s6+0ZVVaHo
	d8BSwCog7TYcsg0g3Y+ykw/e9N2kQFO0xb/G/YLYhYXFS7/rg5wgwbY1csF0spq6
	ojb/eE0iOnSjSLXOuVvr071sDmJGuJkaxYJ+QIvaox6Ncvjj5DumE1lDnKXpkeg1
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id b9V4Zh6qcuxa; Tue, 14 Oct 2025 20:02:42 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQ9n5gszzlgqyY;
	Tue, 14 Oct 2025 20:02:36 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>
Subject: [PATCH 5/8] ufs: core: Remove UFS_DEV_COMP
Date: Tue, 14 Oct 2025 13:00:57 -0700
Message-ID: <20251014200118.3390839-6-bvanassche@acm.org>
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

Remove the UFS_DEV_COMP constant because it is not used.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs_trace.h       | 1 -
 drivers/ufs/core/ufs_trace_types.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/ufs/core/ufs_trace.h b/drivers/ufs/core/ufs_trace.h
index 584c2b5c6ad9..309ae51b4906 100644
--- a/drivers/ufs/core/ufs_trace.h
+++ b/drivers/ufs/core/ufs_trace.h
@@ -42,7 +42,6 @@
 #define UFS_CMD_TRACE_STRINGS					\
 	EM(UFS_CMD_SEND,	"send_req")			\
 	EM(UFS_CMD_COMP,	"complete_rsp")			\
-	EM(UFS_DEV_COMP,	"dev_complete")			\
 	EM(UFS_QUERY_SEND,	"query_send")			\
 	EM(UFS_QUERY_COMP,	"query_complete")		\
 	EM(UFS_QUERY_ERR,	"query_complete_err")		\
diff --git a/drivers/ufs/core/ufs_trace_types.h b/drivers/ufs/core/ufs_tr=
ace_types.h
index f2d5ad1d92b9..bf821970f092 100644
--- a/drivers/ufs/core/ufs_trace_types.h
+++ b/drivers/ufs/core/ufs_trace_types.h
@@ -5,7 +5,6 @@
 enum ufs_trace_str_t {
 	UFS_CMD_SEND,
 	UFS_CMD_COMP,
-	UFS_DEV_COMP,
 	UFS_QUERY_SEND,
 	UFS_QUERY_COMP,
 	UFS_QUERY_ERR,
