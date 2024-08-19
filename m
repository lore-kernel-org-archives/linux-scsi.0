Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEF01591FC
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 22:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107884; cv=none; b=UPuK+kv9p300R05SVjgDn7gjwtfBAwx84xbFwUhfIPdQARXDxPHcxsrxnxAEzXoICGHO5jKCfEoByTdcusR370addxpVD7VZUBtZUBYfj7qg0cJTDDuvLWRq/DOZsKyOE62idH2GxbB2n2k3IbcqPh4mFxmqwkq0OaRecBCMaf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107884; c=relaxed/simple;
	bh=aWYd1+VGy7N0bP5iBQsxxfn+iRp9Yr0/fVSNZtsCWZA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZfYbiom0kafItiTOHAII4oJ4hEEHLyyDVQnQKKPkbOHQhnvo02GOdAaD9aPiawu3SkyfaykyXtBPIYu4X3b2uPWSmEvHR0BNby8LLwpSt8YHSZcr/nzgEKpag/6zQ6FueWMZ2oZyw3oq83JfldosZadLBUKwTwhX4tc6unuMipc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pX3lCQtg; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pX3lCQtg"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wnnrn6pqlz6ClY8q;
	Mon, 19 Aug 2024 22:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1724107880; x=1726699881; bh=OzwpMT051pNFi8LbU0Uq006x94CwKMeQdB9
	z9pHCzOw=; b=pX3lCQtgPiB1zRyrDUYsEgZSegw0QdFk4YloUtYvJ2akrBn5Nan
	GDlVwosjIYumTBuFOXVWWP24wqKLx17RsGacQhCRR8mKBlAqJ5nc5iU8El+YfyoA
	aBhkFrZP59ikjroTavwF6HDK7/fdTvdYvRs7Gq/lD6AUGIY5Bdojzhv7p5C4L1V0
	W0zfBrRY6iH8dyij5J9WH+8u3CdAi3sKLKKFIeXhqr2d1SRXw7KqydjAJcHz9UDV
	QfJb50d8CkebW8v0DSRktpkERjA5g1K3jlpEkPmihj1gNrRirfQ+cLhZRA72SZMK
	6xjx2znEExwll1geAdZ54xvj/YvWdeGCkSA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pSEsUi9XpCUI; Mon, 19 Aug 2024 22:51:20 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wnnrm11Zqz6ClbJ9;
	Mon, 19 Aug 2024 22:51:20 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/9] Simplify the UFS driver initialization code
Date: Mon, 19 Aug 2024 15:50:17 -0700
Message-ID: <20240819225102.2437307-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series addresses the following issues in the UFS driver
initialization code:
* The legacy and MCQ scsi_add_host() calls occur in different functions. =
This
  patch series moves both calls into the same function.
* Two functions have a boolean 'init_dev_params' argument. This patch ser=
ies
  removes that argument from both functions by splitting functions and by
  pushing some function calls from caller into callee.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Bart Van Assche (9):
  ufs: core: Introduce ufshcd_add_scsi_host()
  ufs: core: Introduce ufshcd_activate_link()
  ufs: core: Introduce ufshcd_post_device_init()
  ufs: core: Call ufshcd_add_scsi_host() later
  ufs: core: Move the ufshcd_device_init() call
  ufs: core: Move the ufshcd_device_init(hba, true) call
  ufs: core: Expand the ufshcd_device_init(hba, true) call
  ufs: core: Move the MCQ scsi_add_host() call
  ufs: core: Remove the second argument of ufshcd_device_init()

 drivers/ufs/core/ufshcd.c | 241 ++++++++++++++++++++++----------------
 1 file changed, 139 insertions(+), 102 deletions(-)

