Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBF41F94F
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 22:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783117257; cv=none; b=DavhPqiIatHRg1VhGiuAEa2bcSQmI5Zg12uv66XZc73BE9w723LEs8wGC6Jqs5572BRyTMzhOeyAwlJR0IygK1f91z/dz1SsYnvpJHpLnYC0C3P9Pj7dSg6S2+5tVhh8GobxeXSQ+/xJxT7AvlDEFw/oydHokUrBiT21Uxw30ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783117257; c=relaxed/simple;
	bh=MJ/qh6D/zsDdIiDOfu7SIoCeBVXlf6R7b31cT1FIGdU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tg1h1uBUsf7IAyxOyIj5HGRZP0LmQMBxe0HkSG5l1AjtlbKcZBuK8nk2cwhUfNd686TcAKitjiWX7eZg8dvcDjQGM6wYmlIbLoOPuCtq+ZxIUfJCmvozMiIWqBXrHfCHhZT+bcWE+SQ/4Y+GCStcgILuoqxSOqgBctXW9yZvAFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CkvbjOX1; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CkvbjOX1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783117252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QjnNbXk3O9fzPLCQ/L/wqjlAhAAiHBN/Uo3FaUo9PAw=;
	b=CkvbjOX1sOTozz6Ylnw+lGOAkwiJ8PB8TV0AynpCM9N8t/NX8VviA1uuBmVFObmGtnzrLf
	vWEE8kzna7mY/MV8jMU/JmuoaLiJgGPlM+M7WaDTGHl4BgWOTyCoxXBxF7wQPX6sXRJrNu
	Rzo1JusEe4VFzMNfy1u6Oobh+5GOcvI=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kees Cook <kees@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: csiostor: Use str_plural() in csio_mem_intr_handler()
Date: Sat,  4 Jul 2026 00:17:29 +0200
Message-ID: <20260703221731.180534-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1104; i=thorsten.blum@linux.dev; h=from:subject; bh=MJ/qh6D/zsDdIiDOfu7SIoCeBVXlf6R7b31cT1FIGdU=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkeJr8rqmzPP7KZo/XbcMaXfE6t/ZaGL92uHvnqMUe73 cNa7d7BjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZjI9IWMDN+POR/ln3GxNVsi 8at5QMkbk0u2p69EP1xUvO9EkuzRJj1GhlMGAgHvpxX3sz2MvRMb+ihuku7dVWrJEvdv9V2c2Bd RxgIA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace the manual ternary "s" pluralization with str_plural() to
simplify the code. This also corrects the "0 errors" case.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/csiostor/csio_hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index df9f81f29950..44def5f92b68 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -38,6 +38,7 @@
 #include <linux/stddef.h>
 #include <linux/delay.h>
 #include <linux/string.h>
+#include <linux/string_choices.h>
 #include <linux/compiler.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
@@ -3490,7 +3491,7 @@ static void csio_mem_intr_handler(struct csio_hw *hw, int idx)
 
 		csio_wr_reg32(hw, ECC_CECNT_V(ECC_CECNT_M), cnt_addr);
 		csio_warn(hw, "%u %s correctable ECC data error%s\n",
-			    cnt, name[idx], cnt > 1 ? "s" : "");
+			  cnt, name[idx], str_plural(cnt));
 	}
 	if (v & ECC_UE_INT_CAUSE_F)
 		csio_fatal(hw, "%s uncorrectable ECC data error\n", name[idx]);
