Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA4338B
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2024 21:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722373288; cv=none; b=e/3XV6L8owcqh4n5HZ2cONMD1O1uwO51HZi4fGxFRze77RHh9lh+z1/SEsazqaWWxoBL3ZgK4MM+CeQeibHfkp0ZWV08tj3Ufvb02j+NLLNY/rIwjWGltjAkXcqnblmW6+QF/YSPiqNAiEKHJ0vH7CaAtMGJ4YalIoXevhNw6lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722373288; c=relaxed/simple;
	bh=Jsrij01xQIq4cy8Y9h/sp8k6EUB8pm59HSDNg4pxKxE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UYyO25pK4yn3tW4CST2MIwLSMUhd8vKqBhXGTSgfEr+xkjCgDV6fvAbnPhx7Gzufi6wU4A1vqI5fFsslNoRLO59V8PbGvaD2gMOcSKk4NNGKjdZxScBJP/K8ztaATSGqesoIZJBRfyGo5pFUjrK5K1HdG8kjPTKzwpqw/fU4bNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ru+dIOgG; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ru+dIOgG"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WYSM45686z6CmM6Q;
	Tue, 30 Jul 2024 21:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1722373278; x=1724965279; bh=+nWFw3bkB6v8WZxDZrtYY79DGyS919TRgzi
	vdoncBck=; b=ru+dIOgGpyNuYcm4F78AcaoA+S+WHeqjffF+FYukLEHPGAkAzhL
	HSnKGmcoLcvQd8eYuslxUDoociTgk1UXicrkCG+XrT0tZsgXezYt1OlPXrsN/AKT
	reBi8cTYOzKvXSYMzqciujwhuYTr3o2uGkfIMNl++o+4v3BoD6Tlvum849TkxPlh
	+RzAzW3l390zkEzxRSxzPHtSMEhhN5htzxMKm0PZFKEv9K4KL6/uW8KIvPlmEdas
	xT541xk6D50Nqy8fgfsfCBu8JygwMKCVhnba1Ree+tjHbtdR8pW9uAp3mezLRUzE
	gFyXEfnfRl57YgZ8xUPBf9mHtax+huJzfQQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dBUFSIx8d3gI; Tue, 30 Jul 2024 21:01:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WYSM152Zlz6CmQwN;
	Tue, 30 Jul 2024 21:01:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/6] SCSI disk source code cleanup
Date: Tue, 30 Jul 2024 14:00:35 -0700
Message-ID: <20240730210042.266504-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
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

Bart Van Assche (6):
  scsi: sd: Move the sd_remove() function definition
  scsi: sd: Move the sd_config_discard() function definition
  scsi: sd: Move the sd_config_write_same() function definition
  scsi: sd: Move the scsi_disk_release() function definition
  scsi: sd: Move the sd_fops definition
  scsi: sd: Do not split error messages

 drivers/scsi/sd.c | 411 ++++++++++++++++++++++------------------------
 1 file changed, 198 insertions(+), 213 deletions(-)

