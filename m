Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B8948CD52
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 23:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791503662; cv=none; b=l/y8QGVt0+JdhWrL6ww0cVm/fFUu+MEv7a0U8ZR4AmiigQdobJSLO0MMQBXWcElFlaM/BRaKdSNRM6ddvadjv0Yct6pK2X8NpqplRMr8LpNyybT8o4c8eoJ48kaGQCV/1g3mKrTPd8g/FKfSqHwC7+HRoRKKSZcPTkUKnsWdg8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791503662; c=relaxed/simple;
	bh=m3CYGZJNAhzPMUFu7GeaoaRd2e9cCQEQ06WCsBTVa/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmmYG4Xwmwjk9iNO8Exq1VWno2Wjsm+LubWAF/o62WuIqpQCXkJoRn6mFGJtxOCjq8WjZbFK19xrpz+WJOp+UgtAoOxOWZ4rLiZ7SycBEyf1KQm/kso9V+5JslUxqC+Lfn2/hsXrHYz5Y6KQYll41nE/YQZp6Nyr3EWMSkA0UJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qpUrz+cM; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qpUrz+cM"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-91054f9d26eso2706376d6.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 16:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791503659; x=1792108459; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6nrBGseu0RKze7XYtGVGT/Lh66doqcnrdj9NzSKYKos=;
        b=qpUrz+cMh1tbCixyeRQC6Jh+TqgqLlrqXam9ksowDply8tX3+XLMGSKcjrutA7meja
         7XPRQGVrdZP5er16xkTfb2vZ6jtdemD2qZwmmIvyQYVWIlaGEmpbonmjLv5rM4F8BKuI
         JUnjG86pMIwJU5NmLrGxhBwFyCYtMmCcS/4aN9Er44IZHFjiydePfmCtl5yYhg9uIUD5
         Hnvb9erTTGukp2NzYIFSN4SJ8hrCMajUuiTdFWqcSLwGG28zHke+FiXYne6JKCeCdWTN
         CH4j7O7qpb2DydfHqwk31ZfQbHtQ6HNMAvHsP2hRKrT4DCX0ETgh5/V5wT6QilIJ6XMe
         dpoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791503659; x=1792108459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6nrBGseu0RKze7XYtGVGT/Lh66doqcnrdj9NzSKYKos=;
        b=lSiV77W8KN3IOnKVHpt92DHSri3cS4yRVf1Tp7auc3k82qjk3Ec8uF7yaLop5qpAKD
         P+yH1gUrmQgfsVX4BmTLXyRQQvgogbzgjsXNuoynk22n6bTllCepBdSOpi6IP4XnPghT
         F6c6qu6ZthzfZSF9j2sfBlSNWiER2IHLra0awg9E8dFKsXI1Hk2lhdjpXxCohf7Fstdq
         +osjd5ebZvUFvixBOasW9goSfmgbsDX1KYs1OSgRdd/FgserEQ8BCb7uBOve4vYgcA9G
         l4BdsfmphtpS3i4oEBnJ/94kFvemFoPoUi+GihZMNikdahLvWxuETTBvKGV9sCrrJC93
         tkMg==
X-Forwarded-Encrypted: i=1; AKwUvBw409lcgLBQdtIzdMU5naZpAVtlMYOOeNmz0m5/3CFAFaOLL3OA428S/4/LzmjSryS+mJf0uUuzsQh3@vger.kernel.org
X-Gm-Message-State: AFq9FYJAJyHXWcrzE/S7gPjhUf0lAuHYQ5Gpr+JrLoEk9ojI73rkqfoq
	16uVXQjkzBawNqJynS/9QlE7UzP+rgE57j2ID5Xnc3a77NEP8ZoAHrzz
X-Gm-Gg: AYBFou3xlXg/7cW40KpNJiIMMGgQJR8FihRmeiJzJ5iA/seyW/RKSFpGU08FPu96FXL
	ATGYzRTwmrdYbcYHCjEq8HGqcSqMD1d3I7ef7Ef/y3cE6gsP+E5OrhsmwpVVIJyswAt4J12WZts
	nESiJsjSjn2MskkTPIQvq5Z43ckz5mo67Nni6nOxe+x+UQ5FmTvOUPBX2dFTOn7tTKQJRfLQfVI
	eFqA2fQgJA3NGPdbCN1qXwtTo4TflJe0h52Xf+5iyywOPEpIqvGhouxMHtOENINL5MRZZZ+/KZv
	4QBhMFbqeQXFjVCQ73G5w8d3m++3kd0YiDGcg8Cxv9U7JDvfHiua38eSSV10jvc3lL+dOM9MtA4
	+wzmEVmgpQTjTn7yXRG0bHTD+vnPzck+5DfTisd5L/gzWKwV+GLUgbovk841gprVDYgvv9Whseh
	cJHqCOnXPw4HQxMER8IRRzRDIsqTGaZSXh8xrFymEZ9V4WX1ZvV+mjW4oG7G73uHayv630v53L5
	UP75pvshaKLf6PHE618n7tKTgMnbOSE+2ZVd6vA2xZgIdJqELnfhcf/oKUFQKcBcjwAn1yLojl7
	P8EqFu7kilVgH9SA5NQ=
X-Received: by 2002:ad4:5767:0:b0:919:59e6:f517 with SMTP id 6a1803df08f44-91b557c3a96mr7022486d6.5.1791503659259;
        Thu, 08 Oct 2026 16:54:19 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b550e6609sm3451586d6.43.2026.10.08.16.54.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 16:54:18 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v3 2/3] scsi: target: rd: Release protection space on allocation failure
Date: Thu,  8 Oct 2026 19:54:08 -0400
Message-ID: <20261008235411.56641-3-sanan.hasanou@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20261008235411.56641-1-sanan.hasanou@gmail.com>
References: <20261008235411.56641-1-sanan.hasanou@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sanan Hasanov <sanan.hasanov@ucf.edu>

When rd_allocate_sgl_table() fails, rd_build_prot_space() returns the
error but leaves the partially populated sg_prot_array in place.
pi_prot_type_store() then restores the previous protection type without
calling ->free_prot(), so the pages and scatterlists allocated so far
stay attached to the device. If the user writes pi_prot_type again,
rd_build_prot_space() overwrites sg_prot_array and the earlier
allocation is leaked.

Release the protection space before returning the error, as
rd_configure_device() already does for the data space.

Fixes: d7e8eb5d9216 ("target/rd: Add support for protection SGL setup + release")
Signed-off-by: Sanan Hasanov <sanan.hasanov@ucf.edu>
---
 drivers/target/target_core_rd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 97c63b122..b73bdd733 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -263,8 +263,10 @@ static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length, int block
 	rd_dev->sg_prot_count = sg_tables;
 
 	rc = rd_allocate_sgl_table(rd_dev, sg_table, total_sg_needed, 0xff);
-	if (rc)
+	if (rc) {
+		rd_release_prot_space(rd_dev);
 		return rc;
+	}
 
 	pr_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u prot space of"
 		 " %u pages in %u tables\n", rd_dev->rd_host->rd_host_id,
-- 
2.48.1

