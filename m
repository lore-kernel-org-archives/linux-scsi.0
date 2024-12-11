Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0757B25838C;
	Wed, 11 Dec 2024 18:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943287; cv=none; b=f2zVyZXr30llTwq7rEbzdLml/cHJMX4rKNCiwOEW93wF7LHEliKkWOBGZAg9nv6jvPX6qrKopEREG8L8YM0rCPEQj9crc8IKNhGhmMiLQmErrkltYRUH0PGLEdKNWtds7FdAyUFq6N4Hp35lQ6AAnU8Q8ugnDklox3KEwaZf7uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943287; c=relaxed/simple;
	bh=xvvkx6m9ExYUwmVPVwUyoaCO183IaAF92usXSZ147HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1Gtp0OBhujtCtfqbLEtyy+Z7urgbUTGnNuyvHGFxdpFMmxWSSxCpmWzfhzCcn1d2ss1S3F0EDixERKQyMV4rt6dKQAgiKTNU/fx8e4RuyeXEkVNFpXIV3lj6qnpnresMZuQ6Rm4G3amSXa9HkXk8StzJ2JWHKsrsrGhbxXusJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HlFO10sd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HlFO10sd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D97BC4CED2;
	Wed, 11 Dec 2024 18:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943286;
	bh=xvvkx6m9ExYUwmVPVwUyoaCO183IaAF92usXSZ147HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlFO10sdSdzA2wSh1kITsMDEbaQSm6lZ7Tp4lQvck5ZaWRRP40AU40oF5C8rWHS8X
	 AI/LiS09Vy5HQX5XAMm2xICz2x0KC14p2nzfRBaM/5mxkmimlJAtebARwSHH62n0ve
	 EUvPDFChlynihVsZw7egMDMh8C7FUoCbXNPa9ZNwtewWoJXyDh2oAIYk5dBoHVln1H
	 FkhQy3CLXAxyj6ZKn9cmAvZ6BcGBoVI73z4TdwHNE3OVx2NnHkY1g2DsxxeeVdoajx
	 9KwXAGBbiK6Ctu8UhQxvsn2MFJ89Ng/u2hy2AIbxk5+Xauj7/gX3RQ9dWzY4pPw71F
	 NCttNpFYB0ZJA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Tomas Henzl <thenzl@redhat.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 2/7] scsi: megaraid_sas: Fix for a potential deadlock
Date: Wed, 11 Dec 2024 13:54:35 -0500
Message-ID: <20241211185442.3843374-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185442.3843374-1-sashal@kernel.org>
References: <20241211185442.3843374-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.286
Content-Transfer-Encoding: 8bit

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 50740f4dc78b41dec7c8e39772619d5ba841ddd7 ]

This fixes a 'possible circular locking dependency detected' warning
      CPU0                    CPU1
      ----                    ----
 lock(&instance->reset_mutex);
                              lock(&shost->scan_mutex);
                              lock(&instance->reset_mutex);
 lock(&shost->scan_mutex);

Fix this by temporarily releasing the reset_mutex.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20240923174833.45345-1-thenzl@redhat.com
Acked-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 603c99fcb74e6..7f2d12c5dc4b0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8802,8 +8802,11 @@ megasas_aen_polling(struct work_struct *work)
 						   (ld_target_id / MEGASAS_MAX_DEV_PER_CHANNEL),
 						   (ld_target_id - MEGASAS_MAX_DEV_PER_CHANNEL),
 						   0);
-			if (sdev1)
+			if (sdev1) {
+				mutex_unlock(&instance->reset_mutex);
 				megasas_remove_scsi_device(sdev1);
+				mutex_lock(&instance->reset_mutex);
+			}
 
 			event_type = SCAN_VD_CHANNEL;
 			break;
-- 
2.43.0

