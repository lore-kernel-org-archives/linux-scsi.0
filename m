Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15026231A55;
	Wed, 11 Dec 2024 18:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943294; cv=none; b=q0ACks0aak3zrmvtDZwJhaByr0c9spx26jSVxXhNWs8S8voGYbMPb0479SpNDgnBK/7VwedM0ceUE8TMUIDPIXTP13wSQqJBDM8SvAptN2z95pQhaG2xxGQPSiHhjWfjyao0KO460G2gDPTLQhKQdmNlc2Ba794+YzZW8+2VIz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943294; c=relaxed/simple;
	bh=CCDFKS6vMByGtpQTlwrzuoSGCamZCdlwbcG/B6kvv5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/aLh86I6ssGE+tyNtvgOrP8EAnhKuyZ+tPTt+rvDE7s6NCKtM2SUuZIf7pEotUTtF+d9zGxz89d/RAYZzBDFMC/+WAKkOeNcPd6kSKwOnz76O6LYayrhoxqOjFeOZZaCs4gskBmxhdq3v90zmI6vviaS1GLXDlKUU4U275cUmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZD1viP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZD1viP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D4BC4CEDD;
	Wed, 11 Dec 2024 18:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943293;
	bh=CCDFKS6vMByGtpQTlwrzuoSGCamZCdlwbcG/B6kvv5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZD1viP+kw0HsYfMRSV7mRpynmNmRllGobIktreIQIn+BT2CHeIf7vVH9pElO7PWA
	 U7oss1t2aanUlRfVeMpIbgj0wzMT2TELzyKfBWs/QP/beHvpPIG0vhb5MqFhwxWB13
	 Iun9hR+bM6ckDdmB5AXwRKgs/1vcF+C79dzAaNwOHFbsCIExO31SrBTrL4s6ZWQoN2
	 H9xLQgKDfP5Oxr0yVznoHWdouHHA2pPIzvhYFrKEAVxKGvaDcPqcNoCNW2guNqrQUX
	 P/eFScMADaH/emzhz8xUTgHiB/B2k7rIU0OTVrEtgSljU39sAUasSGzqLifXyhFrmP
	 Jb38bgXMNo0Tw==
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
Subject: [PATCH AUTOSEL 5.4 6/7] scsi: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time
Date: Wed, 11 Dec 2024 13:54:39 -0500
Message-ID: <20241211185442.3843374-6-sashal@kernel.org>
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
index 1bc23e8ee748a..69023ddceb59f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5695,11 +5695,12 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 	int i;
 	u8 failed;
 	__le32 *mfp;
+	int ret_val;
 
 	/* make sure doorbell is not in use */
 	if ((ioc->base_readl(&ioc->chip->Doorbell) & MPI2_DOORBELL_USED)) {
 		ioc_err(ioc, "doorbell is in use (line=%d)\n", __LINE__);
-		return -EFAULT;
+		goto doorbell_diag_reset;
 	}
 
 	/* clear pending doorbell interrupts from previous state changes */
@@ -5789,6 +5790,10 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
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

