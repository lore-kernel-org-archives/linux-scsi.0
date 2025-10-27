Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECFC21A436;
	Mon, 27 Oct 2025 06:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761547932; cv=none; b=rN7WE5rDgDzoeblZkfcwS+h4Jk3CFqGj4Jqmj/8t4MYGWlz2mDAaQaVzSfCqndsKo7e7Z2E+yyFhk0bRhESpIDzgTctTbsk+f4uDhklv4l/rstZ8QQL9jpi9wfVRJg9rMzK6j9wGC2F9Kf3oPCVHVSm0FS9swJj8EG/5iO5++Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761547932; c=relaxed/simple;
	bh=iK6up+/8Pq3Fl4e98omnNziWoIIl2ApW2ZRnkJvKFBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UwmWCQaKhbXQ/dSmVknQUKh11E2cyi+2T8Ly4Eg1PPaX1E2lhk5U7i+iShco0V4epcU0MkX7UyMJ+LAUaDRel7RM/ubCT9BUIN1Q5JGdPTlaUe4swR4Zub5q3SDKpcayMzm6n/XK1YWSll9bpVeHwG/YTBvZps/VRlgu4Suzcl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=rWiYegTf; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="rWiYegTf"
Received: from mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:1a8f:0:640:2fa2:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 6E6ABC0120;
	Mon, 27 Oct 2025 09:50:35 +0300 (MSK)
Received: from i111667286.ld.yandex.ru (unknown [2a02:6bf:8080:98f::1:22])
	by mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id WoVJJd1FuW20-3bBUDgdQ;
	Mon, 27 Oct 2025 09:50:34 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1761547834;
	bh=ADaE+bps9i8oyssyZfSTIRhA8Vx3sy1KVMgi5sFeLkY=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=rWiYegTfanA5WjotGX2O4m4TkKpDAqw12ZrXWqdHp1QtNzIwSwMUKOEhtCo4+imsi
	 B0FMF/6g5xuOC75L94NVda2g43lYsAqA7P+DVtJS+v/uIyV+VBeDYBvH5/FRo+hHLj
	 07Dcbc1Cxs+NOT/IINiPAwZqzYmMfUwI4820RP74=
Authentication-Results: mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Andrey Troshin <drtrosh@yandex-team.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrey Troshin <drtrosh@yandex-team.ru>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 5.10] scsi: target: target_core_configfs: Add length check to avoid buffer overflow
Date: Mon, 27 Oct 2025 09:50:48 +0300
Message-ID: <20251027065048.2023-1-drtrosh@yandex-team.ru>
X-Mailer: git-send-email 2.51.0.windows.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

scsi: target: target_core_configfs: Add length check to avoid buffer overflow
A buffer overflow arises from the usage of snprintf to write into the
buffer "buf" in target_lu_gp_members_show function located in
/drivers/target/target_core_configfs.c. This buffer is allocated with
size LU_GROUP_NAME_BUF (256 bytes).

snprintf(...) formats multiple strings into buf with the HBA name
(hba->hba_group.cg_item), a slash character, a devicename (dev->
dev_group.cg_item) and a newline character, the total formatted string
length may exceed the buffer size of 256 bytes.

Since snprintf() returns the total number of bytes that would have been
written (the length of %s/%sn ), this value may exceed the buffer length
(256 bytes) passed to memcpy(), this will ultimately cause function
memcpy reporting a buffer overflow error.

An additional check of the return value of snprintf() can avoid this
buffer overflow.

Reported-by: Wang Haoran <haoranwangsec@gmail.com>
Reported-by: ziiiro <yuanmingbuaa@gmail.com>
Signed-off-by: Wang Haoran <haoranwangsec@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[Andrey Troshin: patch adaptation for linux-5.10]
Signed-off-by: Andrey Troshin <drtrosh@yandex-team.ru>
---
Backport fix for CVE-2025-39998
Link: https://nvd.nist.gov/vuln/detail/CVE-2025-39998
---
 drivers/target/target_core_configfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 4d2fbe1429b6..e6996428c07d 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2637,7 +2637,7 @@ static ssize_t target_lu_gp_members_show(struct config_item *item, char *page)
 			config_item_name(&dev->dev_group.cg_item));
 		cur_len++; /* Extra byte for NULL terminator */
 
-		if ((cur_len + len) > PAGE_SIZE) {
+		if ((cur_len + len) > PAGE_SIZE || cur_len > LU_GROUP_NAME_BUF) {
 			pr_warn("Ran out of lu_gp_show_attr"
 				"_members buffer\n");
 			break;
-- 
2.34.1

