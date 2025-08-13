Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FE02F7453
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 11:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755085300; cv=none; b=tc1LFklJN49qxRn412YuKZnhqoTvImhQpx4vZXN34rUc2Yc5lNSeLrFDbuu2a/D44GjqxIk+qwPHl4rGk0+l7EVdeUyQSAqnAP2HYXPj1FnPmMhOs7EG3tDakqzfnBkFqo8Ridcru/ux0dO3ZuQXM3OLwOvCthfmgC04/HgdRzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755085300; c=relaxed/simple;
	bh=OYcm3fFsjegdehQYQPjjDBcdAGNvTg4kFT7VPo5U9Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rO8cvMNMDdgUPnAkz75DdNsbMj7T+9F1fh8s2KYXdKzbbhtm8J7Qy+ppfM3ZDOieBbSEaZqvHLCYTSHn4RHPpZviseM36vokrmW4XFpIB3z+6sY5l+RObjxkrkEqgJE9qUQ4gLOS0JFpURzJU/aA1y8pJORFgx8ZcBMB8WcN/IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e0aiT9Y8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e0aiT9Y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF5AC4CEEB;
	Wed, 13 Aug 2025 11:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755085300;
	bh=OYcm3fFsjegdehQYQPjjDBcdAGNvTg4kFT7VPo5U9Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0aiT9Y8RJswwDyLtI/v8rh/99B8YT3PGu91khMi6G35wW1rhMteiQKr9HlJ7dRwq
	 9/YZPVHDd3AZILvoS32WndhyvNRD4RnVYJHE5P/NxrtwSvbXg6aQaKJnfz36OK5VFE
	 UHm/jM1vvDkauyt1sSPjIJRQuh/A9o8PETzFOXYsdn6rVZD/tUx0auXLybJQNl5rxb
	 REGSBPnBQ/6Dll/7fe5sHitS2YqYnMejR0veEr3juyPW0teGNBFavu1G+xoZmWTgG2
	 OYROQi4WhXypYhsidLyylmV+6xSKPiPXm4Vkq210z9GgXap6jrHfP5kaFc96KBkktw
	 dbAqnaRCU9iuQ==
From: Niklas Cassel <cassel@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	Terrence Adams <tadamsjr@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 5/5] scsi: pm80xx: Use pm80xx_get_local_phy_id() to access phy array
Date: Wed, 13 Aug 2025 13:41:12 +0200
Message-ID: <20250813114107.916919-12-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813114107.916919-7-cassel@kernel.org>
References: <20250813114107.916919-7-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1731; i=cassel@kernel.org; h=from:subject; bh=OYcm3fFsjegdehQYQPjjDBcdAGNvTg4kFT7VPo5U9Do=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDLmVN4s75v8eGGhbMo5l7kt30puRfhVnK6tK1y4Ud7g6 vTPsVG5HaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZjIo2BGhuaEa+VfD0sZ7DJl maEsmT/9Vkzxi569bWeNIp0v88xOfMPIsOziS+tfT6csOrT5zO/o5RMfzbnMEr/8r9vsR5lLS4o iXrIDAA==
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

While the current code is perfectly fine (because we verify that the
device is directly attached before using attached_phy to index the
pm8001_ha->phy array), let's use the pm80xx_get_local_phy_id() helper
anyway, to reduce the chance that someone will copy paste this pattern to
other parts of the driver.

Note that in this specific case, we still need to keep the check that the
device is not behind an expander, because we do not want to clear
attached_phy of the expander if a device behind the expander disappears
(as that would disable all the other devices behind the expander).

However, if it is the expander itself that disappears, attached_phy will
be cleared, just like it would for any other directly attached device.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index b3bd61827ad6..96ecc5e63f53 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -782,8 +782,11 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 		 * The phy array only contains local phys. Thus, we cannot clear
 		 * phy_attached for a device behind an expander.
 		 */
-		if (!(parent_dev && dev_is_expander(parent_dev->dev_type)))
-			pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
+		if (!(parent_dev && dev_is_expander(parent_dev->dev_type))) {
+			u32 phy_id = pm80xx_get_local_phy_id(dev);
+
+			pm8001_ha->phy[phy_id].phy_attached = 0;
+		}
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
-- 
2.50.1

