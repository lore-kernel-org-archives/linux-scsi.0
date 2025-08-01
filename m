Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7381D5CE5;
	Fri,  1 Aug 2025 18:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754073350; cv=none; b=PHtxwOp0ULf4fnTdozGwNtky79KgVA4nKRKGjsXxFkpceP0/S0VFmM9yV6qqTsac9Bd5T0iYzbXwDUxXhPg1H3ncj8cK1BlFEdItJJ+jbNkwMPrfKvJO7EvXdJPxQg1Qs+O1ENfQO55EzlYMfsfBgfr75pCTJqcvzeLQyc43yVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754073350; c=relaxed/simple;
	bh=B27OjJv8jOXqJdC/glwPPLA78Xh2lF+0QgwazJeHe98=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DxiF2piZXkqVfzTPvIpJrHDUnV5gW+uazxgPfNCXD7blcFkni4xnJc+BuL/LvAewA9RDzPwbEOUCxUwuHs9d0pdn2JcqruwlLrTCRC2CRgfCOqjA3WKTxpJXyGWuwrUXsBfuLSFI3WcxDpjAINWlS/G6JlqnW2Cb1GoreSj3oCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cpc0LNxB; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cpc0LNxB"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-708d90aa8f9so27100557b3.3;
        Fri, 01 Aug 2025 11:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754073348; x=1754678148; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qfIH0tozfiW0Hsw51f6VO5Q0JxUmTtpKoc44LZzdrkU=;
        b=cpc0LNxB/QFLh5U4hE/O8mLdEhsL2KhtxT2pLvni0Qcx+5UoRJGXRjmlNONqrxOCpP
         +sN1pjbMe9S+UJrNRgYMxJmjKgmdwFo7/fVJwFu7xNkCMiDIt0iJ1SuMwXgLdPN6tKx5
         sIiNlYef2BILRBPJkQL1izJBuz8QHiGe3PNLm/leFNDCTjCy0EK432EMWWcOB4sy3M3E
         xXUqgCscV3P7JiUH84XmGT064ZA9GOVERY/eNo4PiLYF927yrCjMDwO7fq7ZrQDVRcVe
         06+CEkGyyk05i8Bo6LZ51/QrtrB8RaadCApoIVxVk8ZvMUWzcsd+wJol64RCLB1BUnyg
         ksnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754073348; x=1754678148;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qfIH0tozfiW0Hsw51f6VO5Q0JxUmTtpKoc44LZzdrkU=;
        b=uBcPG9sAz1qQE/r2OhQX55CdN3bJ85urEqeWspb2xgP1ZTd5Aycsl4pywM/yD/wXaM
         q+2SllyQ8ftDJFJ8yEvOLmjv6YCvZCRDDUmHcxDa9vr1wBl0Jppn6EcmQ+f82EcNXggv
         Ucvm+ZyaZkdwdQ7598G/980wG/lkb6ZzopPiCeXFpdoXYV/yxViSOUK2f2sTGZr5Yd5m
         34YmRXB4HB55+zMGQNpL/iuwTHlNWsYh82NJQAVj46Sk4eNtTzebB5efVVPSpYXL3qZn
         CiFPA214497KSCgKMZ3C2GFhOU993/LgBAZW5J8d+a3eb8xDF+dcyaVXvS+LuYRXgdqG
         tw3Q==
X-Forwarded-Encrypted: i=1; AJvYcCV8mIvqu7MBB4hsGkwjPB6JaluAtrvy61PZuDelDWVFAR+2qo7yUXfF0wZBlWJRbhn9p/tlEQJ+792mO2c=@vger.kernel.org, AJvYcCXP3RgLjFRRwmIEEEhDirU5iuwmjQ+gcZWuQaGOl5JwaVi8NQ+m2r1zpYHQ34QHlwt+YsqRU+hzrSP57w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxqKps/kpdBlX2QRqd+RPnmbgp/YpTs+Gc0/GvuiRxc8ZsaH0Do
	LLctW+pv5i5tgG4ANBtgY39wXG1VPTqQPrbZ1SK11Uwy8k2dCRruNigD
X-Gm-Gg: ASbGncsoQasEXWBINIvrino3gsV4pn4rslk33JqjG1j4gzgIhr38dLhPQUEhqhrXmjK
	xKCK8Tl3GoqDPgmIxUzBQJLXTgbVdZVve3oPqAWVX21nKcQwUu5AoWlOpCpv/+D9lHc7nobSpkQ
	CLrsRG9HUnAGxCiQi2CkYBzWdqUGL7Fih9WZ3st0Z+ga2bxyfnMY9ibCJZgk8+khDtDY/7g64n2
	bTSErhsgsw2RdsRYsqSuO3t6jE3sb2nOcfevuTMMdxcKLk1U7O3Ta39wPJoieKv6QMY9FweGqr/
	4WSZ3+g4TfxT932WiOZ6xw+Ce/F9NcAHrtlo1wV4kKqFHB7soCp+01ud5AmMW8aTkBHVHPbFWwj
	qPBTL5lX/lHBsYYtCU7ySeEWnxUdHXh1OS4EihJ0FwF4/
X-Google-Smtp-Source: AGHT+IG0Zy2onfPOCf3cQqr9oNwibRTwFlFoKRASJD+QGncsrGzGltXHMxWZXfPCP+kSB0ggJQ37AQ==
X-Received: by 2002:a05:690c:6312:b0:71b:6635:df33 with SMTP id 00721157ae682-71b7f07fcb1mr10967007b3.30.1754073347587;
        Fri, 01 Aug 2025 11:35:47 -0700 (PDT)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a42187esm11931567b3.41.2025.08.01.11.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 11:35:46 -0700 (PDT)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Tomas Henzl <thenzl@redhat.com>,
	Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] scsi: megaraid_sas: Add check to avoid potential NULL pointer dereference
Date: Fri,  1 Aug 2025 18:35:44 +0000
Message-Id: <20250801183544.38154-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add check for the return value of megasas_get_cmd_fusion() to avoid
potential NULL pointer dereference in megasas_prepare_secondRaid1_IO()
if r1_cmd is NULL.

Fixes: 69c337c0f8d7 ("scsi: megaraid_sas: SAS3.5 Generic Megaraid Controllers Fast Path for RAID 1/10 Writes")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index a6794f49e9fa..4f1c1a5a71a8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3426,7 +3426,8 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 	if (cmd->r1_alt_dev_handle != MR_DEVHANDLE_INVALID) {
 		r1_cmd = megasas_get_cmd_fusion(instance,
 				scsi_cmd_to_rq(scmd)->tag + instance->max_fw_cmds);
-		megasas_prepare_secondRaid1_IO(instance, cmd, r1_cmd);
+		if (r1_cmd)
+			megasas_prepare_secondRaid1_IO(instance, cmd, r1_cmd);
 	}
 
 
-- 
2.25.1

