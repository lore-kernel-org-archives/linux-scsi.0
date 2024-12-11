Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42D123E6E8;
	Wed, 11 Dec 2024 18:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943269; cv=none; b=W20jOco+LOYQRaPMbNUD8laHLDWxDDAzeZ8Mwwg6BHlXwl4YdjGV5+D8pqLIXj6ZaiIULfGzWUI4UfRjQK1nHCWui9pzEj/FhEULhykY2hxsgCfQvRaAwfYL98+/eV9GFSxLI2rBH+yPRMaNoIskFhJb/UCTxSv27X96mU4PhNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943269; c=relaxed/simple;
	bh=TmToAHmrV3T65V5SglJTT2b+W8YbFAnlDtctDL1mYRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M97N0aIuHsa5s9KPpgA1L1q5gWC1iaLhUcAlyw98Kz9taaXv1Vlz7cmtPzx4+fLtrMglJ+DHS+1zmmPYPGJ0jRNwD+PEAJFX1RzRP5BKF3X7Gw3qzv4qnr1dKUFiFFtvE9eQ9A+69SnT1gvh1YOcQpSFrJZMl1MCrtxhztATWng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JnDbvFtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JnDbvFtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D99C4CED4;
	Wed, 11 Dec 2024 18:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943265;
	bh=TmToAHmrV3T65V5SglJTT2b+W8YbFAnlDtctDL1mYRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnDbvFtV6egl+euHZFRaV9s0af+pghPU5Ukt3ONW+1pKW6OviGbPBir2EbupXvynK
	 jAZbzpebnXiEGwKw0fdUQI3CYyi9pCGijk2DdtcyixPh71aNxWKoX4XtqD6qnHpc7U
	 ajkzh5pRGCZP9gctr2qUkD7Bin/XDv7PYhG7vN2Knq8mjv/5EgG6zDiQPJ6ywGBXJV
	 XoOBf73FKPa2Z/WOUcHPTT4kk406kWP/+6z3sgdqpg0wi1iStTlg3R7gUrljCPtsqb
	 SQmtzNNhx0VuGPbKZ1bC/CQIRSQDZ6eyTSyoHcT50GqTREw2C0Nzhx8FzsvitfWD8D
	 qj5dn1zuF4Zmw==
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
Subject: [PATCH AUTOSEL 5.10 03/10] scsi: megaraid_sas: Fix for a potential deadlock
Date: Wed, 11 Dec 2024 13:54:09 -0500
Message-ID: <20241211185419.3843138-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185419.3843138-1-sashal@kernel.org>
References: <20241211185419.3843138-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.230
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
index 365279d7c9829..d709d261d0ad1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8868,8 +8868,11 @@ megasas_aen_polling(struct work_struct *work)
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

