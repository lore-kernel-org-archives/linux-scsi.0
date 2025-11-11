Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94909366567
	for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2025 17:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762883389; cv=none; b=coxddKXNSV5xBbvqQAOgP/LYnny/qyRrULMNqqyaFGcnIbh/SHhqe1+itQioOdYZa9w9SPWWMU0ykRLKROmczGYxwMY9MlH88nmlT0FsivSuyBQ8KM/YwUfUfYnJyxlnn2WaC0hPWDYlbbww9GVk3/EEuRewOMqlyFnQB15clko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762883389; c=relaxed/simple;
	bh=wd8HjuszKDiWk/WLoiW49ZE7bKUwkd/mXBcVXS010B0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Rrppfo96DXyZUJxtQDZWZPZ7KksRrr0Pc3vyjPSzAbd7w4Bq10KJGEDyP/qvQVIgEdiwj/eyCwvzfJpMWc3HiHSeMARzsEgLfd1fuPOtFP36slvEJRPs2AQ21PjeugfkSKxJyQI666SysJtdykdO+p6/0hNj4ZU2pMviuGYNl5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kg1hFnwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kg1hFnwK"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35D45C4CEFB;
	Tue, 11 Nov 2025 17:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762883389;
	bh=wd8HjuszKDiWk/WLoiW49ZE7bKUwkd/mXBcVXS010B0=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=Kg1hFnwKawtCcasxS2ejU23lYC/AdLfYeTM1WK8/6lB9dVgNymWbYXdVcLdGgOo96
	 4n3EocI2uTTz4Vvf81Z5C9Pl026VqCNsg6PDuUG6wTKK/tMd0NFqzK6f4ALXfoDPWu
	 WyCuvMyt6YYYSkRtAC1VcVE6mEkoJfIMoxAkxc4gcQmeeQwenMfh323E5tl54V/ykm
	 OqR2tXnyL9QtdjYxumQYyAyYWHjYp+zNiyBLPPq/gLeDCPm+c6RHZDaLe3g21FNN1a
	 Lh8rl/t4JSbnmnNCnpwPw4vZkahMRj7j8WE5dNEyygjYEMoAqOHaQ6jmBiw4aZH160
	 FA8Om/p5Z4qGw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E43ECCFA18;
	Tue, 11 Nov 2025 17:49:49 +0000 (UTC)
From: =?utf-8?q?Nuno_S=C3=A1_via_B4_Relay?= <devnull+nuno.sa.analog.com@kernel.org>
Date: Tue, 11 Nov 2025 17:50:17 +0000
Subject: [PATCH RESEND v2] scsi: pm: Drop unneeded call to
 pm_runtime_mark_last_busy()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251111-scsi-pm-improv-v2-1-626b8491f4b4@analog.com>
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762883425; l=1113;
 i=nuno.sa@analog.com; s=20231116; h=from:subject:message-id;
 bh=s7cddLv/0itS0gt0AH8XS27Y9mgippHn173s01vX9Rk=;
 b=YrCa9WG+27Szsky0+QmtnLULGxfdcAB9Em4oXhIzHtDcNe4iYJFEKRECfZMjZ86VrtU6HTtHi
 3niS5kvmDgNBFajUOu57pXLMuiYh/Yf1s0c6vhA612RlD9FCl/ln/F9
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
-- 
Nuno Sá <nuno.sa@analog.com>


