Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE342368EA;
	Wed, 11 Dec 2024 18:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943041; cv=none; b=uZ+w97QSZit4Ztuxr4uRWpheAXRE8qCCXrnk1w9F6zXUxfdr4RHBWvjdvnG6pivWbqfsfFw6QNN+GOhCbscO547GxABFyFPjO6eE3rjYfGkPiAlVTPtf3CzoeD7zR/RAlA66xvHz7mMrn4iM2gJtoiq5IA+3kWnl5tckTMQyaxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943041; c=relaxed/simple;
	bh=atXkvttAgcTcje5/hkqmH7c7jHA/a7YveQKrg92fmsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYSjusmPllIAtIClbdYH+8hz7/Mh6JYhncaFa/Jp1vPoClI/ctqFBqvbrj3Eq9BianzKK1xiZyxMHJEeL4qpXLAocE4l4tpoNhqS/R9EFk1DJ4AW0cmOXnAqNiqCs92/VNlIKBMXZEGOZg0J/KJUpFYKkrZCkXj0EHq+VrcJrjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AJAqRKF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AJAqRKF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117BEC4CED2;
	Wed, 11 Dec 2024 18:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943041;
	bh=atXkvttAgcTcje5/hkqmH7c7jHA/a7YveQKrg92fmsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJAqRKF0i0CvK70dTAX9A8vwFjwATe1/INIEIcbXeyl/4JanHLQeTBP/3z2BlI031
	 SaPdt8iCNmUWNnAAXYfgg/QXtwhLlwitgn4R07YgOb/X5IykmPGzaHOUeEk2DcRcTj
	 YlSnCD+jdHJ9+iYc1TrrlqvEybOz7e/p2tiWkIRFxOkK2/zfjBZz4pzc/yaXmhD3gk
	 XNXX70Lnu9arCVUjv588q2ccr5EiV4C+4Q4aPQlaGsYSpFGWfFLpzLmKjUUaWuB9Au
	 IVBp8emSGIBT8+KvBret4u58jl6nlFjjBNKAmr9z5Ev45q2h5fMOHG1Fj58NRQoBdb
	 qYfyIdMqgnRpg==
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
Subject: [PATCH AUTOSEL 6.12 07/36] scsi: megaraid_sas: Fix for a potential deadlock
Date: Wed, 11 Dec 2024 13:49:23 -0500
Message-ID: <20241211185028.3841047-7-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185028.3841047-1-sashal@kernel.org>
References: <20241211185028.3841047-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.4
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
index 8e75e2e279a40..50f1dcb6d5846 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8907,8 +8907,11 @@ megasas_aen_polling(struct work_struct *work)
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

