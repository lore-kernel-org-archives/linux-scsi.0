Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC54530DED
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 23:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790119620; cv=none; b=ujsq3iH3SFPAoQdz+5ITR8q7j5vyh7aKFbZDR6H0F67g+nzkqt8gktj4zIW6gBXPCr0unuhh4PRzRFzwBZFMJj9yfqC20himlLjzRcN4QrBNIv/m8whkVq+63yHBCuHAo2IbKT7QSFyPLOfMIBbRjMGzWObHsupu/x3qTIAH9uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790119620; c=relaxed/simple;
	bh=CGJ9t6x69SRK0zt1RJgHfvEakHIvDfo1reqrsTFyG8c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dzQmx+uZvaaRx9AyRbWUPJu71mhtUi6qXNLVDJgMh5QLMKD7X0tPJODk0DGDKmpQT3ZSre82SC5MkF+OQxq31VfygP680YpUT5lSv5cUKr1Qd5VkZwHMuqj/XJNWDMlRTEoll1XD2xCbPGnBxIu3P89qFoJ/Kiq40obS+HaVuCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3QeeYVeS; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3QeeYVeS"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hqGSz4W28zlfvpT;
	Tue, 22 Sep 2026 23:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1790119600; x=1792711601; bh=TCr3vGf76hwBcozUK2f4q1z2qfNQpR/UYfF
	rjX0r55E=; b=3QeeYVeS8QX787c9NKxodau+TSVCn4pYxcb3smqfx3TERTvEtJD
	aaoRJiS7SCdlt6A8l8lF5DEGXLqizfEwAdcEjtSECXg/g4u7IaY0JFOR8Pj6oYCD
	R6SoMgEDtktzfSMRjf9AbC0dpzjrwQfvk89+sGcmVK2NK/5kS7E19P0fZQYV1crc
	A4HvlMl+tPAag5vyazTC/q0g1B0uG58wGCPiut9dChtb2lSyDcsvTV/wdGWziEMl
	KFxOLDdxJSOkgLZTfnPC6O+EoOGuODX8pWpzIkmF3JVX1IpB3oc2yzlWQ3VtZRpG
	QSzqx5NED73MyrOgDlscuWa910rVRJIqZmg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bpyrDU6jcpxn; Tue, 22 Sep 2026 23:26:40 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hqGSv252KzlfvpG;
	Tue, 22 Sep 2026 23:26:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/7] scsi_debug: Enable lock context analysis
Date: Tue, 22 Sep 2026 16:26:20 -0700
Message-ID: <cover.1790119506.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series fixes a locking bug in the scsi_debug driver and enable=
s
lock context analysis. Please consider this patch series for the next mer=
ge
window.

Thanks,

Bart.

Bart Van Assche (7):
  scsi: scsi_debug: Fix a locking bug in resp_write_same()
  scsi: scsi_debug: Split resp_write_same()
  scsi: scsi_debug: Split corrupt_lbas()
  scsi: scsi_debug: Split resp_read_dt0()
  scsi: scsi_debug: Split resp_write_dt0()
  scsi: scsi_debug: Improve lock context annotations
  scsi: core: Enable lock context analysis for the scsi_debug driver

 drivers/scsi/Makefile     |   1 +
 drivers/scsi/scsi_debug.c | 355 +++++++++++++++++++++-----------------
 2 files changed, 197 insertions(+), 159 deletions(-)

