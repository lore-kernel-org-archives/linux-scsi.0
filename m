Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CF0346FAD
	for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2026 15:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774451729; cv=none; b=uMjilse2wqhRHWUH+G6FMuTuCJ+E5MTi73/jfjeaHRh2N8zfzgRhbH353EpSUPu47gGsNUfRojZYM0j+FRs08srT6WTeOLtbG997HXXJbLxf1jTg+eo+nZXvRye9X5FrspLMmRVy/oltJg3LFKqrLQDjbPoJx5wQpUj29AIMiic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774451729; c=relaxed/simple;
	bh=PrCkJPZyhtX6Y5FzjWZTyhPI//MFAUXjz4tH2yubBN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xv57y40MZNM6Sf7oj86/xh+GC4eL//Vb8FYxVpU/DdX5aKKLu4TTk7YrwDKHtqFDoB9kzUVaOZNBN+kx3867cZV+hYnUgUuycbSwdv4d+yqH6F4eDEe/6XeXQV0k9+dXMyPfNirkN7q0O/O8I9sR8xdFOy5o97wH4uQPqW5H+EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=QxE84NxQ; arc=none smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="QxE84NxQ"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-12a74039dc6so2182694c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2026 08:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1774451726; x=1775056526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jYJQmgQchEB0WIt9K+RZv6PV4mbOEYdlgFRcSK67Yrk=;
        b=QxE84NxQs6gnjAdO3acRXdrdZP2hiB/5bK/BqqHXKEEbOy+Atd5xqim+S50zLjaFAv
         t5WHwuezCGWUZYfWT33XPpXD3J+1fj3vI6TJ/Bue44jo4GvikWWgWCA5WiOoQzlyN5DK
         IVaWyAGMSY7L3rEPETZbf8q9vkcKeTTytKEwO+xzZ1sBIXbOixIEgxumu8LHAbXBHjDk
         Ih+dPtqVxqqAPK8eXdHpAEXtIHZkDr0v9sBF4xQk210Ldu8+xD6gXNaMQ06CI1UqvjcZ
         X97le8tw41GHMTGqSfxusn41Qsq9J5F7GMOKm5NsLlNYSwGKoCciqfa10vMO58+4ALtn
         pTjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774451726; x=1775056526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jYJQmgQchEB0WIt9K+RZv6PV4mbOEYdlgFRcSK67Yrk=;
        b=iEvyHjaEwv5Fvib8NYhKkoTJ6GqFqyc6pCVNt+hYEfyrcEh3rhznwn0XIfsFL6aqqp
         vWVZ9/SOcLw/TKalXZCX9EceXFiUjdee1t/OzZgpazcFhX6FQ/Xd+b0xSS7Tey14NdoO
         D1HbTJ+oPTuOHWt0gCeo5Vmdl9GtqR+BWKBoQhWFET9L8MG3HrLe7hczxTf0SVsCF7Fg
         QnRVGoHuDyK/Ast4W9WC4gVPtK3gRj3IfWrrqHZl7qjT9JqGGJvx7gU25gDRuNZsUpPy
         XvdMPQir+OwvSihtxKwP6zvOLxE9yQW6cT/4EOS1/RUeH7BU8qKeqJ+hF9lCyI8E1zTP
         56QQ==
X-Gm-Message-State: AOJu0Yx6L2OPgv/VWHV9SXN2XQTZQaBLuLK62VvSrEyGWZzJxtVdyY2C
	04zMH1pK97pGYi4Zg+d8ZakKVL+2WCq9NTGvwUfnK8DFUS4tlUjT2XtB82cYCZ7cy5UJ8TKRVP8
	ve10nSnnOjKqV7H3NxJNxbCNdcwAKWChGBwt6Syl+YHi01Ul8qk0cnvSDUHfwrgIg11L6JFvcV6
	0/TlUuIPb0sMYFXlWXIVDOmsap5d+R5bvrPLRaw+XYwtuDn2o=
