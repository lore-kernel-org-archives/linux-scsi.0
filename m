Received: from mail-qv1-f97.google.com (mail-qv1-f97.google.com [209.85.219.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8686B27602C
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 08:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755679637; cv=none; b=IXOR0iA0XP/RJy3FJpB8LBYjaDXbTOBMJuCQpmud6zUl0jHFdT0PH3D0nZvLxZFgK9SMDExPGN5NbXpW6N32qQUxzcyxETLSUH5mGuaiE9clVuo97alPZnfZqnU9oYiKI3OHp2q5uTISqB1oWcuyOQDA916MJx2ELBCP5BI6k8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755679637; c=relaxed/simple;
	bh=sfCgg/NAV6tLHgTLAcNIJ4LMvj4Gai48XZd3s3Twyqw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OxsNbOO1pJa0BaV6PPm3otaGiug9fl8SpF1pmtNKur2LIish/X2DV1gQCEfRam8YPDu9rkFyHrknAWyNvNBJmuhS9kxiopQtqDWxEXsWsN5CsAwlcgIqqltZtA+IwtjAU5PvFhcfBiB7os3EkccOeItvbwV2no6Ls7t+6CwdiXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=T66qeP6c; arc=none smtp.client-ip=209.85.219.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="T66qeP6c"
Received: by mail-qv1-f97.google.com with SMTP id 6a1803df08f44-70a9282141fso68084536d6.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 01:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755679634; x=1756284434;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mLuT0CId6O/1kw4RhoqIf/1C5616RIOfBXLgM6dqNIE=;
        b=G9OHgpdRbtvjHVD9uUssWQ0ti6J6uwfowyiNxGQe1WjsxvepBxxZXenaFIlVcXRIYX
         uFACvCjww3oUT2Fz/aSkPZ0ZkcmGWv/+8e1epqD/XRaC3WhPSHSVni/nGMfgaqCzLS8r
         CvvZrhfZ5fX8vEmTzJZwfPfoJxRu8XIAH3WolQTDWE57c/qBQqqrBhwAv6nhpgbnuwnw
         n2knB3QbgFfDsPS5ryHWmU2JK5nqvJrsr8LIMngWyWHvZp8QfQ9K73oWn/J78LWBNa1x
         VuMl88kDEhCaMjoeVdlyl5Ki1Hg1foJ6QT0Uqs041feJ3/meCjduN2z/Za8V5ugRzG/Q
         ZrIg==
X-Gm-Message-State: AOJu0YwgU1vri6i7qPmXTSFFluV5C0PgvlGhDdIvAN2C5zkAJL8aAM7I
	Eae34FnuTlgMAY3/UJBlp/lBDZZegyo/FyR3E0LMVr5AzXjVdWJ+oY0A1ZsGswevZkvJRtxSqSz
	QcDoVX0jMe9T1/lPsNOEjZ27qSJO33kbICy2HG0QrknGq7tTn/mIb6gaQe1snA8LlW46oTbDay/
	JVGSnJNfXEApq5MEXtaXfpcWa+QeFF1JeCSuhgu4kKS9wn0DAuuOWUzfHX9E9WWaKh2vtVsdgNt
	dvn/77eAjpcjlpHCdjyODzL
X-Gm-Gg: ASbGncuQJFjuar38cV2CXEQQkUPzJ7tJmfDnN3xvq+gJt4I5uNvzB4INQJim8miuTic
	eO6+VLplEg0pyWl47xVsNcotZ+GDrcLgLAhuI1Te0ofCA4Pky45Xp3nfRcmtFWGp6FisEWPxysA
	UinNH+uwA5U8YypoB1cLdeMG7mM8oo56Vn/Ev7oV+oezJlglawpISG8guvDdx7Q4Gn5cQcUVTfy
	62H6uTe2DrrkDRLQNp1aBGFsGk7V2k1+pUt9h1uGoLFRuObBpZ64hKboawQkwp/pr3cXuuNEx7i
	315UtwkZ5yqLGKMRHsZkfEcjXLMxxkoWD8ShD+rmGGl8LNY+icwFYGFGTP494rQCbZ4NzORntJi
	R+6HYl3jXi4dKLtpwXcogIev404dQN0Y=
X-Google-Smtp-Source: AGHT+IG69ap6cMxknNEq3hr6Mwr99bTa4wDu59M37fDP3/XOJyafYc3SzLCivXnwEm8Fe9fTGeL2ar4foYW6
X-Received: by 2002:a05:6214:2b0f:b0:707:7694:4604 with SMTP id 6a1803df08f44-70d76fc3801mr23180406d6.30.1755679634215;
        Wed, 20 Aug 2025 01:47:14 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com ([144.49.247.127])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-70ba924f4c3sm8326246d6.35.2025.08.20.01.47.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Aug 2025 01:47:14 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-76e2e8afd68so5516339b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 01:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1755679632; x=1756284432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mLuT0CId6O/1kw4RhoqIf/1C5616RIOfBXLgM6dqNIE=;
        b=T66qeP6cbS6B+69lrC1Ly9KEUheB8FRowLyiBO7EZ0hLM/nS/dZKcJOGF8KkK839yj
         +IFYst/+xavrYbAshGh58JsWksVpmpGAZ05hAuLBse8lWdl6Oe5LxdKwjnO1lMbdkbVm
         PxJIIry/Ie7znbsjT/lPdqzto600PLl5+xmJQ=
X-Received: by 2002:a05:6a20:a110:b0:243:78a:8294 with SMTP id adf61e73a8af0-2431ba5cb08mr3518043637.59.1755679632632;
        Wed, 20 Aug 2025 01:47:12 -0700 (PDT)
X-Received: by 2002:a05:6a20:a110:b0:243:78a:8294 with SMTP id adf61e73a8af0-2431ba5cb08mr3518003637.59.1755679632097;
        Wed, 20 Aug 2025 01:47:12 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324e2643bafsm1604034a91.23.2025.08.20.01.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 01:47:11 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	prayas.patel@broadcom.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 0/6] mpi3mr: bug fixes and minor updates
Date: Wed, 20 Aug 2025 14:11:32 +0530
Message-Id: <20250820084138.228471-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This series contains mpi3mr driver fixes and minor updates.

Chandrakanth Patil (6):
  mpi3mr: Fix device loss during enclosure reboot due to zero link speed
  mpi3mr: Fix controller init failure on fault during queue creation
  mpi3mr: Fix I/O failures during controller reset
  mpi3mr: Update MPI headers to revision 37
  mpi3mr: Fix premature TM timeouts on virtual drives
  mpi3mr: Update driver version to 8.15.0.5.50

 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      | 38 ++++++++++++++++++++++-
 drivers/scsi/mpi3mr/mpi/mpi30_pci.h       |  2 ++
 drivers/scsi/mpi3mr/mpi/mpi30_sas.h       |  1 +
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |  2 +-
 drivers/scsi/mpi3mr/mpi3mr.h              |  8 +++--
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 13 ++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c           | 28 +++++++++++------
 drivers/scsi/mpi3mr/mpi3mr_transport.c    | 11 +++++--
 8 files changed, 88 insertions(+), 15 deletions(-)

--
2.43.5

