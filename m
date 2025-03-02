Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D288C13AF2
	for <linux-scsi@vger.kernel.org>; Sun,  2 Mar 2025 22:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740956299; cv=none; b=P+LSoXTCGU5qnQslT9ZI32W0KuwD8vtLi3T1HBYIucQhF7cNQxfgRgd1AJEzh0RiOOcVETjYkJcNHjA1DSFTACZ4NHWnTXEqAoZl7ze8YfGyO2OH5VsdidlyhfJZ+MzLRv9eYHdpnNLDZc1Sxi+Qax3Uaos3ydwTNO5ctMJ6sJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740956299; c=relaxed/simple;
	bh=tYFixfIY3u81D/Jr0PjpNV7f2Q8NfNfO3Pr54h2gbS8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hbkxTpxG8pnfc45xREmOT2Q3CQ1rX9pIA3NT9SuH0n/sy3QXY7ehsKd2e58y4/o/Ww2r206x0L+JHW06vZbtGj9glsnJk6nE32sHLlS56Wnl0KmMrudFVGhDNc+xp6oEjU4By3bcxflvSCsOU9HoE2kN8oVIQHXR4vB6IkN4aNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q3ju93UX; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q3ju93UX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740956293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jtykvtmmT4SBJVkNfvIH1V/KR8RNUn2kl39LnxHTA7o=;
	b=q3ju93UXezxv/lLOF7wlqHfY97Ijzc1rKEmJ+cmwRSouAAZmrtJyrWTBCaOmHHxtpo6Vlc
	OtYeTYBnFaV6K9fwttSa9jbF6WvWG3cCYUJnl70CIOxHkn1TpC9Ko2aisHjOx4nJbhR8Pl
	RDdRFouZ5t5CrIgxz6DHxBpwyzbivtQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-hardening@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: target: Replace deprecated strncpy() with strscpy()
Date: Sun,  2 Mar 2025 23:56:41 +0100
Message-ID: <20250302225641.245127-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

strncpy() is deprecated for NUL-terminated destination buffers; use
strscpy() instead. The destination buffer db_root is only used with "%s"
format strings and must therefore be NUL-terminated, but not NUL-padded.

Use scnprintf() because snprintf() could return a value >= DB_ROOT_LEN
and lead to an out-of-bounds access. This doesn't happen because count
is explicitly checked against DB_ROOT_LEN before. However, scnprintf()
always returns the number of characters actually written to the string
buffer, which is always within the bounds of db_root_stage, and should
be preferred over snprintf().

The size parameter of strscpy() is optional and since DB_ROOT_LEN is the
size of the destination buffer, it can be removed. Remove it to simplify
the code.

Compile-tested only.

Link: https://github.com/KSPP/linux/issues/90
Link: https://github.com/KSPP/linux/issues/105
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Improve the commit message and replace another strncpy() as suggested
  by Kees Cook
- Replace snprintf() with scnprintf()
- Link to v1: https://lore.kernel.org/r/20250226121003.359876-1-thorsten.blum@linux.dev/
---
 drivers/target/target_core_configfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c40217f44b1b..66804bf1ee32 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -123,7 +123,7 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 		goto unlock;
 	}
 
-	read_bytes = snprintf(db_root_stage, DB_ROOT_LEN, "%s", page);
+	read_bytes = scnprintf(db_root_stage, DB_ROOT_LEN, "%s", page);
 	if (!read_bytes)
 		goto unlock;
 
@@ -143,7 +143,7 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 	}
 	filp_close(fp, NULL);
 
-	strncpy(db_root, db_root_stage, read_bytes);
+	strscpy(db_root, db_root_stage);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
 
 	r = read_bytes;
@@ -3664,7 +3664,7 @@ static void target_init_dbroot(void)
 	}
 	filp_close(fp, NULL);
 
-	strncpy(db_root, db_root_stage, DB_ROOT_LEN);
+	strscpy(db_root, db_root_stage);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
 }
 
-- 
2.48.1

