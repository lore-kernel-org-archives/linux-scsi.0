Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFEA324B33
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 23:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791503663; cv=none; b=a/mXOGasxeza+lDpBdjG2ChQmBYjsrX7nDH1ckLntLp5J4rljFa5F+eo9OeX7yLwIDkujfCptaJxmyIfnNIAeD1JkZNmqNsV/UctYpL1PljB4uspBjHzMzD/wTYj17jHA646EXfmC7wdicRBHXfoNSHUgG7sbRIXVcXw1u59er4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791503663; c=relaxed/simple;
	bh=u3mdpHm63NMciZUxyZb2tyyjBHYBnsglAuR31W/GzJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6Rgo0DfujSgV94XZwGLhQPixcNEsqU9BpjU/rhu0S/Ug8gDmyg8HcdBWcxmgjtZmKaBDUBbXJ1jn4qTAwMzivYe019N3hGQId2YPP0ahEtgnzWcMqZhszVOkvH5Q+DxXkaFvOebiomrjF7Ztf4W+G/SCoQOjCLm45VmR6htSs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VngPppVk; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VngPppVk"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5350e757063so3140841cf.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 16:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791503661; x=1792108461; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wogysuar2t6CIwSyb2S0JLKktNfZleR32/9OzbUkzlE=;
        b=VngPppVkXb2mu5RKY4vYhCsw6dDqNb728+i98WsmGyE5Zeemvaa4dRJZObWBjWru6O
         jhrInJu9iMOGjcyeXdGOukwXMnBONeaJf8JYIgFIblfg3JeiCtLZG6tUPrfqfJVaht1W
         BsDf8t+NBCpfFphT5rDmDkTdSwkGsuHRi5u3AN5EIsbdjrdMZCRTWdsbTCPgnXnNw3l/
         nrS88FBYiBchVWrZsNid1tEim+qudTANn0QyUbYMuRX1nVYiCC0vY6tLNfgqHQGkij1U
         OiDUBl+aqTQiS+uU5JcmzDeD8kIXRg/yMT1dnFV+DX2i14PN2rqIQ1moQSJjjgzq8sDD
         +UIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791503661; x=1792108461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wogysuar2t6CIwSyb2S0JLKktNfZleR32/9OzbUkzlE=;
        b=sADdWe5/+pf1MprxaZ2748Qd5TvJj+v/ka9TNjU4zGcv8851DfD3OlMtKff9Vf3ZTE
         rIdxJ+7slz8NnMuu2BBGIVOfavexa4eFndQL2XATbcf5jw+eaasOE4o+GxZQfqNWGksx
         MqEsGYi1wNaNdwEHmK93YUxVEgxcNoDrqQXc/iTBjYJ6fSRaztSpXjg/UkeoLE2D/Aaz
         lYHMiDxV7+Uj0TQavbBTzKNFdQ3V0/nhnfq8zUJMXEmml/yBIQdve1RDNi/T8PxE1cY4
         eaoxRTL7VfveokbvuVaQFXOr01/+db6pK48aKtYcRXuMx4gNqfIIIO5TB++o4CGzeAE7
         KQQQ==
X-Forwarded-Encrypted: i=1; AKwUvBycdxXNyXV04vcC2WHcCP5DjU1GZkqyKUyuahZ/lknehXalOn00kusqXvHrJWwCgzI6gKm1AtH+S9gb@vger.kernel.org
X-Gm-Message-State: AFq9FYI/c5KdW8+zHlF89MNDAlRYIHzOuLWdQwKN6CfeDfMJXH4PyPSk
	ryTCwf/xLIwuJScgPfK2gVKeDD4PVqLjo0XfrTJrZKT/AjZ9MZaVRVdP
X-Gm-Gg: AYBFou3RkT3iWDxrBhH5ssaWvbm9X6iqK9lP8UV9YmrjYBCwDlOToIQY2cM1Tu8jJg2
	LWEtaUNi5QJOmMhVdAeIfI8ShbEWqhlVuwJm6SCeb2jCg/07K01K/v+2Gvy5TBObRItf2+h9T/d
	EtdeAGOw4d7S596rR0N/bV8us6Bz4WtWxo0E+724+yOloVGJlqqzoPSr7KRD1Kglj17hzajWHGC
	ilxIsDbzhLOaYDSnCQ3//4PBeB3FyhAWRGomxG4fepZMhkNbux3Ef7jJ+8HHsgkzpgv/1e8k72l
	E0EIZ1igclYZwLZ0CFopzAov+BauG7+cxleUD/UUrPMl7N9gun7dvvA3SvMxtWtAt8ah1xF/OTC
	vGhrxKG2QmyZBqab3ejZASQTp5rXupLmfU3yZb+qwbxIleQNoRQKn5UL//3S68+HhLmBGzZKIl4
	f6/+29PU02F6M4X7fbcDmhhYOMXJhuYj1Vud9BnV01UUBhcS32RAVwROkt3kOPyX95w9rp54PAC
	O6EfT0ZhD2q8I46Vv4T0gBgq7RVKt2anq7JlWW99kA/v/jIFj8f/tKMuGyRyKI1BDPSilQv3jE7
	OuJOvOh2lOuskmiVWvo=
X-Received: by 2002:a05:6214:4118:b0:919:847e:ccb8 with SMTP id 6a1803df08f44-91b55345787mr7524496d6.1.1791503661318;
        Thu, 08 Oct 2026 16:54:21 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b550e6609sm3451586d6.43.2026.10.08.16.54.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 16:54:20 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v3 3/3] scsi: target: rd: Don't invoke the OOM killer for ramdisk pages
Date: Thu,  8 Oct 2026 19:54:09 -0400
Message-ID: <20261008235411.56641-4-sanan.hasanou@gmail.com>
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

rd_allocate_sgl_table() allocates the ramdisk's backing memory one page
at a time with GFP_KERNEL. When the requested ramdisk is larger than the
memory that can be freed, these allocations do not fail but invoke the
OOM killer instead. The pages are not charged to any task, so the OOM
killer keeps killing unrelated processes, and may panic the system once
nothing is left to kill, while the configfs write continues allocating.

Use __GFP_RETRY_MAYFAIL so that the allocation fails once reclaim can
make no more progress. rd_allocate_sgl_table() already handles failure
by returning -ENOMEM, and the caller then releases the pages allocated
so far. Add __GFP_NOWARN since the driver logs its own error.

Signed-off-by: Sanan Hasanov <sanan.hasanov@ucf.edu>
---
 drivers/target/target_core_rd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index b73bdd733..7c53d8a72 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -150,7 +150,8 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 						- 1;
 
 		for (j = 0; j < sg_per_table; j++) {
-			pg = alloc_pages(GFP_KERNEL, 0);
+			pg = alloc_pages(GFP_KERNEL | __GFP_RETRY_MAYFAIL |
+					 __GFP_NOWARN, 0);
 			if (!pg) {
 				pr_err("Unable to allocate scatterlist"
 					" pages for struct rd_dev_sg_table\n");
-- 
2.48.1

