Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6167D347FD7
	for <linux-scsi@vger.kernel.org>; Wed,  1 Apr 2026 20:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775075127; cv=none; b=iYE9BQ7hMTIkcuvClBBfUioCkhJd4WRHVe0glfcSyiAcQH54yTuRS+PliOXWdG9bRQrMbQ5ts+cGyWyLm1Bmtx/RboHWBGrwwaNw3uw28WtCI+9lN4VZYkrno0p9BxjXJtqjLAZdZ+jZa5hdNt/uqkEy9VWgg9uXas6qlgsqwqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775075127; c=relaxed/simple;
	bh=ser4ilFxJF0g9QQS5nuM3NMiMHJnJ0lQKDA1IwaOaE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTnfNUwBBDDJNNpGx1bkI9K6OqzdD+1JP2Octgf5Pu6yW0C55bGrh8wYqJOQHyJK+g5DS4DHCK49bek1UpnaQIpDWy4mALYIgoQ1IuDQq7NV9i0ZKk9272cHYqgzKAfITEGcVVXDCFq0j3d01Uqq6KLUTGPoIR26HWPnO1lNDv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YSobZrkT; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YSobZrkT"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fmGh56yQMz1XM6JH;
	Wed,  1 Apr 2026 20:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1775075123; x=1777667124; bh=ser4i
	lFxJF0g9QQS5nuM3NMiMHJnJ0lQKDA1IwaOaE4=; b=YSobZrkTVys54+I/AvNFO
	aKhzGQeUgvpvuI9K3MpslGlDoiQugqIqfQJH0+Oig6UU6WNlbjbfL6GepLq+0p4z
	HQirsoY0aL3gAaUxSX2khgOlkQ9KwdOJCHPzN4aHiX59QWYHqaxNJspKlPb3cznB
	w+N5WYeDRDzP0/tJAaOqXKSddTh1G3N4tZPTmU2QIc83qkdz6U+giG2kAbj1GlYO
	hkY0fiZxzANqdoTpWGEQV20EKbUqkXNQclEJu5ZuP/rhag4jtJqPUIfe7D026gGw
	yH2PhFvoQvkn0eN4Gn8jBh4d4w7O18J/C2BkWP24/UNTwhhI9n8FqNBH3WXftB99
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pCu0mobF5cO2; Wed,  1 Apr 2026 20:25:23 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fmGh25ctRz1XM31H;
	Wed,  1 Apr 2026 20:25:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/3] ufs: core: Remove an include directive from ufshcd-crypto.h
Date: Wed,  1 Apr 2026 13:25:00 -0700
Message-ID: <20260401202506.1445324-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.1185.g05d4b7b318-goog
In-Reply-To: <20260401202506.1445324-1-bvanassche@acm.org>
References: <20260401202506.1445324-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Nothing in the ufshcd-crypto.h header file depends on the ufshcd-priv.h
header file. Hence, stop including that header file. This include
directive was introduced by commit 4bc26113c603 ("scsi: ufs: Split the
ufshcd.h header file").

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd-crypto.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd-crypto.h b/drivers/ufs/core/ufshcd-c=
rypto.h
index c148a5194378..8f66db94e179 100644
--- a/drivers/ufs/core/ufshcd-crypto.h
+++ b/drivers/ufs/core/ufshcd-crypto.h
@@ -8,7 +8,6 @@
=20
 #include <scsi/scsi_cmnd.h>
 #include <ufs/ufshcd.h>
-#include "ufshcd-priv.h"
 #include <ufs/ufshci.h>
=20
 #ifdef CONFIG_SCSI_UFS_CRYPTO
