Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA9A30CD8D
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 16:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761755804; cv=none; b=ZBPUOdP7yT13EZiGMCdw6qUVCh0pRSJf3TK3+dYf7YNo46/PHgk6NSPkDVZ+5viOLpCZYk8anM0UnO9EYG/vaEB/dcGhEBBWc1h6hHbMA4Qlc+4fpWKFbY7VEppe+JYuLPebSdXWgD0vG6DWie5i3q193ImEq3IP1xf98Uj/Xvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761755804; c=relaxed/simple;
	bh=8r6TZbcSObQ4imaECEW23DBfiSsS2dtn/aCamN5FHgQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Dj++xQuB3N6EV/0MAQ+ro5fnuB/sE3H5eJ7EtmUC7vhgAOPqRdclpMzSY3bp0H+QYZ5Y7VhiceybCZWbOw5dt+fnYJHlqFEK7L9GQ7uDNJAV2sMPO0UVoKZ/PWulnZjmnxrBoMEhtNd3bzqsbRYuS7pVpUS7Dt/AhAXmA1IXtlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/GjUiYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/GjUiYf"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6CC27C4CEF7;
	Wed, 29 Oct 2025 16:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761755804;
	bh=8r6TZbcSObQ4imaECEW23DBfiSsS2dtn/aCamN5FHgQ=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=X/GjUiYf8p4WjbiW0YLengisSXc1glKTSZWKBv19m7B34CNsZ17xm3yJ5/lUHKlGX
	 C1Q8grKrkE0VcUSNip7gvpXNU2y6W1g53Dw83kfI9SE78i2BclJ3YSu6RhKdgrgMsM
	 uLkBizDkMmH9Cmk8f+ikZgqRNS9D/NDg7uxAl2MYaByRNQvV1srUHmj4pADjCHGBqx
	 5wwrSuReHknBSaIclldj9T4EIxErPbNNSPgiEzt/qTVjvk4WQI+NC4j/7yszmtqdij
	 CdUGwjNRNGi37q6Y+s21Q1oCDvmGbfPzRALrkTq+ewGeU6sh5B0SJX+klb7qULRqku
	 Joj3pLoo0G0lg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CBF0CCF9EE;
	Wed, 29 Oct 2025 16:36:44 +0000 (UTC)
From: =?utf-8?q?Nuno_S=C3=A1_via_B4_Relay?= <devnull+nuno.sa.analog.com@kernel.org>
Date: Wed, 29 Oct 2025 16:37:13 +0000
Subject: [PATCH v2] scsi: pm: Drop unneeded call to
 pm_runtime_mark_last_busy()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251029-scsi-pm-improv-v2-1-8c276c0eb1b9@analog.com>
X-B4-Tracking: v=1; b=H4sIALhCAmkC/3XMywrCMBCF4Vcps3YkCZVQV76HdJHEaTtgLiQSl
 JJ3N3bv8j9wvh0KZaYC12GHTJULx9BDnQZwmwkrIT96gxLqIoXSWFxhTB7ZpxwrajlqTVaKySn
 op5Rp4fcB3ufeG5dXzJ/Dr/K3/qWqRInOTouwjuxo6WaCecb17KKHubX2BaBWoYitAAAA
X-Change-ID: 20251027-scsi-pm-improv-71477eb109c2
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761755839; l=1077;
 i=nuno.sa@analog.com; s=20231116; h=from:subject:message-id;
 bh=Ou05bUfOa9yU7mLqzgYfaId2pVPwLTtAQ5OCE+EPKUo=;
 b=B2eLKifMO5AX8AcyAqnHC08xxFAgJ7A8rtYR5FIIJRTX+EVjFVknWd5KwTZLgg8hTUihVWk9f
 yABOfzofmRAASnJZ+OAos/AZRocAH2wWfT2DdeoSvFzFlnyXd5L7WXC
X-Developer-Key: i=nuno.sa@analog.com; a=ed25519;
 pk=3NQwYA013OUYZsmDFBf8rmyyr5iQlxV/9H4/Df83o1E=
X-Endpoint-Received: by B4 Relay for nuno.sa@analog.com/20231116 with
 auth_id=100
X-Original-From: =?utf-8?q?Nuno_S=C3=A1?= <nuno.sa@analog.com>
Reply-To: nuno.sa@analog.com

From: Nuno Sá <nuno.sa@analog.com>

There's no need to explicitly call pm_runtime_mark_last_busy() since
pm_runtime_autosuspend() is now doing it since commit 08071e64cb64
("PM: runtime: Mark last busy stamp in pm_runtime_autosuspend()")

Signed-off-by: Nuno Sá <nuno.sa@analog.com>
---
Changes in v2:
- Reference the commit introducing the change affecting this patch
- Link to v1: https://lore.kernel.org/r/20251027-scsi-pm-improv-v1-1-cb9f0bceb4be@analog.com
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


