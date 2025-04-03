Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C8225BAA1;
	Thu,  3 Apr 2025 19:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743707019; cv=none; b=b6k9FmOixN81dVTyp7Abcwzlm8vIIgAYqTIzjhl17e5ELdSjsFcMkPJCuo84mkvSy2bX1KOBPZuQ0x8/iIgw2VGiOJeMs2Kg9vTGtwJjoOKpK2ZpxbkgAP4uUufrNXwEgyTKU8Hqg145Xp8Y9Gqclrkj6vKDBajiUWrd7bs+DOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743707019; c=relaxed/simple;
	bh=iO/N8IMTr9+uTFA5oEozU7wKO/TCzO4fowmKmdEbPqM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YzvdhSsUSXrvwYjY9WcPNCQwHzxQDDYgnHihJI84CrurrwIs6IpESW0r2sHwV3tLx8KNlkwQf559OLM1RZwygr75oYPXwxyok3wWwVOkypb1837lSrYAmdICNHQLvOaet2r2JFl6LSXh69hQG3q6ek1GRNmF49LFu2CiGk0gI4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K8P7hVOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K8P7hVOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6691AC4CEE8;
	Thu,  3 Apr 2025 19:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743707019;
	bh=iO/N8IMTr9+uTFA5oEozU7wKO/TCzO4fowmKmdEbPqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8P7hVOyiiVf/Jvf/HMpJPbo0g9QT33GciZFs6BZ5J19gFOxnly1C3xztyGc1d5y3
	 UWkNL8HzoBxz9OPvzexqt26/0KXOzujxZElyP6RYEyFsdMSiLnEaLuLGfUdoWYc/v5
	 1ceyxbf/4zOfZmEm3l664kh/z/9KdSMgNg0oP2HTEFqtKE3q7rEtSGIuRQKJla8v1a
	 26pLXddL9x6DzQ4h3GuLQ9HS8n4zeGdqQ0YUwKrT7uQRQzN1qhJSZxR4U1uJ2tRtcW
	 gEdcs6iOYkUT94qqYH9wbG5P3D/qQU5OM3mzcwY2hgtYqS/HJVsscDXjgIHO5kBBdZ
	 FZequc6vPS5KA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 38/54] scsi: st: Fix array overflow in st_setup()
Date: Thu,  3 Apr 2025 15:01:53 -0400
Message-Id: <20250403190209.2675485-38-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250403190209.2675485-1-sashal@kernel.org>
References: <20250403190209.2675485-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14
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
index ebbd50ec0cda5..344e4da336bb5 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4122,7 +4122,7 @@ static void validate_options(void)
  */
 static int __init st_setup(char *str)
 {
-	int i, len, ints[5];
+	int i, len, ints[ARRAY_SIZE(parms) + 1];
 	char *stp;
 
 	stp = get_options(str, ARRAY_SIZE(ints), ints);
-- 
2.39.5

