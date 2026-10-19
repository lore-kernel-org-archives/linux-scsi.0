Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913D3483825
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 06:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392638; cv=none; b=NuD0sNlhGWrfUyUtJwz69yYSi3XjB+vmF/F+x1lTO9rpwYON7p9aWZw3QnbvN7brNf6Cx4v0UAcn2jj3HdqVQayrglTDLl/vi+GWzG2qVrHG0pA3fJkZt3b0txIOkPPfVX1P9/CalR5TWFCwHPutP5riTAW2z13HNAXNB+x4HLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392638; c=relaxed/simple;
	bh=5Rlziv/VURH/P/cEyWDRx48qF+WbCr4jIknaDmyCnqs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lm1a9noFP4W6qmLrXgfcvmT5DHKWrl18XB3d9AjiqEXQzxpj9Gtw0o4fm3dYI1H2e0CfSgX2P2IO6Zl2KQVSyMgCxnyKIDPVBha0fVbAdob7ZNJlOXuJvT37inrtLbP+hqNDFh+uRy+at4PFuQzoabDE4nZKV6O+WdO8w96mnY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=gra0rGup; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="gra0rGup"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-ccca948203aso555110a12.3
        for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 23:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792392634; x=1792997434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QK6qh5+NKSNYETgjkTPsz31lzea7ZQK2GxBH2To2CPA=;
        b=gra0rGupPLGWFGL16VbpOM1EcGj0hIgtsTFjqaVx4qlBs/D6QZ+RAYKz8Ksqut0sCs
         0XEF7Cvrnv/EQiE9nYWhiUlN4blyi8a966WIv/E/AY8Gs7pN4oCOCaTVwznhU/af/3E3
         crDAdvDyOWGlucQumxll2k2dbJ7ut5dYIcUTf4tFqVzSsgAO0a5stIYOWAuyA3il/nlT
         a8TKB3zeL3S4WkOY3As1kMwkmxGFzScvtnJ+5+GOdDixF9W9z5m8XTBHH32KLiHU2S+F
         Udg49fAaCE/COWXfetHcKOjuWSDmQEoirdsgr/kZ/7oiMoGAGeMJ7vr7zgDQcbbW5Aq9
         2wmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792392634; x=1792997434;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QK6qh5+NKSNYETgjkTPsz31lzea7ZQK2GxBH2To2CPA=;
        b=VpBwyrLt01fv4dqHJjQIHC3pDTMG6LdP/OP2X8jQ7Qn4mX5WbVOTo5sRLFL9FOpYw3
         eO4OCqXpH7BaE7g2js4Z5Mvrvl1OiknLJ0TNFt8846EkWSHFJ1K9MF7oZQwSpu886NXK
         BGNEZC5kOBS89o1T8Gnrx2eNSzZWUAM48cV2+13rnT7rgURQDx7+sUF7bUoZvcFxuBKH
         gf14Wdoi/+PuX3dYy+skbLin4kTjDKYcqDFr4HZbTWswzrpBFnZVMi/qX37y2+u8teia
         dPsNbJ9fjhFORTghBIKD/fPxLEqKQJYcw/d8MCIvf+7Y+5pLh5domeFvLEfGfGWqr2m7
         ykoA==
X-Forwarded-Encrypted: i=1; AKwUvBwTpPRFZIR8B8zc8F2g3hjrMHeGJTe0QuwGRmr7pXCmjjLMIkrkHMgWmyttnK5EtTJ7tgkUgd/+Qwp/@vger.kernel.org
X-Gm-Message-State: AFq9FYJ3QesqXW61V0ta2xkJjHFpoftad/hd1xKGl/4cL180BnkSI5/3
	c8aRCT24mJ1e6OTf+hvTV6PIHU5gr8ceLCS1JbloQlkAWcuLYHC8POqkydzOMhOpShQ=
X-Gm-Gg: AYBFou3GJFj36wjv2yMkQfVhzmlJysa1e4uPvL1Yf3/myYf2e2a97+YVz57Mygxa3M/
	v0JxKhlL1dOwnoGYSokE333Zrja5QBwVUhatcOguOBav6YrU1FhtAHya/N7YpaAxB1sCRPIATEZ
	j6xiM8tIEpcTXfhSWJletIfMl3rNhv7OchmR+xyCndD2Ig7Makbd19+8kchmbhvexFKbu0RzDSb
	KMYBN1p6B0S36csxNs2pDeKzO8fTmLdS82QKFRRCmFX8SOFViY+D/5vsHMCSdrSKH0FRiTDZVOK
	pmUTp/vaiqt/+x7+2p0esHc4sd9VclHONMQ1WOACjYt96qiNt9FAxVd+7UEalzxsnUNOIGs3ZIq
	rrWutVoLlurIvE9lE696ZkH85YVOq8BJcz0XkVxnVXhBbujI3YP0mr+tLCslMAvYmzNluKIBlQl
	6rfhnYJb+Eyk03VcBU6ZMxvcjWGjivEcZaOyIBwKv0rGmd7dbYfqgV/VW1spMjHvVVrnjsKLQM0
	eYpnA==
X-Received: by 2002:a17:90b:2c90:b0:3ac:a521:953 with SMTP id 98e67ed59e1d1-3acef0ff0cdmr5700956a91.46.1792392633670;
        Sun, 18 Oct 2026 23:50:33 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd3f3ce5asm5870887a91.3.2026.10.18.23.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 23:50:33 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: njavali@marvell.com,
	mrangankar@marvell.com,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 0/2] scsi: qedi: bound firmware-reported lengths before they become copy lengths
Date: Mon, 19 Oct 2026 15:50:17 +0900
Message-ID: <20261019065019.537183-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two places in qedi take a length out of a completion queue entry and use it
as a memcpy() length without ever comparing it against the buffer it is
read from or the one it is written to.  Both of the masks involved are
0xFFFFFF.

The first is the unsolicited PDU path, where the destination is a 256-byte
array on the stack of the nop-in and async handlers.  The second is the
sense data copy on the SCSI response path, where the source is a 96-byte
coherent DMA allocation.  Both lengths are ones a target can reach: the
unsolicited one by sending a nop-in or an async message whose payload is
larger than a single BDQ buffer, the sense one with any check condition.

I have no FastLinQ hardware, so patch 1 is backed by a KUnit harness that
drives the real copy helper with the two DMA buffers swapped for kmalloc()
of the same size so that KASAN can see them, and patch 2 rests on the sizes
in the source.  Neither patch changes what is delivered for a PDU whose
data segment fits in the buffer it was given.

Yehyeong Lee (2):
  scsi: qedi: bound the data segment length of an unsolicited PDU
  scsi: qedi: bound the sense data length reported by the firmware

 drivers/scsi/qedi/qedi_fw.c | 75 ++++++++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 24 deletions(-)
