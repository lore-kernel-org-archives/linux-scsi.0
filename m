Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D808D248353;
	Wed, 11 Dec 2024 18:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943142; cv=none; b=LE/DjWggVwPVD3J3JFZLxY5x8o34LZiEuE95rkK8JUrSXgc7bEBOdcZZayG37GgzRPdFv4uAYW863sT+z9H4ssIe9J0C7+Wj53aSZ9fQf2j2yKyVlyXMpvslD+6nuRDb6byxF07QdfesMsBpyjicZkUxzIcQO2fj8jW82wltHFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943142; c=relaxed/simple;
	bh=BwVBz5oL9M3bMcTfSgQTfhhJR0bBnQHHKRT3mc6MC0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWVLsT789kAE2RhjwYt+8HRGB5BWNhcGpaW186Jd+Ppm04d/SRU6mKNrNWkgxaig/CQniuJMeYBO2gst6JUTWuQdagB+r0MR9mQKMTEuN/qHkSyCQGRGxNSJv1HxDbk2mk5IpSEqIPq/dOhWR+zGpubxsztBNWDXSVwi5hZguZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPoygV62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPoygV62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067D7C4CED4;
	Wed, 11 Dec 2024 18:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943142;
	bh=BwVBz5oL9M3bMcTfSgQTfhhJR0bBnQHHKRT3mc6MC0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPoygV62cdlypJNf9YimU7faVt92VOuZ2Z4LlUm7Rr7CPygsOgut95abwfFV/pEcA
	 KlrrkUoJiDFk+JYF5XoUK1xNjg+gcJgRsxkdsn/gZLjATASgoYKwtlA7Us/S8vAzjx
	 P5qnvWnA/xy/Bb8JVbzZp17EyI54pQWz8w2ykD+0QDxRSRWf5b2nqEJ6KtFWhHr/aU
	 nYI6ppnxuzC5mm3Eb2epqkGQnkX2YOUb7yWyDtZEbQbvIgBNLgKtIc5gRkyhgEEToU
	 e0wAzXOqpJA3MfZAm41UyaVMPLQRtWQkRAu9hqbNEnTFHKF/criAphQxlQ1ufYijOB
	 9YMKSv5Fz10Yw==
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
Subject: [PATCH AUTOSEL 6.6 04/23] scsi: megaraid_sas: Fix for a potential deadlock
Date: Wed, 11 Dec 2024 13:51:41 -0500
Message-ID: <20241211185214.3841978-4-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185214.3841978-1-sashal@kernel.org>
References: <20241211185214.3841978-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.65
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
index 3d4f13da1ae87..4cc93cb79b8b0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8904,8 +8904,11 @@ megasas_aen_polling(struct work_struct *work)
 						   (ld_target_id / MEGASAS_MAX_DEV_PER_CHANNEL),
 						   (ld_target_id % MEGASAS_MAX_DEV_PER_CHANNEL),
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

