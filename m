Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30253093B8
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 17:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755192770; cv=none; b=iRquElnZYnRKFWeyTmxYIoluTIjZEq9ezYSPvanQkyLpTTDvHqKcPBUSiXAHqLxei5zfy/e92/0wQSsKm640f2WPPb3I9jdl/HVPB2rRKCaykRFKeBp2JKy8ll0bHwJ+AF1hobd1xa4Gz6o14+CRehNJC3XH1XY/4+MmwzkXMl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755192770; c=relaxed/simple;
	bh=O3aQvV0SndjIPudIOru37m+jWvCUmBi57kuKNIe0Jr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nxll4gnid1NWWWWuPvkRV8KpmvLQLh9v2zzZlBMXuzEHRjrfAO9NyUGv+3RCz8ByKCGRXXI6ROcrDZOLiE5pe3hDxx7f4WOyy1hDaiQvpLEZEHclTWN4+bYVK3JNliqRYTyfZdBJVjYOPx8Cim3Wv2ZV736TA8PUtNy1YvHEPMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhFVEGYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhFVEGYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71968C4CEED;
	Thu, 14 Aug 2025 17:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755192769;
	bh=O3aQvV0SndjIPudIOru37m+jWvCUmBi57kuKNIe0Jr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhFVEGYP+yXmWLRurgQhCV9PqYgywMSG0d3bDwlshs19rbaCXfOAVKNibzl6IOHnv
	 QAQATD+jFGVb5lieWjnwY/b3acDArNFIBFkXeiPFN7E/qxo2A1aq1hkeeasRodmlXB
	 tV7vOBphKGfxy3JKOAVJStgYHmjC7QHy8k+km8qQtqVtbfNDQGd27lH1hTLu+tcTnm
	 MeyW96hoXpnwyF1KyYAlvIS3qVEmPs348orIvECg9H+s8u3h8L7NVJ6lLUdCbqvI/t
	 KMVFrB6Adwg1DcvFyal3zXdtnlqvBKIRVPDobSvhILg7hqJenDHdPXoaBAR3jWdZ3t
	 VhF1jiZRYpUGQ==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 06/10] scsi: mvsas: Use dev_parent_is_expander() helper
Date: Thu, 14 Aug 2025 19:32:21 +0200
Message-ID: <20250814173215.1765055-18-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814173215.1765055-12-cassel@kernel.org>
References: <20250814173215.1765055-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=771; i=cassel@kernel.org; h=from:subject; bh=O3aQvV0SndjIPudIOru37m+jWvCUmBi57kuKNIe0Jr0=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDLmyS67O0HkvFTfK+22PaKHVzxQnJ9aoi8u5aTZyJrJL 6l5sEK6o5SFQYyLQVZMkcX3h8v+4m73KccV79jAzGFlAhnCwMUpABMJfMXI8Nrjoex6/769d8Mi ytLzqxy412+N/eq3u3Jtn6hVr3z6UoY/3AKLwjZe2PyIRVnkbGl16aQ7B/7uWvwz0V4kecPz1EU /eQA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Make use of the dev_parent_is_expander() helper.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/mvsas/mv_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 15b3d9d55a4b..f2e7997d5b9d 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1175,7 +1175,7 @@ static int mvs_dev_found_notify(struct domain_device *dev, int lock)
 	mvi_device->dev_type = dev->dev_type;
 	mvi_device->mvi_info = mvi;
 	mvi_device->sas_device = dev;
-	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
+	if (dev_parent_is_expander(dev)) {
 		int phy_id;
 
 		phy_id = sas_find_attached_phy_id(&parent_dev->ex_dev, dev);
-- 
2.50.1

