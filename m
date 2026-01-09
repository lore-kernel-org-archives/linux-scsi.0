Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D11A274B42
	for <linux-scsi@vger.kernel.org>; Fri,  9 Jan 2026 20:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767991878; cv=none; b=eiJsi1a6L413d9XlBmBQHiMNNhCfnQgpW0aegRjPSV3IA3Rmvq+aFiHhHrnuOcdO4YoynKSV31kIeQ5YmOhoFADuvhlD4QlkhmncAJhZAbJlXWsFsAbHDNVY+9RKOvPxFw0TXnKnP1R39XEPfnl+NozAkRziDpl8a1aSAjEErfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767991878; c=relaxed/simple;
	bh=6LuyG2+koJFhkpQ47QLlyBAxkfBIRm2E607wPpwlXMA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ecrzpRl/80H7mvXcVCMOeYpKfJrMm+Zwnj0TfsiNXxVRtEMkY5ePAcytsLJIZNCP8ngIfckxvZ7owzIFvxpq0q1CsdDRkOll/DZ/KR9GaYXjhwql/7QKvHm1AxORecFokBxMP3LdaPc4fLQUX+43tFSUGgPZn3JdwCjqrkeeDsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3j35XH7y; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3j35XH7y"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dnv7n1BtnzmLCvk;
	Fri,  9 Jan 2026 20:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1767991876; x=1770583877; bh=rVBY6hUWPQfejOHjM1WZ/4PeFKVJx9CQ/vq
	X7cAHdjE=; b=3j35XH7yqiiki7EhRniQyCzW+hC1zr5zApYyW1AGTqdm9iDgGDQ
	6MJyl9FqTzTM9Ono8XCSMfCQNJi7/Jm7lK/T/7c7+i3VmPforWoH1vgt6sasCXt9
	WoedAmS3hPdqKCu5X5jsfbPIMx6FGoCEnuUJP0JwvLMjlvSCfyC/0VI2vXr+9drA
	LWpca+GysIEZGKl4dcoNP31qjKARIIr6lECFCojyLuPd9iJC8JnOQJzVmb3aK++7
	c2z1R1xSczMv5dK3DpGZN7Su5EKaB24iU+hSwJqj9VBr9aMeQ93Eauh45SqHDoUB
	Ztqb4EVXZaSimeO1S8mP1sf+qRv1dLqE8RA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8oqbTQBHe85f; Fri,  9 Jan 2026 20:51:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dnv7l1MklzmP6YN;
	Fri,  9 Jan 2026 20:51:14 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/2] Call scsi_host_busy() after the SCSI host has been added
Date: Fri,  9 Jan 2026 12:51:00 -0800
Message-ID: <20260109205104.496478-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

The UFS driver is the only SCSI driver I know of that may call
scsi_host_busy() before the SCSI host has been added. This patch series
modifies the UFS driver such that scsi_host_busy() is only called after t=
he
SCSI host has been added. Additionally, commit a0b7780602b1 ("scsi: core:
Fix a regression triggered by scsi_host_busy()") is reverted because all
scsi_host_busy() calls now happen after the corresponding SCSI host has
been added.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v1:
 - Removed the WARN_ON_ONCE(!shost->tag_set.ops); statement from patch 2/=
2.

Bart Van Assche (2):
  ufs: core: Only call scsi_host_busy() after the SCSI host has been
    added
  scsi: core: Revert "Fix a regression triggered by scsi_host_busy()"

 drivers/scsi/hosts.c      | 5 ++---
 drivers/ufs/core/ufshcd.c | 6 ++++--
 2 files changed, 6 insertions(+), 5 deletions(-)

