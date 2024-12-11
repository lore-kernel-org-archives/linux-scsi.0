Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC65D22967C;
	Wed, 11 Dec 2024 18:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943169; cv=none; b=U+e+nZk5UXk3eR92WUOf8OHJloIGSU5wmD8+dnSiMaFyhajKMlU+MFhrb/6g0D1xU/AYvnS50tq1Ri+OWcyw+tf6dm0+QEQYOLi2/640A4zjc7+JG21DCthxMmtyjmVIXzPzUTkCGPeZf2Ui7x2VI8OwitQ6jVCqH72JaYAamsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943169; c=relaxed/simple;
	bh=T2CyAFjapRQwsYCTJENWC+rWbyLUqMcwKWrbwRNy0Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6VOMmgEI1AW+tq2AwQYcTz6wavgXsfgcmj1puI3DumclleUnnX9QNPAlX+MBna47wwtSGJGNsvuP+JpLIo5+s0THoXFINQMQCNwYB0b2Tv5AcwK/tb+FVUW41WJXCncwGTp0jx972aTvoOqfpBeMeEynnGQOZcZm2glxLjpyTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2eg3W9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2eg3W9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC98C4CEDD;
	Wed, 11 Dec 2024 18:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943169;
	bh=T2CyAFjapRQwsYCTJENWC+rWbyLUqMcwKWrbwRNy0Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2eg3W9A3wZ2oxiCB2Mf+/M8YaN5FQVcVgVe5ShNo23QDlx3q2G36CjhOiJpR4BzK
	 ogZOzsfkHftoUCDJOSYa7tTfZQ6n/s7Es+Rnb6f87XMB5j7eipm5y3VtCajSA2C3vT
	 peSKr7m4Y4VP4RBv299N8p+If7LRqpyFHMHW+Agf+AWEKlajYsvE3cSpEbT0Pn0xpY
	 1Tit92J69LqG79TJQcPuu9l7PaNsVzbXb98PUcPCHgHsPeSsLLck1dHHwOUwkgCFmz
	 f1VvlB0dot5V521vEFzV3ADpPIS4U8O+3LKjwO+zucpBcoryOzDIX6vBLVXUrrP8dE
	 qWgKIEoapVWgA==
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
Subject: [PATCH AUTOSEL 6.6 16/23] scsi: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time
Date: Wed, 11 Dec 2024 13:51:53 -0500
Message-ID: <20241211185214.3841978-16-sashal@kernel.org>
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
index 8acf586dc8b2e..a5d12b95fbd09 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7050,11 +7050,12 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
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
@@ -7144,6 +7145,10 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
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

