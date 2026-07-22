Received: from forward102a.mail.yandex.net (forward102a.mail.yandex.net [178.154.239.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0562BF002;
	Wed, 22 Jul 2026 06:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784702303; cv=none; b=kDR6YioQVA8/WR6gAnOL9NdOEpv7Wkh9VOO8srS9U19oupqy/KCINGpQwW3X7dU3569CE/3NFTODewa5Bird4uhDF5QpcsXFi++6j/TNWjti7T+LID4JTAbymUy869nf7SLnE1zWWs/fIRGXdkmkdBHO8jjjHkiYAjwvDt/kXpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784702303; c=relaxed/simple;
	bh=o1ZN9xrbAGGxXrzmQIX0kq/KbIn80Ms/ndtmu8VM4WU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kWqO41Dq3DRAQ2AE6NF/nij1EbhuZPwtMQRwYOInphopeQYpO9tvIGufmeYAWMXQK67a6sVEpq8J37JbyiWMT8HLFQOCKfECscCC+q75AvrtqEXW+MhvHPEiagrOUUeRxiUaDEgH1aqIG6/CFUgS72A919422bxOl8CnDubPgpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=dGrnAxpu; arc=none smtp.client-ip=178.154.239.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="dGrnAxpu"
Received: from mail-nwsmtp-smtp-production-main-52.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-52.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0f:4c9f:0:640:5657:0])
	by forward102a.mail.yandex.net (postfix) with ESMTPS id 2CBECC0051;
	Wed, 22 Jul 2026 09:38:11 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-52.vla.yp-c.yandex.net (smtp) with ESMTPSA id AcQ9Sl0gEmI0-AAbwY1Ta;
	Wed, 22 Jul 2026 09:38:10 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1784702290; bh=qaGDGdFGluhFYM9PhIGXIfohh9deJ8/OObVe5Y+fEOc=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=dGrnAxpuQkAFjWjcK4xT5q+BQtR9MMbu162lc4H7LQ1FjcWawEUVkH09PbGI/u3Bi
	 N8JVtOYA0eHkoWVtI2Hcr8VcO2XLzlTL46bzDRL6rVJpLLtUfHmq27cS/G9rWbuWzd
	 wLdNvbB13vV9Woioh+SpS1uHs4CqrlW/1ulgGTNE=
Authentication-Results: mail-nwsmtp-smtp-production-main-52.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] scsi: target: avoid strlen() in target_core_call_addhbatotarget()
Date: Wed, 22 Jul 2026 09:35:23 +0300
Message-ID: <20260722063523.669361-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since 'snprintf()' is capable to detect output truncation, an extra call
to 'strlen()' in 'target_core_call_addhbatotarget()' may be dropped.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/target/target_core_configfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 2b19a956007b..3214047031b8 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3635,13 +3635,13 @@ static struct config_group *target_core_call_addhbatotarget(
 	unsigned long plugin_dep_id = 0;
 	int ret;
 
-	if (strlen(name) >= TARGET_CORE_NAME_MAX_LEN) {
+	ret = snprintf(buf, TARGET_CORE_NAME_MAX_LEN, "%s", name);
+	if (ret >= TARGET_CORE_NAME_MAX_LEN) {
 		pr_err("Passed *name strlen(): %d exceeds"
 			" TARGET_CORE_NAME_MAX_LEN: %d\n", (int)strlen(name),
 			TARGET_CORE_NAME_MAX_LEN);
 		return ERR_PTR(-ENAMETOOLONG);
 	}
-	snprintf(buf, TARGET_CORE_NAME_MAX_LEN, "%s", name);
 
 	str = strstr(buf, "_");
 	if (!str) {
-- 
2.55.0

