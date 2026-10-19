Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792438433;
	b=N7p2seQB5SygqqmbYADxjus+lL9ZXGCF4R2E2e/cZCNYWd42F0LS3aeYIdnHRtX31IWM
	 zTbWvJIu2yBcCLjHKW1938hyHxD2U5wQJcFITC3u3fY6PmitfI5EUX7u/H2r3QAYvCcCC
	 AFvj6+ZBy8BcOdfQMyJ+853p4/TsPPBwVG9kb09eT0KtjWcKO+Z3pLgKI4+bV/uLLz40/
	 dYZ7bq9f3ZKThZ8Vo+N/AIgCgCbkmIjNeqMaz+SYh1crD3QokBXf9Epj+sVwEblO+tm5v
	 PHS8W9PvHC8eDwk+B8wsY6HIfaOZBCT7wXN+PhXbchOlQeN3lZ0KZR7OfVwC5C4aw6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792438433;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=w4dX1JpC9mAcUr8L80SoNaK8rqXYkTomomo1LuY3oOI=;
	b=dYaYgUMpAq+8jRPNYSfSPDly8H6fpezTmCZUKkex1pWUPl6m5rkQk+NGEFCS5WUOHFyM
	 QSdtAtZYzhz16YBMdAUZgkKZKKVT0kodi36JO5sKGdiVzEEYmHgMcusLEYePOb24kZKjh
	 /Whj/oNmvOswWCVWJ4V0cFCkWQY1zv7b3/dEV/6Eg3mHwHBho6ZihL8/jWTHvvCkrbpEe
	 Wbebj1Qc3bdj0ueZcMuRBqBoklJsiQN26LBUxqLs0G5NA9mhYaTzqdCzV1bTqmrHEcWmh
	 jRRR/U3O14CZ0HJpR9cEuo6DyTF7EE5xI8V8q3gotHoo8pVRZC6lauBnWuH4vYS73/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=emmdxGEf;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15ED606A324
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 19:33:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D15ED606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=emmdxGEf
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a1635f7c89so23911865e9.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 12:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792438431; x=1793043231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w4dX1JpC9mAcUr8L80SoNaK8rqXYkTomomo1LuY3oOI=;
        b=emmdxGEf+H6lEdV9aSLGsbZdA9h6g5E0s0zjMsZw6fN8z/BfHvZb5i87mgf3LGtN1G
         KEazRFlI8+kzSEZIhzi93a3b5axfv4s8C8qePFhktToSwiyz+9O0NHa0KmoT2DOqpZgM
         tUDrWylI4mq+HPGDQu3EoVL9MKbocYT496uW28/gftlFIYKsUw3/M67h0IBaYvXEncTi
         HxP7+gSjXQDONzGJ/2GM9xYubqm+f5yb56fPO+LRHTibqWul1+H99njgKCgiKyx4Tiy+
         mggaAjUasfcNetrdu7ioiZEtTFnAiiamvN4fIrbpv1KaVkNqSW1oQ7xyP5Ap2bp/jOTA
         pm5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792438431; x=1793043231;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w4dX1JpC9mAcUr8L80SoNaK8rqXYkTomomo1LuY3oOI=;
        b=SIMhP82fj+h714vIv+lQrmQgr4PWb1c3xJ/emkFi2wOpg3ihkvaqY/j4BNwBuji2aW
         EmDj+EPHwpZ7ArAshasAnhnWbEyTG+y7XdqgzloyXY2Px/1+An6YXuTUD2gr8AhVitbM
         vygE1NErbD9RBG/NVZtSwIc7BCWXGBVbiFImJSBtkauhZ7MNrAF7iKnOKgYBPWLGqNrP
         qo8YrRu95Ut5m0R6gaMH+BL5dLp0gOC0C78hozkFNoGJaF6Xp4KsuZHASOZj0TDLrVS2
         yYMsuqTXV6YqiZ3gNdiqFY2ZGDKLCz5wAZA63MstwuBylXQ5jwJ4H0V9AQIQxpowUVC6
         RBNQ==
X-Forwarded-Encrypted: i=1; AKwUvBykG83TxY5QUvNapBgWR3xxkJMa35mSl7awKVfkAfqfikz7xwqa6cL0PVKc6wiJa7sVrAg0vRYywvhl@vger.kernel.org
X-Gm-Message-State: AFq9FYJgDJHHHxf0bgRwk/m1s3lYkANNcUnA99fpkD+sAMOOrliHpag9
	7KIz8ME0nwtZTcN/8JGw/VLcYSadkewfQr5xvHA8gqesJkD0B1Bfoa4=
X-Gm-Gg: AYBFou1QzswmNC4X/JZSUz7c2wtwEuUmT1k/kj+d1fOPKBHKtcGb/HBpbR9zmkMo41s
	mqunZ8Sm6uDDHhHzjMg8JuBaLb1fBH0dDGJiutVhBfFSCJnWIsLJekGSS29ZX27Sto5567K003L
	SSxbXK7dJuX/zfcclJ7gyrUc8052kUZ8KxL8Iq5Et+vH2Tu4k+uQQv+JYwFm1Mc+RVXFbTxcX5S
	weG1isvycSwhq0c3E5MC4bim+0qu8UaeOi8sXhQIoD/ooBe92tbFEEVi1u95t59Uzg0MRG8gdUv
	kMxwuAaK8RIARNlg8Uvo0w/0naFZT7yADH7oDcJiBcm+5JAXLhLxbZNnrC9V8QiMDZBRzN7ARrr
	NzUSss0PNLqlKIlEzFcmdcIpjLRMtpVfd14dVlra02VwtlhfFyaUQL0jKSkHbarYVF+xQouFr7v
	HHCOtF9J0X7sRPgE0JRTcrO629j/1SIrZbdyUvvmI=
X-Received: by 2002:a05:600c:1c0e:b0:4a0:b6:4619 with SMTP id 5b1f17b1804b1-4a1d7462e34mr199327485e9.0.1792438430846;
        Mon, 19 Oct 2026 12:33:50 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1d81035csm904816f8f.15.2026.10.19.12.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 12:33:50 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
	linux-scsi@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v2] scsi: ppa: cancel delayed work before freeing on detach
Date: Mon, 19 Oct 2026 19:33:49 +0000
Message-ID: <20261019193349.1176493-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

ppa_detach() frees the ppa_struct without cancelling the pending
delayed work ppa_tq. If ppa_interrupt() is still scheduled or running
when the struct is freed, the work function accesses freed memory via
container_of().

Add cancel_delayed_work_sync() after scsi_remove_host() has drained
all in-flight commands and before the struct is freed. The cancel is
placed after host removal so that ppa_interrupt() can still poll
in-flight commands to completion during the drain, and no new commands
can be queued after scsi_remove_host() returns.

Fixes: c4028958b6eca ("WorkStruct: make allyesconfig")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
Changes in v2:
- Moved cancel_delayed_work_sync() after scsi_remove_host() so that
  ppa_interrupt() can still poll in-flight commands to completion during
  the host drain. In v1 the cancel was placed before list_del_init()
  which could stall scsi_remove_host() by killing the polling mechanism
  for in-flight commands.
 drivers/scsi/ppa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 8a4e910d5758f..d4fc8eedc29ce 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -1139,6 +1139,7 @@ static void ppa_detach(struct parport *pb)
 			list_del_init(&dev->list);
 			scsi_remove_host(dev->host);
 			scsi_host_put(dev->host);
+			cancel_delayed_work_sync(&dev->ppa_tq);
 			parport_unregister_device(dev->dev);
 			kfree(dev);
 			break;
-- 
2.47.3

