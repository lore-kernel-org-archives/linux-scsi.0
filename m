Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AC32FC037
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 06:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768544055; cv=none; b=pILqHQZGkU5D2oZnb5bHAam6sOixnhRVbLMw+nf/eyHkyLkbYrDz9OLFw6vBJxEffPlCR7SNy85tWU6xOEExg3rLI68ql7KtEk8UqR8JKbrL8oq7C2/nYBdCShlzeSV0HRYfjE/hsL+4QewE9AESZln2zvRQy8cCd23O0RSolbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768544055; c=relaxed/simple;
	bh=KN+9RsysROtG03GgePlIIu6GwnzPiOkVxjqZFYjAwv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXk+L4xeXT81SA7FLNO4zutac8uuvvv/1+WvMWhobjqryXs6NqOeNtc+EXRmCv8eWBzyhnyclPjXBXeBB0g5lWmAGsF5eC7voTqNzmKJTq7TobfNOHaz8hgFozFE77hJGUMDfaHen4n0UcAX+dH/qw9kAdX0G/eY97ASfjJuDL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=HGxAXj7N; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HGxAXj7N"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2a0d67f1877so11238785ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:14:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768544054; x=1769148854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jVdghbLJ+uHQM33AaRaTb2qtIOf8ASlScoF+iuc3V7U=;
        b=TNLySQfK7iGOydIhWOCrw1Jz2nHpXwqTrQ8DOZQ2umwIa0aOIsDg3VyCBnES4ALOx+
         iWvmrbpqvG1khKBFsKcZMUUD+YOjhAjd6vr14QJlluX2xKyK0IHii+qsZJuyBJkJeYDK
         vG+QCuMpGIax2XBbLk01frJ8E55Jka2DnPbFnYC4HlKOZskRP1qgB1KI0F/txB9dlWoO
         zwz6shfZLnA+dBZn0OSUuegNq/AKH/n68e1ihsmQgVhY4IkLyGBOR8P/NPdbMPJTH2Qd
         8bmBCw2Kd9dU4MZHl+WOWkdIQbJAqxT6OZDsk5abZoi+Uiyjjnz/n/1WnNqMeInJ+rKn
         KQvw==
X-Gm-Message-State: AOJu0YxVKG9ilg1xJ4P5HmT6VFdqxccglkj0vUUfXXo9jvRGmZWhzAN2
	FlQ+ptwqW6ns9b1o3HDLj87hsTc36PBsocjHdExNW4+ZmGrBaf/DSiR+jzL9+lD0JXeM6AefwBI
	q+AOaZuGW9LMm06FmCXW2OO7fvlLI4aC+ijc6BdQatGeSkPOLKRWj9ZfBSf7FmTRZzC8bJ+PsQj
	kHfhvg/Faf48RbAPEkXJE4dXes0SMN/x32EQpAYV8pJLKQdCQvyK1NNQpJ2/PK+ElLUKCCTPFFk
	HIigsNZBu6KUEuE
X-Gm-Gg: AY/fxX7TMW8qaWOtGb6RFl+oe/fXd7aUIUkN/IV3HUkIWFZPOpJAELUNGpMomvaE5ZM
	ItQStP9RgQqejVmaAvJqDPvkr19smq8IDsYgAk2feqWww/cYmVYlOAAPyKb3x+edc86+AxnBIHV
	itSw5CMFMUczEoTuFNdVJNKyrBF+uqb7eCDpd9jnuAF9uaMyJodssxS8yp6A7ggIh/DE1fA+asn
	zLb7gTQkVEmocGGpA8QaglHFkvQG41/+QWpHDPTWcQ3hBiERIFa6WJBD/MVJi4nlUP+PNKGxPBh
	JlKM9CQm/puzbprYa+J0PCqmgP6D9w0KWrYSWKEMqexhNcR7u5gJvUqR03uICoIbMc4fkG6nIom
	Ap9fWbTlPj7uPc4u5hkdz1RVTH5pRrjlbrBumb0mhWU6UXqlursO9oJJVCZb7IjTVGUbqkrQglW
	oUNFbHhYwhOctKKs6Szj1uy4G8Ae6h9Myyd6ZTZuHrcg==
X-Received: by 2002:a17:903:2f48:b0:2a5:99ec:16d7 with SMTP id d9443c01a7336-2a71888b5c5mr18971835ad.7.1768544054021;
        Thu, 15 Jan 2026 22:14:14 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-2.dlp.protect.broadcom.com. [144.49.247.2])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2a7190d221dsm2015165ad.21.2026.01.15.22.14.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Jan 2026 22:14:14 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c337375d953so963917a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768544052; x=1769148852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jVdghbLJ+uHQM33AaRaTb2qtIOf8ASlScoF+iuc3V7U=;
        b=HGxAXj7N0ZgsEtCK7Ok23zTiHyX8YOGthG37SjV2v08DpWYXdKI6QyoExUnP1IjjqP
         NAXkAkOyskPouyLT0mcFRBXGaYGMLWotVpgT0oLJc5RBWStJaUHh7zreFBwcb+ClUl53
         IGb5SwLvelMdntU9dCpQ+0Wn2/UJsYX1YTCa8=
X-Received: by 2002:a05:6a20:7285:b0:366:14ac:8c6b with SMTP id adf61e73a8af0-38e00d7c14bmr1624986637.65.1768544051913;
        Thu, 15 Jan 2026 22:14:11 -0800 (PST)
X-Received: by 2002:a05:6a20:7285:b0:366:14ac:8c6b with SMTP id adf61e73a8af0-38e00d7c14bmr1624965637.65.1768544051483;
        Thu, 15 Jan 2026 22:14:11 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a71941bd9bsm10231315ad.93.2026.01.15.22.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 22:14:11 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	salomondush@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 8/8] mpi3mr: Driver version update to 8.17.0.3.50
Date: Fri, 16 Jan 2026 11:37:19 +0530
Message-ID: <20260116060719.32937-9-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116060719.32937-1-ranjan.kumar@broadcom.com>
References: <20260116060719.32937-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Update driver version to 8.17.0.3.50

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 6a0291708113..6e962092577d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -56,8 +56,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.15.0.5.51"
-#define MPI3MR_DRIVER_RELDATE	"18-November-2025"
+#define MPI3MR_DRIVER_VERSION	"8.17.0.3.50"
+#define MPI3MR_DRIVER_RELDATE	"09-January-2026"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
-- 
2.47.3

