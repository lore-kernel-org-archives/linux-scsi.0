Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7499328C5CD;
	Thu,  3 Apr 2025 19:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743707460; cv=none; b=dH7Fh4zgph/vUjIHHpCZNhMI8/CJA+y18tzFEzcOVftRA22v/42XxPhtn1MeWWYwU0eJh3oG3kwi5Vavjzmc55k0vhfxy4aqSsXzwjpj2SwHi25MnMSYhsX2rAmYddeLqfXV+mEQEPCEhFRKXLeU4nu4yX8mqmH5H4WdSCiV1WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743707460; c=relaxed/simple;
	bh=3yIRUbe0hMIpYYr+v/4lvN42VzxTKWRdxPDj7VKRCmU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uXvEKB/OMQj4akALaOwfrtAGkwIWqv8emA19jEZU798qi6Tcdp6E/3ttuaJMlVOtn5vtQ1LuhRCmAyDmejKU2k8OSmSEGwN9Ycww0AZTDDay4tuVNTlv01LWd4XUD8uYm1mAp4qYxde7QfWmX+bAGjfpXX4XDimNkFsJLjMqvnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qg00Y+ts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qg00Y+ts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C1FC4CEEA;
	Thu,  3 Apr 2025 19:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743707460;
	bh=3yIRUbe0hMIpYYr+v/4lvN42VzxTKWRdxPDj7VKRCmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qg00Y+tsZSGNupMzlbROiGcrgUAtVlzAHU0KjVUPS7fsicR7Ghl6B+H7XrtM8ysMk
	 4YPdQn5DAoVcpcdqEf1ktkCCDbCLlDOT2QBWrVHDUHefHUzAJhj1naEYSrt5e85lyt
	 cmUpU4WiU0gm9KDBWckjs/NN1tp35RNuVEkDPRUTISsJbmChm7XwvMbEd+MPfC9g9/
	 8VF3j3EP2lE0XwGvXX56yseAuPCcoM0itBv18LpCBCfq2p/XE8P3F7Hre0IALJ23/I
	 akK7dTrUWHUd9d/BkRqBPDuDqStDl+hiiiFOWIH8YKW9z/IbQiAkjWCb4s/7zbGcac
	 Wk7yphH/89xPg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/14] scsi: st: Fix array overflow in st_setup()
Date: Thu,  3 Apr 2025 15:10:32 -0400
Message-Id: <20250403191036.2678799-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250403191036.2678799-1-sashal@kernel.org>
References: <20250403191036.2678799-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.291
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
index 49e149d28954a..2b5e3e2ba3b8b 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4124,7 +4124,7 @@ static void validate_options(void)
  */
 static int __init st_setup(char *str)
 {
-	int i, len, ints[5];
+	int i, len, ints[ARRAY_SIZE(parms) + 1];
 	char *stp;
 
 	stp = get_options(str, ARRAY_SIZE(ints), ints);
-- 
2.39.5

