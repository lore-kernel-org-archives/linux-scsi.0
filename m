Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B18221FBA;
	Sat, 28 Jun 2025 12:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751115222; cv=none; b=OP46GItQ8qomtzofTbHhcccN4JzAQ+yMPDh3+paSMzfnjyNuglJ1rRKb4Ues0H+96bIqN/v+d8kms0i79E2+MKMsp2lVp3fW7WokBm6uizkggqYIVoeHGP5pulMpNe8KKhvCOl+OkA+ifGyjJiE8g4bOpZBjNG9dfURkRlu8OxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751115222; c=relaxed/simple;
	bh=Yw6OVMw2XO0OpaFU64wQm0eI9uWLODY5EjoTjMJ2wzk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=J+EDRHfjHwt7A1VLsBc9DrpQZJD09n4oNcB98/bCviLj4Sgxwk2kVtCft4cBqcLdZ/Jo1xixEqb+wphA943FH3NP95oRcHBUhNwcShGsQMndLK6YexIFwDamGbjBDQ/ITXFdhZTxPJlbdfCqGBSPtKn/HtdeEbT5eNz+mbdhZcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KF4gu9YU; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KF4gu9YU"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-235d6de331fso5677425ad.3;
        Sat, 28 Jun 2025 05:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751115221; x=1751720021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LpHE3fLDeCWcDxZzIAkyKvRKmqfdGUGUIj9xFS7Cx1M=;
        b=KF4gu9YUk0F0BaedLjnGHVg12HU6/NoAyw47b+MZi3bc2URAxBWm/z9srm575t+7xo
         /ffUE2gzEapG9JjHCavdo7GvJxb28Aa5Vi05SykYkG6B2Dz3k3pvVhOxIDBJxMqDsAED
         jFSdcVTRsPoknqdGcdRkeSJLR9zBlU8WouMs8YMy49TbTGt0S6O+cwHeumAHMj/mJf3H
         MQgSgN9y02U22MMkEZl3O6xX6snwlljHXkzAQj7osxrFtKyR7PY328gExfWziZpGP+FJ
         nR2M+KRRcxO9Se9BvkwhUxMpyks6RM8ImLdHIMHJztWoLxjKntyzR+DJ05q4Ol3jGn6s
         GPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751115221; x=1751720021;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LpHE3fLDeCWcDxZzIAkyKvRKmqfdGUGUIj9xFS7Cx1M=;
        b=GQQpiGdOY0fHa0ZbtrK4IDmcEuTEJJpd+Q64Eq6Krda+nlrubmcsdGvwGUgVPkZOta
         M4FYBzHl/ooHoNLD+aozFJKxkpuFORJhcNAoCVmzN1x7dZPVNldyC1aAZ/foG38nqsCB
         jJcjdJ99MNBjpf/DwdGFNObmM2ZsKC9gTmL6vjaVsJtKwLzzVJ1yvUUrjkeMxv277A+z
         Xo7kHujYhlosTF8F18DzZ5x+uhtubYnOv+7YZVlnddH7RwTqQIs4RzPWDPeyjgq7/+47
         8tnD9dg+ulWg4kYAZN/0SvSnRrR6zOgCI3cEoqJ2unxefCGqkzxrqeQvmKAV7mir2+n/
         ubXw==
X-Forwarded-Encrypted: i=1; AJvYcCVO/LNxnxMcID2KEqRAWYIH/tIrWY/SXVvTQVDj+1BAGwjXzAzkxHkgo8WysQSTlqRVD/lQk5bTJMqo0R0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlTNwYbGM27YSLsbJR6S6kq2onItBQUO30t5ZWP5uLppMLw6uZ
	3rbBLuuuaonoUXh0H9liiGUVpEgzqujfA6gYmcSktLR+rSmzn8dyCm5r
X-Gm-Gg: ASbGncsn1mtugqwSnyo2w3VprcRDYEXSlwxlM7fyR7CNadxzBWXOvbI68lengslkfZh
	fDNsloRGYuY64orKlO+g2SrHPhyVftEl2hmvy6thf/fckXckFaURZLUsiA5bkwkNbDjTuQGLBsJ
	tqeUbb3kRmWFLz3lDlJH/PDii4fRjy2pRbK4BhaBF/pY8xVpNCPH4dd79eHjugr1RS+Pacc2QYq
	ZcbtPOBmzfwXDXG5i8THwlBsUy+WJAGVwJaZ7Nhd8XZt+R8suWXckiYOTYNbDotQlYfD3Y6lbbj
	m43DFMJV0eheCW8SV0QL4VQxrRym/bK4OY0SvwWJQc1JmBb3ajMl+/fJC/EfNr/ubi3s1MFiWIs
	YvrDGaAW1iOZgig==
X-Google-Smtp-Source: AGHT+IH6mZZojuqK/skauy15yP8Klz04JW818MtpgIcFZG0uBkQGrY+JCQueG4MKPUFB8R5d1wv4/A==
X-Received: by 2002:a17:902:d603:b0:235:711:f810 with SMTP id d9443c01a7336-23ac43d3283mr106652825ad.23.1751115220657;
        Sat, 28 Jun 2025 05:53:40 -0700 (PDT)
Received: from localhost.localdomain ([223.185.39.134])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3ce960sm38188475ad.250.2025.06.28.05.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jun 2025 05:53:40 -0700 (PDT)
From: ankitdange37@gmail.com
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ankit Dange <ankitdange37@gmail.com>
Subject: [PATCH] scsi: ibmvscsi_tgt: Fix typo 'transitition' to 'transition' in comment
Date: Sat, 28 Jun 2025 18:23:20 +0530
Message-Id: <20250628125320.295824-1-ankitdange37@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ankit Dange <ankitdange37@gmail.com>

Corrected the misspelling of "transitition" to "transition" in a comment
in ibmvscsi_tgt.c for clarity.

Signed-off-by: Ankit Dange <ankitdange37@gmail.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 2fca17cf8b51..edc28da794f0 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -425,7 +425,7 @@ static void ibmvscsis_disconnect(struct work_struct *work)
 
 	/*
 	 * check which state we are in and see if we
-	 * should transitition to the new state
+	 * should transition to the new state
 	 */
 	switch (vscsi->state) {
 	/* Should never be called while in this state. */
-- 
2.34.1

