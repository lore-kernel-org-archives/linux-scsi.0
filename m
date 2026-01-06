Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3AC27586C
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 19:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767726486; cv=none; b=jT2SVXObm+dsVyoqYoBas4dnLi+VAmCDuKFW3LKrXUM0hQqoyK2nQJixAlaWwyccPJAVjWfHffNSGIs9SFlVTMDrhclb3Bp7JML3skKu9WvbSpUJrlXc7OZzh3Bzd6gAeGBAREpmnRPRTnt4N2ioi/cMOoUZc1pDP8biifkFxOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767726486; c=relaxed/simple;
	bh=uGKmeVoI4abqACt9miOolp1pe/bNCdmv8XgxJtXJ8YM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tok0E9r6TqqtbE3bk9YLbkXC3/Vo1ecJo+lSjgAIpe1rI2M1N5PK5A33hDYzhF1FR1013I5o3O7da8j4Jd8YWCJGoGaVhFjBFKBr7x50Q39ryy66K/k0OO3XyLX3klUyD6ReR2JdPo8SuoFAo51SPo2zKdKA+ucDLxWZbPevwec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WRhpmu/a; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WRhpmu/a"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dm10341vPz1XSkny;
	Tue,  6 Jan 2026 19:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1767726482; x=1770318483; bh=CJXIohjvb+L8BMFAzgAV0KtF4AGGqoSXvpk
	4/MzKKpA=; b=WRhpmu/aDfUId5g7x3NGCnNUDrD6/l4TWpqmjZ6HwesndObIcEq
	vuUYxxW/ihRCsqW1FystJ24+kdTxHxRSVEm52E7s6LnN8HxcUPTUemwz2eDqoaDO
	2IAGWf9NKcYHfDq0qQvzwhki4wq41kvYq82juzBB/Dpz4RRH+EdMfRMHSsfr9f9R
	Uzq7CdDeBAOJu6mZWXzL8A+9qcxuBGLW0+YacGgXBTIX6B7xLkwKmsh4vivR7Rsk
	RqeFztxubHhKa/uwg68Im54I0SxEB7NkZxzl2mC+95FxyyaKOk+QWVWOnt/03VfM
	IYJmZvgvHTan2ePkjgxXZMhGnVfrwV6O0dQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7f1n4GIxcftI; Tue,  6 Jan 2026 19:08:02 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dm1016ByXz1XM6Jk;
	Tue,  6 Jan 2026 19:08:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 0/5] Clean up the SCSI disk driver source code
Date: Tue,  6 Jan 2026 12:07:43 -0700
Message-ID: <20260106190749.2549070-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series removes multiple forward declarations from the SCSI dis=
k (sd)
driver and also makes error messages easier to find with grep. Please con=
sider
this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v4:
 - Added Johannes' Reviewed-by tag.

Changes compared to v3:
 - Rebased the patch series. See also
   https://lore.kernel.org/linux-scsi/20251121182112.3485615-1-bvanassche=
@acm.org/.

Changes compared to v2:
 - Rebased the patch series and dropped a patch that is no longer needed.
   See also
   https://lore.kernel.org/linux-scsi/20240805234250.271828-1-bvanassche@=
acm.org/.

Changes compared to v1:
 - Reduced function argument indentation (whitespace only change). See al=
so
   https://lore.kernel.org/linux-scsi/20240730210042.266504-1-bvanassche@=
acm.org/.

Bart Van Assche (5):
  scsi: sd: Move the sd_remove() function definition
  scsi: sd: Move the sd_config_discard() function definition
  scsi: sd: Move the scsi_disk_release() function definition
  scsi: sd: Move the sd_fops definition
  scsi: sd: Do not split error messages

 drivers/scsi/sd.c | 275 ++++++++++++++++++++++------------------------
 1 file changed, 131 insertions(+), 144 deletions(-)

