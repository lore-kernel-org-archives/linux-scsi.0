Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2F71FF1C4;
	Sat, 16 Aug 2025 20:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755377626; cv=none; b=LrujlwDK50i82ANELT9xtUIsT9Dx/tfE9mZWNy79BLEV+TusTCVlNgcBPIplsGhuiZSOmQheBg/th0qHRNKCgLAfaG8LYUs3mopXfM4YGoMHwaLvwUyfIFlr0ToKOUIZ9gKihvhCTSaIBvsEQBXMco/2hbvZQGbglmOVreZs7c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755377626; c=relaxed/simple;
	bh=Egk+BX2Z0HAo6W6BXodo9gGdmkwnPQsFb6x5iwnQpt0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JnXBPH9ewNYLJRMA0XHBmYRVtgqm93Ezl9Jf969FVO5cJUNWI0f8UHs1HKl1czG3sM7d0LxXLaIJ01VwexFFk2iKnkmUS7v1PZNv3mey+XI3nSvITMWaer7urYuHokw16a18WGLyouogNKk1MWQbUEZzCpspTpckbTF3+h2vjg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GJA6K4Qa; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GJA6K4Qa"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76e2ea94c7dso3517434b3a.2;
        Sat, 16 Aug 2025 13:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755377624; x=1755982424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M3tq/SNP+XOKQn6KczyDyeEB8VlhfBDHPhVlYBthHEo=;
        b=GJA6K4QaZvQ6wEAWEmPlbE5oPRynytuY7rfbGpq9JzeCcGTAnB9L7PYztBT7ZfbXLx
         M0tYgog7oZATPjDBlBrUj5iJelsN81jJOOTEdJmz2AbR0mf3/G8d8yzSc8PHC74udcn/
         tYiwh0b090EODZb0RZr4ehLl1+6ddJxEQYgF4/6MeuOyG5rVtiMtNQ8DU2Ts/xiow9Ar
         qVGQ63YQ0NiwgYKoPtDJgjK+p7wY/Co4XsGIU+0m/zb6W7oI/dlZ3HLip2KnbUGJOQU5
         Tv1AC8TzXKxU1/Gla2v7xrbX3dqHWKOBYf/89IDAhEeukEUf9a3Z/QvmfplqJOZXr5RJ
         rPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755377624; x=1755982424;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M3tq/SNP+XOKQn6KczyDyeEB8VlhfBDHPhVlYBthHEo=;
        b=ic9g78rYmnJ6iPH7IkZmPOUr0wCW9c0Hi96PlNxatAro4Gnpv0OhidC+jatlmuiAyo
         XLAcUn+jdGVYWHm/QFvRWz1PPlbuUo4fbmlQf9Vc4tU8ccL2c0CaJhp3tx/xXgbs6aT1
         AJpQ8rllVxzHopd/zTEybNzUllSoHQpqf/QirpqEyFJR52Av8AegN8d08+M2o1wUC+n4
         IucfqmaRDKE4L8Cz1jRjF/rnQlMBtEhGJSKn3VZG/4R/umwjcBmnvV/qAKX4ZHHvDnF5
         xIg5PKTW3cWRcWAhKIgeRJadKv6AXlx1q4FXEmNalj06JMBxy+RdgJaJ4tajkj3wv+uF
         F0DQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4Zn/AlPVE49LFyywkXk24xGye3frLFTFqvfYwNcKxzwUOPyXHQIvQnD3AZ9WRBmnmqihlIxYGOgR7uqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYBOPV8jzoqQdCs2hmXSrjHBbquQVr2IrXB1zu+TBeKgsBJvs6
	+uDr/gGU5oEzKh89Fe4PdI6SMRsWoV72MpVEGmasYkGu8NTEgXJcDWdf
X-Gm-Gg: ASbGncsS4HPs6P8z3ESJWkZyhqYa6LrxQe2H+VMTiijhJBOIMZAJkrqgSSutWcRUZcf
	dxFsEA4hY8qJZWNQAAYXgP2WpPDo4t0vur9wWZHvgeSYaReY4HXg4Tnn/+R+zhK9poTTdzB6dwJ
	vvG3LmBrgZoI9v4sADijeGQiLE1t6aDAlwp9Xv43E5/SonxYQlphmEO8Gs3zblcBeKbQTw1W9ps
	5PQnLyKIYnHqKmccdtccjy6BWtm+ToQXsiyTIM0mQw6qHCZqvr43Z6uNNpgAJdlGIMzX+gqCY4/
	DPfg5rKBSPjIyHdV9C1oRDehJpXmTXCicUL4pkPKwpLD7k+pKjyQhl7rau3uawMo5Ywas54rszB
	AzjtpEN6KBU58YK80x92o8H4DqdyUjCiOOKOQDm+RkIgr9g==
X-Google-Smtp-Source: AGHT+IHLwNTq3ZX7hanMAQH4yYNU+0wPlr2zkQW/bPvDuwTbohtHkalGdqR4wUhTxP3YTSVzo9iexQ==
X-Received: by 2002:a05:6a00:17a0:b0:76b:ca98:faae with SMTP id d2e1a72fcca58-76e446c5b4cmr11285275b3a.8.1755377624108;
        Sat, 16 Aug 2025 13:53:44 -0700 (PDT)
Received: from localhost.localdomain ([202.83.40.77])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e4528c812sm3833154b3a.45.2025.08.16.13.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Aug 2025 13:53:43 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abinash Singh <abinashsinghlalotra@gmail.com>
Subject: [PATCH v7 0/2] scsi: sd: Fix build warning in sd_revalidate_disk()
Date: Sun, 17 Aug 2025 02:23:27 +0530
Message-ID: <20250816205329.404116-1-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

This v7 series follows up on v6 of the 
"scsi: sd: Fix build warning in sd_revalidate_disk()" patches.

On Mon, 11 Aug 2025 09:39 Damien Le Moal wrote:
> The order of the patches must be reversed because the fix build warning patch
> must be CC-ed to stable with a Fixes tag. The cleanup making
> sd_revalidate_disk() a void function must come after the fix. That will avoid
> the weird placeholder comment and also will allow a more extensive cleanup to
> replace several "goto out" with a simple return.

Damien Le Moal pointed out that the order of the patches should be reversed:
The build warning fix must come first, since it requires a Fixes tag 
and should be CC-ed to stable.

The cleanup making sd_revalidate_disk() return void should follow afterwards,
which also allows for a cleaner refactor without placeholder comments and prepares 
for further simplifications.

Changes in v7:

Reversed patch order:

Fix build warning in sd_revalidate_disk() (with Fixes and Cc: stable)
Refactor sd_revalidate_disk() to return void

I have built and tested this series locally with both gcc and clang; 
no build errors or warnings remain.

Many thanks to Damien for the review and guidance.

Abinash Singh (2):
  scsi: sd: Fix build warning in sd_revalidate_disk()
  scsi: sd: make sd_revalidate_disk() return void

 drivers/scsi/sd.c | 58 +++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 25 deletions(-)

-- 
2.43.0

