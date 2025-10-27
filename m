Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC65B1A0BD0
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 17:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761585009; cv=none; b=m6z0vBLtLeoeiHCs25XCXTakD1ZcJisY3cyUsZuJ/zt6ww3uFPzN717h30ruwWyzLDoO3MOsCb6q0tlOEGNM2Qfu/HctC25Lgs3huo8ht8E7mICiQytgEhe3gZK3OSbolKsb3ahc8HKr5caQ89zYRuQzIeg5UeY/prkkysqSzQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761585009; c=relaxed/simple;
	bh=GbhIrkPCzpu5zTAnbPiep6UnifTIJ+tWCJdnbI1rzWk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O/0FJfz9rrhYSf69Ih8I158bpIA8HhuQIPt6cAk+OGohD5CFuP/JFXpBE5uPV1yylLXCpHfAfzC9ta/+NXfT3LDCAW8MB/ptzKQoY36ybgh/7H+KwGNbQesc86/vIUE8jwDgA65ynCXAc6I6hkr7ECloOAPVMZr5/6f41JulhA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3i3Tn3JX; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3i3Tn3JX"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cwKkk53nvzm0yTC;
	Mon, 27 Oct 2025 17:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1761585005; x=1764177006; bh=PtL6UPLG6SFal1cwDSQc3IxIexO6MEE1u+0
	y96JKIqw=; b=3i3Tn3JXP5TqsYBE54T0meMD8VRSglcDGbnLIuf86TCRwLwkcG7
	RvBNRCvarOfpXf6qlyF3YBo8zPYkCzwx5H/NbjwQ01nkO5KodIlnW6UXA47K8w3o
	twt06L41+TGQYc5hpmbf/adZpFWcaaX/lMP8+Gtv4D/m53fW2lbjD9y4G+LC209H
	b0+8K3SRhSLfsiaxH23zIkOqh2oF+/RdGOsPyujmxAoUCEOZKKNDUgDHkYMGWrJN
	pMPNKVEf3S0mfgNpMAa/dHMQltUkWuiMYfiW7z9KlcYBivva1a0O2qnh2oiohG0N
	SVuktyE4tdo3p6soNmXXRUcwvI69rzL2ByA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7rrPBbU1Zi6x; Mon, 27 Oct 2025 17:10:05 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cwKkg31txzm0yVL;
	Mon, 27 Oct 2025 17:10:02 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Two additional UFS fixes for this rc cycle
Date: Mon, 27 Oct 2025 10:09:28 -0700
Message-ID: <20251027170950.2919594-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.838.g19442a804e-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

Commit c74dc8ab47c1 ("scsi: ufs: core: Fix a race condition related to th=
e
"hid" attribute group") is an incomplete fix for the race condition menti=
oned
in the description of that commit. These two patches fix the remaining ra=
ce
condition. Please consider these two patches for the current development =
cycle.

Thank you,

Bart.

Bart Van Assche (2):
  ufs: core: Change the ufs_sysfs_{add,remove}_nodes() argument type
  ufs: core: Really fix the code for updating the "hid" attribute group

 drivers/ufs/core/ufs-sysfs.c | 14 ++++++++++----
 drivers/ufs/core/ufs-sysfs.h |  5 +++--
 drivers/ufs/core/ufshcd.c    |  7 ++++---
 include/ufs/ufshcd.h         |  3 +++
 4 files changed, 20 insertions(+), 9 deletions(-)

