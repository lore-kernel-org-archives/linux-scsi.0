Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F4029DB91;
	Thu,  3 Apr 2025 19:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743707394; cv=none; b=GWVlwy455jaRqqMbKtPMt9OQIWMbpWQHanjFnEDwqSoQomarihyM9lLYYNb59D9wswNDaJ1rbBkgXy2A561Otj6WfKF0BScO9H9D1MtIuHI0F01njNvLuvCvmePuTgevKbOMlgFLEa5/FW9x5W+I8FKVZ4wLv7GrRYWJ/KDMojM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743707394; c=relaxed/simple;
	bh=IBfMB9cJ5OXUmoCp0wVcbbAfq2SiLFxAFew3z0+FGbs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fs6j4nAd9V8b17Br0QD4dAJSul5uf7kTw0jyLD1cyMbLjz2ACOCztWtji4NxGxg8S3vBAWZLhkviL7rt329vSYD7giRM+hlOWddRg7CNt44/VKvsEE5syGq2kys2L1CNo1nubWOSu7tukQIeQw0tL8z4FntZ3Yb9a/7191cFZD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+RpAYE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+RpAYE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE00C4CEE9;
	Thu,  3 Apr 2025 19:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743707392;
	bh=IBfMB9cJ5OXUmoCp0wVcbbAfq2SiLFxAFew3z0+FGbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+RpAYE5g0BkDlAR4r7M9Nc5MWMJrAz7vSEDtCuFvUUlD0/eGXJkI/fRoAtVZI9w5
	 AO/GQyrAvawrUgP+xHe3WRvYzjK9EZ+MxbB62v3alDJXdKDofc4XyFHFdXPTN1wQ1I
	 RFY16vr3ewOJUJYaFCdoWBfO1+KsjMCpRYAJSWFpQ6vJwTvFypxffiwQRmh3qBhZ84
	 RfY1lhHdFYMLkkoEtHmhiCKTsqNajrVk1v6uF6YELEOqu2LjgfqtGIMOK3lVWsHKTn
	 mgEDw/B+iRQzy8w4x+gOo6OiUppkn/OtLWj+pizELJlXKGkAYv5+FfrVKKatkHqWf5
	 ab/PAOiACpM4Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 12/16] scsi: st: Fix array overflow in st_setup()
Date: Thu,  3 Apr 2025 15:09:20 -0400
Message-Id: <20250403190924.2678291-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250403190924.2678291-1-sashal@kernel.org>
References: <20250403190924.2678291-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.179
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
index 1551d533c7196..956b3b9c5aad5 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4109,7 +4109,7 @@ static void validate_options(void)
  */
 static int __init st_setup(char *str)
 {
-	int i, len, ints[5];
+	int i, len, ints[ARRAY_SIZE(parms) + 1];
 	char *stp;
 
 	stp = get_options(str, ARRAY_SIZE(ints), ints);
-- 
2.39.5

