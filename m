Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE79266F14;
	Thu,  3 Apr 2025 19:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743707128; cv=none; b=RfdfPTi1K7O7Zg0izV1ke8siRoxpJGIzotLtKlhqJ66kdPtn6HEBbWLEVW1b5tA9SaI4cLaXOwqNYcC9VmqBBxz+t1CdCO9kEFxefI1CvX+n4cIRifS+8LxbkotG9+PY39Vx3Oo5d01kuXhiTzv+EKs3VkB8Z2xgsB+8iqlkHfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743707128; c=relaxed/simple;
	bh=iO/N8IMTr9+uTFA5oEozU7wKO/TCzO4fowmKmdEbPqM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tgyrc64spXy6P0l1e5TeTzSnh238iUcNg7fbeX/ZIB81j1mqjVgJ9iLBkWDuN5kzVgvZeJKuzjajspu8WswoUmQdUA+gXvveszp+1Vxkt+CSpw0bgamvZS3k2VhwN1NVVgIXjJ+SJCETPKXCxS8YAS0H0Or7GH1bQwnA0TO7iW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rqZyr6fd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rqZyr6fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3250C4CEE3;
	Thu,  3 Apr 2025 19:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743707127;
	bh=iO/N8IMTr9+uTFA5oEozU7wKO/TCzO4fowmKmdEbPqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqZyr6fdDjwjSauTn/ijHvQYGquyBiadJSw1ywxQ0l36AhcCVmVlDiDyua/6iM3Jh
	 vsUGXgaHSYpOPjaRwqX6gWC5aMdK1lKugLXzzn7d8BM2jADGroRpm8P8W7GhqIRjT3
	 /eq9cSgD6ZTLIKFW8VSYg+QhA3W6SidQbGKmSv8vY+Y57I+gVTmpiWnwaM1wSFL3qO
	 3GPRSakPwBNCfxsdLKkdIW8jbi6Z/XVl6mgWFxFQAJQqzcedtvbFQrPhQS8L3RrTuT
	 xTVtn2aYn6q2WrC/RNsEcjFf0yo1q/MWBwkE3PsIMHUdEmbCqjeF63VTY6491O7AKG
	 fq/VZKohvIVGg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.13 34/49] scsi: st: Fix array overflow in st_setup()
Date: Thu,  3 Apr 2025 15:03:53 -0400
Message-Id: <20250403190408.2676344-34-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250403190408.2676344-1-sashal@kernel.org>
References: <20250403190408.2676344-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.13.9
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

