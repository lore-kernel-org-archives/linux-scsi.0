Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A344553ECF5
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 16:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791995072; cv=none; b=nfV24d6ssp+qHgwL0tDiyJjOcnA1e/TmcNyiACxogeQqvoaHVmokEO7qkhyexTAOKy7Fiu+2KMpW+Jw3v1m2DoUGVqISmZQoaI9f+mqdlpTC/rLQyl2lBkNJNRrnstayaKYT88QFLnqzvWXJ8X2RehDzA4iCMQNStDjHiHHlXCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791995072; c=relaxed/simple;
	bh=WWTcqcrYuK6IbdrjMRhsuwFkgDt4+Cy7tBLo38z8uik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qG1q8RcHGiEL2/OCoqh/J/VTuGIhk+zNzsGScypb+m/1UOGPaCseSZYk70x1BU7WQcmi3rkOgJ4j3FPh71Vgqd/WAuGlFusSxhS4xBaf3GmvfFx3krACmhFW0eOt89BADj27fKT9jtoIu6bflw1/Psm5HG1L1oHNPa7sdzajUpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=fQFUIZni; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="fQFUIZni"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-33c2520ad38so9834266eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 09:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791995070; x=1792599870; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cmaZjOlL7Z4YX68oXGeP0K0pl8aIA8E2Yu5c3A96tCc=;
        b=fQFUIZnisWl0fRn10/96qKL9rew8A+GWEuJPzbkW+dqhYpUoqzS34qkA+Yw0vvBEU/
         m7LxM9FGnXxXwsa4GOcpZ3On7q1ttDL8SuIV0KmGiYhfmNmkfNiENVt9NVcqKEm3TSxT
         QCm94QjlgctG+/UvpX0kbs1gtyq+lo3SAqoOhzPhoUYHt3LphgluhXf6r5vH6W+T3XsC
         XHn5y1sgH6dX7mu/930ZU1st0SgArJCrEd9lIbtERiamsuwk49ovZFXM8piTBFx+pqZn
         qoFHArw3pW2XKbImGbGF1nVNdXXVGHGKS1eghAft93Dpz28+3D5gG9WVk3agBKTpDbSP
         ge9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791995070; x=1792599870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cmaZjOlL7Z4YX68oXGeP0K0pl8aIA8E2Yu5c3A96tCc=;
        b=LmHyrx1AzeLDPjR2QL1ftocrev9bBnws5LWdK8UO/Zi1n0GaL7wNiguAofCv35IwSa
         VZluc2mzCtc8k07xy46K5N2drZFnwhaVV3RYVeC+t2K4By22s0Q7ba/WENemIu1WLtjF
         wbxsbnxXs1X/BXjeFKOmsXus3LIlHlctq1mfv5x2UEncKUGW3FGDMAdyjYSQ7omwhNc3
         YAnK7jWShF4t28qWvHXTvMX2hPPmDfDCk83AJLCeQ2ZnT/ufcpdCCizndl2SmgO0O8ep
         LjhiWRaO/6NJIjjlZoakTLI0E9pJA7+l0f5ZCGZJJe8+2CKKk39njik3HnZ2m8gQ6ubJ
         7ZLw==
X-Gm-Message-State: AFq9FYKq41xyFHAAiud0ilUft9DgFfjSEDrIPneTKE1jXYLGTBShTX3E
	Vqq2FuSFjL8Rirln7jKbUkIWJPKFbGbcCPKpij7Fsm03bLJBZburhXBlE+q7StIexY8=
X-Gm-Gg: AYBFou0jq1D1BSTyoJ0DoChrQOuyVomiEIkaAheI05JObZ0VJXXxP/O1FgdUO3Z0MZk
	yOS2hVsFBmg5NV+9Yn/kdiLTEPNn56iIO0OGjuScn97wZ7y5SOp1KXUDw2PQ2hzEzUh1R7dOl8+
	CKFxWwmRbBj17R+pAQCvhQ5peK72Fcx63rZZ5KIB2GCYycMuJw69rQdxwJrQHKJiITvbfUnxrv8
	ovEEJf+HJYYJ0OZdqWbq+iyd6iqrzZHGAeANOgFxWp5LhJoHOeHKDr9OCH+jq3kZcTX4ZufYInz
	TfWZY4RAOnN+FdYSFq/fjyJnCzqcd6S+Sn3Kg4568d1YxpA2Brcutf4YLcp6o8I86/Z+OKhcgdq
	8DVAqoUTzIFJgYA1dUaUt6DKZxmL6uGvyIwX7FRAYyzIb9qYg1eN3fEUAo5BIX1qMFZZbuMuXnu
	1YGB+zgTR1Q4ua/MYlZthDHJeF5+HW2cU0uY55sNFaO8x7NNnBMSVeiolc7ZLjHvXGFb2nfTr1b
	zcKkN+NCWSLPHF/xX0K
X-Received: by 2002:a05:7022:5f14:b0:168:6ad8:e89f with SMTP id a92af1059eb24-16a56c9dd9dmr21327771c88.3.1791995068875;
        Wed, 14 Oct 2026 09:24:28 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:1c49:61ee:8c8:3f4c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a1dd57d0sm48816685c88.8.2026.10.14.09.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 09:24:28 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v6 1/5] scsi: mvumi: bound the per-event parameter and sense dumps
Date: Thu, 15 Oct 2026 01:24:09 +0900
Message-ID: <20261014162413.3649841-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014162413.3649841-1-yhlee@isslab.korea.ac.kr>
References: <20261014162413.3649841-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mvumi_show_event() prints param_count u32 words from params[] and
sense_data_length bytes from sense_data[], but both counts come from the
firmware event (struct mvumi_driver_event) and are never checked against
the arrays, which hold four words and 30 bytes.  A firmware that reports
the maximum (255 each) makes the loops read far past the event and past
the 512-byte buffer the event block is allocated in, printing the result
to the kernel log.

Stop each loop at the size of its array.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index e70d336b4ab39..38a92f8c25f5b 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1361,7 +1361,8 @@ static void mvumi_show_event(struct mvumi_hba *mhba,
 	if (ptr->param_count) {
 		printk(KERN_WARNING "Event param(len 0x%x): ",
 						ptr->param_count);
-		for (i = 0; i < ptr->param_count; i++)
+		for (i = 0; i < ptr->param_count &&
+		     i < ARRAY_SIZE(ptr->params); i++)
 			printk(KERN_WARNING "0x%x ", ptr->params[i]);
 
 		printk(KERN_WARNING "\n");
@@ -1370,7 +1371,8 @@ static void mvumi_show_event(struct mvumi_hba *mhba,
 	if (ptr->sense_data_length) {
 		printk(KERN_WARNING "Event sense data(len 0x%x): ",
 						ptr->sense_data_length);
-		for (i = 0; i < ptr->sense_data_length; i++)
+		for (i = 0; i < ptr->sense_data_length &&
+		     i < sizeof(ptr->sense_data); i++)
 			printk(KERN_WARNING "0x%x ", ptr->sense_data[i]);
 		printk(KERN_WARNING "\n");
 	}
-- 
2.43.0

