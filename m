Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F286734A3C9
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 10:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770718110; cv=none; b=A8FpukXJKL/37I5FQCsnfXauG5XZ91rcfGPqv1P3KnKcG0+V5vSQHkAZ0ueJsfpZJdJF3Pb14dn+YNunxgt/6iB3ZSfwnyUa+mjpzUZX0d4RbcLhfTypsD3MKEAbNxse5ZDL9t7NytOW8+m/mdyAz0p1LQBNXFCYZ2O5Ur3wCvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770718110; c=relaxed/simple;
	bh=g8cCp8SVweSihnrR9rMsrRXF9XO/JoQgmnDE3KnS4rA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EbjzdmqnupfsSoskthGdvw7G/yHnMWT6NLx6iHzW4yfypNs502+1UrT4smqMfPdDrEDuBGG1xQ7l3lF+1aLOdy99XkqLhVgu9aszJazWehx2eD2D5gT/pSR3ETtdaU+NhJRHkNgef2oM3LAqFPG3pOavu33kGV2k3vE/hnD4pUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X27Oi7Pq; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X27Oi7Pq"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-482f454be5bso54121345e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 02:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770718106; x=1771322906; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yVaRDWsLmokfItqakaemlVq7gRQyDWlLjmBO7o/2Rts=;
        b=X27Oi7PqoFfG8iFthzXvDJ7Yiy2Req+dsARdoC2B+/bVf+5x9oXJujNNnq/IjVWOBl
         GjZq4dPFE/IxR0UlP2mBTwRoFVOBHSw//jVgU0KH0jRgzwaN+WLSURNq3wJpq2QYgGWv
         Iid/1vHi1K0INl4EG3IwW1jNSvbgFb+A9dyjzKgch4iC8h47pAu83rU6upvv2z/rAZRs
         XvesAJv+8ccib/t/5zBhsJNmziSc5kT3VicznHs6xVvYloe5t+K0PGkLxSD8qHAJMAi1
         kSwyT9fgalEh36VagXzZeM9rngSzgvcEyJROGCSELfIl6KwDh8RF0yo3jaMVN3W94/AN
         r/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770718106; x=1771322906;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yVaRDWsLmokfItqakaemlVq7gRQyDWlLjmBO7o/2Rts=;
        b=PKlJRCJfn+HYt7wPP4tfY8FNci78X0iIIt3cy53mE/e0rm0HvQFT+xyyJno/nbrtqY
         RauFNOToNEHDb2VLT2/x/bu/LqiXDDrEIRM6cXPuwkmSA7lDUkU5xreXeExc72uRIkDz
         cL2pvgrLfpJQbaCzFGbqi6k2fXfTyT6aI1UhRcpHSZykyGc6aUBYSAmD7deKEEa4euha
         9OVJ9kKOJUlEFS2/le/LkashEfp8HrZpIR3gN8YWWeHhNPcA5tsHaGjFB9IeGgx2yoS5
         M5Vv3dki+IwkgwSC4AWv73S9wuZFYU+A/xU1IxUiHsi0GvJnEPKmWs3lfpFWdTyFdcND
         4u5w==
X-Forwarded-Encrypted: i=1; AJvYcCX7AuBmQmooAIuedXzbwKvZk/wEnZeCD660spfObIh8Lu0MR3B7j5lrNCRsdwxBKJqsXfpAqBkzk8u5@vger.kernel.org
X-Gm-Message-State: AOJu0YzG61eHHoNekkQwXpv1Z4pmmHR1tDElkFvpd7+KKsnwZ46fliEk
	4x3MNwxm5bhc7zLVsZBEFI6UUTPkM240JzTyE6jdxos6TaVRzYfXsPQ=
X-Gm-Gg: AZuq6aLM4A3++vNAoOPbEOy9vHvfe8J0JGrK6ERu0fGzFf16wfMTHigsvDBb2Vv/WAV
	5q/jlrIIyS0L6oPZzeO/DzIJxAr0JPRDO0phdfM9jE4rell0C8vthmJ7yGdswMY4UKq1O0ZUmev
	Ujl+IR7c4+ZXo5LRzFgr6Gd0FHD99IY1C6eqrI9r6VNoAaT2ryxvarcGXqbzZaaEEQIqel623GL
	Gy7H321f6/214Z2Zf4iPjUKyKbhpzbKhVSPKKzabZq7Tm9mT9E+JV5qkAvgpagyxMonRpkTluTX
	CxUYq0J+01zX0k7ot6yKHg9Lvwtaoqo+/u3GNJ4w8C4jGc4Tc0ST+y8pevby/zH+gyo1za/vQVJ
	by4AyAwe280HWnY3wc7A3Joc/E1PEjjE2g/G4yqzGO82dOWLU2a13c8pKQ0QNcfM2fhK0cPfpN5
	bLid7DunkBmlx0CkPQIE6C4hn0XCTt0vMF
X-Received: by 2002:a05:600c:46cf:b0:483:4b37:8620 with SMTP id 5b1f17b1804b1-48350530e24mr22715885e9.10.1770718105653;
        Tue, 10 Feb 2026 02:08:25 -0800 (PST)
Received: from vova-pc ([85.94.105.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d7e74e5sm47719775e9.12.2026.02.10.02.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 02:08:25 -0800 (PST)
Date: Tue, 10 Feb 2026 11:08:22 +0100
From: Vladimir Riabchun <ferr.lambarginio@gmail.com>
To: njavali@marvell.com
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	skashyap@marvell.com, himanshu.madhani@oracle.com,
	qutran@marvell.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: Completely fix fcport double free
Message-ID: <aYsDln9NFQQsPDgg@vova-pc>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In qla24xx_els_dcmd_iocb sp->free is set to qla2x00_els_dcmd_sp_free.
When an error happens, this function is called by qla2x00_sp_release,
when kref_put releases the first and the last reference.

qla2x00_els_dcmd_sp_free frees fcport by calling qla2x00_free_fcport.
Doing it one more time after kref_put is a bad idea.

Fixes: 82f522ae0d97 ("scsi: qla2xxx: Fix double free of fcport")
Fixes: 4895009c4bb7 ("scsi: qla2xxx: Prevent command send on chip reset")
Signed-off-by: Vladimir Riabchun <ferr.lambarginio@gmail.com>
Signed-off-by: Farhat Abbas <fabbas@cloudlinux.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 3224044f1775..0de015de7eb5 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2751,7 +2751,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (!elsio->u.els_logo.els_logo_pyld) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2776,7 +2775,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (rval != QLA_SUCCESS) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
-- 
2.43.0

