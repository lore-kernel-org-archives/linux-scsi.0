Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0365A29D277
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 17:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757957966; cv=none; b=eU66Bi63jR/Znz8ZhdYJgY6YhU9bJKRjwZEhPRBPGyV7BVLBUkj3uwH+LeveBVUSfn9bnrninbjnOPIZfAT7l7H23VL3KXDrK+YonzHJzTjJP7pmfKfjkZIRRHR1xRAzuiL/d51w/pusAMFR4zhIBONDT2BWsOjgjonsLZq5z5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757957966; c=relaxed/simple;
	bh=joWHrm/vhmq4CC4VGGvVP+2qw1zxCTEJN2Gjd1k5Prw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ezXfHVrXlVo4rGUj6USSjF5SK/ZQBhbG5V5UCG41YlkKDai8EWv7kkUwS6NTcgS/tq+TQCQjp5dTSHXQU3A5PlxBf48SuAVALmjgxz44pfoqhuLvbCpXEJQ2utwZMJj4bsggg03GW/Hq4iNMmMbGjyciMXoOKbhE6K9rAHPKgyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pvrhh9Jf; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pvrhh9Jf"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-80e2c527010so289903885a.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 10:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757957964; x=1758562764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tQmmbl6Zn4esp6vu3uGvoaVA9S3ygBqLhwfJzeNUoKY=;
        b=Pvrhh9JfYi+zP6o9M6ZlfAGuBmDmUgSIxg2R90ddMjORej9z7ecjMu1C31WvSwrphq
         CqVjnUueQEO0w/Ra9WdvA35PoAdEk1p6Ahz4UyvZFQuDrBDAq4nsewZ7/BDOrMnqwxy/
         Zl6SBLDUWd7HjySlh01S4FeVgkmIwGlvPNedwnKW4XX+iRWdeH6gysERS78sv5tGCpgq
         8WAklYT/DQ/w9kEoSZNwr4YUCCL7u0hTuTt6IS3dcISrxwxLgYKlKB1alSnMyV2Rf4yF
         mwHa3zDva43lKaZWtkBnS6Ijf3Td7GrxueUHPWoCQJFz0+LkCrNOUNcVMAZ7GbSQHUB6
         rw7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757957964; x=1758562764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tQmmbl6Zn4esp6vu3uGvoaVA9S3ygBqLhwfJzeNUoKY=;
        b=h/20o1LwVvaHZSBLV96Vi8kYFBDAQV88qWawuiIn+8D7IMVlUuS+v/xwlO5n7PFpRi
         +JbUIakR/R7xNqI7GvD4KAwnfEIf8uEEPKY0N4eSJxfeC9Yx/BoS2NOIAPU0/DNncfJA
         0lBdwaeFjT0YJT/K6dIrAShOY+sg5KUVsLEebqC6/pnt6/3xVvszP+3uVknhwoVD0a5S
         PNB+6utSpRjZfkSzowzMMHgOOP/GOJyoLjWPQvl4eT3YECiIn3bJmDgouskkNcR/EU7m
         3YvgLNcJUWV/phvvl60ga79E2ecmT3g5rJyLN+reakarFtKheDz8CVxnV83XacVbApgp
         R8IA==
X-Gm-Message-State: AOJu0YzJom6DglXPnahuUrmt5uR/gXcSRFgZR9Ue1r76QzFN1qB7PPyD
	f4Pxqx8F6e9PiWyMTJ5CuqPleP7wE/ThzTMLOxPlW5qbMzBtTwjR7E+yR6128A==
X-Gm-Gg: ASbGncuoNWAk7RNnml9/iYVcGQgMqYZjYE1/2c8eguPrY1M0tQD+DC1SoEjVXLFsSbw
	MTfG8zqBviPgB9cDcoHX+Ujq/+ZPNtr0ynAeKiv1Taurcs9dmH5ZCNDZ5wgkR8jqbAM46HfMsLx
	mQU+TeSVJFkYWCr2WPC8asy4U+BDK1dVsidtxeSkR6m0bnobUrq+gOfaKfT8EevoC1zguQitu/B
	+oc+cNDD+QOo9PxdUXse0pdke4l3qxgXCWRoI590bqrsnTqq7lon+IDKcS5npoeDAgePCza6Zhv
	93lPiqvIg2MEblL2hOzdM7QHdh8vnVHrEEiLgxOHtixddQxZarZCWZzIXhm3n93T3fteTceXvTA
	QeBW/4qPAyyXHAtdwWis4xtFnr/SpeOmR79oVmcTw4mW5pb9Jp8Te7niMNwIiPxMeXnc3nKA8h4
	Vmr9EWpOLax9qBcXUmfQ==
X-Google-Smtp-Source: AGHT+IGgczTGkThpSOwYOo6hZRIcwgqGpvjxNn4+46TA8HmcQCfp5lRsXUa5LasjhAlBLIXZK6Jk/Q==
X-Received: by 2002:a05:620a:ac07:b0:823:51b0:3a75 with SMTP id af79cd13be357-82400758717mr1917816085a.39.1757957963616;
        Mon, 15 Sep 2025 10:39:23 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-77ef70bcc4esm29710976d6.41.2025.09.15.10.39.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2025 10:39:23 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 08/14] lpfc: Define size of debugfs entry for xri rebalancing
Date: Mon, 15 Sep 2025 11:08:05 -0700
Message-Id: <20250915180811.137530-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250915180811.137530-1-justintee8345@gmail.com>
References: <20250915180811.137530-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To assist in debugging lpfc_xri_rebalancing driver parameter, a debugfs
entry is used.  The debugfs file operations for xri rebalancing have been
previously implemented, but lack definition for its information buffer
size.  Similar to other pre-existing debugfs entry buffers, define
LPFC_HDWQINFO_SIZE as 8192 bytes.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index f319f3af0400..566dd84e0677 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -44,6 +44,9 @@
 /* hbqinfo output buffer size */
 #define LPFC_HBQINFO_SIZE 8192
 
+/* hdwqinfo output buffer size */
+#define LPFC_HDWQINFO_SIZE 8192
+
 /* nvmestat output buffer size */
 #define LPFC_NVMESTAT_SIZE 8192
 #define LPFC_IOKTIME_SIZE 8192
-- 
2.38.0

