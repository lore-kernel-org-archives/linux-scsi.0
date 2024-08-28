Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863BA11CA0;
	Wed, 28 Aug 2024 01:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724807491; cv=none; b=P1zV6VBpLREV+RQiEs8gKBAc5c1O/KXYwrfz7z+6mbAyzd2xcm67RFH89zJ3NZuwC24wm8r6xSI7r5O0Thy3PkclOOTOh956csqYls0zYzIK2h9N94p8PSRLe0e0FXu3lwVX/jySavDPxjC6Afmi1t/gdTITcicGcPT9/Xjntwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724807491; c=relaxed/simple;
	bh=t5uQd8A3JhsS6iUH7qcXUbvuhC460+nc+MbywFcPZJc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PI/ElTFoA5xK7dh3dYnRktgF3Lxwm0k/wK0OcE+V5mLaWImW3qkJ/f6VJ9hy93arCY/RGd4z8VC061PFIp/kLMMFeUaESB7N/u6N0l+SHiTPmVWUjSgyMDHDLj9dU68KjtBmBODPFbJtqJCFznxBa8L2gm9uog8seRvN0pTPC+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qt8R0H6U; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qt8R0H6U"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6bf953cb5d3so29344486d6.0;
        Tue, 27 Aug 2024 18:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724807488; x=1725412288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jqTTqYJx2GdCKw0eVFyzlVgQzDThePA3Ad3iJqiJ5Y4=;
        b=Qt8R0H6U1PBsCDhJoa7zNpaUN0HQQGIQ0AOIgHhpIdztrXBPmd/xYynD2y54prMsmy
         aMVacBTdT57KHb67KQvHuGMpsrUFhtjd2YnwXGgZXU1t5QcyhRMgBDOeq59f98xUkZfL
         M22xwjhtOlEWeb0O6C8uWfju41obD6fQ4u2gQdXX2Rjgwi7erYIWoItZ+W98XAYtvBrF
         8ZlJuVibKK8UCw56k6UN1TYvS6XVQyMiy/9RYr/b3UaszcvVMKcFKl3i3NhEZ0x9dQc4
         hrDOUM2SXfaaHCqKidUSWO+E2JJKmH4MCpgcY0cbUDsymeo/VfAdqAQowCR3iMDVZpFw
         2DvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724807488; x=1725412288;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jqTTqYJx2GdCKw0eVFyzlVgQzDThePA3Ad3iJqiJ5Y4=;
        b=hG/TYO1XWPYzb5igRcCln77DAjD3KO2+cQHgMYJJJXgpobLqhqLctIdqHtfb86zzx8
         KUX3lOWRnl2fdzGdhke+R54jQitQigHqrECGvJHpTLGXMh3SCPtzDTeu/iHQ5fBbcsOJ
         xwCHzckT/F0jqJloDAiEffqIxX+4oXMt13js/YN+yLKmUMLh7y+/bg7tpL7bKG3bbLYN
         jX/4HDKRu1teqE618mIh7vJ1OMH4j22kjQudqYVa1rNnGEe6y4iPUur5ReQnr4+Fb3p+
         SXhra49h75rIZ/eJkPsCWskkUnYp0qHS4QHLr98Z1YMM1QM3NrbELrVOtRLCcb288KdL
         SQ4w==
X-Forwarded-Encrypted: i=1; AJvYcCXEkYeE1nNo6cJhX/ZcDWaonZJNT+cY6NiWcklm6A+W5b8ypq7Ye/n1jPZf3E1+TdP4CeSfoJ8aEUU63pA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtNb3tob9raKHRZwCsT0nKu8PJ/fb3SZnSW6UD8TTiUtkGrF0G
	DxwDpgoIse9Wouabivo76cRpO3TdB37WrOw3Gd+MBoiafkYbpU32
X-Google-Smtp-Source: AGHT+IEw9t4NXgqqlHA1GCL84k6xRiuceYI6cHWjfSm/DMtnIo6BBNm386QycgGVAHm8hmbvxkMGAg==
X-Received: by 2002:a05:6214:3388:b0:6c1:6f94:2f56 with SMTP id 6a1803df08f44-6c33630bdbemr4463096d6.33.1724807488323;
        Tue, 27 Aug 2024 18:11:28 -0700 (PDT)
Received: from MAC-146400.dhcp.fnal.gov (mac-146400.dhcp.fnal.gov. [131.225.73.245])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c162db0bb7sm61296246d6.82.2024.08.27.18.11.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Aug 2024 18:11:28 -0700 (PDT)
From: Rafael Rocha <vidurri@gmail.com>
X-Google-Original-From: Rafael Rocha <rrochavi@fnal.gov>
To: Kai.Makisara@kolumbus.fi
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rrochavi@fnal.gov
Subject: [PATCH] scsi: st: Fix input/output error on empty drive reset
Date: Tue, 27 Aug 2024 20:11:24 -0500
Message-Id: <20240828011124.16755-1-rrochavi@fnal.gov>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tape drives are returning an "Input/output error" when a drive, the host, or
the bus is reset. This behavior is expected when a tape is present to prevent
data loss. However, the driver currently drops these errors even for empty
drives due to the following change:

Commit: 9604eea5bd3ae1fa3c098294f4fc29ad687141ea
Subject: scsi: st: Add third-party power-on reset handling
Link: https://github.com/torvalds/linux/commit/9604eea5bd3ae1fa3c098294f4fc29ad687141ea

This issue is causing several tape software applications to crash on startup or
when performing drive health checks, as noted in the following CERN CTA Tape
software discussion:
https://cta-community.web.cern.ch/t/input-output-error-from-tape-drive-device-dev-nst0/302

To correct this behavior, it is necessary to either check for the presence of a
tape before blocking the device or revise the drive's readiness verification at
the beginning of the flush function.

Signed-off-by: Rafael Rocha <rrochavi@fnal.gov>
---
 drivers/scsi/st.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 0d8ce1a92168..10bda3543e93 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -834,6 +834,9 @@ static int flush_buffer(struct scsi_tape *STp, int seek_next)
 	int backspace, result;
 	struct st_partstat *STps;
 
+	if (STp->ready != ST_READY)
+                return 0;
+
 	/*
 	 * If there was a bus reset, block further access
 	 * to this device.
@@ -841,8 +844,6 @@ static int flush_buffer(struct scsi_tape *STp, int seek_next)
 	if (STp->pos_unknown)
 		return (-EIO);
 
-	if (STp->ready != ST_READY)
-		return 0;
 	STps = &(STp->ps[STp->partition]);
 	if (STps->rw == ST_WRITING)	/* Writing */
 		return st_flush_write_buffer(STp);
-- 
2.39.3 (Apple Git-146)

