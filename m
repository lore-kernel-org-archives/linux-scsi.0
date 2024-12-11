Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C48C232C69;
	Wed, 11 Dec 2024 18:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943276; cv=none; b=m7jknr8OunQQ2j+N/5PM4xxaRVszU1Mrk46IuLDAg2911FFtzkqkQhg9RqU03QXakOdEuOSEj+xA4PYI1afKzv+5Xf988sBOEniopQhnMbKDKySKBqhs+uQHdeTlfBRu1Lkm/kCQNGt9IlGcMKPkK5Y0D14HdawG6FvTPZiJJj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943276; c=relaxed/simple;
	bh=SQuTOUn7QysIlDRQYcpHg0IwPaRIwBSR1120SY/FOtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiUJSydr6mhddQHsHgu/y3a+wKVY+tYzYf+LbPIcqSKyOZcJLwM+HbyB4T9q/3AsMptSC/QbN8yCVA7hPoFLu1d79XviAeckI5vUp/FSKatMyg2AbkPy8Lcw2oQhvOMnHcyUfvv+1wnB23lzNzQ2RGFmRJifBRCW+/ud45ajmO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XLqhN3vq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XLqhN3vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F7FC4CEDD;
	Wed, 11 Dec 2024 18:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943275;
	bh=SQuTOUn7QysIlDRQYcpHg0IwPaRIwBSR1120SY/FOtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLqhN3vq1WRUA8GMzro1bnAXcDAjPQ2JrYMJE9T0MZDvPsKVjsfth8L4VPApQlmMp
	 B6pj/owI00aq9W3lTeZztTNcR4zQwXf9RFwaEh/+/EhYp7tKkY3rhZ3VyU3+1S3Euu
	 VYvBQCtW7BuJvzDI4bCsKC8x1Esqylia8HHQE5zWlV2p4alDKIMMbxu97/0AbjrzvW
	 elR5nYZA4B8lV0OVBopZSN9OoCVS19wJUS/z9Ppas3f5znj95vVff0RfjgcNH06VVk
	 9CQMh3KHwVJVIr2Rs1cyTnNwt8/qgA/jNy9Y/qXPQSaBo7xvzt52o7LSqHl2xiFsqA
	 1WlqAoWYil1lQ==
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
Subject: [PATCH AUTOSEL 5.10 08/10] scsi: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time
Date: Wed, 11 Dec 2024 13:54:14 -0500
Message-ID: <20241211185419.3843138-8-sashal@kernel.org>
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
index 53528711dac1f..768635de93da9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6008,11 +6008,12 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
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
@@ -6102,6 +6103,10 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
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

