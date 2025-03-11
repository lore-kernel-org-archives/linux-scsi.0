Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB962528FD
	for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2025 11:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741692370; cv=none; b=eqHbZy0/3MIH0MiF0cvdZYmlMB94TFlCMrkWewZchFPO95/EnOXhv98x7/pLcCHPiMZMi8RKdiF2+kUu0c1dMzcUTc1r6vScHF5tx3AT9xaNvmO61CC4989EE/MEdudMw3riaouTM3v+sr6VZFr/4/rnxzcn4cTZdYWMx9JzvKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741692370; c=relaxed/simple;
	bh=DE5T2QsG5WYebEaC+jNTJ30HX5kPSVz4+vy9ZE9bzno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OEsqSDQbgWnhFeC8Y0budBj5GDGe2/DhG7xtlZX0Nk81W6cQWdJfIx0OULCgcvIg65Qpr8F75hC7FBIF5mhZbKJ8oM/IBO8b8g4zcEUm7+HxgNVfDbbBGV5rqdMbM45eL54nY9TnVrPxE/fvxlLAGfO0X4HE4Zkv3zAXpw9DHo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=pKbR3Z68; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="pKbR3Z68"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:feedback-id:from:to:cc:reply-to:subject:
	 date:in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=nFv2GKPdt8bvwUocbCLDdIpW0lqr47VBAC2RIQAaOiE=;
	b=pKbR3Z68gFekKUm2P4bhPaMjQf9fC0KTt71NFTy+cLkX6H5EHa1qUYbI2Jut0sqvrwBHHVJdqi/4c
	 NTnFGh2VR/W2zi5tQhRNWxBdys/1hpCUrQMKc7NlJr3o0p9XeGh5J8waafUP/nYbHUjNR2y0fqHKZF
	 PTtTMVtLBk9cf9ZJel+tuQyKcc2A6s8jIkNCJk9wnwvW3sCBaCfyKRniA4FI+fhVO87tyxLnya+Bz1
	 9r0Z09aRtnkc1y3c00U43tU62CDW5dSR7bTnfQOI9HW/yUNoS3irvTWuLRFfR5JxUNWYrDNs/ncUqy
	 vxmk8scQvvhWwM7ziPus2ze9hvQNXgA==
Feedback-ID: 5c3835a5:74d1b5:smtpa:elisa
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id 9e04d119-fe6b-11ef-83bd-005056bdf889;
	Tue, 11 Mar 2025 13:26:03 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	jmeneghi@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	Chenyuan Yang <chenyuan0y@gmail.com>
Subject: [PATCH 1/3] scsi: st: Fix array overflow in st_setup()
Date: Tue, 11 Mar 2025 13:25:14 +0200
Message-ID: <20250311112516.5548-2-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311112516.5548-1-Kai.Makisara@kolumbus.fi>
References: <20250311112516.5548-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Change the array size to follow parms size instead of a fixed value.

Reported-by: Chenyuan Yang <chenyuan0y@gmail.com>
Closes: https://lore.kernel.org/linux-scsi/CALGdzuoubbra4xKOJcsyThdk5Y1BrAmZs==wbqjbkAgmKS39Aw@mail.gmail.com/
Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 85867120c8a9..0d020cb1ffcd 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4157,7 +4157,7 @@ static void validate_options(void)
  */
 static int __init st_setup(char *str)
 {
-	int i, len, ints[5];
+	int i, len, ints[ARRAY_SIZE(parms)+1];
 	char *stp;
 
 	stp = get_options(str, ARRAY_SIZE(ints), ints);
-- 
2.43.0

