Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B77F1CF8B
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 16:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719504016; cv=none; b=PQ1DNJIScf7qiBmt4iHoiZxbceE9+VzPBY5vUfxvgl5q0TjdS8goGdLPe9SJQK/XeuVUfUMB7oJqvEoKkCfoy8588VD6wOHZIWoD92JvR8NeBjVDxOPxU1HiTLr60nm519ubwt2JuqfcyTMxy+rByYbzGrZDqs5xZeeiG7Xs/FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719504016; c=relaxed/simple;
	bh=dT8ulryxO9jNyqI/6P5VM7e1jUorP0EUT6+vrOZ/jk4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rZi6aY6W8JOfkK2x9iY/6iG63cZsaOVpL9FjmMbQc3vZBpHBCAd37lVLs+ktvfep1hTcFiAcDtl+u7dVBLmKuvvwgrcCPT5G8GJZaGJNcwdPJbJxhiJ0kc/K/a9gCqNpN9+bccUXZeflWbDRbXMdIr+UJPtaakqz7G+gEy8HkCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lOzglmYV; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lOzglmYV"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6499b840395so8542407b3.1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 09:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719504014; x=1720108814; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gMctsYknpmhgclYbrXLe3svKJyyKorvOgU6J20+Tvko=;
        b=lOzglmYV7So4PWpoMm7StAMCA9/7/sIzAo19qR2dlLA1WIaFu5m8CFJkBnpgrIJetQ
         2We1Lwhq1T6nDf6rjCeayGjwkblNduv5YKAOfEHIDaK11miiCjGTJ1vMsgyG1I/dl+GN
         b0dt1M+t4V32oAp5crMx78VwcBCegcGOEHAtC/uJTP6fwdWwAdeFNjzwxRd0UOfbhjKE
         yyb8emH5hhVYiy86pSFcayW0S+j4PWHSuBUiwpiD2Ug/oY2tKrBmpq29iHWA4AkR4qpB
         lQFWLyaosGCWt4cR8DaXKmy4ISpQMTpi7/yrKhVE5DfEeIJc1W5LoRw7g8aPfas5wO9m
         TZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719504014; x=1720108814;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gMctsYknpmhgclYbrXLe3svKJyyKorvOgU6J20+Tvko=;
        b=JxLwNPKGTUG5lIuclNcG+phvYsforHCV9SCQO6XmMHju9aKa/qy7AOqt3BMwFt/cmS
         1DjOPb+sbrC6M0cg1KHMaFU0KcXvOMPImMfpkNjFEy+hbGPXSZtPu4qWcb4jO1EzJnCC
         cFwjFOx9wRvbqRY1amTseYGuiS2xar9iLU9ZqdONDvJw82+VK5CaBPzGPjQ94gj2Vwv/
         0lQvvnKB9pPnCd+dNMXhUIxxic1yVLGqzR2lJ6NyxazQyGjS2zw9HixSLKbVVOCaOaAo
         14rwbdTWAV7FZ233DfnOvpHIcaY1DxTxEfwaZjxFUXVpZuNte+nhgTyxtUQR3Zsgf/TH
         HqRA==
X-Gm-Message-State: AOJu0Yxn6UW4/mK4Q6NlSwC5o4jveTZa9x47nSVhlo87jMVaFQQPSReX
	L2ZikOvO3alNjpnkuIC/gZ2rYKt8cssIIEkXYTRCTz6Vj3Uq8l2l0KhN+UjwooKQqeszFo6H+Qk
	NsMnDWGvcmQ==
X-Google-Smtp-Source: AGHT+IHd1pMBb9XC7H0CiweHnQb+sjFwr9VAirsBjXKpq57BPcKIcNkU7nkJt7JWP8XVC4vWSGqJpDRaWgHOoQ==
X-Received: from tadamsjr.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:177c])
 (user=tadamsjr job=sendgmr) by 2002:a25:ae9c:0:b0:e02:bd2f:97f5 with SMTP id
 3f1490d57ef6-e03451f86aamr13928276.6.1719504014050; Thu, 27 Jun 2024 09:00:14
 -0700 (PDT)
Date: Thu, 27 Jun 2024 15:59:22 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240627155924.2361370-1-tadamsjr@google.com>
Subject: [PATCH v2 0/2] small pm80xx driver fixes
From: TJ Adams <tadamsjr@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>, TJ Adams <tadamsjr@google.com>
Content-Type: text/plain; charset="UTF-8"

These are 2 small patches to prevent a kernel crash and change some
logs' levels. V1 consisted of 3 patches. One patch is being dropped so
it can be reworked and sent separately.

Igor Pylypiv (1):
  scsi: pm80xx: Set phy->enable_completion only when we wait for it

Terrence Adams (1):
  scsi: pm8001: Update log level when reading config table

 drivers/scsi/pm8001/pm8001_sas.c | 4 +++-
 drivers/scsi/pm8001/pm80xx_hwi.c | 6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

-- 
2.45.2.741.gdbec12cfda-goog

