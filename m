Received: from mail-dy1-f193.google.com (mail-dy1-f193.google.com [74.125.82.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1B430EF9A
	for <linux-scsi@vger.kernel.org>; Sat, 31 Jan 2026 02:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769824810; cv=none; b=Rw3XwYyk+cB45o/7R+fCPQfWcoe4Vgy7kAX3mV6CCQUooul2KY5hgKI/7OVj/GNPGDp5D6Zc1pAbrx5UjHfm6SUOPrfZT6jk3qY1F/dtVXgwzwUn2ZM2AkAvu22U2Ao/mOLsjB/HfN0sFky0D66Q53+PUujQ1fY2MxiwmuJg5cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769824810; c=relaxed/simple;
	bh=WPOR7pIlzAsSFByXTLbPME5Bd6fb9ctdAJJ6G+O0JIE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m+Og00UYYqn26xrp9fu+Za7MiJsk1WKBSMFptxc1btBPxqasPF7WrOXPvI/nV+V3TBMFQAsenluWm3sakYhFy88ROE1x1HTaTJHU5bqCvV83o3Zj7sv7eHH5TlwZp+Ekv+XtxoZW+Wh/LywxQ0h8cYFSW+ZcxAW7/HPVhkBc6Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ho0P+egy; arc=none smtp.client-ip=74.125.82.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ho0P+egy"
Received: by mail-dy1-f193.google.com with SMTP id 5a478bee46e88-2b785801c93so7195605eec.0
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2026 18:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769824808; x=1770429608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xh/fhDvJm+09EONysSb7IvhqVl7p0cQix0svyoQ0Mhg=;
        b=Ho0P+egyrohH4H4kCXJ/1Om49ZK5Olziybjhzjomk685Df/w2vRU6i9ZvFfYnVt7m3
         jBp+7HbPgERg81r3qj0WSt6pMAw1+PClrxmuX8+1rd7Ap1Rr97Dg93hI3MDMk/StKt+1
         P/Jh0BCjnEfx5kvnFMWESnTEHF2LrPJ7hTVIPih+QE2HQDHc9/ptN44/4CuRFBIRzYTJ
         Dafodd0omXbyuKl7x8glThja2wcEjefxcmvzbQ/9az6BfuBX/KtkOpeTn06Yus42gvm3
         x1qe+DLLstLBpoiQPaG2o0CL1+bdiOljQqZBqw6cklP4OPIh2ODdaS89S3n5HbQtlfYe
         tx0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769824808; x=1770429608;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xh/fhDvJm+09EONysSb7IvhqVl7p0cQix0svyoQ0Mhg=;
        b=qa1P0FJDdwfKTR6uk7pMWrwxOqGn8j89xMRUo4ReTr79DA051qwhB8xIRaI6kev0uw
         TUIjIpQ/HwPIICO1F2V79NjwEeYaOGL+Uje2c5VpoVoN+ci2peB7G+anVUa4UP51Fe3/
         OAqVDXyGEeMCuYIJnx340Glk/wH+pltSeqMQ1+y8/wszg6a1JIgHB25nwAiv2Z6VhV66
         afYwlrbvcKHbqN4SuCenAa10xjjvlns6pGgMNe7UoM1k+1VE/X+R1+CLct7IKJnYPHOY
         lii5sID9OctiUdDEkMWXFX70vHAJAmq2STzdl9SUiqehmGT7AZ0QAym0nP0kfP6ONBPD
         YpEw==
X-Gm-Message-State: AOJu0YxEkQkzbJ7f4ZwuGaTmZ5IDHNai+nxayoE5nv+vu91SKbkPklJP
	ss2qta8No5T65lDrmbBfe1brRiWz5uiyyXoaRI3STJbJcdGjgyUXsrvyta/M1oI5
X-Gm-Gg: AZuq6aKPG6aZieuAy59TYHvnit8RKFefb6F2wE3fduigw+hWEqI8Yg3aCcmlHP95b52
	SGLYGmlIUmDbMQMGL/TpCH36xnUxPX5EWJ8h4AySW9Igm442P2Y+PqSxZMn28lfoaT7AEQKR4iV
	Wf5eSR4HqolmdADCI+MGszG5Zbi66XjUbJ3TTagi1/GYl3RLsXrlxGw0rVW3EeDu9CIK+Mk8zz7
	jABIdcmF1z3DESPtdDTTAAjnRZPzdNVyOEzbZgQ05vCI/OrV6JNdSoW28uUp37DSpNo6og/H3K5
	uAFbdc6ySahlDyVQ+lIk61grxXEJU8IgfCuI8nC4atHpa0FEg27jrZmocK6N3aiTgLg/73rYQoi
	GNLa7EOSmK1gK7tUs2z0x4p25n3s1ox+FMfgRsZL7Glkz4Ditz6kp1KNdX6Ez0w8NaWt7KNX5Pg
	40awUJx5tHWbWjU3loyZUWV9ve98z2I5gECkttAPo7qw/Xx0fMwt74tBwtDiGnx8EpprSNjN/aO
	rPy0QraG5NuyZkZAywU8rfDBlnuo1njFp2Vdc+wpRaL9yfUH/RPJQBtQqkBPjKkleVjCz3IOjsT
	hTFHhRnSwSydTUk=
X-Received: by 2002:a05:7300:8ca0:b0:2b7:288a:e582 with SMTP id 5a478bee46e88-2b7c89286a6mr1719482eec.33.1769824807614;
        Fri, 30 Jan 2026 18:00:07 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a1abeb6asm14523685eec.19.2026.01.30.18.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 18:00:07 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: qlogicfas408: remove unnecessary module_init/exit functions
Date: Fri, 30 Jan 2026 17:59:59 -0800
Message-ID: <20260131020000.45582-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The qlogicfas408 driver has unnecessary empty module_init and
module_exit functions. Remove them. Note that if a module_init function
exists, a module_exit function must also exist; otherwise, the module
cannot be unloaded.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/scsi/qlogicfas408.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 1ce469b7db99..859b3502cdfe 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -611,25 +611,9 @@ void qlogicfas408_disable_ints(struct qlogicfas408_priv *priv)
 	outb(0, qbase + 0xb);	/* disable ints */
 }
 
-/*
- *	Init and exit functions
- */
-
-static int __init qlogicfas408_init(void)
-{
-	return 0;
-}
-
-static void __exit qlogicfas408_exit(void)
-{
-
-}
-
 MODULE_AUTHOR("Tom Zerucha, Michael Griffith");
 MODULE_DESCRIPTION("Driver for the Qlogic FAS SCSI controllers");
 MODULE_LICENSE("GPL");
-module_init(qlogicfas408_init);
-module_exit(qlogicfas408_exit);
 
 EXPORT_SYMBOL(qlogicfas408_info);
 EXPORT_SYMBOL(qlogicfas408_queuecommand);
@@ -641,4 +625,3 @@ EXPORT_SYMBOL(qlogicfas408_get_chip_type);
 EXPORT_SYMBOL(qlogicfas408_setup);
 EXPORT_SYMBOL(qlogicfas408_detect);
 EXPORT_SYMBOL(qlogicfas408_disable_ints);
-
-- 
2.43.0

