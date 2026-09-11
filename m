Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50FC46C84A
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 09:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789117829; cv=none; b=ZtQRwWfY/72ms7WvJw96KvruRckanKE+t3rQK2rMXM2hPlw99ZKre1n0C3eDYpgNM/8bkhI7kiAVTVOJR+X56dJVaYXbgykCusoJXE6nHUmGSud28GMJXQL8blmQHHsYerDKjipUCxJSSc8ngfr/E2BqmXPYo03zCCqTjCLbTXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789117829; c=relaxed/simple;
	bh=X0DLI42KFIBXot7dH8Jyv6ebRzqtAjgDxWDbGBMbXOI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OnQKroYtWqH9fO+vfafsW//c6moz3ZDknxsRs/IAZZAG+RBxfWq1DKbAKFJpkY+8u3nj9P6B2Ov5+pi9ARotgYskxbySwql4xf+2QMX/ZIGPnhjQTMUy0aVpMB7+J6EnvrWsEp1M3KWKBLlHZzsvv1L39w9n3C8G9hqUnhq3eN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f2o+B7RA; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f2o+B7RA"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469d249c5so589190b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789117827; x=1789722627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QfW+h3dE0Vtr+am9z9kjJbJBHTRjYGqN4mXYUFELWLM=;
        b=f2o+B7RAS5XfjUYUMQPtwF3+b45Gb0xGgiVQKQvKxDZ24cIoZV6ikIXFxcJBbw+TF7
         vzY4lMMZm0vN8ylFPZuFV7Q8v8aPfE5+aaa8eHYzLZ8H1bekpibjRP5mcAZBZiHk7VLP
         dYCoiICO061HAONkDvOXpcruycJtkzjVEoiHo8OP6QuPr/GT7tTDBu4wgSEUBIEDXP5R
         m+ANYY3duMk3vvV2r2Fp50WqBZ4sKW354P6sNbkPVAa24dGBpELgo1a1Wfgiogty43ZO
         NXyaZd3UM0qbkIBlWk2hd9NdlDwQupbSVbmQU+RRMul1qQudWYjf8ir4BCMBYUKKqXrf
         LkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789117827; x=1789722627;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QfW+h3dE0Vtr+am9z9kjJbJBHTRjYGqN4mXYUFELWLM=;
        b=I9jpexzUXiuijy0Bg56+TbXHP7wykELdLLHw8P81z2yMRELatHDx/34hlaO0n1WqHy
         prChnYOhFmcwl+TAPDA9fcrIltcpy3h+eDVk24OCzYYl2Do+LfanfFCRwE/aZvjfwQ+A
         i0E7hk9cQhEHZMGutiybH96GbBLorbdmdomxow8OSFAmR9S8xrlmXF6Deal9wMFf47ax
         Adt0qmK3mI2G+fCDrfhlupFofMb+JwAaLJUS9kttjM4KP1y+cBptGIm4dFxr+FpXxxXI
         8rlf4sxhKjuxGbH3/A79+D9g088omFJnT3tBHroudX3za93fF8WkA874fpL/URI9Tv8Q
         RKDg==
X-Gm-Message-State: AFuF++lyqsX5pFu9u20et2r9qrk64mfWc+vpSTPWssMNFQ4LkpAUO1bh
	1aPg0DCvoPbQhPopsT/cCduuRv4tVSWLFha6HzctDXImsvVkR85JQiTv
X-Gm-Gg: AYBFou0prZvgZmtSFsx8/CUMx/vquJLgaqY9QTc39p1jKiYieBFyqoH6m0qpR5kksQR
	G8YoHZCMlI2xTVuuiJusiq2/eCEt8WzVhxZovbVJfHnvhQJ+ei0IBtCnKEiiF9T8xXrYlXV/G2a
	6xlzBT/BCInLKi9CDeC1OU7/FenZTGhaWghtguY7fhbhYT9+d/rmVhorNh5a/RDBE4zZwR+DoDC
	2Hz6N8gfsmcSOymEjO4V91dubpzKquL/i/urUfCqo2mKdBvmeKB90bnmXXTuW2TihhVYx/cQ7Zb
	brAjIh/KBslFpZEtXiXPdTet+ihRd8Prz+hYFJ8pkwB6pniFbv6aygOPPN+XhoYbBsLskHJaWWn
	782a/LMetyYPyG6QLOMYMRD6U2sDr4pEni2ChK4aMIB5pWrZIX1TUMyjR5xmfEQNY/p2QucMLTt
	mCgqK57yFWGtsHL1EtbulANez/ZedbcsMS3iNEq/dvBjpEAMllkzpIUm/zY6wAaBfH0OEjm5ZTj
	DZ+3nJQpqdJi7SEkRIN+b0vZ1xt5vAzsPYwXMbQ+ipiocZ8VGxt
X-Received: by 2002:a05:6a21:113:b0:3cc:8f53:26c0 with SMTP id adf61e73a8af0-3daed31ac42mr6638703637.17.1789117827100;
        Fri, 11 Sep 2026 02:10:27 -0700 (PDT)
Received: from FLYINGPENG-MC2.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c6572ecasm822522a12.22.2026.09.11.02.10.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 11 Sep 2026 02:10:26 -0700 (PDT)
From: Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To: jinpu.wang@cloud.ionos.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH 0/4] scsi: pm8001: fix probe error-path resource leaks
Date: Fri, 11 Sep 2026 17:10:07 +0800
Message-ID: <20260911091011.94676-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following the fix for the incorrect IRQ index used while unwinding a
partial MSI-X setup, further review found several related resource
lifetime issues in the pm8001 initialization and probe error paths.

An allocation failure after IRQ registration can leave handlers active
after their HBA data has been freed. Other probe failures bypass parts of
the normal teardown sequence and leak tasklets, SAS host allocations,
CCB resources, or the devices array. In addition, falling back from MSI-X
to INT-X leaves the allocated MSI-X vectors and multi-queue state behind.

This series makes the error-path ownership and teardown ordering
consistent:

  - release registered IRQs before destroying their HBA and tasklet data;
  - route failures after controller initialization through chip reset and
    the complete probe cleanup chain;
  - centralize CCB teardown so both partial allocation failures and normal
    HBA destruction release all CCB-related resources;
  - release MSI-X vectors and restore single-queue state before requesting
    the legacy INT-X interrupt.

Peng Hao (4):
  scsi: pm8001: free IRQs when HBA allocation fails
  scsi: pm8001: clean up resources on probe failure
  scsi: pm8001: free CCB resources on allocation failure
  scsi: pm8001: free MSI-X vectors before INT-X fallback

 drivers/scsi/pm8001/pm8001_init.c | 88 ++++++++++++++++++++++++---------------
 1 file changed, 55 insertions(+), 33 deletions(-)

-- 
2.43.7
