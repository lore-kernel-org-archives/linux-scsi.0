Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43341F3FF1
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2025 10:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739269702; cv=none; b=ryUhQKPLScspPWzZgUxPfGLRqgSueoWUwS1APCwy3qeG0DGkkFxOnrGfwB0y7ty53bobSVT5F8IhJ+uZcPqVV/Hy7rJ2e2uM22JabmLs440W6IbIPCGF0ML7JxjlxdlkbB7LhqduHfoENe9oG8aHxuJ8cpE4zLuuP+ty01RSHcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739269702; c=relaxed/simple;
	bh=ts84cm5dT13q05hefIVcRkm1LjtvF92DcRpv1IASMy8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VQrCd86IorvnQLqOjrUIPdUv6O/R9vLLLQHo5uqwOHYuUtKQmjWOhPLVRHl399+u1+/qXtSKZqxZJyVY3T42zXmh1KrjKasnh3GoqKEXw6rlzADju6oEzYeBPbQGbRxfqXoQybkpvIXPUiMA84wqosRs7yAGlDNlnEMYD7Xa5W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QVFB4a5/; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QVFB4a5/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739269698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=b7TaF0+rQ1df3IWfbD7/Cbo7lt7svQRAuL8kAQPftgg=;
	b=QVFB4a5/lFyhCt141UiWbCZdF9u5s10DBm1m8ZhgaobA10We5v37FM+HgBIiEtWkgJAQFI
	h8m45syC5PKi20QgPdgY4gGY1DCXueCeoBGkFbg6+a31Ys/nv8GMQUcSjEMW52xKD2PhVw
	P64TzBIYBPUKTsVW4ED0j5Wutbp7R+U=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: sd: Use str_on_off() helper in sd_read_write_protect_flag()
Date: Tue, 11 Feb 2025 11:28:02 +0100
Message-ID: <20250211102802.616530-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the str_on_off() helper function.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 950d8c9fb884..96f64237360f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -50,6 +50,7 @@
 #include <linux/rw_hint.h>
 #include <linux/major.h>
 #include <linux/mutex.h>
+#include <linux/string_choices.h>
 #include <linux/string_helpers.h>
 #include <linux/slab.h>
 #include <linux/sed-opal.h>
@@ -3004,7 +3005,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 		set_disk_ro(sdkp->disk, sdkp->write_prot);
 		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
 			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
-				  sdkp->write_prot ? "on" : "off");
+				  str_on_off(sdkp->write_prot));
 			sd_printk(KERN_DEBUG, sdkp, "Mode Sense: %4ph\n", buffer);
 		}
 	}
-- 
2.48.1

