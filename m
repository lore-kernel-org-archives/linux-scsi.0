Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E26264614
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776358525; cv=none; b=s4EQ5UMtuk9VWWs/mHW4JgARfoghnkM9hKz4Wli2e+arB9BUJvV1aFIa1twV3F5LctVLf8HPyf66yZbg9kFRFHp9VVlU0XaJLbEvk3qMT02TEB6cP6FtDpd7wuIGVC7bPuKGDdHRgqy6cY8PBOheHkt4KnZRp9XCnH71CpwF7QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776358525; c=relaxed/simple;
	bh=tx8O6vQLcp37viM+vOfgjXLEh+FOD+ofSxJ7tOBqZPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8Pc4ACXosDi+9ArjjrhA9dR34M/fWOVDWho1+VKQGulPmVMsaOMmIWDWQDGsU9K2CbWqHprawVDnNEQ+k/XdXIRzVfa5IZh+zk4wLtGLS5YvcHPm1lj6TqE/M1144q254c8K6H1x65fm7JnZ2QcV3rMU56WNaZnu3krq/vo/zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=aQls8S8J; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="aQls8S8J"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-12713e56abdso602326c88.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 09:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776358523; x=1776963323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nd/mW1t//0OSanwooqmtd3lxZe9tbhkFE314DXn8KBI=;
        b=aQls8S8J85qj/M12LfapcPXvUEXPUZ0Pz+mJI0cqCsnmR8rjRKQAFXmLPPWnum6kQd
         lPYjunRO63I4bdCOu1yGloRfkKN9HVEhQFaytYodGQ8LLt+AJh5T/0U/TOeV9PGPyqyj
         v91MPeZPJosyRchZh1Dz3lSAQn5QQ+pPvgI/B2emfhQhmZE8c67YxhcNNFJy9B0jcG3B
         h7RxXjEkZk/vOWZ+dua4sxAwCRzD2/su+UcLeorDOITGd5QTKlOVBuu/KI7pAa0iMM+T
         m8xySXKlqyLo/0ULbnyK2S0Gjy3/IHqhDaGEWX6dOceEVlfueEwqfquq4DYu+Tng2BLm
         Woxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776358523; x=1776963323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Nd/mW1t//0OSanwooqmtd3lxZe9tbhkFE314DXn8KBI=;
        b=GnZwrpVU2/iHeFU57SrtRkAdS1FpJQ9lzAAmlhHLJG2YlqBjt33tnWNaAcwSNBXOHI
         N8BbojZMLCdQ8vDHmma8ujiFSo0QJJCjguXh+G0O3EqPElZCEH1M84DyicFrVCj6jz9i
         U3RJ2QogjlAp1pJokciXRwPmNltLEWgrEaxgV7Y5N3dNR5lLopznrgnUnC+77e+eCUyz
         96vTCys/d1Re/HxEGbdJClUJORzw4qEiKFvSVPNzKmnkKXBqGk3mZ8qAYRns3rCHueDl
         1CKBj5QiN0mprHaXnOKbobXZX4uQ+uu1Q6NyCScFRYloC620Co4tVmniC0iUEGf6T+X6
         QLgQ==
X-Gm-Message-State: AOJu0YzpbX+vVGIZiuiEpSJzZFLGkTLk7Ha5TrEPXwyeRkRj3ABD1KpB
	bUY9rkzN4is9CNtQ4552xoF3nwR6tZgU73ddijwJXo1y0tKcL+qn7NBJpIPjkymIxJmZHxh51UD
	ExQNTK+cULYOTjDIHlRRJWAV8bUpTE30UOMN2TdR7ZgVpLmBZ4zPyT3N0e/vziODJ8ccyKkJPc+
	W8DUmag9dxMM08ArFmyxKmzukfhmVJjGmrZT45OB/OAozY1lA=
X-Gm-Gg: AeBDievtHzF1XXnNiaON3TsV2VgNe1Yj2v2W39+vno451V80K7aSoD79NAhf/pfAeN+
	dR6S5RxKH2ciRnyWr2vMdsknhoKjn9P1Lbfsnzjlq1nF0oq7J3BaXR8LFLKeIF5ouJNFsr3C7Ma
	AGknUgi7RmlPt95ITMxUDyvjASAQLHmYAtZNoeyprqi4ZuSx3MPENd6qHdBJZ5hWsvHmOaA9vpe
	aF2BYiYhpx679Ux9L2k2v2XxFXmo9hZOoUCguVMqm/+3iL1Dz4rkyCMqE6uAKlhxXaVjLGS7Dcb
	21XY1WRuiBxNwv2S6GjrdYow/DgdXkEap3Ve/OLNkyjZvjNVRQOja2p7bF1bHQwSAR9Lwvuhu93
	kkz6peOnOq1drd1w+RbvB3di5lBC88VmU///cj1JoZw+MIPq9hieWF12h1WYnQOUYKzQSZ71kMk
	FYcEBi4aHjOqyjuwwWnT+hrOIondqaVS7UUbg9jUSokJW++AuadUDmvWjZmkRAgREo7TjR+UH+1
	NbNfftRjSfaokOVx3pb7xNF9UoHTtAcmFIrfaoJwE5Z/CP2KGkQ9uknSFQ9wWRNbOiPwthenOoo
	g9bb1T4DCsgF2fEcfzRTXWHR0ic6LQK8HTQ=
X-Received: by 2002:a05:7022:220d:b0:12c:f77:f087 with SMTP id a92af1059eb24-12c63123e38mr2120943c88.12.1776358522458;
        Thu, 16 Apr 2026 09:55:22 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.113])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c5e6b6a05sm7461733c88.14.2026.04.16.09.55.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Apr 2026 09:55:21 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org,
	hare@suse.de
Cc: Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>,
	Riya Savla <rsavla@purestorage.com>
Subject: [PATCH v4] scsi: scsi_dh_alua: increase default ALUA timeout to maximum spec value
Date: Thu, 16 Apr 2026 09:55:12 -0700
Message-ID: <20260416165512.26497-2-brian@purestorage.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260416165512.26497-1-brian@purestorage.com>
References: <20260416165512.26497-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ALUA handler maps a 0 value (no implicit transition timeout provided
by the target) to the ALUA_FAILOVER_TIMEOUT constant, currently 60
seconds. This means the kernel already does not accept an infinite
transition time.

However, 60 seconds is insufficient for some arrays that may take
longer to complete ALUA transitions. Since the highest value allowed
by the SCSI specification for the implicit transition timeout is a
single byte (255 seconds), change the default to 255. This way,
when a target does not provide an explicit transition timeout, we
default to the maximum value the spec allows rather than an arbitrary
60 second limit.

Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Riya Savla <rsavla@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index efb08b9b145a1..80ab0ff921d43 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -37,7 +37,7 @@
 #define TPGS_MODE_EXPLICIT		0x2
 
 #define ALUA_RTPG_SIZE			128
-#define ALUA_FAILOVER_TIMEOUT		60
+#define ALUA_FAILOVER_TIMEOUT		255	/* max 255 (8-bit value) */
 #define ALUA_FAILOVER_RETRIES		5
 #define ALUA_RTPG_DELAY_MSECS		5
 #define ALUA_RTPG_RETRY_DELAY		2
-- 
2.50.1 (Apple Git-155)

