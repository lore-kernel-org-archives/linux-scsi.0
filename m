Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3BE1C32FF;
	Tue, 28 Jan 2025 16:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738082829; cv=none; b=FRdSijxYsDtiE041Mrw4kcgGH8HBVHexEptXwncDquwKIN9xbT95KjGuOWmwgmdcv1+5udlTrXF64FJ0QpprUewmGFF41friQ3STp1//JNHgqDBBCJDhJnHHUQyB4ssMZSh2BuJG9Cf7cInEPQ29CYgbmhE4a3Q/iMM3lN8BY3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738082829; c=relaxed/simple;
	bh=QqjVeGr1MoVChAKZX8OzkSEy2DnqX3wzs/volw4OQEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZYb2U+d/IvXe6KQ6c409En/QL/wzEHYQM8IxJCXBqHOGvezpchCjdvRg2bAaOZVVhum2HAHw7YotlKpRI6/x947oRU6OmRuera2aVFTYnHk4kGSPPXxfI6vpEzoBjsXq8CmL9irPTUznrKdl5C83f1ePMsB2sH2zrAFjFC9zrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VupFIZfU; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VupFIZfU"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e53c9035003so9554167276.2;
        Tue, 28 Jan 2025 08:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738082827; x=1738687627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=phT1rR/004GFOSkR2R9bhedH2F13EDnwojW4EsaMgmU=;
        b=VupFIZfUwMbwFk74wwHf9dyGZhYxFmb3t2fpne8wCvc/GuvdxKA2R07bZ16o8FAzl5
         zC6GC9qB2eRxeYdsKdcQc28dvOjp1ZgjrTuazFxcW8Q0y7WDbm9t+1C6VcmYwDTe8h9U
         miMcagI1nT9XV2b32JVb2p5oA5w+vwLT+nOf9wjP0UFbQkuLxMqJFerkO+KBm+p1Sdxr
         Ovu99BLB+DdfJmGddOhEY13YcezMCxw7poZUACSe+ttr8cXxOsk5aeTaBMNQTNE2XUAU
         6088aMTx8OLVJvnPnjphV9HS+r9oN9OoL9vCnWO8WmXsbxXI6n8T2yi2rs9HBS/QKXAC
         C1fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738082827; x=1738687627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=phT1rR/004GFOSkR2R9bhedH2F13EDnwojW4EsaMgmU=;
        b=rRyvT7Dtn4FDjdm1mElUVEaKFPbCD/v3oCu1gGRubFpg8J5i4GY7TIiiBKukS988I1
         eyJfJtqtVjSjGY5nEXUHoG7F104R0OlFqOi4/zrZydvFzDzzthx//hit3ctUMD0CSwGD
         QoVV94Mm+UBVESw5SBQ/HwRmzB5gKzeHxamH2q1H+QmxDLyhjd4w7aJZz6/ojzf9nV6Z
         Xeq6CmHoEKjBqMYg2IWhro3Sa76ZB7AFVDr9u65uPpAragCi7xUpoEnq1JWV+QoR3P3j
         vXvzvJu9ZLIits1cAnP9yDGFlwmtzxcr3xeeqjFGGbLQJ9q7D4LZ2ybbRUwKKnFKa2Dk
         prKw==
X-Forwarded-Encrypted: i=1; AJvYcCWEzP/xbyeQNiaQb5oxMeiWCtHU+3IxhQUJaluMNm2u6tyvsfZHPebuTtxMHM1WiACCcVA0hvZUl/3GR6U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfQgCz5nRuU9IGdrN2UayF0Yc6dh/lrwJwlL2j1Jn2zKkeORWG
	BsHUPK4/Tvstyuxv3DicPnenTKgkhyfdw2CjAalgZpYNfT5FQtLUkkiClyzX
X-Gm-Gg: ASbGnctsuK7Nqfw5dUKg6JT0prjAZyAL9eKTb/QXoVzGoqNTrLG5HGgtQji18Mhe0Va
	AUGzh8tX5qG7r3IJ5qsjCDeUdVe2ky3vJB3Yqd4jxaaUPwEi/78z+ODlyXX1TKXcW/xO+TU35CE
	FEesLMx8zn7Vr/9R3g7ZHEr92Y2c1vo9J4ca+KZ5oAJmOePfMF0bA8yFQ6bD/oOT0+lkpju1IZn
	TJFCYhlbg9bMp+bnuHFuhZ7uXgs4J2SqGWlmdLsoHRm9AQ8JPVeFxq5OyftNSAyrPLY6QNeitwG
	qy9tiwZ0j3+NQYoY1QClUJMzwnXdRmK5jKfAR5u6yOSQnXbOWjAPXBE5lAHHFg==
X-Google-Smtp-Source: AGHT+IGMN85pL3nKeabmi2vQlqHPoV7QJEJILQG4CftpyG1sVE3UCGmbhZI7bM70JI8gWQuaVgaTHA==
X-Received: by 2002:a05:690c:6f8e:b0:6ef:7dde:bdef with SMTP id 00721157ae682-6f6eb9058b0mr348795307b3.23.1738082827162;
        Tue, 28 Jan 2025 08:47:07 -0800 (PST)
Received: from localhost (c-73-224-175-84.hsd1.fl.comcast.net. [73.224.175.84])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6f757877303sm19392737b3.6.2025.01.28.08.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 08:47:06 -0800 (PST)
From: Yury Norov <yury.norov@gmail.com>
To: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Christoph Hellwig <hch@lst.de>,
	Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 11/13] scsi: lpfc: rework lpfc_next_{online,present}_cpu()
Date: Tue, 28 Jan 2025 11:46:40 -0500
Message-ID: <20250128164646.4009-12-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250128164646.4009-1-yury.norov@gmail.com>
References: <20250128164646.4009-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

lpfc_next_online_cpu() opencodes cpumask_next_and_wrap() by using
a for-loop. Use it and make the lpfc_next_online_cpu() a plain
one-liner.

While there, rework lpfc_next_present_cpu() similarly. Notice that
cpumask_next() followed by cpumask_first() in the worst case of an
empty mask may traverse the mask twice. Cpumask_next_wrap() takes
care of that correctly.

Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index e5a9c5a323f8..62438e84e52a 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1715,18 +1715,12 @@ lpfc_phba_elsring(struct lpfc_hba *phba)
  * Note: If no valid cpu found, then nr_cpu_ids is returned.
  *
  **/
-static inline unsigned int
+static __always_inline unsigned int
 lpfc_next_online_cpu(const struct cpumask *mask, unsigned int start)
 {
-	unsigned int cpu_it;
-
-	for_each_cpu_wrap(cpu_it, mask, start) {
-		if (cpu_online(cpu_it))
-			break;
-	}
-
-	return cpu_it;
+	return cpumask_next_and_wrap(start, mask, cpu_online_mask);
 }
+
 /**
  * lpfc_next_present_cpu - Finds next present CPU after n
  * @n: the cpu prior to search
@@ -1734,16 +1728,9 @@ lpfc_next_online_cpu(const struct cpumask *mask, unsigned int start)
  * Note: If no next present cpu, then fallback to first present cpu.
  *
  **/
-static inline unsigned int lpfc_next_present_cpu(int n)
+static __always_inline unsigned int lpfc_next_present_cpu(int n)
 {
-	unsigned int cpu;
-
-	cpu = cpumask_next(n, cpu_present_mask);
-
-	if (cpu >= nr_cpu_ids)
-		cpu = cpumask_first(cpu_present_mask);
-
-	return cpu;
+	return cpumask_next_wrap(n, cpu_present_mask);
 }
 
 /**
-- 
2.43.0

