Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0811E2C11F3
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 17:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790618091; cv=none; b=YsWKhiQhTFipl3JqdZ8VbCov69cOYqEEV9M7zkjMCgZ3QfF7E6ZC9kM4zKIGa++lbamJwyQHDHmjj5MzsItPSwJXF3IfUtP8U1NYpPuS5uyaT+ibEwDgT+Lj1oLhq2lmbT3pwP8rm7DKHil5V0//KX6ciDGafek4lBeRjgvCXxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790618091; c=relaxed/simple;
	bh=Pjp4eWko7KU2pqR3lqu2bVSslCf2WfGO8Rg50rV7Ias=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jUK6ckhan6nKzhswPZRHFXwQ40oO2bcqCYj/0lNLDQKUNIAhwlLvwMA1CzKP7MNUany/3vW733c2IeRjDwVocmrQ59CVOPX4nHswW4cMcn+h8XVAo1zeItenir+rMO6UVZdBwxhRxwcqF9Levme2I1L2OInakdVfXHPMRSaevHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iPrkZuQk; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iPrkZuQk"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-3411e0ace58so4550827eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 10:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790618089; x=1791222889; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZBI6wXmBZErdkSRp0UxzWQmy1iGRWkvkA8ydNdylaoI=;
        b=iPrkZuQkFLWiEMMVeYdz8eAuqoI0h9ZbBCOzzgysmdKXWT9BEDvhYEGAgIvE/YafzP
         k9h5ZotyLLbOgcwhyFC+jj3Au78J10E3DeFKea5xZ9c1Ks7l50XtJd5rRKZMnmoCrjxh
         RDyPI5Jlb4Uk/54Vot26OWDJ2sdJhBmw+hwSfptjcoAlxYhpIj2eM8r2zpLGg+Sz5yzg
         ndYiAe6Z3bB5bcpSA7n/4M0Xtc1BcLtbiCdMuGcpLuOAHqQ/4SI6Ct+BuDVJn/UOzswJ
         i7gRUhRm4yuHqaBoRPGSddRSmrw3LWXpQaJu/5R03V8IumP9d1gyUACp5nmfo64DqtyP
         pC3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790618089; x=1791222889;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZBI6wXmBZErdkSRp0UxzWQmy1iGRWkvkA8ydNdylaoI=;
        b=jnu+8EFGUTnXhVi3mLieDdbK1TWAFDP30i8DI3tc9oxy4Sd/b2ei+JR/Z0jM2bzEoZ
         hXXQJcacfDB9zps7sBlIA6im7B8ODhVsnaCa0lmhNa94u8mnJMhLeUjx3F4XtiLZFAU1
         BaFqmYWVIZZCFHOXl7ig8z8taD32FAEVYb5qjOUK0urlLU2gXEIX1i7MVjj2ZwkIn5O5
         +R0g0Z1+IFwmJKi9m1d2Z7bexKcO1txbQNTKJskUe5RX+aHF99lJwlxR1h5hxKHUjTnI
         uX+y7CEQ+y1E/9QRi0QKBkCpuLnz/AUVsb2rx2Y5L/OnCFnKePbRUXwZHmuMwcyfJUN8
         0VRA==
X-Gm-Message-State: AFuF++mRCpfuDManoa+DSP3xd0askcPPiGM1IfOBC5ZpcTZ/5JhhPNvi
	hJKgDhH3S7lEVu6K5w5dv/59rxqlJePrTLwo4jVk88xT5ycLCDHyMb1wpL2g/P2N
X-Gm-Gg: AYBFou3um7a54Q9wgbZefARmzO+EvRKJjQjZZZ9V2U3/hyALMxIyw5yXmvYaYe/CWSh
	4B/ZBRMJ8Z8YMkmABU0IOCcbwgXbcI0g09eTBzp92CLZ6eo2b5B2Dy4QCirJzq9c/5Z3/ZaV5pj
	fqMZT7a/QAOb3gpeY7qTupU7Zfu6lRsyeXKK1ZZKqlU4d4Md2LPBWaoC3zB97Mn6lY+uqyDdheV
	ec/hW+1StHtgxng9kEzjoJPT5hQAVQCgLIqpzJ5FLOG3biOXtmcV/fNaHQNKSSPeXZ5gcFr5f9c
	3tOt+xWKQ/hYol6Yezm6JNSSoBRgK3F2ed2Tbj0skmz3KeEOz+q5bSeL+PsJQq1Nt2lG/qm7ySf
	2lf3ihPmL7c1JQJFrswHlygRCILCdAkOkbQo41dMe2/X2wXGyZpO0uvKl+aEiPR7wSg3D/pqMY8
	K7tMh/sspFDXJB65bG6ccE3/Qrmz4hy8g7wCEzGb5guCAzsM4DFGJSTmsmWT0yOIozrxh1HynQW
	JXnpJz0BaiZAVmWx72BmhGIigNAxDrCBxVuoQODJqrKL0sIx2jdrCF5/bg=
X-Received: by 2002:a05:7300:6810:b0:334:2bee:348e with SMTP id 5a478bee46e88-3427236f2bbmr10837300eec.22.1790618088369;
        Mon, 28 Sep 2026 10:54:48 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-342c9c245a7sm21189418eec.11.2026.09.28.10.54.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 10:54:47 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v5 00/10] lpfc: Update lpfc to revision 15.0.0.1
Date: Mon, 28 Sep 2026 11:17:47 -0700
Message-Id: <20260928181757.21959-1-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 15.0.0.1

This patch set contains bug fixes related to cleanup handling in both
normal and error paths, and refactoring of duplicate code.

The patches were cut against Martin's 7.4/scsi-queue tree.

Nigel Kirkland (10):
  lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
  lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not
    set
  lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted
    cmd
  lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error
  lpfc: Add handling for when PLOGI or PRLI is dropped during link
    failure
  lpfc: Fix ndlp use-after-free during repeated RSCN and rediscovery
    sequence
  lpfc: Rework I/O flush ordering when unloading driver
  lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
  lpfc: Update correct ndlp refcnt when rejecting an unsolicited PLOGI
  lpfc: Update lpfc version to 15.0.0.1

 drivers/scsi/lpfc/lpfc_ct.c        |   2 -
 drivers/scsi/lpfc/lpfc_disc.h      |   5 +-
 drivers/scsi/lpfc/lpfc_els.c       | 109 +++++++++++++-----
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 170 +++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_init.c      |  16 ++-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  30 ++++-
 drivers/scsi/lpfc/lpfc_nvme.c      |   9 ++
 drivers/scsi/lpfc/lpfc_sli.c       |   8 +-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 9 files changed, 242 insertions(+), 109 deletions(-)

-- 
2.38.0

