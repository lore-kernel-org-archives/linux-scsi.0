Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1CF347BDC
	for <linux-scsi@vger.kernel.org>; Sun,  6 Sep 2026 17:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788714618; cv=none; b=ezhIr1pVJmp14T2Kbs760mX2MQqMPk6x9y6nTQHZRrVR4DO42HOBYJufMCeNGtj5pfoDvtKy3EbKDcBiC3yt2h6HffZI7Ava78u9nBGHntv6HvP0z9Yq69E6pyxXe62MpkEFzSSwXFp7mjYxY3a7VG54aayo+Wbs4M8w8iGrCnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788714618; c=relaxed/simple;
	bh=lruyQclCRsUnfg26E6EImuxZEquiCmTQnHF1FoASMLs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Gmv2VBHn1yE/uGlJ8jdVkpBOXwFVfyLpSCjlmWtY12sGtmTyI+jonJgTTi9MqFeaD6Jk5JArKCNMurr3Up8en+DMtYo3ezlSBosndqNc78X0Hv27OQcermp4JlCCdFG0zhKdJEH91mh46tinueqpMWsfCezeh0O5RVrjxUreSoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bHEZJqrQ; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bHEZJqrQ"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49954b88fffso19791435e9.0
        for <linux-scsi@vger.kernel.org>; Sun, 06 Sep 2026 10:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788714615; x=1789319415; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hh74k2DAWuqG37Tp3VkGVfE20Ww1rBQTDK9l99hL8ik=;
        b=bHEZJqrQ81eWLUmS6N+iXp51O3QtjIHxCQahFQezoAPKrfG0VWKPxV9oJfdWWXJurx
         8op5/9WU6SHUMSkTlLAghMdkB13VArAPSc6R890CnSshFqIMtSrz+dPlE+IKINa7di3U
         otC+Bz7F4t7k9EAPYK0mesTiyZUlFxQLkhc+7pE775PEVcKJ+/PutERH0tr5v9Wx/j3Y
         I9+SfhK+jRsQpFjil68nJuRxcb3j0sh50sYLKC0nbPXrOR1lexQZTqtQG1eGmUd4lAdW
         /OY/Bgb5pXum99EJDLy4XXSULEl11XJYIhjwcoVOhjWRq+sqKL2Q/0YkpYAG1TRPKVEr
         Vhhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788714615; x=1789319415;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hh74k2DAWuqG37Tp3VkGVfE20Ww1rBQTDK9l99hL8ik=;
        b=DyMb4QUIl1aK91Kn/0kl1n0nkOWsySR0QkBxt4ZvFqhiQ4Wn4qg5EVLfM88XQLwqqg
         uyV7/oIrAneAQoPaKTGZAO9B235zfQFtmQ+mYI3+33u5y0svEVuR0kt3GOm+UnA9G1bV
         avULAmKdSSatEVPNVZMw0x8GQ8/eltXTygPFvn/JI6Q2iB/tgUrVFGBcG7Dsmxdtca51
         G3+4JBBOyb6QF05BitN/STqKo8sUROLYDG1vzpp3hXXyIpN+CSg4sOc8MWdpAOMpFfBV
         HGYaUm2IOrvPIrtPRAuNQTExCPjCs/XZ3YlFI7692LyySQsQXUpCYkBEmCYZtTL+mpYj
         +M3g==
X-Forwarded-Encrypted: i=1; AKwUvByp4QnjxnixEos5gXMaxX4L5IjEZMfa9b3rKdXXoU+rp50D4Jtv6NubxJj7xMe36wou8x51O1/zMXsT@vger.kernel.org
X-Gm-Message-State: AFuF++nE7okzm2lPxwA6m/FYbJBLFbKNwRCUCCefNpqKBlUoxMlE1LIV
	9e5Dd2M/0ZZtUeM5m26r+qhrNIOuavuDKESlB1hx5odJ3joHKgcrSyBu
X-Gm-Gg: AYBFou0Y7g+8fRbd0Ad7O1Vuv9NmMfhA27c0Ftbgx2jOn9S0jM03T+WsKcCp9qOcjeT
	SJNSBTlcAvH6GAnhVundUcD64HFQxamumOx0ybO3MeJQ4gWX1iGNrtibGJ774PZN1jO4WZvphFL
	XIaD8gGh6UI/53FYuhcBSKKL1mQJTu+Fpjxpfqxcloufvl0BzXtqJpVUUmncW023J9pySPdoLHH
	55X3BNH6XNSYCX4u2KT+3QvPDp8RJUlhhSNYAtsLaiQlSqnscnLrYnBfVZp9UO1umeejoCyZeMt
	3lD18q2ixYA0VI6vRA8tn2yENvgZIyTZZfF5aouQLiTcFdipTSEIGy/DK2YDoPcDUcpxNkGPZJa
	Jkomm1WkWbbMiN/mQVa7QRxLwmZ5T5K/m8Kwz+TKK6ivMTZW6y3R2m/V47xUdnUp4O1hCKCT7Z2
	uDYj27kvbldtOEKGUjoKio1U7pry6j/ILYvUN/d6nyQf4Cpor5VTt/4OmzFv+57AjWAjY0MhEPH
	8oDsY+Kn73EBgwtf/qjv1SkPT2PJsMvgv5kytzAAVJJnHVxy40Sa09spY+2P5FGuTzIuXzeYydz
	Zh7GTopVSiLrjHMLGakd6+qemGZ+YhxP7rL8k4Ld8aVQ8aKKLp9jlDrjserFjVQ+dEwfydQoiTC
	Zy8UHmKM=
X-Received: by 2002:a05:600c:1c29:b0:49c:fc6c:be03 with SMTP id 5b1f17b1804b1-49cfc6cc06cmr165929485e9.26.1788714614936;
        Sun, 06 Sep 2026 10:10:14 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-9d84-5101-9c80-d25b-14b6-410c.310.pool.telefonica.de. [2a02:3100:9d84:5101:9c80:d25b:14b6:410c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d00a5b19dsm168436765e9.2.2026.09.06.10.10.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 06 Sep 2026 10:10:14 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	Daniel Wagner <wagi@kernel.org>
Subject: [PATCH] scsi: qla2xxx: Fix the ql2xfc2target parameter description
Date: Sun,  6 Sep 2026 19:10:09 +0200
Message-Id: <20260906171009.2560-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The module parameter is ql2xfc2target, but its MODULE_PARM_DESC() names
qla2xfc2target, so modinfo describes a parameter that does not exist and
shows no description for the real one.

Use the parameter name in the description.

Fixes: 877b03795fcf ("scsi: qla2xxx: Add option to disable FC2 Target support")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c0efdbff5da7..3c412c7fb6fe 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -352,7 +352,7 @@ MODULE_PARM_DESC(ql2xnvme_queues,
 
 int ql2xfc2target = 1;
 module_param(ql2xfc2target, int, 0444);
-MODULE_PARM_DESC(qla2xfc2target,
+MODULE_PARM_DESC(ql2xfc2target,
 		  "Enables FC2 Target support. "
 		  "0 - FC2 Target support is disabled. "
 		  "1 - FC2 Target support is enabled (default).");

base-commit: 986c24e0fe44f844b44d365b71ce831947f50298
-- 
2.53.0

