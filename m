Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E44A1DF97F;
	Thu,  4 Sep 2025 14:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756997657; cv=none; b=S/kbXnbB4eja5tRT5cOuZt/M2dBH1ldxg/JorA2ZvSqcStKYZLhW43HjpFokPtGyg3DqdKxgUgIX0LjELVCU7dEdA2pbDWNhGEuEStb6V30BAEDAyf056GXRgv3RGUWiLJfmi260qPB2s26h0zgvFYdnFv+SFAsr9CWBUFV5dTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756997657; c=relaxed/simple;
	bh=NRF4KZuR9OnhWyUxnCyXlXsD7UEatus8Z/yPvb0aXZE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KFcZyMj6sSS707+aAabhTE0FkFBu6lfsqazVwjpyBFwk4HMi5sVbb+MIDAGLhiAlQwUEumEPhbWw6/5QncdJuEekKICaL27grYBj9SiOXSO9EyU91gAub1nE3417N3aq8pKkqn8zgYzVC+ASwoEbKtDsB6tTQc8PAdjlg4fGGh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f+LWy6/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f+LWy6/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB104C4CEF0;
	Thu,  4 Sep 2025 14:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756997656;
	bh=NRF4KZuR9OnhWyUxnCyXlXsD7UEatus8Z/yPvb0aXZE=;
	h=Date:From:To:Cc:Subject:From;
	b=f+LWy6/MWEkLk+OTSgkzAZdn0BeGqlNte6BtXqlVOHPOPfakyDvEJ14A8FPbP+67s
	 Oofeo3CSXSTdweT5Cw4bjPJCiMbGeXLKRjKdZYg7gzcePiWN7nO0mSvuEmlETpsxSI
	 LsK+enWN49uLWwhMdtxm0qI3ILic5Ew66CY3SrlyPfzn+vtofuhZEg9gZjyTWD5N1M
	 k6xiA6321d7CE/a728QdZJTkL28xd1ZsXbej1rTyYX/k7KUUJBWbdSuKRERC4f7QG1
	 8V9D461NyC3Whvaj1g2oqiqsHjhNxU8tjdJ+60OyOqIfDjqmP5Rvo5DhsL+efFqtWh
	 kx67HGkC8gZKQ==
Date: Thu, 4 Sep 2025 16:54:11 +0200
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v2][next] scsi: pm80xx: Avoid -Wflex-array-member-not-at-end
 warnings
Message-ID: <aLmoE8CznVPres5r@kspp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Remove unused field residual_count in a couple of structures,
and with this, fix the following -Wflex-array-member-not-at-end
warnings:

drivers/scsi/pm8001/pm8001_hwi.h:342:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/scsi/pm8001/pm80xx_hwi.h:561:32: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - Remove unused field residual_count. (James)

v1:
 - Link: https://lore.kernel.org/linux-hardening/aLiMoNzLs1_bu4eJ@kspp/

 drivers/scsi/pm8001/pm8001_hwi.h | 3 ++-
 drivers/scsi/pm8001/pm80xx_hwi.h | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index fc2127dcb58d..170853dbf952 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -339,8 +339,9 @@ struct ssp_completion_resp {
 	__le32	status;
 	__le32	param;
 	__le32	ssptag_rescv_rescpad;
+
+	/* Must be last --ends in a flexible-array member. */
 	struct ssp_response_iu  ssp_resp_iu;
-	__le32	residual_count;
 } __attribute__((packed, aligned(4)));
 
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index eb8fd37b2066..b13d42701b1b 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -558,8 +558,9 @@ struct ssp_completion_resp {
 	__le32	status;
 	__le32	param;
 	__le32	ssptag_rescv_rescpad;
+
+	/* Must be last --ends in a flexible-array member. */
 	struct ssp_response_iu ssp_resp_iu;
-	__le32	residual_count;
 } __attribute__((packed, aligned(4)));
 
 #define SSP_RESCV_BIT	0x00010000
-- 
2.43.0

