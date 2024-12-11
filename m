Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE37252489;
	Wed, 11 Dec 2024 18:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943217; cv=none; b=JZaZP5jqH8w/07NqmS8yaGDN7TjGtkubUeJjYAr0gQzUQA4YZIqFXsBUYeVWEsncaGqu0Vx4rnpshCen/w8HAg0yWuA77ka1EDN/domitB+7YqNgTVm8ns6xo+43l/gUceMx2WRmKpTMC9bATctKItKpGfuDnHIvCjvTNLasibo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943217; c=relaxed/simple;
	bh=BAv85C6e4PYq5+5qthT6t4YBDo4rviPq9j45B2fTOw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUST3lVhZI0bDYXDOKha1mqZ0jfKI1IZH7maInlshfkbh430HdFjSaiCON7nPMUgWadXmkNVLOArwyr7N0zS3F/GsiGRNGYYR3HmBB289MMDVdo/WScOQpjnBSoPDSs4XM8YZddTGn4JdAHsd4JBoqZbV0iiIBuK75fzBgvWXzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZyzesyCL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZyzesyCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162F9C4CED2;
	Wed, 11 Dec 2024 18:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943217;
	bh=BAv85C6e4PYq5+5qthT6t4YBDo4rviPq9j45B2fTOw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyzesyCLoN6+zI3PzV0dd/ZzzidZ9kzVWYwVIDL5lVBZoJj10IfLK7S9yDP8sO41q
	 C7jfOfYXCYhR6TTWRGQEtwLRAqAADG8ZpE9tS8C/1TbrWxyuVQt3gnnSQ3Sgxe9KqA
	 xphx+mM36MUVTb30bD21RstdGiIHyjqYUw49zln3RE5vf9j+3LZqG5gD44QQDy/3QW
	 ypycKUbsjK3R9V4VDWxy2zpIt+HbX/EznSELONWZu1MuwvG7WjRZsjObN9tY3Ui686
	 byXnyJBVHKfspFHHapvKz4hGC5qq0SRsqTyON9YZ5ssqFBurCdKf6d6W4eRZndNOoS
	 tHJ8m6nvApMkg==
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
Subject: [PATCH AUTOSEL 6.1 10/15] scsi: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time
Date: Wed, 11 Dec 2024 13:53:02 -0500
Message-ID: <20241211185316.3842543-10-sashal@kernel.org>
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
index 03fcaf7359391..5c13358416c42 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7061,11 +7061,12 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
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
@@ -7155,6 +7156,10 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
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

