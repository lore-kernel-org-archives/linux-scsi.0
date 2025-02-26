Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6B8221DAE
	for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2025 12:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740571830; cv=none; b=Q2iIWkrExBQ5nBCRA37gt9NkB9OWPOT/LEtk0OW8oLIG27Ezz5C3TDoiCDcTuhCZwGdjmZmhUaxeNjDPtIxY+qaNAMqxNl75RB7k3Ks0YoNvHANKNS/PeWzmixp1bfPAREMwHpf/tQH902U/g3uR/OgYfybSShClW+YoAKwnLWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740571830; c=relaxed/simple;
	bh=NDQLjOPiRU48JFwf9tbOAqkkM206hTnuNHycxmdmLjI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JtQxmWH6zea1GpQgueoLmZ//zxPS8O+Jzoz4a9kLb8iW5a5Y7gyokFRew5AUYFXoZfXWLlq8m3bYa2S6QSifPXVbJ6Sh0V3Cc4xDjYWYPwkdC1QfVBSTiMmdSZDhIIOsAyO6t8mNDjuMZEvzx+9WWOaaXsy0Kihm8u60fGPeofU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mGTdLCAZ; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mGTdLCAZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740571815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+i6UfT5KyDRrgh8kYOD+6Aqz438J4G3HLbqw7xmE2yY=;
	b=mGTdLCAZDtzVp/Uo0ar2swpaAsTqoP15oWrtR6IiRyLQyeRGr6tT4k0PgodS2mmOqG7pT/
	5xQwEUPqi6tu5DJ7G3OKlTKKinEurFpoymNL3DPjbxlHJ0BW1ynYW30l/18zgns30n+6gf
	bg+85t1xcXbNWmfYZXGQaU/RACeTS3Y=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-hardening@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: Replace deprecated strncpy() with strscpy()
Date: Wed, 26 Feb 2025 13:10:03 +0100
Message-ID: <20250226121003.359876-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Since strncpy() is deprecated for NUL-terminated destination buffers,
use strscpy() instead.

Compile-tested only.

Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/target/target_core_configfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c40217f44b1b..446682f900e4 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -143,7 +143,7 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 	}
 	filp_close(fp, NULL);
 
-	strncpy(db_root, db_root_stage, read_bytes);
+	strscpy(db_root, db_root_stage, read_bytes);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
 
 	r = read_bytes;
-- 
2.48.1

