Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02734196DA5
	for <linux-scsi@vger.kernel.org>; Fri,  7 Jun 2024 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717780012; cv=none; b=MHiaDVdCeFS2OoxPQgkNch1wwqCyLvjBvtSTQ0JFjYgxp0BgHT13Z1gEBpP9YeJzOV1wA7K0W/ZNlVqmcN5x3UTXqzwG0DGmZO9bXod3QaxESML+sFwUpm3MjRJkkC8+vXmwuHFAE6F5DhACzs3IphGuzQQTS5N0N1PhyTx/ObA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717780012; c=relaxed/simple;
	bh=JkHsbvNdcURNnEDObWgYdy2/W04T/51djrtr9yhqi5g=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LP1hoBoSC23A1W/8QKRN+IKJcTi6I2vYeShojON+QAD9uYE318ADY8McQ2wOHswop0Q5aFh6Uq4+EqFu0jAO4tk9gC82tojaGulTHnIzKYrGrBtPrjBWqluiIinI7ZmEiKYPHFcIsPBrgf/yL/6gEJrQJoxPxTGYaDCg4y7qKHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qs32rciF; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qs32rciF"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dfab38b7f6bso3535709276.0
        for <linux-scsi@vger.kernel.org>; Fri, 07 Jun 2024 10:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717780010; x=1718384810; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=c18LAfzX1Wi8QLo4CCnxK5ac1BzsLnPw5U/ZVw7/7Ys=;
        b=qs32rciF2jJtAwdoCiMXE2WdnZybAKN3Xf+6lH5wNSlwUcmdDHD51TaMM71cVBuxpF
         OcDQwVCeYnUfFqSbEWddEDvdTx0nNC6DyOapYTztdjNDkj4/pcMB7g9E8Xivox08eOvC
         P+ZA/A4AloxkrZE9CNvMw0rswOz9dRO+nSsjwhD/jYqssjoBtDcAHbbok98sj7pqezpH
         2j+RBT4EQe2OMTjDeudMayiHH02ROoxMZv0Wyud2ksh0XVZQaSWt8X6EHxQHScvQPQMB
         fVpHX+MSUrKOJCnMYuEamb/hlKeF+QXTvvevfylVk7fJPSr3WV2/p6dECSRNX3IzD4Y0
         WXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717780010; x=1718384810;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c18LAfzX1Wi8QLo4CCnxK5ac1BzsLnPw5U/ZVw7/7Ys=;
        b=cNToZxf/XzOq87crYTqQkotKJEYK2KJCFb3A/0gNjMdlFpV5x4NOUOc//poy2POUgD
         tQhHSN1qu4JjcptCzXSCLjprtPbzj9YrzZJfs+wRBV4TX+2j8WU3f3Tx3fCLSoYFMFjF
         YFK51pEicZxsrZmh0DZpefEmZ7bC6XyGR2+EumNn1OZPsql3Nn+w3ttt9/HzBN4vWwvO
         ewrThbNrrKSi14rA1Mtoo0zVTSdHLpkNwilseesS+J88/0ozROjcYEjs+fEdWf5n5quA
         ZjszQUdPAqZ8iqkIJVxFGAj+NW6/gwRHMP3cr+nvc3paI6okcQik5l0DUXVManE09tHO
         tapg==
X-Gm-Message-State: AOJu0Yw/vbSLHuQgwMuHtE+CTEBm9Bw4xNNNZHKPRRbnRFILThEz270K
	lPNc/8kVK1x4fagFooPXO4RQAgoYynF6PhnvNrqSYmf+m6/hxpjoYsfXD13V+AoZv1Ivd3APYOl
	EFEHckCI4kg==
X-Google-Smtp-Source: AGHT+IEA3WOWT4QIlGO6W4Tjaub9S3Qx64539NCK4ihy61lBj1rdJFfBWn5Ij+wiQmwTIai4WGag+0Cv+xbIQQ==
X-Received: from tadamsjr.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:177c])
 (user=tadamsjr job=sendgmr) by 2002:a05:6902:188f:b0:df7:8c1b:430a with SMTP
 id 3f1490d57ef6-dfaf64ea35emr890887276.3.1717780009793; Fri, 07 Jun 2024
 10:06:49 -0700 (PDT)
Date: Fri,  7 Jun 2024 17:06:36 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240607170639.3973949-1-tadamsjr@google.com>
Subject: [PATCH 0/3] small pm80xx driver fixes
From: TJ Adams <tadamsjr@google.com>
To: jinpu.wang@cloud.ionos.com
Cc: linux-scsi@vger.kernel.org, ipylypiv@google.com, 
	TJ Adams <tadamsjr@google.com>
Content-Type: text/plain; charset="UTF-8"

These are 3 small patches to prevent a kernel crash, prevent ncq from
being turned off accidentally, and change some logs' levels.

Igor Pylypiv (2):
  scsi: pm80xx: Set phy->enable_completion only when we wait for it
  scsi: pm80xx: Do not issue hard reset before NCQ EH

Terrence Adams (1):
  scsi: pm8001: Update log level when reading config table

 drivers/scsi/pm8001/pm8001_hwi.c | 11 +++++++++++
 drivers/scsi/pm8001/pm8001_sas.c |  4 +++-
 drivers/scsi/pm8001/pm80xx_hwi.c |  6 +++---
 3 files changed, 17 insertions(+), 4 deletions(-)

-- 
2.45.2.505.gda0bf45e8d-goog

