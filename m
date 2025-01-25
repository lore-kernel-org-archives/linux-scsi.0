Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA9A1D5ACF;
	Sat, 25 Jan 2025 09:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737798663; cv=none; b=f3ziu7/WJpgjJ+0tFsDVqgku8amwMRp+TFONkdEDDCPUd1Gv/DxciwRlTQ0x7pejeqjAdPgzyw5PwOHK5BWIzTm4g3Vkxv1JaiTS2EYCJcXgVQO1GBvthtV8jdFZf9/tV5AVf0nKwdf3uciO9aYCOuy7QUbEU1xUTxLuUU+4LvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737798663; c=relaxed/simple;
	bh=jc+yqcGL4E1gsHhQ+d9OTUVc5rkD3uUzJp4N780/QSs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=kdcimy35x8GSux7zjP2E5pvA7ef3xMjw5d+Hors0afOV6U84Thc+dV0AD1mTnoDqRJ1G0iLVTjLvflv2Zj+qFivP/POTgXuFM9ZGrDAX0WJSC4Uc5eaKG8Kl8CV2EDGXMRrWQLAQ+YvjJtVsdkY3U+0kPRixZwWSLyCsjxFqJj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gkx+0bqn; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gkx+0bqn"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5439b0dd4bfso2394437e87.0;
        Sat, 25 Jan 2025 01:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737798660; x=1738403460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=k1ksSreSoTBG05FBk8wxW3sxFTNx+NPHpt5OqbIgnNw=;
        b=gkx+0bqnhSQWY3yF7LX5bCQfqhYD45iagm5jFVX1mgXUOzEgRd3lIBxdMf0tVLPON6
         qmWZjnA2+VomxvickREGWGtDaANRcprsnS/0owAGLkqKW4MTfSw+a/YotBS50X9YPorG
         cYvf3Bb3Zxxzv3jzP3h1NxmnWy60kNSfaRWmgT0VyTBoHWi30jCQuU8ksov92W6/Y/Th
         bq0v9K8cUOAsT2YD28UTVJHbKbFVxM2UZG4pj+B9zs2WNYXgigH2QYZwl6XaNutWL10D
         SQj2ZL7Y7feCmceFCbzOkH0jXAqxEiq8GlwekEmORz+JS7u84qlty4b3DjvMxJ259g6j
         sXPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737798660; x=1738403460;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k1ksSreSoTBG05FBk8wxW3sxFTNx+NPHpt5OqbIgnNw=;
        b=cC/kI/cMeOsoxvuC2V1nIvyxuslhYxeG7RKTryli0pNTxewSIKBodyUY/q0C7ZFbSe
         OxaUBe1aKljp6AJKX6whKKJOQPYIcGsEqyHfF5SB9Cnz9K+5tI5QbF09+bUl/HIQLkVB
         mPUis0TvrXJ6daFfwVk6f4hwSkAcOriNkm0rFq1EuhqQa3upLwC8aWf5f2UdpIYDdLI0
         9PqlKxe0BhvR3KfYc1AVYglx2UaJimVrAcgJrg54tEHAeQirWvMF7ygaCO7zSSFs3Dz5
         LaXoEIeK9+NkDlN0SbLsA9GsziYxuG/IvUpBRUIhwXjlxMkcSr7xBEaTRchLSBx7jEZA
         tMHg==
X-Forwarded-Encrypted: i=1; AJvYcCWAMYjMX79PIO/fkTA3U0a9m9aahkMKzTSURZU6dr0R6Hw5YUDqlOce5Uoeii2thk6aOisR1dWIl7sKwg==@vger.kernel.org, AJvYcCXlhpQDbqYSOzwReRDr/tHEsK69dGRkjuY10pCfVV4bu+hhmufPx/dIgiY8bpc3UEzJUnFxGOuYdm1G0uI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxE+ciLp491344mdQzOOwspJhQ+omHRi4uQWPtb13CRPsTEJSw7
	fvYsKK6RdvlkyX2ii7wELnL/30NsztRXJCRjx1kPH8n0ksyWacZFJoTAoFod
X-Gm-Gg: ASbGncvsYRYBA2CNoStLAbCdMFysudu/t1QlTh/SmhNIblwbEH3Xdt0mCvTVtbPC5fJ
	tcLMn8Yl7aDNB+iD34HGkTwgGqd4pHplIgcU3SfAxxYBLwpDdhzx3NMyEnijC1kELLx3VzOBzTM
	IsYv3rWoQul6w3eZJ7WB6DwpBwu84H/ugrj0I6LS+hv3OqiWCZ3YkbRyZr22hb0A/JitM88hA2b
	NcbF4TwzJFIDeo5RRaFh2VVSdn7n1NIOlhD7Qg56qjZlwCOeQgwwOIYaq+i+IyFzR5IL/1Irtnx
	vKowcJ937Fz7lcxriUEOd8gGw0QOpqbsdGN7bfhlqNJRk9QCo14=
X-Google-Smtp-Source: AGHT+IFmMJOVNZdjNBJM25yHjx6A3xzmaQhhbcO5TVr3IgQZQ1PoEn4YjEDyyiGmpdKUcsLZSl0rYg==
X-Received: by 2002:ac2:4acb:0:b0:540:1a0c:9ba6 with SMTP id 2adb3069b0e04-5439c282d2bmr10296413e87.34.1737798659849;
        Sat, 25 Jan 2025 01:50:59 -0800 (PST)
Received: from es40.darklands.se (h-94-254-104-176.A469.priv.bahnhof.se. [94.254.104.176])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-543c822fd3esm572716e87.94.2025.01.25.01.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2025 01:50:59 -0800 (PST)
From: Magnus Lindholm <linmag7@gmail.com>
To: linmag7@gmail.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1] scsi: qla1280.c: fix kernel Oops when debug level > 2
Date: Sat, 25 Jan 2025 10:49:22 +0100
Message-ID: <20250125095033.26188-1-linmag7@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A null dereference or Oops exception will eventually occur when qla1280.c
driver is compiled with DEBUG_QLA1280 enabled and ql_debug_level > 2.
I think its clear from the code that the intention here is sg_dma_len(s)
not length of sg_next(s) when printing the debug info.

Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
---
 drivers/scsi/qla1280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 8958547ac111..fed07b146070 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2867,7 +2867,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			dprintk(3, "S/G Segment phys_addr=%x %x, len=0x%x\n",
 				cpu_to_le32(upper_32_bits(dma_handle)),
 				cpu_to_le32(lower_32_bits(dma_handle)),
-				cpu_to_le32(sg_dma_len(sg_next(s))));
+				cpu_to_le32(sg_dma_len(s)));
 			remseg--;
 		}
 		dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
-- 
2.48.1

