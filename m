Received: from mail-lj1-f201.google.com (mail-lj1-f201.google.com [209.85.208.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E70538F254
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 12:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778847474; cv=none; b=NkZGm4KaRBMwPiK7ZJujM15VimEECtKH3h9nr6QTlK4aw3uPKOQNmHZlez2dhYJPmgT75WAbhd1GmzHudAesAdrw/HQWOCsvZFJ/6LQ1bII6cs2n2n4YcSFJY6uKmwAZ9xLdlifor2z9PF/EORSTLJwqtxVDkw2L94ehmLX3Z/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778847474; c=relaxed/simple;
	bh=N9ikYvwVeWzWt/2mT3//uTQ7f/hAfrfWxWay4tNhY9s=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=cLBYVCadIcxnWJXTz40wNIszE68k50lvjzJf1GegkSyPHSvxClEbSC6O7QN3K2W2r3MTNBQzS0Wa9j5OI1QIf3GiKoN1deRhD9b4s5VFzrz8zLTlYHaB3KvAbB5XYnb+meXgrHuTpbeRb9mDRkdRxJvKi5znLu0GNn8kKaZSizw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rnj.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sHeGxc4O; arc=none smtp.client-ip=209.85.208.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rnj.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sHeGxc4O"
Received: by mail-lj1-f201.google.com with SMTP id 38308e7fff4ca-3940824a47dso9738241fa.1
        for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 05:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778847472; x=1779452272; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dm/zJLbbgDSNoqLaVbuam14QZYRwWJXjLg7s4Fbg50w=;
        b=sHeGxc4ONOyQ65jC/GYZ+AVDGaKgDIJs7e5ccxnNv8J/9jB39uWZdt1YV9CskvKVt2
         plJJcHga5aCqHtbwc+M8Kd8UW6zXS54T/9Azkwy3peuc7tNdzAgzcL6ODkqGSPacnPd4
         nRCrghG1pgvzKFAcaULLZAGA5tmvNWM29UFSgs5HLOTekg9xdZL/O8FKjIBIvO2Aq/pF
         X8uceFNKkN//4510QZyt2vWhHUhGkU8l4wT06pRz3PI4gdLoILzXFiu4Q7MxZ5MlUJJ3
         10xlRbUWZO68KJoUJeK2ljTanExsNUSENcu2JkNV9I6M6lu/L8I+aK9C3J7KGHYo7nwz
         qpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778847472; x=1779452272;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dm/zJLbbgDSNoqLaVbuam14QZYRwWJXjLg7s4Fbg50w=;
        b=f4kODQXSWnPjrsKfUO4mvO96hC4GNC9KmQ7wWmV3uWjx+PUpNZaYXClrT2AyvbR2Y0
         UUd59MD81TCz6EiodglAxFrjWReB2zq4PpzdEctwVk3RRRwUt0xufZmx/2YM+B9ZS+Hs
         /ljhmPYbUKx6CGDS4ozltzH/fbvxWOBpyNVcRdSZdW5C2J0CRMTd3YWVsJikdaLgdctP
         YuB7SbGFUCjjXjvf1cQxjPoaA51r1TlFpbnHx6bzqnNvhnJA/iruvXuRFjFUmquFoUeu
         UKgJVoZ+wBJPAkfya+7h3Q2vI1tdnEVmXOx5lPEnjH21CjIkuO3ZFemLCZXH8K34mskb
         fjFg==
X-Forwarded-Encrypted: i=1; AFNElJ9c5yrklumlgq8Qf1PlVuGsYpWsYnG9v4NxkRcYQVDVkxQOTSW5loSHEm6QhJgZNfIGPeoG3ZMgmIeN@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs1PdJwVR9ISY7oPj4Cg6N9S8OHC1AEHc0Xs7u+nY9D0TmmT1e
	n8Wq16An0Y9+ee63yJHgKU6Jk0txA1VJPBMkpkJSkK0X2qb+dVht7InCont9VN9l1cZEew==
X-Received: from ljbq23-n1.prod.google.com ([2002:a2e:a017:0:10b0:393:9f55:d15])
 (user=rnj job=prod-delivery.src-stubby-dispatcher) by 2002:a2e:3507:0:b0:38e:ae31:f0a5
 with SMTP id 38308e7fff4ca-39561c3db53mr8723811fa.9.1778847471538; Fri, 15
 May 2026 05:17:51 -0700 (PDT)
Date: Fri, 15 May 2026 12:15:38 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAGoOB2oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDU0NT3bT8opLMtMr4glwLA90kUyPzREODZAvLFAMloJaCotS0zAqwcdG xtbUADVjNBV4AAAA=
X-Change-Id: 20260515-fortify_pm80-b527a10c89d0
X-Developer-Key: i=rnj@google.com; a=ed25519; pk=QwUkB1OONd7dk9zV4pLRQRehoWHHsLcRZD2QcswqHTc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778847470; l=1021;
 i=rnj@google.com; s=20260515; h=from:subject:message-id; bh=N9ikYvwVeWzWt/2mT3//uTQ7f/hAfrfWxWay4tNhY9s=;
 b=33hkqcbK6GMpl9qSkXZ0k6mkZQRpQZxwGylyQ4UaSKzkpTQHMIyBg4RdOBg8kZErs3RNunxjo aIFWbJ8AAa9AvhCKbxy01yPw8eQBG5giNeInJR5845M3O0C3i60kPx1
X-Mailer: b4 0.14.3
Message-ID: <20260515-fortify_pm80-v1-0-2863187f6d4b@google.com>
Subject: [PATCH 0/2] scsi: pm8001: Fix struct layout and FORTIFY_SOURCE crash
From: Ronja Meyer <rnj@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Tom Peng <tom_peng@usish.com>, 
	Kevin Ao <aoqingyun@usish.com>, Lindar Liu <lindar_liu@usish.com>, 
	James Bottomley <James.Bottomley@suse.de>
Cc: jack wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ronja Meyer <rnj@google.com>, stable@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="utf-8"

This patch series:
- Fixes a crash when the driver is built with FORTIFY_SOURCE=y.
- Aligns the struct layout of hw_event_resp to what the HBA believes
  it looks like.
- Simplifies code previously required to work around the incorrect
  struct definition.

Testing:
- Verified I can still read from disks using the pm80xx driver.
- I do not have pm8001 hardware available to verify against.

Signed-off-by: Ronja Meyer <rnj@google.com>
---
Ronja Meyer (2):
      scsi: pm8001: Redefine sas_identify_frame structure
      scsi: pm8001: Match hw_event_resp to HBA data layout

 drivers/scsi/pm8001/pm8001_hwi.c |   6 +--
 drivers/scsi/pm8001/pm8001_hwi.h | 103 +++++++++++++++++++++++++++++++++++++--
 drivers/scsi/pm8001/pm80xx_hwi.c |   6 +--
 drivers/scsi/pm8001/pm80xx_hwi.h |   4 +-
 4 files changed, 108 insertions(+), 11 deletions(-)
---
base-commit: 98f69975d4c0434ca2e6e8cfa1d8d51647a20593
change-id: 20260515-fortify_pm80-b527a10c89d0

Best regards,
-- 
Ronja Meyer <rnj@google.com>

