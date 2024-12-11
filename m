Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E68825553D;
	Wed, 11 Dec 2024 18:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943251; cv=none; b=N3ELUqKKejENd+ut4A97vpYz3E4bRUWawnfRJBjXtieBWplzYIZzctuqZaxOvkyVZWmSv+DX0CaX9ykJvXLzi6l2xe3+Gs170DuMMj9HV/IONoSmbCWXZBEYpryKEUUmvHqGEdi1knLCWaLv6ydGoMSvdmvNRrXmrMlMMxNlrPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943251; c=relaxed/simple;
	bh=LS/prfdudnyizGxAyFq1i7ISPOp2WtySokBWdeB3kbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0qvYaWkIJ70MhD3wi1rcz7Fd6p4JrtpyRoi5QVO3iDgskpfmmdy/ykOrYIUFrmC7K369dYBhrQsSFgRj+Hs9n97J4hE/wI8RoHk1nY5sGiDjVZiiy9vUohnRKMHM/ih3OEasyxEFNjVOBwVxEzqoIJxL+Id+PQYmh09RgnseTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dvlf7rdo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dvlf7rdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A75CC4CED2;
	Wed, 11 Dec 2024 18:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943251;
	bh=LS/prfdudnyizGxAyFq1i7ISPOp2WtySokBWdeB3kbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dvlf7rdo2o7Ng063jy5sTloEP/Y0N0LiXaA+jwpVHnQXEAURE3/YXzn3QgH63V006
	 X3g0WI4ds+yjT18bnG652mUQd8P7Ju8rYjqH8wCqTVnPRkDVs5UkjDD6oNKcx1jz+P
	 QEpCcswofRpSkpmVzwtUxCOtGlACD8NkrMM+35Md9ssITrVnZhWK7TviicKEzBG0bH
	 cEW3qbPo2oWnFzfH2UsTBEKZm5QxKwaWddVS4hg7TLhEgFo3SrZn/Mxl8uzGTwx3Oi
	 Cm7W12OFSA2hlb0Lhif/51LCd33dg9T85ioLvjN7vck/1sz9jf61CIv2zGA0sAnN0M
	 fkwMKDrAfPe2g==
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
Subject: [PATCH AUTOSEL 5.15 08/10] scsi: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time
Date: Wed, 11 Dec 2024 13:53:49 -0500
Message-ID: <20241211185355.3842902-8-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185355.3842902-1-sashal@kernel.org>
References: <20241211185355.3842902-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.173
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
index 0fc2c355fc379..0c768c404d3d8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6901,11 +6901,12 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
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
@@ -6995,6 +6996,10 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
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

