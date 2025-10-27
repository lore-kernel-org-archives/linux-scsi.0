Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B68302143
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 15:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761578416; cv=none; b=vDAFMD0wu5qQ4YANJUx2tasfG1CLKE3AfB3aijLcNKttMlIK6DeXpYQlKFxJTLhiEsDsG+aMqs1NFQ/wLqgkNULOukN+cGMLndBjNktL00m45vHZCDGivj541zbWn8GjqCIJLc9HLPNDFXJWq386egQgQvdo4vUz4CphNtZJkb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761578416; c=relaxed/simple;
	bh=LZSrzKJC1sBVQuoK1/CZSuQG4+Mpj4gqGa4U8w5nW9E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=M2pwNiiC0hynqd1jz4eLkamhrDMpyyCMP/s2fDBj5y/gQzfuzT98qYzdkZRGDjAApr/8aqycdKwSXekMTA85ofvQ+DpIHP/zFnXoA3USLXE6O4qSTKTa3FGYK99TqNj833vN5Lij3Arnv1izit8RoZVVuUQx1M9dCaeJykjA45A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKQM9EQ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKQM9EQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2737FC113D0;
	Mon, 27 Oct 2025 15:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761578416;
	bh=LZSrzKJC1sBVQuoK1/CZSuQG4+Mpj4gqGa4U8w5nW9E=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=WKQM9EQ46R+H/FP9lkiqgJI/dFvqdqUlu13sqems7P3SemiNkBO+J6Y9P8Mihg2xU
	 1oB/OTsBjukRf8Xth+XsD69u2iylBGsfBXEc0/vRuMQfd366b61167lD5TLkf07q2t
	 fgqz7FGtnLykhXxb/OQJmZj99KpuOBhq/wJgX6NDQYvGZ2tgXHUrEfWpFgbGgKn83Y
	 ypcD5+UpVd4z8tyoyzuEuyuWtt+YHGGVfM4vuDr5FPG3iA58zx0KpUN7OfvhCom29F
	 Df8sdA/5AzoQIC8V5APV4uC1MUuhdQQA9EzzI2Nq6m93UPXSetN4BuNJvmxoTI6fjC
	 +qtwE4K510iPA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF5FCCF9EB;
	Mon, 27 Oct 2025 15:20:16 +0000 (UTC)
From: =?utf-8?q?Nuno_S=C3=A1_via_B4_Relay?= <devnull+nuno.sa.analog.com@kernel.org>
Date: Mon, 27 Oct 2025 15:20:46 +0000
Subject: [PATCH] scsi: pm: Drop unneeded call to
 pm_runtime_mark_last_busy()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251027-scsi-pm-improv-v1-1-cb9f0bceb4be@analog.com>
X-B4-Tracking: v=1; b=H4sIAM2N/2gC/x3MMQqAMAxA0atIZgNtUIpeRRy0Rs1gWxoQoXh3i
 +Mb/i+gnIUVxqZA5ltUYqiwbQP+XMLBKFs1kKHeGnKoXgXThXKlHG90tnOOV2sGT1CjlHmX5x9
 O8/t+2HIwWGAAAAA=
X-Change-ID: 20251027-scsi-pm-improv-71477eb109c2
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761578450; l=802;
 i=nuno.sa@analog.com; s=20231116; h=from:subject:message-id;
 bh=OB0aJ1GOVumh0AfgEbW8k67NFjNGgObUhf97nIR/bA0=;
 b=bNRW0y7KByyvih+ji0ZYUaSRUyps6ymhPYuZ84xsSMzeMWvGPWcTZ5kqM1r4rmgpdSdJwCbQj
 PQZbwxjzVSECarpRTi7wtASvgChemO/tNsNNNrS2lZyycPnKMGG6Nfx
X-Developer-Key: i=nuno.sa@analog.com; a=ed25519;
 pk=3NQwYA013OUYZsmDFBf8rmyyr5iQlxV/9H4/Df83o1E=
X-Endpoint-Received: by B4 Relay for nuno.sa@analog.com/20231116 with
 auth_id=100
X-Original-From: =?utf-8?q?Nuno_S=C3=A1?= <nuno.sa@analog.com>
Reply-To: nuno.sa@analog.com

From: Nuno Sá <nuno.sa@analog.com>

There's no need to explicitly call pm_runtime_mark_last_busy() since
pm_runtime_autosuspend() is now doing it.

Signed-off-by: Nuno Sá <nuno.sa@analog.com>
---
 drivers/scsi/scsi_pm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d581613d87c7..2652fecbfe47 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -205,7 +205,6 @@ static int scsi_runtime_idle(struct device *dev)
 	/* Insert hooks here for targets, hosts, and transport classes */
 
 	if (scsi_is_sdev_device(dev)) {
-		pm_runtime_mark_last_busy(dev);
 		pm_runtime_autosuspend(dev);
 		return -EBUSY;
 	}

---
base-commit: 8fec172c82c2b5f6f8e47ab837c1dc91ee3d1b87
change-id: 20251027-scsi-pm-improv-71477eb109c2
--

Thanks!
- Nuno Sá


