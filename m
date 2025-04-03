Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2748F284B26;
	Thu,  3 Apr 2025 19:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743707314; cv=none; b=mqJ+UHMVE0iOV6U1Dks5JhQdhNh91dsBrXQrFIxRm1l3Ny26h3NpsvPZt0GjdSQzg2tl5GnauaGH6N+Wk1zm/2b1orN+8LQNH4cGsc0hXQAddbVA5Or44cN1CgKcK6LTcYB5U/GULRp1jbYXfu58MiSocIOm0YyQMIl2TeNqbKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743707314; c=relaxed/simple;
	bh=Fbf9TFjCwvdpKswkcsJmq061YakhBha2JaLtmLXcIJg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QpOXNz8O4pZPyk2C/ApBHbX4uhXa/ucZK4HVd88QLOG/hMpq2h5owki7bFAv2gK6zvTcujfNuT/06mUfuF3AkNd4AK8BbPfyM+8YrBidl9kxe5qcVLfEiwD/QKQ9yP4mKqxIygHKqOwPx5fYCKxnWpMBUUjvJsylUKTg0HGzdfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n6vm2yjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n6vm2yjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA60C4CEEA;
	Thu,  3 Apr 2025 19:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743707314;
	bh=Fbf9TFjCwvdpKswkcsJmq061YakhBha2JaLtmLXcIJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6vm2yjcdnKYVFahTnb+5OzNCiTj8skRKM46Id9xeIT9oK5WiPRfskoIOWkYfJ3Jb
	 PVhOrtO+7OVp0MdRu0h6W7zZOM9why9l2YPOUhs1aJhR+4pzALoJBScdN6ElLlVdIY
	 hm0Zal1S26devLVPF2pEDu+UhZbq4cJUbxYUtuwptE+H42u0SurNrYUQcj+uj2Q+rn
	 BPLJrHss6QHEARlfB3/MGCdXgwisg13i/x/+BL0iPu2RhxtZfTbYrA2QVnBiwnH3u9
	 QowrKL/rIsj9EalEuXRrkiNEbMEh/izcoYeGg5Br7GR8U+etg937cGMkTM8YNSP2/1
	 bb4lp89uSovsQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 21/26] scsi: st: Fix array overflow in st_setup()
Date: Thu,  3 Apr 2025 15:07:40 -0400
Message-Id: <20250403190745.2677620-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250403190745.2677620-1-sashal@kernel.org>
References: <20250403190745.2677620-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.85
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
index bdbe94f30f070..900322bad4f3b 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4120,7 +4120,7 @@ static void validate_options(void)
  */
 static int __init st_setup(char *str)
 {
-	int i, len, ints[5];
+	int i, len, ints[ARRAY_SIZE(parms) + 1];
 	char *stp;
 
 	stp = get_options(str, ARRAY_SIZE(ints), ints);
-- 
2.39.5

