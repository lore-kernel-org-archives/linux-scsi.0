Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C2C2628D;
	Fri,  5 Sep 2025 10:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757068354; cv=none; b=crpylc2dBfVZeZ3tiT8wLCt0ajkj2u/qqocZHN/Wf5uTTVzyFekBwI2iMGSuJ+l689zhuSgtBLw19FttDg8Jfuc8h+AarDw/ilYqijvYSXjGFRsKfM5fVoYVbsaahjuoiibGUYN6vGeaGC4Rkn0MdI9O7raHcDqgt3O1VqAWPmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757068354; c=relaxed/simple;
	bh=yohfxdj2aycTd3jKIyuUEtNqZk7V8m0p0Prxdk8XVSo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CemnCCmchMWl27Wr4un2FK76YIGaeG3ajMHj7z3azQpyjZ87JCkhoFDlpSY1m5XySH4Rh+viRqMs9UKFDXJbEEhZt5hQ9jpY/YXJXUjQhWnH+3WKmLYj0LmOEVVtEn7shQP8xQLFHLidsjHoZ2EZFBO0l1Tz5ctrVCzblcuduK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cOrDJcJh; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cOrDJcJh"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757068350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eAkguRwUj6+C2dt+eyFSAKiiA8Ihkil8qDykC68qjkk=;
	b=cOrDJcJhNo+9ClX86pZUlZEv6kLcwRc6h+ILLGxwWxTRohMHHHQE+327pGUfO8PAfsu/v5
	blTu9NMjJMlUxDwrcUxwQyPRzHZX9ztfq0rzzVHkAv6aJWAk+NvOH+/+ErM3J30FWbG0GP
	J8xD23gGb+vKNHjP6xvAppgaWulxCLo=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: scsi_debug: Replace kzalloc() + copy_from_user() with memdup_user_nul()
Date: Fri,  5 Sep 2025 12:31:45 +0200
Message-ID: <20250905103144.423722-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace kzalloc() followed by copy_from_user() with memdup_user_nul() to
improve and simplify sdebug_error_write().

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/scsi_debug.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 353cb60e1abe..83d49c58b11d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1155,14 +1155,9 @@ static ssize_t sdebug_error_write(struct file *file, const char __user *ubuf,
 	struct sdebug_err_inject *inject;
 	struct scsi_device *sdev = (struct scsi_device *)file->f_inode->i_private;
 
-	buf = kzalloc(count + 1, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	if (copy_from_user(buf, ubuf, count)) {
-		kfree(buf);
-		return -EFAULT;
-	}
+	buf = memdup_user_nul(ubuf, count);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
 
 	if (buf[0] == '-')
 		return sdebug_err_remove(sdev, buf, count);
-- 
2.51.0