X-Gm-Gg: ATEYQzyR9ch7L+14cAN8ngSk/faPMvgz1nBWXCxXyoM84orOjccnK9tuI20rftiuTQD
	gXxnuTYKttjuCCiki927UZImMe68e17bz3El+/94R/4TK7/dReZIZG+xRWZeTOP29BQYEC42Wre
	JYSvK03GPjmeC5T/HIKyGyzQkqvHjo5Hd/OurlbxdQXNh4WR0GL1O5OVnUGGFtOs1DJ+fgQnSYH
	aBXKoRjCxXGkYY5YoiBX7ymS6frHyXXOsEX2w7FKshSMXc4CxfAo9FM4ncedUcNTvAE3JawqtGx
	t6j+sgdwCZC0apMy/feUOF0DkZuYzXZtU6dUKCx6LByTn+RjYLWqpGVyud5RkAm69FRnAugMQO6
	Mx4QQ+BH5LXgY7NDpqde0AWekgVlMW94CidPu4CcyvDrM27cCIbgm43+HKZMLXOccfIffwiPkYG
	bJCKQHahWIjHX5I8OuGrGN3G49OVlod4QD4khOs4G8ZWg02dFDpM8wf1T8wMroGbiWNAdBzipZ3
	C4yhqAmwVbnZtxjaYUbX1oFwwJ+ZngidUC1zHrpDHxLxmMBjCLvEN8=
X-Received: by 2002:a05:7023:b0b:b0:128:d577:dc21 with SMTP id a92af1059eb24-12a96e68023mr1948988c88.13.1774451725345;
        Wed, 25 Mar 2026 08:15:25 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.81])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12aa7274231sm46740c88.8.2026.03.25.08.15.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 25 Mar 2026 08:15:24 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org,
	hare@suse.com
Cc: Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>,
	Riya Savla <rsavla@purestorage.com>
Subject: [PATCH v2] scsi: scsi_dh_alua: use the device timeout rather than a constant
Date: Wed, 25 Mar 2026 08:15:15 -0700
Message-ID: <20260325151515.18688-2-brian@purestorage.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260325151515.18688-1-brian@purestorage.com>
References: <20260325151515.18688-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of using a constant for timeouts, use the timeout of the SCSI
device itself. There are reasons why someone might want to extend
the SCSI timeout and having the constant out of sync can lead to
early timeouts.

Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Riya Savla <rsavla@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index efb08b9b145a..a4ee67109548 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -143,7 +143,7 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
 	put_unaligned_be32(bufflen, &cdb[6]);
 
 	return scsi_execute_cmd(sdev, cdb, opf, buff, bufflen,
-				ALUA_FAILOVER_TIMEOUT * HZ,
+				READ_ONCE(sdev->request_queue->rq_timeout) ?: ALUA_FAILOVER_TIMEOUT * HZ,
 				ALUA_FAILOVER_RETRIES, &exec_args);
 }
 
@@ -178,7 +178,7 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 	put_unaligned_be32(stpg_len, &cdb[6]);
 
 	return scsi_execute_cmd(sdev, cdb, opf, stpg_data,
-				stpg_len, ALUA_FAILOVER_TIMEOUT * HZ,
+				stpg_len, READ_ONCE(sdev->request_queue->rq_timeout) ?: ALUA_FAILOVER_TIMEOUT * HZ,
 				ALUA_FAILOVER_RETRIES, &exec_args);
 }
 
@@ -512,7 +512,7 @@ static int alua_tur(struct scsi_device *sdev)
 	struct scsi_sense_hdr sense_hdr;
 	int retval;
 
-	retval = scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
+	retval = scsi_test_unit_ready(sdev, READ_ONCE(sdev->request_queue->rq_timeout) ?: ALUA_FAILOVER_TIMEOUT * HZ,
 				      ALUA_FAILOVER_RETRIES, &sense_hdr);
 	if ((sense_hdr.sense_key == NOT_READY ||
 	     sense_hdr.sense_key == UNIT_ATTENTION) &&
@@ -552,7 +552,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	valid_states_old = pg->valid_states;
 
 	if (!pg->expiry) {
-		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
+		unsigned long transition_tmo = min(READ_ONCE(sdev->request_queue->rq_timeout) ?: ALUA_FAILOVER_TIMEOUT * HZ,
+						   (unsigned long)U8_MAX * HZ);
 
 		if (pg->transition_tmo)
 			transition_tmo = pg->transition_tmo * HZ;
@@ -664,7 +665,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && buff[5] != 0)
 		pg->transition_tmo = buff[5];
 	else
-		pg->transition_tmo = ALUA_FAILOVER_TIMEOUT;
+		pg->transition_tmo = min((READ_ONCE(sdev->request_queue->rq_timeout) ?: ALUA_FAILOVER_TIMEOUT * HZ) / HZ,
+					 (unsigned long)U8_MAX);
 
 	if (orig_transition_tmo != pg->transition_tmo) {
 		sdev_printk(KERN_INFO, sdev,
-- 
2.50.1 (Apple Git-155)

