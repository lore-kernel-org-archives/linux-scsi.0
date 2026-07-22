Received: from forward102a.mail.yandex.net (forward102a.mail.yandex.net [178.154.239.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856CA276038;
	Wed, 22 Jul 2026 08:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708207; cv=none; b=ECMqkvvu4wW73Im3vh0W4O/kr2glwQcZI9Snv3wqgowq2f0toymesnXKUJLJQRXHLQq8etVGgeJkRtOcYYK6wrUOurmt30fOzJwWuBy7LxoPwLZ1HXLxDNhPCQ96EH7zSYXC5foHAUAOHMoN8Fq79Rxqz19c2AwhL9XwngLxoUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708207; c=relaxed/simple;
	bh=2+kx7hZatq9QCQm5/nHMHvMOf+DPdq1/iZ/eSgl0+6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNJF1ffiSpZYe+o/+282I6YVODpSa0cXMX0f4MRZneJXlhLS8PcF+UYMlfjn4u+d4NrivxWenSY+wzJNYw375bEmDjB7DkJPT4zHbnNMFAZ4xd3SM4++jdOXxEUoA6Gh8GRd5Y4i7iyvITR964yn/ze90iKs4PQSwvWV7/Scp00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=Rht6Odip; arc=none smtp.client-ip=178.154.239.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="Rht6Odip"
Received: from mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0f:39a:0:640:15c4:0])
	by forward102a.mail.yandex.net (postfix) with ESMTPS id 56AC3C0060;
	Wed, 22 Jul 2026 11:16:40 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net (smtp) with ESMTPSA id dGSrGX1fHSw0-hO0xLrj1;
	Wed, 22 Jul 2026 11:16:39 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1784708200; bh=8N72bwHG17Zqe6B1BCbU+Y/zm9d9jdPNJZuoJHm/Wws=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=Rht6Odipzj3Hg68vriCndgc4iGVqP8UxhZm8ajhKQQK5ki6qjYBkso4VV15qG+srd
	 HYF7IPtqV5eAZ9FUKcasJBKTqKCQ/48fdE+xsaD/wH0XwMrG74Z7Ww6oFFnzN0QI+b
	 s473R9MIcJpq49hQu7WpEmp5McF5nXSEZC3M57Rk=
Authentication-Results: mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH v2] scsi: target: avoid strlen() in target_core_call_addhbatotarget()
Date: Wed, 22 Jul 2026 11:14:10 +0300
Message-ID: <20260722081410.846516-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722064821.B56F71F000E9@smtp.kernel.org>
References: <20260722064821.B56F71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since 'snprintf()' is capable to calculate output length
and detect output truncation, both calls to 'strlen()'
in 'target_core_call_addhbatotarget()' may be dropped.

Assisted-by: sashiko:gemini-3.1-pro-preview
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v2: adjust error message and drop strlen() on error path as well (Sashiko)
---
 drivers/target/target_core_configfs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 2b19a956007b..8a41139e6594 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3635,13 +3635,13 @@ static struct config_group *target_core_call_addhbatotarget(
 	unsigned long plugin_dep_id = 0;
 	int ret;
 
-	if (strlen(name) >= TARGET_CORE_NAME_MAX_LEN) {
-		pr_err("Passed *name strlen(): %d exceeds"
-			" TARGET_CORE_NAME_MAX_LEN: %d\n", (int)strlen(name),
-			TARGET_CORE_NAME_MAX_LEN);
+	ret = snprintf(buf, TARGET_CORE_NAME_MAX_LEN, "%s", name);
+	if (ret >= TARGET_CORE_NAME_MAX_LEN) {
+		pr_err("Passed *name length: %d exceeds"
+		        " TARGET_CORE_NAME_MAX_LEN: %d\n",
+		        ret, TARGET_CORE_NAME_MAX_LEN);
 		return ERR_PTR(-ENAMETOOLONG);
 	}
-	snprintf(buf, TARGET_CORE_NAME_MAX_LEN, "%s", name);
 
 	str = strstr(buf, "_");
 	if (!str) {
-- 
2.55.0

