Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8A314A0AD
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 23:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722900036; cv=none; b=LytDwfakciRzN4u0qWid8Y0jDpEcFlZzhkqFxTJZwlND4uPXlu+IG5Fjfv+PG9MNVrQDpXR+3LTjzTUEsIEzGDuTYXA09Fv/oo0LPftYvkni3DEA5qnRBxpNPdKQKkyKrjIS6QLeJyTCIW/pPKBZj2VMW6cEHgttLgi4Nmg+Z40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722900036; c=relaxed/simple;
	bh=UByh5aL71WrfjnPQs6YVUeTBkJ9Ckl2j41inYS620yw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r4xP4Oz7BX2yoxXVtFUm6PQrbAmoLwOxZhlzkbb4efjepWBBERwzZKDlQFbPeS1zMRRTeMxNoaH8qohdmuWUcPRt2A9GXMk73N6q/n5asJ5TcpsQuh43sipTcslOKEMHFXEi84exLTVhwsOTdXD0awMVBXj8jeLS+oRSU0ncG2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DApHkycy; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DApHkycy"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WdC8y03qkz6ClY9D;
	Mon,  5 Aug 2024 23:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1722900032; x=1725492033; bh=cixey3qoyT8k/PA0UcYPJgUvm/IKIRXOJxS
	dRJnxun0=; b=DApHkycyt7FHgwuUL4UX0FwcUkOAr4wcAeLCfwJ8uH5Sq8SFxDM
	PI9tImI02CsklxrMDYS6e+d20ErmZscvKO9Va4qZN1b8mR4y+xxwjLHgXlwm84uw
	+cRc4gcb4DODyBhgY2l2SpxASqr1r+d/UBn3BHo3AJDZoMrjioAoelsdrXpKSsWn
	g3ZNAuoyA2HP5+Yrg+6ZgZ13O4MrOhiXc86hxpLBzzQLJ/uRC3wCMPyzxJL1zDJt
	wAaAdtlkkLM52boR0ZuAxR3+HF2l8TOqKTehxxtiuePZBIOawfriHYAjvTCdKn84
	tHCXhSMkDK24RAmMCtbQDugMhtkyDzUyuSA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id P9dhrht1rbyi; Mon,  5 Aug 2024 23:20:32 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WdC8w2LJbz6ClY99;
	Mon,  5 Aug 2024 23:20:32 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Fix recently introduced build failures
Date: Mon,  5 Aug 2024 16:20:19 -0700
Message-ID: <20240805232026.65087-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

During the merge window a patch was merged that changed the type of an
argument of bus_type.match. That patch converts most but not all SCSI
code. Hence this patch series that converts the remaining SCSI drivers.
Please consider this patch series for the v6.11 kernel.

Thanks,

Bart.

Bart Van Assche (2):
  ARM: riscpc: ecard: Fix the build
  mips: sgi-ip22: Fix the build

 arch/arm/mach-rpc/ecard.c     | 2 +-
 arch/mips/sgi-ip22/ip22-gio.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

