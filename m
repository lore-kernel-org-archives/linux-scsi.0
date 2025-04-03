Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8192D3A7E;
	Thu,  3 Apr 2025 19:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743707427; cv=none; b=ZQirQ6j6Ei6SAO7RDzzqIYFOgHx8ZiuRQkvRoLQuhKVRLgdFD2aosoiDkSasOKhJhLkNPHfJG1gAVa4vbiIC7APcb8VZLsJTE8HPqTIyHqddwvVvZ0Nbcpc3IrsDZhPkS16igO5PCWXVPUKDJbBlqmxRBgKcCv371cLJ8gP7RRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743707427; c=relaxed/simple;
	bh=OYDNwu6lqiEdgQdVLiOOiEffqD+K+SGc18Ou35qwRkk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZtPJ0JSsTpgE5iUAfElvsGXi+PvgyRGEajqmkwLFajrciMPelIe0zASbZ8ZLlE2MuFPjJQRdbFtkW1/QXTlAId55s3gQRBDryFCMhJmwjveFMu52LGKCT689krqrL+uRq6TTcmvvmn7vsOpzHhvPn5KQ2ExdaVunQWUc5xhjydE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c9KFwTc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c9KFwTc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4644CC4CEE8;
	Thu,  3 Apr 2025 19:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743707427;
	bh=OYDNwu6lqiEdgQdVLiOOiEffqD+K+SGc18Ou35qwRkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9KFwTc/GHARIkDzsRXiUPEKClSVHak7SzdRJ5krD/kkRxyvXjfBXjv84MIqnv6ti
	 XqhacH4FBtYCAr6UauHTWDWDdBwqRtUwrbRv5c6PRGW/BnMTkT4ADP330CWIbiNlOV
	 c0Tbrq+iCclai3vVr7Qh1yODantffOgmcG3CXes8gD9KJTO6r+/We1ZQJmdxYnN+1W
	 61hkYUx3AMSZoJbuKUjjJgLO/oIc4KbIIHYMCRBpmrIgL2OzhFsTYcUatYhQE38txY
	 QECxIcGtk7YbJ1SVQ34EoBm3YfiENhlT3KbK5eENX3HfQCEyeLpRLUB+h4McVRyR5y
	 2l+WX/E/yUBtA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/15] scsi: st: Fix array overflow in st_setup()
Date: Thu,  3 Apr 2025 15:09:58 -0400
Message-Id: <20250403191002.2678588-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250403191002.2678588-1-sashal@kernel.org>
References: <20250403191002.2678588-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.235
Content-Transfer-Encoding: 8bit

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit a018d1cf990d0c339fe0e29b762ea5dc10567d67 ]

Change the array size to follow parms size instead of a fixed value.

Reported-by: Chenyuan Yang <chenyuan0y@gmail.com>
Closes: https://lore.kernel.org/linux-scsi/CALGdzuoubbra4xKOJcsyThdk5Y1BrAmZs==wbqjbkAgmKS39Aw@mail.gmail.com/
Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20250311112516.5548-2-Kai.Makisara@kolumbus.fi
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 3b819c6b15a56..465fe83b49e98 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4144,7 +4144,7 @@ static void validate_options(void)
  */
 static int __init st_setup(char *str)
 {
-	int i, len, ints[5];
+	int i, len, ints[ARRAY_SIZE(parms) + 1];
 	char *stp;
 
 	stp = get_options(str, ARRAY_SIZE(ints), ints);
-- 
2.39.5

