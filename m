Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2843093B8
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 17:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755192768; cv=none; b=NwKYyXDhw/lMYLVMgbV2VWV7zyGuGrVhF+0ylmnClJJen2FAlPz+706gtx0Ubb4i0GRPv0PCPJSplstg6lU3Cxsw07XoNrsSTJ3UrvLDEXu5TXTiXiMKyWwpjNiM6apmXXeFMPa+FjEckpD8DFkRmCHHzwJsxYlV1L0warscwhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755192768; c=relaxed/simple;
	bh=zkJodNR7266mOfLP8S7rY+zC7cVCnipgRxGLcxw3Rao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYDOvFpAO0XOuOAUs+b48nH7d0th14bWq+/66306jqafT3esQF1DzulKSfgzhwX7Jphnvr55sWCqlicuna4Z388Yj6qxsdlScQjybrUM2zegqGnMCxBctdxgF/iPlSUrNVlvqhVIWQsOVaCMaFr3r6imJQaxLb857uxqT9yak8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rBzftnO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rBzftnO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F90C4CEED;
	Thu, 14 Aug 2025 17:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755192767;
	bh=zkJodNR7266mOfLP8S7rY+zC7cVCnipgRxGLcxw3Rao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBzftnO/RtL1jYeGfhatQSI3KxgyBRliIuvcm8MEkbj5L8TEvv8RFwvrVID7UW4fL
	 Iy57eQNaGpIn8ZYIjPVe1nF6F9djppEGX/2nXSN00Cea1Tm/IJ5kc+RoWEeH7GCS1x
	 4C3geibPbZSbV0EE6R3XDLGxs7havfGC5PIzwCaBpGqQZgMokHE5TDNGWPgM13Z6Lw
	 zqjS/3LYo3ewWWX24Spo88dyjCzuP7Y95lgAfnDy5ghUDk78b2ClNksYKaerTkGhrK
	 SdyveiINqW0fzzt32G0D3deOGxCppymZQm2AxpwEyNTZIVSkfpi+rkSvy0N/r3dRXs
	 ifHpupjJYLfDw==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 05/10] scsi: isci: Use dev_parent_is_expander() helper
Date: Thu, 14 Aug 2025 19:32:20 +0200
Message-ID: <20250814173215.1765055-17-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814173215.1765055-12-cassel@kernel.org>
References: <20250814173215.1765055-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=821; i=cassel@kernel.org; h=from:subject; bh=zkJodNR7266mOfLP8S7rY+zC7cVCnipgRxGLcxw3Rao=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDLmyS5TmPzUsG3149es7os9CrM2GC153CD4Xuf8SW8tO dULrL/ud5SyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAi+7sZGeb8tP5W9XlHi87C VuZ2xuJfWqYdX85O1zphmvmyrUUg9xnD//SAFUv+7JTkDk1yW1h1UPbXsqpZ9o72b6bGX3pt+Cv rCA8A
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Make use of the dev_parent_is_expander() helper.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/isci/remote_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 82deb6a83a8c..4c7462965ea1 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -1434,7 +1434,7 @@ static enum sci_status isci_remote_device_construct(struct isci_port *iport,
 	struct domain_device *dev = idev->domain_dev;
 	enum sci_status status;
 
-	if (dev->parent && dev_is_expander(dev->parent->dev_type))
+	if (dev_parent_is_expander(dev))
 		status = sci_remote_device_ea_construct(iport, idev);
 	else
 		status = sci_remote_device_da_construct(iport, idev);
-- 
2.50.1

