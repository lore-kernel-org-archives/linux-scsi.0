Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795107972;
	b=oxGFte7fFOXvdNBxKn+OUQ6KRoSewoAffdqVcfqNOSlhU6IhqgH2aGHmlUoFLr+uft8E
	 u5xhxrWNDDt7freG3KBmvROW1loDEURma2SNDchmFg8e15hosi6iafvqqLsV088PmBhpH
	 mkIWn1V+/mnRutLX6H38DToZYwDWith8EcaCw4fx1Og5X1wUbTHwV5Ct7h4VJBbpPYLIW
	 3hHrCogA8zB+HUR6SsGN5cva21sxSdmiDVyn/eFaKGWP3xXVir7zDa/req/yQIZE1q+cv
	 XuY2OkXgrp4Jdcite89KOEzDx0dZ0RKiUcTUraiHDK3oGghIOQvRA0BK/XwadgQFn8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795107972;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=cnk+S66UzyDHe3QGPtEeIJhvpws/OJ1mh8yUxrgOPRo=;
	b=ew5MGtkoUgJKrUKLmYKvtjOX/XyN0NvisN7+beDh/3H4tndq9MzFBGEExPOkA9teA6Ik
	 LE7JBZh4VymyNgRSpB6Z5xWjIAfHfGRnlCRgBCzZUfvjQepxtJdM6ccPQqLamVAnDpvZ2
	 UpdOnCXf8wJTst1SkjaY6UFyHqKKNHa86SvM5KJBPmj3ByTVqVY67QdN+aJALaFiy2i70
	 WTsT4SVwyEIJ8JPsv9PZs1BKRz8iAZU8/ITFXgVcqM0T60mDm8VOambWcr/kYW0wUlr0N
	 XfXI0+I+FROq4xbcAawapUAoqxNyPFbIjYDUouhUPT4NE2YrAz5cY5RiaFMZ03nY0tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=muw0IJ9p;
	arc=none smtp.remote-ip=74.125.82.200
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348E0606A333
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 17:06:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 348E0606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=muw0IJ9p
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3846d5f54c1so1027863eec.1
        for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 09:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795107971; x=1795712771; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cnk+S66UzyDHe3QGPtEeIJhvpws/OJ1mh8yUxrgOPRo=;
        b=muw0IJ9pufguJObqIR5TGGw7Dd54/03fF7wNGpGjvmyrbGv/8lr2oNBvmxO/W6r+XG
         Oh2xwcm2RIHAbouXxgPg5paInNrpMIGO22af6ca2mxTtSfnj9yFoEK72JMc2qm8w19Wi
         pqHm/LXaDbieTyLVHDqTyo+1ktbnxkWVAIKGxIDWUelJGmwBe2uB/M/D3+IDHBAyrF0p
         z9t6knX7OHaE699F4PIPOiwQ3axwY5ke2KUrXJQDpd7WOUoBluhdaSY/BTIIle0Ml7Om
         1HzyIGfo1xrOGasAyr8FeVuE3umMX7/7aQOxiuzHr+N3PIjAyPu5J83Mi+YvSgIkXors
         oUOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795107971; x=1795712771;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cnk+S66UzyDHe3QGPtEeIJhvpws/OJ1mh8yUxrgOPRo=;
        b=ESeaupIXEeRIn0nPoe2ph8hQ9XUuQJau4sxft3RmVAx8kbh1wL0TOZ2cs5gcg+uXic
         9WZRad6Kubh75IyyfJro1ZOWjYIrfd4oiYDfpf7iOPvy/AGIsLYJtDJnvkC2H3ruN6dA
         eO75i1VklnHM5KfbBRcU4zVEVSB2BfRUis+yWOhDTdYv8mtJbG/iezZvKIAjmqURaJtf
         x4DKTb6GkL96CpgktMV1OEn/QEKpQe+cEEoaiAwCMoi88XgdwCyKIHSKEcsMXycmd5dV
         LqiO4R5oHVEXRUec5HzUTSsr2la2UJ2uXV63sbaNQGX6tyTeQDSIwFdxAHjtnaa1Nl4v
         jTFw==
X-Gm-Message-State: APuU4Z+crAhkcUbCqjbujN0nq07j4kspw30mn6816IRKPOw4ZKg/SD+T
	KYUKjyjd8W2oaOduKtO4b1xj21kT6idHM3fRcxcC+yQlgkwU9bjEKXy4/g6jAl2oNotJXirRzue
	Jqawv3eCgYA==
X-Received: from dycns21.prod.google.com ([2002:a05:7300:f795:b0:382:8cee:3808])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:648f:b0:380:c3e7:7814
 with SMTP id 5a478bee46e88-3827ff819f7mr6396707eec.7.1795107971055; Thu, 19
 Nov 2026 09:06:11 -0800 (PST)
Date: Thu, 19 Nov 2026 09:06:05 -0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261119170605.1518761-1-irogers@google.com>
Subject: [PATCH] scsi: aic7xxx: Check ahc->flags instead of ahc->features for AHC_SCB_BTT
From: Ian Rogers <irogers@google.com>
To: Hannes Reinecke <hare@suse.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, Elkin Cruz <elkin@google.com>, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

In ahc_linux_run_command(), the untagged queue throttling check tests
'(ahc->features & AHC_SCB_BTT) == 0'. However, AHC_SCB_BTT (0x40000) is
an ahc_flag bit stored in ahc->flags (and tested via ahc->flags at all
17 other sites across aic7xxx), whereas ahc->features has type
ahc_feature where bit 0x40000 is AHC_MULTIROLE, which is never set on
any controller.

As a result, the condition is always true even when SCB-space busy-target
tables are active, needlessly serializing untagged commands per target and
mismatching the untagged_queues accounting elsewhere in the driver.

Test ahc->flags instead of ahc->features.

Found via an x86_64 LLVM=1 (Clang 21.1.8) allyesconfig audit with
-Wenum-enum-conversion enabled; fix and changelog drafted with an AI
coding assistant. Build-tested under LLVM=1 W=1 (-Werror) and
-Wenum-enum-conversion; not tested on Adaptec Parallel SCSI hardware.

Fixes: e4e360c325c9 ("[SCSI] remove aic7xxx busyq")
Signed-off-by: Ian Rogers <irogers@google.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index d93b522695eb..e12ee18a18d5 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1432,7 +1432,7 @@ ahc_linux_run_command(struct ahc_softc *ahc, struct ahc_linux_device *dev,
 	 * table in SCB space.
 	 */
 	if (!(cmd->flags & SCMD_TAGGED)
-	    && (ahc->features & AHC_SCB_BTT) == 0) {
+	    && (ahc->flags & AHC_SCB_BTT) == 0) {
 		int target_offset;
 
 		target_offset = cmd->device->id + cmd->device->channel * 8;
-- 
2.56.1.708.g77570a6a1d-goog

