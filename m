Received: from forward101d.mail.yandex.net (forward101d.mail.yandex.net [178.154.239.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570631FC8;
	Sat,  1 Nov 2025 08:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761986761; cv=none; b=Drndw2Oc670B34nj1BoEOl+4jKKW9Dih00FDuofSdsOb6PFwXZtNrhQI+TrICNiBjZM6FinHUBQsFi814ZKUS2YGfBSh80fhVJ2GUrcnO3Cf43i7cfv1lxIYFe4OfsqFTkLWYzexiH5CGzDiyyxQqDxyx69G+XFhHXVisFwtc5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761986761; c=relaxed/simple;
	bh=Y1noY9CvrxGRZeqr35Q+ZHBFe9VsTLyVDn1Dg4u7/i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuELFtR38zJ2v2e1H6xcnnHLFzWyN9lXqrP7/ToEGmLWAmYDJx3cwRYQkds6HwSP+/HqwbApWhs8SGwsugBXxYRtLhNdBxtCVAnfDRvlxe5bfSkgGMulu60t80xSRXPumc+EUQq6MQmS0AnjNklPSGZ8ZO3DknJs3MqChnxtAJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=KKMesCfN; arc=none smtp.client-ip=178.154.239.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="KKMesCfN"
Received: from mail-nwsmtp-smtp-production-main-95.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-95.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:2a21:0:640:9c41:0])
	by forward101d.mail.yandex.net (Yandex) with ESMTPS id 57546C00B6;
	Sat, 01 Nov 2025 11:45:55 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-95.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id rjcvGoBLIGk0-fZbYDg8S;
	Sat, 01 Nov 2025 11:45:55 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761986755; bh=t0hknyYZZGrBj+vfI+v18u3S29MxewAG3anb01IvVhU=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=KKMesCfN1/jfQ3Og5SoEhV976lffvx1Ipnh5zgv2eft9uLl59nJcK70u24wAGZXRY
	 wLuI16g1G73LXow+x4XwzeInY1sB3bImeNz8kBYcawJBgtmyDNfGM55mU7tGbGW1ZI
	 wH/QyJkQ6fUj5pNauZZrs7Rym9RFEyi5+ba5Gl+Y=
Authentication-Results: mail-nwsmtp-smtp-production-main-95.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] scsi: target: iscsi: simplify lio_target_call_addnptotpg()
Date: Sat,  1 Nov 2025 11:45:50 +0300
Message-ID: <20251101084550.383624-2-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251101084550.383624-1-dmantipov@yandex.ru>
References: <20251101084550.383624-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'lio_target_call_addnptotpg()', use 'strscpy()' to perform both
copying and buffer size check at once, and adjust error message to
make it somewhat more subject-specific.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index efe8cdb20060..fe4d6d3faa88 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -163,12 +163,11 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
 	int ret;
 	char buf[MAX_PORTAL_LEN + 1] = { };
 
-	if (strlen(name) > MAX_PORTAL_LEN) {
-		pr_err("strlen(name): %d exceeds MAX_PORTAL_LEN: %d\n",
-			(int)strlen(name), MAX_PORTAL_LEN);
+	if (strscpy(buf, name, sizeof(buf)) < 0) {
+		pr_err("IPv6 iSCSI network portal address"
+		       " '%s' is too long\n", name);
 		return ERR_PTR(-EOVERFLOW);
 	}
-	snprintf(buf, MAX_PORTAL_LEN + 1, "%s", name);
 
 	str = strstr(buf, "[");
 	if (str) {
-- 
2.51.0

