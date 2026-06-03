Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0DF49252E
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jun 2026 23:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780531008; cv=none; b=EkldiHWzAI1lNIe8SqsCuE0oQQE+2F4PWehYYoOl/Y7bOi7ssO1xNdIkpbLrZY/w6kqNxHjFRpI3z/SIdszbDIxeFHEhKzBi2tVWLbwZJ0QL/4AObdXuXwWbPOewrprPHToOB5+crx/LOTK2Vn8UmmZN8feuERD+5vaINxaM9aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780531008; c=relaxed/simple;
	bh=T0/NMI00gb3tSsw/lDXZhV7NFN3on5mOm+ZY3F9d1wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lDGQI9d13rd59DddEISrNacq1pgNRRwXeddqdIEArbn3ZHqdfcXnMhkgnUnYAI0nWJGJY72Q9K2EhGTGmthdwWdok/M9CmOlVIwDnQ1rjpeNPub6NnU+vlRirhH6SRL/NjZ5WlF5CvjVeh44eyRN38c9Rk9sZR3PbiPQoxulYeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=JTcPcI/Y; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="JTcPcI/Y"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8ccea53f35cso1183526d6.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jun 2026 16:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780531006; x=1781135806; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mp1vJh8uao2AHw0c9OHkXhZ0mnitHWn6AZWE/LHDbYg=;
        b=JTcPcI/Yw8faw9RsFSbCZAfPrdzVklTwre1eWRTyAoYlOiYzElLOGiZIw9PFonW2aD
         72QVYkzOICXTVYiBRYLzljogletAi7ox16+mY8TGPQLN/pZRfmnj/I1dY7+btzoxwpwc
         /dJh3fM8VXFDYHnFIYUwsM51kCpD6Zzm1xydE5k7tyfCWOJU7H0/rlzErJXMjME4P+6E
         DVqYhnfLkJnRZ03CCnkGh2gv2AbNjGps8YaQ3vZfG94Y6wWvWxduJUpypj+ObXxwtSzo
         Dd9wiTYVYWHy/HkyAFpS5nrClMxU+rfTzmkVcvEIZMsMZTFksc+4SSv8E3vqY9QDtGtS
         haxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780531006; x=1781135806;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mp1vJh8uao2AHw0c9OHkXhZ0mnitHWn6AZWE/LHDbYg=;
        b=gLTAQcjwAXFXiIIr6ah4l9gKBxZaamKFLi+NcsI0EXkZ1L9+oct0Z/Zu3OkEA7CrpX
         BPUOKInEd1NA34kwgKNpHVHawgFKOJrzjXxfUSeDjqTzjRA4MPMTqbS5pv0OEBmyp/Lq
         vkJGImcwtzpGjqqm4z8YF9VVLk2c7dktP0uvY4rg66XHFEhXwBXf3l/eoulsKMQVsESm
         cfTQBpgrcctRb+sho/VmWodMRxu+UbvwS3jYk4VS1q3peR5lN+FntuPqp0Q61e73O9+2
         pn5+KU+X+PlB7v7I26xADGMVjxsDo3CCjmhonzebdB+XMYRxhqvEvE/EEtUcdXrvBM0Q
         8xnw==
X-Forwarded-Encrypted: i=1; AFNElJ8i/hu1C74xEhuipR8w3RBRmaDq36mfJOoKcPTQa+V9sN/JSgSBhYdDzugGQJtMWncJGMUkqhfGSrld@vger.kernel.org
X-Gm-Message-State: AOJu0YxRinig7J3G+QYa2y/BepN9gmZyepGCjCEkA3vYeO9yPJ7egFpu
	Pabaw9Acp7ysRIPlp0JUG05Mz73SssnW+bBDJY/B6W2NYhmPIoIg04xNTVcS0I+8I3U=
X-Gm-Gg: Acq92OGKTlWl2gSmxH+jqC7WLFhhL3aUhuK+YFbUZ+7CkDhIWM/E/zDiUlGU5e7pvW3
	tPK4maEU2q1ouc1Lt6c8HcQ7fQqFNUQvdxAQ3+mDxLxtlpyTV1/Cb99Ru57BjknKepT3jUIIqLD
	ZoWWgSkdeXbH7a/rN8YbTxbFmL6VX7JGf/b9SgNLKk6oQqsDozRnMiZTflSjlgFdLB2Rk5ce5JX
	LiVswRaoTShK7bx+4JK9eZiuLwsb1dWr2kTCHcGr/aauYTOG89gBgiFyZC7sHEEkMPeQaH0wxoL
	iECCkbWtosIHDOdKG4UuVVfjIDWqOt/MViUxgst1QgdPAVdnuvbFIpFgFMoztcvIfRTAVWDxo1a
	jYWdQG6/iuACxU/dt3DHrCa5ydF5nHS/mljky7E0ngH1b3Zkf4UmH++QOkbRy5cKAHO+nkOR2De
	to7xCwgsJ8q3b4CUnNuA4E6m6N9mqM4UaipuJcVA==
X-Received: by 2002:a05:6214:2424:b0:8ce:cc3e:9d08 with SMTP id 6a1803df08f44-8cecdd35d4cmr80141996d6.45.1780531006561;
        Wed, 03 Jun 2026 16:56:46 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-8cecd277070sm34168026d6.48.2026.06.03.16.56.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 16:56:46 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] scsi: scsi_debug: fix one-partition tape setup bounds
Date: Wed,  3 Jun 2026 23:55:48 +0000
Message-ID: <20260603235616.124535-1-sam.moelius@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The tape setup path writes partition metadata one element past the
allocated tape_blocks array when a one-partition configuration is
selected.

That corrupts adjacent state during device initialization before any
command is issued.

Reject a declared multi-partition layout that has no space for partition
1, and initialize partition 1's marker only when partition 1 exists.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
Changes in v2
  - Fixed handling of part_1_size == 0 case

 drivers/scsi/scsi_debug.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1515495fd9ea..edcc2f5f6977 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3661,12 +3661,18 @@ static int partition_tape(struct sdebug_dev_info *devip, int nbr_partitions,
 
 	if (part_0_size + part_1_size > TAPE_UNITS)
 		return -1;
+	if (nbr_partitions > 1 && part_1_size <= 0)
+		return -1;
 	devip->tape_eop[0] = part_0_size;
 	devip->tape_blocks[0]->fl_size = TAPE_BLOCK_EOD_FLAG;
 	devip->tape_eop[1] = part_1_size;
-	devip->tape_blocks[1] = devip->tape_blocks[0] +
-			devip->tape_eop[0];
-	devip->tape_blocks[1]->fl_size = TAPE_BLOCK_EOD_FLAG;
+	if (nbr_partitions > 1) {
+		devip->tape_blocks[1] = devip->tape_blocks[0] +
+				devip->tape_eop[0];
+		devip->tape_blocks[1]->fl_size = TAPE_BLOCK_EOD_FLAG;
+	} else {
+		devip->tape_blocks[1] = NULL;
+	}
 
 	for (i = 0 ; i < TAPE_MAX_PARTITIONS; i++)
 		devip->tape_location[i] = 0;
-- 
2.43.0

