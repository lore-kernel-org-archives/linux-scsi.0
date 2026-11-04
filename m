Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759623;
	b=DO5JESe8xWEBol52XY+itMz1z9X4xffwF2gFDwVomA2KUxyE2hl3Yr25OPSrPWHQgfKv
	 Yt4PIzmgVml0rUfdLYrTl0Le1HiLg3uCptFm/CT7hWJ7yXYSOoBscfNwTYtyn/u7zbAa7
	 FJoK1b77vyXQTI7P3qN/VkAkZmVbi546CRdQPO9AyPT/4bM5xfFjyvaC4ILwNdgIrEOZ9
	 Ea0u5r+7p4l+ZDvqOwh9+8IAHLW3wMpzzdwzv8opvT75Qs8XQro82JpPJPrsT7LAf2rAP
	 U3Xk/dKlwAY/OBAI+YeiD6z4DFClZJ2b+iwtykFgnivYsSRSOUAiWDzsukkbI4BU7gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759623;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=3yAKRkPmS0fvUGWgcRv33GX6ZfAkV+3eGLG2Qk2/DwU=;
	b=tpuWYCELzeu4yT5MfqfuozmjnwQ4FXfrxq8rsMS8KOutImSY5ArPnKg8O2P3a2BWx2iD
	 pU+Oyfuq2X7IiE9aN66knHCvMVvoDhVnKGlfAFNh1t5GccVM8DX6Z6l2WlPk2pdrFwqHT
	 kR56/8iRZ3C+nRVs/i4NLq8jjZ7urwW53SmulZ/4wcN1O00XqPj+SDahp4nQKrq605nCm
	 hJyFRHS3TvdDP33SQYqZMObBGQ+XwPsatOLoQOxPrrXAg5A89bvkvrExgKrnkzpAEDjPs
	 bhaO6WxNtNFFvW8XY4HVriODN5u1Gwes7XgmPsD5XSbfv0Es5ZslCt5QedV5L4IWZww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=fYiWCCRF;
	arc=none smtp.remote-ip=45.254.49.198
Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5BD606A328;
	Wed,  4 Nov 2026 02:33:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E5BD606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=fYiWCCRF
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5367d0739;
	Wed, 4 Nov 2026 10:33:37 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] scsi: aic7xxx: Fix potential critical section table leaks
Date: Wed,  4 Nov 2026 10:33:34 +0800
Message-ID: <20261104-db9e3c75b3-scsi-aic7xxx-0@mail.sdu.edu.cn>
X-Mailer: git-send-email 2.43.0
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
X-HM-Tid: 0aa1a467a2de03a1kunm4ff2f44e1636c1
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGUIfVkweHkpLTktMTB5CQlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVKS0hKTE
	1DVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=fYiWCCRFSj4Wm1k5IbCt1rEi6/Zk8gtUXR2DEm9PBch9wlvw6BvtabSqNKF3A22mF1ZuSDnDrDfXkRsRsZI4MhJZ+iSsy7l+Hz3CWsHtH2SZovRMa+/12NyCJ8UnHrD4RuXqqT3ssLyXI5wg4XYgSFu7sojmPF2iZVqWiXEYRus=; s=default; c=relaxed/relaxed; d=mail.sdu.edu.cn; v=1;
	bh=3yAKRkPmS0fvUGWgcRv33GX6ZfAkV+3eGLG2Qk2/DwU=;
	h=date:mime-version:subject:message-id:from;

Free each adapter's copied critical-section table during teardown. AHC
and AHD use the same ownership pattern and both omit the matching
release.

Both changed objects were build-tested with x86_64 GCC W=1, using
defconfig with the driver dependencies enabled. No hardware or kernel
runtime test was performed.

OpenAI Codex assisted with source review, patch implementation and
commit-message drafting. The submitter has reviewed the changes.

Guangshuo Li (2):
  scsi: aic7xxx: Fix potential critical section table leak
  scsi: aic79xx: Fix potential critical section table leak

 drivers/scsi/aic7xxx/aic79xx_core.c | 1 +
 drivers/scsi/aic7xxx/aic7xxx_core.c | 1 +
 2 files changed, 2 insertions(+)


base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
