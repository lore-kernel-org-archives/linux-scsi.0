Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C7E36D501
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 18:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763749289; cv=none; b=absieQE+KnmnqTjKjLSKjOR2WYKw1ASLlg1mAvXhN6ZwuWhHt8S4YIxUvaRSJ3VUjgvXlRDj4wHJXo+7LZsdE2US1urt64jTx2sfL+xOUQisUIPtO7gVhVK0v5uc6c0roujTkeH6vuFh0FVjm5ZDT3PaL1iEICl/4NyDlj0MckY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763749289; c=relaxed/simple;
	bh=C7hLyfZEWDatqEpShhIhqeyyyIGmcTmHxxIDLePTy74=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RO4NGTK+qFPHsFukbxpHM6VPXLSMmiG6qad+RPd/O86KQBl1xU6WStexG+u9aM7rBzq5qmnRlBsM73XF5FXdEV9RPg8++NmN/wPuropMi5RkY+OyTIzmHQNlbaT8eowuKq/jutg+96sGtyM95ouLf4Lik9zsUuundYiHJfCtXjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cPQHEnqs; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cPQHEnqs"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4dCk7V6HbZzlvPwV;
	Fri, 21 Nov 2025 18:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1763749284; x=1766341285; bh=wxdVmxokJit1MVIc25UtPrJWzPDByhyckpN
	pkBRV2Rw=; b=cPQHEnqsnPST4jKIwbWx5rLxzhLD/YEl3TMqijdXRacxBm/gt0j
	Uweigs/3wRxRLF88vI6kUNpgdRxbSSh73PJJatxtlCS9y7GSMPKAM//dVVf0c3Ge
	P/1tmO/ASlrqkLssvtkZssTK9DzGt4PYMTX9sYbKWyAh4RI3QSekFfquzVZ5D0Eg
	3F2luf84nC8Mb0tjetpgJ7KwxzSg+wuLvIOjPPPxBickifu4IQaktboL48r6DLDE
	smldOAmXLa4/G15DYfpDn6C4N1PgvPB3OEutLHnbnkRij/sqLDS9LfF31MpTa7Y8
	AsmakhgTt+Mbz8eb0frnS390njBETJFo4BQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1UbGNAGmhOQM; Fri, 21 Nov 2025 18:21:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4dCk7R2dh6zlvDS4;
	Fri, 21 Nov 2025 18:21:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/5] SCSI disk source code cleanup
Date: Fri, 21 Nov 2025 10:21:05 -0800
Message-ID: <20251121182112.3485615-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
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

Changes compared to v2:
 - rebased the patch series and dropped a patches that is no longer neede=
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

