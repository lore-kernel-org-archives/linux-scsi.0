Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5071F790F;
	Mon,  8 Sep 2025 18:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757356929; cv=none; b=lUAUElIH5m1Fz7kH7hBMrdoevEeKYueE9DXjK5CXW7I1ZVw4f7INMvv4IYwup0wfLGFugmXSvmTK0EpG1Jj1AF5r5o+V/8e7uyZuhsYlRwE8SOd2K0JU2ivT6M/Pdw0uMacGrqAeTqIBSEQUvEOOsr9+JwORilf/ZmTX7ggn6Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757356929; c=relaxed/simple;
	bh=72VHZnaP72CTpxdIwgdUNhKdw5m3kU5+PRYk/sWvmW4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pgcETTYrFBY0nAO1m9qAQoZKdz1g5X/zE3AElJwkHcpnD57OHME96PeLokAUIoGT3spjZttFSzz63SO8qPxlNV5GQClZrXtvNjJNb2OzwGNaASwS0JMq6QRXEgBTItB7qcZwn3uzoREqg9PB+zgX7JdBRqLLLLkgapKyEBjDBJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fbh3WVCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fbh3WVCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8CBC4CEF1;
	Mon,  8 Sep 2025 18:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757356928;
	bh=72VHZnaP72CTpxdIwgdUNhKdw5m3kU5+PRYk/sWvmW4=;
	h=Date:From:To:Cc:Subject:From;
	b=Fbh3WVCo3JM3GvyJPCV7HUjNfU8ejuyRq+iumfCXe8Tq8JbnU5WHVu7yo6qPRzdAZ
	 4lCO7Ub6+7pGQGSaRuqx4cZR49H1ZbH0g4wj0HINNg59He3EZh6Wh7gyYs6SxfjWsS
	 h9u9dYK0YQG7IDvQdyXMdFQCoLAYRUZ6MIrd0hmnMsFvtns6Hqw9TWqwbdZxAtigZc
	 +ihpBDbc2Fa7y9+AUAyf0R0qvnYc5qIyS2yMvkixRIYK3HEKcSTK8NMrhcvdX/blms
	 xW1RJHyJwY1qVVPlGoa8yR7eyNDF9yyneN8oAQyDnXCCvs38SgMZgWfFXF5KN+jN16
	 RaBAcjeMsk+nw==
Date: Mon, 8 Sep 2025 20:42:01 +0200
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v3][next] scsi: pm80xx: Avoid -Wflex-array-member-not-at-end
 warnings
Message-ID: <aL8jeSJ8uKih9DNJ@kspp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Comment out unused field `residual_count` in a couple of structures,
and with this, fix the following -Wflex-array-member-not-at-end
warnings:

drivers/scsi/pm8001/pm8001_hwi.h:342:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/scsi/pm8001/pm80xx_hwi.h:561:32: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v3:
 - Comment out unused field instead of removing it. (John Garry)
 - Update changelog text.
 - Add RB tags.

Changes in v2:
 - Remove unused field residual_count. (James)
 - Link: https://lore.kernel.org/linux-hardening/aLmoE8CznVPres5r@kspp/

v1:
 - Link: https://lore.kernel.org/linux-hardening/aLiMoNzLs1_bu4eJ@kspp/

 drivers/scsi/pm8001/pm8001_hwi.h | 4 +++-
 drivers/scsi/pm8001/pm80xx_hwi.h | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index fc2127dcb58d..f1ce8df082b0 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -339,8 +339,10 @@ struct ssp_completion_resp {
 	__le32	status;
 	__le32	param;
 	__le32	ssptag_rescv_rescpad;
+
+	/* Must be last --ends in a flexible-array member. */
 	struct ssp_response_iu  ssp_resp_iu;
-	__le32	residual_count;
+	/* __le32  residual_count; */
 } __attribute__((packed, aligned(4)));
 
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index eb8fd37b2066..d8a63b7fed6a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -558,8 +558,10 @@ struct ssp_completion_resp {
 	__le32	status;
 	__le32	param;
 	__le32	ssptag_rescv_rescpad;
+
+	/* Must be last --ends in a flexible-array member. */
 	struct ssp_response_iu ssp_resp_iu;
-	__le32	residual_count;
+	/* __le32  residual_count; */
 } __attribute__((packed, aligned(4)));
 
 #define SSP_RESCV_BIT	0x00010000
-- 
2.43.0

