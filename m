Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A191C578E;
	Sun, 15 Sep 2024 12:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726405010; cv=none; b=EBpCbyo7B9942V6zfONNDLAPoxsGyBCqqc7HlngN3lH92Oj20rkMxfAdQ/qj/ik23iXKbMOQSQujaimnAHhUwBohcezU+3fdmshwR7zOfQrgEa0mCtK2Yej+b8n9LcYD+op3e6CVXrHpvkDxlC3eBKknK/Qg4rylGxEQT2PJS0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726405010; c=relaxed/simple;
	bh=l2W860h9XJMVBRnRiaVwUmTtuf2GuQeSfDo+3U7iwTw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=idvSs/sNYdDkO2GO9/kFPeVWxjlWwvsCBD3wy76EbMHrngfjPyaB2fM1XRkxGeXbkRayL/xY59wdnRXmkm7iUiiCwsZzjj8AMsu0FVbJ2D5bEhli0UBpRqVwL2SHLIBvA0PNuXWLpdVtdXIdLzLeQwx1ncOx7mTe53UrRUkpsi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=sBb2v41N; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="sBb2v41N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=+N+Zt3XGYAMPFCZBNNwBCyER2yBCeTEw6QFLxiqdk1s=; b=sBb2v41NrDurcoZa
	qgu9w/3WNzAlMrloGq9WkrJBi1h1Q7Cd9aRjSzsKY+zorf0tPBj6Y14aoVghefduWhrV7n+BNfsyx
	Esn7bA2QvXe9EB9j6S5HvPjJ1gccgOZxDq2s+R1XfMj4PoUS4TQqTs2TyBYUH/3xdh0zJ6Yv6oueF
	t6VDjz1Dx/lw41gXf/oatze3Tw1wb77FBcK7Yv0H7kcRiSAZpQVxJs+oruRPjAjQNnDNOkcKanrKL
	6UaXiBlXN0hcJ1yQNpKTmXDUZIMsgYU/PkmquSIOILwJMjT3HuoVFCiGVS1uEMOhcXONwSJh99RTF
	D8m4WE1vR/5MLLdCgQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1sponv-005pGt-37;
	Sun, 15 Sep 2024 12:56:39 +0000
From: linux@treblig.org
To: anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 0/5] scsi: bfa: Remove deadcode
Date: Sun, 15 Sep 2024 13:56:28 +0100
Message-ID: <20240915125633.25036-1-linux@treblig.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

Hi,
  This removes a pile of dead functions in the SCSI bfa driver.
These were spotted by hunting for unused symbols in a unmodular
kernel build, and then double checking by grepping for the function
name.

  It's been build tested only, I don't have the hardware, but
it's strictly full function (and the occasional struct) deletion,
so there should be no change in functionality.

  Thanks to David Hildenbrand for the suggestion of hunting
for unused symbols.

Dave

Dr. David Alan Gilbert (5):
  scsi: bfa: Remove unused bfa_core code
  scsi: bfa: Remove unused bfa_svc code
  scsi: bfa: Remove unused bfa_ioc code
  scsi: bfa: Remove unused bfa_fcs code
  scsi: bfa: Remove unused misc code

 drivers/scsi/bfa/bfa.h           |  10 ---
 drivers/scsi/bfa/bfa_core.c      |  35 --------
 drivers/scsi/bfa/bfa_defs_fcs.h  |  22 -----
 drivers/scsi/bfa/bfa_fcpim.c     |   9 --
 drivers/scsi/bfa/bfa_fcpim.h     |   1 -
 drivers/scsi/bfa/bfa_fcs.h       |  12 ---
 drivers/scsi/bfa/bfa_fcs_lport.c | 142 -------------------------------
 drivers/scsi/bfa/bfa_fcs_rport.c |  36 --------
 drivers/scsi/bfa/bfa_ioc.c       |  21 -----
 drivers/scsi/bfa/bfa_ioc.h       |   2 -
 drivers/scsi/bfa/bfa_modules.h   |   1 -
 drivers/scsi/bfa/bfa_svc.c       |  72 ----------------
 drivers/scsi/bfa/bfa_svc.h       |   5 --
 drivers/scsi/bfa/bfad.c          |  20 -----
 drivers/scsi/bfa/bfad_drv.h      |   1 -
 15 files changed, 389 deletions(-)

-- 
2.46.0

