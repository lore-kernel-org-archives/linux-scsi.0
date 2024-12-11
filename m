Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADFA243B98;
	Wed, 11 Dec 2024 18:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943092; cv=none; b=qL37uaBtOzpIhbzUhZGMhJv5WGv8i7lmZZQLRC69WPJyOqMhlJvQ7MIjy33XpQ1OJZsaE9zVtUNVNDq0uEsLNvPURxJUvjnhvgf792betjCtsV7oFXiww4/7Uweb4EBKjJsPLulO3D8kiCDxY0U6+9HIpCORl3kuhHIX5M80k9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943092; c=relaxed/simple;
	bh=saNB70G4e6tAQ3yKK5P/0CFOS7FpNYaXi7DO1Ttqy68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZhFjPd4fKow4W/tx6f19wDoRwt5F/2NmpAz6/NYcG5QlH6kFpLw5j+tuGlza2hXt7fJeomSWYWv8BpQCQZVyVSonv6o6eknqU16ZFpwLfidQWkdwoWMkC4pRqstZi0p0viuSwL9m1+NF8OLbP/sLwFXNytku6+XGI0WMeeUtbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJ5CWY36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJ5CWY36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE179C4CED2;
	Wed, 11 Dec 2024 18:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943092;
	bh=saNB70G4e6tAQ3yKK5P/0CFOS7FpNYaXi7DO1Ttqy68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJ5CWY36fl3D2sb5R2Bq+qoCFHorh69/wQZnXejV5NfR93ukJbBQmCmm421HilnPs
	 0REMiuTwbjSOFkntCiAsrBBrdvrgAAfW5Yyb/5nOQuj9ZDxOd25ql35dZBmqnHW3eW
	 XIm6mHqk2mX4LtyID4UhjcCFiRb0s7JDSExjbyrTY0Us7ZtflBCE2NCezuUa1tj0Mp
	 IbIOPGl18CkbLdKSBw+Blq2YqpyNHLzYozCMLSBezQgdn2LLMd9mE9STnGCttP0MnM
	 2k1G2GzwO/Cwm7sd5liOncVJGe+o8PJ9AJEmPzO8HngjZMLEVU68DF1kb/b+Trzrlf
	 8dPQExqRCc03A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 24/36] scsi: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time
Date: Wed, 11 Dec 2024 13:49:40 -0500
Message-ID: <20241211185028.3841047-24-sashal@kernel.org>
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

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 3f5eb062e8aa335643181c480e6c590c6cedfd22 ]

Issue a Diag-Reset when the "Doorbell-In-Use" bit is set during the
driver load/initialization.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20241110173341.11595-2-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index ed5046593fdab..16ac2267c71e1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7041,11 +7041,12 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 	int i;
 	u8 failed;
 	__le32 *mfp;
+	int ret_val;
 
 	/* make sure doorbell is not in use */
 	if ((ioc->base_readl_ext_retry(&ioc->chip->Doorbell) & MPI2_DOORBELL_USED)) {
 		ioc_err(ioc, "doorbell is in use (line=%d)\n", __LINE__);
-		return -EFAULT;
+		goto doorbell_diag_reset;
 	}
 
 	/* clear pending doorbell interrupts from previous state changes */
@@ -7135,6 +7136,10 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 			    le32_to_cpu(mfp[i]));
 	}
 	return 0;
+
+doorbell_diag_reset:
+	ret_val = _base_diag_reset(ioc);
+	return ret_val;
 }
 
 /**
-- 
2.43.0

