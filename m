Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDEF263C7F
	for <linux-scsi@vger.kernel.org>; Fri, 14 Feb 2025 11:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739533467; cv=none; b=ukoT5WB69tQWxXuUg4N2EoA8KJU95wZfFEnk8mJsWneeOQZgBMl670oIokN9L0DF82VrNXoBh1PH3yC4U0pbMbVMoa9oeMJvZ780COe7j4K6H0i274UOJCAS7dKtTdR8TWgb1AgTSaWsWVZ6OXuZSn1ivqW4akmvUX5u/TBSfVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739533467; c=relaxed/simple;
	bh=rwhe49/5jB2QdiusmRIz9cSf22eUSJf+KuUjfLK0eQo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p1InHIc8a8to8oZHHKF9nL9xeIA6tbHj/N62pNmtg18Dp9iLs5xMnbGJ2OUafdVkBzQhYhCY3aNYZCVuj5T7o3PxXC6K7XlPUmOAKQrO70bZlXfhRrOA9gerY4pAYC6WEcLzv52Ue/Se6awIB4rMGECkw0V4C2nhNEgNJnURutg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pf3hgB0D; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pf3hgB0D"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739533452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=89gFJdlR9qUDNbjkUW82cBr8nzW66/88qgzIThpdpAo=;
	b=pf3hgB0DH54F1MAtwetbpQhnD8ASG/CUsIHMzSv3DqCZTpyk6o6e8nIcFe5fAsmHEMZf7x
	QSEXFXilQLJ4mSm7dsciz0AK6PuC0V41qB4cutKiZ4eEqdRuHFk4pvwM/GtTnN8Y4gADxi
	r0u7RX9ixZEMkSv+VAi1iFEnw/4TKEw=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] scsi: hpsa: Remove deprecated and unnecessary strncpy()
Date: Fri, 14 Feb 2025 12:43:02 +0100
Message-ID: <20250214114302.86001-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

While replacing strncpy() with strscpy(), Bart Van Assche pointed out
that the code occurs inside sysfs write callbacks, which already uses
NUL-terminated strings. This allows the string to be passed directly to
sscanf() without requiring a temporary copy.

Remove the deprecated and unnecessary strncpy() and the corresponding
local variables, and pass the buffer buf directly to sscanf().

Replace sscanf() with kstrtoint() to silence checkpatch warnings.

Compile-tested only.

Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Adjust len to copy the same number of bytes as with strncpy()
- Link to v1: https://lore.kernel.org/r/20250212222214.86110-2-thorsten.blum@linux.dev/

Changes in v3:
- Remove strncpy() and tmpbuf et al and use buf directly as suggested by
  Bart Van Assche and Kees Cook
- Replace sscanf() with kstrtoint() as suggested by David Laight
- Link to v2: https://lore.kernel.org/linux-kernel/20250213195332.1464-3-thorsten.blum@linux.dev/
---
 drivers/scsi/hpsa.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 84d8de07b7ae..bb65954b1b1e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -453,17 +453,13 @@ static ssize_t host_store_hp_ssd_smart_path_status(struct device *dev,
 					 struct device_attribute *attr,
 					 const char *buf, size_t count)
 {
-	int status, len;
+	int status;
 	struct ctlr_info *h;
 	struct Scsi_Host *shost = class_to_shost(dev);
-	char tmpbuf[10];
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
-	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
-	strncpy(tmpbuf, buf, len);
-	tmpbuf[len] = '\0';
-	if (sscanf(tmpbuf, "%d", &status) != 1)
+	if (kstrtoint(buf, 10, &status))
 		return -EINVAL;
 	h = shost_to_hba(shost);
 	h->acciopath_status = !!status;
@@ -477,17 +473,13 @@ static ssize_t host_store_raid_offload_debug(struct device *dev,
 					 struct device_attribute *attr,
 					 const char *buf, size_t count)
 {
-	int debug_level, len;
+	int debug_level;
 	struct ctlr_info *h;
 	struct Scsi_Host *shost = class_to_shost(dev);
-	char tmpbuf[10];
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
-	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
-	strncpy(tmpbuf, buf, len);
-	tmpbuf[len] = '\0';
-	if (sscanf(tmpbuf, "%d", &debug_level) != 1)
+	if (kstrtoint(buf, 10, &debug_level))
 		return -EINVAL;
 	if (debug_level < 0)
 		debug_level = 0;
-- 
2.48.1

