Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CA14C8F
	for <linux-scsi@vger.kernel.org>; Fri,  6 Jun 2025 05:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749187768; cv=none; b=CpfK6QXRukSyuB1CHPd+zndLSw3l4fxt2Kgbd2WtXj7qL/tF3Ajjs4qOWSEwFuYUSIKyi4+eLi6xTtbdAvmtQoZwGOEW9qPeqQiZs/Gg761B5MhwOc/gC6tHdl7RpErj5XRvw2VgflzTtbem4MAMGzpq6f8T+2NKFxhR3twEnWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749187768; c=relaxed/simple;
	bh=ahZVWduvO0S1X4c3EufWkOPy9spboJ5dEzl7Xd9hD+g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JO72ruvITpoPxDLxj4Cxa5MYpy7A9VYM1GBoWTE6maVbdJJ4EmosxpchAe3//b1KhX5F00uWdsX/0804E8ZXN2q2ElKMy9PSj6Z0gz1T/FQnGkwa2Y3SkGUbsT5lREOqNB9Ups5+8roe7g3F6kFr2CzgQyVSmYzR1yvM0Hioo8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QV+K4EVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QV+K4EVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBE5C4CEEB;
	Fri,  6 Jun 2025 05:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749187767;
	bh=ahZVWduvO0S1X4c3EufWkOPy9spboJ5dEzl7Xd9hD+g=;
	h=From:To:Cc:Subject:Date:From;
	b=QV+K4EVKM+2JdcR9YrZyK3tz69tGifkhaPQa0VXgcVmJ4bfgul9qn2kPFPUoKKx2e
	 pHyYrAJMC+6cg1riGBmBBovy6naRogJxDMlsSb3OSw1MXvG6mPLNavKE6fKbpjUsLa
	 DkGN21vS+9msQsXfrWNbDksyVWmzI/7s6ax5c0qUpfsPoDUkN9sxXWY864suILSJjP
	 9aAty72PNvHpgvYHEE5aRtEewXa1HtaVA8nuOirrEV9FmRewMRA21DTB1qDGU4/UQj
	 NP4VKaN4jsmo98UU9DuSS91vBmfrZ+qiQ6PuyNpmSJSz4P0YEjfMb02FTKMaoq3eSo
	 o65QT+XNo84Wg==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH 0/2] Improve ATA NCQ command error in mpt3sas and mpi3mr
Date: Fri,  6 Jun 2025 14:27:45 +0900
Message-ID: <20250606052747.742998-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Martin,

Two similar patches for the mpt3sas and mpi3mr drivers to improve the
handling of NCQ command terminated due to an NCQ command failure. These
so-called collateral aborts must be retried immediately but that must be
done without incrementing the command retry counter. Otherwise, these
collateral abort commands may endup being failed due to other NCQ
command errors.

This issue is especially easy to trigger with the mpi3mr driver with a
drive subject to a mixed workload of commands with a short CDL limit and
commands without limits. The failures due to the limit being exceeded,
which are normal, endup also failing commands without a limit, which is
incorrect.

Broadcom people,

I am working in the dark here, with zero information on how your HBA
handle ATA NCQ collateral aborts. I am patching against what I am
seeing, which may be only a partial picture of the problem. So please
check this !

Damien Le Moal (2):
  scsi: mpi3mr: Correctly handle ATA device errors
  scsi: mpt3sas: Correctly handle ATA device errors

 drivers/scsi/mpi3mr/mpi3mr_os.c      | 20 +++++++++++++++++++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 19 +++++++++++++++++++
 2 files changed, 38 insertions(+), 1 deletion(-)

-- 
2.49.0

