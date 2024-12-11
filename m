Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE42824B258;
	Wed, 11 Dec 2024 18:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943203; cv=none; b=ILezabA/luYAQKdPUL+0H4lQyVp4Tvi/idQs8xWJh8dUL4/zck/yPJi2/LfPMgbVb+uUYmKkdyUhTEhTzTQBLM/vSTWvjI4PwzZcKabO0tfPzIaFi6xku3z+SLANo6UXhyYXtZHRVElU+IHC3xq1kEF40AXZ/c6oO8TpyDwmboc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943203; c=relaxed/simple;
	bh=CNz9k/uT+0M1sEaOYVeoWRLnLqWi4vuVQfBExRs6Tho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGHAMv48cFwm5jbZZqGgM4Cvx3SxG/KFH+Eli1KEPM6XSC8twWPI6x2BOkhIFRsAZUrYrvkzKKMclh+AgksnbkJOPjgNfKBHPTaQGjQPbPnJnk/OXTuDRLWJxx0t7RRUtgmV5m/XkumdanriKE/pVOOsWI6uqZ4WL/B7KI/IKaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tVVVPIhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tVVVPIhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4BDC4CEDD;
	Wed, 11 Dec 2024 18:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943202;
	bh=CNz9k/uT+0M1sEaOYVeoWRLnLqWi4vuVQfBExRs6Tho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVVVPIhyqJifhGB55qglJHiPDW67JYqh5y4+GhAW3k8iEPRbxvCPv1NoOXGQzeyo5
	 pZcOKszv4ykGyfDoWLoJzQDA78Spj0oD33xzKAY/WXH669zD14oGogYJHb2E01utaY
	 m/3X2lQHQUZm6HjVRZX2Kq4/+KLZGDsTO2UYL152kjnZRKuJvlLuik1Jb3c9AbrsTV
	 A0jy+ryAgQYRbt7p5gN4AwcoKkIQqjL8rpK56lbCi9UbDrC0NHy63XeIxqkPotD8ct
	 oscDJzEEGq5v/IYTd2HTmQI25ruPemNhI1xDZRuGhB90nZwc8F06shLNJTm3vz4KDX
	 +GsLeZfN/FCyg==
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
Subject: [PATCH AUTOSEL 6.1 03/15] scsi: megaraid_sas: Fix for a potential deadlock
Date: Wed, 11 Dec 2024 13:52:55 -0500
Message-ID: <20241211185316.3842543-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185316.3842543-1-sashal@kernel.org>
References: <20241211185316.3842543-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.119
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
index 37208bc08c667..f4b32ce45ce09 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8905,8 +8905,11 @@ megasas_aen_polling(struct work_struct *work)
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

