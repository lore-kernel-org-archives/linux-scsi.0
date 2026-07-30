Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6319D3DD51C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451687; cv=none; b=u+Wfj5/XpTRbKJyH75djJwamHoS7zlZLaKe8//Zf1zy1ij51SKaOJZvLgE52mNAs0J3ekVQ7WoBze7kZ9okjOw01IJEYDdIhmzeAT1ZbqVuc4NYTJgOlI9eXThPjMvWxzfDxIm7FRgbFMi0A6931IQcIGAswaNj+X/LpdDbGNoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451687; c=relaxed/simple;
	bh=B7a3aLhKXLGOrB+jS153LnWbyEkz/zg5oUxSiOhylcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlgxTWF5vAIx45mv4NUIr1ZHAz5JEnk8DDIejTFs/7mgq02juicO8ko4o6ZcsHHyVLAtyvoDpl1FLZgZXykzom2JvzmANBx9jSN4ZWJlstMNKft3HUGXObTL4BSxsfnQlBkOtB7Px95kDE9KB/A0U8ONcJhWd5pG1uKbrhMZEag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LZrPyso/; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LZrPyso/"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB49K6SG6z1XM30r;
	Thu, 30 Jul 2026 22:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451683; x=1788043684; bh=B7a3a
	LhKXLGOrB+jS153LnWbyEkz/zg5oUxSiOhylcQ=; b=LZrPyso/fyPl6/5GMbVfR
	Gv0CLmZ9cG9Kdd8QTiQvD7ZPjzAL1+mqSYjNosFq7Zh/ySOmdzPv4VGRRUB8oFmy
	/t+OHMhTSVnQ+WIhn12xBUbqKU7eK8EHpa3jBXORhTT8YVKdxsXq5FtclV/SIsgI
	PK/aCnAeQMYxvnOcsB3NKa0tqVsoA2qbOydgv7b7YWFaQCi3iEfw7NrexL2RuI5e
	xRM85M1nufg/hzDnCplIwQ1d7Cro6uRNPsWniTSdueX2tRvnaz3zluJ7eXuSDJqR
	52Ep2ZYSxbW5bdy3oEzDe79yUAjIm4alLe6LcMQYnIzcV/Xgx7K1vjLRVChflc0w
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id h3DbV_WYl7Gx; Thu, 30 Jul 2026 22:48:03 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB49G00lBz1XM6Jk;
	Thu, 30 Jul 2026 22:48:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 25/57] scsi: fcoe: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:08 -0700
Message-ID: <8a5f3eb67ec9d2c31dea01344e3f2de3b8e24b81.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fcoe/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/fcoe/Makefile b/drivers/scsi/fcoe/Makefile
index 1183e80a09e7..5e7121231801 100644
--- a/drivers/scsi/fcoe/Makefile
+++ b/drivers/scsi/fcoe/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_FCOE) +=3D fcoe.o
 obj-$(CONFIG_LIBFCOE) +=3D libfcoe.o
=20
