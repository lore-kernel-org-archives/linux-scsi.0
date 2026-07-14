Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E9734A3D6
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 10:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784026190; cv=none; b=Oo+jnfNf+NViByGEsYvE8TyZfTXeYHhq8qAZ96CI782DXtaVd+S4kwYAQBlMtrJfl5ocfOspaf6NLZ/0GLRtRi5faNUxIT7K2KHGg4PVHiaY/wGC5UtzvAKHtBmJRkvZTFfmJNuEIkwjWw69HuQG7yfy1ybVY7mcIHyi1b9lSHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784026190; c=relaxed/simple;
	bh=LojW2wY3VHLqJgFF1GSjT5lGd+0QwrjgK5ZbhA0zEw4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TmNgGsfub2qKQd2Q9I6UyR6NjFpNmks71ihgNkmfCzooyJgV0VuHJTu/rkNds9B4KsjWIRdAn5crqrv7qSIqUj7ZEDn9mZ/dlzIUNiN+zCnuA8xSv443q9jelxMGcG6IYcfgM3CHxF10R2M8UllGGq/sOsyDDshINi14dLPzlTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ENX08vIt; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ENX08vIt"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ce98cb8165so8260245ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 03:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784026189; x=1784630989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KkV4GjFgROz6Q/rW4BolM9fldQ0ZJ/AlEUz7p40vHb8=;
        b=ENX08vIts2Pxk0Ad52Bw6r6X/FXWAwMeaI9Jaw/urotfXqX9je0Bn81bl7z6JD+uTp
         x+Tou6WgmWYygPlG3Yi4b0XRR1sQVkkJoG7QDkbGN3zMQPBaEBOSOD/vZkQknber2CiS
         H5pX1MPgvdmiBOKIyzgM/w5zfHhLlt1IMBtka87tbiHpZq2MiIg73aUbuz4D6eI9QDAj
         zcT/AkMrooGOP7FkRPnGEDWtjiQEd5UhXu1IdXJjXRa2bul823OqrBPh+YQLBBRjO0FF
         dWiym/RlvMkZHbgRvQLYd7GBtSDWSxZXM/zr+jGZnbtjVQWgrYUJIY6BY1BhhYk7Hv/U
         g0IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784026189; x=1784630989;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KkV4GjFgROz6Q/rW4BolM9fldQ0ZJ/AlEUz7p40vHb8=;
        b=BhdlEIy+2luLZm9nQoyXAgigBMRyfr3nyNq8wrpKZYf5tex/CzaFxyi8xrIRZQRSib
         giuOJvJrXdVaOo3vPExcDCW/c5Il6N3I6g2gAkYKZqsfETXXxOTIxgXjLysNj2OSaKCZ
         eLI8t9exIRtF85hwo0hqSsZ2smjWTdDZJBoxX1yq9Ucje0fw5/6ld8dBX722kBBOw5rV
         jHD6Crk8NDhqTQEiTks8qBjDu/Sh11qe+RHWOSCyCxVSyfwJm939+ghTK/XG7c3/qcdq
         YzexnA6fYloxSH7qC3dA/hzY+OQVN0KKYlRnX+Dce9z+cYhIc1di2ASqTSY8JU3ikPDv
         t4mw==
X-Forwarded-Encrypted: i=1; AHgh+RqSg+MvUhd1G7sX3UcXP5lrtkQVu0UDmZHJYgvmuvWKye7d7lG6FBuj5b94BbgRGbPMueTwuMqp8c3/@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1kKHieXf1Exkow/OrW+sTGScX1KhGo+f6/hf0mCygJgLS6c8o
	MQamDuUUNy9SL3tM5NVWQ2Q2uE0Y1dr2mU7mrFd0RO29If+3uji5tSwL
X-Gm-Gg: AfdE7cnyyw9RFQRtaC/1h4leIK+BMfLPJ20U2Ml40bXaHaHpCU04w9CuFgJazQPUrBt
	jyedr7C6vYD7MKSLrE2vUU48Lmg5W7MVf5GdbmrPQTjaNWvwW1qMT0ETCjmUrp97DQoE3867FvU
	z3tTea/trA3v47mwSoEUQ2/BObzX1uRvo3v35TfQRN5V7vEpvwPs9hYcSgnoj9fFWf/XYqENyHW
	ZInm5v1Qvj+Gwc7VfaCNQ3xDSOQCX9fff0/4HGxbyWjWXKYiaUpbO2zcAy2qZghveBiR2Hq2qpI
	jOb9dMtAf4Jwwi/k7kbejZcuWBc20uZm7iKb7S3Cp+kYuakzlJEc5WEAu6Xop3g3WK5CrVjIOze
	BZ4AIu4U0lMjaeceEaZmC8RWsC2Uov3CjwgKnJto33/KVd0yUgz5oOt5y+VXyJDbMdg+IvCwsMO
	PBjBqJKOuZI+92CXqJWtogMVzBr93p/epGJ+aPTFW3u131b4f6Xr3ZO89IQhdBsRwCnbTnCyhh6
	ra67gWmEacCveH0
X-Received: by 2002:a17:903:298e:b0:2c9:97a7:3283 with SMTP id d9443c01a7336-2cea187c0d0mr121585965ad.23.1784026188650;
        Tue, 14 Jul 2026 03:49:48 -0700 (PDT)
Received: from nugod-NUC15CRHU5.tail9f095a.ts.net ([218.237.104.87])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cebec91c92sm38433615ad.56.2026.07.14.03.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 03:49:48 -0700 (PDT)
From: HyeongJun An <sammiee5311@gmail.com>
To: Mike Christie <michael.christie@oracle.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	HyeongJun An <sammiee5311@gmail.com>,
	Sashiko AI <sashiko-bot@kernel.org>
Subject: [PATCH] scsi: libiscsi: fix stale-data leak into the SCSI sense buffer
Date: Tue, 14 Jul 2026 19:49:34 +0900
Message-ID: <20260714104934.1404423-1-sammiee5311@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iscsi_scsi_cmd_rsp() copies the sense data of a SCSI Response from the
target-supplied data segment.  The segment carries a 2-byte sense length
followed by the sense bytes, so it must hold 2 + senselen bytes, but the
bounds check only requires datalen >= senselen:

	senselen = get_unaligned_be16(data);
	if (datalen < senselen)
		goto invalid_datalen;
	memcpy(sc->sense_buffer, data + 2,
	       min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));

A target that returns a SCSI Response whose datalen equals senselen (with
senselen <= SCSI_SENSE_BUFFERSIZE) makes the memcpy() from data + 2 read
up to two bytes past the received data.  Those bytes are stale conn->data
contents and end up in the command's sense buffer, which is returned to
userspace.

Account for the 2-byte sense length prefix in the check.

Fixes: 7996a778ff8c ("[SCSI] iscsi: add libiscsi")
Suggested-by: Sashiko AI <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
---
 drivers/scsi/libiscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 160f02f2f51d..5cbc51899de0 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -918,7 +918,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		}
 
 		senselen = get_unaligned_be16(data);
-		if (datalen < senselen)
+		if (datalen < senselen + 2)
 			goto invalid_datalen;
 
 		memcpy(sc->sense_buffer, data + 2,
-- 
2.43.0

