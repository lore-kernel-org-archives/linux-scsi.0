Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3873725A2B6;
	Thu,  3 Apr 2025 19:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743707354; cv=none; b=WP5273ofbwU2QT8VxvyAaWMHXxy4apazdpQUdCPiyoNVm0l3fsY1yThvgaG+z9KaCiqHGh7e+Nk/sS0e/4ymSNbYyvvY41o9HeRRCnffH0EKEosv3KEpAb+qWiRq/3w3FNW3J0f0inJeLR5ZmfkM5XHyxJtiZ7kk04I6uavnfQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743707354; c=relaxed/simple;
	bh=G8uLnP8HGvNMLFX8l3YR2gDARSsgRd7Y494IOYK4GxU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=efitTO747u7vE1wwjqqqv7i7WIuJ9DJrMfE4hsz6+8as1asud6vlm4c6TAy1bRUkADixlfmy7VZeSMj1mm5QEoxoRyBaOLpdkAQhnYk3zWyNMUJ9MSiW4ejqx570b3cV0/tkuv8O6rYj2Qof35xcOeAAk7NBvxstvU52nuYebdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5CszjiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5CszjiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30845C4CEE8;
	Thu,  3 Apr 2025 19:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743707354;
	bh=G8uLnP8HGvNMLFX8l3YR2gDARSsgRd7Y494IOYK4GxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5CszjiUt/EaJN8jcaD/lmavP2pJlaAIgQRfbImB2RX8KLvUJUClYSkF0rqVUq3K9
	 U+kxeRNSUG7m5CNt5N+oP7Vit33axub4idB/qtp3+gMZW/zBaA4Z8KlT8j5jTZa/CF
	 yFK5Rdoj9iJcFAJQXxDMk0VCILPucfBgPiVunsNyuO8TxCcU9SEShpqmLeWYc8x9kc
	 bo5dMxaSgvUQSAM8N4KJiyGG5x59X0QM+LE+3Wn8SsjWZkGq9k0rfoHHzNJsi+Uo0I
	 B77kRpM4rshG5WbyGOhLfu1aeE9GY3aDNK2fKxmSUNBuKiD08/h1/KOBAvHgU94TXb
	 P77N+gy21OFtw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 13/18] scsi: st: Fix array overflow in st_setup()
Date: Thu,  3 Apr 2025 15:08:39 -0400
Message-Id: <20250403190845.2678025-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250403190845.2678025-1-sashal@kernel.org>
References: <20250403190845.2678025-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.132
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
index b3caa3b9722d1..7f107be344236 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4112,7 +4112,7 @@ static void validate_options(void)
  */
 static int __init st_setup(char *str)
 {
-	int i, len, ints[5];
+	int i, len, ints[ARRAY_SIZE(parms) + 1];
 	char *stp;
 
 	stp = get_options(str, ARRAY_SIZE(ints), ints);
-- 
2.39.5

