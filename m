Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE8E2E1730
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2025 21:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765919259; cv=none; b=Gg3Wq1YNgXh2elyz5O7qSgaNWyREjm9mcdo4a/YU+eGsExWlwBY5FP2pWe8x2Q5nS4z4tJWP0Tvn3nsU13t2kpQtton9uVJz7ZsXXWRvJeR3lv3CFEwqB/f0zd1J+AeItkwD0JiMebWJYWEmMriLqSCJreCi4ke3HnUWPwGa2O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765919259; c=relaxed/simple;
	bh=Y+ea0L7iBXJrzAdWEpwLVurK6WD6XH8/+E+4l3oSK6E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=frSyk5wD3bcmfsI71MCgXm0uDSaEbmH3nn1Iqd9dTL6+xEemmVkOAV7/UADsAKMt1v0eYSl3L9I7+oZmV1f5ErQxVsqUy+9uTvqWzmnWObN3JuP+4GR1MrRf+L0y5kOs9FLzeTcppFBMlaLzH6gIv8W1X45sjcHBpAJzuVD/Dik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Toq+vW4j; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Toq+vW4j"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dW8dh6LKjzmP4tk;
	Tue, 16 Dec 2025 21:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1765919255; x=1768511256; bh=ZjWDtfNw/RRrRb8dEH+umcTGod1RNoB4DZ7
	zBcIlb9I=; b=Toq+vW4jAVNabnEMpGAhrVi5irG6+0c6VFGNZ0uzF+zfAD7cTE3
	ew+NhdH9XNTeekLvg4wZvoIn3A8/sCDNUV7O8+sl8S3y3Y6aOrpcKlcUwcdc1X8w
	UdeGhRNi2bXLBa51BMMuDvL+mRxJ90ov9aIxe0TC3zZrZWr7XO22wcZAMsQtp6zT
	ANi/Nt+O7BSzOe6VlZ18Ah7bW/Gfy/CytRJcPb6KQ8alFgBj4b4MS93KTpuUi+2I
	tzGRIv+psmvsFtnyNllhnseAXGUkyftY5YvAE/y8fbyiYg5fQpfLMjzxy/fakFtW
	n0fDNLVG57HG5nLgbM+pq8IDXeMFA2Cmyow==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LSCdLI7BlLgG; Tue, 16 Dec 2025 21:07:35 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dW8dg2mNxzmNLLr;
	Tue, 16 Dec 2025 21:07:35 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/5] Clean up the SCSI disk driver source code
Date: Tue, 16 Dec 2025 13:07:12 -0800
Message-ID: <20251216210719.57256-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.305.g3fc767764a-goog
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

Changes compared to v3:
 - Rebased the patch series. See also
   https://lore.kernel.org/linux-scsi/20251121182112.3485615-1-bvanassche=
@acm.org/.

Changes compared to v2:
 - Rebased the patch series and dropped a patches that is no longer neede=
d.
   See also
   https://lore.kernel.org/linux-scsi/20240805234250.271828-1-bvanassche@=
acm.org/.

Changes compared to v1:
 - reduced function argument indentation (whitespace only change). See al=
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

